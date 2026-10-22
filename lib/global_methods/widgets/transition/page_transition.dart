import 'package:flutter/material.dart';

/// A page route builder that animates the new page sliding in from the **right** to left.
///
/// This transition gives a natural "next screen" feeling (common in forward navigation).
///
/// Example usage:
/// ```dart
/// Navigator.push(
///   context,
///   SlidingPageTransitionRL(page: const NextScreen()),
/// );
class SlidingPageTransitionRL extends PageRouteBuilder {
  final Widget page;

  SlidingPageTransitionRL({required this.page})
      : super(
          transitionDuration: const Duration(milliseconds: 550),
          reverseTransitionDuration: const Duration(milliseconds: 300),
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: CurvedAnimation(
                parent: animation,
                curve: Curves.easeOut,
              ),
              child: ScaleTransition(
                scale: Tween<double>(begin: 0.93, end: 1.0).animate(
                  CurvedAnimation(
                    parent: animation,
                    curve: Curves.easeOutCubic,
                  ),
                ),
                child: child,
              ),
            );
          },
        );
}

/// A page route builder that animates the new page sliding in from the **left** to right.
///
/// This transition is typically used for "back" navigation or reverse flow.
///
/// Example usage:
/// ```dart
/// Navigator.push(
///   context,
///   SlidingPageTransitionLR(page: const PreviousScreen()),
/// );
/// ```
class SlidingPageTransitionLR extends PageRouteBuilder {
  final Widget page;

  SlidingPageTransitionLR({required this.page})
      : super(
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(-1.0, 0.0);
      const end = Offset.zero;
      const curve = Curves.fastOutSlowIn;

      var tween =
      Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
      var offsetAnimation = animation.drive(tween);

      return SlideTransition(position: offsetAnimation, child: child);
    },
  );
}
