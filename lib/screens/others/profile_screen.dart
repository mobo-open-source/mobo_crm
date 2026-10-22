import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:mobo_crm/utils/snackbar.dart';
import 'package:provider/provider.dart';
import 'package:mobo_crm/initilisation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mobo_crm/global_methods/services/mobile_field_compatibility_service.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:shimmer/shimmer.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../core/company/session/company_session_manager.dart';
import '../../core/navigation/data_loss_warning_dialog.dart';
import '../settings/screens/profile/provider/provider_profile.dart';
import '../../utils/globals.dart';

/// A screen that displays and allows editing of the user's profile information.
///
/// This screen fetches the user data from Odoo, caches it locally using
/// SharedPreferences, and lets users edit their own profile. Users can
/// update their profile image, personal information, and view related
/// company information.
///
/// Features:
/// - Displays user's profile photo, name, email, phone, mobile, website, and job title.
/// - Editable fields with validation (email and website).
/// - Shows related company and main company (non-editable).
/// - Supports image picking from camera or gallery.
/// - Offline caching using SharedPreferences.
/// - Shimmer effect while loading.
/// - Handles connectivity changes and displays errors via snackbars.
/// - Warns users about unsaved changes when navigating back.
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _isLoading = true;
  Map<String, dynamic>? _userData;
  Uint8List? _userAvatar;
  File? _pickedImageFile;
  String? _pickedImageBase64;
  final ImagePicker _picker = ImagePicker();
  static const String _cacheKeyUser = 'user_profile';
  static const String _cacheKeyUserWriteDate = 'user_profile_write_date';
  StreamSubscription<List<ConnectivityResult>>? _connectivitySub;
  bool _isEditMode = false;
  bool _isSaving = false;
  bool _isShowingLoadingDialog = false;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  /// Controllers for text fields.
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _websiteController = TextEditingController();
  final TextEditingController _functionController = TextEditingController();

  int? _partnerId;
  String? _relatedCompanyName;

  /// Loads cached user profile from SharedPreferences if available.
  Future<void> _loadCachedUser() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cached = prefs.getString(_cacheKeyUser);
      if (cached != null && cached.isNotEmpty && mounted) {
        final data = jsonDecode(cached) as Map<String, dynamic>;
        setState(() {
          _userData = data;
          final img = data['image_1920'];
          _userAvatar =
              (img is String && img.isNotEmpty) ? base64Decode(img) : null;
          _partnerId = data['partner_id'] is List &&
                  (data['partner_id'] as List).isNotEmpty
              ? data['partner_id'][0] as int?
              : null;
          _isLoading = false;
        });
        _updateControllers();
      }
    } catch (_) {}
  }

  void _startConnectivityListener() {
    _connectivitySub =
        Connectivity().onConnectivityChanged.listen((results) async {
      await _checkInternet();
    });
  }

  /// Checks if the device currently has an internet connection.
  Future<bool> _checkInternet() async {
    try {
      final result = await InternetAddress.lookup('one.one.one.one');
      if (result.isNotEmpty && result.first.rawAddress.isNotEmpty) {
        return true;
      }
    } catch (_) {}
    return false;
  }

  /// Normalizes a value for editing in a text field.
  ///
  /// Converts null, false, or empty values to an empty string.
  String _normalizeForEdit(dynamic value) {
    if (value == null) return '';
    if (value is bool) return value ? 'true' : '';
    final s = value.toString().trim();
    if (s.isEmpty) return '';
    if (s.toLowerCase() == 'false') return '';
    return s;
  }

  /// Updates all controllers with the current [_userData] values.
  void _updateControllers() {
    if (_userData != null) {
      _nameController.text = _normalizeForEdit(_userData!['name']);
      _emailController.text = _normalizeForEdit(_userData!['email']);
      _phoneController.text = _normalizeForEdit(_userData!['phone']);
      _mobileController.text = _normalizeForEdit(_userData!['mobile']);
      _websiteController.text = _normalizeForEdit(_userData!['website']);
      _functionController.text = _normalizeForEdit(_userData!['function']);
    }
  }

  /// Cancels edit mode and restores previous values.
  void _cancelEdit() {
    _updateControllers();
    setState(() => _isEditMode = false);
  }

  /// Checks if any editable field has unsaved changes.
  bool _hasUnsavedChanges() {
    if (_userData == null) return false;

    return _nameController.text.trim() !=
            _normalizeForEdit(_userData!['name']) ||
        _emailController.text.trim() !=
            _normalizeForEdit(_userData!['email']) ||
        _phoneController.text.trim() !=
            _normalizeForEdit(_userData!['phone']) ||
        _mobileController.text.trim() !=
            _normalizeForEdit(_userData!['mobile']) ||
        _websiteController.text.trim() !=
            _normalizeForEdit(_userData!['website']) ||
        _functionController.text.trim() !=
            _normalizeForEdit(_userData!['function']);
  }

  /// Resolves the `res.partner` record behind the logged-in user.
  ///
  /// Every editable field on this screen is stored on that partner, so its id
  /// is needed before saving. [_fetchUserProfile] normally fills it, but a
  /// screen restored from cache has to look it up.
  Future<int?> _resolvePartnerId(int uid) async {
    if (_partnerId != null) return _partnerId;
    final result = await MobileFieldCompatibilityService.safeRead(
      'res.users',
      uid,
      ['partner_id'],
    );
    if (result is List && result.isNotEmpty) {
      final partner = (result.first as Map)['partner_id'];
      if (partner is List && partner.isNotEmpty) {
        _partnerId = partner.first as int?;
      } else if (partner is int) {
        _partnerId = partner;
      }
    }
    return _partnerId;
  }

  /// Closes the "Saving Changes" dialog if it is still on screen.
  void _dismissLoadingDialog() {
    if (!_isShowingLoadingDialog) return;
    _isShowingLoadingDialog = false;
    if (!mounted) return;
    final navigator = Navigator.of(context, rootNavigator: true);
    if (navigator.canPop()) navigator.pop();
  }

  /// Saves all changes to the server and updates local cache.
  Future<void> _saveAllChanges() async {
    final prefs = await SharedPreferences.getInstance();
    final int? userId = prefs.getInt('userId');

    if (!_formKey.currentState!.validate()) {
      _showErrorSnackBar('Please fix the validation errors before saving');
      return;
    }

    if (!mounted) return;
    setState(() => _isSaving = true);
    _showLoadingDialog(context, 'Saving Changes');

    String? errorMessage;

    try {
      final uid = userId;

      if (uid == null) {
        throw Exception('user ID not found');
      }

      // Name, email, phone, mobile, website and job title are all delegated
      // from res.partner. res.users lets a user write its own record only for
      // a short self-service whitelist (name, email, image, language, …), so
      // sending the other fields to res.users raises an access error for
      // everyone who is not an administrator — which is why saving silently
      // failed for regular users. Writing the partner carries the same values
      // and is permitted for every internal user.
      final updates = <String, dynamic>{};
      void addIfChanged(String field, TextEditingController controller) {
        final value = controller.text.trim();
        if (value != _normalizeForEdit(_userData![field])) {
          updates[field] = value;
        }
      }

      addIfChanged('name', _nameController);
      addIfChanged('email', _emailController);
      addIfChanged('phone', _phoneController);
      addIfChanged('mobile', _mobileController);
      addIfChanged('website', _websiteController);
      addIfChanged('function', _functionController);

      if (updates.isNotEmpty) {
        final partnerId = await _resolvePartnerId(uid);
        if (partnerId == null) {
          throw Exception('no contact record is linked to this user');
        }

        // safeWrite folds `mobile` into `phone` on databases without the field.
        await MobileFieldCompatibilityService.safeWrite(
          'res.partner',
          [partnerId],
          updates,
        );
      }

      await _fetchUserProfile(forceRefresh: true);
      if (!mounted) return;
      setState(() => _isEditMode = false);

      // The settings card and its avatar read from the shared profile
      // provider, so refresh it too or the old name/email stays on screen.
      await context
          .read<ProfileConfigurationProvider>()
          .fetchUserProfileConfiguration();
    } catch (e) {
      errorMessage = 'Failed to save changes: $e';
    } finally {
      _dismissLoadingDialog();
      if (mounted) {
        setState(() => _isSaving = false);
        if (errorMessage != null) {
          _showErrorSnackBar(errorMessage);
        } else {
          _showSuccessSnackBar('Profile updated successfully');
        }
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _loadCachedUser();
    _fetchUserProfile();
    _startConnectivityListener();
  }

  @override
  void dispose() {
    _connectivitySub?.cancel();
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _mobileController.dispose();
    _websiteController.dispose();
    _functionController.dispose();
    super.dispose();
  }

  /// Shows a loading dialog with a given [message].
  void _showLoadingDialog(BuildContext context, String message) {
    if (_isShowingLoadingDialog || !mounted) return;
    _isShowingLoadingDialog = true;

    final isDark = Theme.of(context).brightness == Brightness.dark;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        backgroundColor: isDark ? const Color(0xFF212121) : Colors.white,
        elevation: 8,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: isDark
                      ? Colors.white.withValues(alpha: 0.12)
                      : AppStyle.primaryColor.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: LoadingAnimationWidget.fourRotatingDots(
                  color: AppStyle.primaryColor,
                  size: 32,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                message,
                style: Theme.of(ctx).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: isDark ? Colors.white : Colors.grey[900],
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                'Please wait while we process your request',
                style: Theme.of(ctx).textTheme.bodySmall?.copyWith(
                      color: isDark ? Colors.grey[400] : Colors.grey[600],
                    ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Shows an error snackbar with a given [message].
  void _showErrorSnackBar(String message) {
    if (!mounted) return;
    CustomSnackbar.showError(context, message);
  }

  /// Shows a success snackbar with a given [message].
  void _showSuccessSnackBar(String message) {
    if (!mounted) return;
    CustomSnackbar.showSuccess(context, message);
  }

  /// Shows a warning snackbar when a non-editable field is tapped.
  void _showNonEditableFieldSnackBar(String fieldName) {
    if (!mounted) return;

    CustomSnackbar.showWarning(
        context, '$fieldName cannot be modified from this screen');
  }

  /// Picks an image from camera or gallery and saves it.
  Future<void> _pickImageFromSource(ImageSource source) async {
    try {
      final picked = await _picker.pickImage(
        source: source,
        imageQuality: 80,
        maxWidth: 600,
      );
      if (picked == null || !mounted) return;

      setState(() => _pickedImageFile = File(picked.path));
      final bytes = await picked.readAsBytes();
      if (!mounted) return;

      setState(() => _pickedImageBase64 = base64Encode(bytes));

      await _saveImage();
      if (!mounted) return;
      // Keeps the settings card's avatar in step with this screen.
      await context
          .read<ProfileConfigurationProvider>()
          .fetchUserProfileConfiguration();
      if (mounted) {
        _showSuccessSnackBar('Image updated successfully');
      }
    } catch (e) {
      if (mounted) {
        _showErrorSnackBar('Failed to update image: $e');
      }
    }
  }

  /// Displays a bottom sheet to choose image source.
  void _showImageSourceActionSheet() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 8),
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: isDark ? Colors.grey[700] : Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.pop(context);
                _pickImageFromSource(ImageSource.camera);
              },
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                child: Row(
                  children: [
                    Icon(HugeIcons.strokeRoundedCamera02,
                        size: 24,
                        color: isDark ? Colors.white : Colors.black87),
                    const SizedBox(width: 16),
                    const Text('Take Photo', style: TextStyle(fontSize: 16)),
                  ],
                ),
              ),
            ),
            Divider(
                height: 1,
                thickness: 1,
                color: isDark ? Colors.grey[800] : Colors.grey[200]),
            InkWell(
              onTap: () {
                Navigator.pop(context);
                _pickImageFromSource(ImageSource.gallery);
              },
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                child: Row(
                  children: [
                    Icon(HugeIcons.strokeRoundedImageCrop,
                        size: 24,
                        color: isDark ? Colors.white : Colors.black87),
                    const SizedBox(width: 16),
                    const Text('Choose from Gallery',
                        style: TextStyle(fontSize: 16)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  /// Fetches the user's profile from the server.
  ///
  /// If [forceRefresh] is true, fetches data even if cached data exists.
  Future<void> _fetchUserProfile({bool forceRefresh = false}) async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('userId') ?? 0;
    if (!mounted) return;
    setState(() => _isLoading = _userData == null);

    try {
      final uid = userId;
      if (uid == 0) {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
        return;
      }

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

      Map<String, dynamic> userData;
      if (result is List && result.isNotEmpty) {
        userData = result.first as Map<String, dynamic>;
      } else {
        throw Exception('No user data returned');
      }

      if (mounted) {
        setState(() {
          _userData = userData;
          final img = userData['image_1920'];
          _userAvatar =
              (img is String && img.isNotEmpty) ? base64Decode(img) : null;
          _partnerId =
              userData['partner_id'] is List ? userData['partner_id'][0] : null;
          _isLoading = false;
        });
        _updateControllers();
        _loadRelatedCompany();

        try {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString(_cacheKeyUser, jsonEncode(userData));
          await prefs.setString(
              _cacheKeyUserWriteDate, userData['write_date']?.toString() ?? '');
        } catch (_) {}
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        String errorMessage = 'Failed to load profile';
        if (e.toString().contains('mobile')) {
          errorMessage =
              'Profile loaded successfully (mobile field compatibility handled)';
        } else {
          errorMessage =
              'Failed to load profile: ${e.toString().length > 100 ? '${e.toString().substring(0, 100)}...' : e.toString()}';
        }
        _showErrorSnackBar(errorMessage);
      }
    }
  }

  /// Loads the related company information based on the partner.
  Future<void> _loadRelatedCompany() async {
    if (_partnerId == null) {
      setState(() {
        _relatedCompanyName = null;
      });
      return;
    }
    try {
      final clientManager =
          Provider.of<OdooClientManager>(context, listen: false);
      final client = clientManager.client;
      if (client == null) return;

      final res = await CompanySessionManager.callKwWithCompany({
        'model': 'res.partner',
        'method': 'read',
        'args': [_partnerId],
        'kwargs': {
          'fields': ['parent_id', 'website', 'function', 'company_name'],
        },
      });

      if (!mounted) return;
      if (res is List && res.isNotEmpty) {
        final row = res.first as Map<String, dynamic>;

        if (mounted && _userData != null) {
          setState(() {
            if ((_userData!['website'] == null ||
                    _userData!['website'] == false) &&
                row['website'] != null &&
                row['website'] != false) {
              _userData!['website'] = row['website'];
              _websiteController.text = _normalizeForEdit(row['website']);
            }

            if ((_userData!['function'] == null ||
                    _userData!['function'] == false) &&
                row['function'] != null &&
                row['function'] != false) {
              _userData!['function'] = row['function'];
              _functionController.text = _normalizeForEdit(row['function']);
            }
          });
        }

        if (row['parent_id'] is List &&
            (row['parent_id'] as List).length >= 2 &&
            row['parent_id'][0] != null) {
          setState(() {
            _relatedCompanyName = row['parent_id'][1]?.toString();
          });
        } else {
          setState(() {
            _relatedCompanyName = null;
          });
        }
      }
    } catch (_) {}
  }

  /// Saves the user's profile image to the server.
  Future<void> _saveImage() async {
    if (_pickedImageBase64 == null) return;

    final clientManager =
        Provider.of<OdooClientManager>(context, listen: false);
    final client = clientManager.client;
    if (client == null) return;

    try {
      final uid = client.sessionId?.userId;
      if (uid == null) return;

      await CompanySessionManager.callKwWithCompany({
        'model': 'res.users',
        'method': 'write',
        'args': [
          [uid],
          {'image_1920': _pickedImageBase64},
        ],
        'kwargs': {},
      });

      await _fetchUserProfile(forceRefresh: true);
    } catch (e) {
      rethrow;
    }
  }

  /// Handles back navigation with unsaved changes warning.
  Future<void> _handleBack() async {
    if (_isEditMode && _hasUnsavedChanges()) {
      final shouldPop = await _showUnsavedChangesDialog(context);
      if (shouldPop && mounted) {
        Navigator.of(context).pop();
      }
      return;
    }
    if (mounted) {
      Navigator.of(context).pop();
    }
  }

  /// Shows a confirmation dialog for unsaved changes.
  Future<bool> _showUnsavedChangesDialog(BuildContext context) async {
    final result = await DataLossWarningDialog.show(
      context: context,
      title: 'Discard Changes?',
      message: 'You have unsaved changes. Do you want to discard them?',
      confirmText: 'Discard',
      cancelText: 'Keep Editing',
    );
    return result ?? false;
  }

  /// Builds a centered Lottie animation with optional title, subtitle, and button.
  Widget _buildCenteredLottie({
    required String lottie,
    required String title,
    String? subtitle,
    Widget? button,
    required bool isDark,
  }) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Lottie.asset(lottie, width: 260),
                  const SizedBox(height: 8),
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : const Color(0xFF1A1A1A),
                    ),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 6),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 14,
                        color: isDark ? Colors.white60 : Colors.black54,
                      ),
                    ),
                  ],
                  if (button != null) ...[const SizedBox(height: 12), button],
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  /// Builds an empty state widget with a ghost animation.
  Widget _buildEmptyState() {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return _buildCenteredLottie(
      lottie: 'assets/empty_ghost.json',
      title: 'No user data Found',
      isDark: isDark,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) async {
        if (!didPop) await _handleBack();
      },
      child: Scaffold(
        backgroundColor: isDark ? Colors.grey[900]! : Colors.white,
        appBar: AppBar(
          title: Text(
            'Profile Details',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Colors.black,
            ),
          ),
          leading: IconButton(
            onPressed: () async {
              await _handleBack();
            },
            icon: Icon(
              HugeIcons.strokeRoundedArrowLeft01,
              color: isDark ? Colors.white : Colors.black,
            ),
          ),
          actions: [
            if (_isEditMode)
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: TextButton(
                    onPressed: _isSaving ? null : _cancelEdit,
                  child: Text(
                    'Cancel',
                    style: TextStyle(
                      color: isDark ? Colors.grey[400] : Colors.grey[600],
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: TextButton(
                onPressed: _isSaving
                    ? null
                    : () {
                        if (_isEditMode) {
                          _saveAllChanges();
                        } else {
                          setState(() => _isEditMode = true);
                        }
                      },
                child: Text(
                  _isEditMode ? 'Save' : 'Edit',
                  style: TextStyle(
                    color: _isEditMode
                        ? (isDark ? Colors.white : Colors.black)
                        : (AppStyle.primaryColor),
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
              ),
            )
          ],
          backgroundColor: isDark ? Colors.grey[900]! : Colors.white,
          systemOverlayStyle:
              isDark ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark,
        ),
        body: _isLoading
            ? _buildShimmerLoading(isDark)
            : _userData == null
                ? Center(child: _buildEmptyState())
                : RefreshIndicator(
                    onRefresh: () => _fetchUserProfile(forceRefresh: true),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                             padding: const EdgeInsets.all(20),
                            child: Form(
                              key: _formKey,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _buildProfileImageSection(context, isDark),
                                  const SizedBox(height: 32),
                                  const Text(
                                    'Personal Information',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  _buildCustomTextField(
                                    context,
                                    'Full Name',
                                    _userData!['name']?.toString(),
                                    HugeIcons.strokeRoundedUserAccount,
                                    controller: _nameController,
                                    isRequired: true,
                                  ),
                                  const SizedBox(height: 16),
                                  _buildCustomTextField(
                                    context,
                                    'Email',
                                    _userData!['email']?.toString(),
                                    HugeIcons.strokeRoundedMail01,
                                    controller: _emailController,
                                    keyboardType: TextInputType.emailAddress,
                                    isRequired: true,
                                  ),
                                  const SizedBox(height: 16),
                                  _buildCustomTextField(
                                    context,
                                    'Phone',
                                    _userData!['phone']?.toString(),
                                    HugeIcons.strokeRoundedCall02,
                                    controller: _phoneController,
                                    keyboardType: TextInputType.phone,
                                  ),
                                  const SizedBox(height: 16),
                                  _buildCustomTextField(
                                    context,
                                    'Mobile',
                                    _userData!['mobile']?.toString(),
                                    HugeIcons.strokeRoundedSmartPhone01,
                                    controller: _mobileController,
                                    keyboardType: TextInputType.phone,
                                  ),
                                  const SizedBox(height: 16),
                                  _buildCustomTextField(
                                    context,
                                    'Website',
                                    _userData!['website']?.toString(),
                                    HugeIcons.strokeRoundedWebDesign02,
                                    controller: _websiteController,
                                    keyboardType: TextInputType.url,
                                  ),
                                  const SizedBox(height: 16),
                                  _buildCustomTextField(
                                    context,
                                    'Job Title',
                                    _userData!['function']?.toString(),
                                    HugeIcons.strokeRoundedWorkHistory,
                                    controller: _functionController,
                                  ),
                                  const SizedBox(height: 16),
                                  _buildCustomTextField(
                                    context,
                                    'Company',
                                    _userData!['company_id'] is List &&
                                            _userData!['company_id'].length > 1
                                        ? (_userData!['company_id'][1]
                                                ?.toString() ??
                                            '')
                                        : '',
                                    HugeIcons.strokeRoundedBuilding05,
                                    showNonEditableMessage: true,
                                  ),
                                  const SizedBox(height: 16),
                                  _buildCustomTextField(
                                    context,
                                    'Related Company',
                                    _relatedCompanyName,
                                    HugeIcons.strokeRoundedBuilding01,
                                    showNonEditableMessage: true,
                                  ),
                                  const SizedBox(height: 16),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
      ),
    );
  }

  /// Builds a shimmer loading effect while fetching data.
  Widget _buildShimmerLoading(bool isDark) {
    final shimmerBase = isDark ? Colors.grey[800]! : Colors.grey[300]!;
    final shimmerHighlight = isDark ? Colors.grey[700]! : Colors.grey[100]!;
    final cardColor = isDark ? Colors.grey[850]! : Colors.white;
    final placeholderColor = isDark ? Colors.grey[700]! : Colors.grey[300]!;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Shimmer.fromColors(
        baseColor: shimmerBase,
        highlightColor: shimmerHighlight,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 16,
                    spreadRadius: 2,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 90,
                    height: 90,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: placeholderColor,
                      border: Border.all(
                        color: isDark ? Colors.grey[800]! : Colors.grey[200]!,
                        width: 2,
                      ),
                    ),
                  ),
                  const SizedBox(width: 18),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 18,
                          width: 180,
                          margin: const EdgeInsets.only(bottom: 8),
                          decoration: BoxDecoration(
                            color: placeholderColor,
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                        Container(
                          height: 14,
                          width: 160,
                          margin: const EdgeInsets.only(bottom: 6),
                          decoration: BoxDecoration(
                            color: placeholderColor,
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                        Container(
                          height: 12,
                          width: 120,
                          decoration: BoxDecoration(
                            color: placeholderColor,
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            ...List.generate(5, (index) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: cardColor,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isDark
                          ? Colors.white.withValues(alpha: 0.08)
                          : Colors.black.withValues(alpha: 0.06),
                    ),
                  ),
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
                            Container(
                              height: 12,
                              width: 120,
                              margin: const EdgeInsets.only(bottom: 8),
                              decoration: BoxDecoration(
                                color: placeholderColor,
                                borderRadius: BorderRadius.circular(6),
                              ),
                            ),
                            Container(
                              height: 16,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: placeholderColor,
                                borderRadius: BorderRadius.circular(6),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  /// Builds a custom text field with label and icon.
  Widget _buildCustomTextField(
    BuildContext context,
    String labelText,
    String? value,
    IconData icon, {
    VoidCallback? onEdit,
    bool disabled = false,
    TextEditingController? controller,
    TextInputType? keyboardType,
    bool showNonEditableMessage = false,
    bool isRequired = false,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final displayValue = (value == null ||
            value.trim().isEmpty ||
            value.trim().toLowerCase() == 'false')
        ? 'Not set'
        : value;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text.rich(
          TextSpan(
            text: labelText,
            style: TextStyle(
              color: isDark ? Colors.white70 : const Color(0xff7F7F7F),
            ),
            children: [
              if (isRequired && _isEditMode)
                const TextSpan(
                  text: ' *',
                  style: TextStyle(
                      color: Colors.red, fontWeight: FontWeight.bold),
                ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        _isEditMode && controller != null && !disabled
            ? _buildEditableField(
                context, controller, keyboardType, labelText, isDark)
            : _buildDisplayField(context, displayValue, icon, isDark,
                onEdit: onEdit,
                labelText: labelText,
                showNonEditableMessage: showNonEditableMessage),
      ],
    );
  }

  /// Builds a display-only field for non-editable values.
  Widget _buildDisplayField(
      BuildContext context, String displayValue, IconData icon, bool isDark,
      {VoidCallback? onEdit,
      String? labelText,
      bool showNonEditableMessage = false}) {
    return GestureDetector(
      onTap: onEdit ??
          (showNonEditableMessage && labelText != null
              ? () {
                  if (mounted) {
                    _showNonEditableFieldSnackBar(labelText);
                  }
                }
              : null),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: isDark ? const Color(0xFF2A2A2A) : const Color(0xffF8FAFB),
          border: Border.all(color: Colors.transparent, width: 1),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              Icon(
                icon,
                color: isDark ? Colors.white70 : Colors.black45,
                size: 20,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  displayValue,
                  style: TextStyle(
                    color: displayValue == 'Not set'
                        ? (isDark ? Colors.grey[500] : Colors.grey[500])
                        : (isDark ? Colors.white70 : const Color(0xff000000)),
                    fontStyle: displayValue == 'Not set'
                        ? FontStyle.italic
                        : FontStyle.normal,
                    fontSize: 14,
                    height: 1.2,
                    letterSpacing: 0.0,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Builds an editable text field with validation.
  Widget _buildEditableField(
      BuildContext context,
      TextEditingController controller,
      TextInputType? keyboardType,
      String labelText,
      bool isDark) {
    return Focus(
      child: Builder(
        builder: (context) {
          final hasFocus = Focus.of(context).hasFocus;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: isDark ? const Color(0xFF2A2A2A) : const Color(0xffF8FAFB),
                  border: Border.all(
                    color: hasFocus ? AppStyle.primaryColor : Colors.transparent,
                    width: 1,
                  ),
                ),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  child: Row(
                    children: [
                      Icon(
                        _getIconForField(labelText),
                        color: hasFocus
                            ? AppStyle.primaryColor
                            : (isDark ? Colors.white70 : const Color(0xff7F7F7F)),
                        size: 20,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextFormField(
                          controller: controller,
                          keyboardType: keyboardType,
                          validator: _getValidatorForField(labelText),
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          style: TextStyle(
                            color: isDark
                                ? Colors.white70
                                : const Color(0xff000000),
                            fontSize: 14,
                            height: 1.2,
                            letterSpacing: 0.0,
                          ),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            errorBorder: InputBorder.none,
                            focusedErrorBorder: InputBorder.none,
                            hintText: controller.text.isEmpty
                                ? 'Enter $labelText'
                                : null,
                            hintStyle: TextStyle(
                              color:
                                  isDark ? Colors.grey[500] : Colors.grey[500],
                              fontStyle: FontStyle.italic,
                              fontSize: 14,
                              height: 1.2,
                              letterSpacing: 0.0,
                            ),
                            isDense: true,
                            contentPadding: EdgeInsets.zero,
                            errorStyle: const TextStyle(height: 0, fontSize: 0),
                          ),
                          cursorColor: isDark ? Colors.white70 : Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (_getValidatorForField(labelText) != null)
                _buildErrorMessage(controller, labelText, isDark),
            ],
          );
        },
      ),
    );
  }

  /// Returns the appropriate icon for a given field label.
  IconData _getIconForField(String labelText) {
    switch (labelText.toLowerCase()) {
      case 'full name':
        return HugeIcons.strokeRoundedUserAccount;
      case 'email':
        return HugeIcons.strokeRoundedMail01;
      case 'phone':
        return HugeIcons.strokeRoundedCall02;
      case 'mobile':
        return HugeIcons.strokeRoundedSmartPhone01;
      case 'website':
        return HugeIcons.strokeRoundedWebDesign02;
      case 'job title':
        return HugeIcons.strokeRoundedWorkHistory;
      default:
        return HugeIcons.strokeRoundedUserAccount;
    }
  }

  /// Returns a validator function for a given field label, if applicable.
  String? Function(String?)? _getValidatorForField(String labelText) {
    switch (labelText.toLowerCase()) {
      case 'full name':
        return (value) {
          if (value == null || value.trim().isEmpty) {
            return 'Full name is required';
          }
          return null;
        };
      case 'email':
        return (value) {
          if (value == null || value.trim().isEmpty) {
            return 'Email is required';
          }
          final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
          if (!emailRegex.hasMatch(value.trim())) {
            return 'Please enter a valid email address';
          }
          return null;
        };
      case 'website':
        return (value) {
          if (value == null || value.trim().isEmpty) return null;
          final urlRegex = RegExp(
              r'^(https?:\/\/)?(www\.)?[a-zA-Z0-9-]+(\.[a-zA-Z]{2,})+(\/.*)?$');
          if (!urlRegex.hasMatch(value.trim())) {
            return 'Please enter a valid website URL';
          }
          return null;
        };
      default:
        return null;
    }
  }

  /// Builds a widget to display validation error messages.
  Widget _buildErrorMessage(
      TextEditingController controller, String labelText, bool isDark) {
    return ValueListenableBuilder<TextEditingValue>(
      valueListenable: controller,
      builder: (context, value, child) {
        final validator = _getValidatorForField(labelText);
        final errorMessage = validator?.call(value.text);
        if (errorMessage == null) return const SizedBox.shrink();
        return Padding(
          padding: const EdgeInsets.only(top: 4, left: 4),
          child: Text(
            errorMessage,
            style: TextStyle(
              color: Colors.red[400],
              fontSize: 12,
              fontWeight: FontWeight.w400,
            ),
          ),
        );
      },
    );
  }

  /// Builds the profile image section with edit functionality.
  Widget _buildProfileImageSection(BuildContext context, bool isDark) {
    Widget photoWidget;
    if (_pickedImageFile != null) {
      photoWidget = ClipOval(
        child: Image.file(
          _pickedImageFile!,
          width: 120,
          height: 120,
          fit: BoxFit.cover,
        ),
      );
    } else if (_userAvatar != null) {
      photoWidget = ClipOval(
        child: Image.memory(
          _userAvatar!,
          width: 120,
          height: 120,
          fit: BoxFit.cover,
        ),
      );
    } else {
      final placeholderColor = isDark ? Colors.grey[700]! : Colors.grey[300]!;
      photoWidget = Container(
        width: 120,
        height: 120,
        decoration: BoxDecoration(
          color: placeholderColor,
          shape: BoxShape.circle,
        ),
        child: Icon(
          HugeIcons.strokeRoundedUserAccount,
          size: 60,
          color: isDark ? Colors.grey[500] : Colors.grey[600],
        ),
      );
    }

    return Center(
      child: Column(
        children: [
          GestureDetector(
            onTap: (!_isEditMode && _userAvatar != null) ? () {} : null,
            child: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isDark ? Colors.grey[600]! : Colors.grey[300]!,
                      width: 3,
                    ),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black.withValues(alpha: 0.08),
                          blurRadius: 16,
                          offset: const Offset(0, 6),
                          spreadRadius: 2),
                    ],
                  ),
                  child: photoWidget,
                ),
                if (_isEditMode)
                  Positioned(
                    bottom: 2,
                    right: 8,
                    child: InkWell(
                      onTap: _showImageSourceActionSheet,
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: AppStyle.primaryColor,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: isDark ? Colors.grey[900]! : Colors.white,
                            width: 3,
                          ),
                        ),
                        child: const Icon(
                          HugeIcons.strokeRoundedCamera02,
                          color: Colors.white,
                          size: 18,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 6),
          if (_userData != null && _normalizeForEdit(_userData!['name']).isNotEmpty)
            Text(
              _normalizeForEdit(_userData!['name']),
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w400,
                color: isDark ? Colors.grey[400] : Colors.grey[800],
                letterSpacing: 0.1,
              ),
              textAlign: TextAlign.center,
            ),
        ],
      ),
    );
  }
}
