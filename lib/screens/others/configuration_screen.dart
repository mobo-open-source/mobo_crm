import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:mobo_crm/screens/others/profile_screen.dart';
import 'package:mobo_crm/utils/snackbar.dart';
import 'package:provider/provider.dart';
import 'package:mobo_crm/global_methods/services/mobile_field_compatibility_service.dart';
import '../../bottom_nav_screen.dart';
import '../../core/company/session/company_session_manager.dart';
import '../../models/LoginPage/session_model.dart';
import '../../services/storage_service.dart';
import '../../utils/app_theme.dart';
import '../../utils/globals.dart';
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
  List<Map<String, dynamic>> _storedAccounts = [];
  late StorageService storageService;
  String? currentUrl;
  String? currentDatabase;

  @override
  void initState() {
    super.initState();
    storageService = StorageService();
    _loadUserData();
    _loadStoredAccounts();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadStoredAccounts();
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

          await _loadStoredAccounts();
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

  /// Loads the list of stored accounts from SharedPreferences.
  Future<void> _loadStoredAccounts() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      currentUrl = prefs.getString('url') ?? "";
      currentDatabase = prefs.getString('selectedDatabase') ?? "";
      final accountsJson = prefs.getStringList('stored_accounts') ?? [];

      _storedAccounts = accountsJson.map((accountStr) {
        final account = Map<String, dynamic>.from(jsonDecode(accountStr));
        return account;
      }).toList();

      await _addCurrentAccountToStored();

      setState(() {});
    } catch (_) {}
  }

  /// Adds the current user account to the stored accounts list.
  /// Ensures only one account is marked as current and stores passwords securely.
  Future<void> _addCurrentAccountToStored() async {
    try {
      final clientManager =
          Provider.of<OdooClientManager>(context, listen: false);

      if (_userData != null) {
        final prefs = await SharedPreferences.getInstance();
        final userId = prefs.getInt('userId') ?? 0;
        final database = prefs.getString('database') ?? '';
        final username = prefs.getString('userName') ?? '';

        String? imageBase64;
        if (_userAvatar != null) {
          try {
            imageBase64 = base64Encode(_userAvatar!);
          } catch (e) {
            imageBase64 = null;
          }
        } else if (_userData!['image_1920'] != null &&
            _userData!['image_1920'] != false) {
          try {
            final imageString = _userData!['image_1920'].toString();
            if (imageString.isNotEmpty &&
                imageString != 'false' &&
                imageString != 'null') {
              imageBase64 = imageString;
            } else {
              imageBase64 = null;
            }
          } catch (e) {
            imageBase64 = null;
          }
        } else {}

        final currentAccount = {
          'id': userId,
          'name': _userData!['name'] ?? 'Unknown User',
          'email': _userData!['email'] ?? 'No email',
          'url': clientManager.url ?? '',
          'database': database,
          'username': username,
          'isCurrent': true,
          'lastLogin': DateTime.now().toIso8601String(),
          'imageBase64': imageBase64,
        };

        final storedPassword = prefs.getString('password');
        final specificPasswordKey =
            'password_${currentAccount['id']}_${currentAccount['database']}';
        final existingSpecificPassword = prefs.getString(specificPasswordKey);

        if (storedPassword != null && existingSpecificPassword == null) {
          await prefs.setString(specificPasswordKey, storedPassword);

          await prefs.setString(
              'password_${currentAccount['username']}_${currentAccount['database']}',
              storedPassword);
          if (currentAccount['email'] != currentAccount['username']) {
            await prefs.setString(
                'password_${currentAccount['email']}_${currentAccount['database']}',
                storedPassword);
          }
        } else if (existingSpecificPassword != null) {
        } else {}

        for (var account in _storedAccounts) {
          account['isCurrent'] = false;
        }

        final existingIndex = _storedAccounts.indexWhere((account) =>
            account['id'] == currentAccount['id'] &&
            account['url'] == currentAccount['url'] &&
            account['database'] == currentAccount['database']);

        if (existingIndex != -1) {
          _storedAccounts[existingIndex] = currentAccount;
        } else {
          _storedAccounts.insert(0, currentAccount);
        }

        await _saveStoredAccounts();
      }
    } catch (_) {}
  }

  /// Saves the current list of stored accounts to SharedPreferences.
  Future<void> _saveStoredAccounts() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final accountsJson =
          _storedAccounts.map((account) => jsonEncode(account)).toList();
      await prefs.setStringList('stored_accounts', accountsJson);
    } catch (_) {}
  }

  /// Switches the app to another stored user account.
  ///
  /// Updates session and login state in storage, clears cached data,
  /// reinitializes providers, and navigates to the home screen.
  ///
  /// Displays a snackbar on success or failure.
  /// [user] is a map containing the stored account details to switch to.
  Future<void> _switchToAccount(Map<String, dynamic> user) async {
    setState(() {
      isAccountLoading = true;
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
      ));

      await storageService.saveLoginState(
        isLoggedIn: true,
        database: user['database'],
        url: user['url'],
      );

      await clientManager.initializeOdooClient(context);
      await clientManager.initializeOdooClientWithUrl(user['url']);

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
        });
        Navigator.pushReplacementNamed(context, '/init');

        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => const HomeScreen(loadInit: true),
          ),
          (route) => false,
        );

        CustomSnackbar.showSuccess(context, 'Switched to ${user['name']}');
      }
    } catch (e) {
      setState(() {
        isAccountLoading = false;
      });
      if (mounted) {
        String errorMessage;
        SnackBarAction? action;

        if (e.toString().contains('AccessDenied') ||
            e.toString().contains('Access Denied')) {
          errorMessage =
              'Invalid credentials for ${user['name']}. Please add the account again with correct password.';
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

  bool isSvgBytes(Uint8List bytes) {
    final str = utf8.decode(bytes, allowMalformed: true);
    return str.contains('<svg');
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.grey[50],
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            HugeIcons.strokeRoundedArrowLeft01,
            color: isDark ? Colors.white : Colors.black,
            size: 28,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text(
          'Configuration',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 22,
            color: isDark ? Colors.white : Colors.black,
          ),
        ),
        automaticallyImplyLeading: false,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () async {
                      await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const ProfileScreen()));
                      _loadUserData();
                    },
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            AppStyle.primaryColor,
                            AppStyle.primaryColor
                          ],
                        ),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.2),
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.white.withValues(alpha: 0.3),
                                width: 2,
                              ),
                            ),
                            child: ClipOval(
                              child: _userAvatar != null
                                  ? Image.memory(
                                      _userAvatar!,
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                        return Container(
                                          color: Colors.white.withValues(alpha: 0.1),
                                          child: Icon(
                                            HugeIcons.strokeRoundedUser,
                                            size: 30,
                                            color:
                                                Colors.white.withValues(alpha: 0.9),
                                          ),
                                        );
                                      },
                                    )
                                  : Container(
                                      color: Colors.white.withValues(alpha: 0.1),
                                      child: Icon(
                                        HugeIcons.strokeRoundedUser,
                                        size: 30,
                                        color: Colors.white.withValues(alpha: 0.9),
                                      ),
                                    ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _userData?['name'] ?? "No Name",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  _userData?['email'] is String
                                      ? _userData!['email']
                                      : 'No Email',
                                  style: TextStyle(
                                    color: Colors.white.withValues(alpha: 0.9),
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                const SizedBox(height: 8),
                              ],
                            ),
                          ),
                          Icon(
                            Icons.arrow_forward_ios,
                            color: Colors.white.withValues(alpha: 0.7),
                            size: 16,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  Container(
                    decoration: BoxDecoration(
                      color: isDark ? Colors.grey[850] : Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Material(
                        color: Colors.transparent,
                        child: Column(
                      children: [
                        ListTile(
                          leading: Icon(
                            HugeIcons.strokeRoundedSettings02,
                            size: 22,
                            color: Colors.black87,
                          ),
                          title: Text(
                            'Settings',
                            style: TextStyle(
                              color: isDark ? Colors.white : Colors.black87,
                              fontWeight: FontWeight.normal,
                              fontSize: 16,
                            ),
                          ),
                          subtitle: Text(
                            'App preferences and sync options',
                            style: TextStyle(
                              color: isDark
                                  ? Colors.grey[400]!
                                  : Colors.grey[600]!,
                            ),
                          ),
                          trailing: const Icon(Icons.chevron_right_rounded),
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SettingsScreen()));
                          },
                        ),
                        Divider(
                          height: 1,
                          thickness: 1,
                          color: isDark ? Colors.grey[800] : Colors.grey[200],
                          indent: 20,
                          endIndent: 20,
                        ),
                        ListTile(
                          leading: Icon(
                            HugeIcons.strokeRoundedMessage01,
                            color:
                                isDark ? Colors.grey[400]! : Colors.grey[600]!,
                          ),
                          title: Text(
                            'Chat',
                            style: TextStyle(
                              color: isDark ? Colors.white : Colors.black87,
                              fontWeight: FontWeight.normal,
                              fontSize: 16,
                            ),
                          ),
                          subtitle: Text(
                            'Messages and discussions',
                            style: TextStyle(
                              color: isDark
                                  ? Colors.grey[400]!
                                  : Colors.grey[600]!,
                            ),
                          ),
                          trailing: const Icon(Icons.chevron_right_rounded),
                          onTap: () {
                            final discussProvider =
                                Provider.of<DiscussProvider>(context,
                                    listen: false);
                            discussProvider.clearAll();
                            Navigator.push(
                              context,
                              SlidingPageTransitionRL(page: Discuss()),
                            );
                          },
                        ),
                        Divider(
                          height: 1,
                          thickness: 1,
                          color: isDark ? Colors.grey[800] : Colors.grey[200],
                          indent: 20,
                          endIndent: 20,
                        ),
                        ListTile(
                          leading: Icon(
                            HugeIcons.strokeRoundedMail01,
                            color:
                                isDark ? Colors.grey[400]! : Colors.grey[600]!,
                          ),
                          title: Text(
                            'Mail Activities',
                            style: TextStyle(
                              color: isDark ? Colors.white : Colors.black87,
                              fontWeight: FontWeight.normal,
                              fontSize: 16,
                            ),
                          ),
                          subtitle: Text(
                            'Email activities and notifications',
                            style: TextStyle(
                              color: isDark
                                  ? Colors.grey[400]!
                                  : Colors.grey[600]!,
                            ),
                          ),
                          trailing: const Icon(Icons.chevron_right_rounded),
                          onTap: () {
                            Navigator.push(
                              context,
                              SlidingPageTransitionRL(
                                page: MailDataScreen(),
                              ),
                            );
                          },
                        ),
                        Divider(
                          height: 1,
                          thickness: 1,
                          color: isDark ? Colors.grey[800] : Colors.grey[200],
                          indent: 20,
                          endIndent: 20,
                        ),
                        FutureBuilder<List<Map<String, dynamic>>>(
                          future: storageService.getAccounts(),
                          builder: (context, snapshot) {
                            final accounts = snapshot.data ?? [];
                            final otherAccounts = accounts.where((user) {
                              final userUrl = user['url'] ?? '';
                              final userDatabase = user['database'] ?? '';
                              final userName = user['userName'] ?? '';
                              final isSameAccount = userUrl == currentUrl &&
                                  userDatabase == currentDatabase &&
                                  userName == _userData?['name'];
                              return !isSameAccount && userName.isNotEmpty;
                            }).toList();
                            final accountCount = otherAccounts.length;

                            return Theme(
                              data: Theme.of(context).copyWith(
                                dividerColor: Colors.transparent,
                                splashColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                              ),
                              child: ExpansionTile(
                                shape: const Border(),
                                collapsedShape: const Border(),
                                leading: Icon(
                                  HugeIcons.strokeRoundedUserSwitch,
                                  color: isDark
                                      ? Colors.grey[400]
                                      : Colors.grey[600],
                                ),
                                title: const Text(
                                  'Switch Accounts',
                                  style: TextStyle(fontWeight: FontWeight.w500),
                                ),
                                subtitle: Text(
                                  accountCount > 0
                                      ? '$accountCount other account${accountCount != 1 ? 's' : ''} available'
                                      : 'Add multiple accounts to switch quickly',
                                  style: TextStyle(
                                    color: isDark
                                        ? Colors.grey[400]
                                        : Colors.grey[600],
                                  ),
                                ),
                                children: [
                                  if (otherAccounts.isEmpty)
                                    Padding(
                                      padding: const EdgeInsets.all(16),
                                      child: Column(
                                        children: [
                                          Container(
                                            width: 60,
                                            height: 60,
                                            decoration: BoxDecoration(
                                              color: AppTheme.primaryColor
                                                  .withValues(alpha: 0.1),
                                              shape: BoxShape.circle,
                                            ),
                                            child: Icon(
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
                                              color: isDark
                                                  ? Colors.white
                                                  : Colors.black87,
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          Text(
                                            'Add multiple accounts to switch between them quickly',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: isDark
                                                  ? Colors.grey[400]
                                                  : Colors.grey[600],
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  else
                                    ...otherAccounts.map((user) {
                                      final avatar =
                                          getAvatarBytes(user['image']);
                                      return Container(
                                        margin: const EdgeInsets.symmetric(
                                            horizontal: 16, vertical: 4),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          color: isDark
                                              ? Colors.grey[800]
                                              : Colors.grey[50],
                                          border: Border.all(
                                            color: isDark
                                                ? Colors.grey[700]!
                                                : Colors.grey[200]!,
                                          ),
                                        ),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(12),
                                          child: Material(
                                            color: Colors.transparent,
                                            child: ListTile(
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                                  horizontal: 16, vertical: 8),
                                          leading: Container(
                                            width: 40,
                                            height: 40,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              border: Border.all(
                                                color: isDark
                                                    ? Colors.grey[600]!
                                                    : Colors.grey[300]!,
                                                width: 2,
                                              ),
                                            ),
                                            child: ClipOval(
                                              child: avatar != null
                                                  ? isSvg(avatar)
                                                      ? SvgPicture.memory(
                                                          avatar,
                                                          width: 36,
                                                          height: 36,
                                                          fit: BoxFit.cover,
                                                        )
                                                      : Image.memory(
                                                          avatar,
                                                          width: 36,
                                                          height: 36,
                                                          fit: BoxFit.cover,
                                                        )
                                                  : Container(
                                                      color: isDark
                                                          ? Colors.grey[700]
                                                          : Colors.grey[200],
                                                      child: Icon(
                                                        Icons.person,
                                                        size: 20,
                                                        color: isDark
                                                            ? Colors.grey[400]
                                                            : Colors.grey[600],
                                                      ),
                                                    ),
                                            ),
                                          ),
                                          title: Text(
                                            user['userName'] ?? 'Unknown User',
                                            style: TextStyle(
                                              color: isDark
                                                  ? Colors.white
                                                  : Colors.black87,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          subtitle: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              const SizedBox(height: 4),
                                              Text(
                                                user['database'] ?? '',
                                                style: TextStyle(
                                                  color: isDark
                                                      ? Colors.grey[400]
                                                      : Colors.grey[600],
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ],
                                          ),
                                          trailing: InkWell(
                                            onTap: () async {
                                              _switchToAccount(user);
                                            },
                                            child: Container(
                                              padding: const EdgeInsets.all(10),
                                              child: Text(
                                                "Switch",
                                                style: TextStyle(
                                                  color: AppTheme.primaryColor,
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 13,
                                                ),
                                              ),
                                            ),
                                          ),
                                          onTap: () async {
                                            _switchToAccount(user);
                                          },
                                        ),
                                          ),
                                        ),
                                      );
                                    }),
                                  Container(
                                    margin: const EdgeInsets.all(16),
                                    width: double.infinity,
                                    child: ElevatedButton.icon(
                                      onPressed: () async {
                                        final prefs = await SharedPreferences
                                            .getInstance();
                                        final url =
                                            prefs.getString('url') ?? '';
                                        final database = prefs.getString(
                                                'selectedDatabase') ??
                                            '';
                                        final session =
                                            await CompanySessionManager
                                                .getCurrentSession();
                                        await Navigator.push(
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
                                      icon: const Icon(
                                        HugeIcons.strokeRoundedUserAdd01,
                                        size: 18,
                                      ),
                                      label: const Text(
                                        'Add Account',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16),
                                      ),
                                      style: ElevatedButton.styleFrom(
                                        elevation: 0,
                                        backgroundColor: AppTheme.primaryColor,
                                        foregroundColor: Colors.white,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 12),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                        Divider(
                          height: 1,
                          thickness: 1,
                          color:
                              isDark ? Colors.grey[800] : Colors.grey.shade200,
                          indent: 20,
                          endIndent: 20,
                        ),
                        ListTile(
                          leading: const Icon(
                            Icons.logout,
                            color: Color(0xFFD32F2F),
                          ),
                          title: Text(
                            'Logout',
                            style: TextStyle(
                              color: isDark
                                  ? Colors.white
                                  : const Color(0xFFD32F2F),
                              fontWeight: FontWeight.normal,
                              fontSize: 16,
                            ),
                          ),
                          subtitle: Text(
                            'Sign out from this device',
                            style: TextStyle(
                              color: isDark
                                  ? Colors.grey[400]!
                                  : Colors.grey[600]!,
                            ),
                          ),
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
