import 'package:flutter/material.dart';
import 'package:mobo_crm/global_methods/widgets/buttons/custom_button.dart';
import 'package:mobo_crm/initilisation.dart';
import 'package:mobo_crm/screens/lead/providers/lead_form_provider.dart';
import 'package:mobo_crm/screens/quotation/provider/quotation_form_provider.dart';
import 'package:provider/provider.dart';

/// Action buttons section for an Opportunity form.
///
/// Displays:
/// - New Quotation button
/// - Won button (if not already won)
/// - Lost button
/// - Enrich button (placeholder)
/// - Restore button (if inactive)
/// - Probability indicator (slider or progress bar)
///
/// Behavior:
/// - Uses LeadFormProvider for opportunity state
/// - Uses QuotationFormProvider to create quotations
/// - Uses OdooClientManager for client/session access
/// - Dynamically updates UI based on:
///   - active status
///   - stageId
///   - probability
///   - edit mode
///
/// Parameters:
/// - [lead]: Current opportunity record data (must contain 'id')
///
/// State Handling:
/// - Shows loading indicator when quotation is being created
/// - Allows marking opportunity as Won or Lost
/// - Allows restoring inactive opportunity
class OpportunityButtonActions extends StatelessWidget {
  final Map<dynamic, dynamic> lead;

  const OpportunityButtonActions({super.key, required this.lead});

  @override
  Widget build(BuildContext context) {
    return Consumer3<LeadFormProvider, QuotationFormProvider,
            OdooClientManager>(
        builder: (context, provider, quotationprovider, odooProvider, child) {
      return Column(
        children: [
          if (provider.active == true) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                quotationprovider.isLoading
                    ? Center(
                        child: CircularProgressIndicator(
                        color: Theme.of(context).primaryColor,
                      ))
                    : Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(context).primaryColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            minimumSize: Size(double.infinity, 48),
                          ),
                          onPressed: () {
                            final client = Provider.of<OdooClientManager>(
                                    context,
                                    listen: false)
                                .client;
                            final session = Provider.of<OdooClientManager>(
                                    context,
                                    listen: false)
                                .currentsession;
                            if (lead['user_id'] == false) {
                              quotationprovider.checkPartner(
                                  forceNoPartner: true,
                                  client!,
                                  lead,
                                  context,
                                  session!);
                            } else {
                              quotationprovider.checkPartner(
                                  forceNoPartner: false,
                                  client!,
                                  lead,
                                  context,
                                  session!);
                            }
                          },
                          child: Text(
                            "New Quotation",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
              ],
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                if (provider.stageId != 4 && provider.active == true) ...[
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        provider.markLeadAsWon(lead['id'], context, lead);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            Theme.of(context).primaryColor.withValues(alpha: 0.1),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        minimumSize: Size(double.infinity, 48),
                      ),
                      child: Text(
                        "Won",
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                ],
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      provider.showBottomSheet(context, lead);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          Theme.of(context).primaryColor.withValues(alpha: 0.1),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      minimumSize: Size(double.infinity, 48),
                    ),
                    child: Text(
                      "Lost",
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          Theme.of(context).primaryColor.withValues(alpha: 0.1),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      minimumSize: Size(double.infinity, 48),
                    ),
                    child: Text(
                      "Enrich",
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
          SizedBox(height: 20),
          if (provider.active == false) ...[
            Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: CustomButton(
                        text: "Restore",
                        onPressed: () {
                          provider.restore(odooProvider.client!, lead, context);
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 40),
              ],
            )
          ],
          if (provider.probablity != null) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Probability:',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: getColorForProbability(provider.probablity!),
                  ),
                ),
                Text(
                  '${provider.probablity!.toString()}%',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: getColorForProbability(provider.probablity!),
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: provider.isEdit
                  ? Slider(
                      value: provider.probablity!,
                      min: 0.0,
                      max: 100.0,
                      divisions: 100,
                      activeColor: getColorForProbability(provider.probablity!),
                      inactiveColor: Colors.purple.shade200,
                      label: '${provider.probablity!.toStringAsFixed(0)}%',
                      onChanged: (newValue) {
                        provider.updateProbability(newValue);
                      },
                    )
                  : LinearProgressIndicator(
                      value: provider.probablity! / 100,
                      minHeight: 8,
                      backgroundColor: Colors.purple.shade200,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        getColorForProbability(provider.probablity!),
                      ),
                    ),
            ),
          ],
          if (provider.active == null || provider.probablity == null) ...[
            Center(
                child: CircularProgressIndicator(
              color: Theme.of(context).primaryColor,
            )),
          ],
        ],
      );
    });
  }

  /// Returns a color based on probability percentage.
  ///
  /// Mapping:
  /// - < 10%      → Red
  /// - 10%–49%    → Orange
  /// - 50%–80%    → Blue
  /// - 81%–99%    → Light Green
  /// - 100%       → Green
  /// - Fallback   → Grey
  ///
  /// Used for:
  /// - Probability text color
  /// - Slider active color
  /// - Linear progress indicator color
  Color getColorForProbability(double probability) {
    if (probability < 10) {
      return Colors.red;
    } else if (probability >= 10 && probability < 50) {
      return Colors.orange[600]!;
    } else if (probability >= 50 && probability <= 80) {
      return Colors.blue;
    } else if (probability > 80 && probability < 100) {
      return Colors.green[300]!;
    } else if (probability == 100) {
      return Colors.green;
    } else {
      return Colors.grey;
    }
  }
}

/// Action buttons section for a Lead form.
///
/// Displays:
/// - Convert to Opportunity button
/// - Lost button
/// - Enrich button (placeholder)
/// - Restore button (if inactive)
/// - Probability indicator (slider or progress bar)
///
/// Behavior:
/// - Uses LeadFormProvider for state management
/// - Converts Lead to Opportunity
/// - Allows marking Lead as Lost
/// - Allows restoring inactive Lead
/// - Displays probability with dynamic color coding
///
/// Parameters:
/// - [lead]: Current lead record data (must contain 'id')
///
/// UI Behavior:
/// - Shows action buttons only when active
/// - Shows restore button when inactive
/// - Displays loading indicator if state not initialized
class LeadFormButtonOptions extends StatelessWidget {
  final Map<dynamic, dynamic> lead;

  const LeadFormButtonOptions({super.key, required this.lead});

  @override
  Widget build(BuildContext context) {
    return Consumer<LeadFormProvider>(builder: (context, provider, child) {
      return Column(
        children: [
          if (provider.active == true) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(child: Consumer<LeadFormProvider>(
                    builder: (context, provider, child) {
                  return CustomButton(
                      text: "Convert To Oportunity",
                      onPressed: () {
                        provider.getDuplicatedLeads(lead['id'], context);
                      });
                })),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          Theme.of(context).primaryColor.withValues(alpha: 0.1),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      minimumSize: Size(double.infinity, 48),
                    ),
                    child: Text(
                      "Enrich",
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: Consumer<LeadFormProvider>(
                      builder: (context, provider, child) {
                    return ElevatedButton(
                      onPressed: () {
                        provider.showBottomSheet(context, lead);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            Theme.of(context).primaryColor.withValues(alpha: 0.1),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        minimumSize: Size(double.infinity, 48),
                      ),
                      child: Text(
                        "Lost",
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    );
                  }),
                ),
              ],
            ),
          ],
          SizedBox(height: 20),
          Consumer2<LeadFormProvider, OdooClientManager>(
            builder: (context, opportunityProvider, odooProvider, child) {
              if (opportunityProvider.active == false) {
                return Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: CustomButton(
                            text: "Restore",
                            onPressed: () {
                              opportunityProvider.restore(
                                  odooProvider.client!, lead, context);
                            },
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 40),
                  ],
                );
              } else {
                return SizedBox();
              }
            },
          ),
          if (provider.probablity != null && provider.active != null) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Probability:',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: getColorForProbability(provider.probablity!),
                  ),
                ),
                Text(
                  '${provider.probablity!.toString()}%',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: getColorForProbability(provider.probablity!),
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: provider.isEdit
                  ? Slider(
                      value: provider.probablity!,
                      min: 0.0,
                      max: 100.0,
                      divisions: 100,
                      activeColor: getColorForProbability(provider.probablity!),
                      inactiveColor: Colors.purple.shade200,
                      label: '${provider.probablity!.toStringAsFixed(0)}%',
                      onChanged: (newValue) {
                        provider.updateProbability(newValue);
                      },
                    )
                  : LinearProgressIndicator(
                      value: provider.probablity! / 100,
                      minHeight: 8,
                      backgroundColor: Colors.purple.shade200,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        getColorForProbability(provider.probablity!),
                      ),
                    ),
            )
          ],
          if (provider.active == null || provider.probablity == null) ...[
            Center(
                child: CircularProgressIndicator(
              color: Theme.of(context).primaryColor,
            )),
          ],
        ],
      );
    });
  }

  /// Returns a color based on probability percentage.
  ///
  /// Used for:
  /// - Probability text
  /// - Slider active color
  /// - Linear progress indicator
  ///
  /// See mapping logic inside method.
  Color getColorForProbability(double probability) {
    if (probability < 10) {
      return Colors.red;
    } else if (probability >= 10 && probability < 50) {
      return Colors.orange[600]!;
    } else if (probability >= 50 && probability <= 80) {
      return Colors.blue;
    } else if (probability > 80 && probability < 100) {
      return Colors.green[300]!;
    } else if (probability == 100) {
      return Colors.green;
    } else {
      return Colors.grey;
    }
  }
}
