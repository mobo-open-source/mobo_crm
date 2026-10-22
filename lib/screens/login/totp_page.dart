import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../bottom_nav_screen.dart';
import '../../core/company/session/company_session_manager.dart';
import '../../core/security/secure_storage_service.dart';
import '../../global_methods/services/global_error_handler.dart';
import '../../global_methods/services/isar_caching_service.dart';
import '../../initilisation.dart';
import '../../services/app_install_check.dart';
import '../../services/database_expiry.dart';
import '../../services/storage_service.dart';
import '../../utils/globals.dart';
import '../customers/provider/customer_data_provider.dart';
import '../discuss/providers/discuss_provider.dart';
import '../lead/providers/lead_data_provider.dart';
import '../opportunity/providers/opportunity_data_provider.dart';
import 'login_layout.dart';

/// Handles Two-Factor Authentication (TOTP) using an invisible in-app WebView.
///
/// Drives Odoo's real `/web/login` page directly:
/// 1. Load the login page and inject the username/password into the real form.
/// 2. Detect the TOTP challenge page and let the user enter the 6-digit code.
/// 3. Submit the code through the page itself and extract the resulting
///    `session_id` cookie once Odoo redirects to a logged-in page.
class TotpPage extends StatefulWidget {
  final String serverUrl;
  final String database;
  final String username;
  final String password;
  final String protocol;

  const TotpPage({
    super.key,
    required this.serverUrl,
    required this.database,
    required this.username,
    required this.password,
    required this.protocol,
  });

  @override
  State<TotpPage> createState() => _TotpPageState();
}

class _TotpPageState extends State<TotpPage> {
  InAppWebViewController? _webController;
  final _totpController = TextEditingController();
  String? _error;
  bool _loading = true;
  bool _verifying = false;

  /// Set when the database has expired, so signing in is refused.
  DatabaseExpiredException? _expiredDatabase;
  bool _isButtonEnabled = false;
  final _formKey = GlobalKey<FormState>();
  bool _credentialsInjected = false;
  bool _isSessionExtracted = false;
  bool _loginSuccess = false;

  /// `session_id` cookie value extracted from the WebView once login succeeds.
  String? sessionId;

  final StorageService _storageService = StorageService();

  static const String _userAgent =
      'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36';

  @override
  void dispose() {
    _totpController.dispose();
    super.dispose();
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
                  image: const AssetImage('assets/loginbg.png'),
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(
                    isDark
                        ? Colors.black.withValues(alpha: 1)
                        : Colors.white.withValues(alpha: 1),
                    BlendMode.dstATop,
                  ),
                ),
              ),
            ),
          ),

          Positioned.fill(
            child: Opacity(
              opacity: 0.0,
              child: InAppWebView(
                initialSettings: InAppWebViewSettings(
                  javaScriptEnabled: true,
                  cacheEnabled: false,
                  clearCache: true,
                  userAgent: _userAgent,
                  useHybridComposition: true,
                  allowContentAccess: true,
                  allowFileAccess: true,
                  mixedContentMode: MixedContentMode.MIXED_CONTENT_ALWAYS_ALLOW,
                  forceDark: ForceDark.AUTO,
                  disableDefaultErrorPage: true,
                ),
                onWebViewCreated: (controller) async {
                  _webController = controller;

                  // Odoo remembers a "trusted device" via a persistent
                  // cookie. This app never asks the user to opt into that,
                  // so any leftover trust cookie (from before this fix, or
                  // a previous account on this device) must be wiped before
                  // loading the login page — otherwise Odoo silently skips
                  // the TOTP challenge on this and every later login.
                  try {
                    await CookieManager.instance().deleteAllCookies();
                  } catch (_) {}

                  await controller.loadUrl(
                    urlRequest: URLRequest(
                      url: WebUri(
                        '${widget.serverUrl}/web/login?db=${widget.database}',
                      ),
                    ),
                  );
                },
                onReceivedServerTrustAuthRequest:
                    (controller, challenge) async {
                      return ServerTrustAuthResponse(
                        action: ServerTrustAuthResponseAction.PROCEED,
                      );
                    },
                onReceivedError: (controller, request, error) {
                  if (mounted) {
                    setState(() {
                      _loading = false;
                      _error = 'Failed to load: ${error.description}';
                    });
                  }
                },
                onLoadStop: (controller, url) async {
                  final urlStr = url?.toString() ?? '';

                  if (urlStr.contains('/web/database/selector') ||
                      urlStr.contains('/web/database/manager')) {
                    await _handleDatabaseSelector();
                    return;
                  }

                  if (urlStr.contains('/web/login') && !_credentialsInjected) {
                    await Future.delayed(const Duration(milliseconds: 800));
                    await _injectCredentials();
                    return;
                  }

                  if (urlStr.contains('/web/login/totp') ||
                      urlStr.contains('totp_token')) {
                    if (mounted) {
                      setState(() {
                        _loading = false;
                      });
                    }
                    await Future.delayed(const Duration(milliseconds: 600));
                    await _focusTotpField();
                    return;
                  }

                  if ((urlStr.contains('/web') ||
                          urlStr.contains('/odoo/discuss') ||
                          urlStr.contains('/odoo') ||
                          urlStr.contains('/odoo/apps') ||
                          urlStr.contains('/website')) &&
                      !urlStr.contains('/login') &&
                      !urlStr.contains('/totp')) {
                    await _extractSessionAndSave(controller);
                  }
                },
              ),
            ),
          ),

          Positioned(
            top: 0,
            left: 0,
            child: SafeArea(
              bottom: false,
              child: IgnorePointer(
                ignoring: _loading,
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () => Navigator.of(context).pop(),
                    borderRadius: BorderRadius.circular(32),
                    child: Container(
                      height: 64,
                      width: 64,
                      alignment: Alignment.center,
                      child: Icon(
                        HugeIcons.strokeRoundedArrowLeft01,
                        color: _loading ? Colors.white54 : Colors.white,
                        size: 24,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildHeader(),
                const SizedBox(height: 20),
                _buildForm(),
              ],
            ),
          ),

          if (_loading)
            Container(
              color: isDark ? Colors.black54 : Colors.white70,
              child: Center(
                child: LoadingAnimationWidget.fourRotatingDots(
                  color: AppStyle.primaryColor,
                  size: 60,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Icon(
          HugeIcons.strokeRoundedTwoFactorAccess,
          color: Colors.white,
          size: 48,
        ),
        const SizedBox(height: 24),
        Text(
          'Two-factor Authentication',
          style: GoogleFonts.montserrat(
            fontWeight: FontWeight.w600,
            color: Colors.white,
            fontSize: 25,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),
        Text(
          'To login, enter below the six-digit authentication code provided by your Authenticator app.',
          style: GoogleFonts.montserrat(
            fontSize: 14,
            color: Colors.white70,
            height: 1.4,
          ),
          textAlign: TextAlign.center,
        ),
        if (widget.serverUrl.isNotEmpty) ...[
          const SizedBox(height: 16),
          Text(
            'Server: ${widget.serverUrl}',
            style: GoogleFonts.manrope(
              fontSize: 12,
              color: Colors.white60,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ],
    );
  }

  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextFormField(
            controller: _totpController,
            keyboardType: TextInputType.number,
            enabled: !_loading && !_verifying,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'TOTP is required';
              }
              return null;
            },
            onChanged: (value) {
              setState(() {
                _isButtonEnabled = value.trim().isNotEmpty;
                _formKey.currentState?.validate();
                if (_error != null) _error = null;
              });
            },
            cursorColor: Colors.black,
            style: GoogleFonts.manrope(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: Colors.black,
            ),
            decoration: InputDecoration(
              hintText: 'Enter TOTP Code',
              hintStyle: GoogleFonts.manrope(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: Colors.black.withValues(alpha: 0.4),
              ),
              prefixIcon: SizedBox(
                width: 48,
                height: 48,
                child: Center(
                  child: Transform.scale(
                    scale: 20 / 24.0,
                    child: const Icon(
                      HugeIcons.strokeRoundedSmsCode,
                      color: Colors.black54,
                      size: 24,
                    ),
                  ),
                ),
              ),
              prefixIconColor: WidgetStateColor.resolveWith(
                (states) => states.contains(WidgetState.disabled)
                    ? Colors.black26
                    : Colors.black54,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 16,
              ),
              errorStyle: const TextStyle(color: Colors.white),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.red[900]!, width: 1.0),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.white, width: 1.5),
              ),
            ),
          ),
          const SizedBox(height: 10),

          if (_expiredDatabase != null) ...[
            LoginBlockedNotice(
              title: _expiredDatabase!.title,
              message: _expiredDatabase!.message,
            ),
            const SizedBox(height: 10),
          ],

          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            height: _error != null ? 48 : 0,
            child: _error != null
                ? Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          HugeIcons.strokeRoundedAlertCircle,
                          color: Colors.white,
                          size: 18,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            _error!,
                            style: GoogleFonts.manrope(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                : null,
          ),

          const SizedBox(height: 20),

          SizedBox(
            height: 48,
            child: ElevatedButton(
              onPressed: (_verifying || !_isButtonEnabled) ? null : _submitTotp,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
                disabledForegroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: _verifying
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Authenticating',
                          style: GoogleFonts.manrope(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(width: 12),
                        LoadingAnimationWidget.staggeredDotsWave(
                          color: Colors.white,
                          size: 28,
                        ),
                      ],
                    )
                  : Text(
                      'Authenticate',
                      style: GoogleFonts.manrope(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _injectCredentials() async {
    if (_credentialsInjected) return;

    final safeUser = jsonEncode(widget.username);
    final safePass = jsonEncode(widget.password);
    final safeDb = jsonEncode(widget.database);

    await _webController?.evaluateJavascript(
      source:
          """
      (function() {
        const login = document.querySelector('input[name="login"], input[type="email"]');
        const password = document.querySelector('input[name="password"]');
        const db = document.querySelector('input[name="db"], select[name="db"]');
        const form = document.querySelector('form[action*="/web/login"]');

        if (!login || !password || !form) return "missing";

        login.value = $safeUser;
        password.value = $safePass;
        if (db) {
          if (db.tagName === 'INPUT') db.value = $safeDb;
          else db.value = $safeDb;
        }

        const btn = form.querySelector('button[type="submit"]');
        if (btn) btn.click();
        else form.requestSubmit();

        return "submitted";
      })();
    """,
    );
    _credentialsInjected = true;
  }

  Future<void> _handleDatabaseSelector() async {
    await _webController?.evaluateJavascript(
      source:
          """
      const select = document.querySelector('select[name="db"]');
      if (select) {
        select.value = '${widget.database}';
        const btn = document.querySelector('button[type="submit"]');
        if (btn) btn.click();
      }
    """,
    );
  }

  Future<void> _focusTotpField() async {
    await _webController?.evaluateJavascript(
      source: """
      const input = document.querySelector('input[name="totp_token"], input[autocomplete="one-time-code"]');
      if (input) {
        input.focus();
        input.select();
      }
    """,
    );
  }

  Future<void> _submitTotp() async {
    if (_verifying || _webController == null) return;

    setState(() {
      _verifying = true;
      _error = null;
      _expiredDatabase = null;
    });

    final totp = _totpController.text.trim();
    if (totp.length != 6 || !RegExp(r'^\d{6}$').hasMatch(totp)) {
      setState(() {
        _error = 'Please enter a valid 6-digit code';
        _verifying = false;
      });
      return;
    }

    try {
      await _webController!.evaluateJavascript(
        source:
            """
        (function() {
          let input = document.querySelector(
            'input[name="totp_token"], input[autocomplete="one-time-code"], input[type="text"][maxlength="6"], input[type="number"][maxlength="6"]'
          );
          if (!input) return "totp_input_not_found";


          input.focus();
          input.value = '$totp';
          ['input', 'change', 'keydown', 'keyup', 'keypress'].forEach(eventType => {
            input.dispatchEvent(new KeyboardEvent(eventType, {key: 'Enter', bubbles: true, cancelable: true}));
          });


          // Never let Odoo remember this device: otherwise it silently
          // skips the TOTP challenge on every later login from this app.
          const trustCheckbox = document.querySelector('input[name="trust_device"], input[type="checkbox"], [name="trust"]');
          if (trustCheckbox && trustCheckbox.checked) {
            trustCheckbox.checked = false;
            trustCheckbox.dispatchEvent(new Event('change', {bubbles: true}));
          }


          const form = input.closest('form') || document.querySelector('form[action*="/web/login"]');
          if (form) {
            const btn = form.querySelector('button[type="submit"], button.btn-primary, button[name="submit"], button.btn-block');
            if (btn) {
              btn.click();
            } else {
              form.submit();
            }
            return "totp_submitted";
          }
          return "form_not_found";
        })();
      """,
      );

      await Future.delayed(const Duration(seconds: 2));

      for (int i = 0; i < 20; i++) {
        final isLoggedIn = await _webController!.evaluateJavascript(
          source: """
          (function() {
            const userMenu = document.querySelector('.o_user_menu, .oe_topbar_avatar, .o_apps_switcher, [data-menu="account"]');
            const webClient = document.querySelector('.o_web_client, .o_action_manager');
            const error = document.querySelector('.alert-danger, .o_error_dialog');
            if (userMenu || webClient) return true;
            if (error) return 'error';
            return false;
          })();
          """,
        );
        if (isLoggedIn == 'error') {
          setState(
            () => _error = "Invalid code or login failed. Please try again.",
          );
          return;
        }
        await Future.delayed(const Duration(milliseconds: 500));
      }

      await Future.delayed(const Duration(seconds: 4));

      final currentUrl = await _webController!.getUrl();
      final urlStr = currentUrl?.toString() ?? '';

      final cookies = await CookieManager.instance().getCookies(
        url: currentUrl!,
      );

      final sessionCookie = cookies.firstWhere(
        (c) => c.name == 'session_id',
        orElse: () => Cookie(name: 'session_id', value: ''),
      );

      final domSuccess = await _webController!.evaluateJavascript(
        source: """
        (function() {
          const hasUserMenu = !!document.querySelector('.o_user_menu, .oe_topbar_avatar');
          const hasWebClient = !!document.querySelector('.o_web_client');
          return hasUserMenu || hasWebClient;
        })();
      """,
      );

      final isSuccess = domSuccess == true ||
          (sessionCookie.value.isNotEmpty &&
              sessionCookie.value.length > 20 &&
              ((urlStr.contains('/web') ||
                      urlStr.contains('/odoo/discuss') ||
                      urlStr.contains('/odoo') ||
                      urlStr.contains('/odoo/apps')) &&
                  !urlStr.contains('/login') &&
                  !urlStr.contains('/totp')));

      if (isSuccess && sessionCookie.value.isNotEmpty) {
        sessionId = sessionCookie.value;
        await _saveSessionData();
        return;
      }

      if (mounted) {
        setState(() {
          _error = 'Invalid code or login failed. Please try again.';
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = 'Authentication failed. Please try again.';
        });
      }
    } finally {
      if (mounted && !_loginSuccess) {
        setState(() {
          _verifying = false;
        });
      }
    }
  }

  /// Called from [onLoadStop] when the WebView naturally navigates to a
  /// logged-in page (e.g. Odoo submitted the TOTP form itself before the
  /// polling loop in [_submitTotp] noticed).
  Future<void> _extractSessionAndSave(
    InAppWebViewController controller,
  ) async {
    if (_isSessionExtracted) return;

    try {
      final currentUrl = await controller.getUrl();
      final cookies = await CookieManager.instance().getCookies(
        url: currentUrl ?? WebUri(widget.serverUrl),
      );

      final sessionCookie = cookies.firstWhere(
        (cookie) => cookie.name == 'session_id',
        orElse: () => Cookie(name: '', value: ''),
      );

      if (sessionCookie.value.isNotEmpty) {
        sessionId = sessionCookie.value;
        await _saveSessionData();
      } else if (mounted) {
        setState(() {
          _loading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _loading = false;
        });
      }
    }
  }

  Future<void> _saveSessionData() async {
    if (_isSessionExtracted) return;
    _isSessionExtracted = true;
    _loginSuccess = true;

    try {
      if (sessionId == null || sessionId!.isEmpty) {
        _isSessionExtracted = false;
        _loginSuccess = false;
        if (mounted) setState(() => _error = 'Login failed. Please try again.');
        return;
      }

      final success = await CompanySessionManager.loginAndSaveSession(
        serverUrl: widget.serverUrl,
        database: widget.database,
        userLogin: widget.username.trim(),
        password: widget.password.trim(),
        existingSessionId: sessionId,
      );

      await _saveUrlHistory(
        protocol: widget.protocol,
        url: widget.serverUrl,
        database: widget.database,
        username: widget.username.trim(),
      );

      if (!success) {
        _isSessionExtracted = false;
        _loginSuccess = false;
        if (mounted) {
          setState(() {
            _error = 'Invalid code or login failed. Please try again.';
            _verifying = false;
          });
        }
        return;
      }

      final session = await CompanySessionManager.getCurrentSession();
      await _storageService.saveAccount({
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
        'url': widget.serverUrl,
        'database': widget.database,
        'image': '',
      });

      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('logoutAction');
      await prefs.setString('sessionId', sessionId!);
      await prefs.setString('username', widget.username);
      await prefs.setString('url', widget.serverUrl);
      await prefs.setString('database', widget.database);
      await prefs.setBool('logoutAction', false);
      await prefs.setBool('isLoggedIn', true);
      await prefs.setString('lastUsername', widget.username.trim());
      await prefs.setInt(
        'loginTimestamp',
        DateTime.now().millisecondsSinceEpoch,
      );

      await prefs.setBool('is2FAUser', true);
      await prefs.setString('totp_protocol', widget.protocol);
      await prefs.setString('totp_server_url', widget.serverUrl);
      await prefs.setString('totp_database', widget.database);
      await prefs.setString('totp_username', widget.username);
      await SecureStorageService().savePassword(
        url: widget.serverUrl,
        database: widget.database,
        username: widget.username,
        password: widget.password,
      );

      if (!mounted) return;

      /// Portal users have no access to internal models (e.g. crm.lead),
      /// which would otherwise be misread as a missing-module error below.
      /// Reject them here with the correct access-denied outcome.
      final isPortal = await ErrorHandler().isPortalUser();
      if (isPortal) {
        List<String> urlHistory = prefs.getStringList('urlHistory') ?? [];
        bool isGetStarted = prefs.getBool('hasSeenGetStarted') ?? false;
        await prefs.clear();
        await prefs.setStringList('urlHistory', urlHistory);
        await prefs.setBool('hasSeenGetStarted', isGetStarted);
        await CompanySessionManager.clearSessionCache();

        if (mounted) {
          Navigator.pushNamedAndRemoveUntil(
            context,
            '/server_setup',
            (route) => false,
          );
          showAccessDeniedDialog(context);
        }
        return;
      }

      final checker = AppInstallCheck();
      RequiredModulesBlock? moduleBlock;
      try {
        moduleBlock = await checker.requiredModulesBlock();
      } on ModuleAccessDeniedException {
        List<String> urlHistory = prefs.getStringList('urlHistory') ?? [];
        bool isGetStarted = prefs.getBool('hasSeenGetStarted') ?? false;
        await prefs.clear();
        await prefs.setStringList('urlHistory', urlHistory);
        await prefs.setBool('hasSeenGetStarted', isGetStarted);
        await CompanySessionManager.clearSessionCache();

        if (mounted) {
          Navigator.pushNamedAndRemoveUntil(
            context,
            '/server_setup',
            (route) => false,
          );
          showAccessDeniedDialog(context);
        }
        return;
      }

      if (moduleBlock != null) {
        /// Roll back only this account's session/account entries so a
        /// database missing CRM or Sales doesn't linger in the
        /// switch-accounts list — unlike the portal/access-denied branches
        /// above, this must not wipe unrelated saved accounts via
        /// prefs.clear().
        await _storageService.removeAccount(
          userLogin: session?.userLogin ?? '',
          userName: session?.userName ?? '',
          userId: session?.userId ?? 0,
          url: widget.serverUrl,
          database: widget.database,
        );
        await SecureStorageService().deletePassword(
          url: widget.serverUrl,
          database: widget.database,
          username: widget.username,
        );
        await prefs.remove('sessionId');
        await prefs.remove('username');
        await prefs.remove('url');
        await prefs.remove('database');
        await prefs.remove('isLoggedIn');
        await prefs.remove('lastUsername');
        await prefs.remove('loginTimestamp');
        await prefs.remove('is2FAUser');
        await prefs.remove('totp_protocol');
        await prefs.remove('totp_server_url');
        await prefs.remove('totp_database');
        await prefs.remove('totp_username');
        await CompanySessionManager.clearSessionCache();

        if (mounted) {
          Navigator.pushNamedAndRemoveUntil(
            context,
            '/server_setup',
            (route) => false,
          );
          showModuleMissingDialog(context, block: moduleBlock);
        }
        return;
      }

      final clientManager = Provider.of<OdooClientManager>(
        context,
        listen: false,
      );
      await clientManager.initializeOdooClient(context);
      await clientManager.initializeOdooClientWithUrl(widget.serverUrl);
      await IsarService.clearAllData();

      if (mounted) {
        try {
          Provider.of<OpportunityDataProvider>(
            context,
            listen: false,
          ).clearAll();
        } catch (_) {}
        try {
          Provider.of<LeadDataProvider>(context, listen: false).clearAll();
        } catch (_) {}
        try {
          Provider.of<CustomerDataProvider>(
            context,
            listen: false,
          ).clearAll();
        } catch (_) {}
        try {
          Provider.of<DiscussProvider>(context, listen: false).clearAll();
        } catch (_) {}

        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const HomeScreen(loadInit: true)),
          (route) => false,
        );
      }
    } catch (e) {
      _isSessionExtracted = false;
      _loginSuccess = false;
      if (e is DatabaseExpiredException) {
        // The code was right, but the database it belongs to has expired.
        if (mounted) {
          setState(() {
            _expiredDatabase = e;
            _verifying = false;
          });
        }
        return;
      }
      if (mounted) setState(() => _error = 'Session error. Please try again.');
    }
  }

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
            const Icon(
              HugeIcons.strokeRoundedAlertCircle,
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
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                (block ?? RequiredModulesBlock.generic).message,
                style: GoogleFonts.manrope(
                  fontSize: 15,
                  color: Colors.black87,
                  height: 1.5,
                ),
              ),
            ],
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
              onPressed: () => Navigator.of(context).pop(),
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
            const Icon(
              HugeIcons.strokeRoundedAlertCircle,
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
              onPressed: () => Navigator.of(context).pop(),
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
}
