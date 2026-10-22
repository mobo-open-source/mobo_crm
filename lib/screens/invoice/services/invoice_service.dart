import '../../../core/company/session/company_session_manager.dart';

/// Service responsible for handling invoice state transitions.
///
/// Provides methods to:
/// - Post (validate) invoices
/// - Cancel invoices
/// - Reset invoices to draft
///
/// Uses [CompanySessionManager.callKwWithCompany] to execute
/// Odoo RPC calls under the active company session.
///
/// Handles compatibility across different Odoo versions
/// by falling back to alternative method names when needed.
class InvoiceService {
  /// Posts (validates) an invoice in Odoo.
  ///
  /// Calls:
  /// - `account.move.action_post`
  ///
  /// Parameters:
  /// - [id]: The invoice ID to be posted.
  ///
  /// Returns:
  /// - `true` if the operation completes without exception.
  ///
  /// Throws:
  /// - Any exception returned by the RPC call.
  Future<bool> postInvoice(int id) async {
    await CompanySessionManager.callKwWithCompany({
      'model': 'account.move',
      'method': 'action_post',
      'args': [
        [id]
      ],
      'kwargs': {},
    });
    return true;
  }

  /// Cancels an invoice.
  ///
  /// Allowed states:
  /// - 'draft'
  /// - 'posted'
  ///
  /// If the invoice is not in a valid state, an exception is thrown.
  ///
  /// Calls:
  /// - `account.move.action_cancel`
  /// - Falls back to `account.move.button_cancel` if the first call fails
  ///
  /// Parameters:
  /// - [invoiceId]: The invoice ID to cancel.
  /// - [currentState]: Current state of the invoice.
  ///
  /// Throws:
  /// - Exception if state is invalid.
  /// - RPC exceptions if both cancel methods fail.
  Future<void> actionCancel(int invoiceId, String currentState) async {
    if (!['draft', 'posted'].contains(currentState)) {
      throw Exception(
          "Cannot cancel invoice: Invoice must be in 'draft' or 'posted' state (current state: $currentState).");
    }

    try {
      await CompanySessionManager.callKwWithCompany({
        'model': 'account.move',
        'method': 'action_cancel',
        'args': [
          [invoiceId]
        ],
        'kwargs': {},
      });
    } catch (_) {
      await CompanySessionManager.callKwWithCompany({
        'model': 'account.move',
        'method': 'button_cancel',
        'args': [
          [invoiceId]
        ],
        'kwargs': {},
      });
    }
  }

  /// Resets an invoice to draft state.
  ///
  /// Allowed states:
  /// - 'cancel'
  /// - 'posted'
  ///
  /// If the invoice is in 'posted' state:
  /// - Executes [cancelInvoiceCallback] first to cancel it.
  /// - Verifies the updated state is 'cancel' before proceeding.
  ///
  /// Calls:
  /// - `account.move.button_draft`
  /// - Falls back to `account.move.action_draft` if needed.
  ///
  /// Parameters:
  /// - [invoiceId]: The invoice ID to reset.
  /// - [currentState]: Current state of the invoice.
  /// - [cancelInvoiceCallback]: Callback used to cancel the invoice
  ///   and return the updated state.
  ///
  /// Throws:
  /// - Exception if state validation fails.
  /// - Exception if cancellation does not succeed.
  /// - RPC exceptions if both draft methods fail.
  Future<void> actionDraft({
    required int invoiceId,
    required String currentState,
    required Future<String> Function() cancelInvoiceCallback,
  }) async {
    if (!['cancel', 'posted'].contains(currentState)) {
      throw Exception(
          "Cannot reset to draft: Invoice must be in 'cancel' or 'posted' state (current state: $currentState).");
    }

    if (currentState == 'posted') {
      final updatedState = await cancelInvoiceCallback();

      if (updatedState != 'cancel') {
        throw Exception(
            "Failed to cancel invoice before resetting to draft (current state: $updatedState).");
      }
    }

    try {
      await CompanySessionManager.callKwWithCompany({
        'model': 'account.move',
        'method': 'button_draft',
        'args': [
          [invoiceId]
        ],
        'kwargs': {},
      });
    } catch (_) {
      await CompanySessionManager.callKwWithCompany({
        'model': 'account.move',
        'method': 'action_draft',
        'args': [
          [invoiceId]
        ],
        'kwargs': {},
      });
    }
  }
}
