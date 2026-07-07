import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mobo_crm/initilisation.dart';
import 'package:mobo_crm/screens/customers/provider/customer_form_provider.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

/// A widget that displays a list of child contacts associated with a customer.
///
/// This widget:
/// - Retrieves contact data from [CustomerFormProvider]
/// - Uses [OdooClientManager] to construct authenticated image URLs
/// - Displays contact profile images using [CachedNetworkImage]
/// - Shows shimmer loading placeholders while images load
/// - Handles missing image, email, and phone gracefully
///
/// If no child contacts are available, a fallback message is displayed.
class ChildContactsList extends StatelessWidget {
  const ChildContactsList({super.key});

  /// Builds the UI for rendering child contacts.
  ///
  /// Behavior:
  /// - Displays a "No contacts available" message if the list is empty.
  /// - Renders a scrollable list of contacts using [ListView.builder].
  /// - Shows:
  ///     • Profile image (fetched securely from Odoo server)
  ///     • Contact name
  ///     • Email address (if available)
  ///     • Phone number (if available)
  ///
  /// Images are fetched using session-based authentication headers.
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<CustomerFormProvider>(context);
    final odooProvider = Provider.of<OdooClientManager>(context);

    if (provider.childContacts.isEmpty) {
      return const Center(
        child: Text(
          "No contacts available",
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      itemCount: provider.childContacts.length,
      itemBuilder: (context, index) {
        final contact = provider.childContacts[index];
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: CachedNetworkImage(
                  imageUrl:
                      "${odooProvider.url}/web/image/res.partner/${contact['id']}/image_128",
                  httpHeaders: {
                    "Cookie":
                        "session_id=${odooProvider.currentsession!.sessionId}",
                  },
                  width: 60,
                  height: 60,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Shimmer.fromColors(
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
                    child: Container(
                      width: 60,
                      height: 60,
                      decoration:
                          const BoxDecoration(shape: BoxShape.rectangle),
                    ),
                  ),
                  errorWidget: (context, url, error) => Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child:
                        const Icon(Icons.person, size: 30, color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      contact['name'] ?? 'Unknown',
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      contact['email'] != false && contact['email'] != null
                          ? contact['email']
                          : 'No email',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      contact['phone'] != false && contact['phone'] != null
                          ? 'Phone: ${contact['phone']}'
                          : 'No phone',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
