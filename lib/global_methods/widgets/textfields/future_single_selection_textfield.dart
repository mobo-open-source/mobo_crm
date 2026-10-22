import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../../utils/app_theme.dart';
import '../../../utils/snackbar.dart';
import '../forms/mobo_dropdown_option_tile.dart';
import '../forms/mobo_dropdown_styles.dart';

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

  /// Shows a clear (x) button once a value is picked and the field is
  /// enabled; pressing it reports `null` through [onSelectionChanged], so
  /// the caller must empty its value there. On by default — turn it off only
  /// for a selection that has no empty state.
  final bool allowClear;

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
    this.allowClear = true,
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
      // This runs while the parent is building, so the field only blanks
      // itself here (the rebuild that follows hands DropdownSearch the new
      // value). Telling the owner has to wait for the frame to finish: its
      // setState throws if called mid-build.
      _selectedItem = null;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) widget.onSelectionChanged(null);
      });
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
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
                return MoboDropdownStyles.hint(widget.hintText, isDark);
              }
              return MoboDropdownStyles.value(
                  widget.displayText(selectedItem), isDark,
                  enabled: isEnabled);
            },
            dropdownButtonProps:
                MoboDropdownStyles.button(isDark, enabled: isEnabled),
            clearButtonProps: MoboDropdownStyles.clearButton(isDark,
                visible: widget.allowClear && isEnabled),
            compareFn: widget.idSelector != null
                ? (a, b) => widget.idSelector!(a) == widget.idSelector!(b)
                : null,
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
            dropdownDecoratorProps:
                MoboDropdownStyles.decorator(isDark, hintText: widget.hintText),
            popupProps: PopupProps.menu(
              showSearchBox: true,
              showSelectedItems: widget.idSelector != null,
              searchFieldProps: MoboDropdownStyles.searchField(isDark),
              loadingBuilder: (context, searchEntry) =>
                  MoboDropdownStyles.loading(),
              emptyBuilder: (context, searchEntry) =>
                  MoboDropdownStyles.empty(isDark),
              itemBuilder: (context, item, isSelected) {
                Widget? leading;
                if (widget.hasImage && widget.imageUrl != null) {
                  final url = widget.imageUrl!(item);
                  leading = ClipRRect(
                    borderRadius: BorderRadius.circular(AppRadius.segment),
                    child: url.isEmpty
                        ? const SizedBox(width: 32, height: 32)
                        : CachedNetworkImage(
                            imageUrl: url,
                            httpHeaders: widget.httpHeaders?.call(item),
                            width: 32,
                            height: 32,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => Shimmer.fromColors(
                              baseColor: Colors.grey[300]!,
                              highlightColor: Colors.grey[100]!,
                              child: Container(
                                  width: 32, height: 32, color: Colors.white),
                            ),
                            errorWidget: (context, url, error) => const Icon(
                                Icons.image_not_supported,
                                size: 32),
                          ),
                  );
                }
                return MoboDropdownOptionTile(
                  title: widget.displayText(item),
                  leading: leading,
                  isSelected: isSelected,
                );
              },
              menuProps: MoboDropdownStyles.menu(isDark),
              constraints: MoboDropdownStyles.popupConstraints,
            ),
            enabled: isEnabled,
          ),
        ),
      ),
    );
  }
}
