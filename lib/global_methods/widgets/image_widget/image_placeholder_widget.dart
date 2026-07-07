import 'package:flutter/material.dart';

/// A sized placeholder shown while an image loads or when none is available.
class ImagePlaceholder extends StatelessWidget {
  /// The size of the placeholder container (width and height will be equal)
  final double? size;

  /// Custom width - use this if you want different width than height
  final double? width;

  /// Custom height - use this if you want different height than width
  final double? height;

  /// Icon to display in the center of the placeholder
  final IconData? icon;

  /// Size of the icon
  final double iconSize;

  /// Color of the icon
  final Color? iconColor;

  /// Background color of the placeholder
  final Color backgroundColor;

  /// Text to display instead of or along with the icon
  final String? text;

  /// Text style for the placeholder text
  final TextStyle? textStyle;

  /// Border radius of the placeholder
  final BorderRadius? borderRadius;

  /// Shape of the placeholder (circle or rectangle)
  final BoxShape shape;

  /// Border of the placeholder
  final BoxBorder? border;

  /// Spacing between icon and text if both are provided
  final double spacing;

  /// Widget to display instead of the default icon
  final Widget? customWidget;

  /// Shadow elevation
  final double elevation;

  /// Shadow color
  final Color shadowColor;

  const ImagePlaceholder({
    super.key,
    this.size,
    this.width,
    this.height,
    this.icon = Icons.image,
    this.iconSize = 40,
    this.iconColor,
    this.backgroundColor = const Color(0xFFEEEEEE),
    this.text,
    this.textStyle,
    this.borderRadius,
    this.shape = BoxShape.rectangle,
    this.border,
    this.spacing = 8.0,
    this.customWidget,
    this.elevation = 0,
    this.shadowColor = Colors.black,
  }) : assert(
          (size != null) || (width != null && height != null),
          'Either size or both width and height must be provided',
        );

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final Color defaultIconColor =
        theme.colorScheme.primary.withOpacity( 0.6);
    final TextStyle defaultTextStyle =
        theme.textTheme.bodyMedium ?? const TextStyle();

    final double containerWidth = size ?? width!;
    final double containerHeight = size ?? height!;

    final BorderRadius effectiveBorderRadius = borderRadius ??
        (shape == BoxShape.circle
            ? BorderRadius.circular(100)
            : BorderRadius.circular(8));

    return Container(
      width: containerWidth,
      height: containerHeight,
      decoration: BoxDecoration(
        color: backgroundColor,
        shape: shape,
        borderRadius:
            shape == BoxShape.rectangle ? effectiveBorderRadius : null,
        border: border,
        boxShadow: elevation > 0
            ? [
                BoxShadow(
                  color: shadowColor.withOpacity(   0.3),
                  blurRadius: elevation * 2,
                  spreadRadius: elevation / 2,
                  offset: Offset(0, elevation / 2),
                )
              ]
            : null,
      ),
      child: customWidget ??
          Center(
            child: text == null
                ? Icon(
                    icon,
                    size: iconSize,
                    color: iconColor ?? defaultIconColor,
                  )
                : icon == null
                    ? Text(
                        text!,
                        style: textStyle ?? defaultTextStyle,
                        textAlign: TextAlign.center,
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            icon,
                            size: iconSize,
                            color: iconColor ?? defaultIconColor,
                          ),
                          SizedBox(height: spacing),
                          Text(
                            text!,
                            style: textStyle ?? defaultTextStyle,
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
          ),
    );
  }
}
