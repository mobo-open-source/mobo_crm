import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:mobo_crm/global_methods/services/global_error_handler.dart';
import 'package:mobo_crm/global_methods/widgets/shimmer/custom_shimmer.dart';
import 'package:mobo_crm/initilisation.dart';
import 'package:mobo_crm/screens/lead/providers/lead_form_provider.dart';
import 'package:mobo_crm/screens/lead/widgets/lead_form_view_widgets.dart';
import 'package:mobo_crm/screens/lead/widgets/messge_screen.dart';
import 'package:mobo_crm/utils/globals.dart';
import 'package:provider/provider.dart';
import '../../Rating/review_service.dart';
import '../../core/navigation/data_loss_warning_dialog.dart';
import '../../utils/snackbar.dart';
import '../opportunity/providers/opportunity_data_provider.dart';
import '../quotation/provider/quotation_form_provider.dart';

/// Screen for creating, viewing, and editing a Lead or Opportunity.
class NewLeadForm extends StatefulWidget {
  final Map<dynamic, dynamic> lead;
  final bool isNew;
  final String type;

  const NewLeadForm(
      {super.key,
      required this.lead,
      this.isNew = false,
      this.type = 'opportunity'});

  @override
  State<NewLeadForm> createState() => _NewLeadFormState();
}

class _NewLeadFormState extends State<NewLeadForm> {
  @override
  void initState() {
    super.initState();
    if (!widget.isNew) {
      Provider.of<LeadFormProvider>(context, listen: false).isloading = true;
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final provider = Provider.of<LeadFormProvider>(context, listen: false);
      if (widget.isNew || provider.isloading) {
        provider.init(widget.lead, context, widget.isNew);
      }
      final clientprovider =
          Provider.of<OdooClientManager>(context, listen: false);

      if (clientprovider.salesPersonItem.isEmpty) {
        clientprovider.getSalesTeamsAndSalesperson();
      }
      if (clientprovider.crmTagDetails.isEmpty) {
        clientprovider.getTags();
      }
    });
  }

  bool _hasCreateChanges(LeadFormProvider provider) {
    return provider.nameController.text.trim().isNotEmpty ||
        provider.phoneController.text.trim().isNotEmpty ||
        provider.mobileController.text.trim().isNotEmpty ||
        provider.emailController.text.trim().isNotEmpty ||
        provider.contactNameController.text.trim().isNotEmpty ||
        provider.compnayNameController.text.trim().isNotEmpty ||
        provider.selectedPartnerId != null ||
        provider.selectedSalespersonId != null;
  }

  Future<void> _handleBack() async {
    final provider = context.read<LeadFormProvider>();

    if (!widget.isNew && provider.isEdit) {
      if (provider.hasFormChanged()) {
        final result = await DataLossWarningDialog.show(
          context: context,
          title: 'Discard Changes?',
          message: 'You have unsaved changes. Do you want to discard them?',
          confirmText: 'Discard',
          cancelText: 'Keep Editing',
        );
        if ((result ?? false) && mounted) {
          provider.isEdit = false;
          provider.notifyListeners();
        }
        return;
      }
      provider.isEdit = false;
      provider.notifyListeners();
      return;
    }

    if (widget.isNew && _hasCreateChanges(provider)) {
      final result = await DataLossWarningDialog.show(
        context: context,
        title: 'Discard Changes?',
        message: 'You have unsaved changes. Do you want to discard them?',
        confirmText: 'Discard',
        cancelText: 'Keep Editing',
      );
      if (!(result ?? false)) return;
    }

    if (mounted) {
      Navigator.pop(context, true);
      Future.microtask(() async {
        try {
          if (!mounted) return;
          final opportunityProvider =
              Provider.of<OpportunityDataProvider>(context, listen: false);
          await opportunityProvider.getOpportunities(
            context: context,
            isLead: false,
            isOpportunity: true,
            isPop: false,
            loading: false,
            searchText: opportunityProvider.searchController.text,
          );
        } catch (_) {}
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Consumer2<LeadFormProvider, OdooClientManager>(
        builder: (context, provider, clientprovider, child) {
      String title;
      if (widget.type == "lead") {
        title = (!widget.isNew && provider.isEdit)
            ? "Update Lead"
            : (widget.isNew ? "Create Lead" : "Lead Details");
      } else {
        title = (!widget.isNew && provider.isEdit)
            ? "Update Pipeline"
            : (widget.isNew ? "Create Pipeline" : "Pipeline Details");
      }

      return WillPopScope(
        onWillPop: () async {
          await _handleBack();
          return false;
        },
        child: Scaffold(
          backgroundColor: Colors.grey[50],
          appBar: AppBar(
            backgroundColor: Colors.grey[50],
            elevation: 0,
            surfaceTintColor: Colors.transparent,
            scrolledUnderElevation: 0,
            automaticallyImplyLeading: false,
            leading: IconButton(
              onPressed: () async => await _handleBack(),
              icon: const Icon(Icons.arrow_back_ios_new,
                  color: Colors.black, size: 20),
            ),
            centerTitle: false,
            title: Text(title,
                style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 22,
                    color: Colors.black)),
            actions: [
              if (!widget.isNew && !provider.isloading) ...[
                IconButton(
                  icon: const Icon(HugeIcons.strokeRoundedMessageMultiple01,
                      color: Colors.black, size: 22),
                  onPressed: () {
                    if (widget.lead['id'] != null) {
                      provider.fetchMessages(
                          clientprovider.client!, 'crm.lead', widget.lead['id'],
                          loading: true);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MessagesScreen(
                                  leadData: widget.lead,
                                  id: widget.lead['id'],
                                  model: 'crm.lead')));
                    }
                  },
                ),
                IconButton(
                  onPressed: () {
                    if (provider.isEdit) {
                      provider.saveChanges(clientprovider.client!, context,
                          {'id': provider.data['id']});
                    } else {
                      provider.isEdit = true;
                      provider.notifyListeners();
                    }
                  },
                  icon: Icon(
                    provider.isEdit
                        ? HugeIcons.strokeRoundedTick01
                        : HugeIcons.strokeRoundedPencilEdit02,
                    color: Colors.black,
                    size: 24,
                  ),
                ),
                _buildPopupMenu(provider, clientprovider),
              ]
            ],
          ),
          body: provider.isloading
              ? const ShimmerLeadDetail()
              : provider.hasError && provider.leadError != null
                  ? ErrorScreen(
                      onRetry: () => provider.fetchStatus(
                          clientprovider.client!, widget.lead,
                          loading: true),
                      error: provider.leadError!,
                      goBack: true)
                  : SingleChildScrollView(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          if (!provider.isEdit)
                            _buildViewModeContent(provider, clientprovider)
                          else
                            _buildEditModeContent(provider),
                        ],
                      ),
                    ),
          bottomNavigationBar: (!provider.isEdit || provider.isloading)
              ? null
              : _buildBottomNavbar(provider, clientprovider, isDark),
        ),
      );
    });
  }

  Widget _buildViewModeContent(
      LeadFormProvider provider, OdooClientManager clientprovider) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          margin: const EdgeInsets.only(bottom: 18),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withValues(alpha: 0.06),
                  blurRadius: 12,
                  offset: const Offset(0, 4)),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(provider.data['name']?.toString() ?? 'New',
                        style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppStyle.primaryColor)),
                  ),
                  if (provider.active != false &&
                      provider.probablityController.text != '0.0')
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                          color: Colors.green[50],
                          borderRadius: BorderRadius.circular(12)),
                      child: Text(provider.initialState ?? 'New',
                          style: TextStyle(
                              color: Colors.green[700],
                              fontSize: 13,
                              fontWeight: FontWeight.w600)),
                    ),
                ],
              ),
              const SizedBox(height: 10),
              if (provider.contactNameController.text.isNotEmpty)
                Text(provider.contactNameController.text,
                    style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87)),
              const SizedBox(height: 10),
              if (provider.emailController.text.isNotEmpty)
                Row(children: [
                  Icon(Icons.email_outlined, size: 16, color: Colors.grey[600]),
                  const SizedBox(width: 6),
                  Expanded(
                      child: Text(provider.emailController.text,
                          style: const TextStyle(fontSize: 14))),
                ]),
              const SizedBox(height: 8),
              if (provider.phoneController.text.isNotEmpty)
                Row(children: [
                  Icon(Icons.phone_outlined, size: 16, color: Colors.grey[600]),
                  const SizedBox(width: 6),
                  Text(provider.phoneController.text,
                      style: const TextStyle(fontSize: 14)),
                ]),
              const SizedBox(height: 12),
              Divider(
                  color: Colors.grey.shade200, thickness: 1, height: 1),
              const SizedBox(height: 8),
              if (provider.data['userId'] != null &&
                  provider.data['userId'] is List &&
                  provider.data['userId'].length > 1)
                _buildInfoRow('Salesperson', provider.data['userId'][1]),
              const SizedBox(height: 8),
              if (provider.data['teamId'] != null &&
                  provider.data['teamId'] is List &&
                  provider.data['teamId'].length > 1)
                _buildInfoRow('Sales Team', provider.data['teamId'][1]),
              const SizedBox(height: 4),
              if (provider.selectedTagIds.isNotEmpty &&
                  clientprovider.crmTagDetails.isNotEmpty)
                _buildTagsRow(provider, clientprovider),
              const SizedBox(height: 4),
              if (provider.expectedRevenue > 0)
                _buildInfoRow('Expected Revenue', provider.expectedRevenue.toStringAsFixed(2), isBold: true),
              const SizedBox(height: 8),
              if (provider.probablityController.text.isNotEmpty)
                _buildInfoRow('Probability', '${provider.probablityController.text}%', isBold: true),
            ],
          ),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.38,
          child: CustomTabBarLeadForm(
              type: widget.type, leadData: widget.lead),
        ),
      ],
    );
  }

  Widget _buildEditModeContent(LeadFormProvider provider) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.only(bottom: 24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withValues(alpha: 0.06),
                  blurRadius: 12,
                  offset: const Offset(0, 4)),
            ],
          ),
          child: MainContentWidget(
              type: widget.type, leadData: widget.lead),
        ),
        SizedBox(
          height: 506,
          child: CustomTabBarLeadForm(
              type: widget.type, leadData: widget.lead),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value, {bool isBold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label,
            style: TextStyle(
                color: Colors.grey[600],
                fontWeight: isBold ? FontWeight.w800 : FontWeight.w500)),
        Text(value,
            style: TextStyle(
                color: Colors.black,
                fontWeight: isBold ? FontWeight.w700 : FontWeight.normal,
                fontSize: 14),
            textAlign: TextAlign.end),
      ],
    );
  }

  Widget _buildTagsRow(LeadFormProvider provider, OdooClientManager clientprovider) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Tags',
            style: TextStyle(
                color: Colors.grey[600], fontWeight: FontWeight.w500)),
        const SizedBox(width: 12),
        Flexible(
          child: Align(
            alignment: Alignment.centerRight,
            child: Wrap(
              alignment: WrapAlignment.end,
              spacing: 6,
              runSpacing: 6,
              children: provider.selectedTagIds.map((tagId) {
                try {
                  final tag = clientprovider.crmTagDetails
                      .firstWhere((t) => t.id == tagId);
                  return Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFCE7EE),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                          color: const Color(0xFFC03355)
                              .withValues(alpha: 0.35),
                          width: 1),
                    ),
                    child: Text(tag.name,
                        style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFFC03355),
                            fontWeight: FontWeight.w500)),
                  );
                } catch (_) {
                  return const SizedBox.shrink();
                }
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBottomNavbar(LeadFormProvider provider,
      OdooClientManager clientprovider, bool isDark) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 8,
              offset: const Offset(0, -2)),
        ],
      ),
      child: SizedBox(
        width: double.infinity,
        height: 48,
        child: TextButton(
          onPressed: (provider.isloading ||
                  provider.nameController.text.trim().isEmpty ||
                  (!widget.isNew && !provider.formEdited))
              ? null
              : () async {
                  if (widget.isNew) {
                    provider.createOpportunity(
                        clientprovider.client!, context, 'lead');
                  } else {
                    provider.saveChanges(clientprovider.client!, context,
                        {'id': provider.data['id']});
                  }
                  await ReviewService().trackSignificantEvent();
                  if (mounted) {
                    await ReviewService().checkAndShowRating(context);
                  }
                },
          style: TextButton.styleFrom(
            backgroundColor: AppStyle.primaryColor,
            disabledBackgroundColor:
                isDark ? Colors.grey[700]! : Colors.grey[400]!,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            padding: const EdgeInsets.all(13),
          ),
          child: provider.isloading
              ? const SizedBox(
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(
                      strokeWidth: 2.5, color: Colors.white))
              : Text(widget.isNew ? "Create Lead" : "Save Changes",
                  style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16)),
        ),
      ),
    );
  }

  Widget _buildPopupMenu(
      LeadFormProvider provider, OdooClientManager clientprovider) {
    return PopupMenuButton<String>(
      icon: const Icon(Icons.more_vert, color: Colors.black),
      onSelected: (value) async {
        if (value == 'Convert To Opportunity') {
          showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) =>
                  const Center(child: CircularProgressIndicator()));
          bool success =
              await provider.getDuplicatedLeads(widget.lead['id'], context);
          if (mounted) Navigator.pop(context);
          if (success && mounted) {
            provider.showConversionPopup(context, widget.lead);
          }
        } else if (value == 'New Quotation') {
          showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) =>
                  const Center(child: CircularProgressIndicator()));
          final quotation =
              Provider.of<QuotationFormProvider>(context, listen: false);
          if (widget.lead['user_id'] == false) {
            quotation.checkPartner(
                forceNoPartner: true,
                clientprovider.client!,
                widget.lead,
                context,
                clientprovider.currentsession!);
          } else {
            quotation.setDefaultData(
                client: clientprovider.client!, context: context);
            quotation.checkPartner(
                forceNoPartner: false,
                clientprovider.client!,
                widget.lead,
                context,
                clientprovider.currentsession!);
          }
          if (mounted) Navigator.pop(context);
        } else if (value == 'Won') {
          final success = await provider.markLeadAsWon(
              widget.lead['id'], context, widget.lead);
          if (success && mounted) {
            final opportunityProvider =
                Provider.of<OpportunityDataProvider>(context, listen: false);
            opportunityProvider.getOpportunities(
                context: context,
                isLead: false,
                isOpportunity: true,
                isPop: false,
                loading: true,
                searchText: opportunityProvider.searchController.text);
          }
        } else if (value == 'Lost') {
          final success = await provider.showBottomSheet(context, widget.lead);
          if (success && mounted && widget.type == 'opportunity') {
            final opportunityProvider =
                Provider.of<OpportunityDataProvider>(context, listen: false);
            opportunityProvider.getOpportunities(
                context: context,
                isLead: false,
                isOpportunity: true,
                isPop: false,
                loading: true,
                searchText: opportunityProvider.searchController.text);
          }
        } else if (value == 'Restore') {
          provider.restore(clientprovider.client!, widget.lead, context);
        }
      },
      itemBuilder: (context) {
        final List<PopupMenuEntry<String>> items = [];
        if (widget.type == 'lead') {
          if (provider.active == true || provider.initialState == 'Lost') {
            items.add(const PopupMenuItem(
                value: 'Convert To Opportunity',
                child: Text('Convert To Opportunity')));
          }
          if (provider.active == true || (provider.probablity ?? 0.0) > 0.0) {
            items.add(const PopupMenuItem(value: 'Lost', child: Text('Lost')));
          }
          if (provider.active == false || (provider.probablity ?? 0.0) == 0.0) {
            items.add(
                const PopupMenuItem(value: 'Restore', child: Text('Restore')));
          }
        } else {
          final allowedStages = ['New', 'Qualified', 'Proposition'];
          if (provider.active == false &&
              provider.probablityController.text == '0.0') {
            items.add(
                const PopupMenuItem(value: 'Restore', child: Text('Restore')));
          } else if (provider.initialState == 'Won') {
            items.addAll([
              const PopupMenuItem(
                  value: 'New Quotation', child: Text('New Quotation')),
              const PopupMenuItem(value: 'Lost', child: Text('Lost')),
            ]);
          } else {
            if (allowedStages.contains(provider.initialState)) {
              items.add(const PopupMenuItem(
                  value: 'New Quotation', child: Text('New Quotation')));
            }
            if (allowedStages.contains(provider.initialState) &&
                provider.active == true) {
              items.add(const PopupMenuItem(value: 'Won', child: Text('Won')));
            }
            if (allowedStages.contains(provider.initialState) &&
                provider.active == true) {
              items.add(const PopupMenuItem(value: 'Lost', child: Text('Lost')));
            }
            if (!allowedStages.contains(provider.initialState) ||
                provider.active == false) {
              items.add(const PopupMenuItem(
                  value: 'Restore', child: Text('Restore')));
            }
          }
        }
        return items;
      },
    );
  }
}
