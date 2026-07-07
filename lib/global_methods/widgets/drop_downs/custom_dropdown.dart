import 'package:flutter/material.dart';
import 'package:mobo_crm/global_methods/const.dart';

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
      builder: (context) => Stack(
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
                color: AppColors().fillColor,
                elevation: 4.0,
                borderRadius: BorderRadius.circular(8),
                child: SizedBox(
                  height: 200,
                  child: ListView.builder(
                    padding: EdgeInsets.zero,
                    itemCount: _filteredItems.length,
                    itemBuilder: (context, index) {
                      final item = _filteredItems[index];
                      return ListTile(
                        title: Text(
                          widget.displayText(item),
                          style: TextStyle(fontSize: 14),
                        ),
                        onTap: () {
                          widget.controller.text = widget.displayText(item);
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
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: const Color(0xFFF2F4F6),
          border: Border.all(color: Colors.transparent, width: 1),
        ),
        child: TextFormField(
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.w600,
          ),
          controller: widget.controller,
          decoration: InputDecoration(
            focusedErrorBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.red, width: 2)),
            errorBorder:
                OutlineInputBorder(borderSide: BorderSide(color: Colors.red)),
            focusedBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(8)),
              borderSide: BorderSide(
                color: Color(0xFFC03355),
                width: 1.5,
              ),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                color: Colors.transparent,
                width: 1.5,
              ),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 8,
            ),
            hintText: widget.hintText,
            hintStyle: TextStyle(color: AppColors().hintColor),

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
                      .endsWith(query.toLowerCase()))
                  .toList();
            });

            _overlayEntry?.remove();
            _overlayEntry = _createOverlayEntry();
            Overlay.of(context).insert(_overlayEntry!);
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    _hideDropdown();
    super.dispose();
  }
}
