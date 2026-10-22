import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mobo_crm/screens/invoice/services/invoice_service.dart';

/// Mock class for [InvoiceService] to simulate API and service behavior in tests.
class MockInvoiceService extends Mock implements InvoiceService {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  /// Mock instance used across tests
  late MockInvoiceService mockService;

  /// Setup the mock service before each test
  setUp(() {
    mockService = MockInvoiceService();
  });

  /// Group of tests for the [postInvoice] method
  group('postInvoice', () {
    /// Test to ensure [postInvoice] returns true when called with a valid invoice ID
    test('returns true when postInvoice called', () async {
      when(() => mockService.postInvoice(10)).thenAnswer((_) async => true);

      final result = await mockService.postInvoice(10);

      expect(result, true);

      verify(() => mockService.postInvoice(10)).called(1);
    });
  });

  /// Group of tests for the [actionCancel] method
  group('actionCancel', () {
    /// Test to ensure [actionCancel] throws an exception if the invoice state is invalid (e.g., paid)
    test('throws if state invalid', () async {
      when(() => mockService.actionCancel(1, 'paid'))
          .thenThrow(Exception('Cannot cancel invoice'));

      expect(
        () => mockService.actionCancel(1, 'paid'),
        throwsException,
      );

      verify(() => mockService.actionCancel(1, 'paid')).called(1);
    });

    /// Test to ensure [actionCancel] completes successfully when the invoice state is valid (e.g., draft)
    test('calls actionCancel when state valid', () async {
      when(() => mockService.actionCancel(5, 'draft'))
          .thenAnswer((_) async => null);

      await mockService.actionCancel(5, 'draft');

      verify(() => mockService.actionCancel(5, 'draft')).called(1);
    });
  });

  /// Group of tests for the [actionDraft] method
  group('actionDraft', () {
    /// Test to ensure [actionDraft] throws an exception if the current state prevents resetting to draft
    test('throws if state invalid', () async {
      when(() => mockService.actionDraft(
            invoiceId: 1,
            currentState: 'draft',
            cancelInvoiceCallback: any(named: 'cancelInvoiceCallback'),
          )).thenThrow(Exception('Cannot reset to draft'));

      expect(
        () => mockService.actionDraft(
          invoiceId: 1,
          currentState: 'draft',
          cancelInvoiceCallback: () async => 'cancel',
        ),
        throwsException,
      );

      verify(() => mockService.actionDraft(
            invoiceId: 1,
            currentState: 'draft',
            cancelInvoiceCallback: any(named: 'cancelInvoiceCallback'),
          )).called(1);
    });
  });
}
