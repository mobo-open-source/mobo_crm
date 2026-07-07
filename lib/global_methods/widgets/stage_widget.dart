import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:mobo_crm/utils/globals.dart';

/// A compact, styled widget that displays or edits the stage/status of a CRM record
/// (lead, opportunity, quotation, etc.).
///
/// Two display modes:
///   1. **Read-only badge** (default): Colored pill-shaped tag with stage name
///   2. **Editable dropdown** (when `isEditable: true` and `stageOptions` provided):
///      - Compact dropdown with stage list
///      - Calls `onStageChanged` when selection changes
///
/// Features:
///   - Dynamic color based on stage name (especially for quotations)
///   - Consistent typography and spacing
///   - Optional custom margin and font size
///   - Supports `stageType` to differentiate behavior (e.g. quotation vs lead/opportunity)
///
/// Typical use: Kanban cards, list tiles, detail views, form headers.
class StageWidget extends StatelessWidget {
  final String stageName;
  final bool isEditable;
  final List<String>? stageOptions;
  final Function(String)? onStageChanged;
  final EdgeInsetsGeometry? margin;
  final double? fontSize;
  final String? stageType;

  final bool isExpanded;

  const StageWidget({
    super.key,
    required this.stageName,
    this.isEditable = false,
    this.stageOptions,
    this.onStageChanged,
    this.margin,
    this.fontSize = 12,
    this.stageType,
    this.isExpanded = false,
  });

  /// Returns background/text color based on stage name and optional `stageType`
  ///
  /// Special handling for quotation stages:
  ///   - Draft/Quotation → grey
  ///   - Sent → blue
  ///   - Sales Order → green
  ///   - Locked/Done → teal
  ///   - Cancelled → red
  ///
  /// Falls back to theme primary color for other types.
  Color _getStageColor(BuildContext context) {
    if (stageType == 'quotation') {
      switch (stageName.toLowerCase()) {
        case 'draft':
        case 'quotation':
          return Colors.grey;
        case 'quotation sent':
        case 'sent':
          return Colors.blue;
        case 'sales order':
        case 'sale order':
        case 'sale':
          return Colors.green;
        case 'locked':
        case 'done':
          return Colors.teal;
        case 'cancelled':
        case 'cancel':
          return Colors.red;
        default:
          return Colors.grey;
      }
    }
    return Theme.of(context).primaryColor;
  }

  @override
  Widget build(BuildContext context) {
    final stageColor = _getStageColor(context);

    if (isEditable && stageOptions != null && stageOptions!.isNotEmpty) {
      final uniqueOptions = stageOptions!.toSet().toList();

      String effectiveValue = stageName;
      if (!uniqueOptions.contains(stageName)) {
        effectiveValue = uniqueOptions.first;
      }
      if (isExpanded) {
        return DropdownSearch<String>(
          items: uniqueOptions,
          selectedItem: effectiveValue,
          enabled: isEditable,
          popupProps: PopupProps.menu(
            showSearchBox: true,
            fit: FlexFit.loose,
            constraints: const BoxConstraints(maxHeight: 320),
            menuProps: MenuProps(
              backgroundColor: Colors.white,
              elevation: 12,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
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
          ),
          dropdownDecoratorProps: DropDownDecoratorProps(
            dropdownSearchDecoration: InputDecoration(
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
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: AppStyle.primaryColor, width: 2),
              ),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            ),
          ),
          onChanged: (String? newValue) {
            if (newValue != null && onStageChanged != null) {
              onStageChanged!(newValue);
            }
          },
          dropdownBuilder: (context, selectedItem) {
            return Text(
              selectedItem ?? effectiveValue,
              style: TextStyle(
                fontSize: 16,
                color: Colors.black,
                fontWeight: FontWeight.w500,
              ),
            );
          },
        );
      }

      return Container(
        margin: margin ?? const EdgeInsets.only(right: 8),
        child: DropdownButtonHideUnderline(
          child: DropdownButton2<String>(
            value: effectiveValue,
            isDense: true,
            isExpanded: isExpanded,
            buttonStyleData: ButtonStyleData(
              height: 48,
              width: isExpanded ? double.infinity : null,
              padding: EdgeInsets.only(
                  left: isExpanded ? 12 : 1, right: isExpanded ? 12 : 4),
              decoration: BoxDecoration(
                border: Border.all(
                    color: isExpanded ? Colors.transparent : Colors.grey),
                borderRadius: BorderRadius.circular(isExpanded ? 12 : 8),
                color: isExpanded ? const Color(0xFFF2F4F6) : Colors.white,
              ),
            ),
            dropdownStyleData: const DropdownStyleData(
              maxHeight: 300,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(8)),
              ),
            ),
            iconStyleData: const IconStyleData(
              icon: Icon(
                Icons.keyboard_arrow_down,
                color: Colors.grey,
              ),
            ),
            items: stageOptions!.map((String stage) {
              return DropdownMenuItem<String>(
                value: stage,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                  child: Text(
                    stage,
                    style: TextStyle(
                      fontSize: fontSize,
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              );
            }).toList(),
            onChanged: (String? newValue) {
              if (newValue != null && onStageChanged != null) {
                onStageChanged!(newValue);
              }
            },
            selectedItemBuilder: (BuildContext context) {
              return stageOptions!.map<Widget>((String stage) {
                return Text(
                  stage,
                  style: TextStyle(
                    fontSize: fontSize,
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                  ),
                );
              }).toList();
            },
          ),
        ),
      );
    }

    return Container(
      margin: margin ?? const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: stageColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        stageName,
        style: TextStyle(
          fontSize: fontSize,
          color: stageColor,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
