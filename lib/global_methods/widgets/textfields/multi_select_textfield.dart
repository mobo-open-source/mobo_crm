import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';

/// A searchable dropdown supporting single or multiple selection of items of type [T].
class MultiSelectSearchableDropdown<T> extends StatefulWidget {
  final List<T> items;
  final String Function(T) displayText;
  final void Function(List<T>) onSelectionChanged;
  final String hintText;
  final double width;
  final bool multiselectable;
  final bool iseditable;
  final List<T>? initialValue;
  final dynamic Function(T)? idSelector;
  final VoidCallback? onTap;

  const MultiSelectSearchableDropdown({
    super.key,
    required this.items,
    required this.displayText,
    required this.onSelectionChanged,
    required this.hintText,
    this.width = double.infinity,
    this.multiselectable = true,
    this.iseditable = true,
    this.initialValue,
    this.idSelector,
    this.onTap,
  });

  @override
  State<MultiSelectSearchableDropdown<T>> createState() =>
      _MultiSelectSearchableDropdownState<T>();
}

class _MultiSelectSearchableDropdownState<T>
    extends State<MultiSelectSearchableDropdown<T>> {
  late List<T> _selectedItems;
  final _key = GlobalKey<DropdownSearchState<T>>();
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _selectedItems = List<T>.from(widget.initialValue ?? []);
  }

  @override
  void didUpdateWidget(MultiSelectSearchableDropdown<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialValue != oldWidget.initialValue) {
      setState(() {
        _selectedItems = List<T>.from(widget.initialValue ?? []);
      });
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  bool _isSame(T a, T b) {
    if (widget.idSelector != null) {
      return widget.idSelector!(a) == widget.idSelector!(b);
    }
    return a == b;
  }

  List<T> get _itemsSortedBySelection {
    final selected = _selectedItems;
    return [
      ...widget.items.where((item) => selected.any((s) => _isSame(s, item))),
      ...widget.items.where((item) => !selected.any((s) => _isSame(s, item))),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    const double headerHeight = 148;
    const double itemHeight = 52;
    const double maxPopupHeight = 380;
    final double calculatedHeight =
        headerHeight + (widget.items.length * itemHeight);
    final double popupHeight = calculatedHeight.clamp(180.0, maxPopupHeight);

    return SizedBox(
      width: widget.width,
      child: DropdownSearch<T>.multiSelection(
        key: _key,
        items: _itemsSortedBySelection,
        itemAsString: widget.displayText,
        selectedItems: _selectedItems,
        compareFn: widget.idSelector != null
            ? (a, b) => widget.idSelector!(a) == widget.idSelector!(b)
            : null,
        onBeforePopupOpening: (_) async {
          _searchController.clear();
          return true;
        },
        onChanged: (items) {
          setState(() => _selectedItems = items);
          widget.onSelectionChanged(items);
        },
        enabled: widget.iseditable,

        dropdownBuilder: (context, selectedItems) {
          const int maxVisible = 2;
          final visibleItems = selectedItems.take(maxVisible).toList();
          final extraCount = selectedItems.length - maxVisible;

          return Container(
            constraints: const BoxConstraints(minHeight: 32),
            alignment: Alignment.centerLeft,
            child: selectedItems.isEmpty
                ? Text(
                    widget.hintText,
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                    ),
                  )
                : Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: [
                      ...visibleItems.map((item) {
                        return Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFCE7EE),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color:
                                  const Color(0xFFC03355).withOpacity(0.35),
                              width: 1,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                widget.displayText(item),
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFFC03355),
                                ),
                              ),
                              if (widget.iseditable) ...[
                                const SizedBox(width: 4),
                                GestureDetector(
                                  behavior: HitTestBehavior.opaque,
                                  onTap: () {
                                    final updated =
                                        List<T>.from(_selectedItems)
                                          ..removeWhere(
                                              (s) => _isSame(s, item));
                                    setState(
                                        () => _selectedItems = updated);
                                    widget.onSelectionChanged(updated);
                                  },
                                  child: const Icon(
                                    Icons.close,
                                    size: 14,
                                    color: Color(0xFFC03355),
                                  ),
                                ),
                              ],
                            ],
                          ),
                        );
                      }),
                      if (extraCount > 0)
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            '+$extraCount more',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey[700],
                            ),
                          ),
                        ),
                    ],
                  ),
          );
        },

        dropdownDecoratorProps: DropDownDecoratorProps(
          dropdownSearchDecoration: InputDecoration(
            isDense: true,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            filled: true,
            fillColor: isDark
                ? Colors.grey[850]
                : const Color(0xFFF2F4F6),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: isDark ? Colors.grey[700]! : Colors.grey[300]!,
                width: 1,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: isDark ? Colors.grey[700]! : Colors.grey[300]!,
                width: 1,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: Color(0xFFC03355),
                width: 1,
              ),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: isDark ? Colors.grey[700]! : Colors.grey[300]!,
                width: 1,
              ),
            ),
          ),
        ),

        popupProps: PopupPropsMultiSelection.menu(
          showSearchBox: false,
          searchFieldProps: TextFieldProps(controller: _searchController),
          showSelectedItems: true,
          menuProps: MenuProps(
            backgroundColor: Colors.white,
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          constraints: BoxConstraints(maxHeight: popupHeight),
          onItemAdded: (selectedItems, _) {
            final updated = List<T>.from(selectedItems);
            setState(() => _selectedItems = updated);
            widget.onSelectionChanged(updated);
          },
          onItemRemoved: (selectedItems, _) {
            final updated = List<T>.from(selectedItems);
            setState(() => _selectedItems = updated);
            widget.onSelectionChanged(updated);
          },
          validationWidgetBuilder: (context, __) => const SizedBox.shrink(),
          title: Container(
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Color(0xFFE0E0E0), width: 0.8),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Padding(
                  padding: EdgeInsets.fromLTRB(16, 12, 16, 8),
                  child: Text(
                    'Select Tags',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Search...',
                      filled: true,
                      fillColor: const Color(0xFFF3F4F6),
                      prefixIcon: const Icon(Icons.search, size: 20),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 10),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 6, 16, 10),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: GestureDetector(
                      onTap: () {
                        _searchController.clear();
                        _key.currentState?.closeDropDownSearch();
                      },
                      child: const Text(
                        'Done',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFFC03355),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          selectionWidget: (context, item, isSelected) =>
              const SizedBox.shrink(),
          itemBuilder: (context, item, isSelected) {
            return Container(
              color: Colors.transparent,
              padding: const EdgeInsets.only(
                  left: 16, right: 4, top: 4, bottom: 4),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      widget.displayText(item),
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.normal,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  Checkbox(
                    value: isSelected,
                    onChanged: null,
                    checkColor: Colors.white,
                    fillColor: WidgetStateProperty.resolveWith<Color>(
                      (states) => states.contains(WidgetState.selected)
                          ? const Color(0xFFC03355)
                          : Colors.transparent,
                    ),
                    side: const BorderSide(
                      color: Color(0xFFC03355),
                      width: 1.5,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
