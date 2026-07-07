import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:mobo_crm/global_methods/const.dart';
import 'package:mobo_crm/global_methods/widgets/activity_icon.dart';
import 'package:mobo_crm/global_methods/widgets/enhanced_activity_icon.dart';
import 'package:mobo_crm/global_methods/widgets/image_widget/get_allimage.dart';
import 'package:mobo_crm/global_methods/widgets/image_widget/image_placeholder_widget.dart';
import 'package:mobo_crm/initilisation.dart';
import 'package:mobo_crm/screens/quotation/provider/quotation_form_provider.dart';
import 'package:mobo_crm/screens/quotation/provider/quotation_view_provider.dart';
import 'package:shimmer/shimmer.dart';

import 'package:provider/provider.dart';

import '../../../../utils/globals.dart';
import '../../../../utils/app_theme.dart';

/// A simple section title widget with rounded corners.
/// Typically used to label sections in forms or lists.
class SectionTitle extends StatelessWidget {
  final String title;

  /// Constructor for SectionTitle.
  const SectionTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w600,
          color: Colors.grey[800],
          letterSpacing: -0.2,
        ),
      ),
    );
  }
}

/// A custom row containing a label and a checkbox.
/// Can optionally display a value text next to the checkbox.
class CustomCheckboxRow extends StatelessWidget {
  final String label;
  final bool value;
  final String valueText;
  final void Function(bool?)? onChanged;

  const CustomCheckboxRow({
    super.key,
    required this.onChanged,
    required this.label,
    required this.value,
    this.valueText = '',
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onChanged != null ? () => onChanged!(!value) : null,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            '$label ',
            style: TextStyle(
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(width: 10),
          const Spacer(),
          Checkbox(
            value: value,
            onChanged: onChanged,
            activeColor: const Color(0xFFC03355),
            side: const BorderSide(
              color: Color(0xFFC03355),
              width: 2,
            ),
          ),
        ],
      ),
    );
  }
}

/// A card-style tile representing a quotation in Kanban view.
///
/// Mirrors the design of the pipeline (opportunity) `KanbanTile`:
///   - Name, partner, currency + amount_total
///   - Activity icon in top-right corner (with optional admin delete menu)
///   - State shown as a colored pill (in place of opportunity tags)
///   - Salesperson avatar (fetched from Odoo with session auth, fallback to initials)
class QuotationKanbanTile extends StatelessWidget {
  final Map quotation;
  final void Function()? onTap;
  final void Function()? onDelete;
  final bool isAdmin;

  const QuotationKanbanTile({
    super.key,
    required this.quotation,
    required this.onTap,
    this.onDelete,
    this.isAdmin = false,
  });

  /// Returns the color associated with the quotation's state.
  Color getStateColor() {
    switch ((quotation['state'] ?? '').toString().toLowerCase()) {
      case 'cancel':
        return Colors.red;
      case 'sale':
        return const Color(0xFF43B75D);
      case 'sent':
        return Colors.blue;
      case 'draft':
      default:
        return Colors.grey;
    }
  }

  /// Returns a human-readable label for the quotation state.
  String getStateLabel() {
    switch ((quotation['state'] ?? '').toString().toLowerCase()) {
      case 'cancel':
        return 'Cancelled';
      case 'sale':
        return 'Sale Order';
      case 'sent':
        return 'Quotation Sent';
      case 'draft':
        return 'Quotation';
      default:
        return (quotation['state'] ?? '').toString().toUpperCase();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<OdooClientManager>(
      builder: (context, odooinitprovider, child) {
        Widget tileContent = Container(
          margin: const EdgeInsets.only(top: 10),
          clipBehavior: Clip.hardEdge,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Colors.grey[200]!,
              width: 1,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Text(
                        (quotation['name'] ?? '').toString().isNotEmpty
                            ? quotation['name']
                            : 'No Name',
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Align(
                      alignment: Alignment.topRight,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            width: 28,
                            height: 28,
                            child: Center(
                              child: Builder(builder: (context) {
                                final activityType =
                                    quotation['activity_type_id'] is List &&
                                            quotation['activity_type_id']
                                                    .length >
                                                1
                                        ? quotation['activity_type_id'][1]
                                            .toString()
                                        : null;
                                final activityState =
                                    quotation['activity_state']?.toString();
                                return EnhancedActivityIcon(
                                  resId: (quotation['id'] is int)
                                      ? quotation['id']
                                      : 0,
                                  resModel: 'sale.order',
                                  recordName:
                                      quotation['name']?.toString() ?? '',
                                  activityType: activityType,
                                  activityState: activityState,
                                  showBadge: false,
                                );
                              }),
                            ),
                          ),
                          if (isAdmin && onDelete != null) ...[
                            const SizedBox(width: 4),
                            SizedBox(
                              width: 28,
                              height: 28,
                              child: PopupMenuButton<String>(
                                offset: const Offset(0, 36),
                                color: Colors.white,
                                padding: EdgeInsets.zero,
                                icon:
                                    const Icon(Icons.more_vert, size: 20),
                                onSelected: (value) {
                                  if (value == 'delete') {
                                    onDelete?.call();
                                  }
                                },
                                itemBuilder: (BuildContext context) => [
                                  PopupMenuItem<String>(
                                    value: 'delete',
                                    child: Row(
                                      children: const [
                                        Icon(
                                          HugeIcons.strokeRoundedDelete02,
                                          color: Colors.red,
                                          size: 20,
                                        ),
                                        SizedBox(width: 12),
                                        Text(
                                          'Delete',
                                          style: TextStyle(
                                            color: Colors.red,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 15,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
                if (quotation['partner_id'] != null &&
                    quotation['partner_id'] != false &&
                    quotation['partner_id'] is List &&
                    quotation['partner_id'].length > 1) ...[
                  Text(
                    quotation['partner_id'][1]?.toString() ?? '',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: Colors.grey[600],
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                ],
                Consumer2<OdooClientManager, QuotationViewProvider>(
                  builder: (context, provider, viewProvider, child) {
                    int? currencyId;
                    String? currencySymbol;
                    if (quotation['currency_id'] is List &&
                        quotation['currency_id'].isNotEmpty) {
                      currencyId = quotation['currency_id'][0] as int?;
                    }
                    if (currencyId != null &&
                        viewProvider.currencySymbolMap
                            .containsKey(currencyId)) {
                      currencySymbol =
                          viewProvider.currencySymbolMap[currencyId];
                    }
                    currencySymbol ??= (quotation['currency_id'] is List &&
                            quotation['currency_id'].length > 1)
                        ? quotation['currency_id'][1]?.toString()
                        : provider.currencySymbol;
                    currencySymbol ??= '\$';
                    final totalAmount =
                        quotation['amount_total']?.toString() ?? '0';
                    return Text(
                      '$currencySymbol $totalAmount',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        color: Colors.grey[700],
                        fontWeight: FontWeight.w600,
                      ),
                    );
                  },
                ),
                const SizedBox(height: 2),
                Wrap(
                  spacing: 5.0,
                  runSpacing: 2.0,
                  children: [
                    StatusColors.buildStatusBadge(
                      getStateLabel(),
                      StatusColors.getStatusColor(quotation['state']),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    if (quotation['user_id'] != false &&
                        quotation['user_id'] != null &&
                        quotation['user_id'] is List &&
                        quotation['user_id'].isNotEmpty) ...[
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.grey[300]!,
                            width: 1.5,
                          ),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(11),
                          child: SizedBox(
                            width: 22,
                            height: 22,
                            child: Builder(builder: (context) {
                              final baseUrl = odooinitprovider.url ?? '';
                              final userId = quotation['user_id'][0];
                              final sessionId = odooinitprovider
                                  .currentsession?.sessionId;

                              final avatarUrl =
                                  "$baseUrl/web/image/res.users/$userId/avatar_128";

                              return CachedNetworkImage(
                                imageUrl: avatarUrl,
                                httpHeaders: sessionId != null
                                    ? {
                                        "Cookie":
                                            "session_id=$sessionId",
                                        "Accept":
                                            "image/png, image/jpeg, image/gif, image/webp, */*",
                                        "User-Agent":
                                            "Mozilla/5.0 (compatible; OdooApp/1.0)",
                                        "Cache-Control": "no-cache",
                                      }
                                    : {
                                        "Accept":
                                            "image/png, image/jpeg, image/gif, image/webp, */*",
                                        "User-Agent":
                                            "Mozilla/5.0 (compatible; OdooApp/1.0)",
                                        "Cache-Control": "no-cache",
                                      },
                                fit: BoxFit.cover,
                                maxHeightDiskCache: 100,
                                maxWidthDiskCache: 100,
                                placeholder: (context, url) =>
                                    Shimmer.fromColors(
                                  baseColor: Colors.grey[300]!,
                                  highlightColor: Colors.grey[100]!,
                                  child: Container(
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                                errorWidget: (context, url, error) {
                                  if (url.contains('avatar_128')) {
                                    final fallbackUrl =
                                        "$baseUrl/web/image?model=res.users&id=$userId&field=image_128";

                                    return CachedNetworkImage(
                                      imageUrl: fallbackUrl,
                                      httpHeaders: sessionId != null
                                          ? {
                                              "Cookie":
                                                  "session_id=$sessionId",
                                              "Accept":
                                                  "image/png, image/jpeg, image/gif, image/webp, */*",
                                              "User-Agent":
                                                  "Mozilla/5.0 (compatible; OdooApp/1.0)",
                                              "Cache-Control":
                                                  "no-cache",
                                            }
                                          : {
                                              "Accept":
                                                  "image/png, image/jpeg, image/gif, image/webp, */*",
                                              "User-Agent":
                                                  "Mozilla/5.0 (compatible; OdooApp/1.0)",
                                              "Cache-Control":
                                                  "no-cache",
                                            },
                                      fit: BoxFit.cover,
                                      errorWidget: (context, fallbackUrl,
                                          fallbackError) {
                                        return _buildAvatarFallback(
                                            quotation, userId);
                                      },
                                    );
                                  }

                                  return _buildAvatarFallback(
                                      quotation, userId);
                                },
                              );
                            }),
                          ),
                        ),
                      ),
                    ],
                    const Spacer(),
                    if (quotation['date_order'] != null &&
                        quotation['date_order'] != false)
                      Text(
                        quotation['date_order']
                            .toString()
                            .split(' ')
                            .first,
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        );

        return InkWell(
          onTap: onTap,
          child: tileContent,
        );
      },
    );
  }

  /// Fallback avatar when image fetch fails (shows initials or person icon)
  Widget _buildAvatarFallback(Map quotation, int userId) {
    if (quotation['user_id'] != null &&
        quotation['user_id'] is List &&
        quotation['user_id'].length > 1 &&
        quotation['user_id'][1] != null) {
      final name = quotation['user_id'][1].toString();
      final firstLetter = name.isNotEmpty ? name[0].toUpperCase() : '?';
      final bgColor = avatarColors[userId % avatarColors.length];

      return Container(
        decoration: BoxDecoration(
          color: bgColor,
          shape: BoxShape.circle,
        ),
        alignment: Alignment.center,
        child: Text(
          firstLetter,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 10,
            color: Colors.white,
          ),
        ),
      );
    } else {
      return Container(
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.grey,
        ),
        child: const Icon(
          Icons.person,
          color: Colors.white,
          size: 12,
        ),
      );
    }
  }
}

/// A list-style tile representing a quotation.
/// Displays name, partner, date, total amount, and activity icon.
class QuotationListTile extends StatelessWidget {
  final Map quotation;
  final IconData? activityIcon;
  final String? activityType;
  final dynamic activityState;
  final Color? activityColor;
  final Function() onTap;

  const QuotationListTile({
    super.key,
    required this.quotation,
    this.activityIcon,
    this.activityType,
    this.activityState,
    this.activityColor,
    required this.onTap,
  });

  /// Returns the color for the current quotation state.
  Color getStateColor() {
    return StatusColors.getStatusColor(quotation['state']?.toString());
  }

  /// Returns a descriptive label for the quotation state.
  String getStateValue() {
    switch (quotation['state']) {
      case 'sale':
        return "Sale Order";
      case 'sent':
        return "Quotation Sent";
      case 'draft':
        return "Quotation";
      case 'cancel':
      default:
        return "Cancelled";
    }
  }

  /// Returns a gradient decoration for the state badge.
  LinearGradient getStateGradient() {
    final baseColor = getStateColor();
    return LinearGradient(
      colors: [baseColor, baseColor],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: isDark ? Colors.grey[850] : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isDark ? Colors.grey[850]! : Colors.grey[200]!,
            width: 0.5,
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF000000).withOpacity(0.05),
              offset: const Offset(0, 6),
              blurRadius: 16,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Padding(
          padding:
              const EdgeInsets.only(left: 14, top: 14, bottom: 14, right: 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 4),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          quotation['name'] ?? 'No Name',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: AppStyle.primaryColor,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (quotation['partner_id'] != null &&
                            quotation['partner_id'] is List &&
                            quotation['partner_id'].length > 1)
                          Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Text(
                              quotation['partner_id'][1],
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.black54,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      _buildStatusBadge(isDark),
                      if (activityIcon != null) ...[
                        const SizedBox(width: 8),
                        ActivityIcon(
                          activityState: activityState,
                          activityType: activityType,
                        ),
                      ],
                    ],
                  ),
                ],
              ),
              if (quotation['date_order'] != null)
                Padding(
                  padding: const EdgeInsets.only(top: 4.0),
                  child: Row(
                    children: [
                      Text(
                        quotation['date_order'] ?? '--/--/--',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ),
              const SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total Amount',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.black54,
                    ),
                  ),
                  Consumer<OdooClientManager>(
                    builder: (context, provider, child) {
                      int? currencyId;
                      String? currencySymbol;
                      if (quotation['currency_id'] is List &&
                          quotation['currency_id'].isNotEmpty) {
                        currencyId = quotation['currency_id'][0] as int?;
                      }
                      final viewProvider = Provider.of<QuotationViewProvider>(
                          context,
                          listen: false);
                      if (currencyId != null &&
                          viewProvider.currencySymbolMap
                              .containsKey(currencyId)) {
                        currencySymbol =
                            viewProvider.currencySymbolMap[currencyId];
                      }
                      currencySymbol ??= (quotation['currency_id'] is List &&
                              quotation['currency_id'].length > 1)
                          ? quotation['currency_id'][1]
                          : provider.currencySymbol;
                      final totalAmount =
                          quotation['amount_total']?.toString() ?? '0.00';

                      if (currencySymbol == null || currencySymbol.isEmpty) {
                        return SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.grey),
                          ),
                        );
                      }

                      return Text(
                        "$currencySymbol $totalAmount",
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.black54,
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.ellipsis,
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 4),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusBadge(bool isDark) {
    final statusColor = StatusColors.getStatusColor(quotation['state']?.toString());
    return StatusColors.buildStatusBadge(
      getStateValue(),
      statusColor,
      isDark: isDark,
    );
  }
}

/// A tile widget representing a product in a quotation.
/// Displays product name, quantity, unit price, total price, discount, and optional actions.
class ProductListTile extends StatelessWidget {
  final String productName;
  final double quantity;
  final double unitPrice;
  final double totalPrice;
  final int? id;
  final double discount;
  final void Function()? onTap;
  final void Function()? onOptionalTap;
  final String type;
  final int index;
  final bool isOptional;
  final String currencySymbol;

  const ProductListTile({
    super.key,
    required this.onTap,
    required this.onOptionalTap,
    required this.index,
    required this.type,
    required this.productName,
    required this.quantity,
    this.discount = 0,
    this.isOptional = false,
    required this.unitPrice,
    required this.totalPrice,
    required this.id,
    required this.currencySymbol,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer2<OdooClientManager, QuotationFormProvider>(
      builder: (context, clientProvider, quotationProvider, child) {
        bool isProductAdded =
            quotationProvider.productlinedata.any((line) => line.id == id);

        return InkWell(
          onTap: onTap,
          child: Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 10.0, horizontal: 12.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 45,
                  height: 45,
                  child: id != null
                      ? OdooByteImage(
                          model: 'product.product',
                          recordId: id!,
                          imageQuality: 'image_128',
                          useNetworkImage: true,
                          size: 45,
                        )
                      : ImagePlaceholder(
                          shape: BoxShape.circle,
                          size: 45,
                          icon: Icons.image_not_supported,
                          iconSize: 22,
                          iconColor: Colors.black54,
                          backgroundColor: Colors.grey[100]!,
                        ),
                ),
                const SizedBox(width: 12),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        productName,
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 15,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Wrap(
                        spacing: 8,
                        runSpacing: 4,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          Text(
                            '$quantity Units',
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey[700],
                            ),
                          ),

                          Text(
                            '•',
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey[500],
                            ),
                          ),

                          Text(
                            ' ${currencySymbol}${unitPrice.toStringAsFixed(2)}',
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey[700],
                            ),
                          ),

                          if (discount != 0) ...[
                            Text(
                              '•',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[500],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 4, vertical: 1),
                              decoration: BoxDecoration(
                                color: Colors.red[50],
                                borderRadius: BorderRadius.circular(4),
                                border: Border.all(
                                    color: Colors.red[100]!, width: 0.5),
                              ),
                              child: Text(
                                '$discount% off',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.red[700],
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 12),

                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        ' ${currencySymbol}${totalPrice.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ),
                    if (isProductAdded && type == 'optional') ...[
                      Icon(
                        Icons.shopping_cart_checkout,
                        color: Colors.green,
                      )
                    ] else if (isOptional &&
                        type == 'optional' &&
                        quotationProvider.isEdit) ...[
                      IconButton(
                        onPressed: onOptionalTap,
                        icon: Icon(
                          Icons.shopping_cart_checkout,
                          color: Theme.of(context).primaryColor,
                        ),
                      )
                    ]
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
