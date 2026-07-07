import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:mobo_crm/initilisation.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';

import '../../../core/company/session/company_session_manager.dart';

/// Shape variants for the profile image container
enum ProfileImageShape { circle, rounded, square }

/// A reusable profile avatar widget that loads user image from Odoo server
/// or from provided base64 bytes, with shimmer placeholder, error fallback,
/// and optional tap gesture.
///
/// Features:
///   - Automatic fetch from Odoo `/web/image/res.users/{userId}/image_1920`
///   - Session cookie authentication via `OdooClientManager`
///   - Supports direct base64 image input (`isByte: true`)
///   - Different shapes: circle (default), rounded square, full square
///   - Custom border, shimmer colors, tap callback
///   - Cached via `CachedNetworkImage` with user-specific cache key
///   - Fallback to person icon on error or no image
///
/// Typical use: app bar avatar, user profile header, comment authors, list items.
class ProfileImage extends StatefulWidget {
  final double size;
  final ProfileImageShape shape;
  final BoxBorder? border;
  final VoidCallback? onTap;
  final Color? shimmerBaseColor;
  final Color? shimmerHighlightColor;
  final bool isByte;
  final String? base64Image;

  const ProfileImage({
    super.key,
    this.size = 40,
    this.shape = ProfileImageShape.circle,
    this.border,
    this.onTap,
    this.shimmerBaseColor,
    this.shimmerHighlightColor,
    this.isByte = false,
    this.base64Image,
  });

  @override
  State<ProfileImage> createState() => _ProfileImageState();
}

class _ProfileImageState extends State<ProfileImage> {
  MemoryImage? memoryImage;
  bool loading = false;

  @override
  void initState() {
    super.initState();
    if (widget.isByte && widget.base64Image != null) {
      _loadImageFromBase64();
    } else if (widget.isByte) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _loadImageFromOdoo();
      });
    }
  }

  /// Decodes base64 string into `MemoryImage`
  void _loadImageFromBase64() {
    try {
      if (widget.base64Image != null && widget.base64Image!.isNotEmpty) {
        final imageData = base64Decode(widget.base64Image!);
        if (mounted) {
          setState(() {
            memoryImage = MemoryImage(Uint8List.fromList(imageData));
            loading = false;
          });
        }
      } else {
        if (mounted) {
          setState(() => loading = false);
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() => loading = false);
      }
    }
  }

  /// Fetches user profile image (image_1920) from Odoo server
  Future<void> _loadImageFromOdoo() async {
    if (mounted) {
      setState(() => loading = true);
    }
    try {
      final odooManager =
          Provider.of<OdooClientManager>(context, listen: false);
      final client = odooManager.client;
      final userId = odooManager.currentsession?.userId;

      if (userId == null || client == null) {
        return;
      }

      final result = await CompanySessionManager.callKwWithCompany({
        'model': 'res.users',
        'method': 'search_read',
        'args': [
          [
            ['id', '=', userId]
          ]
        ],
        'kwargs': {
          'fields': ['image_1920'],
        },
      });

      if (result != null && result.isNotEmpty) {
        final imageBase64 = result[0]['image_1920'];
        if (imageBase64 != null && imageBase64 != 'false') {
          final imageData = base64Decode(imageBase64);
          if (mounted) {
            setState(() {
              memoryImage = MemoryImage(Uint8List.fromList(imageData));
              loading = false;
            });
          }
        } else {}
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
    return Consumer<OdooClientManager>(
      builder: (context, odooProvider, child) {
        final hasValidSession = odooProvider.currentsession != null;
        final hasValidUrl =
            odooProvider.url != null && odooProvider.url!.isNotEmpty;
        final hasValidUserId = odooProvider.currentsession?.userId != null;

        String? imageUrl;
        String? sessionId;

        if (hasValidSession && hasValidUrl && hasValidUserId) {
          imageUrl =
              "${odooProvider.url}/web/image/res.users/${odooProvider.currentsession!.userId}/image_1920";
          sessionId = odooProvider.currentsession!.sessionId;
        }

        Widget imageWidget;

        if (widget.isByte) {
          if (loading) {
            imageWidget = _buildShimmer();
          } else if (memoryImage != null) {
            imageWidget = Image(
              image: memoryImage!,
              width: widget.size,
              height: widget.size,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return _buildError();
              },
            );
          } else {
            imageWidget = _buildError();
          }
        } else if (!hasValidSession ||
            !hasValidUrl ||
            !hasValidUserId ||
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
            cacheKey: "profile_image_${odooProvider.currentsession!.userId}",
            maxWidthDiskCache: 200,
            maxHeightDiskCache: 200,
          );
        }

        return widget.onTap != null
            ? GestureDetector(
                onTap: widget.onTap,
                child: _buildShape(child: imageWidget),
              )
            : _buildShape(child: imageWidget);
      },
    );
  }

  /// Applies shape (circle, rounded, square) and border to the child image
  Widget _buildShape({required Widget child}) {
    switch (widget.shape) {
      case ProfileImageShape.rounded:
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
      case ProfileImageShape.square:
        return Container(
          width: widget.size,
          height: widget.size,
          decoration: BoxDecoration(border: widget.border),
          clipBehavior: Clip.antiAlias,
          child: child,
        );
      case ProfileImageShape.circle:
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
          color: Colors.white,
          shape: widget.shape == ProfileImageShape.circle
              ? BoxShape.circle
              : BoxShape.rectangle,
          borderRadius: widget.shape == ProfileImageShape.rounded
              ? BorderRadius.circular(12)
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
        shape: widget.shape == ProfileImageShape.circle
            ? BoxShape.circle
            : BoxShape.rectangle,
        borderRadius: widget.shape == ProfileImageShape.rounded
            ? BorderRadius.circular(12)
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
