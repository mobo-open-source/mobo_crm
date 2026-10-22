import 'package:flutter/material.dart';
import 'package:mobo_crm/global_methods/widgets/forms/field_label.dart';
import 'package:mobo_crm/screens/opportunity/providers/opportunity_data_provider.dart';
import 'package:mobo_crm/utils/snackbar.dart';
import 'package:provider/provider.dart';

import '../../Rating/review_service.dart';
import '../../utils/app_theme.dart';
import '../../utils/globals.dart';

/// A modal dialog that allows the user to edit/rename an existing CRM stage
/// (`crm.stage`) in the Odoo pipeline.
///
/// Features:
/// - Pre-filled text field with the current stage name
/// - Input validation (non-empty name)
/// - Loading state with disabled UI + progress indicator
/// - Success/error feedback via custom snackbars
/// - Automatic refresh of opportunity list after successful update
/// - Clean, primary-color themed UI (non-destructive action)
class EditStageDialog extends StatefulWidget {
  final int stageId;
  final String currentStageName;

  const EditStageDialog({
    super.key,
    required this.stageId,
    required this.currentStageName,
  });

  @override
  State<EditStageDialog> createState() => _EditStageDialogState();
}

class _EditStageDialogState extends State<EditStageDialog> {
  late TextEditingController _stageNameController;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _stageNameController = TextEditingController(text: widget.currentStageName);
  }

  @override
  void dispose() {
    _stageNameController.dispose();
    super.dispose();
  }

  /// Validates input and updates the CRM stage name via the provider.
  ///
  /// Flow:
  /// 1. Checks for non-empty stage name (after trimming whitespace)
  /// 2. Sets loading state (disables input/button, shows spinner)
  /// 3. Calls `OpportunityDataProvider.updateCrmStage`
  /// 4. On success:
  ///    - Shows success snackbar with new stage name
  ///    - Refreshes the full opportunity list (to update pipeline UI)
  ///    - Closes the dialog
  /// 5. On error: displays error snackbar
  /// 6. Always resets loading state (if widget still mounted)
  ///
  /// Catches and displays any exceptions thrown by the provider.
  Future<void> _updateStage() async {
    if (_stageNameController.text.trim().isEmpty) {
      CustomSnackbar.showError(context, 'Please enter a stage name');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final opportunityProvider =
          Provider.of<OpportunityDataProvider>(context, listen: false);

      final success = await opportunityProvider.updateCrmStage(
        context: context,
        stageId: widget.stageId,
        stageName: _stageNameController.text.trim(),
      );

      if (success && mounted) {
        CustomSnackbar.showSuccess(context,
            'Stage "${_stageNameController.text.trim()}" updated successfully!');
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
        CustomSnackbar.showError(context, 'Error updating stage: $e');
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return AlertDialog(
      backgroundColor: isDark ? const Color(0xFF1E1E1E) : Colors.white,
      elevation: 0,
      shadowColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      titlePadding: EdgeInsets.zero,
      title: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
          ),
        ),
        child: Row(
          children: [
            const SizedBox(width: 4),
            Expanded(
              child: Text(
                'Edit Stage',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.black,
                  fontSize: 18,
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.close, color: Colors.grey, size: 24),
              onPressed: () => Navigator.of(context).pop(),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
          ],
        ),
      ),
      content: SizedBox(
        width: MediaQuery.of(context).size.width * 0.8,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const FieldLabel('Stage Name', isRequired: true),
            const SizedBox(height: 10),
            TextField(
              controller: _stageNameController,
              enabled: !_isLoading,
              cursorColor: AppTheme.primaryColor,
              decoration: AppTheme.fieldDecoration(
                isDark,
                hintText: 'Enter stage name',
              ),
              style: AppTheme.fieldValueStyle(isDark),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 48,
                    child: OutlinedButton(
                      onPressed:
                          _isLoading ? null : () => Navigator.of(context).pop(),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppStyle.primaryColor,
                        side: const BorderSide(color: AppStyle.primaryColor, width: 1.5),
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
                      onPressed: _isLoading ? null : _updateStage,
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
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : Text(
                              'Update Stage',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
