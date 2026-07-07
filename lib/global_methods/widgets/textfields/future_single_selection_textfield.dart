import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../../utils/snackbar.dart';

/// Single-select searchable dropdown with async item loading support
/// using the `dropdown_search` package for better reliability and features.
class SingleSelectSearchableFuture<T> extends StatefulWidget {
  final List<T> items;
  final String Function(T) displayText;
  final void Function(T?) onSelectionChanged;
  final String hintText;
  final double width;
  final bool isEditable;
  final bool hasImage;
  final T? initialValue;
  final String Function(T)? imageUrl;
  final Map<String, String>? Function(T)? httpHeaders;
  final Future<List<T>> Function()? onEmptyItemsFetch;
  final bool isLoading;
  final bool refresh;
  final bool clear;
  final String message;
  final bool showMessage;
  final dynamic Function(T)? idSelector;

  const SingleSelectSearchableFuture({
    super.key,
    required this.items,
    required this.displayText,
    required this.onSelectionChanged,
    required this.hintText,
    this.width = 300,
    this.hasImage = false,
    this.imageUrl,
    this.httpHeaders,
    this.initialValue,
    this.onEmptyItemsFetch,
    this.isLoading = false,
    this.refresh = false,
    this.clear = false,
    this.isEditable = true,
    this.message = 'Please enable edit mode',
    this.showMessage = false,
    this.idSelector,
  });

  @override
  State<SingleSelectSearchableFuture<T>> createState() =>
      _SingleSelectSearchableFutureState<T>();
}

class _SingleSelectSearchableFutureState<T>
    extends State<SingleSelectSearchableFuture<T>> {
  T? _selectedItem;
  final _dropdownKey = GlobalKey<DropdownSearchState<T>>();

  @override
  void initState() {
    super.initState();
    _selectedItem = widget.initialValue;
  }

  @override
  void didUpdateWidget(covariant SingleSelectSearchableFuture<T> oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.clear && _selectedItem != null) {
      setState(() => _selectedItem = null);
      widget.onSelectionChanged(null);
      _dropdownKey.currentState?.clear();
    }

    if (widget.initialValue != oldWidget.initialValue) {
      setState(() => _selectedItem = widget.initialValue);
    }
  }

  Future<List<T>> _fetchItems(String? filter) async {
    if (widget.items.isNotEmpty && widget.onEmptyItemsFetch == null) {
      return widget.items
          .where((item) => widget
              .displayText(item)
              .toLowerCase()
              .contains(filter?.toLowerCase() ?? ''))
          .toList();
    }

    if ((widget.refresh || widget.items.isEmpty) &&
        widget.onEmptyItemsFetch != null) {
      try {
        final fetched = await widget.onEmptyItemsFetch!();
        return fetched
            .where((item) => widget
                .displayText(item)
                .toLowerCase()
                .contains(filter?.toLowerCase() ?? ''))
            .toList();
      } catch (e) {
        return [];
      }
    }

    return widget.items;
  }

  @override
  Widget build(BuildContext context) {
    final isEnabled = widget.isEditable && !(widget.isLoading);

    return GestureDetector(
      onTap: !isEnabled
          ? () {
              if (widget.showMessage) {
                CustomSnackbar.showWarning(context, widget.message);
              } else {
                CustomSnackbar.showWarning(context, 'Please enable edit mode');
              }
            }
          : null,
      child: AbsorbPointer(
        absorbing: !isEnabled,
        child: SizedBox(
          width: double.infinity,
          child: DropdownSearch<T>(
            dropdownBuilder: (context, selectedItem) {
              if (selectedItem == null) {
                return Text(
                  widget.hintText,
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    color: Colors.grey[600],
                    fontStyle: FontStyle.italic,
                  ),
                );
              }

              return Text(
                widget.displayText(selectedItem),
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: isEnabled
                      ? const Color(0xff000000)
                      : Colors.grey,
                    fontSize: 16
                ),
              );
            },
            key: _dropdownKey,
            selectedItem: _selectedItem,
            items: widget.items.isNotEmpty ? widget.items : [],
            asyncItems: widget.onEmptyItemsFetch != null || widget.refresh
                ? (filter) => _fetchItems(filter)
                : null,
            itemAsString: widget.displayText,
            onChanged: (item) {
              setState(() => _selectedItem = item);
              widget.onSelectionChanged(item);
            },
            dropdownDecoratorProps: DropDownDecoratorProps(
              dropdownSearchDecoration: InputDecoration(
                hintText: widget.hintText,
                hintStyle: TextStyle(
                  fontWeight: FontWeight.w400,
                  color: Colors.grey[600],
                  fontStyle: FontStyle.italic,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                  borderSide: BorderSide(
                    color: Color(0xFFC03355),
                    width: 1.5,
                  ),
                ),
                filled: true,
                fillColor: const Color(0xFFF2F4F6),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 12,
                ),
              ),
            ),
            popupProps: PopupProps.menu(
              showSearchBox: true,
              searchFieldProps: TextFieldProps(
                decoration: InputDecoration(
                  hintText: "Search...",
                  filled: true,
                  fillColor: const Color(0xFFF3F4F6),
                  prefixIcon: const Icon(Icons.search),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 12,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      color: Colors.grey[400]!,
                      width: 1,
                    ),
                  ),
                ),
              ),
              loadingBuilder: (context, searchEntry) => const Center(
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
              emptyBuilder: (context, searchEntry) => const Center(
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Text('No items found'),
                ),
              ),
              itemBuilder: widget.hasImage && widget.imageUrl != null
                  ? (context, item, isSelected) {
                      final url = widget.imageUrl!(item);
                      final headers = widget.httpHeaders?.call(item);

                      return Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 10),
                        color: isSelected
                            ? Theme.of(context).primaryColor.withOpacity(0.1)
                            : null,
                        child: Row(
                          children: [
                            if (url.isNotEmpty)
                              ClipRRect(
                                borderRadius: BorderRadius.circular(6),
                                child: CachedNetworkImage(
                                  imageUrl: url,
                                  httpHeaders: headers,
                                  width: 32,
                                  height: 32,
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) =>
                                      Shimmer.fromColors(
                                    baseColor: Colors.grey[300]!,
                                    highlightColor: Colors.grey[100]!,
                                    child: Container(
                                      width: 32,
                                      height: 32,
                                      color: Colors.white,
                                    ),
                                  ),
                                  errorWidget: (context, url, error) =>
                                      const Icon(Icons.image_not_supported,
                                          size: 32),
                                ),
                              )
                            else
                              const SizedBox(width: 32, height: 32),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                widget.displayText(item),
                                style: const TextStyle(fontSize: 15),
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                  : null,
              menuProps: MenuProps(
                backgroundColor: Colors.white,
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              constraints: BoxConstraints(maxHeight: 320),
            ),
            enabled: isEnabled,
          ),
        ),
      ),
    );
  }
}
