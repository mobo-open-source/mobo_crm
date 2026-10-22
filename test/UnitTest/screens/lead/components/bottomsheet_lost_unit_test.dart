import 'package:flutter_test/flutter_test.dart';
import 'package:mobo_crm/screens/lead/components/services/lost_reason_service.dart';

/// Unit tests for the Bottom Sheet "Lost Reason" functionality.
///
/// These tests focus on pure logic of `unitCreateLostReason` and `unitMarkLeadAsLost`
/// without relying on actual API calls or UI components.
void main() {
  group('BottomSheet Lost – Pure Unit Tests', () {
    /// Test that [unitCreateLostReason] creates a lost reason correctly
    /// when the reason already exists in the system.
    test('unitCreateLostReason returns true when created reason exists',
        () async {
      bool createCalled = false;

      /// A fake API caller to simulate Odoo RPC behavior
      Future<dynamic> fakeCaller(Map<String, dynamic> params) async {
        if (params['method'] == 'create') {
          createCalled = true;
          return 1;
        }

        if (params['method'] == 'search_read') {
          return [
            {'id': 1, 'name': 'Too Expensive'}
          ];
        }

        return null;
      }

      final result = await unitCreateLostReason(fakeCaller, 'Too Expensive');

      expect(createCalled, true);
      expect(result, true);
    });

    /// Test that [unitMarkLeadAsLost] returns true when a lost reason is successfully applied
    test('unitMarkLeadAsLost returns true on success', () async {
      Future<dynamic> fakeCaller(Map<String, dynamic> params) async {
        if (params['method'] == 'create') return 10;
        if (params['method'] == 'action_lost_reason_apply') return true;
        return null;
      }

      final result = await unitMarkLeadAsLost(fakeCaller, 5, 2);

      expect(result, true);
    });

    /// Test that [unitMarkLeadAsLost] returns false when no lost reason is selected
    test('unitMarkLeadAsLost returns false when no reason selected', () async {
      Future<dynamic> fakeCaller(Map<String, dynamic> params) async => null;

      final result = await unitMarkLeadAsLost(fakeCaller, 5, null);

      expect(result, false);
    });
  });
}
