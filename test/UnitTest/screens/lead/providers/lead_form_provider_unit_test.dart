import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mobo_crm/core/company/services/company_session_service.dart';
import 'package:mobo_crm/global_methods/services/isar_caching_service.dart';
import 'package:mobo_crm/screens/lead/isar/lead_form_data_model.dart';
import 'package:mobo_crm/screens/lead/providers/lead_form_provider.dart';
import 'package:odoo_rpc/odoo_rpc.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Mock classes to simulate dependencies and external services
class MockBuildContext extends Mock implements BuildContext {}

class MockSessionService extends Mock implements CompanySessionService {}

class MockOdooClient extends Mock implements OdooClient {}

class MockIsarService extends Mock implements IsarService {}

class FakeLeadFormDataModel extends Fake implements LeadFormDataModel {}

/// A test subclass of [LeadFormProvider] overriding fetchStatus to avoid actual API calls
class TestLeadFormProvider extends LeadFormProvider {
  TestLeadFormProvider({
    required super.sessionService,
    required super.isarService,
  });

  @override
  Future<void> fetchStatus(OdooClient client, dynamic lead,
      {bool loading = false}) async {}
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late MockBuildContext mockBuildContext;
  late MockSessionService mockSessionService;
  late MockOdooClient mockOdooClient;
  late MockIsarService mockIsarService;
  late LeadFormProvider provider;

  /// Register fallback values for mocking
  setUpAll(() {
    registerFallbackValue(FakeLeadFormDataModel());
  });

  /// Setup dependencies before each test
  setUp(() {
    SharedPreferences.setMockInitialValues({});
    mockBuildContext = MockBuildContext();
    mockSessionService = MockSessionService();
    mockOdooClient = MockOdooClient();
    mockIsarService = MockIsarService();
    provider = TestLeadFormProvider(
      sessionService: mockSessionService,
      isarService: mockIsarService,
    );

    when(() => mockBuildContext.mounted).thenReturn(true);
  });

  /// Group of tests for `LeadFormProvider.saveChanges` method
  group("LeadFormProvider.saveChanges - ", () {

    /// Test that saveChanges returns true when the lead is updated successfully
    test('Should update lead successfully', () async {
      when(() => mockSessionService.callKwWithCompanyUpdate(any()))
          .thenAnswer((_) async => true);
      when(() => mockIsarService.saveLeadFormData(any()))
          .thenAnswer((_) async {});

      final result = await provider
          .saveChanges(mockOdooClient, mockBuildContext, {'id': 1});
      expect(result, true);

      verify(() => mockSessionService.callKwWithCompanyUpdate(any())).called(1);
    });

    /// Test that saveChanges returns false when the update fails
    test('Should update lead fails', () async {
      when(() => mockSessionService.callKwWithCompanyUpdate(any()))
          .thenAnswer((_) async => false);

      final result = await provider
          .saveChanges(mockOdooClient, mockBuildContext, {'id': 1});
      expect(result, false);

      verify(() => mockSessionService.callKwWithCompanyUpdate(any())).called(1);
    });

    /// Test that saveChanges properly throws an exception when the API fails
    test('Should go to catch block when API throws exception', () async {
      when(() => mockSessionService.callKwWithCompanyUpdate(any()))
          .thenThrow(Exception('API Error'));

      await expectLater(
        () => provider.saveChanges(mockOdooClient, mockBuildContext, {'id': 1}),
        throwsA(isA<Exception>()),
      );

      verify(() => mockSessionService.callKwWithCompanyUpdate(any())).called(1);
    });
  });

  /// Group of tests for `LeadFormProvider.createOpportunity` method
  group("LeadFormProvider.createOpportunity - ", () {

    /// Test that createOpportunity returns false when the name field is empty
    test('Should show warning when name is empty', () async {
      provider.nameController.text = '';

      final result = await provider.createOpportunity(
          mockOdooClient, mockBuildContext, 'lead');

      expect(result, false);
    });

    /// Test that createOpportunity successfully creates a lead when valid data is provided
    test('Should create lead successfully', () async {
      provider.nameController.text = "Test Lead";
      when(() => mockSessionService.callKwWithCompany(any()))
          .thenAnswer((_) async => 1);

      final result = await provider.createOpportunity(
          mockOdooClient, mockBuildContext, 'lead');
      expect(result, true);

      verify(() => mockSessionService.callKwWithCompany(any())).called(1);
    });

    /// Test that createOpportunity returns false if the API throws an exception
    test('Should return false when API throws exception', () async {
      provider.nameController.text = "Test Lead";
      when(() => mockSessionService.callKwWithCompany(any()))
          .thenThrow(Exception('API Error'));

      final result = await provider.createOpportunity(
          mockOdooClient, mockBuildContext, 'lead');
      expect(result, false);

      verify(() => mockSessionService.callKwWithCompany(any())).called(1);
    });
  });
}
