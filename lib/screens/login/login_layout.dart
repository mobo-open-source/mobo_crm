import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hugeicons/hugeicons.dart';

/// A reusable layout wrapper for authentication screens (Login, OTP, Reset, etc).
///
/// This widget:
/// - Renders a themed background with an optional image
/// - Shows the app logo and title at the top
/// - Centers the provided [child] widget in a constrained container
/// - Applies a custom [InputDecorationTheme] for form fields
/// - Optionally displays a floating [backButton]
///
/// Used to keep all auth screens visually consistent.
class LoginLayout extends StatelessWidget {
  final String title;
  final String subtitle;
  final Widget child;
  final Widget? backButton;

  const LoginLayout({
    super.key,
    required this.title,
    required this.subtitle,
    required this.child,
    this.backButton,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      body: Stack(children: [
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              color: isDark ? Colors.grey[950] : Colors.grey[50],
              image: DecorationImage(
                image: AssetImage('assets/loginbg.png'),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                  isDark
                      ? Colors.black.withValues(alpha: 1)
                      : Colors.white.withValues(alpha: 1),
                  BlendMode.dstATop,
                ),
                onError: (exception, stackTrace) {},
              ),
            ),
          ),
        ),
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(top: 80),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/whitecrm.png',
                  width: 36,
                  height: 36,
                  fit: BoxFit.fitWidth,
                  errorBuilder: (context, error, stackTrace) {
                    return Icon(
                      Icons.business,
                      color: Color(0xFFB85450),
                      size: 28,
                    );
                  },
                ),
                const SizedBox(width: 12),
                Text(
                  'mobo crm',
                  style: TextStyle(
                      fontFamily: "YaroRg", fontSize: 28, color: Colors.white),
                ),
              ],
            ),
          ),
        ),
        SafeArea(
          child: LayoutBuilder(
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
                          const SizedBox(height: 100),
                          _buildSignInHeader(),
                          const SizedBox(height: 40),
                          Container(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 24.0),
                            child: Theme(
                              data: Theme.of(context).copyWith(
                                inputDecorationTheme: Theme.of(context)
                                    .inputDecorationTheme
                                    .copyWith(
                                      errorStyle: const TextStyle(
                                        color: Colors.white,
                                      ),
                                      errorBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: BorderSide(
                                          color: Colors.red[900]!,
                                          width: 1.0,
                                        ),
                                      ),
                                      focusedErrorBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: const BorderSide(
                                          color: Colors.white,
                                          width: 1.5,
                                        ),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: BorderSide.none,
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: BorderSide.none,
                                      ),
                                    ),
                              ),
                              child: child,
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
        ),
        if (backButton != null) backButton!,
      ]),
    );
  }

  Widget _buildSignInHeader() {
    return Column(
      children: [
        Text(
          title,
          style: GoogleFonts.manrope(
            fontWeight: FontWeight.w600,
            color: Colors.white,
            fontSize: 26,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 12),
        Text(
          subtitle,
          style: GoogleFonts.manrope(
            color: Colors.white70,
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

/// A styled text form field used in authentication screens.
///
/// Supports:
/// - Prefix icon and optional suffix icon
/// - Validation and autovalidation
/// - Obscured text (for passwords)
/// - Disabled state
/// - Autofocus and autofill hints
///
/// Automatically displays an error icon when [hasError] is true.
class LoginTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final IconData prefixIcon;
  final TextInputType? keyboardType;
  final bool obscureText;
  final bool enabled;
  final String? Function(String?)? validator;
  final Widget? suffixIcon;
  final bool hasError;
  final ValueChanged<String>? onChanged;
  final AutovalidateMode? autovalidateMode;
  final FocusNode? focusNode;
  final bool autofocus;
  final List<String>? autofillHints;

  const LoginTextField({
    super.key,
    required this.controller,
    required this.hint,
    required this.prefixIcon,
    this.keyboardType,
    this.obscureText = false,
    this.enabled = true,
    this.validator,
    this.suffixIcon,
    this.hasError = false,
    this.onChanged,
    this.autovalidateMode,
    this.focusNode,
    this.autofocus = false,
    this.autofillHints,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      cursorColor: Colors.black,
      style: GoogleFonts.manrope(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: Colors.black,
      ),
      controller: controller,
      autofillHints: autofillHints,
      focusNode: focusNode,
      autofocus: autofocus,
      keyboardType: keyboardType,
      obscureText: obscureText,
      enabled: enabled,
      validator: validator,
      autovalidateMode: autovalidateMode,
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: GoogleFonts.manrope(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: Colors.black.withValues(alpha: .4)),
        prefixIcon: Icon(prefixIcon, size: 20),
        prefixIconColor: MaterialStateColor.resolveWith(
          (states) => states.contains(MaterialState.disabled)
              ? Colors.black26
              : Colors.black54,
        ),
        suffixIcon: hasError
            ? Icon(
                Icons.error_outline,
                color: Colors.red,
                size: 20,
              )
            : suffixIcon,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        filled: true,
        fillColor: Colors.white,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      ),
    );
  }
}

/// A dropdown form field for selecting a database or environment.
///
/// Features:
/// - Removes duplicate values from [items]
/// - Displays validation errors using a suffix icon
/// - Can be disabled by passing null to [onChanged]
/// - Styled to match other login form fields
///
/// Useful for selecting a database fetched from server.
class LoginDropdownField extends StatelessWidget {
  final String hint;
  final String? value;
  final List<String> items;
  final void Function(String?)? onChanged;
  final String? Function(String?)? validator;
  final bool hasError;
  final AutovalidateMode? autovalidateMode;

  const LoginDropdownField({
    super.key,
    required this.hint,
    required this.value,
    required this.items,
    required this.onChanged,
    required this.validator,
    this.hasError = false,
    this.autovalidateMode,
  });

  @override
  Widget build(BuildContext context) {
    final uniqueItems = items.toSet().toList();
    final safeValue = uniqueItems.contains(value) ? value : null;
    final bool isEnabled = onChanged != null;

    return DropdownButtonHideUnderline(
      child: DropdownButtonFormField2<String>(
        value: safeValue,
        isExpanded: true,
        hint: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            hint,
            style: GoogleFonts.manrope(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: Colors.black.withValues(alpha: .4),
            ),
          ),
        ),
        decoration: InputDecoration(
          enabled: isEnabled,
          prefixIcon: Padding(
            padding: const EdgeInsets.only(left: 2),
            child: Transform.translate(
              offset: const Offset(7, 0),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    HugeIcons.strokeRoundedDatabase,
                    size: 20,
                    color: Colors.black54,
                  ),
                  SizedBox(width: 0),
                ],
              ),
            ),
          ),
          prefixIconConstraints: const BoxConstraints(
            minWidth: 0,
            minHeight: 0,
            maxWidth: 30,
          ),
          contentPadding: const EdgeInsets.fromLTRB(-4, 14, 14, 14),
          suffixIcon: (hasError && (safeValue == null || safeValue.isEmpty))
              ? Icon(
                  HugeIcons.strokeRoundedAlertCircle,
                  color: Colors.red[900],
                  size: 20,
                )
              : null,
          isDense: true,
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
        ),
        items: uniqueItems.map((String item) {
          return DropdownMenuItem<String>(
            value: item,
            child: Text(
              item,
              style: GoogleFonts.manrope(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: Colors.black,
              ),
            ),
          );
        }).toList(),
        onChanged: isEnabled ? onChanged : null,
        validator: validator,
        dropdownStyleData: DropdownStyleData(
          maxHeight: 200,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: Colors.white,
          ),
          offset: const Offset(0, -4),
        ),
        iconStyleData: IconStyleData(
          icon: Icon(
            Icons.keyboard_arrow_down_rounded,
            color: isEnabled ? Colors.black54 : Colors.black26,
          ),
        ),
      ),
    );
  }
}

/// Displays animated login-related error messages.
///
/// This widget:
/// - Animates error visibility using [AnimatedSwitcher]
/// - Shows an alert icon with the error message
/// - Collapses when [error] is null
///
/// Typically placed below form fields.
class LoginErrorDisplay extends StatelessWidget {
  final String? error;

  const LoginErrorDisplay({
    super.key,
    required this.error,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 320),
        switchInCurve: Curves.easeOut,
        switchOutCurve: Curves.easeIn,
        child: error != null
            ? Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(HugeIcons.strokeRoundedAlertCircle,
                        color: Colors.white, size: 18),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        error!,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ],
                ),
              )
            : const SizedBox.shrink(),
      ),
    );
  }
}

/// URL input field with protocol selector and history dropdown.
///
/// Features:
/// - Supports protocol selection (http / https)
/// - Displays previously used URLs in an overlay dropdown
/// - Shows a loading indicator while validating URL
/// - Displays error state using suffix icon
/// - Automatically hides history when exact match is typed
///
/// Useful for server/instance URL input during login.
class LoginUrlTextField extends StatefulWidget {
  final TextEditingController controller;
  final String hint;
  final IconData prefixIcon;
  final bool enabled;
  final String? Function(String?)? validator;
  final bool hasError;
  final ValueChanged<String>? onChanged;
  final AutovalidateMode? autovalidateMode;
  final FocusNode? focusNode;
  final bool autofocus;
  final String selectedProtocol;
  final ValueChanged<String>? onProtocolChanged;
  final List<String> urlHistory;
  final bool isLoading;
  final ValueChanged<String>? onHistorySelected;

  const LoginUrlTextField({
    super.key,
    required this.controller,
    required this.hint,
    required this.prefixIcon,
    this.enabled = true,
    this.validator,
    this.hasError = false,
    this.onChanged,
    this.autovalidateMode,
    this.focusNode,
    this.autofocus = false,
    this.selectedProtocol = 'https://',
    this.onProtocolChanged,
    this.urlHistory = const [],
    this.isLoading = false,
    this.onHistorySelected,
  });

  @override
  State<LoginUrlTextField> createState() => _LoginUrlTextFieldState();
}

/// Internal state for [LoginUrlTextField].
///
/// Handles:
/// - Focus tracking
/// - Overlay dropdown creation/removal
/// - URL normalization and matching
/// - Dropdown positioning using [CompositedTransformFollower]
class _LoginUrlTextFieldState extends State<LoginUrlTextField> {
  late FocusNode _focusNode;
  bool _showDropdown = false;
  OverlayEntry? _overlayEntry;
  final LayerLink _layerLink = LayerLink();

  @override
  void initState() {
    super.initState();
    _focusNode = widget.focusNode ?? FocusNode();
    _focusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    if (_overlayEntry != null) {
      _overlayEntry!.remove();
      _overlayEntry = null;
    }

    if (widget.focusNode == null) {
      _focusNode.dispose();
    } else {
      _focusNode.removeListener(_onFocusChange);
    }
    super.dispose();
  }

  String _normalizeUrl(String url) {
    return url.replaceFirst(RegExp(r'^https?://'), '').trim().toLowerCase();
  }

  bool _isExactHistoryMatch(String input) {
    final normalizedInput = _normalizeUrl(input);

    return widget.urlHistory.any((historyUrl) {
      return _normalizeUrl(historyUrl) == normalizedInput;
    });
  }

  void _onFocusChange() {
    if (_focusNode.hasFocus && widget.urlHistory.isNotEmpty && widget.enabled) {
      _showHistoryDropdown();
    } else {
      _hideDropdown();
    }
  }

  void _showHistoryDropdown() {
    if (_overlayEntry != null) return;

    _overlayEntry = _createOverlayEntry();
    Overlay.of(context).insert(_overlayEntry!);
    setState(() {
      _showDropdown = true;
    });
  }

  void _hideDropdown() {
    if (_overlayEntry != null) {
      _overlayEntry!.remove();
      _overlayEntry = null;
    }
    if (mounted) {
      setState(() {
        _showDropdown = false;
      });
    }
  }

  OverlayEntry _createOverlayEntry() {
    RenderBox renderBox = context.findRenderObject() as RenderBox;
    var size = renderBox.size;

    return OverlayEntry(
      builder: (context) => Positioned(
        width: size.width,
        child: CompositedTransformFollower(
          link: _layerLink,
          showWhenUnlinked: false,
          offset: Offset(0.0, size.height + 4),
          child: Material(
            elevation: 8,
            borderRadius: BorderRadius.circular(12),
            color: Colors.white,
            child: Container(
              constraints: const BoxConstraints(
                maxHeight: 200,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Colors.black.withValues(alpha: 0.1),
                  width: 1,
                ),
              ),
              child: ListView.builder(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                itemCount: widget.urlHistory.length,
                itemBuilder: (context, index) {
                  final url = widget.urlHistory[index];
                  String displayUrl = url;

                  return InkWell(
                    onTap: () {
                      _selectUrl(url);
                    },
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              displayUrl,
                              style: GoogleFonts.manrope(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: Colors.black87,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _selectUrl(String selectedUrl) {
    String protocol = 'https://';
    String cleanUrl = selectedUrl;
    _hideDropdown();
    widget.onProtocolChanged?.call(protocol);
    widget.controller.text = selectedUrl;
    widget.onChanged?.call(cleanUrl);
    widget.onHistorySelected?.call(selectedUrl);
    Future.delayed(const Duration(milliseconds: 100), () {
      if (mounted) {
        _focusNode.unfocus();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CompositedTransformTarget(
          link: _layerLink,
          child: TextFormField(
            cursorColor: Colors.black,
            style: GoogleFonts.manrope(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: Colors.black,
            ),
            controller: widget.controller,
            focusNode: _focusNode,
            autofocus: widget.autofocus,
            enabled: widget.enabled,
            validator: widget.validator,
            autovalidateMode: widget.autovalidateMode,
            onChanged: (value) {
              widget.onChanged?.call(value);

              if (_isExactHistoryMatch(value)) {
                _hideDropdown();
              } else if (_focusNode.hasFocus &&
                  widget.urlHistory.isNotEmpty &&
                  widget.enabled) {
                _showHistoryDropdown();
              }
            },
            decoration: InputDecoration(
              hintText: widget.hint,
              hintStyle: GoogleFonts.manrope(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Colors.black.withValues(alpha: .4)),
              prefixIcon: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 12, right: 8),
                    child: Icon(
                      widget.prefixIcon,
                      size: 20,
                      color: widget.enabled ? Colors.black54 : Colors.black26,
                    ),
                  ),
                  Container(
                    height: 48,
                    width: 72,
                    decoration: BoxDecoration(
                      border: Border(
                        right: BorderSide(
                          color: Colors.black.withValues(alpha: 0.2),
                          width: 1,
                        ),
                      ),
                    ),
                    child: PopupMenuButton<String>(
                      enabled: widget.enabled,
                      initialValue: widget.selectedProtocol,
                      padding: EdgeInsets.zero,
                      color: Colors.white,
                      constraints: const BoxConstraints(
                        minWidth: 72,
                        maxWidth: 72,
                      ),
                      itemBuilder: (context) => ['http://', 'https://']
                          .map((p) => PopupMenuItem<String>(
                                value: p,
                                child: Text(
                                  p,
                                  style: GoogleFonts.manrope(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black,
                                  ),
                                ),
                              ))
                          .toList(),
                      onSelected: (value) =>
                          widget.onProtocolChanged?.call(value),
                      child: Container(
                        height: 48,
                        width: 85,
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        alignment: Alignment.center,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Flexible(
                              child: Text(
                                widget.selectedProtocol,
                                style: GoogleFonts.manrope(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: widget.enabled
                                      ? Colors.black
                                      : Colors.black26,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(width: 2),
                            Icon(
                              Icons.keyboard_arrow_down,
                              size: 14,
                              color: widget.enabled
                                  ? Colors.black54
                                  : Colors.black26,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                ],
              ),
              prefixIconConstraints: const BoxConstraints(
                minWidth: 0,
                minHeight: 0,
              ),
              suffixIcon: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (widget.isLoading)
                    Padding(
                      padding: const EdgeInsets.only(right: 20),
                      child: SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.black54),
                        ),
                      ),
                    )
                  else if (widget.hasError && !widget.isLoading)
                    Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: Icon(
                        Icons.error_outline,
                        color: Colors.red,
                        size: 20,
                      ),
                    ),
                ],
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.only(
                left: 0,
                right: 20,
                top: 16,
                bottom: 16,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// Primary action button for authentication screens.
///
/// This button:
/// - Supports loading state
/// - Disables itself when loading or [onPressed] is null
/// - Allows injecting a custom [loadingWidget]
/// - Matches the login UI theme
///
/// Commonly used for Login / Continue / Verify actions.
class LoginButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final Widget? loadingWidget;
  final bool isEnabled;

  const LoginButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.loadingWidget,
    this.isEnabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final bool isInteractive = isEnabled && !isLoading && onPressed != null;

    return SizedBox(
      height: 48,
      child: ElevatedButton(
        onPressed: isInteractive ? onPressed : null,
        style: ElevatedButton.styleFrom(
          backgroundColor:
              isInteractive ? Colors.black : Colors.black.withValues(alpha: 0.3),
          foregroundColor: Colors.white,
          disabledBackgroundColor: Colors.black.withValues(alpha: 0.2),
          disabledForegroundColor: Colors.white,
          overlayColor: Colors.transparent,
          surfaceTintColor: Colors.transparent,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: isLoading && loadingWidget != null
            ? loadingWidget!
            : Text(
                text,
                style: GoogleFonts.manrope(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
      ),
    );
  }
}
