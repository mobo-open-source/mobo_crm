import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:mobo_crm/screens/settings/screens/company/company_details.dart';
import 'package:mobo_crm/global_methods/services/biometric_service.dart';
import 'package:mobo_crm/screens/settings/widgets/app_web.dart';
import 'package:mobo_crm/utils/snackbar.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/providers/theme_provider.dart';
import '../../global_methods/const.dart';
import '../../global_methods/widgets/transition/page_transition.dart';
import '../../initilisation.dart';
import '../../utils/app_theme.dart';
import '../../utils/globals.dart';
import 'my_odoo_account_screen.dart';

/// Screen for app settings: app-lock/biometric configuration and account options.
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _isAppLockEnabled = false;
  bool _isBiometricAvailable = false;
  String _authStatusDescription = 'Checking authentication status...';

  String _selectedLanguage = 'en_US';
  String _selectedCurrency = 'USD';
  String _selectedTimezone = 'UTC';

  static const _languages = [
    {'name': 'English (US)', 'code': 'en_US'},
    {'name': 'Arabic', 'code': 'ar_001'},
    {'name': 'French', 'code': 'fr'},
    {'name': 'German', 'code': 'de'},
    {'name': 'Spanish', 'code': 'es'},
    {'name': 'Portuguese', 'code': 'pt'},
  ];

  static const _currencies = [
    {'full_name': 'United States Dollar', 'name': 'USD'},
    {'full_name': 'Euro', 'name': 'EUR'},
    {'full_name': 'British Pound', 'name': 'GBP'},
    {'full_name': 'Indian Rupee', 'name': 'INR'},
    {'full_name': 'UAE Dirham', 'name': 'AED'},
  ];

  static const _timezones = [
    {'name': 'UTC', 'code': 'UTC'},
    {'name': 'Europe/Brussels', 'code': 'Europe/Brussels'},
    {'name': 'Asia/Kolkata', 'code': 'Asia/Kolkata'},
    {'name': 'America/New_York', 'code': 'America/New_York'},
    {'name': 'Asia/Dubai', 'code': 'Asia/Dubai'},
    {'name': 'Asia/Singapore', 'code': 'Asia/Singapore'},
  ];

  @override
  void initState() {
    super.initState();
    _loadAuthSettings();
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    if (mounted) {
      setState(() {
        _selectedLanguage = prefs.getString('selected_language') ?? 'en_US';
        _selectedCurrency = prefs.getString('selected_currency') ?? 'USD';
        _selectedTimezone = prefs.getString('selected_timezone') ?? 'UTC';
      });
    }
  }

  Future<void> _loadAuthSettings() async {
    try {
      final isEnabled = await BiometricService.isBiometricEnabled();
      final isAvailable = await BiometricService.isBiometricAvailable();
      final description = isAvailable
          ? (isEnabled
              ? 'Biometric authentication is enabled'
              : 'Biometric authentication is available but disabled')
          : 'Biometric authentication is not available on this device';
      if (mounted) {
        setState(() {
          _isAppLockEnabled = isEnabled;
          _isBiometricAvailable = isAvailable;
          _authStatusDescription = description;
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() {
          _authStatusDescription = 'Authentication status unavailable';
        });
      }
    }
  }

  Future<void> _toggleAppLock(bool enabled) async {
    try {
      if (enabled) {
        final canAuthenticate =
            await BiometricService.authenticateWithBiometrics(
          reason: 'Authenticate to enable biometric login',
        );
        if (!canAuthenticate) {
          if (mounted) {
            CustomSnackbar.showError(
              context,
              'Authentication failed. Biometric authentication not enabled.',
            );
          }
          return;
        }
      }
      await BiometricService.setBiometricEnabled(enabled);
      await _loadAuthSettings();
      if (mounted) {
        CustomSnackbar.showSuccess(
          context,
          enabled
              ? 'Biometric authentication enabled successfully'
              : 'Biometric authentication disabled',
        );
      }
    } catch (e) {
      if (mounted) {
        CustomSnackbar.showError(
          context,
          'Failed to ${enabled ? 'enable' : 'disable'} biometric authentication',
        );
      }
    }
  }

  Future<void> _launchUrlSmart(String url, {String? title}) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      _openInAppWebPage(uri, title: title);
    }
  }

  Future<void> _openInAppWebPage(Uri url, {String? title}) async {
    if (!mounted) return;
    try {
      Navigator.of(context).push(
        SlidingPageTransitionRL(page: InAppWebPage(url: url, title: title)),
      );
    } catch (e) {
      if (!mounted) return;
      CustomSnackbar.showError(context, 'Could not open page. Try again later.');
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDark ? Colors.grey[900]! : Colors.grey[50]!;
    final cardColor = isDark ? const Color(0xFF1E1E2C) : Colors.white;

    final appBarBg = backgroundColor;

    return Theme(
      data: Theme.of(context).copyWith(
        colorScheme: Theme.of(context).colorScheme.copyWith(
          surface: isDark ? const Color(0xFF1E1E2C) : Colors.white,
          surfaceContainerLow: isDark ? const Color(0xFF1E1E2C) : Colors.white,
          surfaceContainerHighest:
              isDark ? const Color(0xFF2C2C3E) : Colors.white,
          surfaceTint: Colors.transparent,
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: appBarBg,
          foregroundColor: isDark ? Colors.white : Colors.black,
          elevation: 0,
          scrolledUnderElevation: 0,
          surfaceTintColor: Colors.transparent,
        ),
        splashColor: Colors.transparent,
        highlightColor: Colors.black.withOpacity(0.04),
      ),
      child: Scaffold(
        backgroundColor: backgroundColor,
        appBar: AppBar(
          title: Text(
            'Settings',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Colors.black,
            ),
          ),
          backgroundColor: appBarBg,
          elevation: 0,
          scrolledUnderElevation: 0,
          surfaceTintColor: Colors.transparent,
          leading: IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: Icon(
              HugeIcons.strokeRoundedArrowLeft01,
              color: isDark ? Colors.white : Colors.black,
            ),
          ),
        ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSectionCard(
            context,
            'Appearance',
            sectionIcon: HugeIcons.strokeRoundedSmile,
            [
              _buildSwitchTile(
                context,
                'Dark Mode',
                isDark ? 'Dark theme is active' : 'Light theme is active',
                HugeIcons.strokeRoundedSun02,
                Theme.of(context).brightness == Brightness.dark,
                (value) {
                  context.read<ThemeProvider>().toggleTheme();
                  CustomSnackbar.showSuccess(
                    context,
                    'Theme changed to ${value ? 'dark' : 'light'} mode',
                  );
                },
              ),
            ],
          ),

          const SizedBox(height: 16),

          _buildSectionCard(
            context,
            'Security',
            sectionIcon: HugeIcons.strokeRoundedShield01,
            [
              _buildSwitchTile(
                context,
                'App Lock',
                _isBiometricAvailable
                    ? (_isAppLockEnabled
                        ? 'Biometric lock is enabled'
                        : 'Enable biometric lock to keep your app secure')
                    : 'Biometric authentication is not available on this device',
                _isBiometricAvailable
                    ? HugeIcons.strokeRoundedFingerPrint
                    : HugeIcons.strokeRoundedLockPassword,
                _isAppLockEnabled,
                (value) {
                  if (_isBiometricAvailable) {
                    _toggleAppLock(value);
                  } else {
                    CustomSnackbar.showError(
                      context,
                      'Biometric authentication not available on this device',
                    );
                  }
                },
              ),
            ],
          ),

          const SizedBox(height: 16),

          _buildSectionCard(
            context,
            'Language & Region',
            sectionIcon: HugeIcons.strokeRoundedLanguageCircle,
            [
              _buildDropdownTile(
                context,
                'Language',
                'Select your preferred language',
                HugeIcons.strokeRoundedTranslate,
                _selectedLanguage,
                _languages,
                displayKey: 'name',
                valueKey: 'code',
                onChanged: (value) async {
                  if (value == null) return;
                  setState(() => _selectedLanguage = value);
                  final prefs = await SharedPreferences.getInstance();
                  await prefs.setString('selected_language', value);
                  if (mounted) {
                    final name = _languages
                        .firstWhere((l) => l['code'] == value,
                            orElse: () => {'name': value})['name'];
                    CustomSnackbar.showSuccess(
                        context, 'Language updated to $name');
                  }
                },
              ),
              _buildDropdownTile(
                context,
                'Currency',
                'Default currency for transactions',
                HugeIcons.strokeRoundedDollar01,
                _selectedCurrency,
                _currencies,
                displayKey: 'full_name',
                valueKey: 'name',
                onChanged: (value) async {
                  if (value == null) return;
                  setState(() => _selectedCurrency = value);
                  final prefs = await SharedPreferences.getInstance();
                  await prefs.setString('selected_currency', value);
                  if (mounted) {
                    CustomSnackbar.showSuccess(
                        context, 'Currency updated to $value');
                  }
                },
              ),
              _buildDropdownTile(
                context,
                'Timezone',
                'Your local timezone',
                HugeIcons.strokeRoundedClock01,
                _selectedTimezone,
                _timezones,
                displayKey: 'name',
                valueKey: 'code',
                onChanged: (value) async {
                  if (value == null) return;
                  setState(() => _selectedTimezone = value);
                  final prefs = await SharedPreferences.getInstance();
                  await prefs.setString('selected_timezone', value);
                  if (mounted) {
                    CustomSnackbar.showSuccess(
                        context, 'Timezone updated to $value');
                  }
                },
              ),
            ],
          ),

          const SizedBox(height: 16),

          _buildSectionCard(
            context,
            'Account',
            sectionIcon: HugeIcons.strokeRoundedUserCircle,
            [
              _buildActionTile(
                context,
                'My Odoo Account',
                'Access your odoo.com account',
                HugeIcons.strokeRoundedGlobe02,
                () => Navigator.push(
                  context,
                  SlidingPageTransitionRL(
                    page: OdooLoginPage(url: odooUrl, title: 'Odoo Login'),
                  ),
                ),
              ),
              _buildActionTile(
                context,
                'Company Profile',
                'View and edit company information',
                HugeIcons.strokeRoundedBuilding06,
                () => Navigator.push(
                  context,
                  SlidingPageTransitionRL(page: CompanyProfile()),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          _buildSectionCard(
            context,
            'Help & Support',
            sectionIcon: HugeIcons.strokeRoundedHelpCircle,
            [
              _buildActionTile(
                context,
                'Documentation',
                'Guides and resources',
                HugeIcons.strokeRoundedHelpCircle,
                () => Navigator.push(
                  context,
                  SlidingPageTransitionRL(
                    page: OdooLoginPage(
                        url: documentationUrl, title: 'Documentation'),
                  ),
                ),
              ),
              _buildActionTile(
                context,
                'Support',
                'Get help from our support team',
                HugeIcons.strokeRoundedCustomerSupport,
                () => Navigator.push(
                  context,
                  SlidingPageTransitionRL(
                    page: OdooLoginPage(url: supportUrl, title: 'Support'),
                  ),
                ),
              ),
              _buildActionTile(
                context,
                'Help Center',
                'Find answers to common questions',
                HugeIcons.strokeRoundedQuestion,
                () => Navigator.push(
                  context,
                  SlidingPageTransitionRL(
                    page: OdooLoginPage(url: helpUrl, title: 'Help Center'),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          _buildSectionCard(
            context,
            'About',
            sectionIcon: HugeIcons.strokeRoundedInformationCircle,
            [_buildAboutContent(context)],
          ),

          const SizedBox(height: 32),
        ],
      ),
    ),
    );
  }

  Widget _buildSectionCard(
    BuildContext context,
    String title,
    List<Widget> children, {
    Widget? headerTrailing,
    IconData? sectionIcon,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E2C) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.07),
            blurRadius: 8,
            spreadRadius: 0,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Material(
        color: Colors.transparent,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      title,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: isDark ? Colors.white : Colors.black,
                      ),
                    ),
                  ),
                  if (headerTrailing != null) headerTrailing,
                ],
              ),
            ),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildSwitchTile(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon,
    bool value,
    Function(bool) onChanged,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return ListTile(
      leading: SizedBox(
        width: 36,
        height: 36,
        child: Icon(
          icon,
          size: 20,
          color: isDark ? Colors.grey[400] : Colors.black,
        ),
      ),
      title: Text(
        title,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 16,
          color: isDark ? Colors.white : Colors.black87,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          fontSize: 14,
          color: isDark ? Colors.grey[400] : Colors.grey[600],
          height: 1.3,
        ),
      ),
      trailing: _buildModernSwitch(value, onChanged, isDark),
      tileColor: Colors.transparent,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    );
  }

  Widget _buildActionTile(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon,
    VoidCallback? onTap,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return ListTile(
      leading: SizedBox(
        width: 36,
        height: 36,
        child: Icon(
          icon,
          size: 20,
          color: isDark ? Colors.grey[400] : Colors.black,
        ),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.w500,
          color: isDark ? Colors.white : Colors.black87,
        ),
      ),
      subtitle: subtitle.isNotEmpty
          ? Text(
              subtitle,
              style: TextStyle(
                fontSize: 12,
                color: isDark ? Colors.grey[400] : Colors.grey[600],
              ),
            )
          : null,
      trailing: Icon(
        HugeIcons.strokeRoundedArrowRight01,
        color: isDark ? Colors.grey[400] : Colors.grey[600],
        size: 18,
      ),
      tileColor: Colors.transparent,
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
    );
  }

  Widget _buildDropdownTile(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon,
    String value,
    List<Map<String, String>> options, {
    required String displayKey,
    required String valueKey,
    required Function(String?) onChanged,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return ListTile(
      leading: SizedBox(
        width: 36,
        height: 36,
        child: Icon(
          icon,
          size: 20,
          color: isDark ? Colors.grey[400] : Colors.black,
        ),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.w500,
          color: isDark ? Colors.white : Colors.black87,
        ),
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          fontSize: 12,
          color: isDark ? Colors.grey[400] : Colors.grey[600],
        ),
      ),
      trailing: SizedBox(
        width: MediaQuery.of(context).size.width * 0.35,
        child: DropdownButton<String>(
          isExpanded: true,
          value: options.any((o) => o[valueKey] == value) ? value : null,
          onChanged: onChanged,
          underline: const SizedBox(),
          dropdownColor: isDark ? Colors.grey[850] : Colors.white,
          selectedItemBuilder: (context) {
            return options.map((option) {
              return Align(
                alignment: Alignment.centerRight,
                child: Text(
                  option[displayKey] ?? option[valueKey] ?? '',
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 14,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                ),
              );
            }).toList();
          },
          items: options.map((option) {
            return DropdownMenuItem<String>(
              value: option[valueKey],
              child: Text(
                option[displayKey] ?? option[valueKey] ?? '',
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 14,
                  color: isDark ? Colors.white : Colors.black87,
                ),
              ),
            );
          }).toList(),
        ),
      ),
      tileColor: Colors.transparent,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
    );
  }

  Widget _buildModernSwitch(bool value, Function(bool) onChanged, bool isDark) {
    return GestureDetector(
      onTap: () => onChanged(!value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        width: 56,
        height: 30,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: value
              ? AppTheme.primaryColor
              : (isDark ? Colors.grey[900] : Colors.white),
          border: value
              ? null
              : Border.all(color: AppTheme.primaryColor, width: 1.5),
        ),
        child: AnimatedAlign(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeInOut,
          alignment: value ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            width: 24,
            height: 24,
            margin: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: value ? Colors.white : AppTheme.primaryColor,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.15),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAboutContent(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Column(
        children: [
          _buildActionTile(
            context,
            'Visit Website',
            'www.cybrosys.com',
            HugeIcons.strokeRoundedGlobe02,
            () => _launchUrlSmart('https://www.cybrosys.com/', title: 'Our Website'),
          ),
          _buildActionTile(
            context,
            'Contact Us',
            'info@cybrosys.com',
            HugeIcons.strokeRoundedMail01,
            () => _launchUrlSmart('mailto:info@cybrosys.com'),
          ),
          if (Theme.of(context).platform == TargetPlatform.android)
            _buildActionTile(
              context,
              'More Apps',
              'View our other apps on Play Store',
              HugeIcons.strokeRoundedPlayStore,
              () => _launchUrlSmart(
                'https://play.google.com/store/apps/dev?id=7163004064816759344&pli=1',
                title: 'Play Store',
              ),
            ),
          const SizedBox(height: 16),
          Divider(color: isDark ? Colors.grey[800] : Colors.grey[200]),
          const SizedBox(height: 16),
          Text(
            'Follow Us',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: isDark ? Colors.white : Colors.black87,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildSocialButton(
                context,
                'assets/facebook.png',
                const Color(0xFF1877F2),
                () => _launchUrlSmart(
                    'https://www.facebook.com/cybrosystechnologies',
                    title: 'Facebook'),
              ),
              _buildSocialButton(
                context,
                'assets/linkedin.png',
                const Color(0xFF0077B5),
                () => _launchUrlSmart(
                    'https://www.linkedin.com/company/cybrosys/',
                    title: 'LinkedIn'),
              ),
              _buildSocialButton(
                context,
                'assets/instagram.png',
                const Color(0xFFE4405F),
                () => _launchUrlSmart(
                    'https://www.instagram.com/cybrosystech/',
                    title: 'Instagram'),
              ),
              _buildSocialButton(
                context,
                'assets/youtube.png',
                const Color(0xFFFF0000),
                () => _launchUrlSmart(
                    'https://www.youtube.com/channel/UCKjWLm7iCyOYINVspCSanjg',
                    title: 'YouTube'),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Text(
            '© ${DateTime.now().year} Cybrosys Technologies',
            style: TextStyle(
              fontSize: 12,
              color: isDark ? Colors.grey[400] : Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _buildSocialButton(
    BuildContext context,
    String imagePath,
    Color underlineColor,
    VoidCallback onPressed,
  ) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: onPressed,
          child: Container(
            width: 46,
            height: 46,
            padding: const EdgeInsets.all(12),
            child: Image.asset(
              imagePath,
              width: 24,
              height: 24,
              fit: BoxFit.contain,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: 48,
          height: 3,
          decoration: BoxDecoration(
            color: underlineColor,
            borderRadius: BorderRadius.circular(1.5),
          ),
        ),
      ],
    );
  }
}
