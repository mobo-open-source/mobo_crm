import 'package:flutter/material.dart';
import 'package:mobo_crm/global_methods/widgets/textfields/custom_editing_fields.dart';
import 'package:mobo_crm/initilisation.dart';
import 'package:mobo_crm/screens/lead/providers/lead_data_provider.dart';
import 'package:mobo_crm/screens/lead/providers/lead_form_provider.dart';
import 'package:mobo_crm/screens/opportunity/providers/opportunity_data_provider.dart';
import 'package:mobo_crm/utils/app_theme.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// A widget that displays and optionally allows editing of contact information
/// for a lead or opportunity.
///
/// This widget supports both view and edit modes, controlled by [isEdit].
/// In edit mode, the user can input or update the following fields:
/// - Company Name
/// - Contact Name
/// - Job Position
/// - Mobile number
/// - Website
/// - Bounce (only for leads; read-only even in edit mode)
///
/// In view mode, the widget displays the existing values or "None" if empty.
///
/// The widget uses multiple providers for state management:
/// - [LeadFormProvider]: Manages the form fields and controllers for contact info.
/// - [OdooClientManager], [OpportunityDataProvider], [LeadDataProvider]: Provided for context and potential future use.
///
/// Parameters:
/// - [isEdit]: Whether the fields should be editable.
/// - [leadData]: The lead data object containing existing contact info.
/// - [type]: The type of record ("lead" or "opportunity"). This affects which fields are displayed.
///
/// Example usage:
/// ```dart
/// ContactTabWidget(
///   isEdit: true,
///   leadData: lead,
///   type: "lead",
/// )
/// ```
class ContactTabWidget extends StatefulWidget {
  final bool isEdit;
  final dynamic leadData;
  final String type;

  const ContactTabWidget({
    super.key,
    required this.isEdit,
    required this.leadData,
    required this.type,
  });

  @override
  State<ContactTabWidget> createState() => _ContactTabWidgetState();
}

class _ContactTabWidgetState extends State<ContactTabWidget> {
  int version = 18;

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      version = prefs.getInt('version') ?? 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer4<LeadFormProvider, OdooClientManager,
        OpportunityDataProvider, LeadDataProvider>(
      builder: (context, provider, clientprovider, opportunitydataprovider,
          leaddataprovider, child) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                "Contact Information",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.valueColor(isDark),
                ),
              ),
            ),
            Divider(
              height: 1,
              color: isDark ? Colors.grey[700] : Colors.grey.shade200,
              indent: 10,
              endIndent: 10,
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  widget.isEdit
                      ? CustomEditingFields(
                          title: "Company Name",
                          controller: provider.compnayNameController,
                          hintText: "Company Name",
                          isEditable: widget.isEdit,
                          bottomPadding: 0,
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Company Name',
                              style: TextStyle(
                                color: isDark ? Colors.grey[400] : Colors.grey[600],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              provider.compnayNameController.text.isNotEmpty
                                  ? provider.compnayNameController.text
                                  : "None",
                              style: TextStyle(
                                color: isDark ? Colors.white : Colors.black,
                                fontWeight: FontWeight.normal,
                                fontSize: 14,
                              ),
                              textAlign: TextAlign.end,
                            ),
                          ],
                        ),
                  const SizedBox(height: 10),
                  widget.isEdit
                      ? CustomEditingFields(
                          title: "Contact Name",
                          controller: provider.contactNameController,
                          hintText: "Contact Name",
                          isEditable: widget.isEdit,
                          bottomPadding: 0,
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Contact Name',
                              style: TextStyle(
                                color: isDark ? Colors.grey[400] : Colors.grey[600],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              provider.contactNameController.text.isNotEmpty
                                  ? provider.contactNameController.text
                                  : "None",
                              style: TextStyle(
                                color: isDark ? Colors.white : Colors.black,
                                fontWeight: FontWeight.normal,
                                fontSize: 14,
                              ),
                              textAlign: TextAlign.end,
                            ),
                          ],
                        ),
                  const SizedBox(height: 10),
                  widget.isEdit
                      ? CustomEditingFields(
                          title: "Job Position",
                          controller: provider.jobPositionController,
                          hintText: "Job Position",
                          isEditable: widget.isEdit,
                          bottomPadding: 0,
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Job Position',
                              style: TextStyle(
                                color: isDark ? Colors.grey[400] : Colors.grey[600],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              provider.jobPositionController.text.isNotEmpty
                                  ? provider.jobPositionController.text
                                  : "None",
                              style: TextStyle(
                                color: isDark ? Colors.white : Colors.black,
                                fontWeight: FontWeight.normal,
                                fontSize: 14,
                              ),
                              textAlign: TextAlign.end,
                            ),
                          ],
                        ),
                  const SizedBox(height: 10),
                  if (version <= 18) ...[
                    widget.isEdit
                        ? CustomEditingFields(
                            actionType: FieldActionType.phone,
                            inputType: TextInputType.number,
                            title: "Mobile",
                            controller: provider.mobileController,
                            hintText: "Mobile",
                            isEditable: widget.isEdit,
                            bottomPadding: 0,
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Mobile',
                                style: TextStyle(
                                  color: isDark ? Colors.grey[400] : Colors.grey[600],
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Text(
                                provider.mobileController.text.isNotEmpty
                                    ? provider.mobileController.text
                                    : "None",
                                style: TextStyle(
                                  color: isDark ? Colors.white : Colors.black,
                                  fontWeight: FontWeight.normal,
                                  fontSize: 14,
                                ),
                                textAlign: TextAlign.end,
                              ),
                            ],
                          ),
                    const SizedBox(height: 10),
                  ],
                  widget.isEdit
                      ? CustomEditingFields(
                          actionType: FieldActionType.website,
                          title: "Website",
                          controller: provider.websiteController,
                          hintText: "Website",
                          isEditable: widget.isEdit,
                          bottomPadding: 0,
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Website',
                              style: TextStyle(
                                color: isDark ? Colors.grey[400] : Colors.grey[600],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              provider.websiteController.text.isNotEmpty
                                  ? provider.websiteController.text
                                  : "None",
                              style: TextStyle(
                                color: isDark ? Colors.white : Colors.black,
                                fontWeight: FontWeight.normal,
                                fontSize: 14,
                              ),
                              textAlign: TextAlign.end,
                            ),
                          ],
                        ),
                  if (widget.type == 'lead') ...[
                    const SizedBox(height: 10),
                    widget.isEdit
                        ? CustomEditingFields(
                            title: "Bounce",
                            controller: provider.messageBounceController,
                            hintText: "Bounce",
                            isEditable: widget.isEdit,
                            inputType: TextInputType.number,
                            bottomPadding: 0,
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Bounce',
                                style: TextStyle(
                                  color: isDark ? Colors.grey[400] : Colors.grey[600],
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Text(
                                provider.messageBounceController.text,
                                style: TextStyle(
                                  color: isDark ? Colors.white : Colors.black,
                                  fontWeight: FontWeight.normal,
                                  fontSize: 14,
                                ),
                                textAlign: TextAlign.end,
                              ),
                            ],
                          ),
                  ],
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
