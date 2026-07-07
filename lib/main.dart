import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobo_crm/global_methods/services/crm_lead_voice_creation.dart';
import 'package:mobo_crm/global_methods/services/isar_caching_service.dart';
import 'package:mobo_crm/global_methods/services/network_checker.dart';
import 'package:mobo_crm/global_methods/services/siri_intent_service.dart';
import 'package:mobo_crm/screens/myActivities/activities_main/activity_main_provider.dart';
import 'package:mobo_crm/screens/discuss/providers/discuss_provider.dart';
import 'package:mobo_crm/screens/lead/providers/activity_create_provider.dart';
import 'package:mobo_crm/auth/auth.dart';
import 'package:mobo_crm/screens/customers/provider/customer_data_provider.dart';
import 'package:mobo_crm/screens/customers/customers_main_screen.dart';
import 'package:mobo_crm/screens/customers/provider/customer_form_provider.dart';
import 'package:mobo_crm/screens/dashboard/dashboard.dart';
import 'package:mobo_crm/screens/dashboard/provider/dashboard_provider.dart';
import 'package:mobo_crm/screens/discuss/chat/discuss.dart';
import 'package:mobo_crm/initilisation.dart';
import 'package:mobo_crm/screens/lead/providers/lead_form_provider.dart';
import 'package:mobo_crm/screens/lead/providers/lead_data_provider.dart';
import 'package:mobo_crm/screens/lead/lead_main_screen.dart';
import 'package:mobo_crm/global_methods/widgets/loading_screen.dart';
import 'package:mobo_crm/screens/login/get_started_screen.dart';
import 'package:mobo_crm/screens/login/login.dart';
import 'package:mobo_crm/screens/login/server_setup_screen.dart';
import 'package:mobo_crm/screens/myActivities/activity/my_activites_main_screen.dart';
import 'package:mobo_crm/screens/myActivities/activity/provider/activity_data_provider.dart';
import 'package:mobo_crm/screens/myActivities/mail/provider/mail_data_provider.dart';
import 'package:mobo_crm/screens/opportunity/opportunity_main_screen.dart';
import 'package:mobo_crm/screens/opportunity/providers/opportunity_data_provider.dart';
import 'package:mobo_crm/screens/opportunity/providers/stage_provider.dart';
import 'package:mobo_crm/screens/quotation/provider/quotation_view_provider.dart';
import 'package:mobo_crm/screens/quotation/provider/quotebuilder_provider.dart';
import 'package:mobo_crm/screens/quotation/provider/quotation_form_provider.dart';
import 'package:mobo_crm/screens/quotation/quotation_main_screen.dart';
import 'package:mobo_crm/screens/settings/screens/profile/provider/provider_profile.dart';
import 'package:mobo_crm/screens/splash/splash_screen.dart';
import 'package:mobo_crm/utils/globals.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/company/providers/company_provider.dart';
import 'core/company/services/company_session_service_impl.dart';
import 'core/navigation/global_keys.dart';
import 'core/providers/theme_provider.dart';

/// Global navigator key used for programmatic navigation across the app
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

/// Entry point of the Flutter application
///
/// Initializes Flutter bindings, sets system UI overlay style,
/// checks login status from SharedPreferences, initializes Isar database,
/// sets up Siri shortcuts (if applicable), and runs the app with multiple providers.
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final previousOnError = FlutterError.onError;
  FlutterError.onError = (FlutterErrorDetails details) {
    final exceptionStr = details.exception.toString();
    if (details.library == 'image resource service' &&
        exceptionStr.contains('statusCode: 404') &&
        exceptionStr.contains('/web/image/')) {
      return;
    }
    previousOnError?.call(details);
  };

  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );

  final prefs = await SharedPreferences.getInstance();
  bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
  final crmService = CrmService();

  await IsarService.init();

  SiriIntentService.initialize(crmService);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(
          create: (_) {
            final p = CompanyProvider();
            p.initialize();
            return p;
          },
        ),
        ChangeNotifierProvider(create: (context) => OdooClientManager()),
        ChangeNotifierProvider(
            create: (context) => LeadFormProvider(
                sessionService: CompanySessionServiceImpl(),
                isarService: IsarService())),
        ChangeNotifierProvider(create: (context) => DashboardProvider()),
        ChangeNotifierProvider(create: (context) => LeadDataProvider()),
        ChangeNotifierProvider(
            create: (context) => OpportunityDataProvider(
                sessionService: CompanySessionServiceImpl())),
        ChangeNotifierProvider(
            create: (context) => QuotationFormProvider(
                sessionService: CompanySessionServiceImpl())),
        ChangeNotifierProvider(
            create: (context) => QuoteBuilderProvider(
                sessionService: CompanySessionServiceImpl())),
        ChangeNotifierProvider(create: (context) => QuotationViewProvider()),
        ChangeNotifierProvider(
            create: (context) => ActivitiesMainProvider(
                sessionService: CompanySessionServiceImpl())),
        ChangeNotifierProvider(create: (context) => ActivityDataProvider()),
        ChangeNotifierProvider(create: (context) => CustomerDataProvider()),
        ChangeNotifierProvider(
            create: (context) => CustomerFormProvider(
                sessionService: CompanySessionServiceImpl())),
        ChangeNotifierProvider(create: (context) => ActivityCreateProvider()),
        ChangeNotifierProvider(create: (context) => DiscussProvider()),
        ChangeNotifierProvider(create: (context) => MailDataProvider()),
        ChangeNotifierProvider(create: (context) => StageProvider()),
        ChangeNotifierProvider(
            create: (context) => ProfileConfigurationProvider()),
      ],
      child: RestartApp(
        child: MyApp(
          isLoggedIn: isLoggedIn,
        ),
      ),
    ),
  );
}

/// Root widget of the application
///
/// Configures the [MaterialApp] with theme support (light/dark),
/// named routes, global keys, and network status initialization.
class MyApp extends StatelessWidget {
  final bool isLoggedIn;

  const MyApp({super.key, required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      title: 'mobo CRM',
      theme: themeProvider.lightTheme,
      darkTheme: themeProvider.darkTheme,
      themeMode: themeProvider.themeMode,
      debugShowCheckedModeBanner: false,
      navigatorKey: navigatorKey,
      scaffoldMessengerKey: scaffoldMessengerKey,
      initialRoute: '/',
      builder: (context, child) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          NetworkStatusNotifier().initialize(context);
        });
        return child!;
      },
      routes: {
        '/': (context) => const SplashScreen(),
        '/auth_check': (context) => const AuthCheck(),
        '/get_started': (context) => const GetStartedScreen(),
        '/server_setup': (context) => const ServerSetupScreen(),
        '/login': (context) => LoginPage(),
        '/lead': (context) => const LeadMainScreen(),
        '/opportunity': (context) => const OpportunityMainScreen(),
        '/discuss': (context) => const Discuss(),
        '/loading_screen': (context) => LoadingScreen(),
        '/quotation': (context) => const QuotationMainScreen(),
        '/activity': (context) => const MyActivitesMainScreen(),
        '/customer': (context) => const CustomersMainScreen(),
        '/init': (context) => const DashboardInializer(),
      },
    );
  }
}

/// Widget that allows the entire app to be restarted (hot restart simulation)
///
/// Useful when changing language, server URL, theme that requires full rebuild,
/// or after login/logout in some architectures.
class RestartApp extends StatefulWidget {
  final Widget child;

  const RestartApp({super.key, required this.child});

  static void restart(BuildContext context) {
    context.findAncestorStateOfType<_RestartAppState>()?.restartApp();
  }

  @override
  State<RestartApp> createState() => _RestartAppState();
}

class _RestartAppState extends State<RestartApp> {
  Key key = UniqueKey();

  void restartApp() {
    setState(() {
      key = UniqueKey();
    });
  }

  @override
  Widget build(BuildContext context) {
    return KeyedSubtree(
      key: key,
      child: widget.child,
    );
  }
}
