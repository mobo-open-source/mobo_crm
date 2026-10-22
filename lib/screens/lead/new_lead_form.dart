import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:mobo_crm/global_methods/services/global_error_handler.dart';
import 'package:mobo_crm/global_methods/widgets/forms/mobo_submit_button.dart';
import 'package:mobo_crm/global_methods/widgets/shimmer/custom_shimmer.dart';
import 'package:mobo_crm/initilisation.dart';
import 'package:mobo_crm/screens/lead/providers/lead_form_provider.dart';
import 'package:mobo_crm/screens/lead/widgets/lead_form_view_widgets.dart';
import 'package:mobo_crm/screens/lead/widgets/messge_screen.dart';
import 'package:mobo_crm/utils/app_theme.dart';
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
  /// Set once the new lead has actually been created from this screen. The
  /// record is persisted from then on, so there is nothing left to discard.
  bool _leadCreated = false;

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

  /// Whether the record is still a lead. Odoo applies the lead actions to a
  /// record of type lead and the opportunity ones to any other, wherever it
  /// was opened from, so a converted lead gets the opportunity actions. Until
  /// the record's type has loaded, how the screen was opened stands in.
  bool _isLead(LeadFormProvider provider) {
    final type = provider.data['type'];
    return (type is String && type.isNotEmpty ? type : widget.type) == 'lead';
  }

  /// Saves an edited lead and, on success, refreshes the list it came from
  /// so it shows the new values too.
  Future<bool> _saveEdits(
      LeadFormProvider provider, OdooClientManager clientprovider) async {
    final success = await provider.saveChanges(
        clientprovider.client!, context, {'id': provider.data['id']});
    if (success && mounted && widget.type != 'lead') {
      Provider.of<OpportunityDataProvider>(context, listen: false)
          .refreshOpportunities(context);
    }
    return success;
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

    // A record that was just created is already persisted, so leaving the form
    // discards nothing and must not raise the data-loss warning.
    if (widget.isNew && !_leadCreated && _hasCreateChanges(provider)) {
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
      // Started before popping: once the form is gone its context can no
      // longer be used, which is why the old post-pop refresh never ran.
      // The lead list refreshes itself from the `true` pop result, with its
      // own filters applied, so only the pipeline list is refetched here.
      if (widget.type != 'lead') {
        Provider.of<OpportunityDataProvider>(context, listen: false)
            .refreshOpportunities(context);
      }
      Navigator.pop(context, true);
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

      // Only an existing record can fail to load; the create form has
      // nothing to retry.
      final loadFailed =
          !widget.isNew && provider.hasError && provider.leadError != null;

      return WillPopScope(
        onWillPop: () async {
          await _handleBack();
          return false;
        },
        child: Scaffold(
          backgroundColor: isDark ? const Color(0xFF181A20) : Colors.grey[50],
          appBar: AppBar(
            backgroundColor:
                isDark ? const Color(0xFF181A20) : Colors.grey[50],
            elevation: 0,
            surfaceTintColor: Colors.transparent,
            scrolledUnderElevation: 0,
            automaticallyImplyLeading: false,
            leading: IconButton(
              onPressed: () async => await _handleBack(),
              icon: Icon(Icons.arrow_back_ios_new,
                  color: isDark ? Colors.white : Colors.black, size: 20),
            ),
            centerTitle: false,
            title: Text(title,
                style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 22,
                    color: isDark ? Colors.white : Colors.black)),
            actions: [
              // Nothing to edit or act on while the record hasn't loaded: its
              // type and state are unknown, so the menu couldn't offer the
              // right actions (Convert for a lead, Won/Lost for an
              // opportunity).
              if (!widget.isNew && !provider.isloading && !loadFailed) ...[
                IconButton(
                  icon: Icon(HugeIcons.strokeRoundedMessageMultiple01,
                      color: isDark ? Colors.white : Colors.black, size: 22),
                  onPressed: () => _openChatter(provider, clientprovider),
                ),
                // Saving while editing is the bottom "Save Changes" button's
                // job; a second save action up here would just duplicate it.
                if (!provider.isEdit)
                  IconButton(
                    onPressed: () {
                      provider.isEdit = true;
                      provider.notifyListeners();
                    },
                    icon: Icon(
                      HugeIcons.strokeRoundedPencilEdit02,
                      color: isDark ? Colors.white : Colors.black,
                      size: 24,
                    ),
                  ),
                _buildPopupMenu(provider, clientprovider),
              ]
            ],
          ),
          body: provider.isloading
              ? const ShimmerLeadDetail()
              : loadFailed
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          margin: const EdgeInsets.only(bottom: 18),
          decoration: BoxDecoration(
            color: isDark ? Colors.grey[850] : Colors.white,
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
                  // A lost record is archived with probability 0, so it
                  // fails the open-stage test below and needs its own badge.
                  if (provider.isLost)
                    _buildStageBadge('Lost',
                        background: isDark
                            ? Colors.white.withValues(alpha: 0.15)
                            : StatusColors.statusRed.withValues(alpha: 0.12),
                        foreground:
                            isDark ? Colors.white : StatusColors.statusRed)
                  else if (provider.active == true &&
                      (double.tryParse(provider.probablityController.text) ??
                              0) >
                          0)
                    _buildStageBadge(provider.initialState ?? 'New',
                        background: Colors.green[50]!,
                        foreground: Colors.green[700]!),
                ],
              ),
              const SizedBox(height: 10),
              if (provider.contactNameController.text.isNotEmpty)
                Text(provider.contactNameController.text,
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: isDark ? Colors.white : Colors.black87)),
              const SizedBox(height: 10),
              if (provider.emailController.text.isNotEmpty)
                Row(children: [
                  Icon(Icons.email_outlined,
                      size: 16,
                      color: isDark ? Colors.grey[400] : Colors.grey[600]),
                  const SizedBox(width: 6),
                  Expanded(
                      child: Text(provider.emailController.text,
                          style: TextStyle(
                              fontSize: 14,
                              color: isDark ? Colors.white : Colors.black))),
                ]),
              const SizedBox(height: 8),
              if (provider.phoneController.text.isNotEmpty)
                Row(children: [
                  Icon(Icons.phone_outlined,
                      size: 16,
                      color: isDark ? Colors.grey[400] : Colors.grey[600]),
                  const SizedBox(width: 6),
                  Text(provider.phoneController.text,
                      style: TextStyle(
                          fontSize: 14,
                          color: isDark ? Colors.white : Colors.black)),
                ]),
              const SizedBox(height: 12),
              Divider(
                  color: isDark ? Colors.grey[700] : Colors.grey.shade200,
                  thickness: 1,
                  height: 1),
              const SizedBox(height: 8),
              if (_relationName(provider.data['userId']) case final name?)
                _buildInfoRow('Salesperson', name),
              const SizedBox(height: 8),
              if (_relationName(provider.data['teamId']) case final name?)
                _buildInfoRow('Sales Team', name),
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
              if (provider.descriptionController.text.trim().isNotEmpty) ...[
                const SizedBox(height: 8),
                Text('Description',
                    style: TextStyle(
                        color: isDark ? Colors.grey[400] : Colors.grey[600],
                        fontWeight: FontWeight.w500)),
                const SizedBox(height: 4),
                Text(
                    provider.parseHtmlString(
                        provider.descriptionController.text),
                    style: TextStyle(
                        fontSize: 14,
                        color: isDark ? Colors.white : Colors.black)),
              ],
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
        MainContentWidget(type: widget.type, leadData: widget.lead),
        const SizedBox(height: 10),
        SizedBox(
          height: 506,
          child: CustomTabBarLeadForm(
              type: widget.type, leadData: widget.lead),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildStageBadge(String label,
      {required Color background, required Color foreground}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
          color: background, borderRadius: BorderRadius.circular(12)),
      child: Text(label,
          style: TextStyle(
              color: foreground, fontSize: 13, fontWeight: FontWeight.w600)),
    );
  }

  /// The display name of a many2one held as Odoo's `[id, name]`, or null when
  /// it is unset or has no name to show.
  String? _relationName(dynamic relation) {
    if (relation is! List || relation.length < 2) return null;
    final name = relation[1];
    return name is String && name.isNotEmpty ? name : null;
  }

  Widget _buildInfoRow(String label, String value, {bool isBold = false}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label,
            style: TextStyle(
                color: isDark ? Colors.grey[400] : Colors.grey[600],
                fontWeight: isBold ? FontWeight.w800 : FontWeight.w500)),
        Text(value,
            style: TextStyle(
                color: isDark ? Colors.white : Colors.black,
                fontWeight: isBold ? FontWeight.w700 : FontWeight.normal,
                fontSize: 14),
            textAlign: TextAlign.end),
      ],
    );
  }

  Widget _buildTagsRow(LeadFormProvider provider, OdooClientManager clientprovider) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Tags',
            style: TextStyle(
                color: isDark ? Colors.grey[400] : Colors.grey[600],
                fontWeight: FontWeight.w500)),
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
        color: isDark ? Colors.grey[850] : Colors.white,
        boxShadow: [
          BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 8,
              offset: const Offset(0, -2)),
        ],
      ),
      child: MoboSubmitButton(
        label: widget.isNew ? "Create Lead" : "Save Changes",
        loadingLabel: widget.isNew ? "Creating..." : "Saving...",
        isLoading: provider.isloading,
        isReady: !(provider.isloading ||
            provider.nameController.text.trim().isEmpty ||
            (!widget.isNew && !provider.formEdited)),
        onPressed: (provider.isloading ||
                provider.nameController.text.trim().isEmpty ||
                (!widget.isNew && !provider.formEdited))
            ? null
            : () async {
                  if (widget.isNew) {
                    // Captured up front: both outlive this route, which is
                    // popped as soon as the record exists.
                    final navigator = Navigator.of(context);
                    final rootContext =
                        Navigator.of(context, rootNavigator: true).context;

                    final success = await provider.createOpportunity(
                        clientprovider.client!, context, widget.type);
                    // On failure the provider already reported why, so stay on
                    // the form with the entered data intact.
                    if (!success) return;

                    _leadCreated = true;
                    await ReviewService().trackSignificantEvent();
                    if (!mounted) return;
                    // Straight back to the list — no discard warning, because
                    // the lead is saved.
                    navigator.pop(true);
                    // The form is gone by now, so the rating dialog needs a
                    // context that outlives it.
                    if (rootContext.mounted) {
                      await ReviewService().checkAndShowRating(rootContext);
                    }
                  } else {
                    // saveChanges reports its own failure reason.
                    final success = await _saveEdits(provider, clientprovider);
                    if (!success) return;
                    await ReviewService().trackSignificantEvent();
                    if (context.mounted) {
                      await ReviewService().checkAndShowRating(context);
                    }
                  }
                },
      ),
    );
  }

  /// Opens the record's chatter, on the Send Message composer by default or
  /// on [action] (1 Log Note, 2 Activity).
  void _openChatter(
      LeadFormProvider provider, OdooClientManager clientprovider,
      {int action = 0}) {
    if (widget.lead['id'] == null) return;
    provider.fetchMessages(
        clientprovider.client!, 'crm.lead', widget.lead['id'],
        loading: true);
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => MessagesScreen(
                leadData: widget.lead,
                id: widget.lead['id'],
                model: 'crm.lead',
                initialAction: action)));
  }

  Widget _buildPopupMenu(
      LeadFormProvider provider, OdooClientManager clientprovider) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return PopupMenuButton<String>(
      icon: Icon(Icons.more_vert, color: isDark ? Colors.white : Colors.black),
      onSelected: (value) async {
        if (value == 'Send Message') {
          _openChatter(provider, clientprovider);
        } else if (value == 'Log Note') {
          _openChatter(provider, clientprovider, action: 1);
        } else if (value == 'Convert To Opportunity') {
          // Refused up front, before the duplicate lookup and its loading
          // dialog; showConversionPopup repeats the check for other callers.
          final blockedReason = provider.conversionBlockedReason;
          if (blockedReason != null) {
            CustomSnackbar.showWarning(context, blockedReason);
            return;
          }
          showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) =>
                  const Center(child: CircularProgressIndicator()));
          // The lead may have been lost or closed since this screen loaded, so
          // it is checked on the server as well before the dialog is offered.
          final serverReason = await provider
              .conversionBlockedReasonOnServer(widget.lead['id']);
          if (serverReason != null) {
            if (mounted) {
              Navigator.pop(context);
              CustomSnackbar.showWarning(context, serverReason);
            }
            return;
          }
          if (!mounted) return;
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
          // Blank sheet and Odoo's defaults first, then the customer: run
          // side by side, whichever finished last decided what the form held.
          // checkPartner() closes the loading dialog and opens the form.
          await quotation.prepareNewQuotation(
              client: clientprovider.client!, context: context);
          if (!mounted) return;
          quotation.checkPartner(
              forceNoPartner: widget.lead['user_id'] == false,
              clientprovider.client!,
              widget.lead,
              context,
              clientprovider.currentsession!);
        } else if (value == 'Won') {
          final success = await provider.markLeadAsWon(
              widget.lead['id'], context, widget.lead);
          if (success && mounted) {
            Provider.of<OpportunityDataProvider>(context, listen: false)
                .refreshOpportunities(context);
          }
        } else if (value == 'Lost') {
          final success = await provider.showBottomSheet(context, widget.lead);
          if (success && mounted && !_isLead(provider)) {
            Provider.of<OpportunityDataProvider>(context, listen: false)
                .refreshOpportunities(context);
          }
        } else if (value == 'Restore') {
          provider.restore(clientprovider.client!, widget.lead, context);
        }
      },
      itemBuilder: (context) {
        final List<PopupMenuEntry<String>> items = [];
        // The actions follow Odoo's form header, which keys off the record's
        // own type and won status, never off the stage it happens to be in:
        //  - a lead can be converted, or marked lost;
        //  - an opportunity, at any stage, takes a quotation and can be marked
        //    won or lost, so converting a lead hands it all three.
        final isLost = provider.isLost;
        final isWon = provider.isWon;
        final isOpen = provider.active == true;
        if (_isLead(provider)) {
          // A dead lead can't be converted, so it isn't offered; a closed or
          // overdue one is refused with a message when the item is tapped
          // (LeadFormProvider.conversionBlockedReason).
          if (isOpen) {
            items.add(const PopupMenuItem(
                value: 'Convert To Opportunity',
                child: Text('Convert To Opportunity')));
          }
        } else {
          // Hidden only on a lost record; a won one can still be quoted.
          if (!isLost) {
            items.add(const PopupMenuItem(
                value: 'New Quotation', child: Text('New Quotation')));
          }
          if (isOpen && !isWon) {
            items.add(const PopupMenuItem(value: 'Won', child: Text('Won')));
          }
        }
        if (isOpen && !isWon) {
          items.add(const PopupMenuItem(value: 'Lost', child: Text('Lost')));
        }
        // Odoo offers Restore only on a lost record: inactive with a
        // probability of 0. It was shown for other stages too, where it
        // archived a live record instead.
        if (isLost) {
          items.add(
              const PopupMenuItem(value: 'Restore', child: Text('Restore')));
        }
        // The chatter is also behind the message icon, but that alone
        // wasn't discoverable as "send a message" or "log a note".
        items.addAll(const [
          PopupMenuItem(value: 'Send Message', child: Text('Send Message')),
          PopupMenuItem(value: 'Log Note', child: Text('Log Note')),
        ]);
        return items;
      },
    );
  }
}
