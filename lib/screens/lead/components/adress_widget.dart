import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mobo_crm/global_methods/const.dart';
import 'package:mobo_crm/global_methods/widgets/buttons/form_view_icon.dart';

import 'package:mobo_crm/global_methods/widgets/textfields/custom_editing_fields.dart';
import 'package:mobo_crm/global_methods/widgets/textfields/future_single_selection_textfield.dart';
import 'package:mobo_crm/initilisation.dart';
import 'package:mobo_crm/models/models.dart';

import 'package:mobo_crm/screens/lead/providers/lead_form_provider.dart';

import 'package:mobo_crm/screens/opportunity/providers/opportunity_data_provider.dart';
import 'package:mobo_crm/utils/snackbar.dart';
import 'package:provider/provider.dart';

import '../../../core/company/session/company_session_manager.dart';

/// Contact section widget used inside Lead and Opportunity forms.
///
/// Features:
/// - Displays and edits contact-related fields
/// - Supports both view and edit modes
/// - Handles country & state dynamic selection
/// - Integrates with LeadFormProvider and OpportunityDataProvider
/// - Supports saving and creating opportunities
///
/// Used In:
/// - Lead Form
/// - Opportunity Form
///
/// Parameters:
/// - [isedit]: Controls whether fields are editable
/// - [leadData]: Existing lead/opportunity data
/// - [type]: Indicates record type (lead/opportunity)
///
/// Dependencies:
/// - LeadFormProvider
/// - OpportunityDataProvider
/// - OdooClientManager
/// - CompanySessionManager (for RPC calls)
class ContactInFormmationWidget extends StatefulWidget {
  final bool isedit;
  final dynamic leadData;
  final String type;

  const ContactInFormmationWidget(
      {super.key,
      required this.isedit,
      required this.leadData,
      required this.type});

  @override
  State<ContactInFormmationWidget> createState() =>
      _ContactInFormmationWidgetState();
}

class _ContactInFormmationWidgetState extends State<ContactInFormmationWidget> {
  bool isCountryLoading = false;
  List<Country> countryList = [];

  /// Fetches available countries from Odoo.
  ///
  /// Calls:
  /// - `res.country.search_read`
  ///
  /// Updates:
  /// - [countryList]
  /// - [isCountryLoading]
  ///
  /// Parameters:
  /// - [clientprovider]: Active Odoo client manager
  ///
  /// Handles:
  /// - Loading state management
  /// - Safe state updates
  ///
  /// Note:
  /// - Errors are silently ignored (consider logging for debugging).
  Future<void> fetchCountries(OdooClientManager clientprovider) async {
    try {
      setState(() => isCountryLoading = true);
      final countrylist = await CompanySessionManager.callKwWithCompany({
        'model': 'res.country',
        'method': 'search_read',
        'args': [[]],
        'kwargs': {
          'fields': ['id', 'name']
        },
      });
      countryList = (countrylist as List<dynamic>)
          .map((item) => Country.fromJson(item as Map<String, dynamic>))
          .toList();
      setState(() => isCountryLoading = false);
    } catch (_) {}
  }

  @override
  void initState() {
    super.initState();
  }

  /// Builds the contact information UI section.
  ///
  /// Includes:
  /// - Company name
  /// - Contact name
  /// - Job position
  /// - Mobile
  /// - Address details (Country, State, Street, City, Zip)
  /// - Website
  ///
  /// Features:
  /// - Toggle edit/save mode
  /// - Save changes for existing opportunities
  /// - Create new opportunity when ID is null
  /// - Dynamic country/state dropdown loading
  /// - Provider-based state management
  ///
  /// Uses:
  /// - Consumer3 for reactive updates
  /// - SingleSelectSearchableFuture for async dropdowns
  /// - CustomEditingFields for input fields
  ///
  /// Returns:
  /// - Configured contact form widget tree
  @override
  Widget build(BuildContext context) {
    return Consumer3<LeadFormProvider, OdooClientManager,
        OpportunityDataProvider>(
      builder:
          (context, provider, clientprovider, opportunitydataprovider, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  "Contact Information",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Spacer(),
                if (provider.data['type'] == 'opportunity') ...[
                  FormViewCustomIcon(
                      icon: widget.isedit
                          ? Icons.save
                          : FontAwesomeIcons.penToSquare.data,
                      onTap: () async {
                        if (provider.isEdit) {
                          if (provider.data['id'] != null) {
                            bool success = await provider.saveChanges(
                              clientprovider.client!,
                              context,
                              {'id': provider.data['id']},
                            );

                            if (success) {
                              if (context.mounted) {
                                await opportunitydataprovider.getOpportunities(
                                    isPop: false,
                                    loading: true,
                                    context: context,
                                    isOpportunity: true,
                                    isLead: false);
                              }
                            } else {
                              if (context.mounted) {
                                CustomSnackbar.showError(
                                    context, 'Error saving changes');
                              }
                            }
                          } else {
                            provider.createOpportunity(
                                clientprovider.client!, context, widget.type);
                          }
                        } else {
                          provider.changeToEdit();
                        }
                      }),
                ]
              ],
            ),
            SizedBox(
              height: 10,
            ),
            CustomEditingFields(
                title: "Company Name",
                controller: provider.compnayNameController,
                hintText: "Company Name",
                isEditable: widget.isedit),
            CustomEditingFields(
                title: "Contact Name",
                controller: provider.contactNameController,
                hintText: "Contact Name",
                isEditable: widget.isedit),
            CustomEditingFields(
                title: "Job Position",
                controller: provider.jobPositionController,
                hintText: "Job Position",
                isEditable: widget.isedit),
            CustomEditingFields(
                actionType: FieldActionType.phone,
                inputType: TextInputType.number,
                title: "Mobile",
                controller: provider.mobileController,
                hintText: "Mobile",
                isEditable: widget.isedit),
            Row(
              children: [
                Text(
                  "Address",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Spacer(),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              "Country",
              style: TextStyle(fontSize: 16, color: AppColors().subHeading),
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Expanded(
                  child: isCountryLoading
                      ? CircularProgressIndicator()
                      : SingleSelectSearchableFuture<Country>(
                          items: countryList,
                          idSelector: (item) => item.id,
                          initialValue: provider.selectedCountryId,
                          displayText: (country) => country.name,
                          onSelectionChanged: (country) {
                            if (country != null) {
                              setState(() {
                                provider.selectedCountryId = country;
                                provider.selectedStateId = null;
                              });
                            } else {
                              setState(() {
                                provider.selectedCountryId = null;
                                provider.selectedStateId = null;
                              });
                            }
                          },
                          hintText: 'Select a country',
                          onEmptyItemsFetch: () async {
                            final countrylist =
                                await CompanySessionManager.callKwWithCompany({
                              'model': 'res.country',
                              'method': 'search_read',
                              'args': [[]],
                              'kwargs': {
                                'fields': ['id', 'name']
                              },
                            });
                            return (countrylist as List<dynamic>)
                                .map((item) => Country.fromJson(
                                    item as Map<String, dynamic>))
                                .toList();
                          },
                          isEditable: widget.isedit,
                        ),
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              "State",
              style: TextStyle(fontSize: 16, color: AppColors().subHeading),
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Expanded(
                  child: SingleSelectSearchableFuture<StateClass>(
                    refresh: true,
                    items: [],
                    message: "Select A Country First",
                    idSelector: (item) => item.id,
                    clear: provider.selectedCountryId == null,
                    initialValue: provider.selectedStateId,
                    displayText: (state) => state.name,
                    onSelectionChanged: (state) {
                      if (state != null) {
                        setState(() {
                          provider.selectedStateId = state;
                        });
                      }
                    },
                    showMessage: provider.selectedCountryId == null,
                    hintText: 'Select a State',
                    onEmptyItemsFetch: () async {
                      final stateList =
                          await CompanySessionManager.callKwWithCompany({
                        'model': 'res.country.state',
                        'method': 'search_read',
                        'args': [
                          [
                            ['country_id', '=', provider.selectedCountryId!.id]
                          ]
                        ],
                        'kwargs': {
                          'fields': ['id', 'name', 'country_id']
                        },
                      });
                      return (stateList as List<dynamic>)
                          .map((item) =>
                              StateClass.fromJson(item as Map<String, dynamic>))
                          .toList();
                    },
                    isEditable:
                        widget.isedit && provider.selectedCountryId != null,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            CustomEditingFields(
                title: "Street",
                controller: provider.streetController,
                hintText: "Street",
                isEditable: widget.isedit),
            CustomEditingFields(
                title: "City",
                controller: provider.cityController,
                hintText: "City",
                isEditable: widget.isedit),
            CustomEditingFields(
                inputType: TextInputType.number,
                title: "Zip",
                controller: provider.zipController,
                hintText: "Zip",
                isEditable: widget.isedit),
            CustomEditingFields(
                actionType: FieldActionType.website,
                title: "Website",
                controller: provider.websiteController,
                hintText: "Website",
                isEditable: widget.isedit),
            SizedBox(
              height: 10,
            ),
          ],
        );
      },
    );
  }
}
