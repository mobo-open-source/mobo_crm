import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/company/session/company_session_manager.dart';

/// Thrown by [AppInstallCheck.isModuleInstalled] when the probe fails
/// because the current user lacks access rights (e.g. a portal user),
/// as opposed to the module genuinely being absent from the server.
///
/// Distinguishing this from a plain `false` return lets callers show an
/// "Access Denied" message instead of a misleading "Module Missing" one.
class ModuleAccessDeniedException implements Exception {
  final Object cause;
  ModuleAccessDeniedException(this.cause);

  @override
  String toString() => 'ModuleAccessDeniedException: $cause';
}

bool _looksLikeAccessError(Object error) {
  final message = error.toString().toLowerCase();
  return message.contains('accesserror') ||
      message.contains('access denied') ||
      message.contains('access rights') ||
      message.contains('not allowed') ||
      message.contains('you are not allowed') ||
      message.contains('you do not have') ||
      message.contains('permission denied') ||
      message.contains('insufficient') ||
      message.contains('restricted') ||
      message.contains('odoo.exceptions.accesserror');
}

/// Odoo's answer when the model a module would add isn't registered.
bool _looksLikeMissingModel(Object error) {
  final message = error.toString().toLowerCase();
  return message.contains('keyerror') ||
      message.contains("doesn't exist") ||
      message.contains('does not exist') ||
      message.contains('unknown model');
}

/// Utility class used to verify whether required backend modules
/// are installed in the Odoo server.
///
/// Uses RPC calls via CompanySessionManager to check module availability.
/// Includes fallback model checks to verify general API accessibility.
class AppInstallCheck {
  /// Raw text of the last failure seen by [isModuleInstalled], kept only
  /// for on-screen diagnostics while we track down why the wrong dialog
  /// keeps appearing on some servers. Remove once root-caused.
  static String? lastModuleCheckDebug;

  /// Checks whether a specific Odoo module is installed.
  ///
  /// First attempts direct module lookup using `ir.module.module`.
  /// If it fails (e.g., permission issues or restricted access),
  /// falls back to checking a commonly available model (`account.move`)
  /// to verify backend connectivity.
  ///
  /// Returns:
  /// - true → Module installed OR backend reachable
  /// - false → only when the server confirms the module/model is absent
  ///
  /// Rethrows any other failure (expired session, network, HTML error page)
  /// because it says nothing about whether the module is installed.
  ///
  /// Throws [ModuleAccessDeniedException] instead of returning false when
  /// the fallback check fails with an Odoo AccessError — that means the
  /// model exists (module is installed) but this user isn't permitted to
  /// read it, which is a different problem than a missing module.
  Future<bool> isModuleInstalled(String moduleName) async {
    try {
      /// Primary check using module registry
      final count = await CompanySessionManager.callKwWithCompany({
        'model': 'ir.module.module',
        'method': 'search_count',
        'args': [
          [
            ['name', '=', moduleName],
            ['state', '=', 'installed']
          ]
        ],
        'kwargs': {}
      });
      return (count ?? 0) > 0;
    } catch (e) {
      debugPrint('[isModuleInstalled:$moduleName] ir.module.module check failed: $e');
      lastModuleCheckDebug = 'primary(ir.module.module): $e';
      try {
        final Map<String, String> moduleToModel = {
          'sale': 'sale.order',
          'sale_management': 'sale.order',
          'crm': 'crm.lead',
          'account': 'account.move',
        };

        final modelToCheck = moduleToModel[moduleName] ?? 'res.users';

        await CompanySessionManager.callKwWithCompany({
          'model': modelToCheck,
          'method': 'search_count',
          'args': [[]],
          'kwargs': {'limit': 1}
        });
        return true;
      } catch (fallbackError) {
        debugPrint('[isModuleInstalled:$moduleName] fallback model check failed: $fallbackError');
        lastModuleCheckDebug = 'fallback(model check): $fallbackError';
        if (_looksLikeAccessError(fallbackError)) {
          debugPrint('[isModuleInstalled:$moduleName] classified as access error');
          throw ModuleAccessDeniedException(fallbackError);
        }
        if (_looksLikeMissingModel(fallbackError)) {
          debugPrint('[isModuleInstalled:$moduleName] classified as genuinely missing module');
          return false;
        }
        // Session expiry, network drops and HTML error pages say nothing
        // about the module, so don't report it as missing.
        debugPrint('[isModuleInstalled:$moduleName] check failed, not treated as missing');
        rethrow;
      }
    }
  }

  /// Modules the app can't work without (technical name → display name).
  static const requiredModules = {'crm': 'CRM', 'sale': 'Sales'};

  /// Odoo's access group for both the CRM and the Sales app: without it
  /// the user can't open either one, even though both are installed.
  static const _salesUserGroup = 'sales_team.group_sale_salesman';

  /// Why the logged-in user can't use the app, or null when they can.
  ///
  /// Blocks when CRM or Sales isn't installed on the database, or when the
  /// user has no access to them.
  Future<RequiredModulesBlock?> requiredModulesBlock() async {
    final notInstalled = <String>[];
    for (final module in requiredModules.entries) {
      if (!await isModuleInstalled(module.key)) notInstalled.add(module.value);
    }
    if (notInstalled.isNotEmpty) {
      return RequiredModulesBlock(notInstalled, notInstalled: true);
    }
    if (!await _userHasSalesAccess()) {
      return RequiredModulesBlock(requiredModules.values.toList(),
          notInstalled: false);
    }
    return null;
  }

  Future<bool> _userHasSalesAccess() async {
    final prefs = await SharedPreferences.getInstance();
    final int userId = prefs.getInt('userId') ?? 0;
    final int majorVersion = prefs.getInt('version') ?? 0;
    // See AuthService.authenticateOdoo for why the args differ by version.
    final result = await CompanySessionManager.callKwWithCompany({
      'model': 'res.users',
      'method': 'has_group',
      'args': majorVersion >= 18
          ? [userId, _salesUserGroup]
          : [_salesUserGroup],
      'kwargs': {},
    });
    return result == true;
  }
}

/// A login that must be refused because CRM/Sales can't be used.
class RequiredModulesBlock {
  /// Display names of the affected modules.
  final List<String> modules;

  /// True when the modules aren't installed; false when they are but the
  /// user has no access to them.
  final bool notInstalled;

  const RequiredModulesBlock(this.modules, {required this.notInstalled});

  /// Used when a dialog is shown without a specific reason.
  static const generic =
      RequiredModulesBlock(['CRM', 'Sales'], notInstalled: true);

  /// Text for the "Module Missing" dialog.
  String get message {
    final names = modules.map((m) => '"$m"').toList();
    final list = names.length == 1
        ? names.first
        : '${names.sublist(0, names.length - 1).join(', ')} and ${names.last}';
    final plural = names.length > 1;
    if (notInstalled) {
      return 'The required $list ${plural ? 'modules are' : 'module is'} '
          'not installed on this database. Please contact your '
          'administrator to install ${plural ? 'them' : 'it'}.';
    }
    return "Your user doesn't have access to the $list "
        "${plural ? 'apps' : 'app'}. Please contact your administrator "
        'to grant you access.';
  }
}
