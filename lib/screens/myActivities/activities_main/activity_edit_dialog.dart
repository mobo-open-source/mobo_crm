import 'package:flutter/material.dart';

import '../../../core/company/session/company_session_manager.dart';
import '../../../core/navigation/data_loss_warning_dialog.dart';
import '../../../global_methods/widgets/date_picker/custom_date_picker.dart';
import '../../../global_methods/widgets/forms/field_label.dart';
import '../../../global_methods/widgets/textfields/future_single_selection_textfield.dart';
import '../../../models/activity_model/activity_model.dart';
import '../../../models/models.dart';
import '../../../utils/app_theme.dart';
import '../../../utils/globals.dart';

/// Dialog for editing an existing activity and returning the changes via [onSave].
class ActivityEditDialog extends StatefulWidget {
  final Map<String, dynamic> activity;
  final Function(Map<String, dynamic>) onSave;

  const ActivityEditDialog({
    super.key,
    required this.activity,
    required this.onSave,
  });

  @override
  State<ActivityEditDialog> createState() => _ActivityEditDialogState();
}

class _ActivityEditDialogState extends State<ActivityEditDialog> {
  late TextEditingController summaryController;
  late TextEditingController noteController;
  String? selectedDate;
  ActivityType? selectedActivity;
  String? activityTypeError;
  SalesPersonItem? selectedAssignee;
  String? assigneeError;

  String? _initialDate;
  int? _initialActivityId;
  int? _initialAssigneeId;
  String _initialSummary = '';
  String _initialNote = '';

  @override
  void initState() {
    super.initState();
    if (widget.activity['activity_type_id'] != null &&
        widget.activity['activity_type_id'] is List) {
      final activityData = widget.activity['activity_type_id'];
      selectedActivity = ActivityType(
        id: activityData[0],
        name: activityData[1],
      );
    }
    if (widget.activity['user_id'] != null &&
        widget.activity['user_id'] is List) {
      final user = widget.activity['user_id'];
      selectedAssignee = SalesPersonItem(
        id: user[0],
        name: user[1],
        teamid: 0,
        teamName: "",
      );
    }

    summaryController =
        TextEditingController(text: widget.activity['summary'] ?? '');

    noteController = TextEditingController(
      text: (widget.activity['note'] ?? '').replaceAll(RegExp(r'<[^>]*>'), ''),
    );

    if (widget.activity['date_deadline'] != null &&
        widget.activity['date_deadline'] != 'N/A') {
      selectedDate = widget.activity['date_deadline'];
    }

    _initialDate = selectedDate;
    _initialActivityId = selectedActivity?.id;
    _initialAssigneeId = selectedAssignee?.id;
    _initialSummary = summaryController.text;
    _initialNote = noteController.text;
  }

  bool _hasChanges() {
    return selectedDate != _initialDate ||
        selectedActivity?.id != _initialActivityId ||
        selectedAssignee?.id != _initialAssigneeId ||
        summaryController.text != _initialSummary ||
        noteController.text != _initialNote;
  }

  Future<void> _handleClose() async {
    if (!_hasChanges()) {
      if (mounted) Navigator.pop(context);
      return;
    }
    final shouldDiscard = await DataLossWarningDialog.show(
      context: context,
      title: 'Discard Changes?',
      message: 'You have unsaved changes. Do you want to discard them?',
    );
    if (shouldDiscard == true && mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      backgroundColor: isDark ? const Color(0xFF1E1E1E) : Colors.white,
      elevation: 0,
      shadowColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      titlePadding: EdgeInsets.zero,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20),
      actionsPadding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
      title: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Row(
          children: [
            Text(
              "Edit Activity",
              style: TextStyle(
                color: isDark ? Colors.white : Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Spacer(),
            IconButton(
              onPressed: _handleClose,
              icon: Icon(Icons.close,
                  color: isDark ? Colors.grey[400] : Colors.grey, size: 24),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
          ],
        ),
      ),
      content: SizedBox(
        width: MediaQuery.of(context).size.width * 0.95,
        height: MediaQuery.of(context).size.height * 0.55,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const FieldLabel("Activity Type", isRequired: true),
              const SizedBox(height: 10),
              SingleSelectSearchableFuture<ActivityType>(
                items: const [],
                idSelector: (item) => item.id,
                initialValue: selectedActivity,
                displayText: (activity) => activity.name,
                onSelectionChanged: (activity) {
                  setState(() {
                    activityTypeError = null;
                    selectedActivity = activity;
                  });
                },
                hintText: 'Select an Activity',
                onEmptyItemsFetch: () async {
                  final list = await CompanySessionManager.callKwWithCompany({
                    'model': 'mail.activity.type',
                    'method': 'search_read',
                    'args': [
                      [
                        '|',
                        ['res_model', '=', false],
                        ['res_model', '=', 'crm.lead']
                      ]
                    ],
                    'kwargs': {
                      'fields': ['id', 'name'],
                    }
                  });
                  return (list as List)
                      .map((item) =>
                          ActivityType.fromJson(item as Map<String, dynamic>))
                      .toList();
                },
                isEditable: true,
              ),
              if (activityTypeError != null)
                Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: Text(
                    activityTypeError!,
                    style: const TextStyle(color: Colors.red, fontSize: 13),
                  ),
                ),
              const SizedBox(height: 10),
              const FieldLabel("Due Date"),
              const SizedBox(height: 10),
              CustomDatePickerField(
                  initialValue: selectedDate,
                  isEditable: true,
                  onDateChanged: (value) {
                    setState(() {
                      selectedDate = value;
                    });
                  },
                  hintText: "Due Date"),
              const SizedBox(height: 10),
              const FieldLabel("Summary"),
              const SizedBox(height: 10),
              TextField(
                style: AppTheme.fieldValueStyle(isDark),
                cursorColor: AppTheme.primaryColor,
                controller: summaryController,
                decoration: AppTheme.fieldDecoration(
                  isDark,
                  hintText: "e.g. Discuss proposal",
                ),
              ),
              const SizedBox(height: 10),
              const FieldLabel("Assigned To", isRequired: true),
              const SizedBox(height: 10),
              SingleSelectSearchableFuture<SalesPersonItem>(
                items: const [],
                initialValue: selectedAssignee,
                displayText: (person) => person.name,
                onSelectionChanged: (person) {
                  setState(() {
                    assigneeError = null;
                    selectedAssignee = person;
                  });
                },
                hintText: 'Select an Assignee',
                onEmptyItemsFetch: () async {
                  final list = await CompanySessionManager.callKwWithCompany({
                    'model': 'res.users',
                    'method': 'search_read',
                    'args': [[]],
                    'kwargs': {
                      'fields': ['id', 'name', 'sale_team_id'],
                    }
                  });
                  return (list as List)
                      .map((item) => SalesPersonItem.fromJson(
                          item as Map<String, dynamic>))
                      .toList();
                },
                isEditable: true,
              ),
              if (assigneeError != null)
                Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: Text(
                    assigneeError!,
                    style: const TextStyle(color: Colors.red, fontSize: 13),
                  ),
                ),
              const SizedBox(height: 10),
              const FieldLabel("Note"),
              const SizedBox(height: 10),
              TextField(
                style: AppTheme.fieldValueStyle(isDark),
                cursorColor: AppTheme.primaryColor,
                controller: noteController,
                maxLines: 3,
                decoration: AppTheme.fieldDecoration(
                  isDark,
                  hintText: "Log a note...",
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
      actions: [
        Row(
          children: [
            Expanded(
              child: SizedBox(
                height: 48,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    foregroundColor:AppStyle.primaryColor,
                    side: const BorderSide(color: AppStyle.primaryColor, width: 1.5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: _handleClose,
                  child: const Text(
                    'Cancel',
                    style: TextStyle(
                      color: AppStyle.primaryColor,
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: SizedBox(
                height: 48,
                child: ElevatedButton(
                  onPressed: () {
                    // Both can be cleared in the pickers above, but an
                    // activity needs them.
                    setState(() {
                      activityTypeError = selectedActivity == null
                          ? 'Activity Type cannot be empty'
                          : null;
                      assigneeError = selectedAssignee == null
                          ? 'Assignee cannot be empty'
                          : null;
                    });
                    if (activityTypeError != null || assigneeError != null) {
                      return;
                    }
                    widget.onSave({
                      "summary": summaryController.text,
                      "note": noteController.text,
                      "date_deadline": selectedDate,
                      "activity_type_id": selectedActivity?.id,
                      "activity_type_name": selectedActivity?.name,
                      "user_id": selectedAssignee?.id,
                      "user_name": selectedAssignee?.name,
                    });
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppStyle.primaryColor,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    "Save",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
