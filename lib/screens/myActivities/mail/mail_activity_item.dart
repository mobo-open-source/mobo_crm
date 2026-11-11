import 'package:html/parser.dart' as html_parser;
import 'package:intl/intl.dart';

/// One `mail.activity` row, normalised for display.
///
/// Odoo returns `false` (not `null`) for every empty field and the shape
/// differs a little between releases:
/// - `res_name` / `res_model` / `res_id` are `false` for activities that are
///   not linked to a document (possible since Odoo 19).
/// - Odoo 20 pre-fills `summary` with the activity type's name.
/// - `note` is HTML and is often just `<p><br></p>`.
///
/// Parsing everything here keeps the widgets free of `false`/`null` checks and
/// guarantees a value is either real text or `null` — never `"false"`.
class MailActivityItem {
  const MailActivityItem({
    required this.id,
    required this.title,
    required this.typeName,
    required this.state,
    required this.assignedTo,
    this.documentName,
    this.summary,
    this.note,
    this.deadline,
    this.resModel,
    this.resId,
  });

  final int id;

  /// Best available heading: document name, else summary, else type name.
  final String title;

  /// `res_name` — the record the activity belongs to (null when unlinked).
  final String? documentName;

  /// Activity type, e.g. "Call" or "To-Do".
  final String typeName;

  /// Summary, or null when empty or merely repeating [typeName].
  final String? summary;

  /// Note as plain text, or null when it has no visible content.
  final String? note;

  /// Due date (local midnight), or null when none is set.
  final DateTime? deadline;

  /// `overdue`, `today`, `planned`, `done`, or `none` when there is no due date.
  final String state;

  final String assignedTo;
  final String? resModel;
  final int? resId;

  static const Set<String> _serverStates = {
    'overdue',
    'today',
    'planned',
    'done',
  };

  /// Builds an item from a `search_read` row (or a cached copy of one).
  ///
  /// The server's computed `state` is preferred because Odoo evaluates it in
  /// the assignee's timezone; the device clock is only a fallback for rows
  /// that carry no `state` (older servers, offline cache).
  factory MailActivityItem.fromJson(Map<String, dynamic> json,
      {DateTime? now}) {
    final typeName = _many2oneName(json['activity_type_id']) ?? 'Activity';
    final documentName = _text(json['res_name']);
    final rawSummary = _text(json['summary']);
    final deadline = _date(json['date_deadline']);

    final serverState = _text(json['state']);
    final state = serverState != null && _serverStates.contains(serverState)
        ? serverState
        : _stateFromDeadline(deadline, now ?? DateTime.now());

    return MailActivityItem(
      id: json['id'] is int ? json['id'] as int : 0,
      title: documentName ?? rawSummary ?? typeName,
      documentName: documentName,
      typeName: typeName,
      // An activity with no linked document is headed by its own summary (see
      // [title]), so showing it again as a row would only repeat the heading.
      summary: documentName == null ||
              (rawSummary != null &&
                  rawSummary.toLowerCase() == typeName.toLowerCase())
          ? null
          : rawSummary,
      note: htmlToPlainText(json['note']),
      deadline: deadline,
      state: state,
      assignedTo: _many2oneName(json['user_id']) ?? 'Unassigned',
      resModel: _text(json['res_model']),
      resId: json['res_id'] is int ? json['res_id'] as int : null,
    );
  }

  /// Whole days between today and [deadline]: negative when past.
  int? daysFromToday([DateTime? now]) {
    final due = deadline;
    if (due == null) return null;
    final today = now ?? DateTime.now();
    // UTC midnights keep the difference exact across daylight-saving shifts.
    return DateTime.utc(due.year, due.month, due.day)
        .difference(DateTime.utc(today.year, today.month, today.day))
        .inDays;
  }

  /// Short status word for the badge.
  String get stateLabel {
    switch (state) {
      case 'overdue':
        return 'Overdue';
      case 'today':
        return 'Today';
      case 'planned':
        return 'Planned';
      case 'done':
        return 'Done';
      default:
        return 'No due date';
    }
  }

  /// Due date as `04 Nov 2026`, or `No due date`.
  String get deadlineText =>
      deadline == null ? 'No due date' : DateFormat('dd MMM yyyy').format(deadline!);

  /// Relative wording that always agrees with [state], e.g. `3 days overdue`,
  /// `Today`, `Tomorrow`, `In 5 days`.
  String relativeDueText([DateTime? now]) {
    final days = daysFromToday(now);
    if (days == null) return '';
    switch (state) {
      case 'today':
        return 'Today';
      case 'overdue':
        final daysLate = -days;
        if (daysLate <= 0) return 'Overdue';
        return daysLate == 1 ? '1 day overdue' : '$daysLate days overdue';
      case 'planned':
        if (days <= 0) return 'Planned';
        return days == 1 ? 'Tomorrow' : 'In $days days';
      default:
        return '';
    }
  }

  // ── helpers ──────────────────────────────────────────────────────────────

  /// Text, or null for `null`, `false`, `"false"`, `"null"` and blanks.
  static String? _text(dynamic value) {
    if (value == null || value is bool) return null;
    final text = value.toString().trim();
    if (text.isEmpty || text == 'false' || text == 'null') return null;
    return text;
  }

  /// Display name of a many2one (`[id, name]`), or null when unset.
  static String? _many2oneName(dynamic value) {
    if (value is List && value.length > 1) return _text(value[1]);
    if (value is Map) return _text(value['display_name'] ?? value['name']);
    return null;
  }

  static DateTime? _date(dynamic value) {
    final text = _text(value);
    if (text == null) return null;
    // `date_deadline` is a Date, but tolerate a datetime string too.
    return DateTime.tryParse(text.length >= 10 ? text.substring(0, 10) : text);
  }

  static String _stateFromDeadline(DateTime? deadline, DateTime now) {
    if (deadline == null) return 'none';
    final due = DateTime.utc(deadline.year, deadline.month, deadline.day);
    final today = DateTime.utc(now.year, now.month, now.day);
    final days = due.difference(today).inDays;
    if (days == 0) return 'today';
    return days < 0 ? 'overdue' : 'planned';
  }

  /// Converts an HTML note to plain text, keeping paragraph and line breaks.
  ///
  /// Returns null when nothing visible is left (e.g. `<p><br></p>`).
  static String? htmlToPlainText(dynamic raw) {
    final html = _text(raw);
    if (html == null) return null;
    final withBreaks = html
        .replaceAll(RegExp(r'<br\s*/?>', caseSensitive: false), '\n')
        .replaceAll(
            RegExp(r'</(p|div|li|ul|ol|h[1-6]|tr)>', caseSensitive: false),
            '\n');
    final text = html_parser.parse(withBreaks).body?.text ?? '';
    final lines = text
        .split('\n')
        .map((line) => line.trim())
        .where((line) => line.isNotEmpty)
        .toList();
    return lines.isEmpty ? null : lines.join('\n');
  }
}

/// Activities of one group plus where they came from.
class MailActivityList {
  const MailActivityList({required this.items, this.fromCache = false});

  final List<MailActivityItem> items;

  /// True when the server could not be reached and the saved copy is shown.
  final bool fromCache;

  int countWhere(String state) =>
      items.where((item) => item.state == state).length;
}
