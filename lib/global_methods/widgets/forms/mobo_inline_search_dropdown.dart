import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../../utils/app_theme.dart';
import 'mobo_dropdown_option_tile.dart';

/// Searchable dropdown whose results open inline beneath the field rather
/// than in an overlay: type in the field to filter, tap a row to pick it.
///
/// Works inside a [Form]; [validator] errors show as red text under the field.
class MoboInlineSearchDropdown<T> extends StatefulWidget {
  final List<T> items;
  final T? initialValue;
  final String Function(T item) titleBuilder;
  final String? Function(T item)? subtitleBuilder;
  final Widget? Function(T item)? leadingBuilder;
  final Widget? Function(T item)? trailingBuilder;

  /// Extra text matched by the search besides the title, e.g. an SKU.
  final String? Function(T item)? searchTextBuilder;
  final bool Function(T item)? isItemSelected;
  final ValueChanged<T> onChanged;
  final String hintText;
  final IconData leadingIcon;
  final bool isLoading;
  final String emptyText;
  final double panelHeight;
  final String? Function(T? value)? validator;

  /// Shows a persistent "+ Create new" row above the results.
  final VoidCallback? onCreateNew;
  final String? createNewLabel;

  /// "Add item" mode: empty the field after each pick instead of showing the
  /// picked value, ready for the next search.
  final bool clearOnSelect;

  /// Called whenever the panel opens, e.g. to load items on first use.
  final VoidCallback? onOpen;

  const MoboInlineSearchDropdown({
    super.key,
    required this.items,
    required this.titleBuilder,
    required this.onChanged,
    required this.hintText,
    this.initialValue,
    this.subtitleBuilder,
    this.leadingBuilder,
    this.trailingBuilder,
    this.searchTextBuilder,
    this.isItemSelected,
    this.leadingIcon = HugeIcons.strokeRoundedSearch01,
    this.isLoading = false,
    this.emptyText = 'No data found',
    this.panelHeight = 200,
    this.validator,
    this.onCreateNew,
    this.createNewLabel,
    this.clearOnSelect = false,
    this.onOpen,
  });

  @override
  State<MoboInlineSearchDropdown<T>> createState() =>
      _MoboInlineSearchDropdownState<T>();
}

class _MoboInlineSearchDropdownState<T>
    extends State<MoboInlineSearchDropdown<T>> {
  late final TextEditingController _controller;
  final GlobalKey<FormFieldState<T>> _fieldKey = GlobalKey<FormFieldState<T>>();
  T? _selected;
  String _query = '';
  bool _isOpen = false;

  @override
  void initState() {
    super.initState();
    _selected = widget.initialValue;
    _controller = TextEditingController(
      text: _selected == null ? '' : widget.titleBuilder(_selected as T),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  List<T> get _filtered {
    final q = _query.trim().toLowerCase();
    if (q.isEmpty) return widget.items;
    return widget.items.where((item) {
      if (widget.titleBuilder(item).toLowerCase().contains(q)) return true;
      final extra = widget.searchTextBuilder?.call(item);
      return extra != null && extra.toLowerCase().contains(q);
    }).toList();
  }

  void _open() {
    if (_isOpen) return;
    setState(() => _isOpen = true);
    widget.onOpen?.call();
  }

  void _close() {
    if (!_isOpen) return;
    setState(() {
      _isOpen = false;
      _restoreSelectionText();
    });
  }

  void _toggle() => _isOpen ? _close() : _open();

  /// Leaving the panel without picking puts the chosen value's name back, so
  /// half-typed search text never reads as the selection.
  void _restoreSelectionText() {
    _query = '';
    _controller.text =
        _selected == null ? '' : widget.titleBuilder(_selected as T);
  }

  void _select(T item) {
    // The field itself, not the page scope, or the page keeps it as its
    // remembered focus and refocuses it when any later popup closes.
    FocusManager.instance.primaryFocus?.unfocus();
    setState(() {
      _isOpen = false;
      _query = '';
      if (widget.clearOnSelect) {
        _controller.clear();
      } else {
        _selected = item;
        _controller.text = widget.titleBuilder(item);
      }
    });
    if (!widget.clearOnSelect) _fieldKey.currentState?.didChange(item);
    widget.onChanged(item);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return TapRegion(
      onTapOutside: (_) => _close(),
      child: FormField<T>(
      key: _fieldKey,
      initialValue: _selected,
      validator: widget.validator,
      builder: (field) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: _controller,
              onTap: _open,
              onChanged: (value) {
                setState(() => _query = value);
                _open();
              },
              cursorColor: AppTheme.primaryColor,
              style: AppTheme.fieldValueStyle(isDark),
              decoration: AppTheme.fieldDecoration(
                isDark,
                hintText: widget.hintText,
                hasError: field.hasError,
                prefixIcon: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Icon(widget.leadingIcon,
                      size: 22, color: AppTheme.fieldIconColor(isDark)),
                ),
                suffixIcon: GestureDetector(
                  onTap: _toggle,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Icon(
                      _isOpen
                          ? HugeIcons.strokeRoundedArrowUp01
                          : HugeIcons.strokeRoundedArrowDown01,
                      size: 22,
                      color: AppTheme.fieldIconColor(isDark),
                    ),
                  ),
                ),
              ),
            ),
            if (_isOpen) _buildPanel(isDark),
            if (field.hasError)
              Padding(
                padding: const EdgeInsets.only(top: 4, left: 4),
                child: Text(
                  field.errorText!,
                  style: const TextStyle(
                      color: StatusColors.statusRed, fontSize: 12),
                ),
              ),
          ],
        );
      },
      ),
    );
  }

  Widget _buildPanel(bool isDark) {
    final items = _filtered;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Container(
        height: widget.panelHeight,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: AppTheme.surface(isDark),
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(AppRadius.md),
            bottomRight: Radius.circular(AppRadius.md),
          ),
          border: Border.all(color: AppTheme.cardBorder(isDark)),
        ),
        child: Column(
          children: [
            if (widget.onCreateNew != null) ...[
              InkWell(
                onTap: widget.onCreateNew,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                  child: Row(
                    children: [
                      const Icon(Icons.add_circle_outline,
                          size: 18, color: AppTheme.primaryColor),
                      const SizedBox(width: 8),
                      Text(
                        widget.createNewLabel ?? 'Create new',
                        style: const TextStyle(
                          color: AppTheme.primaryColor,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Divider(height: 1, color: AppTheme.cardBorder(isDark)),
            ],
            Expanded(
              child: widget.isLoading
                  ? const Center(
                      child: CircularProgressIndicator(
                          color: AppTheme.primaryColor))
                  : items.isEmpty
                      ? Center(
                          child: Text(
                            widget.emptyText,
                            style: TextStyle(
                              fontSize: 14,
                              color: AppTheme.secondaryLabelColor(isDark),
                            ),
                          ),
                        )
                      : ListView.separated(
                          padding: EdgeInsets.zero,
                          itemCount: items.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(height: 5),
                          itemBuilder: (context, index) {
                            final item = items[index];
                            return MoboDropdownOptionTile(
                              onTap: () => _select(item),
                              isSelected: widget.isItemSelected?.call(item) ??
                                  identical(item, _selected),
                              leading: widget.leadingBuilder?.call(item),
                              title: widget.titleBuilder(item),
                              subtitle: widget.subtitleBuilder?.call(item),
                              trailing: widget.trailingBuilder?.call(item),
                            );
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }
}
