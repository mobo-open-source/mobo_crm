import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:mobo_crm/global_methods/widgets/date_picker/custom_date_picker.dart';
import 'package:mobo_crm/global_methods/widgets/textfields/custom_editing_fields.dart';
import 'package:mobo_crm/initilisation.dart';
import 'package:mobo_crm/screens/quotation/provider/quotation_view_provider.dart';
import 'package:mobo_crm/screens/quotation/provider/quotebuilder_provider.dart';

import 'package:mobo_crm/screens/quotation/provider/quotation_form_provider.dart';
import 'package:provider/provider.dart';

/// A widget that displays and manages the signature section of a quotation.
///
/// This widget allows the user to:
/// - Enter the signer name ("Signed By").
/// - Select the signature date ("Signed On").
/// - Upload or capture a signature image.
///
/// It adapts the UI depending on whether the quotation is in edit mode
/// ([QuotationFormProvider.isEdit]). If not in edit mode, it displays read-only information.
class SignatureWidget extends StatefulWidget {
  const SignatureWidget({super.key});

  @override
  SignatureWidgetState createState() => SignatureWidgetState();
}

/// State for [SignatureWidget].
class SignatureWidgetState extends State<SignatureWidget> {
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.primaryColor;

    return Consumer4<QuotationFormProvider, OdooClientManager,
        QuoteBuilderProvider, QuotationViewProvider>(
      builder: (context, provider, clientprovider, quotebuilderprovider,
          quotationviewprovider, child) {
        return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Header: Signature Details
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 18, vertical: 16),
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                    ),
                  ),
                  child: Row(
                    children: [
                      HugeIcon(
                        icon: HugeIcons.strokeRoundedPencilEdit02,
                        color: Colors.grey[700]!,
                        size: 22,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        'Signature Details',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[900],
                          letterSpacing: -0.3,
                        ),
                      ),
                    ],
                  ),
                ),
                Divider(
                  height: 1,
                  color: Colors.grey[200],
                  indent: 16,
                  endIndent: 16,
                ),

                /// Signed By and Signed On fields
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      provider.isEdit
                          ? CustomEditingFields(
                              title: "Signed By",
                              controller: provider.signedByController,
                              hintText: "Signed By",
                              isEditable: provider.isEdit)
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Signed By",
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Text(
                                  provider.signedByController.text.isEmpty
                                      ? "None"
                                      : provider.signedByController.text,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.normal,
                                    fontSize: 14,
                                  ),
                                  textAlign: TextAlign.end,
                                ),
                              ],
                            ),
                      const SizedBox(height: 10),
                      provider.isEdit
                          ? CustomDatePickerField(
                              isEditable: provider.isEdit,
                              onDateChanged: (value) {
                                setState(() {
                                  provider.formatDateSignature.text = value!;
                                });
                              },
                              hintText: "Signed On")
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Signed On",
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Text(
                                  provider.formatDateSignature.text.isEmpty
                                      ? "None"
                                      : provider.formatDateSignature.text,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.normal,
                                    fontSize: 14,
                                  ),
                                  textAlign: TextAlign.end,
                                ),
                              ],
                            ),
                    ],
                  ),
                ),

                /// Signature upload area
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 2, bottom: 16),
                        child: Row(
                          children: [
                            Text(
                              'Signature',
                              style: TextStyle(
                                  color: Colors.black54,
                                  fontSize: 14,
                                  fontWeight: FontWeight.normal),
                            ),
                          ],
                        ),
                      ),

                      /// Signature image container
                      Center(
                        child: Container(
                          width: double.infinity,
                          height: 200,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: provider.imageBase64 != null &&
                                      provider.imageBase64!.isNotEmpty
                                  ? primaryColor
                                  : Colors.grey.shade300,
                              width: 1.5,
                            ),
                          ),
                          child: Material(
                            color: Colors.transparent,
                            borderRadius: BorderRadius.circular(16),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(16),
                              splashColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              onTap: provider.isEdit ? provider.pickImage : null,
                              child: Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      if (provider.imageBase64 != null &&
                                          provider.imageBase64!.isNotEmpty)
                                        Image.memory(
                                          base64Decode(provider.imageBase64!),
                                          width: double.infinity,
                                          height: double.infinity,
                                          fit: BoxFit.contain,
                                        )
                                      else
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Container(
                                              padding: const EdgeInsets.all(16),
                                              decoration: BoxDecoration(
                                                color:
                                                    primaryColor.withOpacity(0.1),
                                                shape: BoxShape.circle,
                                              ),
                                              child: Icon(
                                                Icons.gesture_rounded,
                                                size: 40,
                                                color: primaryColor,
                                              ),
                                            ),
                                            const SizedBox(height: 16),
                                            Text(
                                              provider.isEdit
                                                  ? 'Tap to add signature'
                                                  : 'No signature added',
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.normal,
                                                fontSize: 15,
                                              ),
                                            ),
                                            if (provider.isEdit) ...[
                                              const SizedBox(height: 4),
                                              Text(
                                                'Upload an image of your signature',
                                                style: TextStyle(
                                                    fontSize: 13,
                                                    color: Colors.black54),
                                              ),
                                            ],
                                          ],
                                        ),
                                      if (provider.imageBase64 != null &&
                                          provider.imageBase64!.isNotEmpty &&
                                          provider.isEdit)
                                        Positioned(
                                          top: 8,
                                          right: 8,
                                          child: Material(
                                            color: Colors.transparent,
                                            borderRadius:
                                                BorderRadius.circular(30),
                                            child: InkWell(
                                              borderRadius:
                                                  BorderRadius.circular(30),
                                              onTap: provider.cleanSignature,
                                              child: Container(
                                                padding: const EdgeInsets.all(8),
                                                decoration: BoxDecoration(
                                                  color: Colors.white
                                                      .withOpacity(0.9),
                                                  shape: BoxShape.circle,
                                                ),
                                                child: const Icon(
                                                  Icons.delete_outline_rounded,
                                                  color: Colors.redAccent,
                                                  size: 22,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),
              ],
            ),
        );
      },
    );
  }
}
