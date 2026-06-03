import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../app/features/data/models/promo_code_model/promo_code_model.dart';
import '../../app/features/data/services/api_service.dart';
import '../../app/core/utils/logger.dart';

class PromoCodeRepository {
  final ApiService _apiService = Get.find<ApiService>();
  final GetStorage _storage = GetStorage();

  Future<List<PromoCode>> getActivePromoCodes({
    DateTime? at,
    bool printToTerminal = true,
  }) async {
    try {
      // Get token from storage (same way login saves it)
      final token = _storage.read('auth_token');

      if (token == null || token.isEmpty) {
        throw Exception('No authentication token found. Please login.');
      }

      Map<String, String>? queryParams;
      Map<String, String> headers = {
        'Authorization': 'Bearer $token',
        'accept': '*/*',
      };

      if (at != null) {
        queryParams = {'at': at.toUtc().toIso8601String()};
      }

      final response = await _apiService.get<List<dynamic>>(
        '/api/v1/promo-codes/active',
        queryParams: queryParams,
        headers: headers,
      );

      if (response.success) {
        final List<dynamic>? data = response.data;

        if (data != null) {
          final promoCodes =
              data.map((json) => PromoCode.fromJson(json)).toList();

          if (printToTerminal) {
            _printPromoCodesToTerminal(promoCodes);
          }

          return promoCodes;
        } else {
          throw Exception('No data received from API');
        }
      } else {
        throw Exception('Failed to load promo codes: ${response.message}');
      }
    } catch (e) {
      if (printToTerminal) {
        Log.info('❌ Error fetching promo codes: $e');
      }
      rethrow;
    }
  }

  void _printPromoCodesToTerminal(List<PromoCode> promoCodes) {
    Log.info('\n${'=' * 60}');
    Log.info('🎟️  ACTIVE PROMO CODES');
    Log.info('=' * 60);
    Log.info('Total Active Codes: ${promoCodes.length}\n');

    if (promoCodes.isEmpty) {
      Log.info('No active promo codes found.');
    } else {
      for (var promo in promoCodes) {
        Log.info(promo.toString());
      }
    }

    Log.info('\n${'=' * 60}');
    Log.info('📊 SUMMARY');
    Log.info('=' * 60);

    final percentageCodes =
        promoCodes.where((p) => p.type == 'percentage').length;
    final fixedCodes = promoCodes.where((p) => p.type == 'fixed').length;
    final unlimitedCodes = promoCodes.where((p) => p.usageLimit == null).length;
    final expiredSoon = promoCodes
        .where((p) =>
            p.validUntil != null &&
            p.validUntil!.difference(DateTime.now()).inDays <= 7)
        .length;

    Log.info('Percentage Discounts: $percentageCodes');
    Log.info('Fixed Amount Discounts: $fixedCodes');
    Log.info('Unlimited Usage: $unlimitedCodes');
    Log.info('Expiring in 7 days: $expiredSoon');
    Log.info('=' * 60 + '\n');
  }
}
