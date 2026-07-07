import 'package:flutter/material.dart';

/// A reusable search text field with an optional filter button.
class CustomSearchTextField extends StatefulWidget {
  final TextEditingController controller;
  final bool readOnly;
  final void Function(String)? onChanged;
  final VoidCallback? onFilterTap;
  final String? hintText;

  const CustomSearchTextField({
    super.key,
    required this.controller,
    required this.readOnly,
    this.onChanged,
    this.onFilterTap,
    this.hintText,
  });

  @override
  State<CustomSearchTextField> createState() => _CustomSearchTextFieldState();
}

class _CustomSearchTextFieldState extends State<CustomSearchTextField> {
  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onControllerChange);
  }

  @override
  void didUpdateWidget(CustomSearchTextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller.removeListener(_onControllerChange);
      widget.controller.addListener(_onControllerChange);
    }
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onControllerChange);
    super.dispose();
  }

  void _onControllerChange() => setState(() {});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final hasText = widget.controller.text.isNotEmpty;
    final hasFilter = widget.onFilterTap != null;

    return Container(
      height: 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Row(
        children: [
          if (hasFilter)
            GestureDetector(
              onTap: widget.readOnly ? null : widget.onFilterTap,
              child: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: isDark ? Colors.white : const Color(0xFF1E1E1E),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(14),
                    bottomLeft: Radius.circular(14),
                  ),
                ),
                child: Icon(
                  Icons.filter_alt_rounded,
                  color: isDark ? Colors.black : Colors.white,
                  size: 20,
                ),
              ),
            ),

          Expanded(
            child: Container(
              height: 50,
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF2A2A2A) : Colors.white,
                borderRadius: hasFilter
                    ? const BorderRadius.only(
                        topRight: Radius.circular(14),
                        bottomRight: Radius.circular(14),
                      )
                    : BorderRadius.circular(14),
              ),
              child: Center(
                child: TextField(
                controller: widget.controller,
                readOnly: widget.readOnly,
                cursorColor: Theme.of(context).primaryColor,
                style: TextStyle(
                  color: isDark ? Colors.white : const Color(0xFF1E1E1E),
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
                decoration: InputDecoration(
                  isDense: true,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 0,
                  ),
                  filled: false,
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  hintText: widget.hintText ?? 'Search by name',
                  hintStyle: TextStyle(
                    color: isDark
                        ? Colors.white38
                        : const Color(0xFF1E1E1E).withOpacity(0.4),
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                  suffixIcon: hasText
                      ? IconButton(
                          icon: Icon(
                            Icons.clear_rounded,
                            size: 18,
                            color: isDark ? Colors.white54 : Colors.grey,
                          ),
                          onPressed: () {
                            widget.controller.clear();
                            widget.onChanged?.call('');
                          },
                        )
                      : null,
                ),
                onChanged: widget.onChanged,
              ),
            ),
          ),
        ),
        ],
      ),
    );
  }
}
