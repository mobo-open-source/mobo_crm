import 'package:flutter/material.dart';

import '../../../utils/app_theme.dart';

/// The list search bar: a card-like search field with a square filter button
/// beside it. Both share a 10px radius and the soft search shadow; focus
/// brings up a brand-coloured ring on the field.
class CustomSearchTextField extends StatefulWidget {
  final TextEditingController controller;
  final bool readOnly;
  final void Function(String)? onChanged;
  final VoidCallback? onFilterTap;
  final String? hintText;

  /// Called after the field is cleared with the × button.
  final VoidCallback? onClear;

  const CustomSearchTextField({
    super.key,
    required this.controller,
    required this.readOnly,
    this.onChanged,
    this.onFilterTap,
    this.hintText,
    this.onClear,
  });

  @override
  State<CustomSearchTextField> createState() => _CustomSearchTextFieldState();
}

class _CustomSearchTextFieldState extends State<CustomSearchTextField> {
  static const double _height = 48;
  static const double _radius = 10;

  final FocusNode _focusNode = FocusNode();
  bool _hasFocus = false;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onControllerChange);
    _focusNode.addListener(_onFocusChange);
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
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
    super.dispose();
  }

  void _onControllerChange() {
    if (mounted) setState(() {});
  }

  void _onFocusChange() {
    if (mounted) setState(() => _hasFocus = _focusNode.hasFocus);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Row(
      children: [
        Expanded(child: _buildField(isDark)),
        if (widget.onFilterTap != null) ...[
          const SizedBox(width: 12),
          _buildFilterButton(isDark),
        ],
      ],
    );
  }

  Widget _buildField(bool isDark) {
    final hasText = widget.controller.text.isNotEmpty;
    final iconColor = AppTheme.hintColor(isDark);

    // The shadow sits on this outer, unclipped box; the fill and focus ring
    // are a bare DecoratedBox so the ring doesn't pad (and shift) the content.
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(_radius),
        boxShadow: AppShadows.search,
      ),
      child: SizedBox(
        height: _height,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: isDark ? Colors.grey[850] : Colors.white,
            borderRadius: BorderRadius.circular(_radius),
            border: Border.all(
              color: _hasFocus ? AppTheme.primaryColor : Colors.transparent,
              width: 2,
            ),
          ),
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: widget.readOnly ? null : _focusNode.requestFocus,
            // Icon, input and clear button are laid out by this Row, not by
            // InputDecoration prefix/suffix: a suffix button taller than the
            // text line re-centres the input when it appears, which is what
            // made the text jump up as soon as you started typing.
            child: Row(
              children: [
                const SizedBox(width: 14),
                Icon(Icons.search, size: 22, color: iconColor),
                const SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    controller: widget.controller,
                    focusNode: _focusNode,
                    readOnly: widget.readOnly,
                    onChanged: widget.onChanged,
                    textInputAction: TextInputAction.search,
                    cursorColor: AppTheme.primaryColor,
                    style: TextStyle(
                      color: isDark ? Colors.white : const Color(0xFF1E1E1E),
                      fontWeight: FontWeight.w400,
                      fontSize: 15,
                    ),
                    decoration: InputDecoration(
                      hintText: widget.hintText ?? 'Search by name',
                      hintStyle: TextStyle(
                        color: iconColor,
                        fontWeight: FontWeight.w400,
                        fontSize: 15,
                      ),
                      filled: false,
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      isDense: true,
                      isCollapsed: true,
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                ),
                if (hasText)
                  IconButton(
                    icon: Icon(Icons.clear_rounded, color: iconColor, size: 18),
                    tooltip: 'Clear search',
                    visualDensity: VisualDensity.compact,
                    constraints:
                        const BoxConstraints(minWidth: 40, minHeight: 40),
                    padding: EdgeInsets.zero,
                    onPressed: widget.readOnly
                        ? null
                        : () {
                            widget.controller.clear();
                            widget.onChanged?.call('');
                            widget.onClear?.call();
                          },
                  ),
                const SizedBox(width: 12),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFilterButton(bool isDark) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(_radius),
        boxShadow: AppShadows.search,
      ),
      child: Material(
        color: isDark ? Colors.grey[850] : Colors.white,
        borderRadius: BorderRadius.circular(_radius),
        child: InkWell(
          onTap: widget.readOnly ? null : widget.onFilterTap,
          borderRadius: BorderRadius.circular(_radius),
          child: SizedBox(
            width: _height,
            height: _height,
            child: Icon(
              Icons.filter_alt_outlined,
              size: 22,
              color: isDark ? Colors.white70 : const Color(0xFF5F5F5F),
            ),
          ),
        ),
      ),
    );
  }
}
