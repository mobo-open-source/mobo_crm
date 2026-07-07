import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobo_crm/global_methods/services/isar_caching_service.dart';

import 'package:mobo_crm/models/models.dart';
import 'package:mobo_crm/global_methods/services/global_error_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../../core/company/session/company_session_manager.dart';
import '../../../../../utils/snackbar.dart';
import '../isar/profile_model_isar.dart';

/// Provides the configuration and management of a user's profile.
///
/// This provider handles:
/// - Fetching the profile from Odoo or Isar cache.
/// - Updating user and partner fields in Odoo.
/// - Selecting and encoding profile images.
/// - Managing text controllers for profile editing.
/// - Handling loading, saving, and error states.
///
/// It uses [ChangeNotifier] to notify listeners when profile data changes.
class ProfileConfigurationProvider extends ChangeNotifier {
  final ImagePicker _picker = ImagePicker();
  Map<String, dynamic> _userProfile = {};
  bool _isLoading = true;
  bool _isSaving = false;
  AppError? profileError;
  bool hasError = false;

  String? _selectedImageBase64;

  /// Text controllers for various editable profile fields.
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController websiteController = TextEditingController();
  final TextEditingController streetController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController functionController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController partnerNameController = TextEditingController();

  Country? _selectedCountry;
  StateClass? _selectedState;

  Map<String, dynamic> get userProfile => _userProfile;

  bool get isLoading => _isLoading;

  bool get isSaving => _isSaving;

  String? get selectedImageBase64 => _selectedImageBase64;

  Country? get selectedCountry => _selectedCountry;

  StateClass? get selectedState => _selectedState;

  /// Sets the selected profile image and notifies listeners.
  set selectedImageBase64(String? image) {
    _selectedImageBase64 = image;
    notifyListeners();
  }

  /// Sets the selected country and notifies listeners.
  set selectedCountry(Country? country) {
    _selectedCountry = country;
    notifyListeners();
  }

  /// Sets the selected state and notifies listeners.
  set selectedState(StateClass? state) {
    _selectedState = state;
    notifyListeners();
  }

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    mobileController.dispose();
    websiteController.dispose();
    streetController.dispose();
    cityController.dispose();
    functionController.dispose();
    usernameController.dispose();
    partnerNameController.dispose();
    _userProfile.clear();
    super.dispose();
  }

  /// Clears all profile data and controllers.
  void clearAll() {
    nameController.clear();
    phoneController.clear();
    emailController.clear();
    mobileController.clear();
    websiteController.clear();
    streetController.clear();
    cityController.clear();
    functionController.clear();
    usernameController.clear();
    partnerNameController.clear();
    _userProfile.clear();
    _selectedCountry = null;
    _selectedState = null;
    _selectedImageBase64 = null;
    notifyListeners();
  }

  /// Fetches the user's profile from Odoo or cache.
  ///
  /// If [loading] is true, notifies listeners of loading state.
  /// Fetches the user profile from Odoo using the `CompanySessionManager`.
  /// Stores profile in Isar cache for offline access.
  /// Handles partner details, address formatting, and country/state selection.
  Future<void> fetchUserProfileConfiguration({bool loading = false}) async {
    final prefs = await SharedPreferences.getInstance();
    final url = prefs.getString('url') ?? '';

    try {
      _isLoading = true;
      hasError = false;
      if (loading) {
        notifyListeners();
      }
      final prefs = await SharedPreferences.getInstance();
      int userId = prefs.getInt('userId') ?? 0;
      if (userId == 0) {
        throw Exception('Invalid userId: $userId');
      }

      final userDetails = await CompanySessionManager.callKwWithCompany({
        'model': 'res.users',
        'method': 'search_read',
        'args': [
          [
            ['id', '=', userId]
          ]
        ],
        'kwargs': {
          'fields': [
            'name',
            'login',
            'phone',
            'email',
            'street',
            'city',
            'country_id',
            'function',
            'company_id',
            'partner_id',
            'image_1920',
          ],
        },
      });

      if (userDetails != null && userDetails.isNotEmpty) {
        final user = userDetails[0];

        user['street'] = user['street'] != false ? user['street'] : '';
        user['city'] = user['city'] != false ? user['city'] : '';
        user['mobile'] = user['phone'] != false ? user['phone'] : 'No Mobile';
        user['website'] =
            user['website'] != false ? user['website'] : 'No Website';
        user['address'] = 'No Address';
        user['partner_id'] =
            user['partner_id'] != false && user['partner_id'] != null
                ? user['partner_id']
                : false;
        user['country_id'] =
            user['country_id'] != false && user['country_id'] != null
                ? user['country_id']
                : false;
        user['partner_name'] = 'No Partner Name';

        if (user['partner_id'] != false && user['partner_id'] != null) {
          final partnerId = user['partner_id'] is List
              ? user['partner_id'][0]
              : user['partner_id'];
          final partnerName =
              user['partner_id'] is List && user['partner_id'].length > 1
                  ? user['partner_id'][1]
                  : null;
          user['partner_name'] =
              partnerName != null ? partnerName : 'No Partner Name';

          final partnerDetails = await CompanySessionManager.callKwWithCompany({
            'model': 'res.partner',
            'method': 'search_read',
            'args': [
              [
                ['id', '=', partnerId]
              ]
            ],
            'kwargs': {
              'fields': [
                'street',
                'city',
                'state_id',
                'country_id',
                'website',
              ],
            },
          });

          if (partnerDetails != null && partnerDetails.isNotEmpty) {
            final partner = partnerDetails[0];
            user['address'] = _formatAddress(partner);
            user['mobile'] =
                user['phone'] != false ? user['phone'] : 'No Mobile';
            user['website'] =
                partner['website'] != false ? partner['website'] : 'No Website';
            user['street'] =
                partner['street'] != false ? partner['street'] : '';
            user['city'] = partner['city'] != false ? partner['city'] : '';
            user['state_id'] =
                partner['state_id'] != false && partner['state_id'] != null
                    ? partner['state_id']
                    : false;

            if (user['country_id'] != false &&
                user['country_id'] is List &&
                user['country_id'].length > 1) {
              _selectedCountry = Country(
                  id: user['country_id'][0], name: user['country_id'][1]);
            } else {
              _selectedCountry = null;
            }

            if (partner['state_id'] != false &&
                partner['state_id'] != null &&
                partner['state_id'] is List &&
                partner['state_id'].length > 1) {
              _selectedState = StateClass(
                  id: partner['state_id'][0], name: partner['state_id'][1]);
            } else {
              _selectedState = null;
            }
          } else {
            _selectedCountry = null;
            _selectedState = null;
          }
        } else {
          _selectedCountry = null;
          _selectedState = null;
        }

        nameController.text =
            user['name'] != false && user['name'] != null ? user['name'] : '';
        usernameController.text =
            user['login'] != false && user['login'] != null
                ? user['login']
                : '';
        partnerNameController.text =
            user['partner_name'] != false && user['partner_name'] != null
                ? user['partner_name']
                : '';
        phoneController.text = user['phone'] != false && user['phone'] != null
            ? user['phone']
            : '';
        emailController.text = user['email'] != false && user['email'] != null
            ? user['email']
            : '';
        mobileController.text =
            user['mobile'] != false && user['mobile'] != null
                ? user['mobile']
                : '';
        websiteController.text =
            user['website'] != false && user['website'] != null
                ? user['website']
                : '';
        streetController.text =
            user['street'] != false && user['street'] != null
                ? user['street']
                : '';
        cityController.text =
            user['city'] != false && user['city'] != null ? user['city'] : '';
        functionController.text =
            user['function'] != false && user['function'] != null
                ? user['function'].toString()
                : '';

        _userProfile = Map<String, dynamic>.from(user);
        final profile = ProfileModelIsar.fromJson(user,
            imageBase64:
                user['image_1920'] != false ? user['image_1920'] : null);
        await IsarService.saveProfile(profile);
      } else {
        throw Exception('No user details found');
      }

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      bool success = false;
      if (_userProfile.isEmpty) {
        success = await getProfileFromIsar();
      }

      if (success == false || _userProfile.isEmpty) {
        profileError = await ErrorHandler.handleException(e, uri: url);
        Future.delayed(const Duration(seconds: 2), () {
          _isLoading = false;
          hasError = true;
          notifyListeners();
        });
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Retrieves the user's profile from Isar cache.
  ///
  /// Returns true if cached profile exists and was loaded successfully.
  Future<bool> getProfileFromIsar() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      int userId = prefs.getInt('userId') ?? 0;
      if (userId == 0) {
        return false;
      }

      final cachedProfile = await IsarService.getCachedProfile(userId);
      if (cachedProfile != null) {
        _userProfile = cachedProfile.toJson();

        if (_userProfile['image_1920'] != 'N/A' &&
            _userProfile['image_1920'] != null) {
          try {
            base64Decode(_userProfile['image_1920']);
            _selectedImageBase64 = _userProfile['image_1920'];
          } catch (e) {
            _userProfile['image_1920'] = 'N/A';
            _selectedImageBase64 = null;
          }
        } else {
          _selectedImageBase64 = null;
        }

        nameController.text =
            _userProfile['name'] != 'N/A' ? _userProfile['name'] : '';
        usernameController.text =
            _userProfile['login'] != 'N/A' ? _userProfile['login'] : '';
        partnerNameController.text = _userProfile['partner_id'] != 'N/A' &&
                _userProfile['partner_id'] is List &&
                _userProfile['partner_id'].length > 1
            ? _userProfile['partner_id'][1] != 'N/A'
                ? _userProfile['partner_id'][1]
                : ''
            : '';
        phoneController.text =
            _userProfile['phone'] != 'N/A' ? _userProfile['phone'] : '';
        emailController.text =
            _userProfile['email'] != 'N/A' ? _userProfile['email'] : '';
        mobileController.text =
            _userProfile['mobile'] != 'N/A' ? _userProfile['mobile'] : '';
        websiteController.text =
            _userProfile['website'] != 'N/A' ? _userProfile['website'] : '';
        streetController.text =
            _userProfile['street'] != 'N/A' ? _userProfile['street'] : '';
        cityController.text =
            _userProfile['city'] != 'N/A' ? _userProfile['city'] : '';
        functionController.text =
            _userProfile['function'] != 'N/A' ? _userProfile['function'] : '';

        _selectedCountry = _userProfile['country_id'] != false &&
                _userProfile['country_id'] != null &&
                _userProfile['country_id'] is List &&
                _userProfile['country_id'].length > 1
            ? Country(
                id: _userProfile['country_id'][0],
                name: _userProfile['country_id'][1])
            : null;
        _selectedState = _userProfile['state_id'] != false &&
                _userProfile['state_id'] != null &&
                _userProfile['state_id'] is List &&
                _userProfile['state_id'].length > 1
            ? StateClass(
                id: _userProfile['state_id'][0],
                name: _userProfile['state_id'][1])
            : null;

        notifyListeners();
        return true;
      } else {
        return false;
      }
    } catch (cacheError) {
      return false;
    }
  }

  /// Formats a partner's address into a single string.
  ///
  /// Combines `street`, `city`, `state`, and `country` if available.
  String _formatAddress(Map<String, dynamic> partner) {
    List<String> addressParts = [];

    if (partner['street'] != false && partner['street'] != null)
      addressParts.add(partner['street']);
    if (partner['city'] != false && partner['city'] != null)
      addressParts.add(partner['city']);
    if (partner['state_id'] != false &&
        partner['state_id'] != null &&
        partner['state_id'] is List &&
        partner['state_id'].length > 1) {
      addressParts.add(partner['state_id'][1]);
    }
    if (partner['country_id'] != false &&
        partner['country_id'] != null &&
        partner['country_id'] is List &&
        partner['country_id'].length > 1) {
      addressParts.add(partner['country_id'][1]);
    }

    return addressParts.isNotEmpty ? addressParts.join(', ') : 'No Address';
  }

  /// Picks an image from the given [source] and converts it to base64.
  ///
  /// Updates [_selectedImageBase64] and notifies listeners.
  /// Shows an error snackbar if image picking fails.
  Future<void> pickImage(ImageSource source, BuildContext ctx) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: source,
        maxWidth: 1920,
        maxHeight: 1920,
        imageQuality: 85,
      );

      if (pickedFile != null) {
        final bytes = await pickedFile.readAsBytes();
        selectedImageBase64 = base64Encode(bytes);
      }
    } catch (e) {
      if (ctx.mounted) {
        CustomSnackbar.showError(ctx, "Failed to pick image: $e");
      }
    }
  }

  /// Saves the profile changes to Odoo.
  ///
  /// Updates both the `res.users` and `res.partner` models.
  /// Updates profile image if it exists and is under 5MB.
  /// Displays success or error messages using snackbars.
  Future<void> saveProfileChanges(BuildContext ctx) async {
    try {
      _isSaving = true;
      notifyListeners();

      final prefs = await SharedPreferences.getInstance();
      int userId = prefs.getInt('userId') ?? 0;
      if (userId == 0) {
        throw Exception('Invalid userId: $userId');
      }

      final result = await CompanySessionManager.callKwWithCompany({
        'model': 'res.users',
        'method': 'read',
        'args': [
          [userId],
          ['partner_id']
        ],
        'kwargs': {},
      });

      if (result.isEmpty ||
          result[0]['partner_id'] == false ||
          result[0]['partner_id'] == null) {
        throw Exception('No partner_id found for user ID $userId');
      }

      int partnerId = result[0]['partner_id'] is List
          ? result[0]['partner_id'][0]
          : result[0]['partner_id'];

      final partnerUpdate = {
        'name': partnerNameController.text.isNotEmpty
            ? partnerNameController.text
            : (nameController.text.isNotEmpty ? nameController.text : null),
        'phone': phoneController.text.isNotEmpty ? phoneController.text : false,
        'email': emailController.text.isNotEmpty ? emailController.text : null,
        'street':
            streetController.text.isNotEmpty ? streetController.text : false,
        'city': cityController.text.isNotEmpty ? cityController.text : false,
        'state_id': _selectedState?.id ?? false,
        'country_id': _selectedCountry?.id ?? false,
        'website':
            websiteController.text.isNotEmpty ? websiteController.text : false,
      };

      if (_selectedImageBase64 != null &&
          _selectedImageBase64!.length < 5 * 1024 * 1024) {
        partnerUpdate['image_1920'] = _selectedImageBase64!;
        await CompanySessionManager.callKwWithCompany({
          'model': 'res.users',
          'method': 'write',
          'args': [
            [userId],
            {'image_1920': _selectedImageBase64!},
          ],
          'kwargs': {},
        });
      } else if (_selectedImageBase64 != null) {
        throw Exception('Image size too large');
      }

      final userUpdate = {
        'function': functionController.text.isNotEmpty
            ? functionController.text
            : false,
        'name': nameController.text.isNotEmpty ? nameController.text : null,
        'email': emailController.text.isNotEmpty ? emailController.text : null,
      };

      final partnerWriteResult = await CompanySessionManager.callKwWithCompany({
        'model': 'res.partner',
        'method': 'write',
        'args': [
          [partnerId],
          partnerUpdate,
        ],
        'kwargs': {},
      });

      if (partnerWriteResult != true) {
        throw Exception(
            'Failed to update partner profile: $partnerWriteResult');
      }

      final userWriteResult = await CompanySessionManager.callKwWithCompany({
        'model': 'res.users',
        'method': 'write',
        'args': [
          [userId],
          userUpdate,
        ],
        'kwargs': {},
      });

      if (userWriteResult != true) {
        throw Exception('Failed to update user profile: $userWriteResult');
      }

      selectedImageBase64 = null;

      if (ctx.mounted) {
        CustomSnackbar.showSuccess(ctx, "Profile Saved Successfully");
      }

      await fetchUserProfileConfiguration();
    } catch (e) {
      if (ctx.mounted) {
        CustomSnackbar.showError(
            ctx, "Failed to save profile: ${e.toString()}");
      }
    } finally {
      _isSaving = false;
      notifyListeners();
    }
  }
}
