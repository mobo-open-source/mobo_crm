import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:mobo_crm/screens/others/profile_screen.dart';
import 'package:mobo_crm/utils/snackbar.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:mobo_crm/global_methods/services/mobile_field_compatibility_service.dart';
import '../../bottom_nav_screen.dart';
import '../../core/company/providers/company_provider.dart';
import '../../core/company/session/company_session_manager.dart';
import '../../core/security/secure_storage_service.dart';
import '../../models/LoginPage/session_model.dart';
import '../../services/auth_service.dart';
import '../../services/storage_service.dart';
import '../../utils/app_theme.dart';
import '../settings/screens/profile/SwitchAccount/server_url_screen.dart';
import '../settings/screens/profile/logout_dialog.dart';
import '../settings/settings_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mobo_crm/initilisation.dart';
import 'package:mobo_crm/screens/discuss/chat/discuss.dart';
import 'package:mobo_crm/screens/discuss/providers/discuss_provider.dart';
import 'package:mobo_crm/screens/myActivities/mail/mail_activity_screen.dart';
import 'package:mobo_crm/global_methods/widgets/transition/page_transition.dart';
import 'package:mobo_crm/global_methods/services/isar_caching_service.dart';
import 'package:mobo_crm/screens/opportunity/providers/opportunity_data_provider.dart';
import 'package:mobo_crm/screens/lead/providers/lead_data_provider.dart';
import 'package:mobo_crm/screens/customers/provider/customer_data_provider.dart';

/// A screen for managing user configuration and settings, including:
/// - Viewing current user profile
/// - Navigating to app settings
/// - Accessing chat and mail activities
/// - Switching between stored accounts
/// - Logging out
class ConfigurationScreen extends StatefulWidget {
  /// Creates an instance of [ConfigurationScreen].
  const ConfigurationScreen({super.key});

  @override
  State<ConfigurationScreen> createState() => _ConfigurationScreenState();
}

class _ConfigurationScreenState extends State<ConfigurationScreen> {
  Map<String, dynamic>? _userData;
  Uint8List? _userAvatar;
  bool _isLoading = true;
  bool isAccountLoading = false;
  String? _switchingAccountKey;
  late StorageService storageService;
  String? currentUrl;
  String? currentDatabase;
  int? currentUserId;

  @override
  void initState() {
    super.initState();
    storageService = StorageService();
    // Identity first: the switch list hides the signed-in account by it, and
    // matching against a half-loaded identity would list the account you are
    // already in.
    _loadCurrentAccount().then((_) => _loadUserData());
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadCurrentAccount();
  }

  /// Loads the current user data from SharedPreferences and attempts to
  /// fetch the latest user data from Odoo using [MobileFieldCompatibilityService].
  Future<void> _loadUserData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userName = prefs.getString('userName') ?? 'User';
      final userEmail = prefs.getString('userEmail') ?? 'user@company.com';
      final userId = prefs.getInt('userId') ?? 0;

      setState(() {
        _userData = {
          'id': userId,
          'name': userName,
          'email': userEmail,
          'phone': '',
          'mobile': '',
          'function': '',
        };
        _isLoading = false;
      });

      try {
        final prefs = await SharedPreferences.getInstance();
        final uid = prefs.getInt('userId') ?? 0;

        final result = await MobileFieldCompatibilityService.safeRead(
          'res.users',
          uid,
          [
            'name',
            'login',
            'email',
            'phone',
            'mobile',
            'website',
            'function',
            'street',
            'street2',
            'city',
            'zip',
            'country_id',
            'state_id',
            'image_1920',
            'partner_id',
            'company_id',
            'write_date'
          ],
        );

        if (result != null && result.isNotEmpty) {
          final userData = result[0];
          if (userData['image_1920'] != null &&
              userData['image_1920'] != false) {
            try {
              final imageString = userData['image_1920'].toString();
              if (imageString.isNotEmpty &&
                  imageString != 'false' &&
                  imageString != 'null') {
                final imageData = base64Decode(imageString);
                if (imageData.isNotEmpty) {
                  _userAvatar = imageData;
                } else {
                  _userAvatar = null;
                }
              } else {
                _userAvatar = null;
              }
            } catch (e) {
              _userAvatar = null;
            }
          } else {
            _userAvatar = null;
          }

          setState(() {
            _userData = {
              'id': userData['id'] ?? userId,
              'name': userData['name'] ?? userName,
              'email': userData['email'] ?? userEmail,
              'phone': userData['phone'] ?? '',
              'mobile': userData['mobile'] ?? userData['phone'] ?? '',
              'function': userData['function'] ?? '',
              'website': userData['website'] ?? '',
              'street': userData['street'] ?? '',
              'street2': userData['street2'] ?? '',
              'city': userData['city'] ?? '',
              'zip': userData['zip'] ?? '',
              'country_id': userData['country_id'],
              'state_id': userData['state_id'],
              'image_1920': userData['image_1920'],
              'partner_id': userData['partner_id'],
              'company_id': userData['company_id'],
            };
          });

          await _loadCurrentAccount();
        }
      } catch (_) {}
    } catch (e) {
      setState(() {
        _userData = {
          'id': 0,
          'name': 'User',
          'email': 'user@company.com',
          'phone': '',
          'mobile': '',
          'function': '',
        };
        _userAvatar = null;
        _isLoading = false;
      });
    }
  }

  /// Loads the identity of the signed-in account and makes sure it has an
  /// up-to-date row in the store the switch list is built from.
  Future<void> _loadCurrentAccount() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      currentUrl = prefs.getString('url') ?? '';
      currentDatabase = prefs.getString('selectedDatabase') ?? '';
      currentUserId = prefs.getInt('userId');

      await _registerCurrentAccount();

      if (mounted) setState(() {});
    } catch (_) {}
  }

  /// Writes the signed-in account into [StorageService]'s account store.
  ///
  /// This screen used to keep its own `stored_accounts` list instead, which
  /// nothing ever reads back — the switch list is built from
  /// `StorageService.getAccounts()`. Two things followed from that: an account
  /// whose sign-in path never called `saveAccount` stayed invisible here, and
  /// a profile renamed or re-photographed afterwards kept whatever name and
  /// picture were captured at login.
  Future<void> _registerCurrentAccount() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getInt('userId') ?? 0;
      final url = prefs.getString('url') ?? '';
      final database = prefs.getString('selectedDatabase') ?? '';
      if (userId == 0 || url.isEmpty) return;

      final accounts = await storageService.getAccounts();
      final existing = accounts.firstWhere(
        (account) =>
            _asInt(account['userId']) == userId &&
            (account['url'] ?? '') == url &&
            (account['database'] ?? '') == database,
        orElse: () => <String, dynamic>{},
      );

      final name = (_userData?['name'] ?? prefs.getString('userName') ?? '')
          .toString()
          .trim();
      final image = _currentAvatarBase64() ?? (existing['image'] ?? '');

      final row = <String, dynamic>{
        ...existing,
        'userId': userId,
        // saveAccount de-duplicates on userLogin + url + database, so the key
        // it was first stored under has to survive.
        'userLogin': existing['userLogin'] ?? prefs.getString('userLogin') ?? '',
        'userName': name.isNotEmpty ? name : existing['userName'],
        'url': url,
        'database': database,
        'sessionId': prefs.getString('sessionId') ?? existing['sessionId'],
        'serverVersion':
            prefs.getString('serverVersion') ?? existing['serverVersion'],
        'userLang': prefs.getString('userLang') ?? existing['userLang'],
        'partnerId': prefs.getInt('partnerId') ?? existing['partnerId'],
        'userTimezone':
            prefs.getString('userTimezone') ?? existing['userTimezone'],
        'companyId': prefs.getInt('companyId') ?? existing['companyId'],
        'companyName':
            prefs.getString('company_name') ?? existing['companyName'],
        'isSystem': prefs.getBool('isSystem') ?? existing['isSystem'] ?? false,
        'image': image,
      };

      // This runs on every visit and on every dependency change, so an
      // unchanged row is left alone rather than rewritten.
      final unchanged = existing.isNotEmpty &&
          existing['userName'] == row['userName'] &&
          existing['image'] == row['image'] &&
          existing['sessionId'] == row['sessionId'];
      if (unchanged) return;

      await storageService.saveAccount(row);
    } catch (_) {}
  }

  /// The signed-in user's photo as base64, or null when there is none to
  /// store (the row then keeps whatever it already had).
  String? _currentAvatarBase64() {
    final raw = _userData?['image_1920'];
    if (raw is String && raw.isNotEmpty && raw != 'false' && raw != 'null') {
      return raw;
    }
    if (_userAvatar != null && _userAvatar!.isNotEmpty) {
      try {
        return base64Encode(_userAvatar!);
      } catch (_) {}
    }
    return null;
  }

  /// Ids come back as int from a fresh write and can be a String from an
  /// older one, so both are accepted.
  int? _asInt(dynamic value) =>
      value is int ? value : int.tryParse('${value ?? ''}');

  /// Returns a unique key identifying a stored account row, used to track
  /// which row's "Switch" action is currently in progress.
  String _accountKey(Map<String, dynamic> user) =>
      '${user['userId']}_${user['url']}_${user['database']}';

  /// Switches the app to another stored user account.
  ///
  /// Updates session and login state in storage, clears cached data,
  /// reinitializes providers, and navigates to the home screen.
  ///
  /// Displays a snackbar on success or failure.
  /// [user] is a map containing the stored account details to switch to.
  Future<void> _switchToAccount(Map<String, dynamic> user) async {
    if (isAccountLoading) return;
    setState(() {
      isAccountLoading = true;
      _switchingAccountKey = _accountKey(user);
    });
    try {
      final clientManager =
          Provider.of<OdooClientManager>(context, listen: false);

      await storageService.saveSession(SessionModel(
        sessionId: user['sessionId'],
        userName: user['userName'],
        userLogin: user['userLogin'],
        userId: user['userId'],
        serverVersion: user['serverVersion'],
        userLang: user['userLang'],
        partnerId: user['partnerId'],
        userTimezone: user['userTimezone'],
        companyId: user['companyId'],
        companyName: user['companyName'],
        isSystem: user['isSystem'] ?? false,
        // The stored row carries only the full version string; without this
        // saveSession writes 0, and every `version >= 18` branch then takes
        // the pre-18 path on a 19 server.
        version: AuthService()
            .parseMajorVersion(user['serverVersion']?.toString() ?? ''),
      ));

      await storageService.saveLoginState(
        isLoggedIn: true,
        database: user['database'],
        url: user['url'],
      );

      // saveLoginState only writes `selectedDatabase`. The client, the
      // session refresh and the saved-password lookup all read `database`, so
      // it kept naming the account being left: once the stored session id
      // went stale (Odoo 19 rotates it every few hours) the re-login ran
      // against the wrong database and the new account could load nothing.
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('database', user['database']?.toString() ?? '');

      // The previous account's company selection is read back as this
      // account's `allowed_company_ids` by every call until
      // CompanyProvider.initialize() replaces it; Odoo refuses a context that
      // names companies the user can't access.
      await prefs.remove('selected_company_id');
      await prefs.remove('selected_allowed_company_ids');
      await prefs.remove('pending_company_id');

      // Point the client at the new account before loading anything.
      // CompanySessionManager.getCurrentSession() serves an in-memory cached
      // session, and initializeOdooClient() below fetches the whole dataset —
      // profile, company, leads, tags, teams, products. Run in the old order
      // it fetched all of that over the session of the account being left, and
      // only afterwards dropped the cache. initializeOdooClientWithUrl clears
      // it first, so it has to come first.
      await clientManager.initializeOdooClientWithUrl(user['url']);
      await clientManager.initializeOdooClient(context);

      // Resolve the new account's company_id/allowed_company_ids from the
      // server and persist them before anything fetches data — otherwise
      // the first request after switching still carries the previous
      // account's stale allowed-company context.
      if (mounted) {
        try {
          await Provider.of<CompanyProvider>(context, listen: false)
              .initialize();
        } catch (_) {}
      }

      if (mounted) {
        try {
          final opportunityProvider =
              Provider.of<OpportunityDataProvider>(context, listen: false);
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

      if (mounted) {
        setState(() {
          isAccountLoading = false;
          _switchingAccountKey = null;
        });

        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => const HomeScreen(loadInit: true),
          ),
          (route) => false,
        );

        // Rows in this store carry `userName`; `name` is never set on them,
        // so the message used to read "Switched to null".
        CustomSnackbar.showSuccess(
            context, 'Switched to ${user['userName'] ?? 'account'}');
      }
    } catch (e) {
      setState(() {
        isAccountLoading = false;
        _switchingAccountKey = null;
      });
      if (mounted) {
        String errorMessage;
        SnackBarAction? action;

        if (e.toString().contains('AccessDenied') ||
            e.toString().contains('Access Denied')) {
          errorMessage =
              'Invalid credentials for ${user['userName'] ?? 'this account'}. Please add the account again with correct password.';
          action = SnackBarAction(
            label: 'Add Account',
            textColor: Colors.white,
            onPressed: () async {
              final prefs = await SharedPreferences.getInstance();
              final url = prefs.getString('url') ?? '';
              final database = prefs.getString('selectedDatabase') ?? '';
              final session = await CompanySessionManager.getCurrentSession();
              Navigator.push(
                context,
                SlidingPageTransitionRL(
                  page: ServerUrlScreen(
                    serverUrl: url,
                    database: database,
                    session: session!,
                  ),
                ),
              );
            },
          );
        } else {
          errorMessage = 'Failed to switch account: ${e.toString()}';
        }

        CustomSnackbar.showError(context, errorMessage);
      }
    }
  }

  /// Removes a stored account after confirmation, deleting it from
  /// [StorageService] and clearing its saved password from secure storage.
  Future<void> _removeStoredAccount(Map<String, dynamic> user) async {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.lg)),
        elevation: 0,
        backgroundColor: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        title: Text(
          'Remove Account',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : AppTheme.dark,
          ),
        ),
        content: Text(
          'Are you sure you want to remove ${user['userName'] ?? 'this account'} from your saved accounts?',
          style: TextStyle(
            fontSize: 14,
            color: isDark ? Colors.grey[400] : Colors.grey[600],
          ),
        ),
        actionsPadding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
        actions: [
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 48,
                  child: OutlinedButton(
                    onPressed: () => Navigator.of(ctx).pop(false),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppTheme.primaryColor,
                      side: const BorderSide(
                          color: AppTheme.primaryColor, width: 1.5),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppRadius.md)),
                    ),
                    child: const Text('Cancel',
                        style: TextStyle(fontWeight: FontWeight.w600)),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: SizedBox(
                  height: 48,
                  child: ElevatedButton(
                    onPressed: () => Navigator.of(ctx).pop(true),
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      shadowColor: Colors.transparent,
                      backgroundColor: StatusColors.statusRed,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppRadius.md)),
                    ),
                    child: const Text('Remove',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    try {
      await storageService.removeAccount(
        userLogin: user['userLogin'] ?? '',
        userName: user['userName'] ?? '',
        userId: user['userId'] ?? 0,
        url: user['url'] ?? '',
        database: user['database'] ?? '',
      );

      await SecureStorageService().deletePassword(
        url: user['url'] ?? '',
        database: user['database'] ?? '',
        username: user['userLogin'] ?? '',
      );

      if (!mounted) return;
      setState(() {});
      CustomSnackbar.showSuccess(
          context, 'Account ${user['userName'] ?? ''} removed');
    } catch (_) {
      if (!mounted) return;
      CustomSnackbar.showError(context, 'Failed to remove account');
    }
  }

  bool isSvgBytes(Uint8List bytes) {
    final str = utf8.decode(bytes, allowMalformed: true);
    return str.contains('<svg');
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final background = isDark ? Colors.grey[900] : Colors.white;

    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        backgroundColor: background,
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: Icon(
            HugeIcons.strokeRoundedArrowLeft01,
            color: isDark ? Colors.white : Colors.black,
          ),
        ),
        title: Text(
          'Configuration',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : Colors.black,
            fontSize: _scaled(context, 22),
          ),
        ),
      ),
      body: _isLoading
          ? _buildLoadingShimmer(isDark)
          : RefreshIndicator(
              color: AppTheme.primaryColor,
              onRefresh: _loadUserData,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 12),
                    _buildProfileHeaderCard(isDark),
                    const SizedBox(height: 12),
                    _buildQuickActionsSection(isDark),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
    );
  }

  /// [size] scaled to the screen width against a 390px baseline, within
  /// 85–120%, so the header text fits small phones and fills large ones.
  double _scaled(BuildContext context, double size) {
    final scale = (MediaQuery.of(context).size.width / 390.0).clamp(0.85, 1.2);
    return size * scale;
  }

  /// The signed-in user's banner; tapping it opens the profile.
  Widget _buildProfileHeaderCard(bool isDark) {
    final name = (_userData?['name'] ?? '').toString().trim();
    final email = _userData?['email'];
    final emailText = email is String ? email.trim() : '';

    return GestureDetector(
      onTap: () async {
        await Navigator.push(context,
            MaterialPageRoute(builder: (context) => const ProfileScreen()));
        _loadUserData();
      },
      child: Container(
        margin: const EdgeInsets.all(20),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppTheme.primaryColor,
          borderRadius: BorderRadius.circular(AppRadius.md),
          boxShadow: AppShadows.card,
        ),
        child: Row(
          children: [
            SizedBox(
              width: 90,
              height: 90,
              child: Center(
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.grey[200]!, width: 2),
                  ),
                  child: ClipOval(
                    child: SizedBox(
                      width: 82,
                      height: 82,
                      child: _userAvatar != null
                          ? Image.memory(
                              _userAvatar!,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  _profileAvatarPlaceholder(isDark),
                            )
                          : _profileAvatarPlaceholder(isDark),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 18),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name.isNotEmpty ? name : 'Unknown User',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: _scaled(context, 18),
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.5,
                      height: 1.2,
                    ),
                  ),
                  if (emailText.isNotEmpty) ...[
                    const SizedBox(height: 2),
                    Text(
                      emailText,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: _scaled(context, 14),
                        fontWeight: FontWeight.w400,
                        letterSpacing: 0.7,
                        height: 1.2,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(left: 8),
              child: Icon(
                HugeIcons.strokeRoundedArrowRight01,
                color: Colors.white,
                size: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _profileAvatarPlaceholder(bool isDark) => Container(
        color: isDark ? Colors.grey[700] : Colors.grey[300],
        child: Icon(
          HugeIcons.strokeRoundedUser,
          size: 36,
          color: isDark ? Colors.grey[500] : Colors.grey[600],
        ),
      );

  /// The menu card: Settings, Chat, Mail Activities, Switch Accounts and
  /// Logout, separated by hairlines.
  Widget _buildQuickActionsSection(bool isDark) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[850] : Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(
          color: isDark ? Colors.grey[850]! : Colors.grey[200]!,
          width: 0.5,
        ),
        boxShadow: AppShadows.card,
      ),
      child: Material(
        color: Colors.transparent,
        child: Column(
          children: [
            _buildActionTile(
              isDark,
              title: 'Settings',
              subtitle: 'App preferences and sync options',
              icon: HugeIcons.strokeRoundedSettings01,
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => SettingsScreen()));
              },
            ),
            _menuDivider(isDark),
            _buildActionTile(
              isDark,
              title: 'Chat',
              subtitle: 'Messages and discussions',
              icon: HugeIcons.strokeRoundedMessage01,
              onTap: () {
                Provider.of<DiscussProvider>(context, listen: false)
                    .clearAll();
                Navigator.push(
                  context,
                  SlidingPageTransitionRL(page: Discuss()),
                );
              },
            ),
            _menuDivider(isDark),
            _buildActionTile(
              isDark,
              title: 'Mail Activities',
              subtitle: 'Email activities and notifications',
              icon: HugeIcons.strokeRoundedMail01,
              onTap: () {
                Navigator.push(
                  context,
                  SlidingPageTransitionRL(page: MailDataScreen()),
                );
              },
            ),
            _menuDivider(isDark),
            _buildSwitchAccounts(isDark),
            _menuDivider(isDark),
            _buildActionTile(
              isDark,
              title: 'Logout',
              subtitle: 'Sign out from this device',
              icon: HugeIcons.strokeRoundedLogout01,
              trailing: const SizedBox.shrink(),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) => LogoutDialog(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  /// A menu row: grey icon, title over subtitle, and a chevron unless
  /// [trailing] replaces it.
  Widget _buildActionTile(
    bool isDark, {
    required String title,
    required String subtitle,
    required IconData icon,
    required VoidCallback onTap,
    Widget? trailing,
  }) {
    return ListTile(
      leading: Icon(icon, color: isDark ? Colors.grey[400] : Colors.grey[600]),
      title: Text(
        title,
        style: TextStyle(
          color: isDark ? Colors.white : Colors.black87,
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          fontSize: 13,
          color: isDark ? Colors.grey[400] : Colors.grey[600],
        ),
      ),
      trailing: trailing ?? const Icon(Icons.chevron_right_rounded),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
    );
  }

  Widget _menuDivider(bool isDark) => Divider(
        height: 1,
        color: isDark ? Colors.grey[800] : Colors.grey[200],
      );

  /// "Switch Accounts" row, expanding to the other stored accounts and the
  /// Add Account button.
  Widget _buildSwitchAccounts(bool isDark) {
    final secondary = isDark ? Colors.grey[400]! : Colors.grey[600]!;

    return FutureBuilder<List<Map<String, dynamic>>>(
      future: storageService.getAccounts(),
      builder: (context, snapshot) {
        final accounts = snapshot.data ?? [];
        final otherAccounts = accounts.where((user) {
          // The signed-in row is recognised by the same id + url + database
          // tuple the store is keyed on. Matching on the display name broke
          // as soon as the profile was renamed: the stored row kept the old
          // name, stopped matching, and the account already in use turned up
          // here as one more to switch to.
          final isSameAccount = _asInt(user['userId']) == currentUserId &&
              (user['url'] ?? '') == currentUrl &&
              (user['database'] ?? '') == currentDatabase;
          final userName = (user['userName'] ?? '').toString();
          return !isSameAccount && userName.isNotEmpty;
        }).toList();
        final accountCount = otherAccounts.length;

        return ExpansionTile(
          // Without these, an expanded ExpansionTile draws divider-coloured
          // lines above and below itself.
          shape: const Border(),
          collapsedShape: const Border(),
          iconColor: AppTheme.primaryColor,
          collapsedIconColor: isDark ? Colors.grey[400] : Colors.grey[600],
          leading: Icon(HugeIcons.strokeRoundedUserSwitch, color: secondary),
          title: Text(
            'Switch Accounts',
            style: TextStyle(
              color: isDark ? Colors.white : Colors.black87,
              fontWeight: FontWeight.w500,
            ),
          ),
          subtitle: Text(
            accountCount > 0
                ? '$accountCount other account${accountCount != 1 ? 's' : ''} available'
                : 'Add multiple accounts to switch quickly',
            style: TextStyle(color: secondary),
          ),
          children: [
            if (otherAccounts.isEmpty)
              _buildNoOtherAccounts(isDark)
            else
              ...otherAccounts.map((user) => _buildAccountTile(isDark, user)),
            _buildAddAccountButton(),
          ],
        );
      },
    );
  }

  Widget _buildNoOtherAccounts(bool isDark) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: AppTheme.primaryColor.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              HugeIcons.strokeRoundedUserAdd01,
              size: 30,
              color: AppTheme.primaryColor,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'No Other Accounts',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: isDark ? Colors.white : Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Add multiple accounts to switch between them quickly',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: isDark ? Colors.grey[400] : Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  /// A stored account: avatar, name over database and a Remove menu.
  /// Tapping the row switches to it; while it switches, a spinner takes the
  /// menu's place and the other rows are dimmed.
  Widget _buildAccountTile(bool isDark, Map<String, dynamic> user) {
    final isSwitchingThis = _switchingAccountKey == _accountKey(user);
    final isRowDisabled = isAccountLoading;

    return Opacity(
      opacity: isRowDisabled && !isSwitchingThis ? 0.5 : 1,
      child: IgnorePointer(
        ignoring: isRowDisabled,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppRadius.md),
            color: isDark ? Colors.grey[800] : Colors.grey[50],
            border: Border.all(
              color: isDark ? Colors.grey[700]! : Colors.grey[200]!,
            ),
          ),
          child: Material(
            color: Colors.transparent,
            child: ListTile(
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              leading: _buildAccountAvatar(isDark, user),
              title: Text(
                user['userName'] ?? 'Unknown User',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: isDark ? Colors.white : Colors.black87,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  user['database'] ?? 'Unknown Database',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: isDark ? Colors.grey[400] : Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
              ),
              trailing: isSwitchingThis
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: AppTheme.primaryColor,
                      ),
                    )
                  : PopupMenuButton<String>(
                      position: PopupMenuPosition.under,
                      icon: Icon(
                        Icons.more_vert,
                        color: isDark ? Colors.white : Colors.black,
                        size: 20,
                      ),
                      onSelected: (value) async {
                        if (value == 'remove') {
                          await _removeStoredAccount(user);
                        }
                      },
                      itemBuilder: (context) => [
                        PopupMenuItem<String>(
                          value: 'remove',
                          child: Text(
                            'Remove',
                            style: TextStyle(
                              color: isDark ? Colors.white : Colors.black87,
                            ),
                          ),
                        ),
                      ],
                    ),
              onTap: () => _switchToAccount(user),
            ),
          ),
        ),
      ),
    );
  }

  /// The account's stored photo in a 40px bordered circle, falling back to
  /// its initials.
  Widget _buildAccountAvatar(bool isDark, Map<String, dynamic> user) {
    final avatar = getAvatarBytes(user['image']);
    final fallback = _buildInitialsAvatar(isDark, user['userName']);

    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: isDark ? Colors.grey[600]! : Colors.grey[300]!,
          width: 2,
        ),
      ),
      child: ClipOval(
        child: avatar == null
            ? fallback
            : isSvg(avatar)
                ? SvgPicture.memory(avatar, fit: BoxFit.cover)
                : Image.memory(
                    avatar,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => fallback,
                  ),
      ),
    );
  }

  Widget _buildInitialsAvatar(bool isDark, dynamic userName) {
    final parts = (userName ?? '')
        .toString()
        .trim()
        .split(RegExp(r'\s+'))
        .where((part) => part.isNotEmpty)
        .toList();
    final initials = parts.isEmpty
        ? ''
        : (parts.length >= 2 ? '${parts[0][0]}${parts[1][0]}' : parts[0][0])
            .toUpperCase();

    return Container(
      color: isDark ? Colors.grey[700] : Colors.grey[100],
      alignment: Alignment.center,
      child: initials.isEmpty
          ? Icon(
              HugeIcons.strokeRoundedUser,
              size: 20,
              color: isDark ? Colors.grey[400] : Colors.grey[600],
            )
          : Text(
              initials,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: isDark ? Colors.grey[300] : Colors.grey[700],
              ),
            ),
    );
  }

  Widget _buildAddAccountButton() {
    return Container(
      margin: const EdgeInsets.all(16),
      width: double.infinity,
      height: 48,
      child: ElevatedButton.icon(
        onPressed: _openAddAccount,
        icon: const Icon(HugeIcons.strokeRoundedUserAdd01, size: 18),
        label: const Text(
          'Add Account',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        style: ElevatedButton.styleFrom(
          elevation: 0,
          shadowColor: Colors.transparent,
          backgroundColor: AppTheme.primaryColor,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.md),
          ),
          padding: const EdgeInsets.symmetric(vertical: 12),
        ),
      ),
    );
  }

  /// Opens the server screen to sign in to one more account.
  Future<void> _openAddAccount() async {
    final prefs = await SharedPreferences.getInstance();
    final url = prefs.getString('url') ?? '';
    final database = prefs.getString('selectedDatabase') ?? '';
    final session = await CompanySessionManager.getCurrentSession();
    if (!mounted || session == null) return;
    await Navigator.push(
      context,
      SlidingPageTransitionRL(
        page: ServerUrlScreen(
          serverUrl: url,
          database: database,
          session: session,
        ),
      ),
    );
  }

  /// Placeholder in the shape of the header card and menu while the
  /// profile loads.
  Widget _buildLoadingShimmer(bool isDark) {
    final placeholderColor = isDark ? Colors.grey[900]! : Colors.white;
    final cardColor = isDark ? Colors.grey[900] : Colors.white;

    Widget bar(double width, double height) => Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            color: placeholderColor,
            borderRadius: BorderRadius.circular(6),
          ),
        );

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Shimmer.fromColors(
        baseColor: isDark ? Colors.grey[800]! : Colors.grey[300]!,
        highlightColor: isDark ? Colors.grey[700]! : Colors.grey[100]!,
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(AppRadius.md),
                boxShadow: AppShadows.card,
              ),
              child: Row(
                children: [
                  Container(
                    width: 90,
                    height: 90,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: placeholderColor,
                    ),
                  ),
                  const SizedBox(width: 18),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        bar(180, 18),
                        const SizedBox(height: 8),
                        bar(160, 14),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(AppRadius.md),
              ),
              child: Column(
                children: List.generate(5, (index) {
                  return Padding(
                    padding: EdgeInsets.only(bottom: index == 4 ? 0 : 16),
                    child: Row(
                      children: [
                        Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: placeholderColor,
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              bar(120, 14),
                              const SizedBox(height: 6),
                              bar(180, 12),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Uint8List? getAvatarBytes(dynamic image) {
    if (image == null || image == false) return null;

    if (image is String && image.isNotEmpty) {
      try {
        return base64Decode(image);
      } catch (_) {
        return null;
      }
    }

    return null;
  }

  bool isSvg(Uint8List bytes) {
    final header = String.fromCharCodes(bytes.take(50)).toLowerCase();
    return header.contains('<svg');
  }
}
