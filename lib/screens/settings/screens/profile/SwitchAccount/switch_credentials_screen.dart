import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:mobo_crm/screens/settings/screens/profile/SwitchAccount/server_url_screen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../../bottom_nav_screen.dart';
import '../../../../../core/company/services/connectivity_service.dart';
import '../../../../../core/company/session/company_session_manager.dart';
import '../../../../../core/security/secure_storage_service.dart';
import '../../../../../global_methods/services/isar_caching_service.dart';
import '../../../../../initilisation.dart';
import '../../../../../models/LoginPage/session_model.dart';
import '../../../../../services/app_install_check.dart';
import '../../../../../services/storage_service.dart';
import '../../../../../utils/globals.dart';
import '../../../../customers/provider/customer_data_provider.dart';
import '../../../../discuss/providers/discuss_provider.dart';
import '../../../../lead/providers/lead_data_provider.dart';
import '../../../../login/totp_page.dart';
import '../../../../opportunity/providers/opportunity_data_provider.dart';

/// A screen that allows users to add a new Odoo account by providing server
/// credentials such as username, password, database, and server URL.
///
/// Handles login, session management, URL history saving, and module checks.
/// Supports two-factor authentication (TOTP) if enabled on the server.
class SwitchCredentialsScreen extends StatefulWidget {
  final String serverUrl;
  final String database;
  final String protocol;
  final String urlInput;
  final SessionModel session;

  const SwitchCredentialsScreen({
    super.key,
    required this.serverUrl,
    required this.database,
    required this.protocol,
    required this.urlInput,
    required this.session,
  });

  @override
  State<SwitchCredentialsScreen> createState() =>
      _SwitchCredentialsScreenState();
}

class _SwitchCredentialsScreenState extends State<SwitchCredentialsScreen> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  bool _isPasswordVisible = false;
  String? _errorMessage;
  String? _previousUrl;
  String? _previousDatabase;
  String? _previousSessionId;
  bool _hadPreviousSession = false;

  @override
  void initState() {
    super.initState();
    _loadPreviousSessionData();
  }

  Future<void> _loadPreviousSessionData() async {
    final prefs = await SharedPreferences.getInstance();

    if (widget.session != null &&
        widget.session.sessionId != null &&
        widget.session.sessionId!.isNotEmpty) {
      _hadPreviousSession = true;
      _previousUrl = prefs.getString('url');
      _previousDatabase = prefs.getString('selectedDatabase');
      _previousSessionId = widget.session.sessionId;
    }
  }

  /// Saves the URL history in shared preferences with protocol, database,
  /// and username information. Maintains a maximum of 10 entries.
  Future<void> _saveUrlHistoryWithProtocol(
    String protocol,
    String url,
    String database,
    String username,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> history = prefs.getStringList('urlHistory') ?? [];

    String finalProtocol = protocol;
    String finalUrl = url.trim();

    if (finalUrl.startsWith('https://')) {
      finalProtocol = 'https://';
      finalUrl = finalUrl.replaceFirst('https://', '');
    } else if (finalUrl.startsWith('http://')) {
      finalProtocol = 'http://';
      finalUrl = finalUrl.replaceFirst('http://', '');
    }

    final entry = jsonEncode({
      'protocol': finalProtocol,
      'url': finalUrl,
      'db': database,
      'username': username,
    });

    history.removeWhere((e) {
      final d = jsonDecode(e);
      return d['url'] == finalUrl && d['protocol'] == finalProtocol;
    });

    history.insert(0, entry);
    await prefs.setStringList('urlHistory', history.take(10).toList());
  }

  /// Handles the login process, saves account information, checks required
  /// modules, and navigates to appropriate screens.
  Future<void> _addAccount() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      String finalUrl = widget.serverUrl.trim();
      String finalProtocol = widget.protocol;

      if (finalUrl.startsWith('https://')) {
        finalProtocol = 'https://';
        finalUrl = finalUrl.replaceFirst('https://', '');
      } else if (finalUrl.startsWith('http://')) {
        finalProtocol = 'http://';
        finalUrl = finalUrl.replaceFirst('http://', '');
      }
      final url = '$finalProtocol$finalUrl';

      final success = await CompanySessionManager.loginAndSaveSession(
        serverUrl: url,
        database: widget.database,
        userLogin: _usernameController.text.trim(),
        password: _passwordController.text.trim(),
      );

      if (!success) throw Exception("Authentication failed.");

      final session = await CompanySessionManager.getCurrentSession();
      final storageService = StorageService();

      await storageService.saveAccount({
        'userName': session?.userName,
        'userLogin': session?.userLogin,
        'userId': session?.userId,
        'sessionId': session?.sessionId,
        'serverVersion': session?.serverVersion,
        'userLang': session?.userLang,
        'partnerId': session?.partnerId,
        'userTimezone': session?.userTimezone,
        'companyId': session?.companyId,
        'companyName': session?.companyName,
        'isSystem': session?.isSystem,
        'url': url,
        'selectedDatabase': widget.database,
        'database': widget.database,
        'image': '',
        'allowedCompanyIds': session?.allowedCompanyIds
          .map((e) => e.toString())
        .toList()
      });

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('lastUsername', _usernameController.text.trim());

      await _saveUrlHistoryWithProtocol(
        widget.protocol,
        finalUrl,
        widget.database,
        _usernameController.text.trim(),
      );

      if (context.mounted) {
        final checker = AppInstallCheck();
        final isInstalled = await checker.checkRequiredModules();

        if (!isInstalled) {
          await prefs.remove('lastUsername');
          await storageService.removeAccount(
            userLogin: session?.userLogin ?? '',
            userName: session?.userName ?? '',
            userId: session?.userId ?? 0,
            url: url,
            database: widget.database,
          );

          await SecureStorageService().deletePassword(
            url: url,
            database: widget.database,
            username: session?.userLogin ?? '',
          );

          if (_hadPreviousSession &&
              _previousUrl != null &&
              _previousDatabase != null) {
            await prefs.setString('url', _previousUrl!);
            await prefs.setString('selectedDatabase', _previousDatabase!);
            await prefs.setString('database', _previousDatabase!);
            await prefs.setString('sessionId', _previousSessionId!);
            await prefs.setString('userName', widget.session.userName!);
            await prefs.setString('userLogin', widget.session.userLogin!);
            await prefs.setInt('userId', widget.session.userId!);
            await prefs.setString(
                'serverVersion', widget.session.serverVersion!);
            await prefs.setString('userLang', widget.session.userLang!);
            await prefs.setInt('partnerId', widget.session.partnerId!);
            await prefs.setString('userTimezone', widget.session.userTimezone!);
            await prefs.setInt('companyId', widget.session.companyId!);
            await prefs.setString('company_name', widget.session.companyName!);
            await prefs.setBool('isSystem', widget.session.isSystem);
            await prefs.setInt('version', widget.session.version!);
            await prefs.setStringList(
              'allowed_company_ids',
              widget.session.allowedCompanyIds
                  .map((e) => e.toString())
                  .toList(),
            );

            await CompanySessionManager.clearSessionCache();
            await CompanySessionManager.forceRefreshFromPrefs();
            ConnectivityService.instance.setCurrentServerUrl(_previousUrl!);

            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ServerUrlScreen(
                    serverUrl: _previousUrl!,
                    database: _previousDatabase!,
                    session: widget.session
                ),
              ),
            );

            if (context.mounted) {
              showModuleMissingDialog(context);
            }
            return;
          }
        } else {

          if (context.mounted) {
            try {
              final opportunityProvider = Provider.of<OpportunityDataProvider>(context, listen: false);
              opportunityProvider.clearFilters(reload: false, context: context);
              opportunityProvider.clearAll();
            } catch (_) {}

            try {
              Provider.of<LeadDataProvider>(context, listen: false).clearAll();
            } catch (_) {}

            try {
              Provider.of<CustomerDataProvider>(context, listen: false).clearAll();
            } catch (_) {}

            try {
              Provider.of<DiscussProvider>(context, listen: false).clearAll();
            } catch (_) {}
          }

          try {
            await IsarService.clearAllData();
          } catch (_) {}

          final clientManager = Provider.of<OdooClientManager>(context, listen: false);

          await clientManager.initializeOdooClient(context);
          await clientManager.initializeOdooClientWithUrl(url);

          await prefs.setString('url', url);
          await prefs.setString('selectedDatabase', widget.database);
          await prefs.setString('database', widget.database);

          if (session != null) {
            await prefs.setString('sessionId', session.sessionId ?? '');
            await prefs.setInt('userId', session.userId ?? 0);
            await prefs.setString('userName', session.userName ?? '');
            await prefs.setString('userLogin', session.userLogin ?? '');
            await prefs.setString('serverVersion', session.serverVersion ?? '');
            await prefs.setString('userLang', session.userLang ?? '');
            await prefs.setInt('partnerId', session.partnerId ?? 0);
            await prefs.setString('userTimezone', session.userTimezone ?? '');
            await prefs.setInt('companyId', session.companyId ?? 0);
            await prefs.setString('companyName', session.companyName ?? '');
            await prefs.setBool('isSystem', session.isSystem ?? false);

            if (session.allowedCompanyIds != null) {
              await prefs.setStringList(
                'allowed_company_ids',
                session.allowedCompanyIds.map((e) => e.toString()).toList(),
              );
            }
          }

          await CompanySessionManager.forceRefreshFromPrefs();
          if (mounted) {

            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => const HomeScreen(loadInit: true),
              ),
              (route) => false,
            );
          }
        }
      }
    } catch (e) {
      final errorStr = e.toString().toLowerCase();
      if (errorStr.contains('two factor') ||
          errorStr.contains('2fa') ||
          errorStr.contains('null')) {
        if (context.mounted) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => TotpPage(
                protocol: widget.protocol,
                serverUrl: widget.serverUrl,
                database: widget.database,
                username: _usernameController.text.trim(),
                password: _passwordController.text.trim(),
              ),
            ),
          );
        }
        return;
      }
      if (mounted) setState(() => _errorMessage = _mapError(e));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  /// Shows a dialog when required modules are missing on the server.
  void showModuleMissingDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        titlePadding: const EdgeInsets.fromLTRB(24, 32, 24, 0),
        contentPadding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
        actionsPadding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
        title: Row(
          children: [
            const HugeIcon(
              icon: HugeIcons.strokeRoundedAlertCircle,
              color: AppStyle.primaryColor,
              size: 24,
            ),
            const SizedBox(width: 12),
            Text(
              'Module Missing',
              style: GoogleFonts.manrope(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Colors.black,
              ),
            ),
          ],
        ),
        content: Text(
          'The required "CRM" module is not installed. Please contact your administrator to enable it.',
          style: GoogleFonts.manrope(
            fontSize: 15,
            color: Colors.black87,
            height: 1.5,
          ),
        ),
        actions: [
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppStyle.primaryColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                padding: const EdgeInsets.symmetric(vertical: 14),
                elevation: 0,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'Back to Add Account',
                style: GoogleFonts.manrope(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Maps common login errors to user-friendly messages.
  String _mapError(dynamic error) {
    final errorStr = error.toString().toLowerCase();
    if (errorStr.contains('accessdenied') ||
        errorStr.contains('wrong login/password') ||
        errorStr.contains('invalid login') ||
        errorStr.contains('{code: 200') && errorStr.contains('accessdenied')) {
      return 'Incorrect username or password. Please check your login credentials.';
    } else if (errorStr.contains('html instead of json') ||
        errorStr.contains('formatexception')) {
      return 'Server configuration issue. This may not be an Odoo server or the URL is incorrect.';
    } else if (errorStr.contains('invalid login') ||
        errorStr.contains('wrong credentials')) {
      return 'Incorrect email or password. Please check your login credentials.';
    } else if (errorStr.contains('user not found') ||
        errorStr.contains('no such user')) {
      return 'User account not found. Please check your email address or contact your administrator.';
    } else if (errorStr.contains('database') &&
        errorStr.contains('not found')) {
      return 'Selected database is not available. Please choose a different database.';
    } else if (errorStr.contains('network') || errorStr.contains('socket')) {
      return 'Network connection failed. Please check your internet connection.';
    } else if (errorStr.contains('timeout')) {
      return 'Connection timed out. The server may be slow or unreachable.';
    } else if (errorStr.contains('unauthorized') || errorStr.contains('403')) {
      return 'Access denied. Your account may not have permission to access this database.';
    } else if (errorStr.contains('server') || errorStr.contains('500')) {
      return 'Server error occurred. Please try again later or contact your administrator.';
    } else if (errorStr.contains('ssl') || errorStr.contains('certificate')) {
      return 'SSL connection failed. Try using HTTP instead of HTTPS.';
    } else if (errorStr.contains('connection refused')) {
      return 'Server is not responding. Please verify the server URL and try again.';
    } else {
      return 'Login failed. Please check your credentials and server settings.';
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                color: isDark ? Colors.grey[950] : Colors.grey[50],
                image: DecorationImage(
                  image: const AssetImage("assets/loginbg.png"),
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(
                    isDark
                        ? Colors.black.withOpacity(1)
                        : Colors.white.withOpacity(1),
                    BlendMode.dstATop,
                  ),
                ),
              ),
              child: SafeArea(
                child: Column(
                  children: [
                    Stack(
                      children: [
                        Positioned(
                          top: 0,
                          left: 0,
                          child: SafeArea(
                            bottom: false,
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: _isLoading
                                    ? null
                                    : () => Navigator.of(context).pop(),
                                borderRadius: BorderRadius.circular(32),
                                child: Container(
                                  height: 64,
                                  width: 64,
                                  alignment: Alignment.center,
                                  child: Icon(
                                    HugeIcons.strokeRoundedArrowLeft01,
                                    color: _isLoading
                                        ? Colors.white54
                                        : Colors.white,
                                    size: 24,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SafeArea(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 40),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  'assets/whitecrm.png',
                                  fit: BoxFit.fitWidth,
                                  height: 30,
                                  width: 30,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Icon(
                                      Icons.business,
                                      color: AppStyle.primaryColor,
                                      size: 20,
                                    );
                                  },
                                ),
                                const SizedBox(width: 10),
                                const Text(
                                  'mobo crm',
                                  style: TextStyle(
                                      fontFamily: "YaroRg",
                                      fontWeight: FontWeight.w400,
                                      fontSize: 28,
                                      color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 20),
                      const SizedBox(height: 45),
                      Align(
                        alignment: Alignment.center,
                        child: Text(
                          "Add Account",
                          style: GoogleFonts.montserrat(
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                            fontSize: 25,
                          ),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Enter your credentials to continue',
                        style: GoogleFonts.manrope(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 30),
                      Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildInputField(
                              controller: _usernameController,
                              label: "Username",
                              icon: HugeIcons.strokeRoundedUser03,
                            ),
                            const SizedBox(height: 20),
                            _buildInputField(
                              controller: _passwordController,
                              label: "Password",
                              obscure: true,
                              isPasswordField: true,
                              icon: HugeIcons.strokeRoundedSquareLockPassword,
                            ),
                          ],
                        ),
                      ),
                      if (_errorMessage != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            _errorMessage!,
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      const SizedBox(height: 30),
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _addAccount,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            elevation: 0,
                          ),
                          child: _isLoading
                              ? Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Adding',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    LoadingAnimationWidget.staggeredDotsWave(
                                      color: Colors.white,
                                      size: 28,
                                    ),
                                  ],
                                )
                              : const Text(
                                  'Add Account',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Builds a styled text input field with optional password toggle and icon.
  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    bool obscure = false,
    IconData? icon,
    bool isPasswordField = false,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: isPasswordField ? !_isPasswordVisible : obscure,
      validator: (value) {
        if (value == null || value.isEmpty) return '$label is required';
        return null;
      },
      style: const TextStyle(color: Colors.black),
      decoration: InputDecoration(
        hintText: label,
        hintStyle: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: Colors.black.withOpacity(0.4),
        ),
        prefixIcon: icon != null ? Icon(icon, color: Colors.black26) : null,
        suffixIcon: isPasswordField
            ? IconButton(
                icon: Icon(
                  _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                  color: _isPasswordVisible ? Colors.black26 : Colors.black54,
                ),
                onPressed: () =>
                    setState(() => _isPasswordVisible = !_isPasswordVisible),
              )
            : null,
        filled: true,
        fillColor: Colors.grey.shade100,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        errorStyle: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
