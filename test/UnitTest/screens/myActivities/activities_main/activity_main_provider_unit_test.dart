import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mobo_crm/core/company/services/company_session_service.dart';
import 'package:mobo_crm/screens/myActivities/activities_main/activity_main_provider.dart';
import 'package:odoo_rpc/odoo_rpc.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Mock class to simulate the CompanySessionService dependency
class MockSessionService extends Mock implements CompanySessionService {}

/// Mock class to simulate the OdooClient dependency
class MockOdooClient extends Mock implements OdooClient {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late MockSessionService mockSessionService;
  late MockOdooClient mockOdooClient;
  late ActivitiesMainProvider provider;

  /// Initialize mocks and provider before each test
  setUp(() {
    SharedPreferences.setMockInitialValues({});
    mockSessionService = MockSessionService();
    mockOdooClient = MockOdooClient();
    provider = ActivitiesMainProvider(sessionService: mockSessionService);
  });

  /// Group of tests for `markActivityDone` method
  group("ActivitiesMainProvider.markActivityDone -", () {
    /// Test marking an activity as done successfully
    test('Should mark activity done successfully', () async {
      when(() => mockSessionService.callKwWithCompany(any()))
          .thenAnswer((_) async => 1);
      await provider.markActivityDone(mockOdooClient, {'id': 1});

      verify(() => mockSessionService.callKwWithCompany(any())).called(1);
    });

    /// Test exception handling when the API call fails
    test('Should throw exception when API fails', () async {
      when(() => mockSessionService.callKwWithCompany(any()))
          .thenThrow(Exception('API Error'));

      expect(
        () => provider.markActivityDone(mockOdooClient, {'id': 1}),
        throwsA(isA<Exception>()),
      );
      verify(() => mockSessionService.callKwWithCompany(any())).called(1);
    });
  });

  /// Group of tests for `deleteActivity` method
  group("ActivitiesMainProvider.deleteActivity -", () {
    /// Test deleting an activity successfully
    test('Should delete activity successfully', () async {
      when(() => mockSessionService.callKwWithCompany(any()))
          .thenAnswer((_) async => 1);

      final result = await provider.deleteActivity(mockOdooClient, {'id': 1});

      expect(result, true);
      verify(() => mockSessionService.callKwWithCompany(any())).called(1);
    });

    /// Test handling API exception while deleting an activity
    test('Should return false when API throws exception', () async {
      when(() => mockSessionService.callKwWithCompany(any()))
          .thenThrow(Exception('API Error'));

      final result = await provider.deleteActivity(mockOdooClient, {'id': 1});

      expect(result, false);
      verify(() => mockSessionService.callKwWithCompany(any())).called(1);
    });
  });
}
