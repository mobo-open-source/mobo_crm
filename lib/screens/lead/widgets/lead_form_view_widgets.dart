import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:mobo_crm/global_methods/const.dart';
import 'package:mobo_crm/global_methods/widgets/buttons/form_view_icon.dart';
import 'package:mobo_crm/global_methods/widgets/date_picker/custom_date_picker.dart';
import 'package:mobo_crm/global_methods/widgets/stage_widget.dart';
import 'package:mobo_crm/global_methods/widgets/textfields/custom_editing_fields.dart';
import 'package:mobo_crm/global_methods/widgets/textfields/future_single_selection_textfield.dart';
import 'package:mobo_crm/global_methods/widgets/textfields/multi_select_textfield.dart';
import 'package:mobo_crm/global_methods/widgets/textfields/single_selection_textfield.dart';
import 'package:mobo_crm/global_methods/widgets/transition/page_transition.dart';
import 'package:mobo_crm/initilisation.dart';
import 'package:mobo_crm/models/models.dart';
import 'package:mobo_crm/screens/lead/providers/lead_data_provider.dart';
import 'package:mobo_crm/screens/lead/providers/lead_form_provider.dart';
import 'package:mobo_crm/screens/lead/widgets/address_tab_widget.dart';
import 'package:mobo_crm/screens/lead/widgets/contact_tab_widget.dart';
import 'package:mobo_crm/screens/lead/widgets/messge_screen.dart';
import 'package:mobo_crm/screens/opportunity/providers/opportunity_data_provider.dart';
import 'package:mobo_crm/screens/quotation/provider/quotation_form_provider.dart';
import 'package:provider/provider.dart';
import '../../../global_methods/dialog boxes/loading_dialog.dart';
import '../../../utils/snackbar.dart';

/// Main content widget for Lead/Opportunity create & edit form.
///
/// This widget renders the primary pipeline information section:
/// - Stage (for opportunities)
/// - Name, expected revenue, probability
/// - Customer, salesperson, sales team
/// - Expected closing date
/// - Tags
/// - Action buttons (edit/save, messages, convert, lost/won/restore)
///
/// It supports both:
/// - View mode (read-only)
/// - Edit mode (form inputs + validation)
///
/// Uses multiple providers:
/// - [LeadFormProvider] for form state & CRUD actions
/// - [OdooClientManager] for API client & session
/// - [QuotationFormProvider] for quotation creation
/// - [OpportunityDataProvider] for refreshing opportunity lists
///
/// Params:
/// - [leadData]: Existing lead/opportunity data (empty for new records)
/// - [type]: Either `"lead"` or `"opportunity"`
class MainContentWidget extends StatefulWidget {
  final dynamic leadData;
  final String type;

  const MainContentWidget({
    super.key,
    required this.leadData,
    required this.type,
  });

  @override
  State<MainContentWidget> createState() => _MainContentWidgetState();
}

/// State class for [MainContentWidget].
///
/// Handles:
/// - Form validation using [_formKey]
/// - Switching between edit and view mode
/// - Submitting create/update actions
/// - Triggering related actions like:
///   - Fetching messages
///   - Converting lead to opportunity
///   - Marking opportunity as won/lost
///   - Restoring archived records
class _MainContentWidgetState extends State<MainContentWidget> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Consumer4<LeadFormProvider, OdooClientManager, QuotationFormProvider,
            OpportunityDataProvider>(
        builder:
            (context, provider, clientprovider, quotation, opportunity, child) {
      return Stack(children: [
        Form(
          key: _formKey,
          child: Column(
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
                  'Pipeline Information',
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
                    if (provider.isEdit &&
                        provider.data['type'] == 'opportunity' &&
                        provider.active == true &&
                        provider.initialState != null) ...[
                      Text(
                        "Stage",
                        style: TextStyle(
                          color: AppColors().subHeading,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 10),
                      StageWidget(
                        isExpanded: true,
                        stageName: provider.currentStageName ?? "New",
                        isEditable: provider.isEdit &&
                            provider.stagesList.isNotEmpty,
                        stageOptions: provider.stagesList.isNotEmpty
                            ? provider.stagesList
                                .map((e) => e['name'] as String)
                                .toSet()
                                .toList()
                            : null,
                        onStageChanged: (value) {
                          final selectedStage = provider.stagesList.firstWhere(
                            (stage) => stage['name'] == value,
                            orElse: () => {'id': 0},
                          );
                          provider.updateStageId(selectedStage['id']);
                        },
                        fontSize: 16,
                      ),
                    SizedBox(
                      height: 12,
                    ),
                    ],
                    if (!provider.isEdit)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Spacer(),
                          if (provider.data['type'] == 'opportunity' &&
                              provider.active == true &&
                              provider.initialState != null) ...[
                            StageWidget(
                              stageName: provider.currentStageName ?? "New",
                              isEditable: provider.isEdit &&
                                  provider.stagesList.isNotEmpty,
                              stageOptions: provider.stagesList.isNotEmpty
                                  ? provider.stagesList
                                      .map((e) => e['name'] as String)
                                      .toSet()
                                      .toList()
                                  : null,
                              onStageChanged: (value) {
                                final selectedStage =
                                    provider.stagesList.firstWhere(
                                  (stage) => stage['name'] == value,
                                  orElse: () => {'id': 0},
                                );
                                provider.updateStageId(selectedStage['id']);
                              },
                              fontSize: 16,
                            ),
                          ],
                          if (!provider.isEdit) ...[
                          if (widget.leadData.isNotEmpty) ...[
                            Consumer3<LeadFormProvider, OdooClientManager,
                                    OpportunityDataProvider>(
                                builder: (context, provider, clientprovider,
                                    opportunitydataprovider, child) {
                              return FormViewCustomIcon(
                                icon: FontAwesomeIcons.message.data,
                                onTap: () {
                                  if (widget.leadData.isNotEmpty) {
                                    provider.fetchMessages(
                                        clientprovider.client!,
                                        'crm.lead',
                                        widget.leadData['id'],
                                        loading: true);

                                    Navigator.push(
                                        context,
                                        SlidingPageTransitionRL(
                                            page: MessagesScreen(
                                          model: 'crm.lead',
                                          id: widget.leadData['id'],
                                          leadData: widget.leadData,
                                        )));
                                  } else {
                                    CustomSnackbar.showWarning(context,
                                        'Create The ${widget.type} First');
                                  }
                                },
                                isIcon: false,
                                url: "assets/message.png",
                              );
                            }),
                            SizedBox(
                              width: 8,
                            ),
                          ],
                          Consumer4<LeadFormProvider, OdooClientManager,
                                  OpportunityDataProvider, LeadDataProvider>(
                              builder: (context,
                                  provider,
                                  clientprovider,
                                  opportunitydataprovider,
                                  leaddataprovider,
                                  child) {
                            return FormViewCustomIcon(
                                icon: provider.isEdit
                                    ? Icons.save
                                    : FontAwesomeIcons.penToSquare.data,
                                buttonColor: Colors.black,
                                onTap: () async {
                                  if (provider.isEdit) {
                                    if (provider.nameController.text.isEmpty) {
                                      CustomSnackbar.showWarning(
                                          context, 'Name can\'t be empty');
                                    }
                                    if (_formKey.currentState!.validate()) {
                                      if (provider.data['id'] != null) {
                                        bool success =
                                            await provider.saveChanges(
                                          clientprovider.client!,
                                          context,
                                          {'id': provider.data['id']},
                                        );

                                        if (success) {
                                          if (context.mounted) {
                                            if (widget.type == 'opportunity') {
                                              await opportunitydataprovider
                                                  .getOpportunities(
                                                      isPop: false,
                                                      loading: true,
                                                      context: context,
                                                      isOpportunity: true,
                                                      isLead: false);
                                            } else {
                                              await leaddataprovider.getLeads(
                                                  context: context);
                                            }
                                          }
                                        } else {
                                          if (context.mounted) {
                                            CustomSnackbar.showError(context,
                                                'Error saving changes');
                                          }
                                        }
                                      } else {
                                        final success =
                                            await provider.createOpportunity(
                                                clientprovider.client!,
                                                context,
                                                widget.type);

                                        if (success) {
                                          if (context.mounted) {
                                            if (widget.type == 'opportunity') {
                                              await opportunitydataprovider
                                                  .getOpportunities(
                                                      isPop: false,
                                                      loading: true,
                                                      context: context,
                                                      isOpportunity: true,
                                                      isLead: false);
                                            } else {
                                              await leaddataprovider.getLeads(
                                                  context: context);
                                            }
                                          }
                                        } else {
                                          if (context.mounted) {
                                            CustomSnackbar.showError(context,
                                                'Error saving changes');
                                          }
                                        }
                                      }
                                    }
                                  } else {
                                    provider.changeToEdit();
                                  }
                                });
                          }),
                          if (widget.leadData.isNotEmpty &&
                              widget.type == 'lead') ...[
                            PopupMenuButton<String>(
                              color: AppColors().fillColor,
                              padding: EdgeInsets.all(0),
                              onSelected: (value) async {
                                if (widget.type == 'lead') {
                                  if (value == "Convert To Opportunity") {
                                    showDialog(
                                      context: context,
                                      barrierDismissible: false,
                                      builder: (context) =>
                                          const GlobalLoadingDialog(
                                              message: "Loading..."),
                                    );

                                    bool success =
                                        await provider.getDuplicatedLeads(
                                      widget.leadData['id'],
                                      context,
                                    );

                                    if (context.mounted) {
                                      Navigator.pop(context);
                                    }

                                    if (success && context.mounted) {
                                      provider.showConversionPopup(
                                          context, widget.leadData);
                                    } else if (context.mounted) {
                                      CustomSnackbar.showError(context,
                                          'Failed to fetch duplicated leads');
                                    }
                                  } else if (value == 'Lost') {
                                    provider.showBottomSheet(
                                        context, widget.leadData);
                                  } else if (value == 'Restore') {
                                    provider.restore(clientprovider.client!,
                                        widget.leadData, context);
                                  }
                                }
                              },
                              itemBuilder: (BuildContext context) {
                                final List<String> choices = [];

                                if (provider.active == true ||
                                    provider.initialState == 'Lost') {
                                  choices.add('Convert To Opportunity');
                                }

                                if (provider.active == true ||
                                    provider.probablity! > 0.0) {
                                  choices.add('Lost');
                                } else {
                                  choices.add('Restore');
                                }

                                return choices.map((String choice) {
                                  return PopupMenuItem<String>(
                                    value: choice,
                                    child: Text(choice),
                                  );
                                }).toList();
                              },
                            ),
                          ],
                          if (widget.leadData.isNotEmpty &&
                              widget.leadData['type'] == "opportunity") ...[
                            Builder(builder: (BuildContext ctx) {
                              return PopupMenuButton<String>(
                                color: AppColors().fillColor,
                                padding: EdgeInsets.all(0),
                                onSelected: (value) async {
                                  if (widget.type == 'opportunity') {
                                    if (value == "New Quotation") {
                                      showDialog(
                                        context: context,
                                        barrierDismissible: false,
                                        builder: (context) =>
                                            const GlobalLoadingDialog(
                                                message: "Loading.."),
                                      );
                                      if (ctx.mounted) {
                                        if (widget.leadData['user_id'] ==
                                            false) {
                                          quotation.checkPartner(
                                            forceNoPartner: true,
                                            clientprovider.client!,
                                            widget.leadData,
                                            ctx,
                                            clientprovider.currentsession!,
                                          );
                                        } else {
                                          quotation.setDefaultData(
                                              client: clientprovider.client!,
                                              context: ctx);
                                          quotation.checkPartner(
                                            forceNoPartner: false,
                                            clientprovider.client!,
                                            widget.leadData,
                                            ctx,
                                            clientprovider.currentsession!,
                                          );
                                        }
                                      }
                                    } else if (value == 'Lost') {
                                      final success =
                                          await provider.showBottomSheet(
                                              ctx, widget.leadData);
                                      if (success && ctx.mounted) {
                                        await opportunity.getOpportunities(
                                          context: ctx,
                                          isLead: false,
                                          isOpportunity: true,
                                          isPop: false,
                                          loading: true,
                                        );
                                        Navigator.pop(ctx);
                                      }
                                    } else if (value == 'Won') {
                                      if (ctx.mounted) {
                                        final success =
                                            await provider.markLeadAsWon(
                                          widget.leadData['id'],
                                          ctx,
                                          widget.leadData,
                                        );
                                        if (success && ctx.mounted) {
                                          await opportunity.getOpportunities(
                                            context: ctx,
                                            isLead: false,
                                            isOpportunity: true,
                                            isPop: false,
                                            loading: true,
                                          );
                                        }
                                      }
                                    } else if (value == 'Restore') {
                                      provider.restore(clientprovider.client!,
                                          widget.leadData, ctx);
                                    }
                                  }
                                },
                                itemBuilder: (BuildContext context) {
                                  final allowedStages = [
                                    'New',
                                    'Qualified',
                                    'Proposition'
                                  ];
                                  if (provider.active == false &&
                                      provider.probablityController.text ==
                                          '0.0') {
                                    return {
                                      'Restore',
                                    }.map((String choice) {
                                      return PopupMenuItem<String>(
                                        value: choice,
                                        child: Text(choice),
                                      );
                                    }).toList();
                                  }
                                  if (provider.initialState == 'Won') {
                                    return {
                                      'New Quotation',
                                      'Lost',
                                    }.map((String choice) {
                                      return PopupMenuItem<String>(
                                        value: choice,
                                        child: Text(choice),
                                      );
                                    }).toList();
                                  }
                                  return {
                                    if (allowedStages
                                        .contains(provider.initialState))
                                      'New Quotation',
                                    if (allowedStages
                                            .contains(provider.initialState) &&
                                        provider.active == true)
                                      'Won',
                                    if (allowedStages
                                            .contains(provider.initialState) &&
                                        provider.active == true)
                                      'Lost',
                                    if (!allowedStages
                                            .contains(provider.initialState) ||
                                        provider.active == false)
                                      'Restore',
                                  }.map((String choice) {
                                    return PopupMenuItem<String>(
                                      value: choice,
                                      child: Text(choice),
                                    );
                                  }).toList();
                                },
                              );
                            }),
                          ],
                        ]
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    CustomEditingFields(
                        isRequired: true,
                        onChanged: (p0) {
                          _formKey.currentState!.validate();
                        },
                        validator: (p0) {
                          if (p0 == null || p0.isEmpty) {
                            return "Name is required";
                          }
                          return null;
                        },
                        title: "Name",
                        controller: provider.nameController,
                        hintText: "Enter a Name",
                        isEditable: provider.isEdit),
                    Row(
                      children: [
                        if (provider.data['type'] == 'opportunity') ...[
                          Expanded(
                            child: CustomEditingFields(
                                isPrefix: true,
                                prefixicon: Icon(
                                  HugeIcons.strokeRoundedDollar02,
                                  size: 15,
                                ),
                                inputType: TextInputType.number,
                                title: "Expected Revenue",
                                controller: provider.expectedRevenueController,
                                hintText: "Expected Revenue",
                                isEditable: provider.isEdit),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                        ],
                        Expanded(
                          child: CustomEditingFields(
                              isPrefix: true,
                              inputType: TextInputType.number,
                              prefixicon: Icon(
                                HugeIcons.strokeRoundedPercent,
                                size: 15,
                              ),
                              title: "Probability",
                              controller: provider.probablityController,
                              hintText: "Probability",
                              isEditable: provider.isEdit),
                        ),
                      ],
                    ),
                    if (clientprovider.customerItems.isNotEmpty) ...[
                      Row(
                        children: [
                          Text(
                            "Customer",
                            style: TextStyle(
                              color: AppColors().subHeading,
                              fontSize: 16,
                            ),
                          ),
                          Spacer(),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      SingleSelectSearchableDropdown<CustomerItem>(
                        isEditable: provider.isEdit,
                        items: clientprovider.customerItems,
                        displayText: (item) => item.name,
                        hasImage: true,
                        initialValue: provider.selectedPartnerId != null
                            ? clientprovider.customerItems.firstWhere(
                                (item) => item.id == provider.selectedPartnerId,
                                orElse: () =>
                                    clientprovider.customerItems.first,
                              )
                            : null,
                        imageUrl: (item) {
                          return "${clientprovider.url}/web/image/res.partner/${item.id}/avatar_128";
                        },
                        httpHeaders: (item) => {
                          "Cookie":
                              "session_id=${clientprovider.currentsession!.sessionId}",
                        },
                        onSelectionChanged: (selected) {
                          setState(() {
                            provider.selectedPartnerId = selected?.id;
                          });
                          provider.markFormEdited();
                        },
                        hintText: "Customer",
                      ),
                      SizedBox(height: 20),
                    ],
                    CustomEditingFields(
                        actionType: FieldActionType.email,
                        title: "Email",
                        controller: provider.emailController,
                        hintText: "Enter a Email",
                        isEditable: provider.isEdit),
                    CustomEditingFields(
                        actionType: FieldActionType.phone,
                        inputType: TextInputType.number,
                        title: "Phone",
                        controller: provider.phoneController,
                        hintText: "Enter a Number",
                        isEditable: provider.isEdit),
                    if (clientprovider.salesPersonItem.isNotEmpty) ...[
                      Row(
                        children: [
                          Text(
                            "Sales person",
                            style: TextStyle(
                              color: AppColors().subHeading,
                              fontSize: 16,
                            ),
                          ),
                          Spacer(),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      SingleSelectSearchableDropdown<SalesPersonItem>(
                          isEditable: provider.isEdit,
                          items: clientprovider.salesPersonItem,
                          displayText: (item) => item.name,
                          hasImage: true,
                          initialValue: provider.selectedSalespersonId != null
                              ? clientprovider.salesPersonItem.firstWhere(
                                  (item) =>
                                      item.id == provider.selectedSalespersonId,
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
                                provider.selectedSalespersonId = selected.id;
                              });
                            } else {
                              setState(() {
                                provider.selectedSalespersonId = null;
                              });
                            }
                            provider.markFormEdited();
                          },
                          hintText: "Sales Person"),
                      SizedBox(
                        height: 12,
                      ),
                    ],
                    if (provider.data['type'] == 'lead') ...[
                      Text(
                        "Sales Team",
                        style: TextStyle(
                            fontSize: 16, color: AppColors().subHeading),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      if (clientprovider.salesTeams.isNotEmpty) ...[
                        SingleSelectSearchableDropdown<SalesTeam>(
                            isEditable: provider.isEdit,
                            items: clientprovider.salesTeams,
                            displayText: (item) => item.name,
                            initialValue: provider.selectedSalesTeamId != null
                                ? clientprovider.salesTeams.firstWhere(
                                    (item) =>
                                        item.id == provider.selectedSalesTeamId,
                                  )
                                : null,
                            onSelectionChanged: (selected) {
                              if (selected != null) {
                                setState(() {
                                  provider.selectedSalesTeamId = selected.id;
                                });
                              } else {
                                setState(() {
                                  provider.selectedSalesTeamId = null;
                                });
                              }
                              provider.markFormEdited();
                            },
                            hintText: "Sales Team"),
                        SizedBox(
                          height: 20,
                        ),
                      ],
                    ],
                    if (provider.data['type'] == 'opportunity') ...[
                      Row(
                        children: [
                          Text(
                            "Expected Closing",
                            style: TextStyle(
                              color: AppColors().subHeading,
                              fontSize: 16,
                            ),
                          ),
                          Spacer(),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      CustomDatePickerField(
                        isEditable: provider.isEdit,
                        onDateChanged: (date) {
                          setState(() {
                            provider.expectedClosing = date!;
                          });
                          provider.markFormEdited();
                        },
                        hintText: 'Select a date',
                        initialValue: provider.expectedClosing,
                      ),
                      SizedBox(
                        height: 12,
                      ),
                    ],
                    if (clientprovider.crmTagDetails.isNotEmpty) ...[
                      Row(
                        children: [
                          Text(
                            "Tags",
                            style: TextStyle(
                              color: AppColors().subHeading,
                              fontSize: 16,
                            ),
                          ),
                          Spacer(),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      MultiSelectSearchableDropdown<LeadTag>(
                          idSelector: (item) => item.id,
                          iseditable: provider.isEdit,
                          initialValue: provider.leadTags,
                          items: clientprovider.crmTagDetails,
                          displayText: (item) => item.name,
                          onSelectionChanged: (item) {
                            setState(() {
                              provider.selectedTagIds =
                                  item.map((e) => e.id).toList();
                            });
                            provider.markFormEdited();
                          },
                          onTap: () async {
                            if (clientprovider.crmTagDetails.isEmpty) {
                              await clientprovider.getTags();
                            }
                          },
                          hintText: "Select Tags"),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ]);
    });
  }
}

/// Tab-based layout widget for Lead/Opportunity form sections.
///
/// Displays four tabs:
/// - Contact
/// - Address
/// - Marketing
/// - Tracking (for opportunities) / Analysis (for leads)
///
/// Each tab contains a scrollable form section and reacts to edit/view mode.
/// Internally manages its own [TabController].
///
/// Params:
/// - [leadData]: Lead or opportunity record data
/// - [type]: Either `"lead"` or `"opportunity"`
class CustomTabBarLeadForm extends StatefulWidget {
  final dynamic leadData;
  final String type;
  final bool showTabBar;

  const CustomTabBarLeadForm(
      {super.key,
      required this.leadData,
      required this.type,
      this.showTabBar = true});

  @override
  CustomTabBarLeadFormState createState() => CustomTabBarLeadFormState();
}

/// State class for [CustomTabBarLeadForm].
///
/// Responsibilities:
/// - Initializes and disposes [TabController]
/// - Builds pill-style tabs with animated selection
/// - Renders tab content for:
///   - Contact
///   - Address
///   - Marketing (Campaign, Source, Medium, Reference)
///   - Tracking / Analysis information
class CustomTabBarLeadFormState extends State<CustomTabBarLeadForm>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Widget buildTabBar(String type) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double available = constraints.maxWidth.isFinite
            ? constraints.maxWidth
            : MediaQuery.of(context).size.width - 32;
        const double gap = 8.0;
        final double tabWidth = (available - gap * 3) / 4;

        return AnimatedBuilder(
          animation: _tabController.animation!,
          builder: (context, _) {
            final int activeIndex = _tabController.animation!.value.round();
            final String label4 =
                type == 'opportunity' ? "Tracking" : "Analysis";
            return SizedBox(
              height: 40,
              child: Row(
                children: [
                  _buildPillTab(
                    context: context,
                    label: "Contact",
                    isSelected: activeIndex == 0,
                    onTap: () => _tabController.animateTo(0),
                    width: tabWidth,
                  ),
                  const SizedBox(width: gap),
                  _buildPillTab(
                    context: context,
                    label: "Address",
                    isSelected: activeIndex == 1,
                    onTap: () => _tabController.animateTo(1),
                    width: tabWidth,
                  ),
                  const SizedBox(width: gap),
                  _buildPillTab(
                    context: context,
                    label: "Marketing",
                    isSelected: activeIndex == 2,
                    onTap: () => _tabController.animateTo(2),
                    width: tabWidth,
                  ),
                  const SizedBox(width: gap),
                  _buildPillTab(
                    context: context,
                    label: label4,
                    isSelected: activeIndex == 3,
                    onTap: () => _tabController.animateTo(3),
                    width: tabWidth,
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer4<LeadFormProvider, OdooClientManager,
            OpportunityDataProvider, LeadDataProvider>(
        builder: (context, provider, clientprovider, opportunitydataprovider,
            leaddataprovider, child) {
      return Column(
        children: [
          if (widget.showTabBar)
            Padding(
              padding: const EdgeInsets.only(bottom: 15),
              child: buildTabBar(provider.data['type'] == 'opportunity'
                  ? 'opportunity'
                  : 'lead'),
            ),
          Expanded(
              child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.06),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: TabBarView(
            controller: _tabController,
            children: [
              SingleChildScrollView(
                child: ContactTabWidget(
                  isEdit: provider.isEdit,
                  leadData: widget.leadData,
                  type: widget.type,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(15),
                child: SingleChildScrollView(
                  child: AddressTabWidget(
                    isEdit: provider.isEdit,
                    leadData: widget.leadData,
                    type: widget.type,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(15),
                child: SingleChildScrollView(
                  child: Column(
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
                          "Marketing Information",
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
                            if (provider.isEdit) ...[
                              Text(
                                "Campaign",
                                style: TextStyle(
                                    color: Colors.black54,
                                    fontSize: 16,
                                    fontWeight: FontWeight.normal),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child:
                                        SingleSelectSearchableFuture<Campaign>(
                                      initialValue: provider.selectedCampaign,
                                      items: [],
                                      idSelector: (item) => item.id,
                                      displayText: (campaign) => campaign.name,
                                      onSelectionChanged: (campaign) {
                                        setState(() {
                                          if (campaign != null) {
                                            provider.selectedCampaign =
                                                campaign;
                                          }
                                        });
                                        provider.markFormEdited();
                                      },
                                      hintText: 'Select a campaign',
                                      onEmptyItemsFetch: () async {
                                        return await provider.fetchCampaigns(
                                            clientprovider.client!);
                                      },
                                      isEditable: provider.isEdit,
                                    ),
                                  ),
                                ],
                              ),
                            ] else ...[
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Campaign",
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Text(
                                    provider.selectedCampaign?.name ?? "None",
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
                            SizedBox(
                              height: 20,
                            ),
                            if (provider.isEdit) ...[
                              Text(
                                "Source",
                                style: TextStyle(
                                    color: Colors.black54,
                                    fontSize: 16,
                                    fontWeight: FontWeight.normal),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: SingleSelectSearchableFuture<Source>(
                                      initialValue: provider.selectedSource,
                                      items: [],
                                      idSelector: (item) => item.id,
                                      displayText: (source) => source.name,
                                      onSelectionChanged: (source) {
                                        setState(() {
                                          if (source != null) {
                                            provider.selectedSource = source;
                                          }
                                        });
                                        provider.markFormEdited();
                                      },
                                      hintText: 'Select a Source',
                                      onEmptyItemsFetch: () async {
                                        return await provider.fetchSources(
                                            clientprovider.client!);
                                      },
                                      isEditable: provider.isEdit,
                                    ),
                                  ),
                                ],
                              ),
                            ] else ...[
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Source",
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Text(
                                    provider.selectedSource?.name ?? "None",
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
                            SizedBox(
                              height: 20,
                            ),
                            if (provider.isEdit) ...[
                              Text(
                                "Medium",
                                style: TextStyle(
                                    color: Colors.black54,
                                    fontSize: 16,
                                    fontWeight: FontWeight.normal),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: SingleSelectSearchableFuture<Medium>(
                                      initialValue: provider.selectedMedium,
                                      items: [],
                                      idSelector: (item) => item.id,
                                      displayText: (medium) => medium.name,
                                      onSelectionChanged: (medium) {
                                        setState(() {
                                          if (medium != null) {
                                            provider.selectedMedium = medium;
                                          }
                                        });
                                        provider.markFormEdited();
                                      },
                                      hintText: 'Select a Medium',
                                      onEmptyItemsFetch: () async {
                                        return await provider.fetchMediums(
                                            clientprovider.client!);
                                      },
                                      isEditable: provider.isEdit,
                                    ),
                                  ),
                                ],
                              ),
                            ] else ...[
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Medium",
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Text(
                                    provider.selectedMedium?.name ?? "None",
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
                            SizedBox(
                              height: 20,
                            ),
                            provider.isEdit
                                ? CustomEditingFields(
                                    title: "Reference",
                                    controller: provider.referredController,
                                    hintText: "Reference",
                                    isEditable: provider.isEdit)
                                : Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Reference",
                                        style: TextStyle(
                                          color: Colors.grey[600],
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      Text(
                                        provider.referredController.text
                                                .trim()
                                                .isEmpty
                                            ? "None"
                                            : provider.referredController.text,
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
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(15),
                child: SingleChildScrollView(
                  child: Column(
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
                          provider.data['type'] == 'opportunity'
                              ? "Tracking Information"
                              : "Analysis Information",
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
                            if (provider.data['type'] == 'opportunity' &&
                                clientprovider.salesTeams.isNotEmpty) ...[
                              if (provider.isEdit) ...[
                                Text(
                                  "Sales Team",
                                  style: TextStyle(
                                      color: Colors.black54,
                                      fontSize: 16,
                                      fontWeight: FontWeight.normal),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: SingleSelectSearchableDropdown<
                                              SalesTeam>(
                                          isEditable: provider.isEdit,
                                          items: clientprovider.salesTeams,
                                          displayText: (item) => item.name,
                                          initialValue:
                                              provider.selectedSalesTeamId !=
                                                      null
                                                  ? clientprovider.salesTeams
                                                      .firstWhere(
                                                      (item) =>
                                                          item.id ==
                                                          provider
                                                              .selectedSalesTeamId,
                                                    )
                                                  : null,
                                          onSelectionChanged: (selected) {
                                            if (selected != null) {
                                              setState(() {
                                                provider.selectedSalesTeamId =
                                                    selected.id;
                                              });
                                            } else {
                                              setState(() {
                                                provider.selectedSalesTeamId =
                                                    null;
                                              });
                                            }
                                            provider.markFormEdited();
                                          },
                                          hintText: "Sales Team"),
                                    ),
                                  ],
                                ),
                              ] else ...[
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Sales Team",
                                      style: TextStyle(
                                        color: Colors.grey[600],
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    Text(
                                      provider.selectedSalesTeamId == null
                                          ? "None"
                                          : clientprovider.salesTeams
                                              .firstWhere(
                                                (item) =>
                                                    item.id ==
                                                    provider
                                                        .selectedSalesTeamId,
                                                orElse: () => SalesTeam(
                                                    id: 0, name: "None"),
                                              )
                                              .name,
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
                            if (provider.isEdit) ...[
                              CustomEditingFields(
                                title: provider.data['type'] == 'opportunity'
                                    ? "Days Open"
                                    : "Assignment Date",
                                controller: provider.dayOpenController,
                                hintText: "Enter value",
                                inputType: TextInputType.number,
                                isEditable: true,
                                onTap: () {
                                  final val = provider.dayOpenController.text;
                                  if (val == '0.0' || val == '0') {
                                    provider.dayOpenController.clear();
                                  }
                                },
                              ),
                              const SizedBox(height: 20),
                              CustomEditingFields(
                                title: provider.data['type'] == 'opportunity'
                                    ? "Days Close"
                                    : "Closing Date",
                                controller: provider.dayCloseController,
                                hintText: "Enter value",
                                inputType: TextInputType.number,
                                isEditable: true,
                                onTap: () {
                                  final val = provider.dayCloseController.text;
                                  if (val == '0.0' || val == '0') {
                                    provider.dayCloseController.clear();
                                  }
                                },
                              ),
                            ] else ...[
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    provider.data['type'] == 'opportunity'
                                        ? "Days Open"
                                        : "Assignment Date",
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Text(
                                    provider.dayOpenController.text
                                            .trim()
                                            .isEmpty
                                        ? "None"
                                        : provider.dayOpenController.text,
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.normal,
                                      fontSize: 14,
                                    ),
                                    textAlign: TextAlign.end,
                                  )
                                ],
                              ),
                              const SizedBox(height: 10),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    provider.data['type'] == 'opportunity'
                                        ? "Days Close"
                                        : "Closing Date",
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Text(
                                    provider.dayCloseController.text
                                            .trim()
                                            .isEmpty
                                        ? "None"
                                        : provider.dayCloseController.text,
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
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          )),
        )),
        ],
      );
    });
  }

  /// Builds a pill-style tab button used in the custom horizontal tab bar.
  ///
  /// This provides a lightweight alternative to Flutter's default [TabBar]
  /// with custom styling and manual tap handling.
  ///
  /// Params:
  /// - [context]: Build context
  /// - [label]: Text label for the tab
  /// - [isSelected]: Whether this tab is currently active
  /// - [onTap]: Callback when the tab is tapped
  Widget _buildPillTab({
    required BuildContext context,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
    required double width,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected
              ? Colors.black
              : (isDark ? Colors.grey[800] : Colors.white),
          border: Border.all(
            color: isSelected
                ? Colors.black
                : (isDark ? Colors.grey[600]! : Colors.grey[300]!),
            width: 1,
          ),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Center(
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: isSelected
                    ? Colors.white
                    : (isDark ? Colors.grey[400] : Colors.grey[700]),
                fontSize: 14,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
