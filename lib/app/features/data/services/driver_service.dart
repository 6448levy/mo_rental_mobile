import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../../../../app/core/utils/logger.dart';
import '../models/auth_models/api_response.dart';
import '../models/driver/driver_profile_model.dart';
import 'api_service.dart';
import '../../../core/constants/api_constants.dart';

class DriverService extends GetxService {
  final ApiService _apiService = Get.find<ApiService>();

  // ---------------------------------------------------------------------------
  // PUBLIC: Fetch all approved driver profiles (no auth required)
  // GET /api/v1/driver-profiles/public
  // ---------------------------------------------------------------------------
  Future<ApiResponse<List<DriverProfileModel>>> getPublicDriverProfiles() async {
    Log.info('\n🚗 FETCHING PUBLIC DRIVER PROFILES');
    return await _apiService.get<List<DriverProfileModel>>(
      '/api/v1/profiles',
      queryParams: {'role': 'driver'},
      fromJson: (json) {
        final List<dynamic> data = json is List ? json : (json['data'] ?? []);
        return data.map((e) => DriverProfileModel.fromJson(e)).toList();
      },
    );
  }

  // ---------------------------------------------------------------------------
  // AUTHENTICATED: Fetch a single driver profile by ID
  // GET /api/v1/driver-profiles/:id
  // ---------------------------------------------------------------------------
  Future<ApiResponse<DriverProfileModel>> getDriverProfileById({
    required String profileId,
  }) async {
    Log.info('\n🚗 FETCHING DRIVER PROFILE: $profileId');

    return await _apiService.get<DriverProfileModel>(
      '/api/v1/profiles/$profileId',
      fromJson: (data) => DriverProfileModel.fromJson(data),
    );
  }

  // ---------------------------------------------------------------------------
  // AUTHENTICATED: Fetch MY driver profile (logged-in driver)
  // GET /api/v1/driver-profiles/me  (common pattern)
  // ---------------------------------------------------------------------------
  Future<ApiResponse<DriverProfileModel>> getMyDriverProfile() async {
    Log.info('\n🚗 FETCHING MY DRIVER PROFILE');

    return await _apiService.get<DriverProfileModel>(
      '/api/v1/profiles/me/driver',
      fromJson: (data) => DriverProfileModel.fromJson(data),
    );
  }

  // ---------------------------------------------------------------------------
  // AUTHENTICATED: Update driver profile
  // PUT /api/v1/driver-profiles/:id
  // ---------------------------------------------------------------------------
  Future<ApiResponse<DriverProfileModel>> updateDriverProfile({
    required String profileId,
    required Map<String, dynamic> data,
  }) async {
    Log.info('\n✏️ UPDATING DRIVER PROFILE: $profileId');
    Log.info('📊 Data: $data');

    return await _apiService.patch<DriverProfileModel>(
      '/api/v1/profiles/$profileId',
      data,
      fromJson: (json) => DriverProfileModel.fromJson(json),
    );
  }

  // ---------------------------------------------------------------------------
  // AUTHENTICATED: Toggle availability status
  // PUT /api/v1/driver-profiles/:id  with { is_available: bool }
  // ---------------------------------------------------------------------------
  Future<ApiResponse<DriverProfileModel>> toggleAvailability({
    required String profileId,
    required bool isAvailable,
  }) async {
    Log.info('\n🔄 TOGGLING DRIVER AVAILABILITY: $isAvailable');

    return await updateDriverProfile(
      profileId: profileId,
      data: {'is_available': isAvailable},
    );
  }

  // ---------------------------------------------------------------------------
  // DRIVER BOOKINGS MANAGEMENT
  // ---------------------------------------------------------------------------

  /// Fetch all available booking requests for this driver
  /// GET /api/v1/driver-bookings/available
  Future<ApiResponse<List<dynamic>>> getAvailableBookings() async {
    Log.info('\n📋 FETCHING AVAILABLE BOOKING REQUESTS');
    return await _apiService.get<List<dynamic>>(
      '/api/v1/driver-bookings/available',
      fromJson: (json) => json is List ? json : (json['data'] ?? []),
    );
  }

  /// Update the status of a specific booking (Accept, Arrived, Started, Completed)
  /// PATCH /api/v1/driver-bookings/:id/status
  Future<ApiResponse<dynamic>> updateBookingStatus({
    required String bookingId,
    required String status,
  }) async {
    Log.info('\n🔄 UPDATING BOOKING STATUS: $bookingId -> $status');
    return await _apiService.patch<dynamic>(
      '/api/v1/driver-bookings/$bookingId/status',
      {'status': status},
      fromJson: (json) => json,
    );
  }
}
