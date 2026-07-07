import 'package:flutter/material.dart';

/// Full-screen loading overlay with animated fade-in effect.
///
/// Features:
///   - Takes over the entire screen with primary color background
///   - Simple fade-in animation on mount (800ms duration)
///   - Optional `isRoute` flag (currently unused — can be extended for route-aware behavior)
///   - Lightweight: no heavy widgets or spinners by default (body is empty)
///
/// Typical use:
///   - Splash-like loading screen during app initialization
///   - Full-screen overlay during long API calls or data sync
///   - Transition screen between routes (when `isRoute: true`)
///
/// Example:
/// ```dart
/// Navigator.push(
///   context,
///   MaterialPageRoute(builder: (_) => LoadingScreen(isRoute: true)),
/// );
/// ```
class LoadingScreen extends StatefulWidget {
  final bool isRoute;
  const LoadingScreen({super.key, this.isRoute = true});

  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> fadeAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    fadeAnimation = Tween<double>(begin: 0, end: 1).animate(_controller);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: const SizedBox.shrink(),
    );
  }
}
