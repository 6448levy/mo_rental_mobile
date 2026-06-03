import 'package:get/get.dart';
import '../../../../app/core/utils/logger.dart';
import '../models/auth_models/api_response.dart';
import '../models/promo_code_model/promo_code_model.dart';
import 'api_service.dart';
import '../../../core/constants/api_constants.dart';

class PromoCodeService extends GetxService {
  final ApiService _apiService = Get.find<ApiService>();

  // ---------------------------------------------------------------------------
  // GET PROMO CODE BY ID (GET /api/v1/promo-codes/:id)
  // ---------------------------------------------------------------------------
  Future<ApiResponse<PromoCode>> getPromoCodeById(String id) async {
    Log.info('\n🎟️ FETCHING PROMO CODE DETAILS: $id');
    return await _apiService.get<PromoCode>(
      '${ApiConstants.PROMO_CODES}/$id',
      fromJson: (json) => PromoCode.fromJson(json),
    );
  }

  // ---------------------------------------------------------------------------
  // VALIDATE PROMO CODE (POST /api/v1/promo-codes/validate)
  // ---------------------------------------------------------------------------
  Future<ApiResponse<PromoCodeValidationResult>> validatePromoCode({
    required String code,
    required double baseAmount,
    String? vehicleId,
    String? branchId,
    String? vehicleClass,
    int? days,
  }) async {
    Log.info('\n🎟️ VALIDATING PROMO CODE: $code');
    
    final payload = {
      'code': code,
      'base_amount': baseAmount,
      if (vehicleId != null) 'vehicle_id': vehicleId,
      if (branchId != null) 'branch_id': branchId,
      if (vehicleClass != null) 'vehicle_class': vehicleClass,
      if (days != null) 'days': days,
    };

    return await _apiService.post<PromoCodeValidationResult>(
      '${ApiConstants.PROMO_CODES}/validate',
      payload,
      fromJson: (json) => PromoCodeValidationResult.fromJson(json),
    );
  }
}
