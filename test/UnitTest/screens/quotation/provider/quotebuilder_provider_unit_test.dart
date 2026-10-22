import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mobo_crm/core/company/services/company_session_service.dart';
import 'package:mobo_crm/screens/quotation/provider/quotebuilder_provider.dart';
import 'package:odoo_rpc/odoo_rpc.dart';

class MockCompanySessionService extends Mock implements CompanySessionService {}

class MockOdooClient extends Mock implements OdooClient {}

class FakeBuildContext extends Fake implements BuildContext {}

void main() {
  late QuoteBuilderProvider provider;
  late MockCompanySessionService mockService;
  late MockOdooClient mockClient;
  late BuildContext mockContext;

  setUp(() {
    mockService = MockCompanySessionService();
    mockClient = MockOdooClient();
    provider = QuoteBuilderProvider(sessionService: mockService);
    mockContext = FakeBuildContext();
  });

  group('QuoteBuilderProvider', () {
    final saleOrderId = 1;

    final pdfResponse = {
      "headers": {
        "files": [
          {
            "id": 10,
            "name": "Header 1",
            "is_selected": true,
            "custom_form_fields": [
              {"name": "field1"}
            ]
          }
        ]
      },
      "footers": {
        "files": [
          {
            "id": 20,
            "name": "Footer 1",
            "is_selected": false,
            "custom_form_fields": [
              {"name": "field2"}
            ]
          }
        ]
      },
      "lines": [
        {
          "id": 100,
          "files": [
            {
              "id": 1000,
              "name": "Line PDF 1",
              "is_selected": true,
              "custom_form_fields": [
                {"name": "lineField"}
              ]
            }
          ]
        }
      ]
    };

    test('fetchPDFData fetches and sets PDF data correctly', () async {
      when(() => mockService.callKwWithCompanyDynamic(any())).thenAnswer(
        (_) async => pdfResponse,
      );

      when(() => mockService.callKwWithCompanyUpdate(any()))
          .thenAnswer((_) async => true);

      final result =
          await provider.fetchPDFData(saleOrderId, mockClient, mockContext);

      expect(result, true);
      expect(provider.pdfData['headers']['files'].length, 1);
      expect(provider.selectedHeaderIds.contains(10), true);
      expect(provider.selectedFooterIds.isEmpty, true);
      expect(provider.selectedProductDocs.containsKey(100), true);
      expect(provider.selectedProductDocs[100]!.contains(1000), true);

      expect(provider.isLoading, false);
    });

    test('saveIncludedPDF calls session service methods and updates JSON data',
        () async {
      provider.pdfData.addAll(pdfResponse);
      provider.selectedHeaderIds.add(10);
      provider.selectedFooterIds.add(20);
      provider.selectedProductDocs[100] = {1000};

      when(() => mockService.callKwWithCompanyUpdate(any()))
          .thenAnswer((_) async => true);
      when(() => mockService.callKwWithCompanyDynamic(any()))
          .thenAnswer((_) async => pdfResponse);

      await provider.saveIncludedPDF(saleOrderId, mockClient, mockContext);

      verify(() => mockService.callKwWithCompanyDynamic(any())).called(1);
      verify(() => mockService.callKwWithCompanyUpdate(any()))
          .called(greaterThan(0));

      expect(provider.isLoading, false);
    });
  });
}
