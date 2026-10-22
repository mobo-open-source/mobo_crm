import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mobo_crm/core/company/services/company_session_service.dart';
import 'package:mobo_crm/models/LoginPage/session_model.dart';
import 'package:mobo_crm/models/models.dart';
import 'package:mobo_crm/models/quotation_model/quotation_model.dart';
import 'package:mobo_crm/screens/quotation/provider/quotation_form_provider.dart';
import 'package:mobo_crm/screens/quotation/provider/quotation_view_provider.dart';
import 'package:mobo_crm/screens/quotation/provider/quotebuilder_provider.dart';
import 'package:odoo_rpc/odoo_rpc.dart';

class MockSessionService extends Mock implements CompanySessionService {}

class MockBuildContext extends Mock implements BuildContext {}

class MockOdooClient extends Mock implements OdooClient {}

class FakeOdooClient extends Fake implements OdooClient {}

class FakeSessionModel extends Fake implements SessionModel {}

class FakeBuildContext extends Fake implements BuildContext {}

/// Test subclass for QuotationFormProvider to override tax field
class TestQuotationFormProvider extends QuotationFormProvider {
  TestQuotationFormProvider({required super.sessionService});

  @override
  Future<String> fetchTaxFieldName(OdooClient client) async {
    return 'tax_ids';
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() {
    registerFallbackValue(FakeOdooClient());
    registerFallbackValue(FakeSessionModel());
    registerFallbackValue(FakeBuildContext());
  });

  late MockSessionService mockSessionService;
  late MockBuildContext mockBuildContext;
  late MockOdooClient mockOdooClient;
  late TestQuotationFormProvider provider;
  late QuoteBuilderProvider buildProvider;
  late QuotationViewProvider viewProvider;

  setUp(() {
    mockBuildContext = MockBuildContext();
    mockOdooClient = MockOdooClient();
    mockSessionService = MockSessionService();
    provider = TestQuotationFormProvider(sessionService: mockSessionService);
    buildProvider = QuoteBuilderProvider(sessionService: mockSessionService);
    viewProvider = QuotationViewProvider();

    when(() => mockBuildContext.mounted).thenReturn(true);
  });

  /// ----------------------------
  /// Tests for createQuotationOnly
  /// ----------------------------
  group("QuotationFormProvider.createQuotationOnly -", () {
    test('Should create quotation successfully', () async {
      when(() => mockSessionService.callKwWithCompany(any()))
          .thenAnswer((_) async => 1);
      when(() => mockSessionService.callKwWithCompanyDynamic(any()))
          .thenAnswer((_) async => [
                {'name': 'Quotation/001'}
              ]);

      provider.formatDateQuotation.text = '2026-02-25 12:00:00';
      provider.orderpersonValue = 1;
      provider.imageBase64 = "dummy_image_base64";
      provider.signedByController.text = "Dummy Signer";
      provider.formatDateSignature.text = "2026-02-25 12:00:00";
      provider.formatDateDelivery.text = "2026-02-26 12:00:00";
      provider.onlineSignature = true;
      provider.onlinePayment = true;
      provider.referenceController.text = "REF001";
      provider.documentController.text = "Origin Document";
      provider.selectedcampaignId = Campaign(id: 1, name: 'Demo');
      provider.selectedMediumId = Medium(id: 1, name: 'Demo');
      provider.selectedSourceId = Source(id: 1, name: 'Demo');
      provider.selectedTagIds = [1, 2, 3];
      provider.formatDateexpire.text = "2026-03-25 12:00:00";
      provider.selectedPaymentTermId = PaymentTerm(id: 1, name: '15 days');
      provider.productlinedata = [
        ProductLine(
          id: 1,
          product: "Product 1",
          type: null,
          description: "Product Description",
          quantity: 2,
          unitPrice: 100.0,
          taxIds: [1, 2],
          amount: 1000,
        ),
      ];
      provider.isSaleInstalled = true;

      final result = await provider.createQuotationOnly(
        buildProvider,
        viewProvider,
        mockOdooClient,
        1,
        1,
        SessionModel(userId: 1, companyId: 1, sessionId: 'a1b2'),
        mockBuildContext,
      );

      expect(result, true);

      verify(() => mockSessionService.callKwWithCompany(any())).called(1);
      verify(() => mockSessionService.callKwWithCompanyDynamic(any()))
          .called(1);
    });

    test('Should create quotation fails', () async {
      when(() => mockSessionService.callKwWithCompany(any()))
          .thenAnswer((_) async => 1);
      when(() => mockSessionService.callKwWithCompanyDynamic(any()))
          .thenAnswer((_) async => []);

      provider.formatDateQuotation.text = '2026-02-25 12:00:00';
      provider.orderpersonValue = 1;
      provider.imageBase64 = "dummy_image_base64";
      provider.signedByController.text = "Dummy Signer";
      provider.formatDateSignature.text = "2026-02-25 12:00:00";
      provider.formatDateDelivery.text = "2026-02-26 12:00:00";
      provider.onlineSignature = true;
      provider.onlinePayment = true;
      provider.referenceController.text = "REF001";
      provider.documentController.text = "Origin Document";
      provider.selectedcampaignId = Campaign(id: 1, name: 'Demo');
      provider.selectedMediumId = Medium(id: 1, name: 'Demo');
      provider.selectedSourceId = Source(id: 1, name: 'Demo');
      provider.selectedTagIds = [1, 2, 3];
      provider.formatDateexpire.text = "2026-03-25 12:00:00";
      provider.selectedPaymentTermId = PaymentTerm(id: 1, name: '15 days');
      provider.productlinedata = [
        ProductLine(
          id: 1,
          product: "Product 1",
          type: null,
          description: "Product Description",
          quantity: 2,
          unitPrice: 100.0,
          taxIds: [1, 2],
          amount: 1000,
        ),
      ];
      provider.isSaleInstalled = true;

      final result = await provider.createQuotationOnly(
        buildProvider,
        viewProvider,
        mockOdooClient,
        1,
        1,
        SessionModel(userId: 1, companyId: 1, sessionId: 'a1b2'),
        mockBuildContext,
      );

      expect(result, false);

      verify(() => mockSessionService.callKwWithCompany(any())).called(1);
    });

    test('Should return false when exception is thrown', () async {
      when(() => mockSessionService.callKwWithCompany(any()))
          .thenThrow(Exception('API Failed'));

      provider.formatDateQuotation.text = '2026-02-25 12:00:00';
      provider.productlinedata = [
        ProductLine(
          id: 1,
          product: "Product 1",
          type: null,
          description: "Product Description",
          quantity: 2,
          unitPrice: 100.0,
          taxIds: [1, 2],
          amount: 1000,
        ),
      ];

      final result = await provider.createQuotationOnly(
        buildProvider,
        viewProvider,
        mockOdooClient,
        1,
        1,
        SessionModel(userId: 1, companyId: 1, sessionId: 'a1b2'),
        mockBuildContext,
      );

      expect(result, false);
      verify(() => mockSessionService.callKwWithCompany(any())).called(1);
    });
  });

  /// ----------------------------
  /// Tests for updateQuotation
  /// ----------------------------
  group("QuotationFormProvider.updateQuotation -", () {
    test('Should update quotation successfully', () async {
      when(() => mockSessionService.callKwWithCompanyDynamic(any()))
          .thenAnswer((_) async => [
                {
                  'id': 1,
                  'product_id': 1,
                  'name': 'Product 1',
                  'display_type': null,
                  'tax_ids': [1, 2],
                }
              ]);

      when(() => mockSessionService.callKwWithCompanyUpdate(any()))
          .thenAnswer((_) async => true);

      provider.formatDateQuotation.text = '2026-02-25 12:00:00';
      provider.orderpersonValue = 1;
      provider.imageBase64 = "dummy_image_base64";
      provider.signedByController.text = "Dummy Signer";
      provider.formatDateSignature.text = "2026-02-25 12:00:00";
      provider.formatDateDelivery.text = "2026-02-26 12:00:00";
      provider.onlineSignature = true;
      provider.onlinePayment = true;
      provider.referenceController.text = "REF001";
      provider.documentController.text = "Origin Document";
      provider.selectedcampaignId = Campaign(id: 1, name: 'Demo');
      provider.selectedMediumId = Medium(id: 1, name: 'Demo');
      provider.selectedSourceId = Source(id: 1, name: 'Demo');
      provider.selectedTagIds = [1, 2, 3];
      provider.formatDateexpire.text = "2026-03-25 12:00:00";
      provider.selectedPaymentTermId = PaymentTerm(id: 1, name: '15 days');
      provider.productlinedata = [
        ProductLine(
          id: 1,
          product: "Product 1",
          type: null,
          description: "Product Description",
          quantity: 2,
          unitPrice: 100.0,
          taxIds: [1, 2],
          amount: 1000,
        ),
      ];
      provider.isSaleInstalled = true;

      final result = await provider.updateQuotation(
        buildProvider,
        mockOdooClient,
        1,
        mockBuildContext,
        1,
        1,
        SessionModel(userId: 1, companyId: 1, sessionId: 'a1b2'),
        isQuote: true,
      );

      expect(result, true);

      verify(() => mockSessionService.callKwWithCompanyUpdate(
        any(
          that: predicate<Map<String, dynamic>>(
                (map) =>
            map['model'] == 'sale.order' &&
                map['method'] == 'write',
          ),
        ),
      ));
    });

    test('Should return false when exception is thrown', () async {
      when(() => mockSessionService.callKwWithCompanyDynamic(any()))
          .thenThrow(Exception("Network Error"));

      provider.formatDateQuotation.text = '2026-02-25 12:00:00';
      provider.orderpersonValue = 1;
      provider.imageBase64 = "dummy_image_base64";
      provider.signedByController.text = "Dummy Signer";
      provider.formatDateSignature.text = "2026-02-25 12:00:00";
      provider.formatDateDelivery.text = "2026-02-26 12:00:00";
      provider.onlineSignature = true;
      provider.onlinePayment = true;
      provider.referenceController.text = "REF001";
      provider.documentController.text = "Origin Document";
      provider.selectedcampaignId = Campaign(id: 1, name: 'Demo');
      provider.selectedMediumId = Medium(id: 1, name: 'Demo');
      provider.selectedSourceId = Source(id: 1, name: 'Demo');
      provider.selectedTagIds = [1, 2, 3];
      provider.formatDateexpire.text = "2026-03-25 12:00:00";
      provider.selectedPaymentTermId = PaymentTerm(id: 1, name: '15 days');
      provider.productlinedata = [
        ProductLine(
          id: 1,
          product: "Product 1",
          type: null,
          description: "Product Description",
          quantity: 2,
          unitPrice: 100.0,
          taxIds: [1, 2],
          amount: 1000,
          orderlineId: 1,
        ),
      ];
      provider.isSaleInstalled = true;

      final result = await provider.updateQuotation(
        buildProvider,
        mockOdooClient,
        1,
        mockBuildContext,
        1,
        1,
        SessionModel(userId: 1, companyId: 1, sessionId: 'a1b2'),
        isQuote: true,
      );

      expect(result, false);
    });
  });
}
