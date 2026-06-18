import 'package:carrental/app/features/data/models/rate_plan/rate_plan_response.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('RatePlanResponse.fromJson — real backend shape', () {
    // A trimmed sample of the live /api/v1/rate-plans `data` array, including
    // the Mongo shapes that previously crashed parsing.
    final dataArray = [
      {
        '_id': '6a265a84bbdc75f0f0010a77',
        'name': 'Truck Class 2026',
        'vehicle_class': 'truck',
        'vehicle_model_id': null,
        'vehicle_id': null,
        'active': true,
        'branch_id': null,
        'currency': 'USD',
        'daily_rate': {r'$numberDecimal': '90.00'},
        'weekly_rate': {r'$numberDecimal': '560.00'},
        'monthly_rate': {r'$numberDecimal': '1900.00'},
        'createdAt': '2026-06-08T06:00:36.622Z',
        'updatedAt': '2026-06-08T06:00:36.622Z',
        'valid_from': '2026-01-01T00:00:00.000Z',
        'valid_to': null,
      },
      {
        '_id': '6a25dfdbe15c63cf137990e6',
        'name': 'HRE Compact 2025',
        'vehicle_class': 'compact',
        'branch_id': {'_id': '69cc0287ff2b26f5c24d8af7', 'name': 'Mutare Branch'},
        'vehicle_model_id': {'_id': '692afbeb8550dfebd86fd971', 'make': 'BMW'},
        'currency': 'USD',
        'daily_rate': {r'$numberDecimal': '50.00'},
        'weekly_rate': {r'$numberDecimal': '30.00'},
        'monthly_rate': {r'$numberDecimal': '100.00'},
        'active': true,
        'valid_from': '2026-01-01T00:00:00.000Z',
      },
    ];

    test('parses a bare array payload without crashing', () {
      final res = RatePlanResponse.fromJson(dataArray);
      expect(res.plans.length, 2);
    });

    test('parses Mongo \$numberDecimal rates into doubles', () {
      final res = RatePlanResponse.fromJson(dataArray);
      expect(res.plans.first.dailyRate, 90.0);
      expect(res.plans.first.monthlyRate, 1900.0);
    });

    test('extracts populated branch_id object as a name', () {
      final res = RatePlanResponse.fromJson(dataArray);
      expect(res.plans[1].branchId, 'Mutare Branch');
    });

    test('reads the `active` flag', () {
      final res = RatePlanResponse.fromJson(dataArray);
      expect(res.plans.first.isActive, isTrue);
    });

    test('handles null valid_to / branch_id gracefully', () {
      final res = RatePlanResponse.fromJson(dataArray);
      expect(res.plans.first.branchId, '');
      expect(res.plans.first.validTo, isA<DateTime>());
    });
  });
}
