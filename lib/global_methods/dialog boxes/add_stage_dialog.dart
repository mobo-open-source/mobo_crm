import 'package:flutter/material.dart';
import 'package:mobo_crm/screens/opportunity/providers/opportunity_data_provider.dart';
import 'package:mobo_crm/utils/snackbar.dart';
import 'package:provider/provider.dart';

import '../../utils/globals.dart';

import '../../Rating/review_service.dart';
import '../../utils/globals.dart';

/// A modal dialog that allows the user to create a new CRM stage (pipeline stage)
/// in the Odoo `crm.stage` model.
///
/// Features:
/// - Simple input for stage name
/// - Loading state handling with disabled UI + spinner
/// - Success/error feedback via custom snackbars
/// - Automatic refresh of opportunity list after successful creation
/// - Informative hint explaining where the new stage will appear
///
/// The new stage is typically inserted **before** the "Add Stage" button
/// (implementation detail handled in backend/provider).
class AddStageDialog extends StatefulWidget {
  const AddStageDialog({super.key});

  @override
  State<AddStageDialog> createState() => _AddStageDialogState();
}

class _AddStageDialogState extends State<AddStageDialog> {
  final TextEditingController _stageNameController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _stageNameController.addListener(_onTextChanged);
  }

  void _onTextChanged() {
    setState(() {});
  }

  @override
  void dispose() {
    _stageNameController.removeListener(_onTextChanged);
    _stageNameController.dispose();
    super.dispose();
  }

  /// Validates input and creates a new CRM stage via the provider.
  ///
  /// Flow:
  /// 1. Checks for non-empty stage name (trimmed)
  /// 2. Sets loading state and disables UI
  /// 3. Calls `OpportunityDataProvider.createCrmStage`
  /// 4. On success:
  ///    - Shows success snackbar with stage name
  ///    - Refreshes the full opportunity list
  ///    - Closes dialog
  /// 5. On error: shows error snackbar
  /// 6. Always resets loading state (if widget still mounted)
  ///
  /// Any unhandled exceptions from the provider are caught and displayed.
  Future<void> _createStage() async {
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

      final success = await opportunityProvider.createCrmStage(
        context: context,
        stageName: _stageNameController.text.trim(),
      );

      if (success && mounted) {
        CustomSnackbar.showSuccess(context,
            'Stage "${_stageNameController.text.trim()}" created successfully!');
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
        CustomSnackbar.showError(context, 'Error creating stage: $e');
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
      titlePadding: EdgeInsets.zero,
      title: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
          ),
        ),
        child: Row(
          children: [
            Icon(
              Icons.add_circle_outline,
              color: AppStyle.primaryColor,
              size: 24,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'Add New Stage',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
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
            Text.rich(
              TextSpan(
                text: 'Stage Name ',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[700],
                ),
                children: const [
                  TextSpan(
                    text: '*',
                    style: TextStyle(
                      color: AppStyle.primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _stageNameController,
              enabled: !_isLoading,
              decoration: InputDecoration(
                hintText: 'Enter stage name (e.g., "Qualified", "Proposal")',
                hintStyle: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[500],
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Theme.of(context).primaryColor),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
              style: TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 16),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFFAFAFA),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.blue[200]!),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    color: Colors.blue[600],
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'The new stage will be added right before the "Add Stage" button.',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.blue[700],
                      ),
                    ),
                  ),
                ],
              ),
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
                      onPressed: (_isLoading || _stageNameController.text.trim().isEmpty) ? null : _createStage,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: (_isLoading || _stageNameController.text.trim().isEmpty)
                            ? Colors.grey[300]
                            : AppStyle.primaryColor,
                        foregroundColor: (_isLoading || _stageNameController.text.trim().isEmpty)
                            ? Colors.grey[500]
                            : Colors.white,
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
                              'Create Stage',
                              style: TextStyle(
                                fontSize: 14,
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
