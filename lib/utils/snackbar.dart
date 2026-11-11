import 'dart:async';

import 'package:flutter/material.dart';

import '../../core/colors/app_colors.dart';
import '../../core/navigation/global_keys.dart';

/// Defines supported snackbar visual categories.
/// Used to decide icon, color and semantic meaning.
enum SnackbarType { info, success, warning, error }

/// Custom snackbar utility with consistent styling, icons, and colors.
///
/// Features:
///   - Four types: info, success, warning, error
///   - Floating style with rounded corners
///   - Icon + title + message layout
///   - Dark/light mode aware colors
///   - Safe to call from anywhere (uses global ScaffoldMessenger key)
///   - Shown **above dialogs, bottom sheets and menus** when one is open
///   - Convenience methods: showSuccess, showError, showInfo, showWarning
///
/// A SnackBar lives in the page's Scaffold, and every dialog, bottom sheet and
/// popup menu is a route drawn *over* that Scaffold, so a plain SnackBar raised
/// while one is open appears underneath it where nobody can see it. In that
/// case the message is put on the root navigator's overlay instead, which is
/// drawn above every route. With nothing modal on screen the regular SnackBar
/// is used, so its position and behaviour are unchanged.
///
/// Usage:
/// ```dart
/// CustomSnackbar.showSuccess(context, 'Profile updated!');
/// CustomSnackbar.showError(context, 'Failed to connect to server');
/// ```
class CustomSnackbar {
  /// Shows a custom snackbar with title, message, type, and optional duration.
  ///
  /// Uses global `scaffoldMessengerKey` to display even from non-widget contexts.
  /// Safe: checks mounted state and wraps in post-frame callback.
  static void show({
    required BuildContext context,
    required String title,
    required String message,
    SnackbarType type = SnackbarType.info,
    Duration duration = const Duration(seconds: 3),
  }) {
    try {
      if (!context.mounted) {
        return;
      }
      Theme.of(context);
    } catch (e) {
      return;
    }

    // Looked up now, while [context] is known to be valid: the callback below
    // runs after the frame, by which time the caller may already be gone (a
    // dialog that reports an error and closes straight away).
    final NavigatorState? navigator = _rootNavigator(context);

    void tryShow() {
      try {
        if (navigator != null &&
            navigator.mounted &&
            _isModalOnTop(navigator) &&
            _showAboveModal(navigator, title, message, type, duration)) {
          return;
        }

        final ScaffoldMessengerState? messenger =
            scaffoldMessengerKey.currentState;
        if (messenger == null || !messenger.mounted) {
          return;
        }

        BuildContext? themeCtx;
        try {
          themeCtx = navigatorKey.currentContext;
          if (themeCtx != null && themeCtx.mounted) {
            Theme.of(themeCtx);
          } else {
            themeCtx = null;
          }
        } catch (e) {
          themeCtx = null;
        }

        _showWithMessenger(messenger, themeCtx, title, message, type, duration);
      } catch (_) {}
    }

    WidgetsBinding.instance.addPostFrameCallback((_) => tryShow());
  }

  // ── above dialogs, sheets and menus ──────────────────────────────────────

  /// The toast currently on screen, so a new one can replace it (as showing a
  /// new SnackBar replaces the previous one).
  static OverlayEntry? _toastEntry;

  static NavigatorState? _rootNavigator(BuildContext context) {
    try {
      return Navigator.maybeOf(context, rootNavigator: true);
    } catch (_) {
      return null;
    }
  }

  /// True when the topmost route is a dialog, bottom sheet or popup menu.
  ///
  /// `popUntil` examines the topmost route first and stops as soon as the
  /// predicate says so, so returning true straight away pops nothing: it is
  /// simply the way to read the top route.
  static bool _isModalOnTop(NavigatorState navigator) {
    Route<dynamic>? top;
    navigator.popUntil((route) {
      top = route;
      return true;
    });
    return top is PopupRoute;
  }

  /// Puts the message on the root overlay. Returns false if that was not
  /// possible, so the caller can fall back to the regular SnackBar.
  static bool _showAboveModal(
    NavigatorState navigator,
    String title,
    String message,
    SnackbarType type,
    Duration duration,
  ) {
    final overlay = navigator.overlay;
    if (overlay == null) return false;

    _removeToast();

    // Long messages (an access-rights explanation, say) need longer to read.
    final visibleFor = message.length > 70
        ? duration + const Duration(seconds: 2)
        : duration;

    late final OverlayEntry entry;
    entry = OverlayEntry(
      builder: (overlayContext) {
        final isDark = Theme.of(overlayContext).brightness == Brightness.dark;
        return Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: SafeArea(
            bottom: false,
            child: Align(
              alignment: Alignment.topCenter,
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 560),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                  child: _ToastCard(
                    colors: _getColorsForType(type, isDark),
                    title: title,
                    message: message,
                    isDark: isDark,
                    visibleFor: visibleFor,
                    onClosed: () {
                      if (identical(_toastEntry, entry)) _removeToast();
                    },
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );

    try {
      overlay.insert(entry);
      _toastEntry = entry;
      return true;
    } catch (_) {
      return false;
    }
  }

  static void _removeToast() {
    final entry = _toastEntry;
    _toastEntry = null;
    if (entry == null) return;
    try {
      entry.remove();
    } catch (_) {}
    try {
      entry.dispose();
    } catch (_) {}
  }

  // ── regular SnackBar ─────────────────────────────────────────────────────

  static void _showWithMessenger(
      ScaffoldMessengerState messenger,
      BuildContext? themeContext,
      String title,
      String message,
      SnackbarType type,
      Duration duration,
      ) {
    try {
      if (!messenger.mounted) {
        return;
      }

      bool isDark = false;
      if (themeContext != null && themeContext.mounted) {
        try {
          isDark = Theme.of(themeContext).brightness == Brightness.dark;
        } catch (e) {
          isDark = false;
        }
      }
      final colors = _getColorsForType(type, isDark);

      if (!messenger.mounted) {
        return;
      }

      try {
        messenger.hideCurrentSnackBar();
      } catch (_) {}

      try {
        messenger.showSnackBar(
          SnackBar(
            content: _buildContent(colors, title, message, isDark),
            backgroundColor: colors.backgroundColor,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            duration: duration,
            elevation: 8,
          ),
        );
      } catch (_) {}
    } catch (_) {}
  }

  /// Icon + title + message, shared by the SnackBar and the toast so both
  /// look the same.
  static Widget _buildContent(
    _SnackbarColors colors,
    String title,
    String message,
    bool isDark,
  ) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: colors.iconBackgroundColor,
            shape: BoxShape.circle,
          ),
          child: Icon(colors.icon, size: 16, color: colors.iconColor),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                message,
                style: TextStyle(
                  fontSize: 12,
                  color: isDark ? Colors.grey[300] : Colors.grey[100],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// Internal helper: returns icon + colors for each snackbar type
  static _SnackbarColors _getColorsForType(SnackbarType type, bool isDark) {
    switch (type) {
      case SnackbarType.info:
        return _SnackbarColors(
          icon: Icons.info_outline,
          iconColor: Colors.blue[300]!,
          iconBackgroundColor: Colors.blue.withValues(alpha: 0.2),
          backgroundColor: isDark
              ? AppColors.infoBackgroundDark
              : AppColors.infoBackgroundLight,
        );
      case SnackbarType.success:
        return _SnackbarColors(
          icon: Icons.check_circle_outline,
          iconColor: Colors.green[300]!,
          iconBackgroundColor: Colors.green.withValues(alpha: 0.2),
          backgroundColor: isDark
              ? AppColors.successBackgroundDark
              : AppColors.successBackgroundLight,
        );
      case SnackbarType.warning:
        return _SnackbarColors(
          icon: Icons.warning_outlined,
          iconColor: Colors.orange[300]!,
          iconBackgroundColor: Colors.orange.withValues(alpha: 0.2),
          backgroundColor: isDark
              ? AppColors.warningBackgroundDark
              : AppColors.warningBackgroundLight,
        );
      case SnackbarType.error:
        return _SnackbarColors(
          icon: Icons.error_outline,
          iconColor: Colors.red[300]!,
          iconBackgroundColor: Colors.red.withValues(alpha: 0.2),
          backgroundColor: isDark
              ? AppColors.errorBackgroundDark
              : AppColors.errorBackgroundLight,
        );
    }
  }

  static void showSuccess(BuildContext context, String message) {
    show(
      context: context,
      title: 'Success',
      message: message,
      type: SnackbarType.success,
    );
  }

  static void showError(BuildContext context, String message) {
    show(
      context: context,
      title: 'Error',
      message: message,
      type: SnackbarType.error,
    );
  }

  static void showInfo(BuildContext context, String message) {
    show(
      context: context,
      title: 'Info',
      message: message,
      type: SnackbarType.info,
    );
  }

  static void showWarning(BuildContext context, String message) {
    show(
      context: context,
      title: 'Warning',
      message: message,
      type: SnackbarType.warning,
    );
  }
}

/// The message card shown on the root overlay while a dialog, sheet or menu is
/// open. Slides in from the top, stays for [visibleFor], and can be tapped
/// away. Mirrors the look of the floating SnackBar.
class _ToastCard extends StatefulWidget {
  const _ToastCard({
    required this.colors,
    required this.title,
    required this.message,
    required this.isDark,
    required this.visibleFor,
    required this.onClosed,
  });

  final _SnackbarColors colors;
  final String title;
  final String message;
  final bool isDark;
  final Duration visibleFor;

  /// Called once the card has finished leaving, so its overlay entry can go.
  final VoidCallback onClosed;

  @override
  State<_ToastCard> createState() => _ToastCardState();
}

class _ToastCardState extends State<_ToastCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<Offset> _slide;
  Timer? _timer;
  bool _closing = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 220),
    );
    _slide = Tween<Offset>(
      begin: const Offset(0, -0.6),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _controller.forward();
    _timer = Timer(widget.visibleFor, _close);
  }

  Future<void> _close() async {
    if (_closing || !mounted) return;
    _closing = true;
    _timer?.cancel();
    try {
      await _controller.reverse();
    } catch (_) {}
    widget.onClosed();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _slide,
      child: FadeTransition(
        opacity: _controller,
        child: Semantics(
          liveRegion: true,
          // Material gives the text its theme font and, being transparent,
          // draws nothing of its own; the overlay has no Material ancestor.
          child: Material(
            type: MaterialType.transparency,
            child: GestureDetector(
              onTap: _close,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  color: widget.colors.backgroundColor,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x33000000),
                      blurRadius: 16,
                      offset: Offset(0, 6),
                    ),
                  ],
                ),
                child: CustomSnackbar._buildContent(
                  widget.colors,
                  widget.title,
                  widget.message,
                  widget.isDark,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Internal color/icon bundle for each snackbar type
class _SnackbarColors {
  final IconData icon;
  final Color iconColor;
  final Color iconBackgroundColor;
  final Color backgroundColor;

  _SnackbarColors({
    required this.icon,
    required this.iconColor,
    required this.iconBackgroundColor,
    required this.backgroundColor,
  });
}
