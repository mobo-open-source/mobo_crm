import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mobo_crm/core/company/services/company_session_service.dart';
import 'package:mobo_crm/screens/opportunity/providers/opportunity_data_provider.dart';

/// Mock class to simulate the CompanySessionService dependency
class MockSessionService extends Mock implements CompanySessionService {}

/// Mock class to simulate a BuildContext dependency
class MockBuildContext extends Mock implements BuildContext {}

/// A fake search count function for delete stage tests
Future<int> mockSearchCount(int stageId) async => 0;

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late MockSessionService mockSessionService;
  late MockBuildContext mockBuildContext;
  late OpportunityDataProvider provider;

  setUp(() {
    mockBuildContext = MockBuildContext();
    when(() => mockBuildContext.mounted).thenReturn(true);
    mockSessionService = MockSessionService();
    provider = OpportunityDataProvider(sessionService: mockSessionService);
  });

  /// Group of tests for updating opportunity stages
  group("OpportunityDataProvider.updateOpportunityStage -", () {
    test('Should update opportunity stage successfully', () async {
      when(() => mockSessionService.callKwWithCompanyUpdate(any()))
          .thenAnswer((_) async => true);

      final result = await provider.updateOpportunityStage(
        context: mockBuildContext,
        opportunityId: 1,
        newStageId: 1,
        newStageName: 'Qualified',
      );
      expect(result, true);

      verify(() => mockSessionService.callKwWithCompanyUpdate(any())).called(1);
    });

    test('Should return false when API fails', () async {
      when(() => mockSessionService.callKwWithCompanyUpdate(any()))
          .thenThrow(Exception('API Error'));

      final result = await provider.updateOpportunityStage(
        context: mockBuildContext,
        opportunityId: 1,
        newStageId: 1,
        newStageName: 'Qualified',
      );

      expect(result, false);
    });
  });

  /// Group of tests for creating CRM stages
  group("OpportunityDataProvider.createCrmStage -", () {
    test('Should create crm stage successfully', () async {
      when(() => mockSessionService.callKwWithCompanyDynamic(any()))
          .thenAnswer((_) async => [
                {'sequence': 10}
              ]);
      when(() => mockSessionService.callKwWithCompany(any()))
          .thenAnswer((_) async => 1);

      final result = await provider.createCrmStage(
        context: mockBuildContext,
        stageName: 'Qualified',
      );
      expect(result, true);

      verify(() => mockSessionService.callKwWithCompanyDynamic(any()))
          .called(1);
      verify(() => mockSessionService.callKwWithCompany(any())).called(1);
    });

    test('Should return false when API fails', () async {
      when(() => mockSessionService.callKwWithCompanyDynamic(any()))
          .thenAnswer((_) async => []);
      when(() => mockSessionService.callKwWithCompany(any()))
          .thenAnswer((_) => Future.error(Exception('API Error')));

      final result = await provider.createCrmStage(
        context: mockBuildContext,
        stageName: 'Qualified',
      );

      expect(result, false);
    });
  });

  /// Group of tests for updating CRM stages
  group("OpportunityDataProvider.updateCrmStage -", () {
    test('Should update crm stage successfully', () async {
      when(() => mockSessionService.callKwWithCompanyUpdate(any()))
          .thenAnswer((_) async => true);

      final result = await provider.updateCrmStage(
        context: mockBuildContext,
        stageId: 1,
        stageName: 'Qualified',
      );
      expect(result, true);

      verify(() => mockSessionService.callKwWithCompanyUpdate(any())).called(1);
    });

    test('Should return false when API fails', () async {
      when(() => mockSessionService.callKwWithCompanyUpdate(any()))
          .thenThrow(Exception('API Error'));

      final result = await provider.updateCrmStage(
        context: mockBuildContext,
        stageId: 1,
        stageName: 'Qualified',
      );

      expect(result, false);
    });
  });

  /// Group of tests for deleting CRM stages
  group("OpportunityDataProvider.deleteCrmStage -", () {
    test('deleteCrmStage returns true when stage is empty', () async {
      final provider =
          OpportunityDataProvider(sessionService: mockSessionService);

      Future<int> mockSearchCount(int stageId) async => 0;
      when(() => mockSessionService.callKwWithCompanyUpdate(any()))
          .thenAnswer((_) async => true);

      final result = await provider.deleteCrmStage(
        context: mockBuildContext,
        searchCountFn: mockSearchCount,
        stageId: 1,
        stageName: 'Qualified',
      );

      expect(result, true);
      verify(() => mockSessionService.callKwWithCompanyUpdate(any())).called(1);
    });

    test('deleteCrmStage returns false when stage has opportunities', () async {
      final provider =
          OpportunityDataProvider(sessionService: mockSessionService);

      Future<int> mockSearchCount(int stageId) async => 5;

      final result = await provider.deleteCrmStage(
        context: mockBuildContext,
        searchCountFn: mockSearchCount,
        stageId: 1,
        stageName: 'Qualified',
      );

      expect(result, false);
    });

    test('Should return false when API fails', () async {
      when(() => mockSessionService.callKwWithCompanyUpdate(any()))
          .thenThrow(Exception('API Error'));

      final result = await provider.deleteCrmStage(
        context: mockBuildContext,
        searchCountFn: mockSearchCount,
        stageId: 1,
        stageName: 'Qualified',
      );

      expect(result, false);
    });
  });
}
