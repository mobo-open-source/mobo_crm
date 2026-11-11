import 'package:flutter/material.dart';
import 'package:mobo_crm/global_methods/widgets/date_picker/custom_date_picker.dart';
import 'package:mobo_crm/global_methods/widgets/forms/field_label.dart';
import 'package:mobo_crm/global_methods/widgets/forms/mobo_submit_button.dart';
import 'package:mobo_crm/global_methods/widgets/textfields/custom_editing_fields.dart';
import 'package:mobo_crm/global_methods/widgets/textfields/future_single_selection_textfield.dart';
import 'package:mobo_crm/initilisation.dart';
import 'package:mobo_crm/models/activity_model/activity_model.dart';
import 'package:mobo_crm/screens/lead/providers/activity_create_provider.dart';
import 'package:mobo_crm/models/models.dart';
import 'package:mobo_crm/screens/myActivities/activities_main/activity_main_provider.dart';
import 'package:mobo_crm/utils/app_theme.dart';
import 'package:mobo_crm/utils/odoo_failure.dart';
import 'package:odoo_rpc/odoo_rpc.dart';
import 'package:provider/provider.dart';

import '../../core/company/session/company_session_manager.dart';
import '../../core/navigation/data_loss_warning_dialog.dart';

/// A modal bottom-sheet style dialog that allows users to create a new
/// `mail.activity` record in Odoo, associated with a specific record
/// (e.g. lead/opportunity, partner, sale order, etc.).
///
/// This dialog supports:
///   - Selecting an activity type
///   - Optional summary and internal note
///   - Assignee selection (required for most activity types)
///   - Due date (required for most activity types)
///   - Special handling for "Meeting" type (no assignee/date required)
///
/// After successful creation, it refreshes the activity list via provider
/// and calls an optional success callback.
class AddActivityDialog extends StatefulWidget {
  final int resId;
  final String model;

  /// Optional callback executed after activity is successfully created
  /// and the activity list has been refreshed.
  final void Function()? onSuccess;

  const AddActivityDialog({
    super.key,
    required this.resId,
    required this.model,
    this.onSuccess,
  });

  @override
  State<AddActivityDialog> createState() => _AddActivityDialogState();
}

class _AddActivityDialogState extends State<AddActivityDialog> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController summaryController = TextEditingController();
  final TextEditingController noteController = TextEditingController();
  String? activityTypeError;
  String? assigneeError;
  String? dateError;

  bool _isCreating = false;

  /// Why the last attempt to create the activity failed, shown inside the
  /// dialog. A SnackBar cannot be used for this: it is drawn behind a dialog.
  OdooFailure? _createFailure;

  String? selectedDate;
  ActivityType? selectedActivity;
  SalesPersonItem? selectedAssignee;

  int? _globalResId;
  String? _globalModel;
  String? recordError;
  final TextEditingController _recordSearchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _globalResId = widget.resId != 0 ? widget.resId : null;
    _globalModel = widget.model.isNotEmpty ? widget.model : 'crm.lead';
  }

  @override
  void dispose() {
    summaryController.dispose();
    noteController.dispose();
    _recordSearchController.dispose();
    super.dispose();
  }

  bool _hasChanges() {
    return summaryController.text.isNotEmpty ||
        noteController.text.isNotEmpty ||
        selectedActivity != null ||
        selectedAssignee != null ||
        selectedDate != null;
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

  /// Returns `true` if the currently selected activity type is a "Meeting"
  /// (case-insensitive comparison).
  ///
  /// Meetings typically do not require an assignee or due date in many Odoo
  /// configurations.
  bool get isMeeting => selectedActivity?.name.toLowerCase() == 'meeting';

  @override
  Widget build(BuildContext context) {
    final odooClient = Provider.of<OdooClientManager>(context, listen: false);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Dialog(
      backgroundColor: isDark ? const Color(0xFF1E1E1E) : Colors.white,
      elevation: 0,
      shadowColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Consumer<OdooClientManager>(
        builder: (context, clientprovider, _) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: Row(
                  children: [
                    Text(
                      "Add Activity",
                      style: TextStyle(
                          color: isDark ? Colors.white : Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: _handleClose,
                      icon:
                          const Icon(Icons.close, color: Colors.grey, size: 24),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    )
                  ],
                ),
              ),
              Flexible(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (widget.resId == 0) ...[
                          const FieldLabel("Related Record (Lead/Opportunity)"),
                          const SizedBox(height: 10),
                          SingleSelectSearchableFuture<Map<String, dynamic>>(
                            items: const [],
                            displayText: (item) => item['name'] ?? 'Unknown',
                            onSelectionChanged: (item) {
                              setState(() {
                                recordError = null;
                                _createFailure = null;
                                _globalResId = item?['id'];
                              });
                            },
                            hintText: 'Search Lead/Opportunity',
                            onEmptyItemsFetch: () async {
                              final list = await CompanySessionManager
                                  .callKwWithCompany({
                                'model': 'crm.lead',
                                'method': 'search_read',
                                'args': [[]],
                                'kwargs': {
                                  'fields': ['id', 'name'],
                                  'limit': 100,
                                }
                              });
                              return (list as List)
                                  .cast<Map<String, dynamic>>();
                            },
                            isEditable: true,
                            width: double.infinity,
                          ),
                          if (recordError != null)
                            Padding(
                              padding: const EdgeInsets.only(top: 6),
                              child: Text(
                                recordError!,
                                style: const TextStyle(
                                    color: Colors.red, fontSize: 13),
                              ),
                            ),
                          const SizedBox(height: 10),
                        ] else ...[
                        ],

                        const FieldLabel("Activity Type", isRequired: true),
                        const SizedBox(height: 10),
                        SingleSelectSearchableFuture<ActivityType>(
                          items: const [],
                          idSelector: (item) => item.id,
                          displayText: (activity) => activity.name,
                          onSelectionChanged: (activity) {
                            setState(() {
                              activityTypeError = null;
                              _createFailure = null;
                              selectedActivity = activity;
                            });
                          },
                          hintText: 'Select an Activity',
                          onEmptyItemsFetch: () async {
                            final list =
                                await CompanySessionManager.callKwWithCompany({
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
                                .map((item) => ActivityType.fromJson(
                                    item as Map<String, dynamic>))
                                .toList();
                          },
                          isEditable: true,
                          width: double.infinity,
                        ),
                        if (activityTypeError != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 6),
                            child: Text(
                              activityTypeError!,
                              style: const TextStyle(
                                  color: Colors.red, fontSize: 13),
                            ),
                          ),
                        const SizedBox(height: 10),

                        CustomEditingFields(
                          controller: summaryController,
                          isEditable: true,
                          bottomPadding: 10,
                          title: "Summary",
                          hintText: "Enter summary",
                        ),

                        const FieldLabel("Assigned To", isRequired: true),
                        const SizedBox(height: 10),
                        SingleSelectSearchableFuture<SalesPersonItem>(
                          items: const [],
                          displayText: (person) => person.name,
                          onSelectionChanged: (person) {
                            setState(() {
                              assigneeError = null;
                              _createFailure = null;
                              selectedAssignee = person;
                            });
                          },
                          hintText: 'Select an Assignee',
                          onEmptyItemsFetch: () async {
                            final list =
                                await CompanySessionManager.callKwWithCompany({
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
                          width: double.infinity,
                        ),
                        if (assigneeError != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 6),
                            child: Text(
                              assigneeError!,
                              style: const TextStyle(
                                  color: Colors.red, fontSize: 13),
                            ),
                          ),

                        const SizedBox(height: 10),
                        CustomEditingFields(
                          controller: noteController,
                          isEditable: true,
                          bottomPadding: 10,
                          title: "Note",
                          hintText: "Enter internal note",
                        ),

                        const FieldLabel("Date", isRequired: true),
                        const SizedBox(height: 10),
                        CustomDatePickerField(
                          isEditable: true,
                          onDateChanged: (date) {
                            setState(() {
                              dateError = null;
                              _createFailure = null;
                              selectedDate = date;
                            });
                          },
                          hintText: "Pick a Date",
                        ),
                        if (dateError != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 6),
                            child: Text(
                              dateError!,
                              style: const TextStyle(
                                  color: Colors.red, fontSize: 13),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
              // Outside the scrolling form, so it is in view whatever the
              // dialog's height and wherever the form is scrolled to.
              if (_createFailure != null)
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 4, 20, 0),
                  child: _ActivityErrorBanner(
                    failure: _createFailure!,
                    isDark: isDark,
                  ),
                ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
                child: Consumer<ActivityCreateProvider>(
                  builder: (context, activity, child) {
                    final bool hasRequiredData = !_isCreating &&
                        selectedActivity != null &&
                        (_globalResId != null) &&
                        (isMeeting ||
                            (selectedAssignee != null && selectedDate != null));
                    return MoboSubmitButton(
                        label: "Create Activity",
                        loadingLabel: "Creating...",
                        isLoading: _isCreating,
                        isReady: hasRequiredData,
                        onPressed: hasRequiredData
                            ? () async {
                                setState(() {
                                  recordError = _globalResId == null
                                      ? 'Please select a record'
                                      : null;
                                  activityTypeError = selectedActivity == null
                                      ? 'Activity Type cannot be empty'
                                      : null;
                                  assigneeError =
                                      (!isMeeting && selectedAssignee == null)
                                          ? 'Assignee cannot be empty'
                                          : null;
                                  dateError =
                                      (!isMeeting && selectedDate == null)
                                          ? 'Date cannot be empty'
                                          : null;
                                });

                                if (!_formKey.currentState!.validate() ||
                                    recordError != null ||
                                    activityTypeError != null ||
                                    assigneeError != null ||
                                    dateError != null) {
                                  return;
                                }

                                setState(() {
                                  _isCreating = true;
                                  _createFailure = null;
                                });
                                try {
                                  final success = await _createActivity(
                                    client: odooClient.client!,
                                    context: context,
                                  );

                                  if (success && context.mounted) {
                                    activity.fetchActivities(
                                      context,
                                      _globalResId!,
                                      _globalModel ?? widget.model,
                                    );
                                    final activitiesMainProvider =
                                        Provider.of<ActivitiesMainProvider>(
                                            context,
                                            listen: false);
                                    await activitiesMainProvider
                                        .fetchActivities(isNotify: true);
                                    widget.onSuccess?.call();
                                    if (context.mounted) Navigator.pop(context);
                                  }
                                } finally {
                                  if (mounted) setState(() => _isCreating = false);
                                }
                              }
                            : null,
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  /// Validates input data and creates a new `mail.activity` record in Odoo
  /// via RPC.
  ///
  /// Steps performed:
  /// 1. Final safety checks on required fields
  /// 2. Verifies that the target model actually exists in Odoo
  /// 3. Builds the activity payload
  /// 4. Calls `mail.activity.create(...)`
  /// 5. On failure, shows the reason inside the dialog ([_createFailure])
  ///
  /// Returns `true` if the activity was created successfully, `false`
  /// otherwise.
  ///
  /// The reason is read from Odoo's own error, so a user who lacks the access
  /// rights is told that (and which groups may do it) instead of a generic
  /// "Error creating activity". It is shown inline because a SnackBar would be
  /// drawn behind this dialog.
  Future<bool> _createActivity({
    required OdooClient client,
    required BuildContext context,
  }) async {
    try {
      final String targetModel = _globalModel ?? widget.model;
      final int? targetResId = _globalResId;

      if (targetModel.isEmpty || targetResId == null || targetResId == 0) {
        throw Exception('Model or Resource ID is missing or invalid');
      }
      if (selectedActivity == null) {
        throw Exception('Activity type is not selected');
      }
      if (!isMeeting && selectedAssignee == null) {
        throw Exception('Assignee is not selected');
      }
      if (!isMeeting && selectedDate == null) {
        throw Exception('Date is not selected');
      }

      final modelCheck = await CompanySessionManager.callKwWithCompany({
        'model': 'ir.model',
        'method': 'search_read',
        'args': [
          [
            ['model', '=', widget.model]
          ]
        ],
        'kwargs': {
          'fields': ['id', 'model'],
          'limit': 1,
        },
      });

      if (modelCheck.isEmpty) {
        throw Exception('Invalid model: $targetModel does not exist in Odoo');
      }

      final modelId = (modelCheck[0] as Map<String, dynamic>)['id'] as int;

      final odooManager =
          Provider.of<OdooClientManager>(context, listen: false);
      final fallbackUserId = odooManager.currentsession?.userId;
      final fallbackDate =
          DateTime.now().toIso8601String().substring(0, 10);

      final activityData = {
        'res_model': targetModel,
        'res_model_id': modelId,
        'res_id': targetResId,
        'activity_type_id': selectedActivity!.id,
        'summary': summaryController.text.isNotEmpty
            ? summaryController.text
            : 'New Activity',
        'note': noteController.text,
        'user_id': selectedAssignee?.id ?? fallbackUserId,
        'date_deadline': selectedDate ?? fallbackDate,
      };
      final response = await CompanySessionManager.callKwWithCompany({
        'model': 'mail.activity',
        'method': 'create',
        'args': [activityData],
        'kwargs': {},
      });

      if (response is int) {}

      return true;
    } catch (e) {
      if (mounted) {
        setState(() {
          _createFailure = describeOdooFailure(
            e,
            action: 'schedule an activity on this record',
          );
        });
      }
      return false;
    }
  }
}

/// Explains inside the dialog why an activity could not be created.
///
/// Orange for something the user can do nothing about here (missing access
/// rights, data Odoo refused), red for a failure of the request itself.
class _ActivityErrorBanner extends StatelessWidget {
  const _ActivityErrorBanner({required this.failure, required this.isDark});

  final OdooFailure failure;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final bool isAccess = failure.isAccessDenied;
    final bool isValidation = failure.kind == OdooFailureKind.validation;
    final Color color = (isAccess || isValidation)
        ? StatusColors.statusOrange
        : StatusColors.statusRed;
    final IconData icon = isAccess
        ? Icons.lock_outline_rounded
        : isValidation
            ? Icons.info_outline_rounded
            : Icons.error_outline_rounded;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: color.withValues(alpha: 0.35)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: color),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  failure.headline,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.valueColor(isDark),
                  ),
                ),
                if (failure.detail != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    failure.detail!,
                    maxLines: 6,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 12,
                      height: 1.35,
                      color: AppTheme.secondaryLabelColor(isDark),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
