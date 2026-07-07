import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:mobo_crm/global_methods/services/biometric_service.dart';

/// A biometric authentication screen used to lock and secure the application.
///
/// This screen:
/// - Automatically attempts biometric authentication on load
/// - Displays available biometric type (Face ID, Fingerprint, etc.)
/// - Shows animated feedback during authentication
/// - Handles authentication errors with retry support
/// - Optionally allows skipping authentication
///
/// Typically used as an app lock or secure access gate
/// before entering the main CRM dashboard.
class BiometricAuthScreen extends StatefulWidget {
  final VoidCallback onSuccess;
  final VoidCallback? onSkip;
  final bool allowSkip;

  /// Creates a biometric authentication screen.
  ///
  /// Parameters:
  /// - [onSuccess]: Callback triggered when authentication succeeds.
  /// - [onSkip]: Optional callback triggered if user skips authentication.
  /// - [allowSkip]: Whether skipping authentication is allowed.
  const BiometricAuthScreen({
    super.key,
    required this.onSuccess,
    this.onSkip,
    this.allowSkip = false,
  });

  @override
  State<BiometricAuthScreen> createState() => _BiometricAuthScreenState();
}

/// State class for [BiometricAuthScreen].
///
/// Responsibilities:
/// - Manage authentication state
/// - Control pulse animation
/// - Load available biometric methods
/// - Handle retry and error states
///
/// Uses [BiometricService] to perform device authentication.
class _BiometricAuthScreenState extends State<BiometricAuthScreen>
    with TickerProviderStateMixin {
  bool _isAuthenticating = false;
  String _errorMessage = '';
  List<String> _availableBiometrics = [];
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  /// Initializes animations and loads available biometric methods.
  ///
  /// Automatically triggers biometric authentication
  /// after a short delay.
  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _loadAvailableBiometrics();
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        _authenticateWithBiometrics();
      }
    });
  }

  /// Initializes the pulse animation used for
  /// the biometric icon during authentication.
  ///
  /// Creates a repeating scale animation for visual feedback.
  void _initializeAnimations() {
    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));
    _pulseController.repeat(reverse: true);
  }

  /// Retrieves available biometric types from the device.
  ///
  /// Updates [_availableBiometrics] to determine
  /// appropriate icon and instruction text.
  Future<void> _loadAvailableBiometrics() async {
    final biometrics = await BiometricService.getAvailableBiometricNames();
    if (mounted) {
      setState(() {
        _availableBiometrics = biometrics;
      });
    }
  }

  /// Initiates biometric authentication using [BiometricService].
  ///
  /// Updates:
  /// - [_isAuthenticating]
  /// - [_errorMessage]
  ///
  /// On success:
  /// - Calls [widget.onSuccess]
  ///
  /// On failure:
  /// - Displays retry UI
  Future<void> _authenticateWithBiometrics() async {
    if (_isAuthenticating) return;

    setState(() {
      _isAuthenticating = true;
      _errorMessage = '';
    });

    try {
      final bool isAuthenticated =
          await BiometricService.authenticateWithBiometrics(
        reason: 'Please authenticate to access your CRM',
      );

      if (mounted) {
        if (isAuthenticated) {
          widget.onSuccess();
        } else {
          setState(() {
            _isAuthenticating = false;
            _errorMessage = 'Authentication failed. Please try again.';
          });
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isAuthenticating = false;
          _errorMessage = 'Authentication error. Please try again.';
        });
      }
    }
  }

  /// Returns the appropriate icon based on
  /// the available biometric type.
  ///
  /// Supports:
  /// - Face ID
  /// - Fingerprint
  /// - Generic device authentication
  IconData _getBiometricIcon() {
    if (_availableBiometrics.contains('Face ID')) {
      return HugeIcons.strokeRoundedFaceId;
    } else if (_availableBiometrics.contains('Fingerprint')) {
      return HugeIcons.strokeRoundedFingerPrint;
    } else {
      return HugeIcons.strokeRoundedLockPassword;
    }
  }

  /// Returns instruction text based on
  /// the detected biometric method.
  String _getBiometricSubtitle() {
    if (_availableBiometrics.contains('Face ID')) {
      return 'Look at your device to authenticate';
    } else if (_availableBiometrics.contains('Fingerprint')) {
      return 'Place your finger on the sensor';
    } else {
      return 'Use your device authentication';
    }
  }

  /// Disposes animation controller to prevent memory leaks.
  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  /// Builds the authentication screen header.
  ///
  /// Displays:
  /// - App title
  /// - Branding
  /// - Instruction message
  Widget _buildAuthHeader() {
    return Column(
      children: [
        Text(
          'App Locked',
          style: GoogleFonts.montserrat(
            fontWeight: FontWeight.w600,
            color: Colors.white,
            fontSize: 32,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: const Color(0xFFD32F2F),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                HugeIcons.strokeRoundedCustomerSupport,
                color: Colors.white,
                size: 18,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              'CRM Manager',
              style: GoogleFonts.montserrat(
                fontWeight: FontWeight.w600,
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          'Please authenticate to continue',
          style: TextStyle(
            color: Colors.white70,
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  /// Builds the loading state UI shown
  /// while authentication is in progress.
  Widget _buildAuthenticatingDisplay() {
    return Column(
      children: [
        const SizedBox(
          width: 32,
          height: 32,
          child: CircularProgressIndicator(
            strokeWidth: 3,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'Authenticating...',
          style: TextStyle(
            color: Colors.white70,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  /// Builds the retry interface shown
  /// when authentication fails.
  ///
  /// Displays:
  /// - Error message
  /// - Retry button
  /// - Optional skip button (if enabled)
  Widget _buildRetryButton() {
    return Column(
      children: [
        if (_errorMessage.isNotEmpty) ...[
          Icon(
            Icons.error_outline,
            size: 48,
            color: Colors.red.shade300,
          ),
          const SizedBox(height: 16),
          Text(
            _errorMessage,
            style: TextStyle(
              color: Colors.red.shade300,
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
        ],
        SizedBox(
          width: double.infinity,
          height: 48,
          child: ElevatedButton(
            onPressed: () {
              setState(() {
                _errorMessage = '';
              });
              _authenticateWithBiometrics();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.shade600,
              foregroundColor: Colors.white,
              overlayColor: Colors.transparent,
              surfaceTintColor: Colors.transparent,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              'Try Again',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        if (widget.allowSkip) ...[
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: TextButton(
              onPressed: widget.onSkip,
              style: TextButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: const BorderSide(
                    color: Colors.white30,
                    width: 1,
                  ),
                ),
              ),
              child: Text(
                'Skip for now',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.white70,
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }

  /// Builds the initial authentication prompt UI.
  ///
  /// Displays:
  /// - Biometric icon
  /// - Instruction text
  /// - Authenticate button
  Widget _buildInitialDisplay() {
    return Column(
      children: [
        AnimatedBuilder(
          animation: _pulseAnimation,
          builder: (context, child) {
            return Transform.scale(
              scale: _isAuthenticating ? _pulseAnimation.value : 1.0,
              child: Icon(
                _getBiometricIcon(),
                size: 48,
                color: Colors.white.withValues(alpha: 0.8),
              ),
            );
          },
        ),
        const SizedBox(height: 16),
        Text(
          _getBiometricSubtitle(),
          style: TextStyle(
            color: Colors.white70,
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 24),
        SizedBox(
          width: double.infinity,
          height: 48,
          child: ElevatedButton(
            onPressed: _authenticateWithBiometrics,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFD32F2F),
              foregroundColor: Colors.white,
              overlayColor: Colors.transparent,
              surfaceTintColor: Colors.transparent,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(_getBiometricIcon(), size: 16),
                const SizedBox(width: 8),
                Text(
                  'Authenticate',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  /// Builds the biometric authentication screen UI.
  ///
  /// Handles:
  /// - Background styling
  /// - Responsive layout
  /// - Conditional UI states:
  ///   - Authenticating
  ///   - Error
  ///   - Initial prompt
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
                image: const DecorationImage(
                  image: AssetImage('assets/loginbg.png'),
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(
                    Colors.black,
                    BlendMode.dstATop,
                  ),
                ),
              ),
            ),
          ),
          LayoutBuilder(
            builder: (context, viewportConstraints) {
              return SingleChildScrollView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 0.0),
                child: ConstrainedBox(
                  constraints:
                      BoxConstraints(minHeight: viewportConstraints.maxHeight),
                  child: Align(
                    alignment: const Alignment(0, -0.05),
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 400),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildAuthHeader(),
                          const SizedBox(height: 30),
                          Container(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 24.0),
                            child: Column(
                              children: [
                                const SizedBox(height: 20),
                                if (_isAuthenticating)
                                  _buildAuthenticatingDisplay()
                                else if (_errorMessage.isNotEmpty)
                                  _buildRetryButton()
                                else
                                  _buildInitialDisplay(),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
