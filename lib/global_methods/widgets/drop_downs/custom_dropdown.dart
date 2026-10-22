import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../../utils/app_theme.dart';
import '../forms/mobo_dropdown_option_tile.dart';

/// A searchable, overlay-based dropdown (autocomplete-style) that filters items
/// as the user types and shows results in a positioned overlay below the field.
///
/// Features:
///   - Real-time filtering based on `displayText` (case-insensitive endsWith)
///   - Overlay positioned exactly below the text field using `LayerLink`
///   - Click-outside-to-dismiss behavior
///   - Custom validator support (via `TextFormField`)
///   - Fixed modern styling matching app theme (grey background, rounded corners)
///   - Works with any generic type `T` via `displayText` callback
///
/// Usage:
/// ```dart
/// SearchableDropdown<CustomerItem>(
///   items: customers,
///   displayText: (c) => c.name,
///   onItemSelected: (c) => _selectCustomer(c),
///   controller: _customerController,
///   hintText: 'Search customer...',
///   validator: (val) => val?.isEmpty ?? true ? 'Required' : null,
/// )
/// ```
class SearchableDropdown<T> extends StatefulWidget {
  final List<T> items;
  final String Function(T) displayText;
  final void Function(T) onItemSelected;
  final TextEditingController controller;
  final String hintText;
  final String? Function(String?)? validator;

  const SearchableDropdown({
    super.key,
    required this.items,
    required this.displayText,
    required this.onItemSelected,
    required this.controller,
    required this.hintText,
    this.validator,
  });

  @override
  // ignore: library_private_types_in_public_api
  _SearchableDropdownState<T> createState() => _SearchableDropdownState<T>();
}

class _SearchableDropdownState<T> extends State<SearchableDropdown<T>> {
  OverlayEntry? _overlayEntry;
  final LayerLink _layerLink = LayerLink();
  List<T> _filteredItems = [];

  void _showDropdown() {
    _filteredItems = widget.items;
    _overlayEntry = _createOverlayEntry();
    Overlay.of(context).insert(_overlayEntry!);
  }

  void _hideDropdown() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  /// Creates the overlay entry positioned below the text field
  OverlayEntry _createOverlayEntry() {
    RenderBox renderBox = context.findRenderObject() as RenderBox;
    var size = renderBox.size;
    var offset = renderBox.localToGlobal(Offset.zero);

    return OverlayEntry(
      builder: (context) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        return Stack(
        children: [
          Positioned.fill(
            child: GestureDetector(
              onTap: _hideDropdown,
              behavior: HitTestBehavior.translucent,
            ),
          ),
          Positioned(
            width: size.width,
            left: offset.dx,
            top: offset.dy + size.height,
            child: CompositedTransformFollower(
              link: _layerLink,
              offset: Offset(0, size.height + 5),
              child: Material(
                color: AppTheme.surface(isDark),
                elevation: 4.0,
                clipBehavior: Clip.antiAlias,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppRadius.lg),
                  side: BorderSide(
                      color: isDark ? Colors.grey[700]! : Colors.grey[200]!),
                ),
                child: SizedBox(
                  height: 200,
                  child: _filteredItems.isEmpty
                      ? Center(
                          child: Text(
                            'No data found',
                            style: TextStyle(
                              fontSize: 14,
                              color: AppTheme.secondaryLabelColor(isDark),
                            ),
                          ),
                        )
                      : ListView.builder(
                          padding: EdgeInsets.zero,
                          itemCount: _filteredItems.length,
                          itemBuilder: (context, index) {
                            final item = _filteredItems[index];
                            final label = widget.displayText(item);
                            return MoboDropdownOptionTile(
                              title: label,
                              isSelected: widget.controller.text == label,
                              onTap: () {
                                widget.controller.text = label;
                                widget.onItemSelected(item);
                                _hideDropdown();
                              },
                            );
                          },
                        ),
                ),
              ),
            ),
          ),
        ],
      );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return CompositedTransformTarget(
      link: _layerLink,
      child: TextFormField(
          style: AppTheme.fieldValueStyle(isDark),
          cursorColor: AppTheme.primaryColor,
          controller: widget.controller,
          decoration: AppTheme.fieldDecoration(
            isDark,
            hintText: widget.hintText,
            suffixIcon: Icon(
              HugeIcons.strokeRoundedArrowDown01,
              size: 22,
              color: AppTheme.fieldIconColor(isDark),
            ),
          ).copyWith(
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.md),
              borderSide: const BorderSide(color: StatusColors.statusRed),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.md),
              borderSide:
                  const BorderSide(color: StatusColors.statusRed, width: 2),
            ),
          ),
          readOnly: false,
          validator: widget.validator,
          onTap: _showDropdown,
          onChanged: (query) {
            setState(() {
              _filteredItems = widget.items
                  .where((item) => widget
                      .displayText(item)
                      .toLowerCase()
                      .contains(query.toLowerCase()))
                  .toList();
            });

            _overlayEntry?.remove();
            _overlayEntry = _createOverlayEntry();
            Overlay.of(context).insert(_overlayEntry!);
          },
        ),
    );
  }

  @override
  void dispose() {
    _hideDropdown();
    super.dispose();
  }
}
