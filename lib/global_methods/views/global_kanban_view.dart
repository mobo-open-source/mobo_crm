import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:drag_and_drop_lists/drag_and_drop_lists.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:mobo_crm/initilisation.dart';
import 'package:mobo_crm/screens/opportunity/providers/opportunity_data_provider.dart';
import 'package:mobo_crm/global_methods/dialog boxes/lead_creation_dialog.dart';
import 'package:mobo_crm/global_methods/dialog boxes/add_stage_dialog.dart';
import 'package:mobo_crm/global_methods/dialog boxes/edit_stage_dialog.dart';
import 'package:mobo_crm/global_methods/dialog boxes/delete_stage_dialog.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/company/session/company_session_manager.dart';
import '../../utils/globals.dart';
import '../../utils/snackbar.dart';
import '../widgets/shimmer/custom_shimmer.dart';

/// A generic horizontal Kanban-style board using drag-and-drop lists.
///
/// Supports two main modes:
///   1. Opportunities → dynamic stages fetched from Odoo (`crm.stage`), with add/edit/delete stage actions
///   2. Other entities (leads, quotations, forecast, etc.) → static categories from data
///
/// Features:
///   - Draggable cards between columns
///   - Auto-scroll when dragging near screen edges
///   - Stage header with item count, add button, and more menu (edit/delete)
///   - Optimistic UI updates + rollback on failure when moving opportunities
///   - Loading overlay during stage/opportunity updates
///   - "Add Stage" button at the end (opportunities only)
///
/// Generic type `T` is typically `Map<dynamic, dynamic>` for Odoo records.
class KanbanBoard<T> extends StatefulWidget {
  final List<T> data;
  final String label;
  final String Function(T) getCategory;
  final Widget Function(T) itemBuilder;
  final Future<void> Function()? onRefresh;

  const KanbanBoard({
    super.key,
    required this.data,
    required this.label,
    required this.getCategory,
    required this.itemBuilder,
    this.onRefresh,
  });

  @override
  State<KanbanBoard<T>> createState() => _KanbanBoardState<T>();
}

class _KanbanBoardState<T> extends State<KanbanBoard<T>> {
  /// Cached future for CRM stages (only used when label == "opportunities")
  static Future<List<Map<String, dynamic>>>? _cachedStagesFuture;

  bool isLoading = true;
  final ScrollController _scrollController = ScrollController();
  Timer? _scrollTimer;
  List<DragAndDropList> _dragAndDropLists = [];
  Set<int> _loadingOpportunityIds = {};
  final ScrollController _headerScrollController = ScrollController();
  bool _headerSyncLock = false;

  /// Cached grouped data and sorted keys for building sticky headers
  Map<String, List<T>> _currentGroupedData = {};
  List<String> _currentSortedKeys = [];

  @override
  void initState() {
    super.initState();
    if (widget.label == "opportunities") {
      _cachedStagesFuture = _fetchCrmStages();
    }
    _scrollController.addListener(_syncHeaderToBoard);
  }

  void _syncHeaderToBoard() {
    if (_headerSyncLock) return;
    _headerSyncLock = true;
    if (_headerScrollController.hasClients &&
        _scrollController.hasClients &&
        _headerScrollController.position.hasContentDimensions) {
      final offset = _scrollController.offset.clamp(
        _headerScrollController.position.minScrollExtent,
        _headerScrollController.position.maxScrollExtent,
      );
      _headerScrollController.jumpTo(offset);
    }
    _headerSyncLock = false;
  }

  @override
  void dispose() {
    _scrollController.removeListener(_syncHeaderToBoard);
    _headerScrollController.dispose();
    _scrollTimer?.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  /// Extracts the column/category name from an item
  String _getKanbanCategory(T item) {
    return widget.getCategory(item);
  }

  /// Builds the drag-and-drop list structure from grouped data and sorted keys
  void _buildDragAndDropLists(
      Map<String, List<T>> groupedData, List<String> sortedKeys) {
    _dragAndDropLists = sortedKeys.map((key) {
      List<T> items = groupedData[key] ?? [];

      List<DragAndDropItem> dragItems = [];

      dragItems.addAll(items.map((item) {
        bool isUpdating = false;
        if (item is Map && item['id'] != null) {
          isUpdating = _loadingOpportunityIds.contains(item['id']);
        }

        return DragAndDropItem(
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
            child: Stack(
              children: [
                widget.itemBuilder(item),
                if (isUpdating)
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                      ),
                      child: const Center(
                        child: SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor:
                            AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      }).toList());

      dragItems.add(
        DragAndDropItem(
          child: SizedBox(height: 8),
        ),
      );

      return DragAndDropList(
        header: _buildHiddenHeader(key, items),
        children: dragItems,
      );
    }).toList();
  }

  /// Invisible placeholder — keeps DragAndDropList.header non-null
  /// while the real header is rendered by the sticky row above.
  Widget _buildHiddenHeader(String key, List<T> items) =>
      const SizedBox.shrink();

  /// Builds header content for inside each DragAndDropList
  Widget _buildColumnHeaderContent(String key, List<T> items) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Row(
        children: [
          Container(
            padding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              '${key.isNotEmpty ? key[0].toUpperCase() + key.substring(1) : key} ${items.length}',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
          const Spacer(),
          if (widget.label == "opportunities") ...[
            const SizedBox(width: 4),
            SizedBox(
              width: 32,
              height: 32,
              child: IconButton(
                onPressed: () => _handleAddOpportunity(context, key),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                icon: const Icon(
                  Icons.add,
                  size: 20,
                  color: Colors.black,
                ),
              ),
            ),
            const SizedBox(width: 4),
            SizedBox(
              width: 32,
              height: 32,
              child: PopupMenuButton<String>(
                color: Colors.white,
                icon: const Icon(
                  Icons.more_vert,
                  size: 20,
                  color: Colors.black,
                ),
                padding: EdgeInsets.zero,
                offset: const Offset(0, 28),
                itemBuilder: (context) => [
                  PopupMenuItem<String>(
                    value: 'edit',
                    child: Row(
                      children: [
                        Icon(HugeIcons.strokeRoundedPencilEdit02,
                            size: 20, color: Colors.blue),
                        const SizedBox(width: 12),
                        Text('Edit',
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                                fontSize: 16)),
                      ],
                    ),
                  ),
                  PopupMenuItem<String>(
                    value: 'delete',
                    child: Row(
                      children: [
                        Icon(HugeIcons.strokeRoundedDelete02,
                            size: 20,
                            color: Colors.red),
                        const SizedBox(width: 12),
                        Text('Delete',
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                                fontSize: 16)),
                      ],
                    ),
                  ),
                ],
                onSelected: (value) =>
                    _handleStageAction(context, value, key),
              ),
            ),
          ],
        ],
      ),
    );
  }

  /// Called when user drags an item from one column to another
  void _onItemReorder(
      int oldItemIndex, int oldListIndex, int newItemIndex, int newListIndex) {
    if (widget.label != "opportunities") {
      return;
    }

    setState(() {
      _fetchCrmStages().then((stages) {
        try {
          Map<String, int> stageOrderMap = {};
          for (var stage in stages) {
            String stageName = stage['name'] as String;
            int stageId = stage['id'] as int;
            stageOrderMap[stageName] = stageId;
          }

          Map<String, List<T>> groupedData = {};
          for (var item in widget.data) {
            String category = _getKanbanCategory(item);
            groupedData.putIfAbsent(category, () => []).add(item);
          }

          for (var stage in stages) {
            String stageName = stage['name'] as String;
            groupedData.putIfAbsent(stageName, () => []);
          }

          List<String> sortedKeys = groupedData.keys.toList()
            ..sort((a, b) {
              int stageA = stageOrderMap[a] ?? 9999;
              int stageB = stageOrderMap[b] ?? 9999;
              return stageA.compareTo(stageB);
            });

          if (oldListIndex >= sortedKeys.length ||
              newListIndex >= sortedKeys.length) return;

          String fromStage = sortedKeys[oldListIndex];
          String toStage = sortedKeys[newListIndex];

          List<T> fromItems = groupedData[fromStage] ?? [];

          if (oldItemIndex == 0 || oldItemIndex >= fromItems.length + 1) return;

          T movedItem = fromItems[oldItemIndex - 1];

          if (fromStage == toStage) return;

          if (movedItem is Map) {
            int? newStageId = stageOrderMap[toStage];
            if (newStageId != null) {
              _handleOpportunityDrop(context, movedItem, newStageId, toStage);
            }
          }
        } catch (_) {}
      });
    });
  }

  void _onListReorder(int oldListIndex, int newListIndex) {}

  /// Opens dialog to create new opportunity in the selected stage
  void _handleAddOpportunity(BuildContext context, String stageName) async {
    try {
      int? stageId = await _getStageIdByName(stageName);
      if (stageId == null) {
        if (mounted) {
          CustomSnackbar.showError(
              context, 'Error: Could not find stage "$stageName"');
        }
        return;
      }

      if (mounted) {
        showDialog(
          context: context,
          builder: (context) => OpportunityLeadDialog(
            stageId: stageId,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        CustomSnackbar.showError(context, 'Error creating opportunity: $e');
      }
    }
  }

  /// Handles drag-drop of an opportunity to a new stage
  ///
  /// Features optimistic update + rollback on failure
  void _handleOpportunityDrop(
      BuildContext context,
      Map<dynamic, dynamic> draggedOpportunity,
      int newStageId,
      String toStage) async {
    try {
      final opportunityProvider =
      Provider.of<OpportunityDataProvider>(context, listen: false);

      int opportunityId = draggedOpportunity['id'];

      setState(() {
        _loadingOpportunityIds.add(opportunityId);
      });

      final originalStageId = draggedOpportunity['stage_id'] is List
          ? draggedOpportunity['stage_id'][0]
          : draggedOpportunity['stage_id'];
      final originalStageName = draggedOpportunity['stage_id'] is List
          ? draggedOpportunity['stage_id'][1]
          : 'Unknown';

      try {
        opportunityProvider.optimisticallyUpdateStage(
          opportunityId: opportunityId,
          newStageId: newStageId,
          newStageName: toStage,
        );
      } catch (_) {}

      HapticFeedback.mediumImpact();

      bool success = false;

      try {
        success = await opportunityProvider.updateOpportunityStage(
          context: context,
          opportunityId: opportunityId,
          newStageId: newStageId,
          newStageName: toStage,
        );
      } catch (e) {
        success = false;
      }

      setState(() {
        _loadingOpportunityIds.remove(opportunityId);
      });

      if (success && mounted) {
        CustomSnackbar.showSuccess(context,
            'Successfully moved ${draggedOpportunity['name']} to $toStage');
      } else if (!success) {
        try {
          opportunityProvider.rollbackStageUpdate(
            opportunityId: opportunityId,
            originalStageId: originalStageId,
            originalStageName: originalStageName,
          );
        } catch (_) {}
      }
    } catch (e) {
      setState(() {
        _loadingOpportunityIds.remove(draggedOpportunity['id']);
      });

      if (mounted) {
        CustomSnackbar.showError(context, 'Failed to move opportunity: $e');
      }
    }
  }

  /// Looks up stage ID by name using cached stages
  Future<int?> _getStageIdByName(String stageName) async {
    try {
      if (_cachedStagesFuture != null) {
        final stages = await _cachedStagesFuture!;
        for (var stage in stages) {
          if (stage['name'] == stageName) {
            return stage['id'] as int;
          }
        }
      }
    } catch (_) {}
    return null;
  }

  /// Starts auto-scrolling when dragging near screen edges
  void _startAutoScroll(double deltaX) {
    const double scrollSpeed = 5.0;
    const double edgeThreshold = 100.0;

    double screenWidth = MediaQuery.of(context).size.width;

    _scrollTimer?.cancel();

    if (deltaX < edgeThreshold && _scrollController.offset > 0) {
      _scrollTimer = Timer.periodic(const Duration(milliseconds: 20), (timer) {
        if (_scrollController.offset > 0) {
          _scrollController.jumpTo(_scrollController.offset - scrollSpeed);
        } else {
          timer.cancel();
        }
      });
    } else if (deltaX > screenWidth - edgeThreshold &&
        _scrollController.offset < _scrollController.position.maxScrollExtent) {
      _scrollTimer = Timer.periodic(const Duration(milliseconds: 20), (timer) {
        if (_scrollController.offset <
            _scrollController.position.maxScrollExtent) {
          _scrollController.jumpTo(_scrollController.offset + scrollSpeed);
        } else {
          timer.cancel();
        }
      });
    }
  }

  /// Stops any active auto-scroll timer
  void _stopAutoScroll() {
    _scrollTimer?.cancel();
    _scrollTimer = null;
  }

  /// Builds the "+ Add Stage" header widget (opportunities only)
  Widget _buildAddStageHeader() {
    return Container(
      width: 292,
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
      child: InkWell(
        onTap: () => _showAddStageDialog(),
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.add,
                size: 16,
                color: Colors.white,
              ),
              const SizedBox(width: 6),
              const Text(
                'Add Stage',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Sticky header row — scrolls horizontally in sync with the board,
  /// but is positioned outside any vertical scroll so it never moves vertically.
  Widget _buildStickyHeaderRow(
      List<String> sortedKeys,
      Map<String, List<T>> groupedData,
      {bool showAddStage = false}) {
    return SingleChildScrollView(
      controller: _headerScrollController,
      scrollDirection: Axis.horizontal,
      physics: const NeverScrollableScrollPhysics(),
      child: Row(
        children: [
          const SizedBox(width: 14),
          ...sortedKeys.asMap().entries.map((entry) {
            final key = entry.value;
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: 292.0,
                  child: _buildColumnHeaderContent(key, groupedData[key] ?? []),
                ),
                const SizedBox(width: 12),
              ],
            );
          }),
          if (showAddStage)
            SizedBox(width: 292.0, child: _buildAddStageHeader()),
          const SizedBox(width: 18),
        ],
      ),
    );
  }

  /// Adds the "+ Add Stage" column at the end (opportunities only)
  void _addStageButton(List<String> sortedKeys) {
    final addStageColumn = DragAndDropList(
      header: const SizedBox.shrink(),
      decoration: const BoxDecoration(color: Colors.transparent),
      children: [
        DragAndDropItem(
          child: const SizedBox(height: 8),
        ),
      ],
    );

    _dragAndDropLists.add(addStageColumn);
  }

  /// Opens dialog to create a new CRM stage
  void _showAddStageDialog() {
    showDialog(
      context: context,
      builder: (context) => const AddStageDialog(),
    );
  }

  /// Handles stage-level actions (edit/delete)
  void _handleStageAction(
      BuildContext context, String action, String stageName) async {
    try {
      final opportunityProvider =
      Provider.of<OpportunityDataProvider>(context, listen: false);
      final stageId =
      await opportunityProvider.getStageIdByName(context, stageName);

      if (stageId == null) {
        CustomSnackbar.showError(context, 'Could not find stage "$stageName"');

        return;
      }

      switch (action) {
        case 'edit':
          _showEditStageDialog(stageId, stageName);
          break;
        case 'delete':
          _showDeleteStageDialog(stageId, stageName);
          break;
      }
    } catch (e) {
      CustomSnackbar.showError(context, 'Error: $e');
    }
  }

  /// Opens dialog to edit an existing stage
  void _showEditStageDialog(int stageId, String stageName) async {
    try {
      final opportunityProvider =
      Provider.of<OpportunityDataProvider>(context, listen: false);
      final stages = await opportunityProvider.getCrmStages(context);

      final stage = stages.firstWhere(
            (s) => s['id'] == stageId,
        orElse: () => {'name': stageName},
      );

      if (mounted) {
        showDialog(
          context: context,
          builder: (context) => EditStageDialog(
            stageId: stageId,
            currentStageName: stage['name'] ?? stageName,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        CustomSnackbar.showError(context, 'Error loading stage details: $e');
      }
    }
  }

  /// Opens confirmation dialog to delete a stage
  void _showDeleteStageDialog(int stageId, String stageName) {
    showDialog(
      context: context,
      builder: (context) => DeleteStageDialog(
        stageId: stageId,
        stageName: stageName,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<OpportunityDataProvider>(context, listen: false);
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: widget.label == "opportunities" ? _cachedStagesFuture : null,
      initialData: widget.label == "opportunities" && provider.crmStages.isNotEmpty
          ? provider.crmStages
          : null,
      builder: (context, snapshot) {
        if (widget.label == "opportunities") {
          if (snapshot.connectionState == ConnectionState.waiting &&
              (snapshot.data == null || snapshot.data!.isEmpty)) {
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

          _currentGroupedData = groupedData;
          _currentSortedKeys = sortedKeys;

          _buildDragAndDropLists(groupedData, sortedKeys);
          _addStageButton(sortedKeys);

          final stickyHeader = _buildStickyHeaderRow(
              sortedKeys, groupedData, showAddStage: true);

          final boardInner = Padding(
            padding: const EdgeInsets.fromLTRB(8, 0, 0, 8),
            child: Listener(
              onPointerMove: (PointerMoveEvent event) {
                _startAutoScroll(event.position.dx);
              },
              onPointerUp: (PointerUpEvent event) {
                _stopAutoScroll();
              },
              child: DragAndDropLists(
                children: _dragAndDropLists,
                onItemReorder: _onItemReorder,
                onListReorder: _onListReorder,
                axis: Axis.horizontal,
                scrollController: _scrollController,
                listPadding: const EdgeInsets.symmetric(horizontal: 6),
                itemDivider: const SizedBox(height: 10),
                listDecoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius:
                      BorderRadius.vertical(bottom: Radius.circular(16)),
                ),
                lastItemTargetHeight: 20,
                addLastItemTargetHeightToTop: false,
                lastListTargetSize: 0,
                listWidth: 304,
              ),
            ),
          );

          if (widget.onRefresh != null) {
            return Column(
              children: [
                stickyHeader,
                Expanded(
                  child: Transform.translate(
                    offset: const Offset(0, -2),
                    child: RefreshIndicator(
                      color: Theme.of(context).primaryColor,
                      backgroundColor: Colors.white,
                      onRefresh: widget.onRefresh!,
                      child: LayoutBuilder(
                        builder: (context, constraints) =>
                            SingleChildScrollView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          child: SizedBox(
                            height: constraints.maxHeight,
                            child: boardInner,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          }

          return Column(
            children: [
              stickyHeader,
              Expanded(
                child: Transform.translate(
                  offset: const Offset(0, -2),
                  child: boardInner,
                ),
              ),
            ],
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

          _currentGroupedData = groupedData;
          _currentSortedKeys = sortedKeys;

          _buildDragAndDropLists(groupedData, sortedKeys);

          return Column(
            children: [
              _buildStickyHeaderRow(sortedKeys, groupedData),
              Expanded(
                child: Transform.translate(
                  offset: const Offset(0, -2),
                  child: Padding(
                  padding: const EdgeInsets.fromLTRB(8, 0, 0, 8),
                  child: DragAndDropLists(
                      children: _dragAndDropLists,
                      onItemReorder: _onItemReorder,
                      onListReorder: _onListReorder,
                      axis: Axis.horizontal,
                      scrollController: _scrollController,
                      listPadding: const EdgeInsets.fromLTRB(6, 0, 6, 8),
                      listDecoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                            BorderRadius.vertical(bottom: Radius.circular(16)),
                      ),
                      listInnerDecoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                            BorderRadius.vertical(bottom: Radius.circular(16)),
                      ),
                      lastItemTargetHeight: 20,
                      addLastItemTargetHeightToTop: false,
                      lastListTargetSize: 2,
                      listWidth: 304,
                    ),
                  ),
                ),
              ),
              ],
            );
        }
      },
    );
  }

  /// Fetches all CRM stages from Odoo (cached future)
  Future<List<Map<String, dynamic>>> _fetchCrmStages() async {
    try {
      final provider =
          Provider.of<OpportunityDataProvider>(context, listen: false);
      return await provider.getCrmStages(context);
    } catch (e) {
      return [];
    }
  }

  /// Parses date string for sorting (fallback to now)
  DateTime _parseDate(String dateStr) {
    try {
      return DateTime.parse(dateStr);
    } catch (e) {
      return DateTime.now();
    }
  }
}
