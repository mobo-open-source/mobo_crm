import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:lottie/lottie.dart';
import 'package:mobo_crm/global_methods/const.dart';
import 'package:mobo_crm/initilisation.dart';
import 'package:mobo_crm/screens/quotation/provider/quotation_form_provider.dart';
import 'package:mobo_crm/screens/quotation/provider/quotation_view_provider.dart';
import 'package:mobo_crm/screens/quotation/provider/quotebuilder_provider.dart';
import 'package:mobo_crm/screens/quotation/widgets/components/custom_components.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

/// A widget that displays the Quote Builder interface.
///
/// This widget shows different sections of a quotation's PDF documents
/// (headers, footers, and product-related documents) and allows selecting
/// and editing custom fields for each file if the quotation is in edit mode.
///
/// Integrates with the following providers:
/// - [OdooClientManager] to check the Odoo version and client.
/// - [QuoteBuilderProvider] to manage PDF data and selections.
/// - [QuotationFormProvider] for quotation state and edit mode.
/// - [QuotationViewProvider] for additional quotation view context.
class QuoteBuilderWidget extends StatelessWidget {
  final VoidCallback? onFormChanged;

  const QuoteBuilderWidget({super.key, this.onFormChanged});

  @override
  Widget build(BuildContext context) {
    return Consumer4<OdooClientManager, QuoteBuilderProvider,
        QuotationFormProvider, QuotationViewProvider>(
      builder: (context, clientProvider, quoteProvider, quoteformprovider,
          quotationviewprovider, child) {
        if (quoteProvider.isLoading) {
          return _buildShimmerPlaceholder();
        }

        return Container(
          decoration: BoxDecoration(
            color: AppColors().fillColor,
            borderRadius: BorderRadius.circular(16),
          ),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (quoteformprovider.saleId != null &&
                    clientProvider.isOdoo18) ...[
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
                          icon: HugeIcons.strokeRoundedFile02,
                          color: Colors.grey[700]!,
                          size: 22,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          "Quote Builder",
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
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SectionTitle(title: "Headers"),
                        const SizedBox(height: 8),
                        _buildSection(
                            context,
                            quoteProvider.pdfData['headers']?['files'] ?? [],
                            'header',
                            quoteProvider,
                            quoteformprovider.isEdit),
                        const SizedBox(height: 40),
                        SectionTitle(title: "Footers"),
                        const SizedBox(height: 8),
                        _buildSection(
                            context,
                            quoteProvider.pdfData['footers']?['files'] ?? [],
                            'footer',
                            quoteProvider,
                            quoteformprovider.isEdit),
                        const SizedBox(height: 24),
                        SectionTitle(title: "Product Documents"),
                        const SizedBox(height: 8),
                        _buildProductSection(
                            context,
                            quoteProvider.pdfData['lines'] ?? [],
                            quoteProvider,
                            quoteformprovider.isEdit),
                      ],
                    ),
                  ),
                ],
                if (quoteformprovider.saleId == null) ...[
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.5,
                    child: Center(
                      child: Text(
                        "Save the quotation\nto see the documents",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[500],
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
                if (quoteformprovider.saleId != null &&
                    clientProvider.isOdoo18 == false) ...[
                  Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Lottie.asset('assets/empty_ghost.json', width: 260),
                        Text(
                          "Feature only available in Odoo 18",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w500),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  )
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  /// Builds a shimmer loading placeholder while PDF data is being fetched.
  Widget _buildShimmerPlaceholder() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: List.generate(3, (sectionIndex) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Shimmer.fromColors(
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
                    child: Container(
                      height: 24,
                      width: 180,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ...List.generate(3, (index) {
                    return Shimmer.fromColors(
                      baseColor: Colors.grey[300]!,
                      highlightColor: Colors.grey[100]!,
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        height: 60,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    );
                  }),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }

  /// Builds a section of files (headers or footers).
  ///
  /// [files] - List of file data maps.
  /// [section] - 'header' or 'footer'.
  /// [provider] - QuoteBuilderProvider to manage selection.
  /// [isEdit] - Whether the section is editable.
  Widget _buildSection(BuildContext context, List<dynamic> files,
      String section, QuoteBuilderProvider provider, bool isEdit) {
    if (files.isEmpty) {
      return _buildEmptySection(context, "No documents available");
    }

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      child: Column(
        children: files.asMap().entries.map((entry) {
          final file = entry.value;
          return _buildFileTile(context, file, section, provider, isEdit);
        }).toList(),
      ),
    );
  }

  /// Builds the product documents section with nested files.
  Widget _buildProductSection(BuildContext context, List<dynamic> lines,
      QuoteBuilderProvider provider, bool isEdit) {
    if (lines.isEmpty) {
      return _buildEmptySection(context, "No product documents available");
    }

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      child: Column(
        children: lines.asMap().entries.map((lineEntry) {
          final line = lineEntry.value;

          return Padding(
            padding: const EdgeInsets.all(5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  line['name'],
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const Divider(height: 24),
                ...line['files'].asMap().entries.map<Widget>((fileEntry) {
                  final file = fileEntry.value;
                  return _buildFileTile(
                      context, file, 'lines', provider, isEdit,
                      lineId: line['id']);
                }).toList(),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  /// Displays a placeholder when a section has no files.
  Widget _buildEmptySection(BuildContext context, String message) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 24.0),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.folder_open, size: 48, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            message,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Colors.grey[600],
                ),
          ),
        ],
      ),
    );
  }

  /// Builds an individual file tile with selection and custom fields.
  ///
  /// [section] - 'header', 'footer', or 'lines'.
  /// [lineId] - Optional line ID for product documents.
  Widget _buildFileTile(BuildContext context, Map<String, dynamic> file,
      String section, QuoteBuilderProvider provider, bool isEdit,
      {int? lineId}) {
    final theme = Theme.of(context);

    bool isSelected = section == 'header' &&
            provider.selectedHeaderIds.contains(file['id']) ||
        section == 'footer' &&
            provider.selectedFooterIds.contains(file['id']) ||
        (section == 'lines' &&
            lineId != null &&
            provider.selectedProductDocs[lineId]?.contains(file['id']) == true);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                if (isEdit) {
                  provider.toggleSelection(file['id'], section, lineId: lineId);
                }
              },
              borderRadius: BorderRadius.circular(12),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: double.infinity,
                padding:
                    const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                decoration: BoxDecoration(
                  color: isSelected
                      ? theme.primaryColor.withOpacity(0.15)
                      : AppColors().fillColor,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected
                        ? theme.primaryColor
                        : AppColors().subHeading,
                    width: isSelected ? 2 : 1,
                  ),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: theme.primaryColor.withOpacity(0.2),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          )
                        ]
                      : null,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        file['name'],
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight:
                              isSelected ? FontWeight.w600 : FontWeight.normal,
                          color: isSelected
                              ? theme.primaryColor
                              : theme.colorScheme.onSurface,
                        ),
                      ),
                    ),

                    /// Custom fields display for selected file
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isSelected
                            ? theme.primaryColor
                            : Colors.transparent,
                        border: Border.all(
                          color: isSelected
                              ? theme.primaryColor
                              : Colors.grey[400]!,
                        ),
                      ),
                      child: Icon(
                        isSelected ? Icons.check : Icons.add,
                        size: 16,
                        color: isSelected ? Colors.white : Colors.grey[400],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            height: isSelected &&
                    file['custom_form_fields'] != null &&
                    file['custom_form_fields'].isNotEmpty
                ? null
                : 0,
            padding: EdgeInsets.symmetric(
                vertical: isSelected &&
                        file['custom_form_fields'] != null &&
                        file['custom_form_fields'].isNotEmpty
                    ? 16
                    : 0),
            child: ClipRect(
              child: isSelected &&
                      file['custom_form_fields'] != null &&
                      file['custom_form_fields'].isNotEmpty
                  ? Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors().fillColor,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey[300]!),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Custom Fields",
                            style: theme.textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 12),
                          ...file['custom_form_fields'].map<Widget>((field) {
                            String controllerKey =
                                "${file['id']}_${field['name']}";
                            TextEditingController controller = section ==
                                    'header'
                                ? provider.headerFieldControllers.putIfAbsent(
                                    controllerKey,
                                    () => TextEditingController(
                                        text: field['value']))
                                : section == 'footer'
                                    ? provider.footerFieldControllers
                                        .putIfAbsent(
                                            controllerKey,
                                            () => TextEditingController(
                                                text: field['value']))
                                    : provider.productFieldControllers
                                        .putIfAbsent(
                                            controllerKey,
                                            () => TextEditingController(
                                                text: field['value']));

                            return Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: TextFormField(
                                controller: controller,
                                decoration: InputDecoration(
                                  labelText: field['name'],
                                  floatingLabelBehavior:
                                      FloatingLabelBehavior.always,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  filled: true,
                                  fillColor: Colors.grey[50],
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 16,
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ],
                      ),
                    )
                  : const SizedBox.shrink(),
            ),
          ),
        ],
      ),
    );
  }
}
