import 'package:custom_rating_bar/custom_rating_bar.dart';
import 'package:flutter/material.dart';
import 'package:mobo_crm/global_methods/const.dart';

import 'package:mobo_crm/global_methods/widgets/drop_downs/custom_dropdown.dart';
import 'package:mobo_crm/global_methods/widgets/forms/field_label.dart';
import 'package:mobo_crm/global_methods/widgets/forms/mobo_submit_button.dart';
import 'package:mobo_crm/global_methods/widgets/textfields/custom_editing_fields.dart';
import 'package:mobo_crm/global_methods/widgets/transition/page_transition.dart';
import 'package:mobo_crm/initilisation.dart';
import 'package:mobo_crm/models/models.dart';
import 'package:mobo_crm/screens/lead/new_lead_form.dart';

import 'package:mobo_crm/screens/myActivities/activity/provider/activity_data_provider.dart';
import 'package:mobo_crm/screens/opportunity/providers/opportunity_data_provider.dart';
import 'package:mobo_crm/utils/snackbar.dart';
import 'package:odoo_rpc/odoo_rpc.dart';
import 'package:provider/provider.dart';

import '../../Rating/review_service.dart';
import '../../core/company/session/company_session_manager.dart';
import '../../core/navigation/data_loss_warning_dialog.dart';
import '../../utils/app_theme.dart';

/// A modal dialog for quickly creating a new CRM Opportunity (or sometimes Lead)
/// directly in a specific pipeline stage.
///
/// Main purpose:
///   - Create a new `crm.lead` record of type 'opportunity'
///   - Assign it to the provided `stageId`
///   - Link to an existing customer/partner
///   - Set basic fields: name, expected revenue, priority, email/phone, description
///
/// Features two main actions:
///   - "Add" → creates & refreshes pipeline
///   - "Edit" → creates then immediately opens in edit form (`NewLeadForm`)
class OpportunityLeadDialog extends StatefulWidget {
  final int stageId;

  /// Label to differentiate usage context ('opportunity' or 'lead')
  /// Currently affects navigation behavior after "Edit" button
  final String label;

  const OpportunityLeadDialog(
      {super.key, required this.stageId, this.label = "opportunity"});

  @override
  State<OpportunityLeadDialog> createState() => _OpportunityLeadDialogState();
}

class _OpportunityLeadDialogState extends State<OpportunityLeadDialog> {
  final TextEditingController customerNamecontroller = TextEditingController();
  final TextEditingController opportunityNameController =
      TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController expectedRevenueController =
      TextEditingController();
  final TextEditingController internalNotesController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  int? selectedCustomerId;

  double priority = 0;
  final List<String> priorityList = ["Low", "Medium", "High"];
  String? selectedPriority;
  bool _hasRequiredData = false;

  @override
  void initState() {
    super.initState();
    opportunityNameController.addListener(_checkRequiredData);
    customerNamecontroller.addListener(_checkRequiredData);
    expectedRevenueController.addListener(_checkRequiredData);
  }

  void _checkRequiredData() {
    final hasData = opportunityNameController.text.trim().isNotEmpty &&
        customerNamecontroller.text.trim().isNotEmpty &&
        expectedRevenueController.text.trim().isNotEmpty;
    if (hasData != _hasRequiredData) {
      setState(() {
        _hasRequiredData = hasData;
      });
    }
  }

  bool _hasChanges() {
    return opportunityNameController.text.trim().isNotEmpty ||
        customerNamecontroller.text.trim().isNotEmpty ||
        phoneController.text.trim().isNotEmpty ||
        expectedRevenueController.text.trim().isNotEmpty ||
        internalNotesController.text.trim().isNotEmpty;
  }

  Future<void> _handleClose() async {
    if (!_hasChanges()) {
      if (mounted) Navigator.pop(context);
      return;
    }
    final result = await DataLossWarningDialog.show(
      context: context,
      title: 'Discard Changes?',
      message: 'You have unsaved changes. Do you want to discard them?',
      confirmText: 'Discard',
      cancelText: 'Keep Editing',
    );
    if ((result ?? false) && mounted) Navigator.pop(context);
  }

  @override
  void dispose() {
    opportunityNameController.removeListener(_checkRequiredData);
    customerNamecontroller.removeListener(_checkRequiredData);
    expectedRevenueController.removeListener(_checkRequiredData);
    opportunityNameController.dispose();
    phoneController.dispose();
    expectedRevenueController.dispose();
    customerNamecontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final odoomanagerprovider =
        Provider.of<OdooClientManager>(context, listen: false);
    final allcustomer = odoomanagerprovider.customerItems;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Dialog(
      backgroundColor: isDark ? const Color(0xFF1E1E1E) : Colors.white,
      elevation: 0,
      shadowColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: ConstrainedBox(
        constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Row(
                children: [
                  Text(
                    "Add Pipeline",
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
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const FieldLabel("Contact", isRequired: true),
                      const SizedBox(height: 10),
                      SearchableDropdown<CustomerItem>(
                        items: allcustomer,
                        displayText: (item) =>
                            "${item.name} - ${item.name}",
                        onItemSelected: (selectedItem) {
                          setState(() {
                            selectedCustomerId = selectedItem.id;
                          });
                        },
                        controller: customerNamecontroller,
                        hintText: "Search Contact",
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Contact is required';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 10),

                      CustomEditingFields(
                        isRequired: true,
                        bottomPadding: 10,
                        controller: opportunityNameController,
                        isEditable: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "This field can't be empty";
                          }
                          return null;
                        },
                        title: "Opportunity Name",
                        hintText: "Enter opportunity name",
                      ),

                      CustomEditingFields(
                        bottomPadding: 10,
                        controller: phoneController,
                        inputType: TextInputType.number,
                        isEditable: true,
                        validator: (value) {
                          return null;
                        },
                        title: "Phone",
                        hintText: "Phone",
                      ),

                      CustomEditingFields(
                        isRequired: true,
                        bottomPadding: 10,
                        controller: expectedRevenueController,
                        isEditable: true,
                        inputType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Expected revenue is required';
                          }
                          if (!RegExp(r'^\d+$').hasMatch(value)) {
                            return 'Please enter digits only';
                          }
                          return null;
                        },
                        title: "Expected Revenue",
                        hintText: "Expected Revenue",
                      ),

                      CustomEditingFields(
                        bottomPadding: 10,
                        controller: internalNotesController,
                        isEditable: true,
                        isExpanable: true,
                        validator: (value) {
                          return null;
                        },
                        title: "Description",
                        hintText: "Description",
                      ),

                      Row(
                        children: [
                          const FieldLabel("Priority"),
                          const SizedBox(width: 8),
                          RatingBar(
                            size: 20,
                            filledIcon: Icons.star,
                            emptyColor: AppColors().hintLight,
                            emptyIcon: Icons.star,
                            onRatingChanged: (value) {
                              setState(() {
                                priority = value;
                              });
                            },
                            initialRating: 0,
                            maxRating: 3,
                          )
                        ],
                      ),
                      const SizedBox(height: 20),
                      Consumer3<OdooClientManager, OpportunityDataProvider,
                              ActivityDataProvider>(
                          builder: (context, provider, opportunityprovider,
                              activitydataprovider, child) {
                        return MoboSubmitButton(
                              label: "Add Pipeline",
                              loadingLabel: "Adding...",
                              isLoading: opportunityprovider.isLoading,
                              isReady: _hasRequiredData,
                              onPressed: _hasRequiredData
                                  ? () async {
                                      if (_formKey.currentState!.validate()) {
                                        bool success = await _saveOpportunity(
                                            provider.client!, context, false);

                                        if (success) {
                                          if (context.mounted) {
                                            await opportunityprovider
                                                .getOpportunities(
                                                    isPop: true,
                                                    customFilter:
                                                        opportunityprovider
                                                            .lastFilter,
                                                    loading: true,
                                                    context: context,
                                                    isOpportunity: true,
                                                    isLead: false);
                                          }
                                          await ReviewService()
                                              .trackSignificantEvent();
                                          WidgetsBinding.instance
                                              .addPostFrameCallback((_) async {
                                            if (mounted) {
                                              await ReviewService()
                                                  .checkAndShowRating(context);
                                            }
                                          });
                                        }
                                      }
                                    }
                                  : null,
                        );
                      }),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Creates a new `crm.lead` record of type 'opportunity' in Odoo.
  ///
  /// Parameters:
  ///   - [client]        Authenticated Odoo RPC client
  ///   - [context]       BuildContext for mounted checks & snackbars
  ///   - [openEditAfterCreate]  If true, navigates to edit form after creation
  ///
  /// Returns `true` on success, `false` on failure (shows error snackbar).
  ///
  /// Important fields mapped:
  ///   - name → opportunity name
  ///   - partner_id → selected customer
  ///   - stage_id → provided stage
  ///   - expected_revenue → numeric string
  ///   - priority → 0..2 (from 0–3 star rating)
  ///   - description → internal notes
  Future<bool> _saveOpportunity(
      OdooClient client, BuildContext context, bool isEdit) async {
    final newOpportunity = {
      "name": opportunityNameController.text,
      "partner_id": selectedCustomerId,
      "type": "opportunity",
      'stage_id': widget.stageId,
      "expected_revenue":
          double.tryParse(expectedRevenueController.text) ?? 0.0,
      "description": internalNotesController.text,
      'priority': priority.toInt().clamp(0, 2).toString(),
    };

    try {
      final opportunityId = await CompanySessionManager.callKwWithCompany({
        'model': 'crm.lead',
        'method': 'create',
        'args': [newOpportunity],
        'kwargs': {},
      });

      // Odoo returns the new record's id on success. Anything else (null,
      // an error payload, etc.) means nothing was actually persisted, even
      // though no exception was thrown.
      if (opportunityId is! int) {
        throw Exception('Unexpected response from server: $opportunityId');
      }

      if (isEdit) {
        if (context.mounted) {
          Navigator.pushReplacement(
              context,
              SlidingPageTransitionRL(
                  page: NewLeadForm(
                      lead: {'id': opportunityId, 'type': 'opportunity'})));
        }
      }

      return true;
    } catch (e) {
      // Leave the dialog open on failure so the entered data isn't lost and
      // the user doesn't mistake the dialog closing for a successful save.
      if (context.mounted) {
        final detail = e is OdooException ? e.message : e.toString();
        CustomSnackbar.showError(context, 'Error creating opportunity: $detail');
      }

      return false;
    }
  }
}
