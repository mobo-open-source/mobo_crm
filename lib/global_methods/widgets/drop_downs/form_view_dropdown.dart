import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

/// A customizable, searchable-style dropdown field using `animated_custom_dropdown`.
///
/// Features:
///   - Fixed compact width (150px) suitable for form views
///   - Shimmer loading placeholder when items/initialValue are empty
///   - Editable / non-editable mode (absorbs pointer events when disabled)
///   - Optional background fill (light blue #e6f0ff by default)
///   - Custom padding control for dropdown menu
///   - Animated open/close with arrow icon
///   - Calls `onChanged` only on valid selection
///
/// Typical use: stage selector, priority picker, status dropdown in CRM forms.
class CustomDropdownFormView extends StatefulWidget {
  final String initialValue;
  final List<String> items;
  final ValueChanged<String> onChanged;
  final bool isEditable;
  final bool hasBackground;
  final double droppadding;
  const CustomDropdownFormView({
    super.key,
    required this.initialValue,
    required this.items,
    required this.onChanged,
    this.droppadding = 0,
    this.hasBackground = true,
    this.isEditable = true,
  });

  @override
  _CustomDropdownFormViewState createState() => _CustomDropdownFormViewState();
}

class _CustomDropdownFormViewState extends State<CustomDropdownFormView> {
  late String selectedValue;

  @override
  void initState() {
    super.initState();
    selectedValue = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    if (widget.items.isEmpty || widget.initialValue.isEmpty) {
      return SizedBox(
        width: 150,
        height: 48,
        child: Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(5),
            ),
          ),
        ),
      );
    }

    return AbsorbPointer(
      absorbing: !widget.isEditable,
      child: SizedBox(
        width: 150,
        child: CustomDropdown<String>(
          closedHeaderPadding: EdgeInsets.all(widget.droppadding),

          decoration: CustomDropdownDecoration(
            expandedBorderRadius: BorderRadius.circular(5),
            closedBorderRadius: BorderRadius.circular(5),
            closedFillColor:
                widget.hasBackground ? Color(0xffe6f0ff) : Colors.transparent,

            closedSuffixIcon: widget.isEditable
                ? Icon(
                    Icons.keyboard_arrow_down_sharp,
                    color: Theme.of(context).primaryColor,
                  )
                : const SizedBox.shrink(),
          ),
          initialItem: selectedValue,

          headerBuilder: (context, selectedItem, enabled) {
            return Text(
              selectedItem,
              style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.bold,
              ),
            );
          },

          listItemBuilder: (context, item, isSelected, onItemSelect) {
            return Text(
              item,
              style: TextStyle(),
            );
          },

          onChanged: (String? newValue) {
            if (newValue != null) {
              setState(() {
                selectedValue = newValue;
              });
              widget.onChanged(newValue);
            }
          },
          items: widget.items,
        ),
      ),
    );
  }
}
