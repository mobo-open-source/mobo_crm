import 'dart:convert';
import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mobo_crm/global_methods/widgets/activity_icon.dart';
import 'package:mobo_crm/initilisation.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import '../../../core/company/session/company_session_manager.dart';

/// Shape variants for the image container
enum ImageShape { circle, rounded, square }

/// A versatile widget that displays images from Odoo records (via RPC fetch or direct base64).
///
/// Two loading modes:
///   1. **Network mode** (`useNetworkImage: true`): Loads image directly via `/web/image` endpoint
///      using authenticated session cookie. Best for large/frequently changing images.
///   2. **Byte mode** (`useNetworkImage: false`): Fetches `image_XXXX` field via `search_read`,
///      decodes base64 into `MemoryImage`. Ideal for small/static images or offline-first apps.
///
/// Features:
///   - Automatic session check & fetch
///   - Shimmer placeholder during load
///   - Person icon fallback on error/no image
///   - Custom shape (circle, rounded, square) with optional border
///   - Optional tap gesture
///   - Stacked activity icon overlay (when `isStacked: true`)
///   - High-quality caching via `CachedNetworkImage` (network mode)
///
/// Typical use: user avatars, partner logos, product images, lead/opportunity thumbnails.
class OdooByteImage extends StatefulWidget {
  final String model;
  final int recordId;
  final double size;
  final String imageQuality;
  final ImageShape shape;
  final BoxBorder? border;
  final VoidCallback? onTap;
  final Color? shimmerBaseColor;
  final Color? shimmerHighlightColor;
  final double? squareBorderRadius;
  final String type;
  final String state;
  final bool useNetworkImage;
  final bool isStacked;

  const OdooByteImage(
      {super.key,
      this.state = '',
      this.type = '',
      this.imageQuality = 'image_1920',
      required this.model,
      required this.recordId,
      this.size = 40,
      this.shape = ImageShape.circle,
      this.border,
      this.onTap,
      this.shimmerBaseColor,
      this.shimmerHighlightColor,
      this.squareBorderRadius,
      this.useNetworkImage = false,
      this.isStacked = false
      });

  @override
  State<OdooByteImage> createState() => _OdooByteImageState();
}

class _OdooByteImageState extends State<OdooByteImage> {
  MemoryImage? memoryImage;
  bool loading = false;
  int? userId;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async{
      await context.read<OdooClientManager>().ensureSession();
      if (widget.useNetworkImage) {
      } else {
        _loadImage();
      }
    });
  }

  /// Fetches image base64 from Odoo via `search_read` and decodes it
  Future<void> _loadImage() async {
    if (mounted) {
      setState(() => loading = true);
    }
    try {

      final result = await CompanySessionManager.callKwWithCompany({
        'model': widget.model,
        'method': 'search_read',
        'args': [
          [
            ['id', '=', widget.recordId]
          ]
        ],
        'kwargs': {
          'fields': [widget.imageQuality],
          'limit': 1,
        },
      });

      if (result != null && result.isNotEmpty) {
        final imageBase64 = result[0][widget.imageQuality];
        if (imageBase64 != null && imageBase64 != 'false') {
          final imageData = base64Decode(imageBase64);
          if (mounted) {
            setState(() {
              memoryImage = MemoryImage(Uint8List.fromList(imageData));
            });
          }
        }
      }
    } catch (_) {
    } finally {
      if (mounted) {
        setState(() => loading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget imageWidget;

    if (widget.useNetworkImage) {
      final odooManager =
          Provider.of<OdooClientManager>(context, listen: false);

      final hasValidSession = odooManager.currentsession != null;
      final hasValidUrl =
          odooManager.url != null && odooManager.url!.isNotEmpty;
      final hasValidRecordId = widget.recordId > 0;

      String? imageUrl;
      String? sessionId;

      if (hasValidSession && hasValidUrl && hasValidRecordId) {
        imageUrl =
            "${odooManager.url}/web/image/${widget.model}/${widget.recordId}/${widget.imageQuality}";
        sessionId = odooManager.currentsession!.sessionId;
      }

      if (!hasValidSession ||
          !hasValidUrl ||
          !hasValidRecordId ||
          imageUrl == null) {
        imageWidget = _buildError();
      } else {
        imageWidget = CachedNetworkImage(
          imageUrl: imageUrl,
          httpHeaders: {
            "Cookie": "session_id=$sessionId",
          },
          width: widget.size,
          height: widget.size,
          fit: BoxFit.cover,
          placeholder: (context, url) => _buildShimmer(),
          errorWidget: (context, url, error) {
            return _buildError();
          },
          cacheKey:
              "odoo_image_${widget.model}_${widget.recordId}_${widget.imageQuality}",
          maxWidthDiskCache: 200,
          maxHeightDiskCache: 200,
        );
      }
    } else {
      if (loading) {
        imageWidget = _buildShimmer();
      } else if (memoryImage != null) {
        imageWidget = Image(
          image: memoryImage!,
          width: widget.size,
          height: widget.size,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => _buildError(),
        );
      } else {
        imageWidget = _buildError();
      }
    }

    return GestureDetector(
      onTap: widget.onTap,
      child: widget.isStacked
          ? Stack(
              clipBehavior: Clip.none,
              children: [
                _buildShape(child: imageWidget),
                Positioned(
                  bottom: -10,
                  right: -15,
                  child: ActivityIcon(
                    filled: true,
                    radius: 14,
                    size: 15,
                    activityType: widget.type,
                    activityState: widget.state,
                  ),
                ),
              ],
            )
          : _buildShape(child: imageWidget),
    );
  }

  /// Applies shape (circle, rounded, square) and border to the child image
  Widget _buildShape({required Widget child}) {
    switch (widget.shape) {
      case ImageShape.rounded:
        return Container(
          width: widget.size,
          height: widget.size,
          decoration: BoxDecoration(
            border: widget.border,
            borderRadius: BorderRadius.circular(12),
          ),
          clipBehavior: Clip.antiAlias,
          child: child,
        );
      case ImageShape.square:
        return Container(
          width: widget.size,
          height: widget.size,
          decoration: BoxDecoration(
            border: widget.border,
            borderRadius: BorderRadius.circular(widget.squareBorderRadius ?? 5),
          ),
          clipBehavior: Clip.antiAlias,
          child: child,
        );
      case ImageShape.circle:
        return ClipOval(
          child: Container(
            width: widget.size,
            height: widget.size,
            decoration: BoxDecoration(border: widget.border),
            child: child,
          ),
        );
    }
  }

  /// Shimmer placeholder during loading
  Widget _buildShimmer() {
    return Shimmer.fromColors(
      baseColor: widget.shimmerBaseColor ?? Colors.grey[300]!,
      highlightColor: widget.shimmerHighlightColor ?? Colors.grey[100]!,
      child: Container(
        width: widget.size,
        height: widget.size,
        decoration: BoxDecoration(
          color: Colors.grey[300]!,
          shape: widget.shape == ImageShape.circle
              ? BoxShape.circle
              : BoxShape.rectangle,
          borderRadius: widget.shape == ImageShape.rounded
              ? BorderRadius.circular(12)
              : widget.shape == ImageShape.square
                  ? BorderRadius.circular(widget.squareBorderRadius ?? 5)
                  : null,
        ),
      ),
    );
  }

  /// Fallback widget when image fails to load or is unavailable
  Widget _buildError() {
    return Container(
      width: widget.size,
      height: widget.size,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        shape: widget.shape == ImageShape.circle
            ? BoxShape.circle
            : BoxShape.rectangle,
        borderRadius: widget.shape == ImageShape.rounded
            ? BorderRadius.circular(12)
            : widget.shape == ImageShape.square
                ? BorderRadius.circular(widget.squareBorderRadius ?? 5)
                : null,
      ),
      child: Icon(
        Icons.person,
        size: widget.size * 0.6,
        color: Colors.grey[600],
      ),
    );
  }
}

/// Simple widget to display a base64-encoded image with fallback UI.
///
/// Features:
///   - Decodes base64 string to memory image
///   - Rounded clipping with configurable radius
///   - Grey placeholder + broken image icon on error/missing data
///
/// Useful for static images stored in Odoo fields or local cache.
class Base64ImageView extends StatelessWidget {
  final String? base64String;
  final double size;
  final double borderRadius;

  const Base64ImageView({
    super.key,
    required this.base64String,
    this.size = 100,
    this.borderRadius = 8,
  });

  @override
  Widget build(BuildContext context) {
    if (base64String == null ||
        base64String!.isEmpty ||
        base64String == 'false') {
      return Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        child: const Icon(Icons.image, color: Colors.grey),
      );
    }

    try {
      Uint8List imageBytes = base64Decode(base64String!);
      return ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: Image.memory(
          imageBytes,
          width: size,
          height: size,
          fit: BoxFit.cover,
        ),
      );
    } catch (e) {
      return Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        child: const Icon(Icons.broken_image, color: Colors.grey),
      );
    }
  }
}
