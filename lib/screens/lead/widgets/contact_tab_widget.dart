import 'package:flutter/material.dart';
import 'package:mobo_crm/global_methods/widgets/textfields/custom_editing_fields.dart';
import 'package:mobo_crm/initilisation.dart';
import 'package:mobo_crm/screens/lead/providers/lead_data_provider.dart';
import 'package:mobo_crm/screens/lead/providers/lead_form_provider.dart';
import 'package:mobo_crm/screens/opportunity/providers/opportunity_data_provider.dart';
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
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
              ),
              child: Text(
                "Contact Information",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[900],
                  letterSpacing: -0.3,
                ),
              ),
            ),
            Divider(
              height: 1,
              color: Colors.grey[200],
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
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Company Name',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              provider.compnayNameController.text.isNotEmpty
                                  ? provider.compnayNameController.text
                                  : "None",
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.normal,
                                fontSize: 14,
                              ),
                              textAlign: TextAlign.end,
                            ),
                          ],
                        ),
                  SizedBox(height: 10),
                  widget.isEdit
                      ? CustomEditingFields(
                          title: "Contact Name",
                          controller: provider.contactNameController,
                          hintText: "Contact Name",
                          isEditable: widget.isEdit,
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Contact Name',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              provider.contactNameController.text.isNotEmpty
                                  ? provider.contactNameController.text
                                  : "None",
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.normal,
                                fontSize: 14,
                              ),
                              textAlign: TextAlign.end,
                            ),
                          ],
                        ),
                  SizedBox(height: 10),
                  widget.isEdit
                      ? CustomEditingFields(
                          title: "Job Position",
                          controller: provider.jobPositionController,
                          hintText: "Job Position",
                          isEditable: widget.isEdit,
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Job Position',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              provider.jobPositionController.text.isNotEmpty
                                  ? provider.jobPositionController.text
                                  : "None",
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.normal,
                                fontSize: 14,
                              ),
                              textAlign: TextAlign.end,
                            ),
                          ],
                        ),
                  SizedBox(height: 10),
                  if (version <= 18) ...[
                    widget.isEdit
                        ? CustomEditingFields(
                            actionType: FieldActionType.phone,
                            inputType: TextInputType.number,
                            title: "Mobile",
                            controller: provider.mobileController,
                            hintText: "Mobile",
                            isEditable: widget.isEdit,
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Mobile',
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Text(
                                provider.mobileController.text.isNotEmpty
                                    ? provider.mobileController.text
                                    : "None",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.normal,
                                  fontSize: 14,
                                ),
                                textAlign: TextAlign.end,
                              ),
                            ],
                          ),
                    SizedBox(height: 10),
                  ],
                  widget.isEdit
                      ? CustomEditingFields(
                          actionType: FieldActionType.website,
                          title: "Website",
                          controller: provider.websiteController,
                          hintText: "Website",
                          isEditable: widget.isEdit,
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Website',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              provider.websiteController.text.isNotEmpty
                                  ? provider.websiteController.text
                                  : "None",
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.normal,
                                fontSize: 14,
                              ),
                              textAlign: TextAlign.end,
                            ),
                          ],
                        ),
                  if (widget.type == 'lead') ...[
                    SizedBox(height: 10),
                    widget.isEdit
                        ? CustomEditingFields(
                            title: "Bounce",
                            controller: provider.messageBounceController,
                            hintText: "Bounce",
                            isEditable: widget.isEdit,
                            inputType: TextInputType.number,
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Bounce',
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Text(
                                provider.messageBounceController.text,
                                style: TextStyle(
                                  color: Colors.black,
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
