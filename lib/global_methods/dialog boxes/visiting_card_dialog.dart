import 'package:flutter/material.dart';
import 'package:mobo_crm/global_methods/const.dart';

/// Displays a modal bottom-sheet style dialog that lets the user choose
/// how to add a new contact/partner in the CRM system.
///
/// Offers two main options:
///   1. **Scan Visiting Card** → (intended for QR code / OCR / camera-based import)
///   2. **Create Manually**   → opens a full form for manual entry
///
/// Currently both buttons only close the dialog (placeholder behavior).
/// You should replace the `onPressed` callbacks with actual navigation or action logic.
///
/// Usage example:
/// ```dart
/// await showContactInputDialog(context);
/// ```
Future<void> showContactInputDialog(BuildContext context) async {
  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext dialogContext) {
      return Dialog(
        backgroundColor: AppColors().fillColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.person_add_alt_1,
                    color: Theme.of(context).primaryColor,
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text(
                      "Add New Contact",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              Text(
                "Choose how you want to add the contact.",
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors().subHeading.withOpacity(0.8),
                ),
              ),
              const SizedBox(height: 24),

              Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pop(dialogContext);
                      },
                      icon: const Icon(Icons.qr_code_scanner),
                      label: const Text("Scan Visiting Card"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).primaryColor,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () {
                        Navigator.pop(dialogContext);
                      },
                      icon: const Icon(Icons.edit),
                      label: const Text("Create Manually"),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        side: BorderSide(
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}
