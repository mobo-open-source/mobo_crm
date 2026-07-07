import 'package:flutter/material.dart';

/// A bottom sheet widget that allows the user to compose and send an email.
///
/// This widget provides the following functionalities:
/// - Select a recipient from a dropdown list.
/// - Enter a subject for the email.
/// - Compose the email body.
/// - Attach files and display them as a list with delete options.
/// - Send or discard the email.
///
/// The bottom sheet automatically adjusts for the on-screen keyboard using
/// [MediaQuery.of(context).viewInsets.bottom] to prevent overlapping content.
///
/// Example usage:
/// ```dart
/// showModalBottomSheet(
///   context: context,
///   isScrollControlled: true,
///   builder: (_) => const EmailBottomSheet(),
/// );
/// ```
class EmailBottomSheet extends StatefulWidget {
  const EmailBottomSheet({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _EmailBottomSheetState createState() => _EmailBottomSheetState();
}

/// The state class for [EmailBottomSheet], handling user input and UI updates.
class _EmailBottomSheetState extends State<EmailBottomSheet> {
  String? selectedEmail;
  TextEditingController subjectController = TextEditingController();
  TextEditingController bodyController = TextEditingController();
  List<String> attachments = [];

  @override
  Widget build(BuildContext context) {
    return Padding(
      /// Adjusts padding to avoid keyboard overlapping the bottom sheet content.
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        top: 16.0,
        left: 16.0,
        right: 16.0,
      ),
      child: Container(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Top draggable indicator
              Center(
                child: Container(
                  width: 40,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              /// Recipient section
              Text(
                'To',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor),
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: 'Select Recipient Email',
                  floatingLabelStyle: const TextStyle(color: Colors.grey),
                  labelStyle: const TextStyle(color: Colors.grey),
                  fillColor: Colors.white,
                  filled: true,
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey[300]!),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Theme.of(context).primaryColor, width: 2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.red, width: 2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                validator: (value) =>
                    value == null ? 'Please Select A Recipient' : null,
                items: ['deco.addict@agroloait.com']
                    .map((email) => DropdownMenuItem(
                          value: email,
                          child: Text(email),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    selectedEmail = value;
                  });
                },
              ),
              const SizedBox(height: 15),

              /// Subject section
              Text(
                'Subject',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: subjectController,
                decoration: InputDecoration(
                  labelText: 'Your Company Quotation (Ref: S00157)',
                  floatingLabelStyle: const TextStyle(color: Colors.grey),
                  labelStyle: const TextStyle(color: Colors.grey),
                  fillColor: Colors.white,
                  filled: true,
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey[300]!),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Theme.of(context).primaryColor, width: 2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.red, width: 2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 15),

              /// Email body section
              Text(
                'Email Body',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: bodyController,
                maxLines: 5,
                decoration: InputDecoration(
                  labelText: 'Enter email body here',
                  floatingLabelStyle: const TextStyle(color: Colors.grey),
                  labelStyle: const TextStyle(color: Colors.grey),
                  fillColor: Colors.white,
                  filled: true,
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey[300]!),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Theme.of(context).primaryColor, width: 2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.red, width: 2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 15),

              /// Attachments section
              Text(
                'Attachments:',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor),
              ),
              ...attachments.map((attachment) => ListTile(
                    title: Text(attachment),
                    trailing: IconButton(
                      icon: Icon(Icons.delete,
                          color: Theme.of(context).primaryColor),
                      onPressed: () {
                        setState(() {
                          attachments.remove(attachment);
                        });
                      },
                    ),
                  )),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                icon: const Icon(
                  Icons.attach_file,
                  color: Colors.white,
                ),
                label: const Text(
                  'Add Attachment',
                  style: TextStyle(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor),
                onPressed: () async {},
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.white),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('Discard'),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).primaryColor),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text(
                      'Send',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
