import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobo_crm/global_methods/const.dart';
import 'package:mobo_crm/global_methods/widgets/buttons/form_view_icon.dart';
import 'package:mobo_crm/global_methods/widgets/image_widget/get_allimage.dart';
import 'package:mobo_crm/global_methods/widgets/shimmer/custom_shimmer.dart';
import 'package:mobo_crm/global_methods/widgets/textfields/custom_editing_fields.dart';
import 'package:mobo_crm/global_methods/widgets/textfields/future_single_selection_textfield.dart';
import 'package:mobo_crm/initilisation.dart';
import 'package:mobo_crm/models/models.dart';
import 'package:mobo_crm/screens/settings/screens/profile/provider/provider_profile.dart';
import 'package:odoo_rpc/odoo_rpc.dart';
import 'package:provider/provider.dart';

import '../../../../core/company/session/company_session_manager.dart';
import '../company/company_details.dart';

/// A screen that allows users to view and edit their profile information.
///
/// This widget uses [ProfileConfigurationProvider] to manage profile data,
/// including fetching user details, updating fields, and picking profile images.
/// It displays a form with editable fields such as name, email, phone, address, and country/state selection.
///
/// [client] is required to interact with the Odoo backend.
/// [loadData] determines whether to fetch data immediately or not.
class ProfileConfiguration extends StatelessWidget {
  final bool loadData;
  final OdooClient client;

  /// Creates a [ProfileConfiguration] screen.
  ///
  /// [client] is required.
  const ProfileConfiguration({
    super.key,
    this.loadData = false,
    required this.client,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.black),
        centerTitle: false,
        leading: IconButton(
          padding: EdgeInsets.all(0),
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios_new_rounded),
        ),
        title: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: const Text(
            'Edit Profile',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
        backgroundColor: Colors.grey[50],
        automaticallyImplyLeading: false,
      ),
      body: Consumer<ProfileConfigurationProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading && provider.userProfile.isEmpty) {
            return const ShimmerLoading(isCustomer: true);
          } else if (provider.userProfile.isEmpty) {
            return NoDataView();
          }

          return ProfileConfigurationForm(provider: provider);
        },
      ),
    );
  }
}

/// A form widget that allows users to edit their profile details.
///
/// Displays profile picture, editable fields (name, email, phone, etc.),
/// and country/state selectors. Provides an image picker to select a profile image
/// from the camera or gallery.
class ProfileConfigurationForm extends StatefulWidget {
  final ProfileConfigurationProvider provider;

  /// Creates a [ProfileConfigurationForm] for editing user profile.
  const ProfileConfigurationForm({super.key, required this.provider});

  @override
  State<ProfileConfigurationForm> createState() =>
      _ProfileConfigurationFormState();
}

class _ProfileConfigurationFormState extends State<ProfileConfigurationForm> {
  /// Opens a modal bottom sheet to allow the user to pick an image.
  ///
  /// Provides options to select an image from the gallery or take a new photo
  /// using the camera. The selected image is saved in [ProfileConfigurationProvider].
  void _showImagePicker(BuildContext context) {
    final theme = Theme.of(context);
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 10,
                spreadRadius: 0,
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                SizedBox(height: 24),
                Padding(
                  padding: const EdgeInsets.only(bottom: 20.0),
                  child: Text(
                    'Select Image Source',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: theme.primaryColor,
                      letterSpacing: 0.3,
                    ),
                  ),
                ),
                _buildPremiumOption(
                  context: context,
                  icon: Icons.photo_library_rounded,
                  iconColor: Color(0xFF5E6CEA),
                  backgroundColor: const Color(0xFFFAFAFA),
                  title: 'Photo Gallery',
                  subtitle: 'Pick from your saved photos',
                  onTap: () async {
                    Navigator.of(context).pop();
                    await widget.provider
                        .pickImage(ImageSource.gallery, context);
                  },
                ),
                SizedBox(height: 16),
                _buildPremiumOption(
                  context: context,
                  icon: Icons.camera_alt_rounded,
                  iconColor: Color(0xFF33C759),
                  backgroundColor: Color(0xFFE6F8ED),
                  title: 'Camera',
                  subtitle: 'Take a new photo',
                  onTap: () async {
                    Navigator.of(context).pop();
                    await widget.provider
                        .pickImage(ImageSource.camera, context);
                  },
                ),
                SizedBox(height: 24),
              ],
            ),
          ),
        );
      },
    );
  }

  /// Builds a custom option for the image picker modal.
  ///
  /// [icon] and [iconColor] define the icon displayed.
  /// [backgroundColor] sets the circle behind the icon.
  /// [title] and [subtitle] describe the option.
  /// [onTap] is the callback when the user selects the option.
  Widget _buildPremiumOption({
    required BuildContext context,
    required IconData icon,
    required Color iconColor,
    required Color backgroundColor,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade200),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 6,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: backgroundColor,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: iconColor, size: 26),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios_rounded,
              color: Colors.grey.shade400,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    /// Builds the full profile form including profile picture, editable fields,
    /// and country/state selection dropdowns.
    return Consumer2<OdooClientManager, ProfileConfigurationProvider>(
        builder: (context, clientprovider, profileprovider, child) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Card(
                color: AppColors().fillColor,
                child: SizedBox(
                  width: double.infinity,
                  child: Container(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Stack(
                              clipBehavior: Clip.none,
                              alignment: Alignment.bottomRight,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withValues(alpha: 0.1),
                                        blurRadius: 8,
                                        offset: Offset(0, 4),
                                      ),
                                    ],
                                    border: Border.all(
                                      color: Theme.of(context)
                                          .primaryColor
                                          .withValues(alpha: 0.2),
                                      width: 1,
                                    ),
                                  ),
                                  child: widget.provider.selectedImageBase64 !=
                                          null
                                      ? ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          child: Image.memory(
                                            base64Decode(widget
                                                .provider.selectedImageBase64!),
                                            width: 70,
                                            height: 70,
                                            fit: BoxFit.cover,
                                            errorBuilder:
                                                (context, error, stackTrace) =>
                                                    OdooByteImage(
                                              squareBorderRadius: 12,
                                              shape: ImageShape.square,
                                              size: 70,
                                              model: 'res.users',
                                              recordId: clientprovider
                                                  .client!.sessionId!.userId,
                                              imageQuality: 'image_1920',
                                              shimmerBaseColor:
                                                  Colors.grey[200],
                                              shimmerHighlightColor:
                                                  Colors.grey[100],
                                            ),
                                          ),
                                        )
                                      : OdooByteImage(
                                          squareBorderRadius: 12,
                                          shape: ImageShape.square,
                                          size: 70,
                                          model: 'res.users',
                                          recordId: clientprovider
                                              .client!.sessionId!.userId,
                                          imageQuality: 'image_1920',
                                          shimmerBaseColor: Colors.grey[200],
                                          shimmerHighlightColor:
                                              Colors.grey[100],
                                        ),
                                ),
                                Positioned(
                                  right: -8,
                                  bottom: -8,
                                  child: GestureDetector(
                                    onTap: () => _showImagePicker(context),
                                    child: AnimatedContainer(
                                      duration: Duration(milliseconds: 200),
                                      curve: Curves.easeInOut,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        gradient: LinearGradient(
                                          colors: [
                                            Theme.of(context).primaryColor,
                                            Theme.of(context)
                                                .primaryColor
                                                .withValues(alpha: 0.8),
                                          ],
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                        ),
                                      ),
                                      child: CircleAvatar(
                                        radius: 15,
                                        backgroundColor: Colors.transparent,
                                        child: Icon(
                                          Icons.edit,
                                          size: 16,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Spacer(),
                            FormViewCustomIcon(
                              icon: Icons.save,
                              onTap: widget.provider.isSaving
                                  ? null
                                  : () {
                                      widget.provider
                                          .saveProfileChanges(context);
                                    },
                            ),
                          ],
                        ),
                        SizedBox(height: 20),
                        CustomEditingFields(
                          title: 'Name',
                          controller: widget.provider.nameController,
                          hintText: 'Enter Your Name',
                          isEditable: true,
                        ),
                        CustomEditingFields(
                          title: 'Phone',
                          controller: widget.provider.phoneController,
                          hintText: 'Enter Your Phone Number',
                          isEditable: true,
                        ),
                        CustomEditingFields(
                          title: 'Email',
                          controller: widget.provider.emailController,
                          hintText: 'Enter Your Email',
                          isEditable: true,
                        ),
                        CustomEditingFields(
                          title: 'Mobile',
                          controller: widget.provider.mobileController,
                          hintText: 'Enter Your Mobile Number',
                          isEditable: true,
                        ),
                        CustomEditingFields(
                          title: 'Website',
                          controller: widget.provider.websiteController,
                          hintText: 'Enter Your Website',
                          isEditable: true,
                        ),
                        Text(
                          "Country",
                          style: TextStyle(
                              fontSize: 16, color: AppColors().subHeading),
                        ),
                        SizedBox(height: 10),
                        Row(
                          children: [
                            Expanded(
                              child: SingleSelectSearchableFuture<Country>(
                                items: [],
                                idSelector: (item) => item.id,
                                initialValue: widget.provider.selectedCountry,
                                displayText: (country) => country.name,
                                onSelectionChanged: (country) {
                                  if (country != null) {
                                    setState(() {
                                      widget.provider.selectedCountry = country;
                                      widget.provider.selectedState = null;
                                    });
                                  } else {
                                    setState(() {
                                      widget.provider.selectedCountry = null;
                                      widget.provider.selectedState = null;
                                    });
                                  }
                                },
                                hintText: 'Select a country',
                                onEmptyItemsFetch: () async {
                                  final countrylist =
                                      await CompanySessionManager
                                          .callKwWithCompany({
                                    'model': 'res.country',
                                    'method': 'search_read',
                                    'args': [[]],
                                    'kwargs': {
                                      'fields': ['id', 'name']
                                    },
                                  });
                                  return (countrylist as List<dynamic>)
                                      .map((item) => Country.fromJson(
                                          item as Map<String, dynamic>))
                                      .toList();
                                },
                                isEditable: true,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20),
                        Text(
                          "State",
                          style: TextStyle(
                              fontSize: 16, color: AppColors().subHeading),
                        ),
                        SizedBox(height: 10),
                        Row(
                          children: [
                            Expanded(
                              child: SingleSelectSearchableFuture<StateClass>(
                                refresh: true,
                                items: [],
                                idSelector: (item) => item.id,
                                clear: widget.provider.selectedCountry == null,
                                initialValue: widget.provider.selectedState,
                                displayText: (state) => state.name,
                                onSelectionChanged: (state) {
                                  if (state != null) {
                                    setState(() {
                                      widget.provider.selectedState = state;
                                    });
                                  }
                                },
                                message: "Select A Country First",
                                hintText: 'Select a State',
                                onEmptyItemsFetch: () async {
                                  final stateList = await CompanySessionManager
                                      .callKwWithCompany({
                                    'model': 'res.country.state',
                                    'method': 'search_read',
                                    'args': [
                                      [
                                        [
                                          'country_id',
                                          '=',
                                          widget.provider.selectedCountry!.id
                                        ]
                                      ]
                                    ],
                                    'kwargs': {
                                      'fields': ['id', 'name', 'country_id']
                                    },
                                  });
                                  return (stateList as List<dynamic>)
                                      .map((item) => StateClass.fromJson(
                                          item as Map<String, dynamic>))
                                      .toList();
                                },
                                isEditable:
                                    widget.provider.selectedCountry != null,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20),
                        CustomEditingFields(
                          title: 'Street',
                          controller: widget.provider.streetController,
                          hintText: 'Enter Your Street',
                          isEditable: true,
                        ),
                        CustomEditingFields(
                          title: 'City',
                          controller: widget.provider.cityController,
                          hintText: 'Enter Your City',
                          isEditable: true,
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
    });
  }
}
