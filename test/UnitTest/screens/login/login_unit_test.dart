import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mobo_crm/core/company/services/company_session_service.dart';

import 'package:mobo_crm/models/LoginPage/session_model.dart';
import 'package:mobo_crm/services/login_service.dart';
import 'package:mobo_crm/services/storage_service.dart';
import 'package:mobo_crm/services/app_install_check.dart';

/// Mock classes to simulate dependencies
class MockStorageService extends Mock implements StorageService {}

class MockAppInstallCheck extends Mock implements AppInstallCheck {}

class MockCompanySessionService extends Mock implements CompanySessionService {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late MockStorageService storageService;
  late MockAppInstallCheck appInstallCheck;
  late LoginService loginService;
  late MockCompanySessionService mockCompanySessionService;

  /// Fake session data returned by the mock session service
  final FakeSession = SessionModel(
    sessionId: 'session_123',
    userId: 1,
    userLogin: 'admin',
    userName: 'Administrator',
    serverVersion: '17.0',
    userLang: 'en_US',
    userTimezone: 'UTC',
    partnerId: 1,
    companyId: 1,
    companyName: 'My Company',
    isSystem: true,
    version: 17,
    allowedCompanyIds: [1],
  );

  /// Register fallback value for mocking session model
  setUpAll(() {
    registerFallbackValue(FakeSession);
  });

  /// Initialize mocks and the service before each test
  setUp(() {
    storageService = MockStorageService();
    appInstallCheck = MockAppInstallCheck();
    mockCompanySessionService = MockCompanySessionService();

    loginService = LoginService(
      storageService: storageService,
      appInstallCheck: appInstallCheck,
      sessionService: mockCompanySessionService,
    );
  });

  /// Group of tests for `LoginService.login` method
  group('LoginService.login', () {
    /// Test login success when credentials are correct and required modules are installed
    test('returns success when login ok and module installed', () async {
      when(() => mockCompanySessionService.loginAndSaveSession(
            serverUrl: any(named: 'serverUrl'),
            database: any(named: 'database'),
            userLogin: any(named: 'userLogin'),
            password: any(named: 'password'),
          )).thenAnswer((_) async => true);

      when(() => mockCompanySessionService.getCurrentSession())
          .thenAnswer((_) async => FakeSession);

      when(() => storageService.saveSession(any())).thenAnswer((_) async {});
      when(() => storageService.saveLoginState(
            isLoggedIn: true,
            database: any(named: 'database'),
            url: any(named: 'url'),
          )).thenAnswer((_) async {});
      when(
        () => storageService.saveAccount(any()),
      ).thenAnswer((_) async => {});
      when(() => appInstallCheck.checkRequiredModules())
          .thenAnswer((_) async => true);

      final result = await loginService.login(
        serverUrl: 'https://demo.odoo.com',
        database: 'demo',
        username: 'admin',
        password: 'admin',
      );

      expect(result.status, LoginStatus.success);

      verify(() => storageService.saveSession(any())).called(1);
      verify(() => storageService.saveAccount(any())).called(1);
      verify(() => appInstallCheck.checkRequiredModules()).called(1);
    });

    /// Test login fails due to invalid credentials
    test('returns invalidCredentials when login fails', () async {
      when(() => mockCompanySessionService.loginAndSaveSession(
            serverUrl: any(named: 'serverUrl'),
            database: any(named: 'database'),
            userLogin: any(named: 'userLogin'),
            password: any(named: 'password'),
          )).thenAnswer((_) async => false);

      final result = await loginService.login(
        serverUrl: 'x',
        database: 'x',
        username: 'x',
        password: 'x',
      );

      expect(result.status, LoginStatus.invalidCredentials);
    });

    /// Test login requires 2FA (TOTP) when API throws specific exception
    test('returns totpRequired when 2FA error thrown', () async {
      when(() => mockCompanySessionService.loginAndSaveSession(
            serverUrl: any(named: 'serverUrl'),
            database: any(named: 'database'),
            userLogin: any(named: 'userLogin'),
            password: any(named: 'password'),
          )).thenThrow(Exception('2FA required'));

      final result = await loginService.login(
        serverUrl: 'x',
        database: 'x',
        username: 'x',
        password: 'x',
      );

      expect(result.status, LoginStatus.totpRequired);
    });

    /// Test login returns moduleMissing when required modules (e.g., CRM) are not installed
    test('returns moduleMissing when CRM module not installed', () async {
      when(() => mockCompanySessionService.loginAndSaveSession(
            serverUrl: any(named: 'serverUrl'),
            database: any(named: 'database'),
            userLogin: any(named: 'userLogin'),
            password: any(named: 'password'),
          )).thenAnswer((_) async => true);

      when(() => mockCompanySessionService.getCurrentSession())
          .thenAnswer((_) async => FakeSession);

      when(() => storageService.saveSession(any())).thenAnswer((_) async {});
      when(() => storageService.saveLoginState(
            isLoggedIn: true,
            database: any(named: 'database'),
            url: any(named: 'url'),
          )).thenAnswer((_) async {});
      when(
        () => storageService.saveAccount(any()),
      ).thenAnswer((_) async => {});
      when(() => appInstallCheck.checkRequiredModules())
          .thenAnswer((_) async => false);

      final result = await loginService.login(
        serverUrl: 'x',
        database: 'x',
        username: 'x',
        password: 'x',
      );

      expect(result.status, LoginStatus.moduleMissing);
    });
  });
}
