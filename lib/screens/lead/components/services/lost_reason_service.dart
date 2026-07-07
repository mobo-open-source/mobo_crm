import '../bottomsheet_lost.dart';

/// Signature definition for an abstract Odoo RPC caller.
///
/// Accepts:
/// - A parameter map containing:
///   - 'model'
///   - 'method'
///   - 'args'
///   - 'kwargs'
///
/// Returns:
/// - Future<dynamic> representing the RPC response.
///
/// This abstraction allows:
/// - Easier unit testing (mocking RPC calls)
/// - Decoupling business logic from specific Odoo client implementations
typedef OdooCaller = Future<dynamic> Function(Map<String, dynamic> params);

/// Fetches all available CRM lost reasons from Odoo.
///
/// Calls:
/// - `crm.lost.reason.search_read`
///
/// Returns:
/// - List of [Lostdetails] objects containing:
///   - id
///   - name
///
/// Parameters:
/// - [caller]: Abstracted Odoo RPC executor.
///
/// Throws:
/// - Any exception propagated from the RPC layer.
Future<List<Lostdetails>> unitFetchLostReasons(OdooCaller caller) async {
  final response = await caller({
    'model': 'crm.lost.reason',
    'method': 'search_read',
    'args': [],
    'kwargs': {
      'fields': ['id', 'name']
    },
  });

  return List<Map<String, dynamic>>.from(response)
      .map((e) => Lostdetails(e['name'], e['id']))
      .toList();
}

/// Creates a new CRM lost reason in Odoo.
///
/// Steps:
/// 1. Calls `crm.lost.reason.create`.
/// 2. Refetches lost reasons.
/// 3. Verifies the reason exists in the returned list.
///
/// Parameters:
/// - [caller]: Abstracted Odoo RPC executor.
/// - [reason]: Name of the new lost reason.
///
/// Returns:
/// - `true` if the reason is successfully created and verified.
/// - `false` otherwise.
///
/// Throws:
/// - Any exception from the RPC layer.
Future<bool> unitCreateLostReason(
  OdooCaller caller,
  String reason,
) async {
  await caller({
    'model': 'crm.lost.reason',
    'method': 'create',
    'args': [
      {'name': reason}
    ],
    'kwargs': {},
  });

  final list = await unitFetchLostReasons(caller);
  return list.any((e) => e.name == reason);
}

/// Marks a CRM lead as lost with a selected lost reason.
///
/// Steps:
/// 1. Creates a `crm.lead.lost` record.
/// 2. Calls `action_lost_reason_apply` to apply the lost status.
///
/// Parameters:
/// - [caller]: Abstracted Odoo RPC executor.
/// - [leadId]: ID of the CRM lead.
/// - [lostReasonId]: Selected lost reason ID.
///
/// Returns:
/// - `true` if the lead is successfully marked as lost.
/// - `false` if:
///   - [lostReasonId] is null
///   - RPC response is invalid
///
/// Throws:
/// - Any exception from the RPC layer.
Future<bool> unitMarkLeadAsLost(
  OdooCaller caller,
  int leadId,
  int? lostReasonId,
) async {
  if (lostReasonId == null) return false;

  final res = await caller({
    'model': 'crm.lead.lost',
    'method': 'create',
    'args': [
      {
        'lead_ids': [leadId],
        'lost_reason_id': lostReasonId,
        'lost_feedback': '',
      }
    ],
    'kwargs': {},
  });

  if (res is! int) return false;

  await caller({
    'model': 'crm.lead.lost',
    'method': 'action_lost_reason_apply',
    'args': [res],
    'kwargs': {},
  });

  return true;
}
