import 'package:cached_network_image/cached_network_image.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../forms/mobo_dropdown_option_tile.dart';
import '../forms/mobo_dropdown_styles.dart';

/// Single Select Searchable Dropdown using dropdown_search package
/// Supports: real-time search, images (with custom headers), editable mode, initial value
class SingleSelectSearchableDropdown<T> extends StatelessWidget {
  final List<T> items;
  final String Function(T) displayText;
  final void Function(T?) onSelectionChanged;
  final String hintText;
  final double width;
  final bool isEditable;
  final bool hasImage;
  final T? initialValue;
  final bool showMessage;
  final String message;
  final String Function(T)? imageUrl;
  final Map<String, String>? Function(T)? httpHeaders;

  /// Shows a clear (x) button once a value is picked and the field is
  /// editable; pressing it reports `null` through [onSelectionChanged], so
  /// the caller must empty its value there. On by default — turn it off only
  /// for a selection that has no empty state.
  final bool allowClear;

  const SingleSelectSearchableDropdown({
    super.key,
    required this.items,
    required this.displayText,
    required this.onSelectionChanged,
    required this.hintText,
    this.width = 300,
    this.isEditable = true,
    this.hasImage = false,
    this.initialValue,
    this.showMessage = false,
    this.message = 'Please enable edit mode',
    this.imageUrl,
    this.httpHeaders,
    this.allowClear = true,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return SizedBox(
      width: double.infinity,
      child: DropdownSearch<T>(
        items: items,
        selectedItem: initialValue,
        enabled: isEditable,
        dropdownButtonProps:
            MoboDropdownStyles.button(isDark, enabled: isEditable),
        clearButtonProps: MoboDropdownStyles.clearButton(isDark,
            visible: allowClear && isEditable),
        popupProps: PopupProps.menu(
          showSearchBox: true,
          menuProps: MoboDropdownStyles.menu(isDark),
          searchFieldProps: MoboDropdownStyles.searchField(isDark),
          emptyBuilder: (context, searchEntry) =>
              MoboDropdownStyles.empty(isDark),
          constraints: MoboDropdownStyles.popupConstraints,
          itemBuilder: (context, item, isSelected) => MoboDropdownOptionTile(
            title: displayText(item),
            isSelected: isSelected,
          ),
        ),
        dropdownDecoratorProps:
            MoboDropdownStyles.decorator(isDark, hintText: "Select $hintText"),
        onChanged: (value) {
          onSelectionChanged(value);
        },
        dropdownBuilder: (context, selectedItem) {
          if (selectedItem == null) {
            return MoboDropdownStyles.hint("Select $hintText", isDark);
          }

          if (!hasImage || imageUrl == null) {
            return MoboDropdownStyles.value(displayText(selectedItem), isDark,
                enabled: isEditable);
          }

          final imgUrl = imageUrl!(selectedItem);
          final itemName = displayText(selectedItem);
          final initial =
              itemName.isNotEmpty ? itemName[0].toUpperCase() : '?';
          return Row(
            children: [
              if (imgUrl.isNotEmpty)
                CachedNetworkImage(
                  imageUrl: imgUrl,
                  httpHeaders: httpHeaders?.call(selectedItem),
                  width: 32,
                  height: 32,
                  fit: BoxFit.cover,
                  imageBuilder: (context, imageProvider) => CircleAvatar(
                    backgroundImage: imageProvider,
                  ),
                  placeholder: (context, url) => Shimmer.fromColors(
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
                    child: const CircleAvatar(radius: 16),
                  ),
                  errorWidget: (context, url, error) => CircleAvatar(
                    radius: 16,
                    backgroundColor: Colors.grey[400],
                    child: Text(
                      initial,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              const SizedBox(width: 12),
              Expanded(
                child: MoboDropdownStyles.value(
                    displayText(selectedItem), isDark,
                    enabled: isEditable),
              ),
            ],
          );
        },
      ),
    );
  }
}
