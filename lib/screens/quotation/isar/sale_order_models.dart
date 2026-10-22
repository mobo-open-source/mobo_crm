import 'package:isar_community/isar.dart';

part 'sale_order_models.g.dart';

/// Represents a cached sale order in Isar.
///
/// Stores all relevant details of a sale order, including customer, company,
/// payment, fiscal position, campaign, and other metadata. Can be constructed
/// from a JSON map.
@collection
class SaleOrderIsarCache {
  SaleOrderIsarCache();

  Id id = Isar.autoIncrement;
  int? serverId;
  String? name;
  String? state;
  List<int>? invoiceIds;
  String? signature;
  String? signedBy;
  String? signedOn;
  String? commitmentDate;
  String? customerAddress;
  int? userId;
  String? userName;

  int? companyId;
  String? companyName;

  bool? requireSignature;
  bool? requirePayment;
  String? clientOrderRef;

  int? fiscalPositionId;
  String? fiscalPositionName;

  int? journalId;
  String? journalName;

  String? origin;
  double? amountUntaxed;

  int? opportunityId;

  int? campaignId;
  String? campaignName;

  int? mediumId;
  String? mediumName;

  int? sourceId;
  String? sourceName;

  int? teamId;
  String? invoiceStatus;
  List<int>? tagIds;

  int? saleOrderTemplateId;
  String? saleOrderTemplateName;

  String? validityDate;
  String? dateOrder;

  int? paymentTermId;
  String? paymentTermName;

  int? partnerId;
  String? partnerName;

  double? amountTotal;
  double? amountTax;

  int? currencyId;
  String? currencySymbol;

  /// Indexed server ID for search queries.
  @Index(type: IndexType.value)
  int? searchServerId;

  /// Factory method to create a `SaleOrderIsarCache` from a JSON map.
  factory SaleOrderIsarCache.fromJson(Map<String, dynamic> json) {
    return SaleOrderIsarCache()
      ..serverId = _asInt(json['id'])
      ..name = _asString(json['name'])
      ..customerAddress = _asString(json['customerAddress'])
      ..state = _asString(json['state'])
      ..invoiceIds = _getIdList(json['invoice_ids'])
      ..signature = _asString(json['signature'])
      ..signedBy = _asString(json['signed_by'])
      ..signedOn = _asString(json['signed_on'])
      ..commitmentDate = _asString(json['commitment_date'])
      ..userId = _getId(json['user_id'])
      ..userName = _getName(json['user_id'])
      ..companyId = _getId(json['company_id'])
      ..companyName = _getName(json['company_id'])
      ..requireSignature = json['require_signature'] == true
      ..requirePayment = json['require_payment'] == true
      ..clientOrderRef = _asString(json['client_order_ref'])
      ..fiscalPositionId = _getId(json['fiscal_position_id'])
      ..fiscalPositionName = _getName(json['fiscal_position_id'])
      ..journalId = _getId(json['journal_id'])
      ..journalName = _getName(json['journal_id'])
      ..origin = _asString(json['origin'])
      ..amountUntaxed = _asDouble(json['amount_untaxed'])
      ..opportunityId = _getId(json['opportunity_id'])
      ..campaignId = _getId(json['campaign_id'])
      ..campaignName = _getName(json['campaign_id'])
      ..mediumId = _getId(json['medium_id'])
      ..mediumName = _getName(json['medium_id'])
      ..sourceId = _getId(json['source_id'])
      ..sourceName = _getName(json['source_id'])
      ..teamId = _getId(json['team_id'])
      ..invoiceStatus = _asString(json['invoice_status'])
      ..tagIds = _getIdList(json['tag_ids'])
      ..saleOrderTemplateId = _getId(json['sale_order_template_id'])
      ..saleOrderTemplateName = _getName(json['sale_order_template_id'])
      ..validityDate = _asString(json['validity_date'])
      ..dateOrder = _asString(json['date_order'])
      ..paymentTermId = _getId(json['payment_term_id'])
      ..paymentTermName = _getName(json['payment_term_id'])
      ..partnerId = _getId(json['partner_id'])
      ..partnerName = _getName(json['partner_id'])
      ..amountTotal = _asDouble(json['amount_total'])
      ..amountTax = _asDouble(json['amount_tax'])
      ..currencyId = _getId(json['currency_id'])
      ..searchServerId = _asInt(json['id']);
  }

  /// Helper to safely parse a string from dynamic value.
  static String? _asString(dynamic val) {
    if (val is String && val.isNotEmpty) return val;
    return null;
  }

  /// Helper to safely parse an int from dynamic value.
  static int? _asInt(dynamic val) {
    if (val is int) return val;
    return null;
  }

  /// Helper to safely parse a double from dynamic value.
  static double? _asDouble(dynamic val) {
    if (val is num) return val.toDouble();
    return null;
  }

  /// Helper to convert a dynamic list to a list of int IDs.
  static List<int> _getIdList(dynamic val) {
    if (val is List) return val.whereType<int>().toList();
    return [];
  }

  /// Helper to get the ID from a JSON [val] in `[id, name]` format.
  static int? _getId(dynamic val) {
    if (val is List && val.isNotEmpty && val[0] is int) {
      return val[0];
    }
    return null;
  }

  /// Helper to get the Name from a JSON [val] in `[id, name]` format.
  static String? _getName(dynamic val) {
    if (val is List && val.length > 1 && val[1] is String) {
      return val[1];
    }
    return null;
  }
}

/// Represents a cached sale order line in Isar.
///
/// Stores details for individual line items of a sale order, including product,
/// quantity, price, tax, discount, and downpayment status.
@collection
class SaleOrderLineIsarCache {
  SaleOrderLineIsarCache();

  Id id = Isar.autoIncrement;
  int? saleOrderId;
  int? orderLineId;
  int? productId;
  String? productName;
  String? name;
  double? productUomQty;
  double? priceUnit;
  String? displayType;
  List<int>? taxIds;
  double? discount;
  bool? isDownPayment;
  double? amount;

  /// Indexed sale order ID for search queries.
  @Index(type: IndexType.value)
  int? searchSaleOrderId;

  /// Factory method to create a sale order line from JSON.
  ///
  /// [taxField] specifies which JSON field contains tax IDs.
  factory SaleOrderLineIsarCache.fromOrderLine(
      Map<String, dynamic> json, int saleOrderId, String taxField) {
    final qty = (json['product_uom_qty'] as num?)?.toDouble() ?? 0.0;
    final unitPrice = (json['price_unit'] as num?)?.toDouble() ?? 0.0;
    final discount = (json['discount'] as num?)?.toDouble() ?? 0.0;
    final discountedPrice = unitPrice * (1 - (discount / 100));
    final calculatedAmount = qty * discountedPrice;

    return SaleOrderLineIsarCache()
      ..saleOrderId = saleOrderId
      ..orderLineId = _asInt(json['id'])
      ..productId = _getId(json['product_id'])
      ..productName =
          json['is_downpayment'] == false && json['product_id'] != false
              ? _getName(json['product_id'])
              : _asString(json['name'])
      ..name = json['name'] != false ? _asString(json['name']) : null
      ..productUomQty = qty
      ..priceUnit = unitPrice
      ..displayType =
          json['display_type'] != false ? _asString(json['display_type']) : null
      ..taxIds = _getIdList(json[taxField] ?? [])
      ..discount = discount
      ..isDownPayment = json['is_downpayment'] == true
      ..amount = calculatedAmount
      ..searchSaleOrderId = saleOrderId;
  }

  static String? _asString(dynamic val) {
    if (val is String && val.isNotEmpty) return val;
    return null;
  }

  static int? _asInt(dynamic val) {
    if (val is int) return val;
    return null;
  }

  static List<int> _getIdList(dynamic val) {
    if (val is List) return val.whereType<int>().toList();
    return [];
  }

  static int? _getId(dynamic val) {
    if (val is List && val.isNotEmpty && val[0] is int) {
      return val[0];
    }
    return null;
  }

  static String? _getName(dynamic val) {
    if (val is List && val.length > 1 && val[1] is String) {
      return val[1];
    }
    return null;
  }
}

/// Represents a cached sale order option in Isar.
///
/// Stores optional products/services associated with a sale order.
@collection
class SaleOrderOptionIsarCache {
  SaleOrderOptionIsarCache();

  Id id = Isar.autoIncrement;
  int? saleOrderId;
  int? optionId;
  int? productId;
  String? productName;
  String? name;
  double? priceUnit;
  double? quantity;

  /// Indexed sale order ID for search queries.
  @Index(type: IndexType.value)
  int? searchSaleOrderId;

  /// Factory method to create a sale order option from JSON.
  factory SaleOrderOptionIsarCache.fromOption(
      Map<String, dynamic> json, int saleOrderId) {
    return SaleOrderOptionIsarCache()
      ..saleOrderId = saleOrderId
      ..optionId = _asInt(json['id'])
      ..productId = _getId(json['product_id'])
      ..productName = _asString(json['name'])
      ..name = _asString(json['name'])
      ..priceUnit = _asDouble(json['price_unit'])
      ..quantity = _asDouble(json['quantity'])
      ..searchSaleOrderId = saleOrderId;
  }

  static String? _asString(dynamic val) {
    if (val is String && val.isNotEmpty) return val;
    return null;
  }

  static int? _asInt(dynamic val) {
    if (val is int) return val;
    return null;
  }

  static double? _asDouble(dynamic val) {
    if (val is num) return val.toDouble();
    return null;
  }

  static int? _getId(dynamic val) {
    if (val is List && val.isNotEmpty && val[0] is int) {
      return val[0];
    }
    return null;
  }
}
