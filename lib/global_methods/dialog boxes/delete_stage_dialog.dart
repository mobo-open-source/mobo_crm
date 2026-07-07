import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:mobo_crm/screens/opportunity/providers/opportunity_data_provider.dart';
import 'package:mobo_crm/utils/globals.dart';
import 'package:mobo_crm/utils/snackbar.dart';
import 'package:provider/provider.dart';

import '../../Rating/review_service.dart';

/// A confirmation dialog that allows the user to permanently delete an existing
/// CRM stage (`crm.stage`) from the Odoo pipeline.
///
/// Features:
/// - Displays the stage name prominently with warning styling
/// - Shows irreversible action warning
/// - Loading state with disabled buttons + spinner
/// - Success/error feedback via custom snackbars
/// - Automatically refreshes the opportunity list after successful deletion
/// - Red-themed UI to emphasize destructive action
///
/// This dialog **does not** handle moving opportunities or reassigning them —
/// that logic (if any) should be implemented in `OpportunityDataProvider.deleteCrmStage`.
class DeleteStageDialog extends StatefulWidget {
  /// The Odoo ID of the stage to delete (`crm.stage` record ID)
  final int stageId;

  /// The display name of the stage (used in UI and success message)
  final String stageName;

  const DeleteStageDialog({
    super.key,
    required this.stageId,
    required this.stageName,
  });

  @override
  State<DeleteStageDialog> createState() => _DeleteStageDialogState();
}

class _DeleteStageDialogState extends State<DeleteStageDialog> {
  bool _isLoading = false;

  /// Deletes the CRM stage via the provider and handles UI feedback + refresh.
  ///
  /// Flow:
  /// 1. Sets loading state (disables buttons, shows spinner)
  /// 2. Calls `OpportunityDataProvider.deleteCrmStage`
  /// 3. On success:
  ///    - Shows success snackbar with stage name
  ///    - Refreshes opportunity list (to update pipeline UI)
  ///    - Closes dialog
  /// 4. On error: displays error snackbar
  /// 5. Always resets loading state (if widget still mounted)
  ///
  /// Any exceptions thrown by the provider are caught and shown to the user.
  Future<void> _deleteStage() async {

    setState(() {
      _isLoading = true;
    });

    try {
      final opportunityProvider =
          Provider.of<OpportunityDataProvider>(context, listen: false);

      final success = await opportunityProvider.deleteCrmStage(
        context: context,
        searchCountFn: opportunityProvider.searchCountFn,
        stageId: widget.stageId,
        stageName: widget.stageName,
      );

      if (success && mounted) {
        CustomSnackbar.showSuccess(
            context, 'Stage "${widget.stageName}" deleted successfully!');
        await ReviewService().trackSignificantEvent();
        final parentContext = Navigator.of(context).overlay!.context;

        Navigator.of(context).pop();

        Future.delayed(const Duration(seconds: 3), () {
          ReviewService().checkAndShowRating(parentContext);
        });
        await opportunityProvider.getOpportunities(
          context: context,
          loading: true,
        );

        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        CustomSnackbar.showError(context, 'Error deleting stage: $e');
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      title: Text(
        'Delete Stage',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.black,
          fontSize: 18,
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Are you sure you want to delete the stage:',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 12),

          Row(
            children: [
              Icon(
                HugeIcons.strokeRoundedLabelImportant,
                color: Colors.red[700],
                size: 20,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  widget.stageName,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.red[700],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.orange[50],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.orange[200]!),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.info_outline,
                  color: Colors.orange[600],
                  size: 20,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'This action cannot be undone. The stage will be permanently deleted from your CRM pipeline.',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.orange[700],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          child: Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 48,
                  child: OutlinedButton(
                    onPressed:
                        _isLoading ? null : () => Navigator.of(context).pop(),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.grey[600],
                      backgroundColor: Colors.white,
                      side: BorderSide(color: AppStyle.primaryColor, width: 1.5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: Text(
                      'Cancel',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                        color: AppStyle.primaryColor,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: SizedBox(
                  height: 48,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _deleteStage,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppStyle.primaryColor,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: _isLoading
                        ? SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : Text(
                            'Delete Stage',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
