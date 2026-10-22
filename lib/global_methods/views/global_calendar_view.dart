import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../utils/globals.dart';

/// A customizable calendar view widget that displays activities by date.
///
/// [eventsData] should contain a list of maps where each map represents
/// an activity. Each activity must include:
/// - `activity_date_deadline` → String date in ISO format (yyyy-MM-dd)
/// - `name` → Activity title
///
/// Features:
/// - Month navigation (previous/next)
/// - Month & Year picker dialog
/// - Highlight for today's date
/// - Highlight for selected date
/// - Dot indicator for days containing activities
/// - Activity list display for selected date
///
/// The widget adapts automatically to light and dark themes.
class MyCalendarView extends StatefulWidget {
  /// List of activity records grouped by date.
  ///
  /// Each map should contain:
  /// - `activity_date_deadline` (String)
  /// - `name` (String)
  final List<Map<dynamic, dynamic>> eventsData;

  const MyCalendarView({super.key, required this.eventsData});

  @override
  State<MyCalendarView> createState() => _MyCalendarViewState();
}

/// State class for [MyCalendarView].
///
/// Manages:
/// - Currently displayed month
/// - Selected date
/// - Month/year picker dialog
/// - Activity grouping logic
/// - Calendar grid generation
class _MyCalendarViewState extends State<MyCalendarView> {
  late DateTime _displayMonth;
  DateTime? _selectedDate;
  final List<String> months = [
    "January",
    "February",
    "March",
    "April",
    "May",
    "June",
    "July",
    "August",
    "September",
    "October",
    "November",
    "December",
  ];

  /// Generates a list of years centered around the current year.
  ///
  /// Returns a list of 21 years:
  /// (currentYear - 10) to (currentYear + 10)
  List<int> get yearList {
    final currentYear = DateTime.now().year;
    return List.generate(21, (index) => currentYear - 10 + index);
  }

  @override
  void initState() {
    super.initState();
    _displayMonth = DateTime.now();
  }

  /// Returns a list of [DateTime] objects representing
  /// all visible days for a given month.
  ///
  /// Includes placeholder entries (DateTime(0)) at the beginning
  /// to align the first weekday correctly in the grid.
  List<DateTime> _getDaysInMonth(DateTime month) {
    final firstDay = DateTime(month.year, month.month, 1);
    final lastDay = DateTime(month.year, month.month + 1, 0);
    final days = <DateTime>[];

    for (int i = 0; i < firstDay.weekday % 7; i++) {
      days.add(DateTime(0));
    }

    for (int d = 1; d <= lastDay.day; d++) {
      days.add(DateTime(month.year, month.month, d));
    }

    return days;
  }

  /// Groups events by their exact calendar day.
  ///
  /// Converts `activity_date_deadline` strings into DateTime
  /// and normalizes them to year-month-day (without time).
  ///
  /// Returns:
  /// Map<DateTime, List<Map<dynamic, dynamic>>>
  ///
  /// Each key represents a single day.
  Map<DateTime, List<Map<dynamic, dynamic>>> get _eventsByDay {
    final map = <DateTime, List<Map<dynamic, dynamic>>>{};
    for (final event in widget.eventsData) {
      final dateStr = event['activity_date_deadline']?.toString();
      if (dateStr == null || dateStr.isEmpty) continue;

      final date = DateTime.tryParse(dateStr);
      if (date == null) continue;

      final dayKey = DateTime(date.year, date.month, date.day);
      map.putIfAbsent(dayKey, () => []).add(event);
    }
    return map;
  }

  /// Navigates to the previous month.
  ///
  /// Also clears any selected date.
  void _previousMonth() {
    setState(() {
      _displayMonth = DateTime(_displayMonth.year, _displayMonth.month - 1);
      _selectedDate = null;
    });
  }

  /// Navigates to the next month.
  ///
  /// Also clears any selected date.
  void _nextMonth() {
    setState(() {
      _displayMonth = DateTime(_displayMonth.year, _displayMonth.month + 1);
      _selectedDate = null;
    });
  }

  /// Opens a dialog allowing the user to select
  /// a specific month and year.
  ///
  /// Updates [_displayMonth] when confirmed.
  /// Resets the selected date after change.
  Future<void> _showMonthYearPicker() async {
    int tempYear = _displayMonth.year;
    int tempMonthIndex = _displayMonth.month - 1;

    final isDark = Theme.of(context).brightness == Brightness.dark;

    await showDialog(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              backgroundColor: isDark ? const Color(0xFF2A2A2A) : Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              title: Text(
                "Select Month & Year",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.black,
                ),
              ),
              content: SizedBox(
                width: double.maxFinite,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: isDark ? Colors.grey[700]! : Colors.grey[300]!,
                          width: 1,
                        ),
                        color: isDark
                            ? const Color(0xFF333333)
                            : const Color(0xFFF2F4F6),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton2<String>(
                          value: months[tempMonthIndex],
                          isExpanded: true,
                          dropdownStyleData: DropdownStyleData(
                            maxHeight: 200,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: isDark ? Colors.grey[700]! : Colors.grey[400]!,
                                width: 1,
                              ),
                              color: isDark
                                  ? const Color(0xFF444444)
                                  : Colors.white,
                            ),
                          ),
                          iconStyleData: IconStyleData(
                            icon: Icon(Icons.keyboard_arrow_down,
                                color:
                                    isDark ? Colors.white70 : Colors.black54),
                          ),
                          items: months
                              .map((m) =>
                                  DropdownMenuItem(value: m, child: Text(m)))
                              .toList(),
                          onChanged: (val) {
                            if (val != null) {
                              setDialogState(() {
                                tempMonthIndex = months.indexOf(val);
                              });
                            }
                          },
                          buttonStyleData: ButtonStyleData(
                            height: 42,
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: isDark ? Colors.grey[700]! : Colors.grey[300]!,
                          width: 1,
                        ),
                        color: isDark
                            ? const Color(0xFF333333)
                            : const Color(0xFFF2F4F6),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton2<int>(
                          value: tempYear,
                          isExpanded: true,
                          dropdownStyleData: DropdownStyleData(
                            maxHeight: 200,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: isDark ? Colors.grey[700]! : Colors.grey[400]!,
                                width: 1,
                              ),
                              color: isDark
                                  ? const Color(0xFF444444)
                                  : Colors.white,
                            ),
                          ),
                          iconStyleData: IconStyleData(
                            icon: Icon(Icons.keyboard_arrow_down,
                                color:
                                    isDark ? Colors.white70 : Colors.black54),
                          ),
                          items: yearList
                              .map((y) => DropdownMenuItem(
                                  value: y, child: Text(y.toString())))
                              .toList(),
                          onChanged: (val) {
                            if (val != null) {
                              setDialogState(() {
                                tempYear = val;
                              });
                            }
                          },
                          buttonStyleData: ButtonStyleData(
                            height: 42,
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(dialogContext),
                  child: Text('Cancel',
                      style: TextStyle(color: isDark ? Colors.white70 : null)),
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      _displayMonth = DateTime(tempYear, tempMonthIndex + 1);
                      _selectedDate = null;
                    });
                    Navigator.pop(dialogContext);
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  /// Builds the calendar UI.
  ///
  /// Layout includes:
  /// - Month navigation header
  /// - Weekday row (Sun–Sat)
  /// - Calendar grid
  /// - Selected date activity panel
  ///
  /// If no date is selected, a helper message is displayed.
  BoxDecoration _cardDecoration(bool isDark) => BoxDecoration(
        color: isDark ? const Color(0xFF2A2A2A) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withValues(alpha: 0.25)
                : Colors.black.withValues(alpha: 0.07),
            blurRadius: 14,
            spreadRadius: 0,
            offset: const Offset(0, 4),
          ),
        ],
      );

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primary = Theme.of(context).primaryColor;
    final eventsByDay = _eventsByDay;
    final days = _getDaysInMonth(_displayMonth);

    final selectedEvents =
        _selectedDate != null ? eventsByDay[_selectedDate!] ?? [] : <Map>[];

    final sw = MediaQuery.of(context).size.width;

    final hPadding = sw * 0.042;
    final cardInnerH = sw * 0.04;
    final cardInnerV = sw * 0.05;
    final monthFontSize = sw * 0.048;
    final weekdayFontSize = sw * 0.034;
    final dateFontSize = sw * 0.041;
    final chevronSize = sw * 0.08;
    final selectedDateFontSize = sw * 0.044;
    final activityBadgeFontSize = sw * 0.033;
    final activityFontSize = sw * 0.039;
    final dotSize = sw * 0.011;
    final gridAspectRatio = sw < 360 ? 1.0 : 1.1;

    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Padding(
        padding: EdgeInsets.fromLTRB(hPadding, 4, hPadding, hPadding),
        child: Column(
          children: [
            Container(
              decoration: _cardDecoration(isDark),
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                    cardInnerH, cardInnerV, cardInnerH, cardInnerV * 1.2),
                child: Column(
                  children: [
                    Row(
                      children: [
                        IconButton(
                          icon: Icon(Icons.chevron_left, size: chevronSize),
                          onPressed: _previousMonth,
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: _showMonthYearPicker,
                            child: Center(
                              child: Text(
                                DateFormat('MMMM yyyy').format(_displayMonth),
                                style: TextStyle(
                                  fontSize: monthFontSize,
                                  fontWeight: FontWeight.w600,
                                  color:
                                      isDark ? Colors.white : Colors.black87,
                                ),
                              ),
                            ),
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.chevron_right, size: chevronSize),
                          onPressed: _nextMonth,
                        ),
                      ],
                    ),
                    SizedBox(height: sw * 0.05),
                    Row(
                      children:
                          ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat']
                              .map((day) => Expanded(
                                    child: Center(
                                      child: Text(
                                        day,
                                        style: TextStyle(
                                          fontSize: weekdayFontSize,
                                          fontWeight: FontWeight.w600,
                                          color: isDark
                                              ? Colors.white70
                                              : Colors.black54,
                                        ),
                                      ),
                                    ),
                                  ))
                              .toList(),
                    ),
                    SizedBox(height: sw * 0.04),
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 7,
                        childAspectRatio: gridAspectRatio,
                      ),
                      itemCount: days.length,
                      itemBuilder: (context, index) {
                        final date = days[index];
                        final isPlaceholder = date.year == 0;
                        if (isPlaceholder) return const SizedBox.shrink();

                        final now = DateTime.now();
                        final isToday = now.year == date.year &&
                            now.month == date.month &&
                            now.day == date.day;

                        final isSelected = _selectedDate != null &&
                            _selectedDate!.year == date.year &&
                            _selectedDate!.month == date.month &&
                            _selectedDate!.day == date.day;

                        final bool isSunday =
                            date.weekday == DateTime.sunday;

                        final dayEvents = eventsByDay[date] ?? [];
                        final hasEvents = dayEvents.isNotEmpty;

                        return GestureDetector(
                          onTap: () =>
                              setState(() => _selectedDate = date),
                          child: Container(
                            margin: EdgeInsets.all(sw * 0.01),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: isSelected
                                  ? primary.withValues(alpha: 0.15)
                                  : Colors.transparent,
                              border: isToday && !isSelected
                                  ? Border.all(
                                      color: Colors.blue[200]!,
                                      width: 2,
                                    )
                                  : null,
                            ),
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                Text(
                                  '${date.day}',
                                  style: TextStyle(
                                    fontSize: dateFontSize,
                                    fontWeight: isSelected || isToday
                                        ? FontWeight.bold
                                        : FontWeight.w600,
                                    color: isSunday
                                        ? Colors.black54
                                        : (isSelected
                                            ? AppStyle.primaryColor
                                            : Colors.black),
                                  ),
                                ),
                                if (hasEvents)
                                  Positioned(
                                    bottom: sw * 0.008,
                                    left: 0,
                                    right: 0,
                                    child: Center(
                                      child: Container(
                                        width: dotSize,
                                        height: dotSize,
                                        decoration: BoxDecoration(
                                          color: primary,
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: sw * 0.05),
            if (_selectedDate != null)
              Container(
                decoration: _cardDecoration(isDark),
                child: Padding(
                  padding: EdgeInsets.all(sw * 0.042),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: Text(
                              DateFormat('MMM d, yyyy – EEEE')
                                  .format(_selectedDate!),
                              style: TextStyle(
                                fontSize: selectedDateFontSize,
                                fontWeight: FontWeight.w600,
                                color:
                                    isDark ? Colors.white : Colors.black87,
                              ),
                            ),
                          ),
                          SizedBox(width: sw * 0.02),
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: sw * 0.032,
                                vertical: sw * 0.016),
                            decoration: BoxDecoration(
                              color: Colors.blue.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              '${selectedEvents.length} '
                              '${selectedEvents.length == 1 ? "activity" : "activities"}',
                              style: TextStyle(
                                fontSize: activityBadgeFontSize,
                                color: Colors.blue,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: sw * 0.04),
                      if (selectedEvents.isEmpty)
                        Center(
                          child: Padding(
                            padding:
                                EdgeInsets.symmetric(vertical: sw * 0.05),
                            child: Text(
                              'No activities on this day',
                              style: TextStyle(
                                fontSize: activityFontSize,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        )
                      else
                        ...selectedEvents.map((e) {
                          final title =
                              e['name']?.toString() ?? 'Activity';
                          return Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: sw * 0.016),
                            child: Row(
                              children: [
                                Icon(Icons.circle,
                                    size: sw * 0.026, color: primary),
                                SizedBox(width: sw * 0.03),
                                Expanded(
                                  child: Text(
                                    title,
                                    style: TextStyle(
                                        fontSize: activityFontSize),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),
                    ],
                  ),
                ),
              )
            else
              Container(
                decoration: _cardDecoration(isDark),
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: sw * 0.05),
                    child: Text(
                      'Tap a date to view activities',
                      style: TextStyle(
                        fontSize: activityFontSize,
                        color: isDark ? Colors.white70 : Colors.grey[700],
                      ),
                    ),
                  ),
                ),
              ),
            SizedBox(height: sw * 0.08),
          ],
        ),
      ),
    );
  }
}
