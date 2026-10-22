import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:provider/provider.dart';

import '../../../../global_methods/widgets/forms/field_label.dart';
import '../../../../global_methods/widgets/textfields/multi_select_textfield.dart';
import '../../../../initilisation.dart';
import '../../../../models/models.dart';
import '../../../../models/quotation_model/quotation_model.dart';
import '../../../../utils/app_theme.dart';
import '../../provider/quotation_form_provider.dart';

/// Editable order line: quantity, unit price and taxes change in place and
/// the line total updates as you type.
class QuotationLineCard extends StatefulWidget {
  final int index;
  final ProductLine line;
  final String currencySymbol;

  const QuotationLineCard({
    super.key,
    required this.index,
    required this.line,
    required this.currencySymbol,
  });

  @override
  State<QuotationLineCard> createState() => _QuotationLineCardState();
}

class _QuotationLineCardState extends State<QuotationLineCard> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final client = context.read<OdooClientManager>();
      if (client.client != null && client.currentsession != null) {
        context
            .read<QuotationFormProvider>()
            .ensureTaxList(client.client!, client.currentsession!);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<QuotationFormProvider>();
    final line = widget.line;
    final selectedTaxes =
        provider.taxList.where((tax) => line.taxIds.contains(tax.id)).toList();

    return EditableProductLineCard(
      productId: line.id,
      productName: line.product,
      quantity: line.quantity ?? 1,
      unitPrice: line.unitPrice ?? 0,
      total: line.amount ?? 0,
      currencySymbol: widget.currencySymbol,
      onQuantityChanged: (qty) =>
          provider.updateProductLine(widget.index, quantity: qty),
      onPriceChanged: (price) =>
          provider.updateProductLine(widget.index, unitPrice: price),
      onDelete: () => provider.removeProductLine(widget.index),
      footer: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const FieldLabel('Taxes'),
          const SizedBox(height: 10),
          MultiSelectSearchableDropdown<Tax>(
            items: provider.taxList,
            displayText: (tax) => tax.name,
            idSelector: (tax) => tax.id,
            hintText: 'No taxes',
            initialValue: selectedTaxes,
            onSelectionChanged: (taxes) => provider.updateProductLine(
                widget.index,
                taxIds: taxes.map<int>((t) => t.id).toList()),
          ),
        ],
      ),
    );
  }
}

/// Editable optional product, with a cart action that moves it into the
/// order lines.
class OptionalProductCard extends StatelessWidget {
  final int index;
  final Map<dynamic, dynamic> item;
  final String currencySymbol;

  const OptionalProductCard({
    super.key,
    required this.index,
    required this.item,
    required this.currencySymbol,
  });

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<QuotationFormProvider>();
    final client = context.read<OdooClientManager>().client!;
    final quantity = (item['quantity'] as num?)?.toDouble() ?? 1;
    final price = (item['price'] as num?)?.toDouble() ?? 0;
    final productId = item['product_id'];
    final isInOrder =
        provider.productlinedata.any((line) => line.id == productId);

    return EditableProductLineCard(
      productId: productId,
      productName: item['product_name'],
      quantity: quantity,
      unitPrice: price,
      total: quantity * price,
      currencySymbol: currencySymbol,
      onQuantityChanged: (qty) =>
          provider.updateOptionalProduct(index, client, quantity: qty),
      onPriceChanged: (value) =>
          provider.updateOptionalProduct(index, client, price: value),
      onDelete: () => provider.removeOptionalProduct(index, client),
      headerAction: isInOrder
          ? const Tooltip(
              message: 'Already in the order',
              child: Padding(
                padding: EdgeInsets.all(8),
                child: Icon(Icons.shopping_cart_checkout,
                    color: StatusColors.statusGreen, size: 20),
              ),
            )
          : IconButton(
              tooltip: 'Add to order',
              icon: const Icon(Icons.shopping_cart_checkout,
                  color: AppTheme.primaryColor, size: 20),
              onPressed: () {
                final current =
                    Map<String, dynamic>.from(provider.optionalProductData[index]);
                provider.addOptionalProductsToMain(
                  productName: current['product_name'],
                  id: current['product_id'],
                  quantity: (current['quantity'] as num).toDouble(),
                  unitPrice: (current['price'] as num?)?.toDouble() ?? 0.0,
                );
              },
            ),
    );
  }
}

/// Shared line card body: name + SKU with actions, then quantity,
/// unit price and line total. Fields keep their own text and only re-sync
/// from the incoming values while they aren't focused, so typing is never
/// overwritten by a rebuild.
class EditableProductLineCard extends StatefulWidget {
  final dynamic productId;
  final String? productName;
  final double quantity;
  final double unitPrice;
  final double total;
  final String currencySymbol;
  final ValueChanged<double> onQuantityChanged;
  final ValueChanged<double> onPriceChanged;
  final VoidCallback onDelete;

  /// Extra action shown before the delete button.
  final Widget? headerAction;

  /// Extra content under the numbers row (e.g. a tax picker).
  final Widget? footer;

  const EditableProductLineCard({
    super.key,
    required this.productId,
    required this.productName,
    required this.quantity,
    required this.unitPrice,
    required this.total,
    required this.currencySymbol,
    required this.onQuantityChanged,
    required this.onPriceChanged,
    required this.onDelete,
    this.headerAction,
    this.footer,
  });

  @override
  State<EditableProductLineCard> createState() =>
      _EditableProductLineCardState();
}

class _EditableProductLineCardState extends State<EditableProductLineCard> {
  late final TextEditingController _qtyController;
  late final TextEditingController _priceController;
  final FocusNode _qtyFocus = FocusNode();
  final FocusNode _priceFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    _qtyController = TextEditingController(text: _formatQty(widget.quantity));
    _priceController =
        TextEditingController(text: widget.unitPrice.toStringAsFixed(2));
  }

  @override
  void didUpdateWidget(covariant EditableProductLineCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Re-sync (e.g. after a card above is removed and cards shift up), but
    // never under the user's cursor.
    if (!_qtyFocus.hasFocus &&
        (double.tryParse(_qtyController.text) ?? 0) != widget.quantity) {
      _qtyController.text = _formatQty(widget.quantity);
    }
    if (!_priceFocus.hasFocus &&
        (double.tryParse(_priceController.text) ?? 0) != widget.unitPrice) {
      _priceController.text = widget.unitPrice.toStringAsFixed(2);
    }
  }

  @override
  void dispose() {
    _qtyController.dispose();
    _priceController.dispose();
    _qtyFocus.dispose();
    _priceFocus.dispose();
    super.dispose();
  }

  String _formatQty(double qty) =>
      qty == qty.roundToDouble() ? qty.toStringAsFixed(0) : qty.toString();

  void _setQuantity(double qty) {
    final value = qty > 0 ? qty : 1.0;
    _qtyController.text = _formatQty(value);
    widget.onQuantityChanged(value);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final products = context.select<OdooClientManager, List>(
        (client) => client.allproducts);
    final product = products.cast<dynamic>().firstWhere(
          (p) => p['id'] == widget.productId,
          orElse: () => null,
        );
    final code = product?['default_code'];
    final sku = code is String && code.isNotEmpty ? code : '-';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.surface(isDark),
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(
          color: isDark ? Colors.grey[700]! : Colors.grey[200]!,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.productName ?? 'Unnamed Product',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.valueColor(isDark),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'SKU: $sku',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppTheme.secondaryLabelColor(isDark),
                      ),
                    ),
                  ],
                ),
              ),
              if (widget.headerAction != null) widget.headerAction!,
              IconButton(
                tooltip: 'Delete',
                icon: const Icon(HugeIcons.strokeRoundedDelete02,
                    color: StatusColors.statusRed, size: 20),
                onPressed: widget.onDelete,
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: _Labeled(
                  label: 'Quantity',
                  child: _quantityField(isDark),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _Labeled(
                  label: 'Unit Price',
                  child: TextField(
                    controller: _priceController,
                    focusNode: _priceFocus,
                    textAlign: TextAlign.right,
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    cursorColor: AppTheme.primaryColor,
                    style: AppTheme.fieldValueStyle(isDark),
                    decoration: _numericDecoration(isDark).copyWith(
                      prefixIcon: Padding(
                        padding: const EdgeInsets.only(left: 12, right: 6),
                        child: Center(
                          widthFactor: 1,
                          child: Text(
                            widget.currencySymbol,
                            style: TextStyle(
                                color: AppTheme.secondaryLabelColor(isDark)),
                          ),
                        ),
                      ),
                      prefixIconConstraints:
                          const BoxConstraints(minWidth: 0, minHeight: 0),
                    ),
                    onTapOutside: (_) => _priceFocus.unfocus(),
                    onTap: () => _priceController.selection = TextSelection(
                      baseOffset: 0,
                      extentOffset: _priceController.text.length,
                    ),
                    onChanged: (text) => widget.onPriceChanged(double.tryParse(
                            text.replaceAll(RegExp(r'[^\d.]'), '')) ??
                        0.0),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              _Labeled(
                label: 'Total',
                alignEnd: true,
                child: SizedBox(
                  height: 44,
                  child: Center(
                    child: Text(
                      '${widget.currencySymbol}${widget.total.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : AppTheme.primaryColor,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          if (widget.footer != null) ...[
            const SizedBox(height: 12),
            widget.footer!,
          ],
        ],
      ),
    );
  }

  /// Plain numeric field rather than a +/- stepper: in a card's third of the
  /// width, the two 48px tap targets (Material 3 pads icon buttons to that)
  /// left the number itself no room, so the quantity never showed.
  Widget _quantityField(bool isDark) {
    return TextField(
      controller: _qtyController,
      focusNode: _qtyFocus,
      textAlign: TextAlign.center,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      cursorColor: AppTheme.primaryColor,
      style: AppTheme.fieldValueStyle(isDark),
      decoration: _numericDecoration(isDark).copyWith(hintText: '1'),
      onTap: () => _qtyController.selection = TextSelection(
        baseOffset: 0,
        extentOffset: _qtyController.text.length,
      ),
      onChanged: (text) {
        final value = double.tryParse(text);
        if (value != null && value > 0) widget.onQuantityChanged(value);
      },
      onTapOutside: (_) {
        if ((double.tryParse(_qtyController.text) ?? 0) <= 0) {
          _setQuantity(1);
        }
        _qtyFocus.unfocus();
      },
    );
  }

  InputDecoration _numericDecoration(bool isDark) {
    final idle = OutlineInputBorder(
      borderSide: BorderSide.none,
      borderRadius: BorderRadius.circular(AppRadius.numeric),
    );
    return InputDecoration(
      isDense: true,
      filled: true,
      fillColor: AppTheme.inputFill(isDark),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      border: idle,
      enabledBorder: idle,
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: AppTheme.primaryColor, width: 2),
        borderRadius: BorderRadius.circular(AppRadius.numeric),
      ),
    );
  }
}

class _Labeled extends StatelessWidget {
  final String label;
  final Widget child;
  final bool alignEnd;

  const _Labeled(
      {required this.label, required this.child, this.alignEnd = false});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Column(
      crossAxisAlignment:
          alignEnd ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: AppTheme.secondaryLabelColor(isDark),
          ),
        ),
        const SizedBox(height: 6),
        child,
      ],
    );
  }
}
