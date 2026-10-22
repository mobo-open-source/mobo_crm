import 'package:flutter/services.dart';

import 'package:mobo_crm/global_methods/services/crm_lead_voice_creation.dart';

/// Service that handles Siri Shortcuts / Intents integration on iOS.
///
/// Registers a method channel to receive calls from native iOS code
/// when the user invokes Siri shortcuts like "Create lead in Odoo"
/// or asks for lead suggestions.
///
/// Responsibilities:
///   - Initializes the channel handler
///   - Routes incoming method calls from native → Dart handlers
///   - Handles 'createLead' intent by forwarding voice-parsed data to CrmService
///   - Returns structured success/error responses to native layer
///   - Provides placeholder for 'getLeadSuggestions' (can be expanded later)
///
/// Platform-specific:
///   - Only active on iOS (channel is ignored on Android)
///   - Requires matching native iOS setup (Intents, Siri Shortcuts, App Intents)
class SiriIntentService {
  static const MethodChannel _channel =
      MethodChannel('com.cybrosys.mobo_crm.siri_intents');

  static late CrmService _crmService;

  /// Initializes the Siri intent handler with the CRM service instance.
  ///
  /// Must be called once early in the app lifecycle (e.g. after login,
  /// in main() or app wrapper init).
  ///
  /// [crmService] is used to create leads from voice/Siri input.
  static void initialize(CrmService crmService) {
    _crmService = crmService;
    _channel.setMethodCallHandler(_handleMethodCall);
  }

  /// Handles incoming method calls from the native iOS layer.
  ///
  /// Supported methods:
  ///   - 'createLead'        → create a new lead/opportunity from voice data
  ///   - 'getLeadSuggestions' → return mock or real suggestions (placeholder)
  ///
  /// Throws PlatformException for unknown methods or processing errors.
  static Future<dynamic> _handleMethodCall(MethodCall call) async {
    try {
      switch (call.method) {
        case 'createLead':
          return await _handleCreateLead(call.arguments);
        case 'getLeadSuggestions':
          return await _handleGetLeadSuggestions(call.arguments);
        default:
          throw PlatformException(
            code: 'UNIMPLEMENTED',
            message: 'Method ${call.method} not implemented',
          );
      }
    } catch (e) {
      throw PlatformException(
        code: 'ERROR',
        message: 'Failed to handle intent: $e',
      );
    }
  }

  /// Processes the 'createLead' Siri intent.
  ///
  /// Expects a map of voice-parsed parameters (name, phone, email, etc.).
  /// Forwards to CrmService and returns structured result to native.
  ///
  /// Returns:
  ///   {
  ///     'success': bool,
  ///     'message': String,
  ///     'leadName': String
  ///   }
  static Future<Map<String, dynamic>> _handleCreateLead(
      dynamic arguments) async {
    final params = Map<String, dynamic>.from(arguments);

    try {
      final success = await _crmService.createOpportunityFromVoice(params);

      return {
        'success': success,
        'message': success
            ? 'Lead "${params['name'] ?? 'Unknown'}" created successfully'
            : 'Failed to create lead',
        'leadName': params['name'] ?? 'Unknown Lead'
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'Error creating lead: $e',
        'leadName': params['name'] ?? 'Unknown Lead'
      };
    }
  }

  /// Placeholder handler for 'getLeadSuggestions' Siri intent.
  ///
  /// Currently returns static mock data.
  /// Can be extended to query recent leads, cached contacts, or Odoo.
  ///
  /// Returns list of simple contact suggestions.
  static Future<List<Map<String, dynamic>>> _handleGetLeadSuggestions(
      dynamic arguments) async {
    return [
      {'name': 'John Doe', 'email': 'john@example.com'},
      {'name': 'Jane Smith', 'email': 'jane@example.com'},
      {'name': 'Bob Johnson', 'email': 'bob@example.com'},
    ];
  }
}
