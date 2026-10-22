import 'package:flutter/material.dart';
import 'package:flutter_snake_navigationbar/flutter_snake_navigationbar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:mobo_crm/global_methods/const.dart';
import 'package:mobo_crm/initilisation.dart';
import 'package:mobo_crm/screens/myActivities/activities_main/activity_main_provider.dart';
import 'package:mobo_crm/screens/myActivities/activities_main/activity_main_screen.dart';
import 'package:mobo_crm/screens/customers/customers_main_screen.dart';
import 'package:mobo_crm/screens/customers/provider/customer_data_provider.dart';
import 'package:mobo_crm/screens/dashboard/provider/dashboard_provider.dart';
import 'package:mobo_crm/screens/lead/lead_main_screen.dart';
import 'package:mobo_crm/screens/lead/providers/lead_data_provider.dart';
import 'package:mobo_crm/screens/opportunity/opportunity_main_screen.dart';
import 'package:mobo_crm/screens/opportunity/providers/opportunity_data_provider.dart';
import 'package:mobo_crm/screens/quotation/provider/quotation_view_provider.dart';
import 'package:mobo_crm/screens/quotation/quotation_main_screen.dart';
import 'package:provider/provider.dart';

import 'Rating/review_service.dart';
import 'core/company/session/company_session_manager.dart';
import 'global_methods/services/global_error_handler.dart';
import 'services/storage_service.dart';
import 'utils/globals.dart';

/// Main home screen of the CRM application with bottom navigation.
///
/// Features:
/// * Snake-style animated bottom navigation bar (using flutter_snake_navigationbar)
/// * 5 main sections: Pipeline (Opportunities), Leads, Quotations, Customers, Activities
/// * Refreshes data when tapping on already selected tab
/// * Custom back button behavior: returns to Pipeline tab instead of popping screen
class HomeScreen extends StatefulWidget {
  final bool loadInit;

  const HomeScreen({super.key, this.loadInit = false});

  @override
  // ignore: library_private_types_in_public_api
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  bool firstTap = false;
  final List<Widget> _screens = [
    OpportunityMainScreen(),
    LeadMainScreen(),
    QuotationMainScreen(),
    CustomersMainScreen(),
    ActivitiesScreen(),
  ];

  @override
  void initState() {
    if (widget.loadInit) {
      _initializeDashboard();
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _guardAgainstPortalUser();
      Future.delayed(const Duration(seconds: 3), () {
        if (mounted) {
          ReviewService().checkAndShowRating(context);
        }
      });
    });
    super.initState();
  }

  /// Safety net run every time the main app shell mounts, regardless of
  /// which login path got here (regular, 2FA, switch-account, or an
  /// auto-restored saved session on app start) — portal users must never
  /// be able to use the internal app, since they lack access to crm.lead
  /// and other internal models.
  Future<void> _guardAgainstPortalUser() async {
    final isPortal = await ErrorHandler().isPortalUser();
    if (!isPortal || !mounted) return;

    await StorageService().clearAllSessionData();
    await CompanySessionManager.clearSessionCache();

    if (!mounted) return;
    Navigator.of(context).pushNamedAndRemoveUntil(
      '/server_setup',
      (route) => false,
    );
    _showAccessDeniedDialog(context);
  }

  /// Initializes dashboard data (usually called on first app open after login)
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Consumer6<
            OpportunityDataProvider,
            LeadDataProvider,
            QuotationViewProvider,
            CustomerDataProvider,
            OdooClientManager,
            ActivitiesMainProvider>(
        builder: (context, oppodata, leaddata, saledata, customerdata,
            clientprovider, activityData, child) {
      return PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, _) {
          if (didPop) return;
          if (_selectedIndex != 0) {
            setState(() {
              _selectedIndex = 0;
            });
            oppodata.getOpportunities(
              loading: true,
              context: context,
              isOpportunity: true,
            );
          }
        },
        child: Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          body: _screens[_selectedIndex],
          bottomNavigationBar: PhysicalModel(
            color: isDark ? const Color(0xFF1E1E1E) : AppColors().fillColor,
            borderRadius: BorderRadius.circular(20),
            shadowColor: Colors.black12,
            // Scaffold.bottomNavigationBar isn't inset for the device's
            // bottom safe area on its own, so on gesture-nav devices the
            // labels sit flush against the system gesture bar. SafeArea
            // reserves that space, filled with the same PhysicalModel color.
            child: SafeArea(
              top: false,
              // Keeps the labels clear of rounded screen corners even when the
              // device reports no bottom inset (system bars hidden).
              minimum: const EdgeInsets.only(bottom: 8),
              child: SnakeNavigationBar.color(
                elevation: 0,
                height: 60,
                backgroundColor:
                    isDark ? const Color(0xFF1E1E1E) : AppColors().fillColor,
                behaviour: SnakeBarBehaviour.pinned,
                snakeShape: SnakeShape.indicator,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(0),
                ),
                snakeViewColor: Theme.of(context).primaryColor,
                selectedItemColor: Theme.of(context).primaryColor,
                unselectedItemColor: Colors.grey.shade500,
                showSelectedLabels: true,
                showUnselectedLabels: true,
                currentIndex: _selectedIndex,
                onTap: (index) {
                  if (_selectedIndex == index) {
                    switch (index) {
                      case 0:
                        oppodata.getOpportunities(
                          loading: true,
                          context: context,
                          isOpportunity: true,
                        );
                        break;
                      case 1:
                        leaddata.initlead(
                          loading: true,
                          context,
                        );
                        break;
                      case 2:
                        saledata.getQuotationsAndReport(
                            loading: true,
                            context: context,
                            session: clientprovider.currentsession!);

                        break;
                      case 3:
                        customerdata.fetchCustomerData(
                            loading: true, context: context);

                        break;
                      case 4:
                        activityData.fetchActivities(isNotify: true);
                        break;
                    }
                  } else {
                    if (mounted) {
                      setState(() {
                        _selectedIndex = index;
                      });
                    }
                  }
                },
                items: [
                  BottomNavigationBarItem(
                    icon: _buildHugeIcon(HugeIcons.strokeRoundedBriefcase01, 0),
                    label: 'Pipeline',
                  ),
                  BottomNavigationBarItem(
                    icon:
                        _buildHugeIcon(HugeIcons.strokeRoundedUserMultiple, 1),
                    label: 'Leads',
                  ),
                  BottomNavigationBarItem(
                    icon: _buildHugeIcon(HugeIcons.strokeRoundedInvoice01, 2),
                    label: 'Quotation',
                  ),
                  BottomNavigationBarItem(
                    icon: _buildHugeIcon(
                        HugeIcons.strokeRoundedCustomerService, 3),
                    label: 'Customer',
                  ),
                  BottomNavigationBarItem(
                    icon: _buildHugeIcon(HugeIcons.strokeRoundedCalendar03, 4),
                    label: 'Activities',
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }

  Widget _buildHugeIcon(IconData iconData, int index) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 2),
      child: Icon(
        iconData,
        color: _selectedIndex == index
            ? Theme.of(context).primaryColor
            : Colors.grey.shade500,
        size: 22,
      ),
    );
  }

  void _showAccessDeniedDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        titlePadding: const EdgeInsets.fromLTRB(24, 32, 24, 0),
        contentPadding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
        actionsPadding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
        title: Row(
          children: [
            const Icon(
              HugeIcons.strokeRoundedAlertCircle,
              color: AppStyle.primaryColor,
              size: 24,
            ),
            const SizedBox(width: 12),
            Text(
              'Access Denied',
              style: GoogleFonts.manrope(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Colors.black,
              ),
            ),
          ],
        ),
        content: Text(
          'This feature is not available for portal users. Please contact your administrator.',
          style: GoogleFonts.manrope(
            fontSize: 15,
            color: Colors.black87,
            height: 1.5,
          ),
        ),
        actions: [
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppStyle.primaryColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                padding: const EdgeInsets.symmetric(vertical: 14),
                elevation: 0,
              ),
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Back to Login',
                style: GoogleFonts.manrope(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
