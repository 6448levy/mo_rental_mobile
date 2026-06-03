import 'package:get/get.dart';
import '../../../../app/core/utils/logger.dart';
import '../models/auth_models/api_response.dart';
import '../models/fleet/vehicle_model.dart' as fleet;
import 'api_service.dart';
import '../../../core/constants/api_constants.dart';

class FleetService extends GetxService {
  final ApiService _apiService = Get.find<ApiService>();

  // ---------------------------------------------------------------------------
  // VEHICLE MODELS (/api/v1/vehicle-models)
  // ---------------------------------------------------------------------------

  Future<ApiResponse<List<fleet.VehicleModel>>> getVehicleModels() async {
    Log.info('\n🚗 FETCHING VEHICLE MODELS');
    return await _apiService.get<List<fleet.VehicleModel>>(
      ApiConstants.VEHICLE_MODELS,
      fromJson: (json) {
        final List<dynamic> data = json is List ? json : (json['data'] ?? []);
        return data.map((e) => fleet.VehicleModel.fromJson(e)).toList();
      },
    );
  }

  Future<ApiResponse<fleet.VehicleModel>> getVehicleModelById(String id) async {
    Log.info('\n🚗 FETCHING VEHICLE MODEL: $id');
    return await _apiService.get<fleet.VehicleModel>(
      '${ApiConstants.VEHICLE_MODELS}/$id',
      fromJson: (json) => fleet.VehicleModel.fromJson(json),
    );
  }

  // ---------------------------------------------------------------------------
  // VEHICLES (/api/v1/vehicles)
  // ---------------------------------------------------------------------------

  Future<ApiResponse<List<fleet.Vehicle>>> getVehicles({String? modelId, String? branchId}) async {
    Log.info('\n🚗 FETCHING VEHICLES');
    
    final queryParams = <String, String>{};
    if (modelId != null) queryParams['model_id'] = modelId;
    if (branchId != null) queryParams['branch_id'] = branchId;

    final queryString = queryParams.isNotEmpty 
        ? '?' + queryParams.entries.map((e) => '${e.key}=${e.value}').join('&')
        : '';

    return await _apiService.get<List<fleet.Vehicle>>(
      '${ApiConstants.VEHICLES}$queryString',
      fromJson: (json) {
        final List<dynamic> data = json is List ? json : (json['data'] ?? []);
        return data.map((e) => fleet.Vehicle.fromJson(e)).toList();
      },
    );
  }

  Future<ApiResponse<fleet.Vehicle>> getVehicleById(String id) async {
    Log.info('\n🚗 FETCHING VEHICLE: $id');
    return await _apiService.get<fleet.Vehicle>(
      '${ApiConstants.VEHICLES}/$id',
      fromJson: (json) => fleet.Vehicle.fromJson(json),
    );
  }
}
