import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../bottom_nav_screen.dart';
import '../../core/company/session/company_session_manager.dart';
import '../../core/security/secure_storage_service.dart';
import '../../global_methods/services/isar_caching_service.dart';
import '../../initilisation.dart';
import '../../services/app_install_check.dart';
import '../../services/storage_service.dart';
import '../../utils/globals.dart';
import '../customers/provider/customer_data_provider.dart';
import '../discuss/providers/discuss_provider.dart';
import '../lead/providers/lead_data_provider.dart';
import '../opportunity/providers/opportunity_data_provider.dart';

/// Handles Two-Factor Authentication (TOTP) without a WebView.
///
/// Uses direct HTTP form submissions to the Odoo server:
/// 1. POST credentials → `/web/login` → get session cookie.
/// 2. User enters 6-digit code; POST → `/web/login/totp` → finalize session.
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
  final _totpController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  String? _error;
  bool _loading = true;
  bool _verifying = false;
  bool _isButtonEnabled = false;

  /// Session cookie received after POSTing credentials.
  String? _sessionCookie;

  /// CSRF token extracted from the /web/login/totp page HTML.
  String? _csrfToken;

  /// Final session ID after successful TOTP verification.
  String? sessionId;

  final StorageService _storageService = StorageService();

  /// Returns an [HttpClient] that accepts self-signed certificates.
  HttpClient _makeHttpClient() =>
      HttpClient()..badCertificateCallback = (_, __, ___) => true;

  /// URL-encodes a map into `key=value&key2=value2` form data.
  String _encodeForm(Map<String, String> params) => params.entries
      .map((e) =>
          '${Uri.encodeQueryComponent(e.key)}=${Uri.encodeQueryComponent(e.value)}')
      .join('&');

  /// Reads the full body from an [HttpClientResponse].
  Future<String> _readBody(HttpClientResponse response) async {
    final bytes = <int>[];
    await for (final chunk in response) {
      bytes.addAll(chunk);
    }
    return utf8.decode(bytes, allowMalformed: true);
  }

  @override
  void initState() {
    super.initState();
    _initiateLogin();
  }

  /// Step 1 – POST credentials to `/web/login`.
  ///
  /// Odoo responds with a redirect to `/web/login/totp` when 2FA is needed.
  /// We capture the `session_id` cookie from that response.
  Future<void> _initiateLogin() async {
    final client = _makeHttpClient();
    try {
      final uri = Uri.parse('${widget.serverUrl}/web/login');
      final req = await client.postUrl(uri);
      req.followRedirects = false;
      req.headers.contentType =
          ContentType('application', 'x-www-form-urlencoded');
      req.headers.set('User-Agent',
          'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36');

      final body = _encodeForm({
        'login': widget.username,
        'password': widget.password,
        'db': widget.database,
        'redirect': '/web',
      });
      req.contentLength = utf8.encode(body).length;
      req.write(body);

      final res = await req.close();
      await res.drain<void>();

      String? sid;
      for (final cookie in res.cookies) {
        if (cookie.name == 'session_id' && cookie.value.isNotEmpty) {
          sid = cookie.value;
          break;
        }
      }

      final location = res.headers.value('location') ?? '';
      final isTotpRedirect =
          location.contains('/web/login/totp') || location.contains('totp');

      if (!isTotpRedirect || sid == null) {
        if (mounted) {
          setState(() {
            _error = 'Login failed. Please check your credentials.';
            _loading = false;
          });
        }
        return;
      }

      _sessionCookie = sid;

      await _extractCsrfToken(client, sid);

      if (mounted) setState(() => _loading = false);
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = 'Connection error. Please try again.';
          _loading = false;
        });
      }
    } finally {
      client.close();
    }
  }

  /// Step 2 – GET `/web/login/totp` and parse the CSRF token from the form.
  Future<void> _extractCsrfToken(HttpClient client, String sid) async {
    try {
      final uri = Uri.parse('${widget.serverUrl}/web/login/totp');
      final req = await client.getUrl(uri);
      req.headers.set('Cookie', 'session_id=$sid');
      req.headers.set('User-Agent',
          'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36');

      final res = await req.close();
      final html = await _readBody(res);

      final patterns = [
        RegExp(r'name="csrf_token"\s+value="([^"]+)"'),
        RegExp(r'value="([^"]+)"\s+name="csrf_token"'),
        RegExp(r"'csrf_token'\s*:\s*'([^']+)'"),
        RegExp(r'"csrf_token"\s*:\s*"([^"]+)"'),
      ];
      for (final p in patterns) {
        final m = p.firstMatch(html);
        if (m != null) {
          _csrfToken = m.group(1);
          break;
        }
      }
    } catch (_) {
    }
  }

  /// Step 3 – POST the 6-digit code to `/web/login/totp`.
  Future<void> _submitTotp() async {
    if (_verifying) return;

    setState(() {
      _verifying = true;
      _error = null;
    });

    final totp = _totpController.text.trim();
    if (totp.length != 6 || !RegExp(r'^\d{6}$').hasMatch(totp)) {
      setState(() {
        _error = 'Please enter a valid 6-digit code';
        _verifying = false;
      });
      return;
    }

    if (_sessionCookie == null) {
      setState(() {
        _error = 'Session expired. Please go back and try again.';
        _verifying = false;
      });
      return;
    }

    final client = _makeHttpClient();
    try {
      final uri = Uri.parse('${widget.serverUrl}/web/login/totp');
      final req = await client.postUrl(uri);
      req.followRedirects = false;
      req.headers.contentType =
          ContentType('application', 'x-www-form-urlencoded');
      req.headers.set('Cookie', 'session_id=$_sessionCookie');
      req.headers.set('User-Agent',
          'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36');

      final params = <String, String>{
        'totp_token': totp,
        'redirect': '/web',
      };
      if (_csrfToken != null) params['csrf_token'] = _csrfToken!;

      final body = _encodeForm(params);
      req.contentLength = utf8.encode(body).length;
      req.write(body);

      final res = await req.close();
      await res.drain<void>();

      final location = res.headers.value('location') ?? '';

      String newSession = _sessionCookie!;
      for (final cookie in res.cookies) {
        if (cookie.name == 'session_id' && cookie.value.isNotEmpty) {
          newSession = cookie.value;
          break;
        }
      }

      final success = res.statusCode == 302 &&
          location.isNotEmpty &&
          !location.contains('/login') &&
          !location.contains('/totp');

      if (success) {
        sessionId = newSession;
        await _saveSessionData();
      } else {
        setState(() =>
            _error = 'Invalid code or login failed. Please try again.');
      }
    } catch (e) {
      setState(() => _error = 'Authentication failed. Please try again.');
    } finally {
      client.close();
      if (mounted) setState(() => _verifying = false);
    }
  }

  Future<void> _saveSessionData() async {
    try {
      if (sessionId == null || sessionId!.isEmpty) {
        setState(() => _error = 'Login failed. Please try again.');
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

      if (!success) return;

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
          'loginTimestamp', DateTime.now().millisecondsSinceEpoch);

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

      final checker = AppInstallCheck();
      final isInstalled = await checker.checkRequiredModules();

      if (!isInstalled) {
        List<String> urlHistory = prefs.getStringList('urlHistory') ?? [];
        bool isGetStarted = prefs.getBool('hasSeenGetStarted') ?? false;
        await prefs.clear();
        await prefs.setStringList('urlHistory', urlHistory);
        await prefs.setBool('hasSeenGetStarted', isGetStarted);

        if (mounted) {
          Navigator.pushNamedAndRemoveUntil(
              context, '/server_setup', (route) => false);
          showModuleMissingDialog(context);
        }
        return;
      }

      final clientManager =
          Provider.of<OdooClientManager>(context, listen: false);
      await clientManager.initializeOdooClient(context);
      await clientManager.initializeOdooClientWithUrl(widget.serverUrl);
      await IsarService.clearAllData();

      if (mounted) {
        try {
          Provider.of<OpportunityDataProvider>(context, listen: false)
              .clearAll();
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

        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (_) => const HomeScreen(loadInit: true)),
          (route) => false,
        );
      }
    } catch (e) {
      setState(() => _error = 'Session error. Please try again.');
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

  void showModuleMissingDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
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
              fontSize: 15, color: Colors.black87, height: 1.5),
        ),
        actions: [
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppStyle.primaryColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14)),
                padding:
                    const EdgeInsets.symmetric(vertical: 14),
                elevation: 0,
              ),
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Back to Login',
                  style: GoogleFonts.manrope(
                      fontWeight: FontWeight.bold, fontSize: 15)),
            ),
          ),
        ],
      ),
    );
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
        Icon(HugeIcons.strokeRoundedTwoFactorAccess,
            color: Colors.white, size: 48),
        const SizedBox(height: 24),
        Text(
          'Two-factor Authentication',
          style: GoogleFonts.montserrat(
              fontWeight: FontWeight.w600, color: Colors.white, fontSize: 25),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),
        Text(
          'To login, enter below the six-digit authentication code provided by your Authenticator app.',
          style: GoogleFonts.montserrat(
              fontSize: 14, color: Colors.white70, height: 1.4),
          textAlign: TextAlign.center,
        ),
        if (widget.serverUrl.isNotEmpty) ...[
          const SizedBox(height: 16),
          Text(
            'Server: ${widget.serverUrl}',
            style: GoogleFonts.manrope(
                fontSize: 12,
                color: Colors.white60,
                fontWeight: FontWeight.w500),
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
                color: Colors.black),
            decoration: InputDecoration(
              hintText: 'Enter TOTP Code',
              hintStyle: GoogleFonts.manrope(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Colors.black.withValues(alpha: .4)),
              prefixIcon:
                  const Icon(HugeIcons.strokeRoundedSmsCode, size: 20),
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
                  horizontal: 20, vertical: 16),
              errorStyle: const TextStyle(color: Colors.white),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide:
                    BorderSide(color: Colors.red[900]!, width: 1.0),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide:
                    const BorderSide(color: Colors.white, width: 1.5),
              ),
            ),
          ),
          const SizedBox(height: 10),
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            height: _error != null ? 48 : 0,
            child: _error != null
                ? Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(HugeIcons.strokeRoundedAlertCircle,
                            color: Colors.white, size: 18),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            _error!,
                            style: GoogleFonts.manrope(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w400),
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
              onPressed:
                  (_verifying || !_isButtonEnabled) ? null : _submitTotp,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
                disabledForegroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              child: _verifying
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Authenticating',
                            style: GoogleFonts.manrope(
                                fontSize: 14,
                                fontWeight: FontWeight.w600)),
                        const SizedBox(width: 12),
                        LoadingAnimationWidget.staggeredDotsWave(
                            color: Colors.white, size: 28),
                      ],
                    )
                  : Text('Authenticate',
                      style: GoogleFonts.manrope(
                          fontSize: 14, fontWeight: FontWeight.w600)),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _totpController.dispose();
    super.dispose();
  }
}
