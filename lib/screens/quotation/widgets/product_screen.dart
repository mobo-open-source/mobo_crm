import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:mobo_crm/initilisation.dart';
import 'package:mobo_crm/screens/quotation/provider/quotation_view_provider.dart';
import 'package:mobo_crm/screens/quotation/provider/quotebuilder_provider.dart';

import 'package:mobo_crm/screens/quotation/widgets/components/product_line.dart';

import 'package:mobo_crm/screens/quotation/provider/quotation_form_provider.dart';

import 'package:provider/provider.dart';

/// MainScreen widget displays the primary product management interface for a quotation.
///
/// This screen allows users to view and manage all products and sections associated
/// with a quotation. It integrates with multiple providers to fetch product data,
/// manage editing state, and update the quotation dynamically.
///
/// Key Features:
/// 1. Displays a header for "Product Information".
/// 2. Provides action buttons in edit mode for:
///    - Adding a new product.
///    - Adding a new section.
///    - Adding a note.
/// 3. Shows the list of quotation order lines using the [OrderLinesTab] widget.
/// 4. Supports both editable (`isEdit == true`) and read-only (`isEdit == false`) modes.
/// 5. Fetches all product data dynamically if the client provider has no cached products.
///
/// Example usage:
/// ```dart
/// MainScreen();
/// ```
class MainScreen extends StatefulWidget {
  /// Creates a MainScreen widget.
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer4<OdooClientManager, QuotationFormProvider,
        QuoteBuilderProvider, QuotationViewProvider>(
      builder: (context, clientprovider, provider, quotebuilderprovider,
          quotationviewprovider, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
              ),
              child: Row(
                children: [
                  HugeIcon(
                    icon: HugeIcons.strokeRoundedShoppingBasket01,
                    color: Colors.grey[700]!,
                    size: 22,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    "Products",
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
            Divider(height: 1, color: Colors.grey[200], indent: 16, endIndent: 16),
            if (provider.isEdit && provider.isAbsorbed == false) ...[
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Search Product to Add",
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 8),
                    GestureDetector(
                      onTap: () {
                        if (clientprovider.allproducts.isEmpty) {
                          clientprovider.getFullProductData(
                            clientprovider.client!,
                            clientprovider.currentsession!,
                            context,
                          );
                        }
                        provider.showAddProductBottomSheet(
                          null,
                          false,
                          context,
                          clientprovider.client!,
                          clientprovider.currentsession!,
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 16,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xffF8FAFB),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey[200]!),
                        ),
                        child: Row(
                          children: [
                            HugeIcon(
                              icon: HugeIcons.strokeRoundedPackage,
                              color: Colors.grey[500]!,
                              size: 18,
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                "Search products...",
                                style: TextStyle(
                                  color: Colors.grey[500],
                                  fontSize: 15,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                            HugeIcon(
                              icon: HugeIcons.strokeRoundedArrowDown01,
                              color: Colors.grey[500]!,
                              size: 16,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Column(
                  children: [
                    const OrderLinesTab(),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

/// OptionalProductScreen widget displays and manages optional products for a quotation.
///
/// This screen is only visible if the "Sales" module is installed (`isSaleInstalled == true`).
/// It provides UI to add optional products, view existing optional products, and handle
/// the case when no optional products exist.
///
/// Key Features:
/// 1. Displays a header for "Optional Products".
/// 2. In edit mode:
///    - Provides a button to add new optional products.
///    - Shows a placeholder message if no optional products exist.
/// 3. Lists all optional products using the [OptionalProductsList] widget.
/// 4. Handles read-only mode gracefully by showing a message if the Sales module is not installed.
/// 5. Supports fetching all product data dynamically from the client provider.
///
/// Example usage:
/// ```dart
/// OptionalProductScreen();
/// ```
class OPtionalProductScreen extends StatelessWidget {
  /// Creates an OptionalProductScreen widget.
  const OPtionalProductScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final isSmall = screenHeight < 700;
    final headerPad = isSmall ? 12.0 : 18.0;
    final headerFontSize = isSmall ? 16.0 : 18.0;
    final sectionPadV = isSmall ? 10.0 : 16.0;
    final sectionPadH = isSmall ? 12.0 : 16.0;
    final labelFontSize = isSmall ? 13.0 : 14.0;
    final searchFieldPadV = isSmall ? 12.0 : 16.0;

    return Consumer4<OdooClientManager, QuotationFormProvider,
        QuoteBuilderProvider, QuotationViewProvider>(
      builder: (context, clientprovider, provider, quotebuilderprovider,
          quotationviewprovider, child) {
        return provider.isSaleInstalled
            ? Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: headerPad, vertical: 16),
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                    ),
                  ),
                  child: Row(
                    children: [
                      HugeIcon(
                        icon: HugeIcons.strokeRoundedPackage,
                        color: Colors.grey[700]!,
                        size: isSmall ? 18.0 : 22.0,
                      ),
                      SizedBox(width: isSmall ? 8.0 : 10.0),
                      Text(
                        "Optional Products",
                        style: TextStyle(
                          fontSize: headerFontSize,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[900],
                          letterSpacing: -0.3,
                        ),
                      ),
                    ],
                  ),
                ),
                Divider(height: 1, color: Colors.grey[200], indent: 16, endIndent: 16),
                if (provider.isEdit) ...[
                  Padding(
                    padding: EdgeInsets.fromLTRB(
                        sectionPadH, sectionPadV, sectionPadH, sectionPadV * 0.5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Search Product to Add",
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: labelFontSize,
                            color: Colors.grey[600],
                          ),
                        ),
                        SizedBox(height: isSmall ? 6.0 : 8.0),
                        GestureDetector(
                          onTap: () async {
                            if (clientprovider.allproducts.isEmpty) {
                              await clientprovider.getFullProductData(
                                clientprovider.client!,
                                clientprovider.currentsession!,
                                context,
                              );
                            }
                            if (context.mounted) {
                              provider.showAddOptionalProductBottomSheet(
                                null,
                                false,
                                context,
                                clientprovider.client!,
                                clientprovider.currentsession!,
                              );
                            }
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: sectionPadH,
                              vertical: searchFieldPadV,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xffF8FAFB),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.grey[200]!),
                            ),
                            child: Row(
                              children: [
                                HugeIcon(
                                  icon: HugeIcons.strokeRoundedPackage,
                                  color: Colors.grey[500]!,
                                  size: 18,
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    "Search products...",
                                    style: TextStyle(
                                      color: Colors.grey[500],
                                      fontSize: isSmall ? 13.0 : 15.0,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ),
                                HugeIcon(
                                  icon: HugeIcons.strokeRoundedArrowDown01,
                                  color: Colors.grey[500]!,
                                  size: 16,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        const OptionalProductsList(),
                        SizedBox(height: isSmall ? 24.0 : 40.0),
                      ],
                    ),
                  ),
                ),
              ])
            : Expanded(
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.all(isSmall ? 16.0 : 24.0),
                    child: Text(
                      "The Sales module is required to access this feature. Please contact your administrator to enable it.",
                      style: TextStyle(
                          fontSize: isSmall ? 13.0 : 14.0,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey[600]),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              );
      },
    );
  }
}
