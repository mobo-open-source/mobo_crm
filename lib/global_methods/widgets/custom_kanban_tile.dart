import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:mobo_crm/global_methods/const.dart';
import 'package:mobo_crm/global_methods/widgets/enhanced_activity_icon.dart';
import 'package:mobo_crm/initilisation.dart';
import 'package:mobo_crm/models/models.dart';

import 'package:mobo_crm/screens/lead/providers/lead_form_provider.dart';

import 'package:shimmer/shimmer.dart';
import 'package:provider/provider.dart';

import '../../screens/opportunity/providers/opportunity_data_provider.dart';

/// A compact, interactive card (tile) used in Kanban board columns to represent
/// a single lead or opportunity record.
///
/// Features:
///   - Displays name, partner/customer, expected revenue (for opportunities)
///   - Shows priority stars (1–3)
///   - Colored tags from `tag_ids` with generated pastel colors
///   - User avatar (fetched from Odoo with session auth, fallback to initials)
///   - Next activity indicator via `KanbanActivityIcon`
///   - "Lost" overlay SVG when `active == false`
///   - Tap gesture to open detail/form view
///
/// Designed to work inside `KanbanBoard` columns with drag-and-drop support.
class KanbanTile extends StatelessWidget {
  final Map<dynamic, dynamic> lead;
  final bool isAdmin;
  final List<LeadTag> tags;
  final void Function()? onTap;
  final void Function()? onDelete;
  final Future<void> Function(int newPriority)? onPriorityChanged;

  const KanbanTile({
    super.key,
    required this.lead,
    this.isAdmin = false,
    required this.tags,
    required this.onTap,
    required this.onDelete,
    this.onPriorityChanged,
  });

  @override
  Widget build(BuildContext context) {
    final int priority = int.tryParse(lead['priority']?.toString() ?? '0') ?? 0;

    Widget priorityStars(BuildContext context) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(3, (index) {
          final starIndex = index + 1;

          return GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              onPriorityChanged?.call(starIndex);
            },
            child: Icon(
              index < priority ? Icons.star : Icons.star_border,
              color: index < priority ? Colors.amber : Colors.grey,
              size: 18,
            ),
          );
        }),
      );
    }

    List<int> tagIds =
        (lead['tag_ids'] as List<dynamic>?)?.map((e) => e as int).toList() ??
            [];

    List<LeadTag> tagDetails =
    tags.where((tag) => tagIds.contains(tag.id)).toList();

    return Consumer2<LeadFormProvider, OdooClientManager>(
        builder: (context, provider, odooinitprovider, child) {
          Widget tileContent = Container(
            margin: const EdgeInsets.only(bottom: 10),
            clipBehavior: Clip.hardEdge,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Colors.grey[200]!,
                width: 1,
              ),
            ),
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Text(
                              lead['name'] ?? 'No Name',
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
                                    child: KanbanActivityIcon(
                                      record: lead,
                                      onActivityChanged: () {},
                                    ),
                                  ),
                                ),
                                if (isAdmin) ...[
                                  const SizedBox(width: 4),
                                  SizedBox(
                                    width: 28,
                                    height: 28,
                                    child: PopupMenuButton<String>(
                                      offset: const Offset(0, 36),
                                      color: Colors.white,
                                      padding: EdgeInsets.zero,
                                      icon: const Icon(Icons.more_vert, size: 20),
                                      onSelected: (value) {
                                        if (value == 'delete') {
                                          onDelete?.call();
                                        }
                                      },
                                      itemBuilder: (BuildContext context) => [
                                        PopupMenuItem<String>(
                                          value: 'delete',
                                          child: Row(
                                            children: [
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
                      if (lead['partner_id'] != null) ...[
                        Text(
                          [
                            if (lead['partner_id'] != null &&
                                lead['partner_id'] != false)
                              lead['partner_id'][1] ?? '',
                            if (lead['contact_name'] != null &&
                                lead['contact_name'] != false &&
                                lead['contact_name'].toString().isNotEmpty)
                              lead['contact_name'].toString(),
                          ].where((s) => s.isNotEmpty).join(', '),
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
                      if (lead['type'] == 'opportunity') ...[
                        Consumer2<OdooClientManager, OpportunityDataProvider>(
                            builder: (context, clientprovider, opportunityProvider,
                                child) {
                              int? partnerId;
                              String? currencySymbol;
                              if (lead['partner_id'] is List &&
                                  lead['partner_id'].isNotEmpty) {
                                partnerId = lead['partner_id'][0] as int?;
                              }
                              if (partnerId != null &&
                                  opportunityProvider.partnerSymbolMap
                                      .containsKey(partnerId)) {
                                currencySymbol =
                                opportunityProvider.partnerSymbolMap[partnerId];
                              }
                              currencySymbol ??= clientprovider.currencySymbol ?? '\$';
                              return Text(
                                "${currencySymbol} ${lead['expected_revenue']?.toString() ?? "0"}",
                                style: GoogleFonts.inter(
                                  fontSize: 14,
                                  color: Colors.grey[700],
                                  fontWeight: FontWeight.w600,
                                ),
                              );
                            }),
                      ],
                      if (tagDetails.isNotEmpty) ...[
                        const SizedBox(height: 2),
                        Wrap(
                          spacing: 5.0,
                          runSpacing: 2.0,
                          children: tagDetails.map((tag) {
                            return Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFCE7EE),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: const Color(0xFFC03355)
                                      .withValues(alpha: 0.35),
                                  width: 1,
                                ),
                              ),
                              child: Text(
                                tag.name,
                                style: GoogleFonts.inter(
                                    fontSize: 11,
                                    color: const Color(0xFFC03355),
                                    fontWeight: FontWeight.w600),
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          if (lead['user_id'] != false &&
                              lead['user_id'] != null) ...[
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
                                  final userId = lead['user_id'][0];
                                  final sessionId =
                                      odooinitprovider.currentsession?.sessionId;

                                  final avatarUrl =
                                      "$baseUrl/web/image/res.users/$userId/avatar_128";

                                  return CachedNetworkImage(
                                    imageUrl: avatarUrl,
                                    httpHeaders: sessionId != null
                                        ? {
                                      "Cookie": "session_id=$sessionId",
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
                                            "Cookie": "session_id=$sessionId",
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
                                          errorWidget: (context, fallbackUrl,
                                              fallbackError) {
                                            return _buildAvatarFallback(
                                                lead, userId);
                                          },
                                        );
                                      }

                                      return _buildAvatarFallback(lead, userId);
                                    },
                                  );
                                }),
                              ),
                            ),
                            )
                          ],
                          const Spacer(),
                          priorityStars(context),
                        ],
                      ),
                    ],
                  ),
                ),
                if (lead['active'] == null || lead['active'] == false)
                  Positioned(
                    top: -7,
                    right: -7,
                    child: SizedBox(
                      height: 70,
                      width: 70,
                      child: SvgPicture.asset("assets/lost.svg"),
                    ),
                  ),
              ],
            ),
          );

          return InkWell(
            onTap: onTap,
            child: tileContent,
          );
        });
  }

  /// Fallback avatar when image fetch fails (shows initials or person icon)
  Widget _buildAvatarFallback(Map<dynamic, dynamic> lead, int userId) {
    if (lead['user_id'] != null && lead['user_id'][1] != null) {
      final name = lead['user_id'][1];
      final firstLetter = name.isNotEmpty ? name[0].toUpperCase() : "?";
      final bgColor = avatarColors[userId % avatarColors.length];

      return Container(
        decoration: BoxDecoration(
          color: bgColor,
          shape: BoxShape.circle,
        ),
        alignment: Alignment.center,
        child: Text(
          firstLetter,
          style: TextStyle(
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
