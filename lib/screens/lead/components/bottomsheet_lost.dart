import 'package:flutter/material.dart';
import 'package:mobo_crm/initilisation.dart';
import 'package:mobo_crm/screens/lead/components/services/lost_reason_service.dart';
import 'package:mobo_crm/screens/lead/providers/lead_form_provider.dart';
import 'package:mobo_crm/screens/lead/providers/lead_data_provider.dart';
import 'package:mobo_crm/screens/opportunity/providers/opportunity_data_provider.dart';
import 'package:odoo_rpc/odoo_rpc.dart';
import 'package:provider/provider.dart';
import '../../../core/company/session/company_session_manager.dart';
import '../../../utils/globals.dart';
import '../../../utils/snackbar.dart';

/// Bottom sheet widget used to mark a Lead or Opportunity as Lost.
///
/// Features:
/// - Fetches lost reasons from Odoo (`crm.lost.reason`)
/// - Allows searching and filtering reasons
/// - Supports creating a new lost reason dynamically
/// - Captures optional feedback
/// - Marks lead/opportunity as lost using Odoo RPC
/// - Refreshes Lead or Opportunity lists after update
///
/// Parameters:
/// - [lead]: Lead/Opportunity record data (must contain 'id')
/// - [isLead]: Determines whether the record is a Lead or Opportunity
///
/// Dependencies:
/// - CompanySessionManager (RPC calls)
/// - LeadFormProvider
/// - LeadDataProvider
/// - OpportunityDataProvider
/// - OdooClientManager
///
/// UI Behavior:
/// - Animated dropdown for reason selection
/// - Displays loading state during submission
/// - Shows success/error snackbars
class CustomDropdownLost extends StatefulWidget {
  final dynamic lead;
  final bool isLead;

  const CustomDropdownLost(
      {super.key, required this.lead, required this.isLead});

  @override
  State<CustomDropdownLost> createState() => CustomDropdownLostState();
}

TextEditingController searchController = TextEditingController();
TextEditingController feedbackcontroller = TextEditingController();

/// State for [CustomDropdownLost]; manages loading and selecting a lost reason.
class CustomDropdownLostState extends State<CustomDropdownLost> {
  List<Lostdetails> lostReasonsList = [];
  List<Lostdetails> filteredList = [];
  bool isDropdownOpen = false;
  Lostdetails? selectedValue;
  int? defaultindex = 0;
  List<Map<String, dynamic>> lostReasons = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchLostReasons();
  }

  /// Selects a lost reason from the list.
  ///
  /// Updates:
  /// - [selectedValue]
  /// - [defaultindex]
  /// - Search field text
  /// - Closes dropdown
  ///
  /// Parameters:
  /// - [selectedName]: Name of the selected reason
  void selectLostReason(String selectedName) {
    FocusManager.instance.primaryFocus?.unfocus();
    setState(() {
      final index =
          lostReasonsList.indexWhere((reason) => reason.name == selectedName);
      if (index != -1) {
        defaultindex = index + 1;
        selectedValue = lostReasonsList[index];
        searchController.text = selectedValue!.name;
        toggleDropdown(false);
      }
    });
  }

  /// Fetches available lost reasons from Odoo.
  ///
  /// Calls:
  /// - `crm.lost.reason.search_read`
  ///
  /// Updates:
  /// - [lostReasonsList]
  /// - [filteredList]
  ///
  /// Note:
  /// - Errors are silently ignored (consider logging for debugging).
  Future<void> fetchLostReasons() async {
    try {
      final response = await CompanySessionManager.callKwWithCompany({
        'model': 'crm.lost.reason',
        'method': 'search_read',
        'args': [],
        'kwargs': {
          'fields': ['id', 'name'],
        },
      });

      lostReasons = List<Map<String, dynamic>>.from(response);
      setState(() {
        lostReasonsList = lostReasons
            .map((reason) => Lostdetails(reason['name'], reason['id']))
            .toList();
        filteredList = List.from(lostReasonsList);
      });
    } catch (_) {}
  }

  /// Creates a new lost reason in Odoo.
  ///
  /// After successful creation:
  /// - Re-fetches updated lost reasons list
  /// - Automatically selects the newly created reason
  ///
  /// Parameters:
  /// - [reason]: Name of the new lost reason
  ///
  /// Uses:
  /// - unitCreateLostReason()
  /// - unitFetchLostReasons()
  Future<void> createLostReason(String reason) async {
    try {
      final success = await unitCreateLostReason(
        CompanySessionManager.callKwWithCompany,
        reason,
      );

      if (success) {
        final list = await unitFetchLostReasons(
          CompanySessionManager.callKwWithCompany,
        );

        setState(() {
          lostReasonsList = list;
          filteredList = List.from(list);
        });

        selectLostReason(reason);
      }
    } catch (_) {}
  }

  /// Filters lost reasons based on search query.
  ///
  /// Behavior:
  /// - Shows full list if query is empty
  /// - Filters using case-insensitive match
  ///
  /// Parameters:
  /// - [query]: Search input string
  void filterSearchResults(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredList = List.from(lostReasonsList);
      } else {
        filteredList = lostReasonsList
            .where(
                (item) => item.name.toLowerCase().endsWith(query.toLowerCase()))
            .toList();
      }
    });
  }

  void toggleDropdown(bool open) {
    FocusManager.instance.primaryFocus?.unfocus();
    setState(() {
      isDropdownOpen = open;
    });
  }

  void toggle() {
    FocusManager.instance.primaryFocus?.unfocus();
    setState(() {
      isDropdownOpen = !isDropdownOpen;
    });
  }

  /// Marks the selected Lead/Opportunity as Lost in Odoo.
  ///
  /// Process:
  /// 1. Creates record in `crm.lead.lost`
  /// 2. Calls `action_lost_reason_apply`
  /// 3. Verifies status update
  /// 4. Shows success/error message
  /// 5. Refreshes providers
  ///
  /// Parameters:
  /// - [client]: Active Odoo client
  /// - [leadId]: ID of the lead/opportunity
  ///
  /// Returns:
  /// - `true` if successfully marked as lost
  /// - `false` if operation fails
  ///
  /// Throws:
  /// - Exception if no reason selected
  /// - Exception if status update fails
  Future<bool> markLeadAsLost(OdooClient client, int leadId) async {
    try {
      if (defaultindex == null) {
        throw Exception("No lost reason selected");
      }

      final responseWrite = await CompanySessionManager.callKwWithCompany({
        'model': 'crm.lead.lost',
        'method': 'create',
        'args': [
          {
            'lead_ids': [leadId],
            'lost_reason_id': defaultindex!,
            'lost_feedback': feedbackcontroller.text
          }
        ],
        'kwargs': {'context': {}},
      });

      if (responseWrite == null || responseWrite is! int) {
        throw Exception(
            "Invalid response from crm.lead.lost create: $responseWrite");
      }

      await CompanySessionManager.callKwWithCompany({
        'model': 'crm.lead.lost',
        'method': 'action_lost_reason_apply',
        'args': [responseWrite],
        'kwargs': {},
      });

      bool isLost = false;
      if (context.mounted) {
        final leadProvider =
            Provider.of<LeadFormProvider>(context, listen: false);
        await leadProvider.fetchStatus(client, {'id': leadId});
        isLost = leadProvider.active == false &&
            (leadProvider.probablity == 0.0 || leadProvider.probablity == null);
      } else {
        throw Exception("Context unmounted before status check");
      }

      if (!isLost) {
        throw Exception("Lead status not updated to lost");
      }

      if (context.mounted) {
        CustomSnackbar.showSuccess(context, 'Marked as lost successfully');

        Navigator.pop(context);
        return true;
      } else {
        throw Exception("Context unmounted before UI update");
      }
    } catch (e) {
      if (context.mounted) {
        CustomSnackbar.showError(
            context, 'Failed to mark as lost: ${e.toString()}');
      }
      return false;
    } finally {
      searchController.clear();
      feedbackcontroller.clear();
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[900] : Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                margin: const EdgeInsets.only(top: 12, bottom: 8),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.red.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.flag_rounded,
                    color: Colors.red[700],
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Mark as Lost",
                        style: TextStyle(
                          color: isDark ? Colors.white : Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "Provide reason for closing this opportunity",
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(
                    Icons.close_rounded,
                    color: Colors.grey[600],
                  ),
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.grey[200],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                    Text(
                      "Lost Reason",
                      style: TextStyle(
                        color: isDark ? Colors.white : Colors.black87,
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 12),
                    if (lostReasonsList.isEmpty)
                      const Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 16),
                          child: CircularProgressIndicator(),
                        ),
                      )
                    else
                      ConstrainedBox(
                        constraints: const BoxConstraints(maxHeight: 260),
                        child: SingleChildScrollView(
                          child: Column(
                            children: lostReasonsList.map((reason) {
                              final isSelected = selectedValue?.id == reason.id;
                              return GestureDetector(
                                onTap: () => setState(() {
                                  selectedValue = reason;
                                  defaultindex = reason.id;
                                }),
                                child: Container(
                                  margin: const EdgeInsets.only(bottom: 10),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: isDark
                                        ? Colors.grey[800]
                                        : Colors.white,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: Colors.grey[200]!,
                                      width: 1.5,
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      Radio<int>(
                                        value: reason.id,
                                        groupValue: selectedValue?.id,
                                        onChanged: (val) => setState(() {
                                          selectedValue = reason;
                                          defaultindex = reason.id;
                                        }),
                                        activeColor: AppStyle.primaryColor,
                                        materialTapTargetSize:
                                            MaterialTapTargetSize.shrinkWrap,
                                      ),
                                      const SizedBox(width: 4),
                                      Expanded(
                                        child: Text(
                                          reason.name,
                                          style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: isSelected
                                                ? FontWeight.w500
                                                : FontWeight.w400,
                                            color: isDark
                                                ? Colors.white
                                                : Colors.black87,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    const SizedBox(height: 20),
                    Text(
                      "Additional Feedback",
                      style: TextStyle(
                        color: isDark ? Colors.white : Colors.black87,
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      decoration: BoxDecoration(
                        color: isDark ? Colors.grey[800] : Colors.grey[50],
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: Colors.grey[300]!,
                          width: 1,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.05),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: TextField(
                        maxLines: 5,
                        controller: feedbackcontroller,
                        style: TextStyle(
                          color: isDark ? Colors.white : Colors.black87,
                          fontSize: 15,
                        ),
                        decoration: InputDecoration(
                          hintText: "Describe what went wrong (optional)...",
                          hintStyle: TextStyle(
                            color: Colors.grey[500],
                            fontSize: 15,
                          ),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.all(16),
                        ),
                      ),
                    ),
                    const SizedBox(height: 28),
                    Row(
                      children: [
                        Expanded(
                          child: SizedBox(
                            height: 48,
                            child: OutlinedButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                backgroundColor: isDark ? Colors.grey[800] : Colors.white,
                                side: BorderSide(
                                  color: AppStyle.primaryColor,
                                  width: 1.5,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: Text(
                                "Cancel",
                                style: TextStyle(
                                  color: AppStyle.primaryColor,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        if (widget.isLead)
                          Expanded(
                            child: Consumer4<OdooClientManager, LeadFormProvider,
                                    LeadDataProvider, OpportunityDataProvider>(
                                builder: (context, odooinitprovider,
                                    leadprovider, leaddataprovider,
                                    opportunitydata, child) {
                              return SizedBox(
                                height: 48,
                                child: ElevatedButton(
                                  onPressed: _isLoading
                                      ? null
                                      : () async {
                                          setState(() {
                                            _isLoading = true;
                                          });
                                          final success = await markLeadAsLost(
                                            odooinitprovider.client!,
                                            widget.lead['id'],
                                          );
                                          if (success && context.mounted) {
                                            if (widget.isLead) {
                                              await leadprovider.fetchStatus(
                                                  odooinitprovider.client!,
                                                  widget.lead);
                                              leaddataprovider.getLeads(
                                                useRawClient: true,
                                                clientraw:
                                                    odooinitprovider.client,
                                                loading: true,
                                              );
                                            } else {
                                              await opportunitydata
                                                  .getOpportunities(
                                                context: context,
                                                isLead: false,
                                                isOpportunity: true,
                                                isPop: false,
                                                loading: true,
                                              );
                                            }
                                          }
                                        },
                                  style: ElevatedButton.styleFrom(
                                    elevation: 0,
                                    padding: const EdgeInsets.symmetric(vertical: 12),
                                    backgroundColor: AppStyle.primaryColor,
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  child: _isLoading
                                      ? const SizedBox(
                                          width: 22,
                                          height: 22,
                                          child: CircularProgressIndicator(
                                            color: Colors.white,
                                            strokeWidth: 2,
                                          ),
                                        )
                                      : const Text(
                                          "Mark as Lost",
                                          style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                ),
                              );
                            }),
                          ),
                        if (!widget.isLead)
                          Expanded(
                            child: Consumer2<OdooClientManager,
                                    OpportunityDataProvider>(
                                builder: (context, odooinitprovider,
                                    opportunitydataprovider, child) {
                              return SizedBox(
                                height: 48,
                                child: ElevatedButton(
                                  onPressed: _isLoading
                                      ? null
                                      : () async {
                                          setState(() {
                                            _isLoading = true;
                                          });
                                          final success = await markLeadAsLost(
                                            odooinitprovider.client!,
                                            widget.lead['id'],
                                          );
                                          if (success && context.mounted) {
                                            await opportunitydataprovider
                                                .getOpportunities(
                                              rawclient:
                                                  odooinitprovider.client,
                                              isLead: false,
                                              isOpportunity: true,
                                              isPop: false,
                                              loading: true,
                                            );
                                          }
                                        },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppStyle.primaryColor,
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    elevation: 0,
                                    padding: const EdgeInsets.symmetric(vertical: 12),
                                  ),
                                  child: _isLoading
                                      ? const SizedBox(
                                          width: 22,
                                          height: 22,
                                          child: CircularProgressIndicator(
                                            color: Colors.white,
                                            strokeWidth: 2,
                                          ),
                                        )
                                      : const Text(
                                          "Mark as Lost",
                                          style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                ),
                              );
                            }),
                          ),
                      ],
                    ),
                    const SizedBox(height: 28),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Model representing a Lost Reason.
///
/// Properties:
/// - [name]: Lost reason name
/// - [id]: Odoo record ID
///
/// Used for:
/// - Dropdown display
/// - Selection handling
class Lostdetails {
  final String name;
  final int id;

  Lostdetails(this.name, this.id);

  @override
  bool operator ==(Object other) =>
      other is Lostdetails && other.id == id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => name;
}
