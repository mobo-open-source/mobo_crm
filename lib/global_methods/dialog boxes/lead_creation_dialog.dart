import 'package:custom_rating_bar/custom_rating_bar.dart';
import 'package:flutter/material.dart';
import 'package:mobo_crm/global_methods/const.dart';

import 'package:mobo_crm/global_methods/widgets/drop_downs/custom_dropdown.dart';
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
import '../../utils/globals.dart';

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
  final TextEditingController emailController = TextEditingController();
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
        emailController.text.trim().isNotEmpty ||
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
    emailController.dispose();
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

    return Dialog(
      backgroundColor: AppColors().fillColor,
      insetPadding: const EdgeInsets.all(20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: ConstrainedBox(
        constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(15),
                  topRight: Radius.circular(15),
                ),
              ),
              child: Row(
                children: [
                  Text(
                    "Add Pipeline",
                    style: TextStyle(
                        color: Colors.black,
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
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: 10),
                      Text.rich(
                        TextSpan(
                          text: "Contact",
                          style: TextStyle(
                            fontSize: 16,
                            color: AppColors().subHeading,
                          ),
                          children: const [
                            TextSpan(
                              text: ' *',
                              style: TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 5),
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
                      const SizedBox(height: 15),

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
                        controller: emailController,
                        isEditable: true,
                        validator: (value) {
                          return null;
                        },
                        title: "Email",
                        hintText: "Email",
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

                      Row(
                        children: [
                          Text(
                            "Priority",
                            style: TextStyle(
                                color: AppColors().subHeading,
                                fontSize: 16),
                          ),
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
                      const SizedBox(height: 10),

                      const SizedBox(height: 16),
                      const Divider(),
                      const SizedBox(height: 16),
                      Consumer3<OdooClientManager, OpportunityDataProvider,
                              ActivityDataProvider>(
                          builder: (context, provider, opportunityprovider,
                              activitydataprovider, child) {
                        if (opportunityprovider.isLoading) {
                          return Center(
                            child: CircularProgressIndicator(
                              color: AppStyle.primaryColor,
                            ),
                          );
                        } else {
                          return SizedBox(
                            width: double.infinity,
                            height: 48,
                            child: ElevatedButton(
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
                              style: TextButton.styleFrom(
                                backgroundColor: AppStyle.primaryColor,
                                disabledBackgroundColor: Colors.grey,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                padding: const EdgeInsets.all(13),
                              ),
                              child: const Text(
                                "Add Pipeline",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          );
                        }
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
      "expected_revenue": expectedRevenueController.text,
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
      if (context.mounted) {
        Navigator.pop(context);
        CustomSnackbar.showError(context, 'Error creating opportunity');
      }

      return false;
    }
  }
}
