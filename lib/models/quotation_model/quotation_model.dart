/// Represents a sales quotation summary.
///
/// Contains financial totals and partner information.
class QuotationModel {
  final int id;
  final String partnerName;
  final double currencyRate;
  final double prepaymentPercent;
  final double amountTax;
  final double amountTotal;
  final double amountUntaxed;

  /// Creates a [QuotationModel] instance.
  QuotationModel({
    required this.id,
    required this.partnerName,
    required this.currencyRate,
    required this.prepaymentPercent,
    required this.amountTax,
    required this.amountTotal,
    required this.amountUntaxed,
  });

  /// Creates a [QuotationModel] from a JSON map.
  ///
  /// Provides safe fallbacks for missing or null values.
  factory QuotationModel.fromJson(Map<String, dynamic> json) {
    return QuotationModel(
      id: json['id'] ?? 0,
      partnerName: json['partner_id'] != null && json['partner_id'] is List
          ? json['partner_id'][1]
          : 'Unknown',
      currencyRate: (json['currency_rate'] ?? 1.0).toDouble(),
      prepaymentPercent: (json['prepayment_percent'] ?? 0).toDouble(),
      amountTax: (json['amount_tax'] ?? 0).toDouble(),
      amountTotal: (json['amount_total'] ?? 0).toDouble(),
      amountUntaxed: (json['amount_untaxed'] ?? 0).toDouble(),
    );
  }
}

/// Represents detailed sale order information.
///
/// Includes metadata, financial totals, order lines,
/// optional products, and document attachments.
class SaleOrderData {
  final int saleOrderId;
  final String quotationName;
  final String status;
  final String customerName;
  final String companyName;
  final String salesperson;
  final String? campaign;
  final String? medium;
  final String? source;
  final String? validityDate;
  final String? orderDate;
  final bool requireSignature;
  final bool requirePayment;
  final String? currencySymbol;
  final double totalAmount;
  final double totaluntaxed;
  final double taxedAmount;
  final List<ProductLine> orderLines;
  final List<Map<String, dynamic>> optionalProducts;
  final String? base64;

  /// Creates a [SaleOrderData] instance.
  SaleOrderData({
    required this.base64,
    required this.taxedAmount,
    required this.totaluntaxed,
    required this.saleOrderId,
    required this.quotationName,
    required this.status,
    required this.customerName,
    required this.companyName,
    required this.salesperson,
    this.campaign,
    this.medium,
    this.source,
    this.validityDate,
    this.orderDate,
    required this.requireSignature,
    required this.requirePayment,
    required this.currencySymbol,
    required this.totalAmount,
    required this.orderLines,
    required this.optionalProducts,
  });
}

/// Represents a single product line inside a sale order.
class ProductLine {
  final int? id;
  final double? discount;
  final String? product;
  final double? quantity;
  final double? unitPrice;
  final double? amount;
  final String? description;
  final List<dynamic> taxIds;
  final String? type;
  final List<int> productDocumentIds;
  int? orderlineId;
  bool isDownPayment;

  /// Creates a [ProductLine] instance.
  ProductLine({
    required this.description,
    this.type,
    this.discount = 0,
    required this.id,
    required this.product,
    required this.quantity,
    required this.unitPrice,
    required this.amount,
    required this.taxIds,
    this.orderlineId,
    this.isDownPayment = false,
    this.productDocumentIds = const [],
  });

  /// Returns a copy of this [ProductLine] with updated values.
  ProductLine copyWith({
    int? id,
    String? product,
    double? quantity,
    double? unitPrice,
    double? amount,
    String? description,
    List<dynamic>? taxIds,
    String? type,
    bool? isDownPayment,
    int? orderlineId,
    List<int>? productDocumentIds,
  }) {
    return ProductLine(
      id: id ?? this.id,
      isDownPayment: isDownPayment ?? this.isDownPayment,
      orderlineId: orderlineId ?? this.orderlineId,
      product: product ?? this.product,
      quantity: quantity ?? this.quantity,
      unitPrice: unitPrice ?? this.unitPrice,
      amount: amount ?? this.amount,
      description: description ?? this.description,
      taxIds: taxIds ?? this.taxIds,
      type: type ?? this.type,
      productDocumentIds: productDocumentIds ?? this.productDocumentIds,
    );
  }

  /// Creates a [ProductLine] from a map.
  ///
  /// Supports both `tax_ids` and `tax_id` keys.
  factory ProductLine.fromMap(Map<String, dynamic> map) {
    List<dynamic> taxList = [];
    if (map.containsKey('tax_ids')) {
      taxList = map['tax_ids'] ?? [];
    } else if (map.containsKey('tax_id')) {
      taxList = map['tax_id'] ?? [];
    }

    return ProductLine(
      description: map['description'] as String?,
      id: map['id'] as int?,
      product: map['product'] as String?,
      quantity: (map['quantity'] as num?)?.toDouble(),
      unitPrice: (map['unit_price'] as num?)?.toDouble(),
      amount: (map['amount'] as num?)?.toDouble(),
      discount: (map['discount'] as num?)?.toDouble(),
      taxIds: taxList.map((id) => id as int).toList(),
      type: map['type'] as String?,
      productDocumentIds: (map['product_document_ids'] as List<dynamic>?)
              ?.map((id) => id as int)
              .toList() ??
          [],
    );
  }
}

/// Represents a sale order template configuration.
class SaleOrderTemplate {
  final int id;
  final String name;
  final List<dynamic>? mailTemplateId;
  final int? numberOfDays;

  /// Creates a [SaleOrderTemplate] instance.
  SaleOrderTemplate({
    required this.id,
    required this.name,
    this.mailTemplateId,
    this.numberOfDays,
  });

  /// Creates a [SaleOrderTemplate] from JSON.
  factory SaleOrderTemplate.fromJson(Map<String, dynamic> json) {
    return SaleOrderTemplate(
      id: json['id'],
      name: json['name'] ?? '',
      mailTemplateId:
          json['mail_template_id'] != false ? json['mail_template_id'] : [],
      numberOfDays: json['number_of_days'],
    );
  }
}

/// Represents a payment term configuration.
class PaymentTerm {
  final int id;
  final String name;

  /// Creates a [PaymentTerm] instance.
  PaymentTerm({
    required this.id,
    required this.name,
  });

  /// Creates a [PaymentTerm] from JSON.
  factory PaymentTerm.fromJson(Map<String, dynamic> json) {
    return PaymentTerm(
      id: json['id'] as int,
      name: json['name'] as String? ?? '',
    );
  }
}
