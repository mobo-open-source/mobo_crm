import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mobo_crm/core/company/services/company_session_service.dart';
import 'package:mobo_crm/models/isar/lead_and_customer_models.dart';
import 'package:mobo_crm/models/models.dart';
import 'package:mobo_crm/screens/customers/provider/customer_form_provider.dart';
import 'package:odoo_rpc/odoo_rpc.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Mock class for [BuildContext] to use in widget-independent testing.
class MockBuildContext extends Mock implements BuildContext {}

/// Mock class for [CompanySessionService] to simulate API responses.
class MockSessionService extends Mock implements CompanySessionService {}

/// Mock class for [OdooClient] to simulate Odoo API client behavior.
class MockOdooClient extends Mock implements OdooClient {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  /// Mock instances used across tests
  late MockBuildContext mockBuildContext;
  late MockSessionService mockSessionService;
  late MockOdooClient mockOdooClient;
  late CustomerFormProvider provider;

  /// Setup common test dependencies before each test
  setUp(() {
    SharedPreferences.setMockInitialValues({});
    mockBuildContext = MockBuildContext();
    mockSessionService = MockSessionService();
    mockOdooClient = MockOdooClient();
    provider = CustomerFormProvider(sessionService: mockSessionService);

    when(() => mockBuildContext.mounted).thenReturn(true);
  });

  /// Group of tests for `CustomerFormProvider.createCustomerData`
  group("CustomerFormProvider.createCustomerData - ", () {

    /// Test to check behavior when the customer name is empty
    test('Should show warning when name is empty', () async {
      provider.nameController.text = '';
      await provider.createCustomerData(mockBuildContext);
      expect(provider.isLoading, false);
      expect(provider.customerIdRaw, null);
    });

    /// Test to ensure a customer is successfully created with all fields provided
    test('Should create customer successfully', () async {
      final parentCompany = CustomerItemModel()
        ..serverId = 200
        ..name = 'Parent Company';

      final salesperson = CustomerItemModel()
        ..serverId = 15
        ..name = 'John Doe';

      final salesTeam = CustomerItemModel()
        ..serverId = 3
        ..name = 'Direct Sales';

      provider.nameController.text = 'Sara Ahmed';
      provider.streetController.text = '123 Main Street';
      provider.street2Controller.text = 'Near Metro Station';
      provider.cityController.text = 'London';
      provider.zipController.text = '682001';
      provider.phoneController.text = '971676';
      provider.mobileController.text = '9999999';
      provider.emailController.text = 'sara@example.com';
      provider.websiteController.text = 'https://example.com';
      provider.langController.text = 'en_US';
      provider.referenceController.text = 'REF001';
      provider.jobPositionController.text = 'Sales Manager';
      provider.commentController.text = 'Important CRM customer';
      provider.companyRegistryController.text = 'CR123456';

      provider.checkType = 'contact';
      provider.selectedCategoriesId = [1, 2];
      provider.selectedImageBase64 = 'base64encodedimage';

      provider.selectedState = StateClass(id: 10, name: 'USA');
      provider.selectedCountry = Country(id: 91, name: 'London');
      provider.selectedIndustry = IndustryModel(id: 5, name: 'IT');

      provider.selectedCompanyID = parentCompany;
      provider.selectedSalesperson = salesperson;
      provider.selectedSalesTeam = salesTeam;

      provider.selectedCustomerPaymentTerm =
          AccountPaymentTerm(id: 7, name: '30 Days');

      provider.selectedSupplierPaymentTerm =
          AccountPaymentTerm(id: 8, name: '45 Days');

      provider.selectedPaymentMethod =
          AccountPaymentMethod(id: 4, name: 'Bank Transfer');

      when(() => mockSessionService.callKwWithCompany(any()))
          .thenAnswer((_) async => 100);

      await provider.createCustomerData(mockBuildContext);

      expect(provider.customerIdRaw, 100);
      expect(provider.hasError, false);
    });

    /// Test duplicate behavior (similar to success test) for demonstration
    test('Should create customer fails', () async {
      final parentCompany = CustomerItemModel()
        ..serverId = 200
        ..name = 'Parent Company';

      final salesperson = CustomerItemModel()
        ..serverId = 15
        ..name = 'John Doe';

      final salesTeam = CustomerItemModel()
        ..serverId = 3
        ..name = 'Direct Sales';

      provider.nameController.text = 'Sara Ahmed';
      provider.streetController.text = '123 Main Street';
      provider.street2Controller.text = 'Near Metro Station';
      provider.cityController.text = 'London';
      provider.zipController.text = '682001';
      provider.phoneController.text = '971676';
      provider.mobileController.text = '9999999';
      provider.emailController.text = 'sara@example.com';
      provider.websiteController.text = 'https://example.com';
      provider.langController.text = 'en_US';
      provider.referenceController.text = 'REF001';
      provider.jobPositionController.text = 'Sales Manager';
      provider.commentController.text = 'Important CRM customer';
      provider.companyRegistryController.text = 'CR123456';

      provider.checkType = 'contact';
      provider.selectedCategoriesId = [1, 2];
      provider.selectedImageBase64 = 'base64encodedimage';

      provider.selectedState = StateClass(id: 10, name: 'USA');
      provider.selectedCountry = Country(id: 91, name: 'London');
      provider.selectedIndustry = IndustryModel(id: 5, name: 'IT');

      provider.selectedCompanyID = parentCompany;
      provider.selectedSalesperson = salesperson;
      provider.selectedSalesTeam = salesTeam;

      provider.selectedCustomerPaymentTerm =
          AccountPaymentTerm(id: 7, name: '30 Days');

      provider.selectedSupplierPaymentTerm =
          AccountPaymentTerm(id: 8, name: '45 Days');

      provider.selectedPaymentMethod =
          AccountPaymentMethod(id: 4, name: 'Bank Transfer');

      when(() => mockSessionService.callKwWithCompany(any()))
          .thenAnswer((_) async => 100);

      await provider.createCustomerData(mockBuildContext);

      expect(provider.customerIdRaw, 100);
      expect(provider.hasError, false);
    });

    /// Test to ensure errors are caught when the API throws an exception
    test('Should go to catch block when API throws exception', () async {
      provider.nameController.text = 'Sara Ahmed';
      when(() => mockSessionService.callKwWithCompany(any()))
          .thenThrow(Exception('API Error'));
      await provider.createCustomerData(mockBuildContext);
      expect(provider.customerIdRaw, null);
      expect(provider.hasError, true);
      expect(provider.isLoading, false);
      verify(() => mockSessionService.callKwWithCompany(any())).called(1);
    });
  });

  /// Group of tests for `CustomerFormProvider.saveCustomerData`
  group("CustomerFormProvider.saveCustomerData - ", () {

    /// Test to check behavior when the customer name is empty
    test('Should show warning when name is empty', () async {
      provider.nameController.text = '';
      final result =
          await provider.saveCustomerData(mockOdooClient, 10, mockBuildContext);
      expect(result, false);
      expect(provider.isLoading, false);
    });

    /// Test to ensure customer is successfully updated
    test('Should update customer successfully', () async {
      final parentCompany = CustomerItemModel()
        ..serverId = 200
        ..name = 'Parent Company';

      final salesperson = CustomerItemModel()
        ..serverId = 15
        ..name = 'John Doe';

      final salesTeam = CustomerItemModel()
        ..serverId = 3
        ..name = 'Direct Sales';

      provider.nameController.text = 'Sara Ahmed';
      provider.streetController.text = '123 Main Street';
      provider.street2Controller.text = 'Near Metro Station';
      provider.cityController.text = 'London';
      provider.zipController.text = '682001';
      provider.phoneController.text = '971676';
      provider.mobileController.text = '9999999';
      provider.emailController.text = 'sara@example.com';
      provider.websiteController.text = 'https://example.com';
      provider.referenceController.text = 'REF001';
      provider.jobPositionController.text = 'Sales Manager';
      provider.companyRegistryController.text = 'CR123456';

      provider.selectedCategoriesId = [1, 2];
      provider.selectedImageBase64 = 'base64encodedimage';

      provider.selectedState = StateClass(id: 10, name: 'USA');
      provider.selectedCountry = Country(id: 91, name: 'London');
      provider.selectedIndustry = IndustryModel(id: 5, name: 'IT');

      provider.selectedCompanyID = parentCompany;
      provider.selectedSalesperson = salesperson;
      provider.selectedSalesTeam = salesTeam;

      provider.selectedCustomerPaymentTerm =
          AccountPaymentTerm(id: 7, name: '30 Days');

      provider.selectedSupplierPaymentTerm =
          AccountPaymentTerm(id: 8, name: '45 Days');

      provider.selectedPaymentMethod =
          AccountPaymentMethod(id: 4, name: 'Bank Transfer');

      when(() => mockSessionService.callKwWithCompanyUpdate(any()))
          .thenAnswer((_) async => true);

      final result =
          await provider.saveCustomerData(mockOdooClient, 10, mockBuildContext);
      expect(result, true);

      verify(() => mockSessionService.callKwWithCompanyUpdate(any())).called(1);
    });

    /// Test to ensure errors are caught when the API throws an exception
    test('Should go to catch block when API throws exception', () async {
      provider.nameController.text = 'Sara Ahmed';
      when(() => mockSessionService.callKwWithCompanyUpdate(any()))
          .thenThrow(Exception('API Error'));
      final result =
          await provider.saveCustomerData(mockOdooClient, 10, mockBuildContext);
      expect(result, false);

      verify(() => mockSessionService.callKwWithCompanyUpdate(any())).called(1);
    });
  });
}
