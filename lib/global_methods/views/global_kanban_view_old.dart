import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import 'package:mobo_crm/screens/opportunity/providers/opportunity_data_provider.dart';
import 'package:provider/provider.dart';

import '../../core/company/session/company_session_manager.dart';
import '../../utils/snackbar.dart';
import '../const.dart';
import '../dialog boxes/lead_creation_dialog.dart';
import '../widgets/shimmer/custom_shimmer.dart';

/// A generic, horizontal-scrolling Kanban board with support for drag-and-drop
/// of items between columns (stages/categories).
///
/// Two main modes:
///   1. **Opportunities** (`label == "opportunities"`):
///      - Columns are dynamic CRM stages fetched from Odoo
///      - Supports adding/editing/deleting stages
///      - Drag-drop moves opportunities between stages (optimistic + rollback)
///      - Per-column vertical scrolling + auto-scroll on drag
///      - "Add Card" button at bottom of each column
///   2. **Other entities** (leads, quotations, forecast, etc.):
///      - Static columns based on `getCategory` function
///      - No stage management UI
///
/// Features common to both:
///   - Horizontal auto-scroll when dragging near edges
///   - Per-column vertical auto-scroll when dragging near top/bottom
///   - Loading shimmer during stage fetch
///   - Error handling for stage fetch failures
class KanbanBoard<T> extends StatefulWidget {
  final List<T> data;
  final String label;
  final String Function(T) getCategory;
  final Widget Function(T) itemBuilder;

  const KanbanBoard({
    super.key,
    required this.data,
    required this.label,
    required this.getCategory,
    required this.itemBuilder,
  });

  @override
  State<KanbanBoard<T>> createState() => _KanbanBoardState<T>();
}

class _KanbanBoardState<T> extends State<KanbanBoard<T>> {
  /// Cached future for CRM stages (only used when `label == "opportunities"`)
  static Future<List<Map<String, dynamic>>>? _cachedStagesFuture;

  bool isLoading = true;
  final Map<String, ScrollController> _scrollControllers = {};
  final ScrollController _horizontalScrollController = ScrollController();
  DateTime? _lastHorizontalScrollTime;

  @override
  void initState() {
    super.initState();
    if (widget.label == "opportunities") {
      _cachedStagesFuture = _fetchCrmStages();
    }
  }

  @override
  void dispose() {
    for (var controller in _scrollControllers.values) {
      controller.dispose();
    }
    _horizontalScrollController.dispose();
    super.dispose();
  }

  /// Returns (or creates) the vertical `ScrollController` for a specific column
  ScrollController _getScrollController(String stageKey) {
    if (!_scrollControllers.containsKey(stageKey)) {
      _scrollControllers[stageKey] = ScrollController();
    }
    return _scrollControllers[stageKey]!;
  }

  /// Handles vertical auto-scroll within a column when dragging near top/bottom
  void _handleAutoScroll(String stageKey, double localY, double columnHeight) {
    final controller = _getScrollController(stageKey);
    const scrollZone = 80.0;
    const scrollSpeed = 20.0;

    if (!controller.hasClients) return;

    if (localY < scrollZone && controller.offset > 0) {
      final newOffset = (controller.offset - scrollSpeed)
          .clamp(0.0, controller.position.maxScrollExtent);
      controller.jumpTo(newOffset);
    } else if (localY > columnHeight - scrollZone &&
        controller.offset < controller.position.maxScrollExtent) {
      final newOffset = (controller.offset + scrollSpeed)
          .clamp(0.0, controller.position.maxScrollExtent);
      controller.jumpTo(newOffset);
    }
  }

  /// Handles horizontal auto-scroll of the entire board when dragging near screen edges
  void _handleHorizontalAutoScroll(double globalX) {
    if (!_horizontalScrollController.hasClients) return;

    final now = DateTime.now();
    if (_lastHorizontalScrollTime != null &&
        now.difference(_lastHorizontalScrollTime!).inMilliseconds < 150) {
      return;
    }
    _lastHorizontalScrollTime = now;

    final screenWidth = MediaQuery.of(context).size.width;
    const scrollZone = 100.0;
    const scrollSpeed = 12.0;

    final currentOffset = _horizontalScrollController.offset;
    final maxScrollExtent =
        _horizontalScrollController.position.maxScrollExtent;

    if (maxScrollExtent <= 0) return;

    if (globalX < scrollZone && currentOffset > 0) {
      final newOffset =
          (currentOffset - scrollSpeed).clamp(0.0, maxScrollExtent);
      _horizontalScrollController.animateTo(
        newOffset,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
      );
    } else if (globalX > screenWidth - scrollZone &&
        currentOffset < maxScrollExtent) {
      final newOffset =
          (currentOffset + scrollSpeed).clamp(0.0, maxScrollExtent);
      _horizontalScrollController.animateTo(
        newOffset,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return DragTarget<Map<dynamic, dynamic>>(
          onWillAccept: (data) => false,
          onMove: (details) {
            if (widget.label == "opportunities") {
              _handleHorizontalAutoScroll(details.offset.dx);
            }
          },
          onLeave: (data) {},
          builder: (context, candidateData, rejectedData) {
            return FutureBuilder<List<Map<String, dynamic>>>(
              future:
                  widget.label == "opportunities" ? _cachedStagesFuture : null,
              builder: (context, snapshot) {
                if (widget.label == "opportunities") {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return KanbanShimmer();
                  }
                  if (snapshot.hasError || !snapshot.hasData) {
                    return const Center(child: Text("Error loading stages"));
                  }

                  final stages = snapshot.data!;
                  Map<String, List<T>> groupedData = {};
                  Map<String, int> stageOrderMap = {};

                  for (var item in widget.data) {
                    String category = _getKanbanCategory(item);
                    groupedData.putIfAbsent(category, () => []).add(item);
                  }

                  for (var stage in stages) {
                    String stageName = stage['name'] as String;
                    int stageId = stage['id'] as int;
                    stageOrderMap[stageName] = stageId;
                    groupedData.putIfAbsent(stageName, () => []);
                  }

                  List<String> sortedKeys = groupedData.keys.toList()
                    ..sort((a, b) {
                      int stageA = stageOrderMap[a] ?? 9999;
                      int stageB = stageOrderMap[b] ?? 9999;
                      return stageA.compareTo(stageB);
                    });

                  return SingleChildScrollView(
                    controller: _horizontalScrollController,
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: sortedKeys.map((key) {
                        final stageId = stageOrderMap[key] ?? 0;
                        return _buildColumn(key, groupedData[key]!, context,
                            widget.label, stageId);
                      }).toList(),
                    ),
                  );
                } else {
                  Map<String, List<T>> groupedData = {};
                  for (var item in widget.data) {
                    String category = _getKanbanCategory(item);
                    groupedData.putIfAbsent(category, () => []).add(item);
                  }

                  List<String> sortedKeys = groupedData.keys.toList();
                  if (widget.label == "forecast") {
                    sortedKeys.sort((a, b) {
                      if (a == "None") return -1;
                      if (b == "None") return 1;
                      return _parseDate(a).compareTo(_parseDate(b));
                    });
                  }

                  return SingleChildScrollView(
                    controller: _horizontalScrollController,
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: sortedKeys.map((key) {
                        return _buildColumn(
                            key, groupedData[key]!, context, widget.label, 0);
                      }).toList(),
                    ),
                  );
                }
              },
            );
          },
        );
      },
    );
  }

  /// Fetches all CRM stages from Odoo (used only in opportunities mode)
  Future<List<Map<String, dynamic>>> _fetchCrmStages() async {
    try {
      final result = await CompanySessionManager.callKwWithCompany({
        'model': 'crm.stage',
        'method': 'search_read',
        'args': [[]],
        'kwargs': {
          'fields': ['id', 'name'],
          'order': 'id ASC',
        },
      });

      if (result is List) {
        setState(() {
          isLoading = false;
        });
        return List<Map<String, dynamic>>.from(result);
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  /// Extracts category key from item (with special handling for forecast)
  String _getKanbanCategory(T item) {
    var mapItem = item as Map<dynamic, dynamic>;

    switch (widget.label) {
      case "forecast":
        return _getForecastCategory(mapItem);
      case "leads":
      case "opportunities":
        return mapItem['stage_id'] is List && mapItem['stage_id'].length == 2
            ? mapItem['stage_id'][1]
            : "Unknown";
      case "activities":
        return mapItem['month'] ?? "Unknown";
      default:
        return widget.getCategory(item);
    }
  }

  /// Forecast-specific category (month-year from deadline)
  String _getForecastCategory(Map<dynamic, dynamic> item) {
    String? deadline = item['date_deadline']?.toString();
    if (deadline == null || deadline == "false") return "None";

    try {
      DateTime parsedDate = DateTime.parse(deadline);
      return DateFormat('MMMM yyyy').format(parsedDate);
    } catch (e) {
      return "Invalid Date";
    }
  }

  /// Parses month-year string for sorting (fallback to far future)
  DateTime _parseDate(String monthYear) {
    try {
      return DateFormat('MMMM yyyy').parse(monthYear);
    } catch (e) {
      return DateTime(9999);
    }
  }

  void _handleOpportunityDrop(
      BuildContext context,
      Map<dynamic, dynamic> draggedOpportunity,
      int newStageId,
      String newStageName) async {
    final opportunityProvider =
        Provider.of<OpportunityDataProvider>(context, listen: false);

    final opportunityId = draggedOpportunity['id'] as int;
    final originalStageId = draggedOpportunity['stage_id'] is List
        ? draggedOpportunity['stage_id'][0] as int
        : draggedOpportunity['stage_id'] as int;
    final originalStageName = draggedOpportunity['stage_id'] is List
        ? draggedOpportunity['stage_id'][1] as String
        : '';

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ),
            SizedBox(width: 16),
            Text('Updating stage...'),
          ],
        ),
        duration: Duration(seconds: 2),
        backgroundColor: Theme.of(context).primaryColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 8,
      ),
    );

    opportunityProvider.optimisticallyUpdateStage(
      opportunityId: opportunityId,
      newStageId: newStageId,
      newStageName: newStageName,
    );

    final success = await opportunityProvider.updateOpportunityStage(
      context: context,
      opportunityId: opportunityId,
      newStageId: newStageId,
      newStageName: newStageName,
    );

    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    if (success) {
      CustomSnackbar.showSuccess(context, 'Stage updated successfully');
    } else {
      opportunityProvider.rollbackStageUpdate(
        opportunityId: opportunityId,
        originalStageId: originalStageId,
        originalStageName: originalStageName,
      );
    }
  }

  /// Builds a single column (stage/category) with header, items, and optional add button
  Widget _buildColumn(String title, List<T> items, BuildContext context,
      String label, int stageId) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 0),
      child: Container(
        width: 280,
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppColors().fillColor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Stack(
          children: [
            if (label == 'opportunities')
              DragTarget<Map<dynamic, dynamic>>(
                onAccept: (draggedOpportunity) {
                  HapticFeedback.mediumImpact();
                  _handleOpportunityDrop(
                      context, draggedOpportunity, stageId, title);
                },
                onWillAccept: (draggedOpportunity) {
                  if (draggedOpportunity != null) {
                    final currentStageId =
                        draggedOpportunity['stage_id'] is List
                            ? draggedOpportunity['stage_id'][0]
                            : draggedOpportunity['stage_id'];
                    return currentStageId != stageId;
                  }
                  return false;
                },
                onMove: (details) {
                  if (label == 'opportunities') {
                    try {
                      final RenderBox? renderBox =
                          context.findRenderObject() as RenderBox?;
                      if (renderBox != null && renderBox.hasSize) {
                        final localPosition =
                            renderBox.globalToLocal(details.offset);
                        _handleAutoScroll('${title}_$stageId', localPosition.dy,
                            renderBox.size.height);
                        _handleHorizontalAutoScroll(details.offset.dx);
                      }
                    } catch (_) {}
                  }
                },
                builder: (context, candidateData, rejectedData) {
                  final isHovering = candidateData.isNotEmpty;
                  return Container(
                    decoration: BoxDecoration(
                      color: isHovering
                          ? Theme.of(context).primaryColor.withOpacity(0.1)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(8),
                      border: isHovering
                          ? Border.all(
                              color: Theme.of(context).primaryColor, width: 2)
                          : null,
                    ),
                    child: _buildColumnContent(
                        title, items, context, label, stageId),
                  );
                },
              )
            else
              _buildColumnContent(title, items, context, label, stageId),
          ],
        ),
      ),
    );
  }

  /// Builds the inner content of a column (header + scrollable items list + optional add button)
  Widget _buildColumnContent(String title, List<T> items, BuildContext context,
      String label, int stageId) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: DragTarget<Map<dynamic, dynamic>>(
                  onWillAccept: (draggedOpportunity) {
                    if (label == 'opportunities' &&
                        draggedOpportunity != null) {
                      final currentStageId =
                          draggedOpportunity['stage_id'] is List
                              ? draggedOpportunity['stage_id'][0]
                              : draggedOpportunity['stage_id'];
                      return currentStageId != stageId;
                    }
                    return false;
                  },
                  onAccept: (draggedOpportunity) {
                    if (label == 'opportunities') {
                      HapticFeedback.mediumImpact();
                      _handleOpportunityDrop(
                          context, draggedOpportunity, stageId, title);
                    }
                  },
                  onMove: (details) {
                    if (label == 'opportunities') {
                      try {
                        final RenderBox? renderBox =
                            context.findRenderObject() as RenderBox?;
                        if (renderBox != null && renderBox.hasSize) {
                          final localPosition =
                              renderBox.globalToLocal(details.offset);
                          _handleAutoScroll('${title}_$stageId',
                              localPosition.dy, renderBox.size.height);
                          _handleHorizontalAutoScroll(details.offset.dx);
                        }
                      } catch (_) {}
                    }
                  },
                  builder: (context, candidateData, rejectedData) {
                    final isHovering = candidateData.isNotEmpty;
                    return Container(
                      decoration: BoxDecoration(
                        color: isHovering && label == 'opportunities'
                            ? Theme.of(context).primaryColor.withOpacity(0.05)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: NotificationListener<ScrollNotification>(
                        onNotification: (scrollNotification) {
                          return false;
                        },
                        child: Scrollbar(
                          controller: _getScrollController('${title}_$stageId'),
                          thumbVisibility: items.length > 3,
                          trackVisibility: items.length > 5,
                          child: ListView.builder(
                            controller:
                                _getScrollController('${title}_$stageId'),
                            physics: const BouncingScrollPhysics(),
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            itemCount: items.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 4),
                                child: widget.itemBuilder(items[index]),
                              );
                            },
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              if (label == 'opportunities') ...[
                const SizedBox(height: 40),
              ],
              if (label != 'opportunities') ...[
                const SizedBox(height: 10),
              ],
            ],
          ),
        ),
        if (label == 'opportunities')
          Positioned(
            bottom: 0,
            child: InkWell(
              onTap: () {
                if (label == 'opportunities') {
                  showDialog(
                    context: context,
                    builder: (context) =>
                        OpportunityLeadDialog(stageId: stageId),
                  );
                }
              },
              child: Container(
                height: 40,
                width: 280,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(8),
                    bottomRight: Radius.circular(8),
                  ),
                  color: Theme.of(context).primaryColor.withOpacity(0.1),
                ),
                child: Row(
                  children: [
                    const SizedBox(width: 15),
                    Icon(
                      Icons.add,
                      color: Theme.of(context).primaryColor,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      "Add Card",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }
}
