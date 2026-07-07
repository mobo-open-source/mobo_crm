import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../global_methods/services/isar_caching_service.dart';
import '../../../../initilisation.dart';
import '../../../../services/storage_service.dart';
import '../../../../utils/globals.dart';
import '../../../../utils/snackbar.dart';
import '../../../login/server_setup_screen.dart';

/// A dialog widget that prompts the user to confirm logout.
///
/// Displays an AlertDialog with "Cancel" and "Log Out" buttons. If the user confirms,
/// the `_performLogout` method is called to clear app data, cached preferences,
/// and navigates the user to the `ServerSetupScreen`.
class LogoutDialog extends StatefulWidget {
  /// Constructor for [LogoutDialog].
  const LogoutDialog();

  @override
  _LogoutDialogState createState() => _LogoutDialogState();
}

/// The state for [LogoutDialog] which manages loading state and logout process.
class _LogoutDialogState extends State<LogoutDialog> {
  bool isLogoutLoading = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return AlertDialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      title: Text(
        "Confirm Logout",
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.black,
          fontSize: 18,
        ),
      ),
      content: Text(
        'Are you sure you want to log out? Your session will be ended.',
        style: TextStyle(
          fontWeight: FontWeight.w400,
          color: Colors.grey[700],
          fontSize: 15,
          height: 1.4,
        ),
      ),
      actions: [
        Row(
          children: [
            Expanded(
              child: SizedBox(
                height: 48,
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    foregroundColor: AppStyle.primaryColor,
                    side: BorderSide(
                      color: AppStyle.primaryColor, width: 1.5
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    "Cancel",
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                      color: AppStyle.primaryColor,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: SizedBox(
                height: 48,
                child: ElevatedButton(
                  onPressed: isLogoutLoading
                      ? null
                      : () async {
                          await _performLogout(context);
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppStyle.primaryColor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: isLogoutLoading
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : Text(
                          'Log Out',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  /// Handles the full logout process:
  ///
  /// 1. Shows a loading dialog with animation.
  /// 2. Clears cached data using `IsarService`.
  /// 3. Saves necessary preferences like `urlHistory`, `hasSeenGetStarted`, and biometric settings.
  /// 4. Clears all providers for customers, leads, opportunities, and quotations.
  /// 5. Navigates the user to the `ServerSetupScreen`.
  ///
  /// [context] - BuildContext used for showing dialogs and navigation.
  Future<void> _performLogout(BuildContext context) async {
    setState(() => isLogoutLoading = true);

    final odooClient = Provider.of<OdooClientManager>(context, listen: false);
    final navigator = Navigator.of(context);

    navigator.pop();

    showGeneralDialog(
      context: context,
      barrierDismissible: false,
      barrierLabel: '',
      barrierColor: Colors.black54,
      transitionDuration: Duration.zero,
      pageBuilder: (_, __, ___) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        return Material(
          type: MaterialType.transparency,
          child: Center(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 40),
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(32, 36, 32, 36),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  LoadingAnimationWidget.fourRotatingDots(
                    color: isDark ? Colors.white : AppStyle.primaryColor,
                    size: 50,
                  ),
                  const SizedBox(height: 30),
                  Text(
                    "Logging out...",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    "Please wait while we process\nyour request.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: isDark ? Colors.grey[300] : Colors.grey[700],
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );

    await Future.delayed(const Duration(seconds: 2));

    await IsarService.clearAllData();

    final prefs = await SharedPreferences.getInstance();
    List<String> urlHistory = prefs.getStringList('urlHistory') ?? [];
    bool isGetStarted = prefs.getBool('hasSeenGetStarted') ?? false;
    bool _biometricEnabled = prefs.getBool('biometricEnabled') ?? false;
    await IsarService.clearAllData();

    await StorageService().clearAllSessionData();
    odooClient.clearAll();
    await prefs.remove('loggedInAccounts');

    await prefs.clear();

    await prefs.setStringList('urlHistory', urlHistory);
    await prefs.setBool('hasSeenGetStarted', isGetStarted);
    await prefs.setBool('biometricEnabled', _biometricEnabled);

    if (navigator.mounted) {
      navigator.pop();
      navigator.pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (context) => ServerSetupScreen(),
        ),
        (route) => false,
      );
      CustomSnackbar.showSuccess(context, "Logged out successfully");
    }

    if (mounted) {
      setState(() => isLogoutLoading = false);
    }
  }
}
