import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:mobo_crm/global_methods/const.dart';
import 'package:mobo_crm/global_methods/widgets/date_picker/custom_date_picker.dart';
import 'package:mobo_crm/global_methods/widgets/textfields/custom_editing_fields.dart';
import 'package:mobo_crm/global_methods/widgets/textfields/future_single_selection_textfield.dart';
import 'package:mobo_crm/global_methods/widgets/textfields/multi_select_textfield.dart';
import 'package:mobo_crm/global_methods/widgets/textfields/single_selection_textfield.dart';
import 'package:mobo_crm/initilisation.dart';
import 'package:mobo_crm/models/models.dart';

import 'package:mobo_crm/screens/quotation/provider/quotation_view_provider.dart';
import 'package:mobo_crm/screens/quotation/provider/quotebuilder_provider.dart';

import 'package:mobo_crm/screens/quotation/widgets/components/custom_components.dart';
import 'package:mobo_crm/screens/quotation/provider/quotation_form_provider.dart';
import 'package:provider/provider.dart';

import '../../../core/company/session/company_session_manager.dart';

/// A screen widget that displays and manages additional information for a quotation.
///
/// [OtherInfoScreen] provides a comprehensive form interface for editing or viewing
/// various optional and metadata fields associated with a quotation, including sales,
/// invoicing, shipping, and tracking information.
///
/// This widget supports both editable and read-only modes based on the [QuotationFormProvider.isEdit]
/// and [QuotationFormProvider.isAbsorbed] flags. It integrates with multiple providers to
/// fetch dynamic data such as salespersons, sales teams, fiscal positions, journals, campaigns,
/// sources, mediums, and tags.
///
/// The widget leverages custom reusable components such as:
/// - [SingleSelectSearchableDropdown] and [SingleSelectSearchableFuture] for searchable dropdowns.
/// - [MultiSelectSearchableDropdown] for selecting multiple tags.
/// - [CustomEditingFields] for text input fields.
/// - [CustomDatePickerField] for selecting delivery dates.
/// - [CustomCheckboxRow] for toggling boolean options.
///
/// ### Key Features:
/// 1. **Sales Section**
///    - Select a salesperson or view the assigned salesperson.
///    - Select a sales team or display the assigned team.
///    - Toggle online signature and online payment options.
///
/// 2. **Reference and Tags**
///    - Editable reference input field or view-only display.
///    - Multi-select CRM tags with badges in read-only mode.
///
/// 3. **Invoicing Section**
///    - Select fiscal position and invoice journal with searchable dropdowns.
///    - Editable and read-only display modes are supported.
///
/// 4. **Shipping Section**
///    - Editable delivery date using a date picker or read-only text.
///
/// 5. **Tracking Section**
///    - Enter source document information.
///    - Associate opportunity, campaign, source, and medium using dynamic searchable selections.
///
/// 6. **Provider Integration**
///    - Integrates with [QuotationFormProvider], [OdooClientManager], [QuoteBuilderProvider],
///      and [QuotationViewProvider] to fetch, update, and manage data.
///
/// ### Example Usage:
/// ```dart
/// OtherInfoScreen(
///   onFormChanged: () {
///     // Handle form changes
///   },
/// )
/// ```
///
/// ### Notes:
/// - Editable components are enabled only if `isEdit == true` and `isAbsorbed == false`.
/// - Dynamic items such as campaigns, fiscal positions, sources, and mediums are fetched
///   asynchronously using provider methods.
/// - Provides fallback display values ("None") when no data is available.
class OtherInfoScreen extends StatefulWidget {
  final VoidCallback? onFormChanged;

  /// Creates an instance of [OtherInfoScreen].
  const OtherInfoScreen({super.key, this.onFormChanged});

  @override
  State<OtherInfoScreen> createState() => _OtherInfoScreenState();
}

class _OtherInfoScreenState extends State<OtherInfoScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer4<QuotationFormProvider, OdooClientManager,
            QuoteBuilderProvider, QuotationViewProvider>(
        builder: (context, provider, clientprovider, quotebuilderprovider,
            quotationviewprovider, child) {
      return SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 18, vertical: 16),
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
              ),
              child: Row(
                children: [
                  HugeIcon(
                    icon: HugeIcons.strokeRoundedInformationCircle,
                    color: Colors.grey[700]!,
                    size: 22,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    "Other Information",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[900],
                      letterSpacing: -0.3,
                    ),
                  ),
                ],
              ),
            ),
            Divider(
              height: 1,
              color: Colors.grey[200],
              indent: 16,
              endIndent: 16,
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SectionTitle(title: 'Sales'),
                  const SizedBox(height: 20),
                  if (clientprovider.salesPersonItem.isNotEmpty) ...[
                    if (provider.isEdit) ...[
                      Text(
                        "Sales person",
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      SingleSelectSearchableDropdown<SalesPersonItem>(
                          isEditable: provider.isEdit,
                          items: clientprovider.salesPersonItem,
                          displayText: (item) => item.name,
                          hasImage: true,
                          initialValue: provider.orderpersonValue != null
                              ? clientprovider.salesPersonItem.firstWhere(
                                (item) => item.id == provider.orderpersonValue,
                          )
                              : null,
                          imageUrl: (item) {
                            return "${clientprovider.url}/web/image/res.users/${item.id}/avatar_128";
                          },
                          httpHeaders: (item) => {
                            "Cookie":
                            "session_id=${clientprovider.currentsession!.sessionId}",
                          },
                          onSelectionChanged: (selected) {
                            if (selected != null) {
                              setState(() {
                                provider.orderpersonValue = selected.id;
                              });
                            } else {
                              setState(() {
                                provider.orderpersonValue = null;
                              });
                            }
                          },
                          hintText: "Sales Person"),
                    ] else ...[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Sales person",
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            provider.orderpersonValue != null
                                ? clientprovider.salesPersonItem
                                .firstWhere(
                                  (item) =>
                              item.id == provider.orderpersonValue,
                              orElse: () => SalesPersonItem(
                                  id: 0,
                                  name: 'None',
                                  teamid: null,
                                  teamName: ''),
                            )
                                ?.name ??
                                'None'
                                : 'None',
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
                    SizedBox(
                      height: 20,
                    ),
                  ],
                  if (clientprovider.salesTeams.isNotEmpty) ...[
                    if (provider.isEdit) ...[
                      Text(
                        "Sales Team",
                        style: TextStyle(
                          color: AppColors().subHeading,
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      SingleSelectSearchableDropdown<SalesTeam>(
                          isEditable: provider.isEdit,
                          items: clientprovider.salesTeams,
                          displayText: (item) => item.name,
                          initialValue: provider.selectedTeamId != null
                              ? clientprovider.salesTeams.firstWhere(
                                (item) => item.id == provider.selectedTeamId,
                          )
                              : null,
                          onSelectionChanged: (selected) {
                            if (selected != null) {
                              setState(() {
                                provider.selectedTeamId = selected.id;
                              });
                            } else {
                              setState(() {
                                provider.selectedTeamId = null;
                              });
                            }
                          },
                          hintText: "Sales Team"),
                    ] else ...[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Sales Team",
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            provider.selectedTeamId != null
                                ? clientprovider.salesTeams
                                .firstWhere(
                                  (item) => item.id == provider.selectedTeamId,
                              orElse: () => SalesTeam(id: 0, name: 'None'),
                            )
                                .name
                                : 'None',
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
                    SizedBox(
                      height: 10,
                    ),
                  ],
                  provider.isEdit
                      ? CustomCheckboxRow(
                          label: 'Online Signature',
                          value: provider.onlineSignature,
                          onChanged: (value) {
                            if (provider.isAbsorbed == false) {
                              setState(() {
                                provider.onlineSignature = value!;
                              });
                            }
                          },
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Online Signature',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              provider.onlineSignature ? 'Done' : 'No',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey[800],
                              ),
                            ),
                          ],
                        ),
                  const SizedBox(height: 10),
                  provider.isEdit
                      ? CustomCheckboxRow(
                          onChanged: (value) {
                            if (provider.isAbsorbed == false) {
                              setState(() {
                                provider.onlinePayment = value!;
                              });
                            }
                          },
                          label: 'Online Payment',
                          value: provider.onlinePayment,
                          valueText: 'of 100%',
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Online Payment',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              provider.onlinePayment ? 'Done' : 'No',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey[800],
                              ),
                            ),
                          ],
                        ),
                  SizedBox(
                    height: 10,
                  ),
                  provider.isEdit
                      ? CustomEditingFields(
                      title: "Reference",
                      controller: provider.referenceController,
                      hintText: "Reference",
                      isEditable: provider.isEdit)
                      : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Reference",
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        provider.referenceController.text.isEmpty
                            ? "None"
                            : provider.referenceController.text,
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.normal,
                          fontSize: 14,
                        ),
                        textAlign: TextAlign.end,
                      ),
                    ],
                  ),
                  if (clientprovider.crmTagDetails.isNotEmpty) ...[
                    SizedBox(
                      height: 10,
                    ),
                    if (provider.isEdit) ...[
                      Text(
                        "Tags",
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      MultiSelectSearchableDropdown<LeadTag>(
                          idSelector: (item) => item.id,
                          iseditable: provider.isEdit,
                          initialValue: clientprovider.crmTagDetails
                              .where((element) =>
                              provider.selectedTagIds.contains(element.id))
                              .toList(),
                          items: clientprovider.crmTagDetails,
                          displayText: (item) => item.name,
                          onSelectionChanged: (item) {
                            setState(() {
                              provider.selectedTagIds =
                                  item.map((e) => e.id).toList();
                              provider.isChanged = true;
                            });
                          },
                          hintText: "Select Tags"),
                    ] else ...[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: Text(
                              "Tags",
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          Flexible(
                            child: Wrap(
                              alignment: WrapAlignment.end,
                              spacing: 6,
                              runSpacing: 6,
                              children: provider.selectedTagIds.map((tagId) {
                                try {
                                  final tag =
                                  clientprovider.crmTagDetails.firstWhere(
                                        (t) => t.id == tagId,
                                  );

                                  return Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFFCE7EE),
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(
                                        color: const Color(0xFFC03355).withValues(alpha: 0.35),
                                        width: 1,
                                      ),
                                    ),
                                    child: Text(
                                      tag.name,
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Color(0xFFC03355),
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  );
                                } catch (_) {
                                  return const SizedBox.shrink();
                                }
                              }).toList(),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                  const SizedBox(height: 24),
                  const SectionTitle(
                    title: 'Invoicing',
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  if (provider.isEdit) ...[
                    Text(
                      "Fiscal Position",
                      style: TextStyle(
                        color: AppColors().subHeading,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    SingleSelectSearchableFuture<FiscalPosition>(
                      initialValue: provider.selectedFiscalId,
                      items: [],
                      idSelector: (fiscal) => fiscal.id,
                      displayText: (fiscal) => fiscal.name,
                      onSelectionChanged: (fiscal) {},
                      hintText: 'Select a Fiscal Position',
                      onEmptyItemsFetch: () async {
                        final fiscalresponse =
                        await CompanySessionManager.callKwWithCompany({
                          'model': 'account.fiscal.position',
                          'method': 'search_read',
                          'args': [],
                          'kwargs': {
                            'fields': ['name', 'id'],
                            'domain': [
                              '|',
                              [
                                'company_id',
                                '=',
                                clientprovider.currentsession!.companyId
                              ],
                              ['company_id', '=', false],
                            ],
                          },
                        });
                        return (fiscalresponse as List)
                            .map((item) =>
                            FiscalPosition.fromJson(item as Map<String, dynamic>))
                            .toList();
                      },
                      isEditable: provider.isEdit,
                    ),
                  ] else ...[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Fiscal Position",
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          provider.selectedFiscalId?.name ?? "None",
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
                  SizedBox(
                    height: 10,
                  ),
                  if (provider.isEdit) ...[
                    Text(
                      "Invoice Journal",
                      style: TextStyle(
                        color: AppColors().subHeading,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    SingleSelectSearchableFuture<AccountJournal>(
                      initialValue: provider.journalId,
                      items: [],
                      idSelector: (journal) => journal.id,
                      displayText: (journal) => journal.name,
                      onSelectionChanged: (journal) {
                        if (journal != null) {
                          setState(() {
                            provider.journalId = journal;
                          });
                        } else {
                          provider.journalId = null;
                        }
                      },
                      hintText: 'Select a Invoice Journal',
                      onEmptyItemsFetch: () async {
                        final response =
                        await CompanySessionManager.callKwWithCompany({
                          'model': 'account.journal',
                          'method': 'search_read',
                          'args': [],
                          'kwargs': {
                            'fields': ['name'],
                            'domain': [
                              '|',
                              ['company_id', '=', false],
                              [
                                'company_id',
                                'parent_of',
                                [clientprovider.currentsession!.companyId]
                              ],
                              ['type', '=', 'sale'],
                            ],
                          },
                        });

                        return (response as List)
                            .map((item) =>
                            AccountJournal.fromJson(item as Map<String, dynamic>))
                            .toList();
                      },
                      isEditable: provider.isEdit,
                    ),
                  ] else ...[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Invoice Journal",
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          provider.journalId?.name ?? "None",
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
                  const SizedBox(height: 24),
                  const SectionTitle(title: 'Shipping'),
                  const SizedBox(height: 20),
                  if (provider.isEdit) ...[
                    Text(
                      "Delivery Date",
                      style: TextStyle(
                        color: AppColors().subHeading,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    CustomDatePickerField(
                        isEditable: provider.isEdit && provider.isAbsorbed == false,
                        onDateChanged: (value) {
                          setState(() {
                            provider.formatDateDelivery.text = value!;
                          });
                        },
                        hintText: "Delivery Date"),
                  ] else ...[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Delivery Date",
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          provider.formatDateDelivery.text.isEmpty
                              ? "None"
                              : provider.formatDateDelivery.text,
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
                  const SizedBox(height: 24),
                  const SectionTitle(title: 'Tracking'),
                  const SizedBox(height: 20),
                  if (provider.isEdit) ...[
                    CustomEditingFields(
                        title: 'Source Document',
                        controller: provider.documentController,
                        hintText: 'Source Document',
                        isEditable: provider.isEdit)
                  ] else ...[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Source Document",
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          provider.documentController.text.isEmpty
                              ? "None"
                              : provider.documentController.text,
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
                  if (clientprovider.leadItems.isNotEmpty) ...[
                    SizedBox(
                      height: 10,
                    ),
                    if (provider.isEdit) ...[
                      Text(
                        "Opportunity",
                        style: TextStyle(
                          color: AppColors().subHeading,
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      SingleSelectSearchableDropdown<LeadItem>(
                          isEditable: provider.isEdit,
                          items: clientprovider.leadItems,
                          displayText: (item) => item.name!,
                          initialValue: provider.currentopportunityId != null
                              ? clientprovider.leadItems.firstWhere(
                                (item) => item.id == provider.currentopportunityId,
                          )
                              : null,
                          onSelectionChanged: (selected) {
                            if (selected != null) {
                              setState(() {
                                provider.currentopportunityId = selected.id;
                              });
                            } else {
                              setState(() {
                                provider.currentopportunityId = null;
                              });
                            }
                          },
                          hintText: "Opportunity"),
                    ] else ...[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Opportunity",
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            provider.currentopportunityId != null
                                ? clientprovider.leadItems
                                .firstWhere(
                                  (item) =>
                              item.id ==
                                  provider.currentopportunityId,
                              orElse: () => LeadItem(
                                  id: 0,
                                  name: 'None',
                                  contactname: '',
                                  createdon: '',
                                  email: '',
                                  salesperson: '',
                                  stage: ''),
                            )
                                .name ??
                                'None'
                                : 'None',
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
                    SizedBox(
                      height: 10,
                    ),
                  ],
                  if (provider.isEdit) ...[
                    Text(
                      "Campaign",
                      style: TextStyle(fontSize: 16, color: AppColors().subHeading),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: SingleSelectSearchableFuture<Campaign>(
                            initialValue: provider.selectedcampaignId,
                            items: [],
                            idSelector: (item) => item.id,
                            displayText: (campaign) => campaign.name,
                            onSelectionChanged: (campaign) {
                              setState(() {
                                if (campaign != null) {
                                  provider.selectedcampaignId = campaign;
                                }
                              });
                            },
                            hintText: 'Select a campaign',
                            onEmptyItemsFetch: () async {
                              return await provider
                                  .fetchCampaigns(clientprovider.client!);
                            },
                            isEditable: provider.isEdit,
                          ),
                        ),
                      ],
                    ),
                  ] else ...[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Campaign",
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          provider.selectedcampaignId?.name ?? "None",
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
                  SizedBox(
                    height: 10,
                  ),
                  if (provider.isEdit) ...[
                    Text(
                      "Source",
                      style: TextStyle(fontSize: 16, color: AppColors().subHeading),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: SingleSelectSearchableFuture<Source>(
                            initialValue: provider.selectedSourceId,
                            items: [],
                            idSelector: (item) => item.id,
                            displayText: (source) => source.name,
                            onSelectionChanged: (source) {
                              setState(() {
                                if (source != null) {
                                  provider.selectedSourceId = source;
                                }
                              });
                            },
                            hintText: 'Select a Source',
                            onEmptyItemsFetch: () async {
                              return await provider
                                  .fetchSources(clientprovider.client!);
                            },
                            isEditable: provider.isEdit,
                          ),
                        ),
                      ],
                    ),
                  ] else ...[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Source",
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          provider.selectedSourceId?.name ?? "None",
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
                  SizedBox(
                    height: 10,
                  ),
                  if (provider.isEdit) ...[
                    Text(
                      "Medium",
                      style: TextStyle(fontSize: 16, color: AppColors().subHeading),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: SingleSelectSearchableFuture<Medium>(
                            initialValue: provider.selectedMediumId,
                            items: [],
                            idSelector: (item) => item.id,
                            displayText: (medium) => medium.name,
                            onSelectionChanged: (medium) {
                              setState(() {
                                if (medium != null) {
                                  provider.selectedMediumId = medium;
                                }
                              });
                            },
                            hintText: 'Select a Medium',
                            onEmptyItemsFetch: () async {
                              return await provider
                                  .fetchMediums(clientprovider.client!);
                            },
                            isEditable: provider.isEdit,
                          ),
                        ),
                      ],
                    ),
                  ] else ...[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Medium",
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          provider.selectedMediumId?.name ?? "None",
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
                  SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }
}
