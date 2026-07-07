import 'package:flutter/material.dart';
import 'package:mobo_crm/global_methods/const.dart';
import 'package:mobo_crm/global_methods/widgets/image_widget/custom_profile_image.dart';
import 'package:mobo_crm/global_methods/widgets/transition/page_transition.dart';
import 'package:mobo_crm/initilisation.dart';
import 'package:mobo_crm/screens/others/profile_screen.dart';

import 'package:mobo_crm/screens/settings/screens/profile/provider/provider_profile.dart';
import 'package:odoo_rpc/odoo_rpc.dart';
import 'package:provider/provider.dart';

/// A card widget displaying the current user's profile information in settings.
///
/// Features:
/// - Displays user's profile image, name, and email.
/// - Shows placeholders while data is loading.
/// - Navigates to [ProfileScreen] on tap.
///
/// Uses `Consumer2` to listen to changes in:
/// 1. [OdooClientManager] – for Odoo client state.
/// 2. [ProfileConfigurationProvider] – for user profile data.
class SettingsProfileCard extends StatelessWidget {
  final OdooClient? client;

  /// Constructs a [SettingsProfileCard].
  ///
  /// The [client] parameter can be provided if profile-related API calls are needed.
  const SettingsProfileCard({super.key, required this.client});

  /// Builds the widget tree for the settings profile card.
  ///
  /// Returns a [Card] with:
  /// - Profile image
  /// - Name and email
  /// - Right arrow icon indicating navigation
  /// - Tap behavior to navigate to [ProfileScreen] using a sliding page transition
  @override
  Widget build(BuildContext context) {
    return Consumer2<OdooClientManager, ProfileConfigurationProvider>(
        builder: (context, odooprovider, profileprovider, child) {
      return Card(
        elevation: 0,
        color: AppColors().fillColor,
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              SlidingPageTransitionRL(page: ProfileScreen()),
            );
          },
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              children: [
                const SizedBox(width: 15),
                const ProfileImage(size: 50),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        profileprovider.isLoading
                            ? 'Loading ...'
                            : profileprovider.userProfile['name'] == null
                                ? "No Name"
                                : profileprovider.nameController.text,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        profileprovider.isLoading
                            ? 'Loading ...'
                            : profileprovider.userProfile['email'] == null
                                ? "No Email"
                                : profileprovider.emailController.text,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.chevron_right,
                  color: Colors.grey,
                ),
                const SizedBox(width: 15),
              ],
            ),
          ),
        ),
      );
    });
  }
}
