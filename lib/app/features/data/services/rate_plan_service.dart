import 'package:get/get.dart';
import '../../../../app/core/utils/logger.dart';
import '../models/auth_models/api_response.dart';
import '../models/rate_plan/rate_plan_request.dart';
import '../models/rate_plan/rate_plan_response.dart';
import 'api_service.dart';

class RatePlanService extends GetxService {
  final ApiService _apiService = Get.find<ApiService>();

  Future<ApiResponse<RatePlanResponse>> getRatePlans({
    required String token,
    RatePlanRequest? request,
  }) async {
    Log.info('📊 RATE PLANS REQUEST');
    Log.info('🔑 Token: ${token.substring(0, 20)}...');
    Log.info('📋 Query Params: ${request?.toQueryParams()}');

    final headers = {
      'Authorization': 'Bearer $token',
      'Accept': 'application/json',
    };

    final queryParams = request?.toQueryParams() ?? {};
    final endpoint = '/api/v1/rate-plans';

    return await _apiService.get<RatePlanResponse>(
      endpoint,
      headers: headers,
      fromJson: (data) => RatePlanResponse.fromJson(data),
      queryParams: queryParams,
    );
  }

  // Add other methods for POST, PUT, DELETE as needed
  Future<ApiResponse<RatePlan>> createRatePlan({
    required String token,
    required Map<String, dynamic> data,
  }) async {
    Log.info('➕ CREATE RATE PLAN');
    Log.info('📊 Data: $data');

    final headers = {
      'Authorization': 'Bearer $token',
      'Accept': 'application/json',
    };

    return await _apiService.post<RatePlan>(
      '/api/v1/rate-plans',
      data,
      headers: headers,
      fromJson: (data) => RatePlan.fromJson(data),
    );
  }

  Future<ApiResponse<RatePlan>> updateRatePlan({
    required String token,
    required String planId,
    required Map<String, dynamic> data,
  }) async {
    Log.info('✏️ UPDATE RATE PLAN: $planId');
    Log.info('📊 Data: $data');

    final headers = {
      'Authorization': 'Bearer $token',
      'Accept': 'application/json',
    };

    return await _apiService.put<RatePlan>(
      '/api/v1/rate-plans/$planId',
      data,
      headers: headers,
      fromJson: (data) => RatePlan.fromJson(data),
    );
  }

  Future<ApiResponse<void>> deleteRatePlan({
    required String token,
    required String planId,
  }) async {
    Log.info('🗑️ DELETE RATE PLAN: $planId');

    final headers = {
      'Authorization': 'Bearer $token',
      'Accept': 'application/json',
    };

    return await _apiService.delete(
      '/api/v1/rate-plans/$planId',
      headers: headers,
    );
  }
}
