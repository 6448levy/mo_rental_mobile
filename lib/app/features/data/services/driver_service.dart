import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
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
    print('\n🚗 FETCHING PUBLIC DRIVER PROFILES');
    try {
      final urlStr = ApiConstants.join('/api/v1/driver-profiles/public');
      final url = Uri.parse(urlStr);
      print('📡 URL: $url');

      final response = await http.get(
        url,
        headers: {'Accept': 'application/json'},
      ).timeout(_apiService.timeout);

      print('📊 Status: ${response.statusCode}');
      print('📝 Body: ${response.body}');

      // ✅ Guard: ensure server returned JSON, not HTML
      final contentType = response.headers['content-type'] ?? '';
      if (!contentType.contains('application/json')) {
        print('❌ Expected JSON but got: $contentType');
        return ApiResponse<List<DriverProfileModel>>(
          success: false,
          message: 'Server returned a non-JSON response. Status: ${response.statusCode}.',
          data: [],
        );
      }

      final dynamic _decoded = json.decode(response.body);

      // If server returned the list directly as [ ] instead of { data: [] }
      if (_decoded is List) {
        final profiles = _decoded.map((e) => DriverProfileModel.fromJson(e)).toList();
        print('✅ Fetched ${profiles.length} driver profiles (direct list)');
        return ApiResponse<List<DriverProfileModel>>(
          success: true,
          message: 'Driver profiles fetched successfully',
          data: profiles,
        );
      }

      final Map<String, dynamic> responseData = _decoded as Map<String, dynamic>;

      if (response.statusCode == 200 && responseData['success'] == true) {
        final List<dynamic> rawList = responseData['data'] ?? [];
        final profiles =
            rawList.map((e) => DriverProfileModel.fromJson(e)).toList();
        print('✅ Fetched ${profiles.length} driver profiles');
        return ApiResponse<List<DriverProfileModel>>(
          success: true,
          message: 'Driver profiles fetched successfully',
          data: profiles,
        );
      } else {
        final msg = responseData['message'] ?? 'Failed to fetch driver profiles';
        print('❌ Error: $msg');
        return ApiResponse<List<DriverProfileModel>>(
          success: false,
          message: msg,
          error: responseData,
        );
      }
    } catch (e) {
      print('❌ DRIVER SERVICE ERROR: $e');
      return ApiResponse<List<DriverProfileModel>>(
        success: false,
        message: 'An error occurred: ${e.toString()}',
        error: e.toString(),
      );
    }
  }

  // ---------------------------------------------------------------------------
  // AUTHENTICATED: Fetch a single driver profile by ID
  // GET /api/v1/driver-profiles/:id
  // ---------------------------------------------------------------------------
  Future<ApiResponse<DriverProfileModel>> getDriverProfileById({
    required String profileId,
    required String token,
  }) async {
    print('\n🚗 FETCHING DRIVER PROFILE: $profileId');

    final headers = {
      'Authorization': 'Bearer $token',
      'Accept': 'application/json',
    };

    return await _apiService.get<DriverProfileModel>(
      '/api/v1/driver-profiles/$profileId',
      headers: headers,
      fromJson: (data) => DriverProfileModel.fromJson(data),
    );
  }

  // ---------------------------------------------------------------------------
  // AUTHENTICATED: Fetch MY driver profile (logged-in driver)
  // GET /api/v1/driver-profiles/me  (common pattern)
  // ---------------------------------------------------------------------------
  Future<ApiResponse<DriverProfileModel>> getMyDriverProfile({
    required String token,
  }) async {
    print('\n🚗 FETCHING MY DRIVER PROFILE');

    final headers = {
      'Authorization': 'Bearer $token',
      'Accept': 'application/json',
    };

    return await _apiService.get<DriverProfileModel>(
      '/api/v1/driver-profiles/me',
      headers: headers,
      fromJson: (data) => DriverProfileModel.fromJson(data),
    );
  }

  // ---------------------------------------------------------------------------
  // AUTHENTICATED: Update driver profile
  // PUT /api/v1/driver-profiles/:id
  // ---------------------------------------------------------------------------
  Future<ApiResponse<DriverProfileModel>> updateDriverProfile({
    required String profileId,
    required String token,
    required Map<String, dynamic> data,
  }) async {
    print('\n✏️ UPDATING DRIVER PROFILE: $profileId');
    print('📊 Data: $data');

    final headers = {
      'Authorization': 'Bearer $token',
      'Accept': 'application/json',
    };

    return await _apiService.put<DriverProfileModel>(
      '/api/v1/driver-profiles/$profileId',
      data,
      headers: headers,
      fromJson: (json) => DriverProfileModel.fromJson(json),
    );
  }

  // ---------------------------------------------------------------------------
  // AUTHENTICATED: Toggle availability status
  // PUT /api/v1/driver-profiles/:id  with { is_available: bool }
  // ---------------------------------------------------------------------------
  Future<ApiResponse<DriverProfileModel>> toggleAvailability({
    required String profileId,
    required String token,
    required bool isAvailable,
  }) async {
    print('\n🔄 TOGGLING DRIVER AVAILABILITY: $isAvailable');

    return await updateDriverProfile(
      profileId: profileId,
      token: token,
      data: {'is_available': isAvailable},
    );
  }
}
