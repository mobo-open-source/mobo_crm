import 'package:flutter/material.dart';
import 'package:flutter_snake_navigationbar/flutter_snake_navigationbar.dart';
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
      Future.delayed(const Duration(seconds: 3), () {
        if (mounted) {
          ReviewService().checkAndShowRating(context);
        }
      });
    });
    super.initState();
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
            color: AppColors().fillColor,
            borderRadius: BorderRadius.circular(20),
            shadowColor: Colors.black12,
            child: SnakeNavigationBar.color(
              elevation: 0,
              height: 60,
              backgroundColor: AppColors().fillColor,
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
                  icon: _buildHugeIcon(HugeIcons.strokeRoundedUserMultiple, 1),
                  label: 'Leads',
                ),
                BottomNavigationBarItem(
                  icon: _buildHugeIcon(HugeIcons.strokeRoundedInvoice01, 2),
                  label: 'Quotation',
                ),
                BottomNavigationBarItem(
                  icon:
                      _buildHugeIcon(HugeIcons.strokeRoundedCustomerService, 3),
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
}
