import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mobo_crm/services/network_service.dart';

/// Mock class to simulate the NetworkService dependency
class MockNetworkService extends Mock implements NetworkService {}

void main() {
  late MockNetworkService mockNetworkService;

  /// Initialize the mock before each test
  setUp(() {
    mockNetworkService = MockNetworkService();
  });

  /// Group of tests for `NetworkService.fetchDatabaseList`
  group("NetworkService.fetchDatabaseList - ", () {
    /// Test that a successful server response returns a list of database names
    test(
      'should return a list of database names when the server responds successfully',
      () async {
        when(
          () => mockNetworkService.fetchDatabaseList(any()),
        ).thenAnswer((_) async => ['db1', 'db2']);

        final result = await mockNetworkService.fetchDatabaseList(
          'https://demo.odoo.com',
        );

        expect(result, isA<List<String>>());
      },
    );

    /// Test that an empty server response returns an empty list
    test(
      'should return an empty list when the server responds with no databases',
      () async {
        when(
          () => mockNetworkService.fetchDatabaseList(any()),
        ).thenAnswer((_) async => []);

        final result = await mockNetworkService.fetchDatabaseList(
          'https://demo.odoo.com',
        );

        expect(result, isEmpty);
      },
    );

    /// Test that an exception is thrown when the server returns an error
    test(
      'should throw an exception when the server responds with an error',
      () async {
        when(
          () => mockNetworkService.fetchDatabaseList(any()),
        ).thenThrow(Exception("Internal Server Error"));

        expect(
          () => mockNetworkService.fetchDatabaseList('https://demo.odoo.com'),
          throwsException,
        );
      },
    );
  });
}
