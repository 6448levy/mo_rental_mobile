// lib/app/features/data/services/booking_service.dart
import 'dart:convert';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import '../models/auth_models/api_response.dart';
import '../models/booking/booking_model.dart';
import 'api_service.dart';

class BookingService extends GetxService {
  final ApiService _apiService = Get.find<ApiService>();
  final GetStorage _storage = GetStorage();

  Map<String, String> get _authHeaders {
    final token = _storage.read('auth_token') ?? '';
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      if (token.isNotEmpty) 'Authorization': 'Bearer $token',
    };
  }

  // ---------------------------------------------------------------------------
  // POST /bookings  — Create a new booking
  // ---------------------------------------------------------------------------
  Future<ApiResponse<BookingModel>> createBooking({
    required String driverId,
    required String pickupLocation,
    required String destination,
    String paymentMethod = 'card',
  }) async {
    print('\n🗓️ CREATING BOOKING');
    try {
      final url = Uri.parse('${_apiService.baseUrl}/api/v1/bookings');
      final body = json.encode({
        'driver_id': driverId,
        'pickup_location': pickupLocation,
        'destination': destination,
        'payment_method': paymentMethod,
      });

      print('📡 URL: $url');
      print('📦 BODY: $body');

      final response = await http
          .post(url, headers: _authHeaders, body: body)
          .timeout(_apiService.timeout);

      print('📊 Status: ${response.statusCode}');
      print('📝 Body: ${response.body}');

      final Map<String, dynamic> responseData = json.decode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = responseData['data'];
        if (data != null) {
          return ApiResponse<BookingModel>(
            success: true,
            message: responseData['message'] ?? 'Booking created successfully',
            data: BookingModel.fromJson(data),
          );
        }
        return ApiResponse<BookingModel>(
          success: true,
          message: responseData['message'] ?? 'Booking created successfully',
        );
      } else {
        return ApiResponse<BookingModel>(
          success: false,
          message: responseData['message'] ?? 'Failed to create booking',
          error: responseData,
        );
      }
    } catch (e) {
      print('❌ BOOKING SERVICE ERROR: $e');
      return ApiResponse<BookingModel>(
        success: false,
        message: 'An error occurred: ${e.toString()}',
        error: e.toString(),
      );
    }
  }

  // ---------------------------------------------------------------------------
  // GET /bookings  — Retrieve all bookings for current user
  // ---------------------------------------------------------------------------
  Future<ApiResponse<List<BookingModel>>> getBookings() async {
    print('\n📋 FETCHING BOOKINGS');
    try {
      final url = Uri.parse('${_apiService.baseUrl}/api/v1/bookings');
      print('📡 URL: $url');

      final response = await http
          .get(url, headers: _authHeaders)
          .timeout(_apiService.timeout);

      print('📊 Status: ${response.statusCode}');
      print('📝 Body: ${response.body}');

      final Map<String, dynamic> responseData = json.decode(response.body);

      if (response.statusCode == 200) {
        final List<dynamic> rawList = responseData['data'] ?? [];
        final bookings = rawList.map((e) => BookingModel.fromJson(e)).toList();
        print('✅ Fetched ${bookings.length} bookings');
        return ApiResponse<List<BookingModel>>(
          success: true,
          message: 'Bookings fetched successfully',
          data: bookings,
        );
      } else {
        return ApiResponse<List<BookingModel>>(
          success: false,
          message: responseData['message'] ?? 'Failed to fetch bookings',
          error: responseData,
        );
      }
    } catch (e) {
      print('❌ BOOKING SERVICE ERROR: $e');
      return ApiResponse<List<BookingModel>>(
        success: false,
        message: 'An error occurred: ${e.toString()}',
        error: e.toString(),
      );
    }
  }

  // ---------------------------------------------------------------------------
  // GET /bookings/:id  — Retrieve a single booking
  // ---------------------------------------------------------------------------
  Future<ApiResponse<BookingModel>> getBookingById(String id) async {
    print('\n📋 FETCHING BOOKING: $id');
    try {
      final url = Uri.parse('${_apiService.baseUrl}/api/v1/bookings/$id');
      final response = await http
          .get(url, headers: _authHeaders)
          .timeout(_apiService.timeout);

      final Map<String, dynamic> responseData = json.decode(response.body);

      if (response.statusCode == 200) {
        return ApiResponse<BookingModel>(
          success: true,
          message: 'Booking fetched successfully',
          data: BookingModel.fromJson(responseData['data']),
        );
      } else {
        return ApiResponse<BookingModel>(
          success: false,
          message: responseData['message'] ?? 'Failed to fetch booking',
          error: responseData,
        );
      }
    } catch (e) {
      return ApiResponse<BookingModel>(
        success: false,
        message: 'An error occurred: ${e.toString()}',
        error: e.toString(),
      );
    }
  }
}
