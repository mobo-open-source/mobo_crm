import 'package:cached_network_image/cached_network_image.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

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
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: DropdownSearch<T>(
        items: items,
        selectedItem: initialValue,
        enabled: isEditable,
        popupProps: PopupProps.menu(
          showSearchBox: true,
          menuProps: MenuProps(
            backgroundColor: Colors.white,
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
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
          constraints: BoxConstraints(maxHeight: 320),
          itemBuilder: (context, item, isSelected) {
            return ListTile(
              title: Text(
                displayText(item),
                style: TextStyle(
                  color: Colors.black87,
                  fontWeight:
                      isSelected ? FontWeight.w600 : FontWeight.w400,
                ),
              ),
            );
          },
        ),
        dropdownDecoratorProps: DropDownDecoratorProps(
          dropdownSearchDecoration: InputDecoration(
            hintText: "Select $hintText",
            hintStyle: TextStyle(
              fontWeight: FontWeight.w400,
              color: Colors.grey[600],
              fontStyle: FontStyle.italic,
            ),
            filled: true,
            fillColor: const Color(0xFFF2F4F6),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
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
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          ),
        ),
        onChanged: (value) {
          onSelectionChanged(value);
        },
        dropdownBuilder: (context, selectedItem) {
          if (selectedItem == null) {
            return Text(
              "Select $hintText",
              style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 15,
                color: Colors.grey[600],
                fontStyle: FontStyle.italic,
              ),
            );
          }

          if (!hasImage || imageUrl == null) {
            return Text(
              displayText(selectedItem),
              style: TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            );
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
                child: Text(
                  displayText(selectedItem),
                  style: TextStyle(
                    color: Colors.black87,
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
