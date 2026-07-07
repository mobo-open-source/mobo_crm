import 'package:flutter/material.dart';
import 'package:mention_tag_text_field/mention_tag_text_field.dart';
import 'package:mobo_crm/global_methods/const.dart';
import 'package:mobo_crm/models/models.dart';
import 'package:odoo_rpc/odoo_rpc.dart';

import '../../../core/company/session/company_session_manager.dart';

/// A multiline text field with @mention support that fetches and displays
/// customer suggestions from Odoo (`res.partner`) in real-time.
///
/// Features:
///   - Triggers suggestions when user types `@` followed by text
///   - Fetches matching customers via `search_read` (name ilike query)
///   - Displays results in a positioned overlay below the field
///   - Supports custom mention styling via `MyCustomTag`
///   - Calls `onMentionTapped` with updated mentions list and full text
///   - Calls `onTextChanged` on every text change
///   - Dismisses overlay on outside tap or selection
///
/// Dependencies:
///   - `mention_tag_text_field` package for mention parsing & rendering
///   - `OdooClient` from `odoo_rpc` for backend queries
class MentionTagTextFieldExample extends StatefulWidget {
  final OdooClient client;
  final String hintText;

  final void Function(dynamic value, String text)? onTextChanged;
  final void Function(dynamic value, String text)? onMentionTapped;
  final Widget? prefixIcon;
  final Widget? suffixIcon;

  const MentionTagTextFieldExample({
    super.key,
    required this.client,
    required this.hintText,
    this.onMentionTapped,
    this.onTextChanged,
    this.prefixIcon,
    this.suffixIcon,
  });

  @override
  State<MentionTagTextFieldExample> createState() =>
      _MentionTagTextFieldExampleState();
}

class _MentionTagTextFieldExampleState
    extends State<MentionTagTextFieldExample> {
  final MentionTagTextEditingController _controller =
      MentionTagTextEditingController();
  final GlobalKey _textFieldKey = GlobalKey();

  /// Overlay showing customer suggestions
  OverlayEntry? _overlayEntry;
  String? mentionValue;

  /// List of matching customers from Odoo
  List<CustomerItem> searchResults = [];

  @override
  void initState() {
    super.initState();
    _controller.setText = "";
  }

  @override
  void dispose() {
    _removeOverlay();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        mentionField(),
      ],
    );
  }

  /// Builds the main mention-enabled text field
  Widget mentionField() {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[850] : Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF000000).withOpacity(0.04),
            offset: const Offset(0, 1),
            blurRadius: 3,
            spreadRadius: 0,
          ),
        ],
      ),
      child: MentionTagTextField(
        key: _textFieldKey,
        keyboardType: TextInputType.multiline,
        minLines: 1,
        maxLines: 5,
        controller: _controller,
        onMention: (value) => onMention(value),
        onChanged: (value) {
          if (widget.onTextChanged != null) {
            widget.onTextChanged!(_controller.mentions, _controller.getText);
          }
        },
        mentionTagDecoration: MentionTagDecoration(
          mentionStart: ['@', '#'],
          mentionBreak: ' ',
          allowDecrement: false,
          allowEmbedding: false,
          showMentionStartSymbol: false,
          maxWords: null,
          mentionTextStyle: const TextStyle(
            color: Colors.blue,
          ),
        ),
        decoration: InputDecoration(
          isDense: true,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          filled: true,
          fillColor: isDark ? Colors.grey[850] : Colors.white,
          border: InputBorder.none,
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: Theme.of(context).primaryColor,
              width: 1.5,
            ),
          ),
          hintText: widget.hintText,
          prefixIcon: widget.prefixIcon,
          suffixIcon: widget.suffixIcon,
          hintStyle: TextStyle(
            color: isDark
                ? Colors.white70
                : const Color(0xff1E1E1E).withOpacity(0.7),
            fontWeight: FontWeight.w400,
            fontSize: 15,
            height: 1.0,
          ),
        ),
      ),
    );
  }

  /// Shows overlay with customer suggestions below the text field
  void _showOverlay() {
    _removeOverlay();
    _overlayEntry = _createOverlayEntry();
    Overlay.of(context).insert(_overlayEntry!);
  }

  /// Creates the positioned overlay with search results
  OverlayEntry _createOverlayEntry() {
    final RenderBox? textFieldBox =
        _textFieldKey.currentContext?.findRenderObject() as RenderBox?;
    if (textFieldBox == null) {
      return OverlayEntry(builder: (context) => const SizedBox.shrink());
    }

    final offset = textFieldBox.localToGlobal(Offset.zero);
    final screenHeight = MediaQuery.of(context).size.height;
    final textFieldTop = offset.dy;
    final textFieldBottom = offset.dy + textFieldBox.size.height;
    final spaceBelow = screenHeight - textFieldBottom;
    final halfScreen = screenHeight / 2;
    const dropdownHeight = 200.0;

    bool showAbove = spaceBelow < halfScreen && textFieldTop > dropdownHeight;

    double topPosition =
        showAbove ? textFieldTop - dropdownHeight - 5 : textFieldBottom + 15;

    return OverlayEntry(
      builder: (context) => GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          _removeOverlay();
          mentionValue = null;
          searchResults.clear();
          setState(() {});
        },
        child: Stack(
          children: [
            Positioned.fill(
              child: Container(color: Colors.transparent),
            ),
            Positioned(
              width: textFieldBox.size.width,
              left: offset.dx,
              top: topPosition,
              child: Card(
                elevation: 4.0,
                color: AppColors().fillColor,
                child: SizedBox(
                  height: dropdownHeight,
                  width: textFieldBox.size.width,
                  child: searchResults.isEmpty
                      ? Center(
                          child: CircularProgressIndicator(
                          color: Theme.of(context).primaryColor,
                        ))
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          itemCount: searchResults.length,
                          itemBuilder: (context, index) {
                            final item = searchResults[index];
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              child: Material(
                                color: Colors.transparent,
                                borderRadius: BorderRadius.circular(8),
                                child: InkWell(
                                  onTap: () {
                                    final mentionIndex =
                                        _controller.mentions.length;
                                    _controller.addMention(
                                      label: item.name,
                                      data: item,
                                      stylingWidget: MyCustomTag(
                                        controller: _controller,
                                        text: item.name,
                                        index: mentionIndex,
                                      ),
                                    );
                                    widget.onMentionTapped!(
                                      _controller.mentions,
                                      _controller.getText,
                                    );
                                    mentionValue = null;
                                    searchResults.clear();
                                    _removeOverlay();
                                    setState(() {});
                                  },
                                  borderRadius: BorderRadius.circular(8),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 12),
                                    child: Row(
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              item.name,
                                              style:
                                                  const TextStyle(fontSize: 14),
                                            ),
                                            Text(
                                              item.email.isNotEmpty
                                                  ? item.email
                                                  : item.fullname,
                                              style: TextStyle(
                                                  color: Colors.grey.shade400,
                                                  fontSize: 12),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Removes the overlay if it exists
  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  /// Triggered when user types @mention pattern
  Future<void> onMention(String? value) async {
    mentionValue = value;
    setState(() {});
    if (value == null || !value.startsWith('@')) {
      _removeOverlay();
      searchResults.clear();
      return;
    }

    final input = value.substring(1);
    searchResults = await fetchCustomers(input);
    if (searchResults.isNotEmpty && mentionValue != null) {
      _showOverlay();
    }

    setState(() {});
  }

  /// Fetches customers from Odoo matching the search input
  Future<List<CustomerItem>> fetchCustomers(String input) async {
    try {
      final response = await CompanySessionManager.callKwWithCompany({
        'model': 'res.partner',
        'method': 'search_read',
        'args': [
          [
            ['name', 'ilike', '%$input']
          ]
        ],
        'kwargs': {
          'fields': ['name', 'complete_name', 'email'],
          'limit': 10,
        },
      });

      return (response as List)
          .map((json) => CustomerItem.fromJson(json))
          .toList();
    } catch (e) {
      return [];
    }
  }
}

/// Custom mention tag widget rendered inside the text field
class MyCustomTag extends StatelessWidget {
  const MyCustomTag({
    super.key,
    required this.controller,
    required this.text,
    required this.index,
  });

  final MentionTagTextEditingController controller;
  final String text;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            text,
            style: const TextStyle(
              color: Colors.blue,
            ),
          ),
        ],
      ),
    );
  }
}
