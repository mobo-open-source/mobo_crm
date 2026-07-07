import 'package:flutter/material.dart';
import 'package:mobo_crm/global_methods/widgets/textfields/custom_editing_fields.dart';
import 'package:mobo_crm/global_methods/widgets/textfields/future_single_selection_textfield.dart';
import 'package:mobo_crm/initilisation.dart';
import 'package:mobo_crm/models/models.dart';
import 'package:mobo_crm/screens/lead/providers/lead_data_provider.dart';
import 'package:mobo_crm/screens/lead/providers/lead_form_provider.dart';
import 'package:mobo_crm/screens/opportunity/providers/opportunity_data_provider.dart';
import 'package:provider/provider.dart';

import '../../../core/company/session/company_session_manager.dart';

/// A widget that displays and allows editing of the address information for a lead or opportunity.
///
/// The widget supports both view and edit modes, determined by [isEdit]. When in edit mode,
/// the user can select a country and state from searchable dropdowns and input street, city, and zip code.
/// In view mode, the selected or entered values are displayed as read-only text.
///
/// This widget interacts with multiple providers to manage state:
/// - [LeadFormProvider] for managing the address form fields and selected country/state.
/// - [OdooClientManager] for fetching countries and states from the backend.
/// - [OpportunityDataProvider] and [LeadDataProvider] are also provided for context but not directly used in this widget.
///
/// Features:
/// - Country selection with live fetching if the list is empty.
/// - State selection filtered by the selected country.
/// - Text fields for street, city, and zip code.
/// - Supports displaying "None" if no value is selected or entered.
/// - Editable and non-editable modes are fully supported.
///
/// Parameters:
/// - [isEdit]: Whether the widget should allow editing or display read-only values.
/// - [leadData]: The lead data object containing existing address information.
/// - [type]: The type of record (e.g., "lead" or "opportunity") being displayed.
///
/// Example usage:
/// ```dart
/// AddressTabWidget(
///   isEdit: true,
///   leadData: lead,
///   type: "lead",
/// )
/// ```
class AddressTabWidget extends StatefulWidget {
  final bool isEdit;
  final dynamic leadData;
  final String type;

  const AddressTabWidget({
    super.key,
    required this.isEdit,
    required this.leadData,
    required this.type,
  });

  @override
  State<AddressTabWidget> createState() => _AddressTabWidgetState();
}

class _AddressTabWidgetState extends State<AddressTabWidget> {
  bool isCountryLoading = false;
  List<Country> countryList = [];

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
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
              ),
              child: Text(
                "Address Information",
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
                  if (widget.isEdit) ...[
                    Text(
                      "Country",
                      style: TextStyle(
                          color: Colors.black54,
                          fontSize: 16,
                          fontWeight: FontWeight.normal),
                    ),
                    SizedBox(height: 10),
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
                                        await CompanySessionManager
                                            .callKwWithCompany({
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
                                  isEditable: widget.isEdit,
                                ),
                        ),
                      ],
                    ),
                  ] else ...[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Country",
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          provider.selectedCountryId?.name ?? "None",
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.normal,
                            fontSize: 14,
                          ),
                          textAlign: TextAlign.end,
                        )
                      ],
                    ),
                  ],
                  SizedBox(height: 20),
                  if (widget.isEdit) ...[
                    Text(
                      "State",
                      style: TextStyle(
                          color: Colors.black54,
                          fontSize: 16,
                          fontWeight: FontWeight.normal),
                    ),
                    SizedBox(height: 10),
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
                              final stateList = await CompanySessionManager
                                  .callKwWithCompany({
                                'model': 'res.country.state',
                                'method': 'search_read',
                                'args': [
                                  [
                                    [
                                      'country_id',
                                      '=',
                                      provider.selectedCountryId!.id
                                    ]
                                  ]
                                ],
                                'kwargs': {
                                  'fields': ['id', 'name', 'country_id']
                                },
                              });
                              return (stateList as List<dynamic>)
                                  .map((item) => StateClass.fromJson(
                                      item as Map<String, dynamic>))
                                  .toList();
                            },
                            isEditable: widget.isEdit &&
                                provider.selectedCountryId != null,
                          ),
                        ),
                      ],
                    ),
                  ] else ...[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "State",
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          provider.selectedStateId?.name ?? "None",
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.normal,
                            fontSize: 14,
                          ),
                          textAlign: TextAlign.end,
                        )
                      ],
                    ),
                  ],
                  SizedBox(height: 20),
                  widget.isEdit
                      ? CustomEditingFields(
                          title: "Street",
                          controller: provider.streetController,
                          hintText: "Street",
                          isEditable: widget.isEdit,
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Street",
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              provider.streetController.text.trim().isEmpty
                                  ? "None"
                                  : provider.streetController.text,
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.normal,
                                fontSize: 14,
                              ),
                              textAlign: TextAlign.end,
                            )
                          ],
                        ),
                  SizedBox(height: 10),
                  widget.isEdit
                      ? CustomEditingFields(
                          title: "City",
                          controller: provider.cityController,
                          hintText: "City",
                          isEditable: widget.isEdit,
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "City",
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              provider.cityController.text.trim().isEmpty
                                  ? "None"
                                  : provider.cityController.text,
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.normal,
                                fontSize: 14,
                              ),
                              textAlign: TextAlign.end,
                            )
                          ],
                        ),
                  SizedBox(height: 10),
                  widget.isEdit
                      ? CustomEditingFields(
                          inputType: TextInputType.number,
                          title: "Zip",
                          controller: provider.zipController,
                          hintText: "Zip",
                          isEditable: widget.isEdit,
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Zip",
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              provider.zipController.text.trim().isEmpty
                                  ? "None"
                                  : provider.zipController.text,
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.normal,
                                fontSize: 14,
                              ),
                              textAlign: TextAlign.end,
                            )
                          ],
                        ),
                  SizedBox(height: 10),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
