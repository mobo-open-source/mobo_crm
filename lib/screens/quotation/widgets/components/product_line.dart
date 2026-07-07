import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

import 'package:mobo_crm/initilisation.dart';
import 'package:mobo_crm/screens/quotation/provider/quotation_form_provider.dart';
import 'package:mobo_crm/screens/quotation/widgets/components/custom_components.dart';
import 'package:mobo_crm/screens/quotation/provider/quotation_view_provider.dart';

import 'package:provider/provider.dart';

/// A tab widget that displays the main order lines of a quotation.
///
/// The [OrderLinesTab] widget uses [QuotationFormProvider] and [OdooClientManager]
/// to fetch and display the products associated with a quotation. It supports:
/// - Displaying a list of products in the order with quantity, unit price, total, and discount.
/// - Handling editable products if [isEdit] is true.
/// - Showing sections for products that have a `type` (treated as a section header).
/// - Tapping on a product allows editing or adding details via a bottom sheet.
///
/// The widget automatically calculates the currency symbol based on the
/// selected currency code or defaults to the provider/client settings.
///
/// Example usage:
/// ```dart
/// OrderLinesTab()
/// ```
class OrderLinesTab extends StatefulWidget {
  const OrderLinesTab({super.key});

  @override
  OrderLinesTabState createState() => OrderLinesTabState();
}

/// State class for [OrderLinesTab] handling UI updates and user interaction.
class OrderLinesTabState extends State<OrderLinesTab> {
  @override
  Widget build(BuildContext context) {
    return Consumer2<QuotationFormProvider, OdooClientManager>(
        builder: (context, provider, clientprovider, child) {
      if (provider.productlinedata.isEmpty) {
        final screenHeight = MediaQuery.of(context).size.height;
        final isSmall = screenHeight < 700;
        final minBoxHeight = screenHeight * (isSmall ? 0.18 : 0.23);
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Container(
            width: double.infinity,
            constraints: BoxConstraints(minHeight: minBoxHeight),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey[200]!),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  HugeIcons.strokeRoundedShoppingBasket01,
                  size: isSmall ? 40.0 : 52.0,
                  color: Colors.grey[400],
                ),
                SizedBox(height: isSmall ? 12 : 16),
                Text(
                  'No products added yet',
                  style: TextStyle(
                    fontSize: isSmall ? 14.0 : 16.0,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        );
      } else {
        return Column(
          children: provider.productlinedata.map((data) {
            int index = provider.productlinedata.indexOf(data);

            final quotationViewProvider =
                Provider.of<QuotationViewProvider>(context, listen: false);
            int? currencyId = provider.currencycode;
            String? currencySymbol;
            if (currencyId != null &&
                quotationViewProvider.currencySymbolMap
                    .containsKey(currencyId)) {
              currencySymbol =
                  quotationViewProvider.currencySymbolMap[currencyId];
            }
            currencySymbol ??= provider.currencySymbol ??
                clientprovider.currencySymbol ??
                ' 24';

            if ((data.type == null)) {
              return ProductListTile(
                onOptionalTap: () {},
                onTap: () async {
                  if (provider.isEdit && provider.isAbsorbed == false) {
                    if (clientprovider.allproducts.isEmpty) {
                      await clientprovider.getFullProductData(
                          clientprovider.client!,
                          clientprovider.currentsession!,
                          context);
                    }
                    if (data.isDownPayment != true) {
                      if (context.mounted) {
                        provider.showAddProductBottomSheet(
                            index,
                            true,
                            context,
                            clientprovider.client!,
                            clientprovider.currentsession!);
                      }
                    }
                  }
                },
                discount: data.discount!,
                type: data.type ?? "invoice",
                index: index,
                productName: data.product!,
                quantity: data.quantity!,
                unitPrice: data.unitPrice!,
                totalPrice: data.amount!,
                id: data.id,
                currencySymbol: currencySymbol,
              );
            } else {
              return Padding(
                padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
                child: GestureDetector(
                  onTap: () {
                    if (provider.isEdit) {
                      provider.showEditSectionBottomSheet(
                          data.type!, index, true, context);
                    }
                  },
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          data.product ?? "Untitled Section",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[800],
                            letterSpacing: -0.2,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }
          }).toList(),
        );
      }
    });
  }
}

/// A widget that displays optional products associated with a quotation.
///
/// Optional products can be added to the main order. The widget:
/// - Displays a placeholder or Lottie animation if no optional products exist.
/// - Allows adding optional products to the main quotation if [isEdit] is true.
/// - Calculates the currency symbol for displaying unit and total prices.
/// - Uses [ProductListTile] for each optional product.
///
/// Example usage:
/// ```dart
/// OptionalProductsList()
/// ```
class OptionalProductsList extends StatefulWidget {
  /// Creates a widget for displaying optional products in a quotation.
  const OptionalProductsList({super.key});

  @override
  State<OptionalProductsList> createState() => _OptionalProductsListState();
}

/// State class for [OptionalProductsList] handling UI and user interactions.
class _OptionalProductsListState extends State<OptionalProductsList> {
  @override
  Widget build(BuildContext context) {
    return Consumer2<QuotationFormProvider, OdooClientManager>(
      builder: (context, provider, clientprovider, child) {
        if (provider.optionalProductData.isEmpty) {
          final screenHeight = MediaQuery.of(context).size.height;
          final isSmall = screenHeight < 700;
          final minBoxHeight = screenHeight * (isSmall ? 0.18 : 0.23);
          return Padding(
            padding: EdgeInsets.fromLTRB(16, isSmall ? 12.0 : 16.0, 16, 0),
            child: Container(
              width: double.infinity,
              constraints: BoxConstraints(minHeight: minBoxHeight),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey[200]!),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    HugeIcons.strokeRoundedPackage,
                    size: isSmall ? 40.0 : 52.0,
                    color: Colors.grey[400],
                  ),
                  SizedBox(height: isSmall ? 12 : 16),
                  Text(
                    'No optional products',
                    style: TextStyle(
                      fontSize: isSmall ? 14.0 : 16.0,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: provider.optionalProductData.map<Widget>((product) {
              int index = provider.optionalProductData.indexOf(product);

              final quotationViewProvider =
                  Provider.of<QuotationViewProvider>(context, listen: false);
              int? currencyId = provider.currencycode;
              String? currencySymbol;
              if (currencyId != null &&
                  quotationViewProvider.currencySymbolMap
                      .containsKey(currencyId)) {
                currencySymbol =
                    quotationViewProvider.currencySymbolMap[currencyId];
              }
              currencySymbol ??= provider.currencySymbol ??
                  clientprovider.currencySymbol ??
                  ' 24';

              return ProductListTile(
                onOptionalTap: () {
                  setState(() {
                    provider.addOptionalProductsToMain(
                      productName: product['product_name'],
                      id: product['product_id']!,
                      quantity: (product['quantity'] as num).toDouble(),
                      unitPrice: (product['price'] as num?)?.toDouble() ?? 0.0,
                    );
                  });
                },
                isOptional: provider.isIdPresentInEither(product['id']),
                onTap: () async {
                  if (provider.isEdit) {
                    if (clientprovider.allproducts.isEmpty) {
                      await clientprovider.getFullProductData(
                          clientprovider.client!,
                          clientprovider.currentsession!,
                          context);
                    }

                    if (context.mounted) {
                      provider.showAddOptionalProductBottomSheet(
                        index,
                        true,
                        context,
                        clientprovider.client!,
                        clientprovider.currentsession!,
                      );
                    }
                  }
                },
                type: "optional",
                index: index,
                productName: product['product_name'] ?? "Unknown Product",
                quantity: (product['quantity'] as num).toDouble(),
                unitPrice: (product['price'] as num?)?.toDouble() ?? 0.0,
                totalPrice: (product['quantity'] as num).toDouble() *
                    ((product['price'] as num?)?.toDouble() ?? 0.0),
                id: product['product_id'] ?? 0,
                currencySymbol: currencySymbol,
              );
            }).toList(),
          ),
        );
      },
    );
  }
}
