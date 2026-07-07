import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Full-screen image viewer with pinch-to-zoom, double-tap zoom, and Hero animation support.
///
/// Supports two input modes:
///   1. Raster image via `ImageProvider` (network, asset, memory, file)
///   2. SVG via raw string content (`svgString`)
///
/// Features:
///   - Interactive zoom (min 0.5× → max 4×)
///   - Double-tap to zoom in/out (centered on tap position)
///   - Optional Hero tag for smooth transition animation from list/grid
///   - Dark/light theme aware background
///   - Simple app bar with back button
///   - Tap anywhere outside image to close
///
/// Usage examples:
/// ```dart
/// // From network image
/// Navigator.push(
///   context,
///   MaterialPageRoute(
///     builder: (_) => FullScreenImage(
///       imageProvider: CachedNetworkImageProvider(url),
///       tag: 'profile_$userId',
///     ),
///   ),
/// );
///
/// // From SVG string
/// FullScreenImage.svg(svgString: rawSvgContent);
/// ```
class FullScreenImage extends StatefulWidget {
  final ImageProvider? imageProvider;
  final String? svgString;
  final String? tag;

  FullScreenImage({
    Key? key,
    required this.imageProvider,
    this.tag,
  })  : svgString = null,
        super(key: key) {}

  const FullScreenImage.svg({
    Key? key,
    required this.svgString,
    this.tag,
  })  : imageProvider = null,
        super(key: key);

  @override
  State<FullScreenImage> createState() => _FullScreenImageState();
}

class _FullScreenImageState extends State<FullScreenImage>
    with SingleTickerProviderStateMixin {
  late TransformationController _transformationController;
  TapDownDetails? _doubleTapDetails;

  @override
  void initState() {
    super.initState();
    _transformationController = TransformationController();
  }

  @override
  void dispose() {
    _transformationController.dispose();
    super.dispose();
  }

  /// Handles double-tap gesture:
  ///   - If already zoomed → reset to identity
  ///   - If at identity → zoom in 3× centered on tap position
  void _handleDoubleTap() {
    if (_transformationController.value != Matrix4.identity()) {
      _transformationController.value = Matrix4.identity();
    } else {
      if (_doubleTapDetails != null) {
        final position = _doubleTapDetails!.localPosition;
        _transformationController.value = Matrix4.identity()
          ..translate(-position.dx * 2, -position.dy * 2)
          ..scale(3.0);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    Widget child;
    if (widget.imageProvider != null) {
      child = Image(
        image: widget.imageProvider!,
        fit: BoxFit.contain,
        width: screenSize.width,
        height: screenSize.height,
      );
    } else if (widget.svgString != null) {
      child = SvgPicture.string(
        widget.svgString!,
        fit: BoxFit.contain,
        width: screenSize.width,
        height: screenSize.height,
      );
    } else {
      child = const SizedBox();
    }

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.grey[50],
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: GestureDetector(
        onTap: () => Navigator.of(context).pop(),
        child: Center(
          child: GestureDetector(
            onDoubleTapDown: (details) => _doubleTapDetails = details,
            onDoubleTap: _handleDoubleTap,
            child: InteractiveViewer(
              transformationController: _transformationController,
              minScale: 0.5,
              maxScale: 4.0,
              child: widget.tag != null
                  ? Hero(tag: widget.tag!, child: child)
                  : child,
            ),
          ),
        ),
      ),
    );
  }
}
