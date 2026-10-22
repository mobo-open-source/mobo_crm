import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:mobo_crm/initilisation.dart';
import 'package:mobo_crm/screens/login/forgot_password_screen.dart';
import 'package:mobo_crm/screens/login/login_layout.dart';
import 'package:mobo_crm/screens/login/totp_page.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/company/services/company_session_service_impl.dart';
import '../../global_methods/services/global_error_handler.dart';
import '../../global_methods/services/isar_caching_service.dart';
import '../customers/provider/customer_data_provider.dart';
import '../discuss/providers/discuss_provider.dart';
import '../lead/providers/lead_data_provider.dart';
import '../opportunity/providers/opportunity_data_provider.dart';
import '../quotation/provider/quotation_view_provider.dart';
import '../../services/app_install_check.dart';
import '../../services/database_expiry.dart';
import '../../services/login_service.dart';
import '../../services/storage_service.dart';
import '../../utils/globals.dart';

/// Login screen for authenticating users against the Odoo server.
///
/// Responsibilities:
/// - Collects username & password
/// - Validates inputs
/// - Calls LoginService to authenticate
/// - Handles TOTP redirection
/// - Handles missing module scenarios
/// - Persists successful login server history
///
/// Navigation:
/// - Success → /init
/// - TOTP required → TotpPage
/// - Module missing → Server setup
class LoginPage extends StatefulWidget {
  final bool clearAll;
  final String? serverUrl;
  final String? database;
  final String? protocol;

  const LoginPage(
      {super.key,
      this.clearAll = false,
      this.serverUrl,
      this.database,
      this.protocol});

  @override
  State<LoginPage> createState() => LoginPageState();
}

/// State for [LoginPage].
///
/// Manages:
/// - Form validation state
/// - Loading indicator
/// - Error messages
/// - Password visibility
/// - Server URL & database from previous screen
class LoginPageState extends State<LoginPage> {
  final _loginFormKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isLoading = false;
  bool _submitted = false;
  String? _errorMessage;

  /// Set when the database has expired, so signing in is refused.
  DatabaseExpiredException? _expiredDatabase;
  bool _isPasswordVisible = false;

  late String serverUrl;
  late String database;
  final _storageService = StorageService();

  @override
  void initState() {
    super.initState();
    if (widget.clearAll) {
      Provider.of<OdooClientManager>(context, listen: false).clearAll();
    }

    serverUrl = widget.serverUrl ?? '';
    database = widget.database ?? '';

    if (serverUrl.isEmpty || database.isEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() {
          _errorMessage =
              'Server URL and database are required. Please go back and configure.';
        });
      });
    }
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _usernameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      onPopInvoked: (didPop) {
        if (!didPop) {
          if (Navigator.of(context).canPop()) {
            Navigator.of(context).pop();
          } else {
            Navigator.of(context).pushReplacementNamed('/server_setup');
          }
        }
      },
      child: LoginLayout(
        title: 'Sign In',
        subtitle: 'Enter your credentials to access the app',
        backButton: Positioned(
          top: MediaQuery.of(context).padding.top + 8,
          left: 16,
          child: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
              size: 20,
            ),
            onPressed: () {
              if (Navigator.of(context).canPop()) {
                Navigator.of(context).pop();
              } else {
                Navigator.of(context).pushReplacementNamed('/server_setup');
              }
            },
          ),
        ),
        child: Form(
          key: _loginFormKey,
          child: _buildLoginForm(),
        ),
      ),
    );
  }

  Widget _buildLoginForm() {
    return AutofillGroup(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          LoginTextField(
            controller: _usernameController,
            hint: 'Username',
            prefixIcon: HugeIcons.strokeRoundedUser,
            enabled: !_isLoading,
            autofillHints: const [AutofillHints.username, AutofillHints.email],
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Username is required';
              }
              return null;
            },
            autovalidateMode: _submitted
                ? AutovalidateMode.onUserInteraction
                : AutovalidateMode.disabled,
          ),
          const SizedBox(height: 16),
          LoginTextField(
            controller: _passwordController,
            hint: 'Password',
            prefixIcon: HugeIcons.strokeRoundedSquareLockPassword,
            obscureText: !_isPasswordVisible,
            autofillHints: const [AutofillHints.password],
            enabled: !_isLoading,
            suffixIcon: IconButton(
              icon: Icon(
                _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                size: 20,
                color: Colors.black54,
              ),
              onPressed: () {
                setState(() {
                  _isPasswordVisible = !_isPasswordVisible;
                });
              },
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Password is required';
              }
              return null;
            },
            autovalidateMode: _submitted
                ? AutovalidateMode.onUserInteraction
                : AutovalidateMode.disabled,
          ),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: _isLoading
                  ? null
                  : () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ResetPasswordScreen(
                            url: _buildFullServerUrl(),
                            database: database,
                          ),
                        ),
                      );
                    },
              child: Text(
                'Forgot Password?',
                style: GoogleFonts.manrope(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: _isLoading ? Colors.white54 : Colors.white70,
                  decorationColor: _isLoading ? Colors.white54 : Colors.white,
                ),
              ),
            ),
          ),
          if (_expiredDatabase != null) ...[
            LoginBlockedNotice(
              title: _expiredDatabase!.title,
              message: _expiredDatabase!.message,
            ),
            const SizedBox(height: 14),
          ],
          if (_errorMessage != null) ...[
            LoginErrorDisplay(error: _errorMessage),
            SizedBox(
              height: 10,
            ),
          ],
          LoginButton(
            text: 'Sign In',
            isLoading: _isLoading,
            onPressed: _performLogin,
            loadingWidget: LoadingAnimationWidget.staggeredDotsWave(
              color: Colors.white,
              size: 20,
            ),
          ),
        ],
      ),
    );
  }

  /// Shows a blocking dialog when the required CRM module is missing
  /// on the server.
  ///
  /// Prevents user from proceeding until server setup is corrected.
  void showModuleMissingDialog(BuildContext context,
      {RequiredModulesBlock? block}) {
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
          (block ?? RequiredModulesBlock.generic).message,
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
                'Back to Login',
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

  /// Shows a blocking dialog when a portal user attempts to log in.
  ///
  /// Portal users don't have access to this internal app and must be
  /// stopped here rather than allowed to proceed.
  void showAccessDeniedDialog(BuildContext context) {
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
              'Access Denied',
              style: GoogleFonts.manrope(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Colors.black,
              ),
            ),
          ],
        ),
        content: Text(
          'This feature is not available for portal users. Please contact your administrator.',
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
                'Back to Login',
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

  /// Saves successful login details into SharedPreferences for quick reuse.
  ///
  /// Stores:
  /// - protocol (http / https)
  /// - server URL
  /// - database name
  /// - username
  ///
  /// Behavior:
  /// - Normalizes protocol from URL if user included it
  /// - Removes duplicate entries
  /// - Keeps only the 10 most recent servers
  Future<void> _saveUrlHistory({
    required String protocol,
    required String url,
    required String database,
    required String username,
  }) async {
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

  /// Validates form and performs login using [LoginService].
  ///
  /// Flow:
  /// 1. Validates form fields
  /// 2. Normalizes server URL
  /// 3. Calls LoginService.login(...)
  /// 4. Handles outcomes:
  ///    - success → navigates to init screen
  ///    - moduleMissing → shows dialog & redirects
  ///    - totpRequired → navigates to TOTP screen
  ///    - databaseExpired → shows a notice that sign-in is blocked
  ///    - invalidCredentials → shows inline error
  ///    - serverError → formats error message
  /// Normalizes [widget.serverUrl] to a bare host and prepends
  /// [widget.protocol], so callers always get a fully-schemed URL
  /// (e.g. `http://192.168.29.35:8018`) instead of assuming https.
  String _buildFullServerUrl() {
    String baseUrl = (widget.serverUrl ?? serverUrl).trim();
    if (baseUrl.startsWith("http://") || baseUrl.startsWith("https://")) {
      baseUrl = baseUrl.replaceFirst(RegExp(r'^https?://'), '');
    }
    return (widget.protocol ?? 'https://') + baseUrl;
  }

  Future<void> _performLogin() async {
    setState(() {
      _submitted = true;
      _errorMessage = null;
      _expiredDatabase = null;
    });

    if (!_loginFormKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final result = await LoginService(
            storageService: StorageService(),
            appInstallCheck: AppInstallCheck(),
            sessionService: CompanySessionServiceImpl())
        .login(
      serverUrl: _buildFullServerUrl(),
      database: widget.database!,
      username: _usernameController.text.trim(),
      password: _passwordController.text.trim(),
    );

    setState(() => _isLoading = false);

    switch (result.status) {
      case LoginStatus.success:
        await _clearPreviousAccountData();
        await _saveUrlHistory(
          protocol: widget.protocol!,
          url: _buildFullServerUrl(),
          database: database,
          username: _usernameController.text.trim(),
        );
        Navigator.pushReplacementNamed(context, '/init');
        break;

      case LoginStatus.moduleMissing:
        Navigator.pushNamedAndRemoveUntil(
          context,
          '/server_setup',
          (route) => false,
        );
        showModuleMissingDialog(context,
            block: result.error as RequiredModulesBlock?);
        break;

      case LoginStatus.totpRequired:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => TotpPage(
              serverUrl: _buildFullServerUrl(),
              database: widget.database!,
              username: _usernameController.text.trim(),
              password: _passwordController.text.trim(),
              protocol: widget.protocol!,
            ),
          ),
        );
        break;

      case LoginStatus.accessDenied:
        showAccessDeniedDialog(context);
        break;

      case LoginStatus.databaseExpired:
        // Nothing was saved, so the user simply stays on this screen.
        setState(() => _expiredDatabase = result.error as DatabaseExpiredException);
        break;

      case LoginStatus.invalidCredentials:
        setState(() => _errorMessage = 'Incorrect username or password');
        break;

      case LoginStatus.serverError:
        setState(() => _errorMessage = _formatLoginError(result.error));
        break;
    }
  }

  /// Drops the offline cache and in-memory lists left by the previous
  /// account, as the TOTP and switch-account logins already do. Otherwise
  /// the lists open from another user's cache (e.g. an admin's leads), and
  /// editing such a record fails with an AccessError for this user.
  Future<void> _clearPreviousAccountData() async {
    try {
      await IsarService.clearAllData();
    } catch (_) {}
    if (!mounted) return;
    for (final clear in <void Function()>[
      () => Provider.of<OpportunityDataProvider>(context, listen: false)
          .clearAll(),
      () => Provider.of<LeadDataProvider>(context, listen: false).clearAll(),
      () => Provider.of<CustomerDataProvider>(context, listen: false)
          .clearAll(),
      () => Provider.of<QuotationViewProvider>(context, listen: false)
          .clearAllData(),
      () => Provider.of<DiscussProvider>(context, listen: false).clearAll(),
    ]) {
      try {
        clear();
      } catch (_) {}
    }
  }

  /// Converts raw server / network / parsing errors into
  /// user-friendly error messages for display.
  ///
  /// Covers:
  /// - Invalid credentials
  /// - Database not found
  /// - Network errors
  /// - SSL / certificate errors
  /// - Timeout
  /// - Server 500 errors
  String _formatLoginError(dynamic error) {
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
    } else if (errorStr.contains('null')) {
      return '';
    } else {
      return 'Login failed. Please check your credentials and server settings.';
    }
  }
}
