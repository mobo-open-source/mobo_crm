import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mobo_crm/global_methods/const.dart';

/// A custom dropdown-style selector (not using Flutter's built-in DropdownButton)
/// that displays a list of view/filter options with icons or SVG assets.
///
/// Features:
/// - Overlay-based dropdown menu positioned below the button
/// - Supports both Material Icons and SVG assets
/// - Visual feedback for selected item (bold text + blue color)
/// - Click-outside-to-dismiss behavior
/// - Compact button showing current selection + arrow
///
/// Expected item structure (each map in `items`):
/// ```dart
/// {
///   'label': String,              // required - display text
///   'icon': IconData?,            // optional - Material icon
///   'assetUrl': String?,          // optional - path to SVG asset
///   'isSelected': bool            // managed internally
/// }
/// ```
/// At least one of `icon` or `assetUrl` should be provided per item.
class ViewSelectorDropdown extends StatefulWidget {
  /// List of view/filter options to display in the dropdown
  final List<Map<String, dynamic>> items;

  /// Callback invoked when user selects a different option
  /// Receives the index of the selected item in the `items` list
  final Function(int) onChanged;

  final int initialValue;

  const ViewSelectorDropdown({
    super.key,
    required this.items,
    required this.onChanged,
    this.initialValue = 0,
  });

  @override
  State<ViewSelectorDropdown> createState() => _ViewSelectorDropdownState();
}

class _ViewSelectorDropdownState extends State<ViewSelectorDropdown> {
  late int selectedIndex;
  OverlayEntry? _overlayEntry;
  final GlobalKey _buttonKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    selectedIndex = widget.initialValue.clamp(0, widget.items.length - 1);

    for (var i = 0; i < widget.items.length; i++) {
      widget.items[i]['isSelected'] = (i == selectedIndex);
    }
  }

  /// Displays the custom overlay dropdown menu below the button.
  ///
  /// Calculates position based on the button's global coordinates.
  /// Adds a transparent full-screen tap detector to close on outside click.
  void _showOverlay(BuildContext context) {
    _hideOverlay();
    final RenderBox? renderBox =
        _buttonKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox == null) return;

    final Offset position = renderBox.localToGlobal(Offset.zero);
    final Size size = renderBox.size;

    _overlayEntry = OverlayEntry(
      builder: (context) => Stack(
        children: [
          Positioned.fill(
            child: GestureDetector(
              onTap: _hideOverlay,
              child: Container(color: Colors.transparent),
            ),
          ),

          Positioned(
            left: position.dx - 80,
            top: position.dy + size.height + 5,
            width: 200,
            child: Material(
              color: Colors.transparent,
              child: Card(
                color: AppColors().fillColor,
                elevation: 15,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListView.builder(
                    shrinkWrap: true,
                    padding: EdgeInsets.zero,
                    itemCount: widget.items.length,
                    itemBuilder: (context, index) {
                      final item = widget.items[index];
                      final isSelected = item['isSelected'] ?? false;
                      return ListTile(
                        leading: item.containsKey('assetUrl') &&
                                item['assetUrl'] != null
                            ? SvgPicture.asset(
                                item['assetUrl'],
                                width: 24,
                                height: 24,
                                color:
                                    isSelected ? Colors.blue : Colors.black54,
                              )
                            : Icon(
                                item['icon'],
                                size: 24,
                                color:
                                    isSelected ? Colors.blue : Colors.black54,
                              ),
                        title: Text(
                          item['label'],
                          style: TextStyle(
                            color: isSelected ? Colors.blue : Colors.black87,
                            fontWeight: isSelected
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                        ),
                        onTap: () {
                          setState(() {
                            for (var i = 0; i < widget.items.length; i++) {
                              widget.items[i]['isSelected'] = (i == index);
                            }
                            selectedIndex = index;
                          });
                          widget.onChanged(index);
                          _hideOverlay();
                        },
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  /// Removes the overlay if it exists
  void _hideOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  @override
  void dispose() {
    _hideOverlay();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      key: _buttonKey,
      onTap: () => _showOverlay(context),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          border: Border.all(color: Theme.of(context).primaryColor, width: 1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            widget.items[selectedIndex].containsKey('assetUrl') &&
                    widget.items[selectedIndex]['assetUrl'] != null
                ? SvgPicture.asset(widget.items[selectedIndex]['assetUrl'],
                    width: 24,
                    height: 24,
                    color: Theme.of(context).primaryColor)
                : Icon(
                    widget.items[selectedIndex]['icon'],
                    size: 24,
                    color: Theme.of(context).primaryColor,
                  ),
            const SizedBox(width: 4),
            const Icon(
              Icons.arrow_drop_down,
              size: 24,
              color: Colors.black54,
            ),
          ],
        ),
      ),
    );
  }
}
