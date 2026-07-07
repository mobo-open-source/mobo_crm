import 'package:flutter/material.dart';
import 'package:mobo_crm/global_methods/const.dart';

/// A reusable circular/rounded icon button used in forms and detail views.
///
/// Features:
///   - Fixed square container (50×50) with background color
///   - Supports either Material Icon or asset image
///   - Custom tap callback
///   - Optional custom icon/button color
///
/// Typical use: action buttons in form headers (edit, delete, attach, chat, etc.)
class FormViewCustomIcon extends StatelessWidget {
  final IconData icon;
  final void Function()? onTap;
  final bool isIcon;
  final String url;
  final Color? buttonColor;

  const FormViewCustomIcon(
      {super.key,
      required this.icon,
      required this.onTap,
      this.buttonColor,
      this.isIcon = true,
      this.url = ""});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(10),
        height: 50,
        width: 50,
        decoration: BoxDecoration(
            color: AppColors().iconBackground,
            borderRadius: BorderRadius.circular(5)),
        child: isIcon
            ? Icon(
                icon,
                size: 30,
                color: buttonColor,
              )
            : Image.asset(url),
      ),
    );
  }
}
