import 'package:carrental/app/core/utils/app_logger.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../app/features/data/models/promo_code_model/promo_code_model.dart';
import '../../app/features/data/services/api_service.dart';

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
          final promoCodes = data.map((json) => PromoCode.fromJson(json)).toList();

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
        AppLogger.d('❌ Error fetching promo codes: $e');
      }
      rethrow;
    }
  }

  void _printPromoCodesToTerminal(List<PromoCode> promoCodes) {
    AppLogger.d('\n${'=' * 60}');
    AppLogger.d('🎟️  ACTIVE PROMO CODES');
    AppLogger.d('=' * 60);
    AppLogger.d('Total Active Codes: ${promoCodes.length}\n');

    if (promoCodes.isEmpty) {
      AppLogger.d('No active promo codes found.');
    } else {
      for (var promo in promoCodes) {
        AppLogger.d(promo.toString());
      }
    }

    AppLogger.d('\n${'=' * 60}');
    AppLogger.d('📊 SUMMARY');
    AppLogger.d('=' * 60);
    
    final percentageCodes = promoCodes.where((p) => p.type == 'percentage').length;
    final fixedCodes = promoCodes.where((p) => p.type == 'fixed').length;
    final unlimitedCodes = promoCodes.where((p) => p.usageLimit == null).length;
    final expiredSoon = promoCodes.where((p) => 
      p.validUntil != null && 
      p.validUntil!.difference(DateTime.now()).inDays <= 7
    ).length;

    AppLogger.d('Percentage Discounts: $percentageCodes');
    AppLogger.d('Fixed Amount Discounts: $fixedCodes');
    AppLogger.d('Unlimited Usage: $unlimitedCodes');
    AppLogger.d('Expiring in 7 days: $expiredSoon');
    AppLogger.d('=' * 60 + '\n');
  }                                                                                                                           
}