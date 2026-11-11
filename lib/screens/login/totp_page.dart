import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../bottom_nav_screen.dart';
import '../../core/company/services/connectivity_service.dart';
import '../../core/company/session/company_session_manager.dart';
import '../../core/security/secure_storage_service.dart';
import '../../global_methods/services/global_error_handler.dart';
import '../../global_methods/services/isar_caching_service.dart';
import '../../initilisation.dart';
import '../../services/app_install_check.dart';
import '../../services/auth_service.dart';
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

/// What the "Try again" button does when the WebView is not on the code page.
enum _RetryMode {
  /// Nothing went wrong: the button submits the code.
  none,

  /// Start over from the login page (cookies cleared, credentials resent).
  restart,

  /// The code was accepted and the session exists; only saving it failed, so
  /// retry that step without asking for another code.
  retrySave,
}

/// What kind of Odoo page the WebView is showing.
enum _PageKind { databaseSelector, totp, login, other }

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

  /// True while the credentials are being typed into the login form, so a
  /// second `onLoadStop` for the same page cannot submit the form twice.
  bool _injecting = false;

  _RetryMode _retryMode = _RetryMode.none;

  /// Stops the loading overlay from staying up forever on a stalled page.
  Timer? _watchdog;

  /// How long the login page may take to reach the code form.
  static const Duration _loadTimeout = Duration(seconds: 45);

  /// How long to wait for Odoo to accept the code. A first sign-in on a new
  /// instance can take a while because Odoo builds its assets on demand.
  static const Duration _signInTimeout = Duration(seconds: 90);

  /// How long each step after the WebView (saving the session, module check,
  /// client setup) may take before the user is told and offered a retry.
  static const Duration _stepTimeout = Duration(seconds: 60);

  /// `session_id` cookie value extracted from the WebView once login succeeds.
  String? sessionId;

  final StorageService _storageService = StorageService();

  static const String _userAgent =
      'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36';

  @override
  void dispose() {
    _watchdog?.cancel();
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
                  _startWatchdog();
                  await _loadLoginPage(controller);
                },
                onReceivedServerTrustAuthRequest:
                    (controller, challenge) async {
                      return ServerTrustAuthResponse(
                        action: ServerTrustAuthResponseAction.PROCEED,
                      );
                    },
                onReceivedError: (controller, request, error) {
                  if (_isSessionExtracted) return;
                  // Images, fonts and analytics failing is normal and must not
                  // abort the sign-in: only the page itself counts.
                  if (request.isForMainFrame == false) return;
                  // iOS reports a navigation that was replaced by another one
                  // (e.g. the login form being submitted) as "cancelled".
                  if (error.type == WebResourceErrorType.CANCELLED) return;
                  _failFlow(_describeLoadError(error.description));
                },
                onReceivedHttpError: (controller, request, response) {
                  if (_isSessionExtracted) return;
                  if (request.isForMainFrame == false) return;
                  final status = response.statusCode ?? 0;
                  if (status >= 400) {
                    _failFlow(
                      'The server answered with an error (HTTP $status). '
                      'Please try again in a moment.',
                    );
                  }
                },
                onLoadStop: (controller, url) =>
                    _onPageLoaded(url?.toString() ?? ''),
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
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    LoadingAnimationWidget.fourRotatingDots(
                      color: AppStyle.primaryColor,
                      size: 60,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      _loginSuccess
                          ? 'Signing you in…'
                          : 'Connecting to your server…',
                      style: GoogleFonts.manrope(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: isDark ? Colors.white : Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
            ),

          // Last in the stack so it stays tappable above the loading overlay:
          // the user must always be able to leave a sign-in that is stuck.
          Positioned(
            top: 0,
            left: 0,
            child: SafeArea(
              bottom: false,
              child: IgnorePointer(
                // Leaving halfway through saving the session would strand the
                // account in a half signed-in state.
                ignoring: _loginSuccess,
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: _goBack,
                    borderRadius: BorderRadius.circular(32),
                    child: Container(
                      height: 64,
                      width: 64,
                      alignment: Alignment.center,
                      child: Icon(
                        HugeIcons.strokeRoundedArrowLeft01,
                        color: _loading && !isDark
                            ? Colors.black54
                            : Colors.white,
                        size: 24,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Leaves the page. When this page replaced the route (automatic re-login
  /// at app start) there is nothing to pop, so go to the server setup instead.
  void _goBack() {
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    } else {
      Navigator.of(
        context,
      ).pushNamedAndRemoveUntil('/server_setup', (route) => false);
    }
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
            // Off when the WebView is not on Odoo's code page: there is
            // nothing to type into until "Try again" restarts the sign-in.
            enabled: !_loading && !_verifying && _retryMode == _RetryMode.none,
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
              onPressed: _verifying
                  ? null
                  : _retryMode != _RetryMode.none
                  ? _retry
                  : (_isButtonEnabled ? _submitTotp : null),
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
                      _retryMode != _RetryMode.none
                          ? 'Try again'
                          : 'Authenticate',
                      style: GoogleFonts.manrope(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
            ),
          ),

          if (_verifying) ...[
            const SizedBox(height: 12),
            Text(
              'Signing in… the first sign-in on a new instance can take up to a minute.',
              style: GoogleFonts.manrope(
                fontSize: 12,
                color: Colors.white70,
                height: 1.4,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }

  // ── WebView plumbing ─────────────────────────────────────────────────────

  /// Runs [source] in the page. Never throws and never hangs: a page that is
  /// navigating, or a WebView that has gone away, simply yields `null`.
  Future<dynamic> _js(String source) async {
    final controller = _webController;
    if (controller == null) return null;
    try {
      return await controller
          .evaluateJavascript(source: source)
          .timeout(const Duration(seconds: 8));
    } catch (_) {
      return null;
    }
  }

  /// Loads Odoo's login page from a clean cookie jar.
  Future<void> _loadLoginPage(InAppWebViewController controller) async {
    // Odoo remembers a "trusted device" via a persistent cookie. This app never
    // asks the user to opt into that, so any leftover trust cookie (from a
    // previous account on this device) must be wiped before loading the login
    // page — otherwise Odoo silently skips the TOTP challenge. The wipe is
    // bounded: a cookie store that never answers must not block the sign-in.
    try {
      await CookieManager.instance().deleteAllCookies().timeout(
        const Duration(seconds: 5),
      );
    } catch (_) {}

    try {
      await controller.loadUrl(
        urlRequest: URLRequest(
          url: WebUri(
            '${widget.serverUrl}/web/login'
            '?db=${Uri.encodeQueryComponent(widget.database)}',
          ),
        ),
      );
    } catch (_) {
      _failFlow('Could not open the sign-in page. Please try again.');
    }
  }

  _PageKind _classify(String url) {
    final path = (Uri.tryParse(url)?.path ?? '').toLowerCase();
    if (path.startsWith('/web/database')) return _PageKind.databaseSelector;
    if (path.startsWith('/web/login/totp') || url.contains('totp_token')) {
      return _PageKind.totp;
    }
    // `/web/login_successful` (portal users) is deliberately not "login".
    if (path == '/web/login' || path == '/web/login/') return _PageKind.login;
    return _PageKind.other;
  }

  /// Handles every page the WebView finishes loading. Each branch ends in one
  /// of three states — waiting for the user's code, signed in, or an error the
  /// user can see — so the loading overlay can no longer be left up forever.
  Future<void> _onPageLoaded(String url) async {
    if (!mounted || _isSessionExtracted) return;
    if (url.isEmpty || url == 'about:blank') return;

    switch (_classify(url)) {
      case _PageKind.databaseSelector:
        await _handleDatabaseSelector();
        return;

      case _PageKind.login:
        if (!_credentialsInjected) {
          await Future.delayed(const Duration(milliseconds: 800));
          await _injectCredentials();
          return;
        }
        // Odoo sent us back to the login page after the credentials went in:
        // wrong password, a captcha, rate limiting or a session that was lost.
        final state = await _pageState();
        final message = state != null && state.startsWith('error:')
            ? state.substring(6).trim()
            : '';
        _failFlow(
          message.isNotEmpty
              ? message
              : 'Odoo returned to the login page. Check your username and '
                    'password, then try again.',
        );
        return;

      case _PageKind.totp:
        _watchdog?.cancel();
        if (mounted) setState(() => _loading = false);
        await Future.delayed(const Duration(milliseconds: 600));
        await _focusTotpField();
        return;

      case _PageKind.other:
        // Normally the signed-in web client (/odoo, /web, /my, ...). Whether
        // it is signed in is decided by asking Odoo about the session cookie,
        // not by guessing from the URL.
        if (await _finishIfAuthenticated()) return;
        if (_credentialsInjected) {
          _failFlow(
            'Sign-in did not complete: the server showed an unexpected page. '
            'Please try again.',
          );
        }
        return;
    }
  }

  /// Stops the loading overlay and shows [message] with a way forward.
  void _failFlow(String message, {_RetryMode mode = _RetryMode.restart}) {
    _watchdog?.cancel();
    if (!mounted) return;
    setState(() {
      _loading = false;
      _verifying = false;
      _error = message;
      _retryMode = mode;
    });
  }

  /// Gives the login page [_loadTimeout] to reach the code form. If it has not
  /// by then, either the sign-in already succeeded without a page event (the
  /// signed-in web client can take very long to finish loading) or the server
  /// is not answering.
  void _startWatchdog() {
    _watchdog?.cancel();
    _watchdog = Timer(_loadTimeout, () async {
      if (!mounted || _isSessionExtracted || !_loading) return;
      if (_credentialsInjected && await _finishIfAuthenticated(attempts: 1)) {
        return;
      }
      if (!mounted || _isSessionExtracted || !_loading) return;
      _failFlow(
        'The server is taking too long to respond. Check your connection '
        'and try again.',
      );
    });
  }

  String _describeLoadError(String description) {
    if (description.contains('App Transport Security') ||
        description.contains('secure connection')) {
      return 'iOS blocked the connection because this server uses plain '
          'http://. Use an https:// address, or contact your administrator.';
    }
    return 'Could not load the sign-in page: $description';
  }

  /// Retries whatever failed, without making the user go back and retype.
  Future<void> _retry() async {
    if (_verifying) return;
    final mode = _retryMode;
    setState(() {
      _error = null;
      _retryMode = _RetryMode.none;
    });

    if (mode == _RetryMode.retrySave && sessionId != null) {
      setState(() => _verifying = true);
      await _saveSessionData();
      return;
    }

    final controller = _webController;
    if (controller == null) return;
    setState(() {
      _loading = true;
      _verifying = false;
      _isButtonEnabled = false;
      _totpController.clear();
    });
    _credentialsInjected = false;
    _injecting = false;
    _isSessionExtracted = false;
    _loginSuccess = false;
    sessionId = null;
    _startWatchdog();
    await _loadLoginPage(controller);
  }

  // ── session detection ────────────────────────────────────────────────────

  /// The WebView's `session_id` cookie for the page it is on, if any.
  Future<String?> _readSessionCookie() async {
    try {
      final current = await _webController?.getUrl();
      final cookies = await CookieManager.instance()
          .getCookies(url: current ?? WebUri(widget.serverUrl))
          .timeout(const Duration(seconds: 5));
      for (final cookie in cookies) {
        final value = cookie.value?.toString() ?? '';
        if (cookie.name == 'session_id' && value.isNotEmpty) return value;
      }
    } catch (_) {}
    return null;
  }

  /// Whether [cookie] is a signed-in Odoo session (as opposed to the
  /// half-finished session Odoo hands out while it still waits for the code).
  Future<bool> _isAuthenticated(String cookie) async {
    try {
      final info = await AuthService().getSessionInfo(widget.serverUrl, cookie);
      return info['uid'] is int;
    } catch (_) {
      return false;
    }
  }

  /// If the WebView holds a signed-in session, saves it and carries on.
  /// Returns true when the sign-in has been (or is being) handled.
  Future<bool> _finishIfAuthenticated({int attempts = 4}) async {
    for (var i = 0; i < attempts; i++) {
      if (!mounted) return false;
      if (_isSessionExtracted) return true;
      final cookie = await _readSessionCookie();
      if (cookie != null && await _isAuthenticated(cookie)) {
        sessionId = cookie;
        await _saveSessionData();
        return true;
      }
      // The WebView's cookie store can lag a moment behind the network.
      if (i < attempts - 1) {
        await Future.delayed(const Duration(milliseconds: 500));
      }
    }
    return false;
  }

  /// `'pending'` while the page we submitted is still the current document,
  /// `'error:<text>'` when a new page shows an Odoo error, `'clean'` when it
  /// shows none, and null while the page cannot be read.
  Future<String?> _pageState() async {
    final result = await _js("""
      (function() {
        if (window.__moboPending) return 'pending';
        var el = document.querySelector('.alert-danger, .alert-warning');
        return el ? 'error:' + el.innerText.trim() : 'clean';
      })();
    """);
    return result is String ? result : null;
  }

  // ── page scripts ─────────────────────────────────────────────────────────

  Future<void> _injectCredentials() async {
    if (_credentialsInjected || _injecting) return;
    _injecting = true;

    final safeUser = jsonEncode(widget.username);
    final safePass = jsonEncode(widget.password);
    final safeDb = jsonEncode(widget.database);

    try {
      // The form may not be in the page yet on a slow server, so look a few
      // times. It counts as injected only once it was really submitted.
      for (var attempt = 0; attempt < 6; attempt++) {
        if (!mounted || _isSessionExtracted) return;

        final result = await _js("""
          (function() {
            var login = document.querySelector('input[name="login"], input[type="email"]');
            var password = document.querySelector('input[name="password"]');
            var db = document.querySelector('input[name="db"], select[name="db"]');
            var form = (password && password.closest('form')) || document.querySelector('form[action*="/web/login"]');

            if (!login || !password || !form) return "missing";

            login.value = $safeUser;
            password.value = $safePass;
            if (db) db.value = $safeDb;

            var btn = form.querySelector('button[type="submit"]');
            if (btn) btn.click();
            else if (form.requestSubmit) form.requestSubmit();
            else form.submit();

            return "submitted";
          })();
        """);

        if (result == 'submitted') {
          _credentialsInjected = true;
          return;
        }
        await Future.delayed(const Duration(milliseconds: 500));
      }

      _failFlow(
        "Couldn't find Odoo's sign-in form on this server. Please try again.",
      );
    } finally {
      _injecting = false;
    }
  }

  Future<void> _handleDatabaseSelector() async {
    final safeDb = jsonEncode(widget.database);
    // Wrapped in a function: a bare `const` would throw "already declared"
    // the second time it runs in the same page.
    await _js("""
      (function() {
        var select = document.querySelector('select[name="db"]');
        if (select) {
          select.value = $safeDb;
          var btn = document.querySelector('button[type="submit"]');
          if (btn) btn.click();
        }
      })();
    """);
  }

  Future<void> _focusTotpField() async {
    await _js("""
      (function() {
        var input = document.querySelector('input[name="totp_token"], input[autocomplete="one-time-code"]');
        if (input) {
          input.focus();
          input.select();
        }
      })();
    """);
  }

  Future<void> _submitTotp() async {
    if (_verifying || _webController == null) return;

    final totp = _totpController.text.trim();
    if (!RegExp(r'^\d{6}$').hasMatch(totp)) {
      setState(() => _error = 'Please enter a valid 6-digit code');
      return;
    }

    setState(() {
      _verifying = true;
      _error = null;
      _expiredDatabase = null;
    });

    try {
      final submitted = await _js("""
        (function() {
          // Already sent: never send the same code twice.
          if (window.__moboPending) return "totp_submitted";

          var input = document.querySelector(
            'input[name="totp_token"], input[autocomplete="one-time-code"], input[type="text"][maxlength="6"], input[type="number"][maxlength="6"]'
          );
          if (!input) return "totp_input_not_found";

          var form = input.closest('form') || document.querySelector('form[action*="/web/login"]');
          if (!form) return "form_not_found";

          input.focus();
          input.value = '$totp';
          input.dispatchEvent(new Event('input', {bubbles: true}));
          input.dispatchEvent(new Event('change', {bubbles: true}));

          // Never let Odoo remember this device: otherwise it silently
          // skips the TOTP challenge on every later login from this app.
          var trust = form.querySelector('input[type="checkbox"]');
          if (trust && trust.checked) {
            trust.checked = false;
            trust.dispatchEvent(new Event('change', {bubbles: true}));
          }

          // Drop any error left from a previous attempt, so the next one that
          // shows up is certainly about this code, and mark this document so
          // the page Odoo answers with can be told apart from it.
          document.querySelectorAll('.alert-danger, .alert-warning').forEach(function(el) { el.remove(); });
          window.__moboPending = true;

          var btn = form.querySelector('button[type="submit"], button.btn-primary');
          if (btn) btn.click();
          else if (form.requestSubmit) form.requestSubmit();
          else form.submit();
          return "totp_submitted";
        })();
      """);

      if (submitted == 'totp_input_not_found' ||
          submitted == 'form_not_found') {
        // Nothing was sent, so the code is still unused: start over cleanly.
        _failFlow('The code page is not showing. Please try again.');
        return;
      }

      await _waitForSignIn();
    } catch (_) {
      if (mounted && !_isSessionExtracted) {
        _failFlow('Authentication failed. Please try again.');
      }
    } finally {
      if (mounted && !_loginSuccess) {
        setState(() => _verifying = false);
      }
    }
  }

  /// Waits for Odoo's answer to the submitted code and acts on it.
  ///
  /// Follows the WebView's address and Odoo's own view of the session rather
  /// than waiting for the signed-in web client to finish rendering, which can
  /// take over a minute on a fresh instance (Odoo builds its assets on first
  /// use). Every way out either continues the sign-in or tells the user why it
  /// stopped.
  Future<void> _waitForSignIn() async {
    final deadline = DateTime.now().add(_signInTimeout);
    var lastPending = DateTime.now();

    while (mounted && DateTime.now().isBefore(deadline)) {
      // The page-load handler may already have completed the sign-in.
      if (_isSessionExtracted) return;

      final url = (await _webController?.getUrl())?.toString() ?? '';
      switch (_classify(url)) {
        case _PageKind.login:
          final message = _errorFrom(await _pageState());
          _failFlow(
            message.isNotEmpty
                ? message
                : 'Odoo returned to the login page. Please sign in again.',
          );
          return;

        case _PageKind.totp:
          final state = await _pageState();
          if (state != null && state.startsWith('error:')) {
            // Odoo rejected the code. Its form is back, so the user can retype.
            final message = _errorFrom(state);
            if (mounted) {
              setState(
                () => _error = message.isNotEmpty
                    ? message
                    : 'Invalid code. Please try again.',
              );
            }
            return;
          }
          if (state == 'pending') {
            lastPending = DateTime.now();
          } else if (state == 'clean' &&
              DateTime.now().difference(lastPending) >
                  const Duration(seconds: 12)) {
            // The page has not moved since the submit, so it never went out.
            _failFlow('The code could not be sent. Please try again.');
            return;
          }
          break;

        case _PageKind.databaseSelector:
          break;

        case _PageKind.other:
          if (await _finishIfAuthenticated(attempts: 1)) return;
          break;
      }

      await Future.delayed(const Duration(milliseconds: 700));
    }

    if (mounted && !_isSessionExtracted) {
      _failFlow(
        'Sign-in is taking too long. Check your connection and try again.',
      );
    }
  }

  /// The Odoo error text carried by a [_pageState] result, or ''.
  String _errorFrom(String? state) =>
      state != null && state.startsWith('error:')
      ? state.substring(6).trim()
      : '';

  Future<void> _saveSessionData() async {
    if (_isSessionExtracted) return;
    _isSessionExtracted = true;
    _loginSuccess = true;

    try {
      if (sessionId == null || sessionId!.isEmpty) {
        _isSessionExtracted = false;
        _loginSuccess = false;
        _failFlow('Login failed. Please try again.');
        return;
      }

      // Every step below talks to the server, and a stalled connection would
      // otherwise leave the user on the loading screen with no way forward.
      final success = await CompanySessionManager.loginAndSaveSession(
        serverUrl: widget.serverUrl,
        database: widget.database,
        userLogin: widget.username.trim(),
        password: widget.password.trim(),
        existingSessionId: sessionId,
      ).timeout(_stepTimeout);

      await _saveUrlHistory(
        protocol: widget.protocol,
        url: widget.serverUrl,
        database: widget.database,
        username: widget.username.trim(),
      );

      if (!success) {
        _isSessionExtracted = false;
        _loginSuccess = false;
        // The code was accepted and the session exists, so retrying only needs
        // to repeat the save — not ask for another code.
        _failFlow(
          'Could not finish signing in. Please try again.',
          mode: _RetryMode.retrySave,
        );
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
      final isPortal = await ErrorHandler().isPortalUser().timeout(
        _stepTimeout,
      );
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
        moduleBlock = await checker.requiredModulesBlock().timeout(
          _stepTimeout,
        );
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
      await clientManager.initializeOdooClient(context).timeout(_stepTimeout);
      await clientManager
          .initializeOdooClientWithUrl(widget.serverUrl)
          .timeout(_stepTimeout);
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
        _watchdog?.cancel();
        if (mounted) {
          setState(() {
            _expiredDatabase = e;
            _loading = false;
            _verifying = false;
          });
        }
        return;
      }
      // Whatever went wrong, the loading overlay must come down and the user
      // must get a way forward: the code was already accepted, so only the
      // save is retried.
      _failFlow(_describeSessionError(e), mode: _RetryMode.retrySave);
    }
  }

  /// A message the user can act on for a failure after the code was accepted.
  String _describeSessionError(Object error) {
    if (error is TimeoutException) {
      return 'The server took too long to respond. Check your connection '
          'and try again.';
    }
    if (error is NoInternetException) return error.message;
    if (error is ServerUnreachableException) return error.message;
    return 'Session error. Please try again.';
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
