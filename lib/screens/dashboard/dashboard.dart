import 'package:flutter/material.dart';
import 'package:mobo_crm/bottom_nav_screen.dart';
import 'package:mobo_crm/initilisation.dart';
import 'package:mobo_crm/screens/dashboard/provider/dashboard_provider.dart';

import 'package:provider/provider.dart';

import 'dart:async';

/// Initializes dashboard dependencies before rendering the main screen.
///
/// Responsibilities:
/// - Initializes [DashboardProvider]
/// - Initializes [OdooClientManager] after first frame render
/// - Ensures required dashboard data is prepared
///
/// This widget acts as a setup layer before displaying the home screen.
class DashboardInializer extends StatefulWidget {
  const DashboardInializer({super.key});

  @override
  State<DashboardInializer> createState() => _DashboardInializerState();
}

/// State class for [DashboardInializer].
///
/// Handles:
/// - Asynchronous dashboard initialization
/// - Safe Odoo client initialization using post-frame callback
///
/// Ensures all services are ready before user interaction.
class _DashboardInializerState extends State<DashboardInializer> {
  late Future<bool> _initFuture;

  @override
  void initState() {
    super.initState();
    _initFuture = _initializeDashboard();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<OdooClientManager>().initializeOdooClient(context);
    });
  }

  /// Initializes dashboard data using [DashboardProvider.init].
  ///
  /// Returns:
  /// - `true` if initialization succeeds
  /// - `false` if an exception occurs
  ///
  /// This method ensures required dashboard configurations
  /// are loaded before rendering dashboard views.
  Future<bool> _initializeDashboard() async {
    try {
      final success = await Provider.of<DashboardProvider>(
        context,
        listen: false,
      ).init(context);

      return success;
    } catch (e) {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return const HomeScreen();
  }
}
