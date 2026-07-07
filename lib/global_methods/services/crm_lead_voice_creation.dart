import 'package:odoo_rpc/odoo_rpc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/company/session/company_session_manager.dart';

/// Service class responsible for CRM-related operations in Odoo,
/// particularly creating records (leads/opportunities) via RPC calls.
///
/// Currently focused on voice-command-driven lead creation.
/// Uses `OdooClient` from `odoo_rpc` and persists/restores session via SharedPreferences.
///
/// Important: This class lazily initializes the `OdooClient` from stored session data.
/// It is **not** thread-safe — avoid concurrent calls without synchronization.
class CrmService {
  OdooClient? client;

  /// Creates a new CRM lead (`crm.lead` with `type: 'lead'`) in Odoo using data
  /// extracted from voice input (speech-to-text result).
  ///
  /// Parameters:
  ///   - [parameters]  Map containing voice-parsed fields:
  ///     - `name`              → Lead title (required, fallback: "Lead from Voice")
  ///     - `phone`             → Contact phone number
  ///     - `email`             → Contact email
  ///     - `company`           → Partner/company name
  ///     - `description`       → Internal notes
  ///     - `probability`       → Success probability (0–100)
  ///     - `expected_revenue`  → Expected monetary value
  ///
  /// Behavior:
  ///   1. Lazily restores Odoo session from SharedPreferences if `client` is null
  ///   2. Calls `crm.lead.create(...)` via `CompanySessionManager`
  ///   3. Shows success notification (currently empty implementation)
  ///   4. Returns `true` if creation succeeded (response is integer ID)
  ///
  /// Returns:
  ///   - `true`  → Lead created successfully
  ///   - `false` → Failed (invalid session, network error, missing data, etc.)
  Future<bool> createOpportunityFromVoice(
      Map<String, dynamic> parameters) async {
    try {
      if (client == null) {
        final prefs = await SharedPreferences.getInstance();
        String url = prefs.getString('url') ?? '';
        String db = prefs.getString('selectedDatabase') ?? '';
        String sessionId = prefs.getString('sessionId') ?? '';
        String serverVersion = prefs.getString('serverVersion') ?? '';
        String userLang = prefs.getString('userLang') ?? '';
        int userId = prefs.getInt('userId') ?? 0;
        int partnerId = prefs.getInt('partnerId') ?? 0;
        String userLogin = prefs.getString('userLogin') ?? '';
        String userName = prefs.getString('userName') ?? '';
        int companyId = prefs.getInt('companyId') ?? 0;
        final allowedIdStrings =
            prefs.getStringList('allowed_company_ids') ?? [];
        final allowedCompanies = allowedIdStrings
            .map((idStr) {
              final id = int.tryParse(idStr);
              return id != null && id > 0 ? Company(id: id, name: '') : null;
            })
            .whereType<Company>()
            .toList();

        if (url.isEmpty || db.isEmpty || sessionId.isEmpty) {
          return false;
        }

        final session = OdooSession(
          id: sessionId,
          userId: userId,
          partnerId: partnerId,
          userLogin: userLogin,
          userName: userName,
          userLang: userLang,
          userTz: '',
          isSystem: prefs.getBool('isSystem') ?? false,
          dbName: db,
          serverVersion: serverVersion,
          companyId: companyId,
          allowedCompanies: allowedCompanies,
        );

        client = OdooClient(url, sessionId: session);
      }

      final response = await CompanySessionManager.callKwWithCompany({
        'model': 'crm.lead',
        'method': 'create',
        'args': [
          {
            'name': parameters['name'] ?? 'Lead from Voice',
            'phone': parameters['phone'] ?? '',
            'email_from': parameters['email'] ?? '',
            'partner_name': parameters['company'] ?? '',
            'description':
                parameters['description'] ?? 'Created via voice command',
            'probability':
                double.tryParse(parameters['probability']?.toString() ?? '0') ??
                    0.0,
            'expected_revenue': double.tryParse(
                    parameters['expected_revenue']?.toString() ?? '0') ??
                0.0,
            'active': true,
            'type': 'lead',
          }
        ],
        'kwargs': {},
      });
      return response != null && response is int;
    } catch (e) {
      return false;
    }
  }
}
