// lib/app/features/data/services/booking_service.dart
import 'dart:convert';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import '../../../../app/core/utils/logger.dart';
import '../models/auth_models/api_response.dart';
import '../models/booking/booking_model.dart';
import '../models/booking/driver_booking_model.dart';
import '../models/booking/reservation_model.dart';
import 'api_service.dart';
import '../../../core/constants/api_constants.dart';

class BookingService extends GetxService {
  final ApiService _apiService = Get.find<ApiService>();
  final GetStorage _storage = GetStorage();



  // ===========================================================================
  // DRIVER BOOKINGS (/api/v1/driver-bookings)
  // ===========================================================================

  Future<ApiResponse<DriverBookingModel>> createDriverBooking({
    required Map<String, dynamic> bookingData,
  }) async {
    Log.info('\n🚗 CREATING DRIVER BOOKING');
    return await _apiService.post<DriverBookingModel>(
      ApiConstants.DRIVER_BOOKINGS,
      bookingData,
      fromJson: (json) => DriverBookingModel.fromJson(json),
    );
  }

  Future<ApiResponse<List<DriverBookingModel>>> getMyDriverBookings({
    String? status,
  }) async {
    Log.info('\n📋 FETCHING MY DRIVER BOOKINGS');
    final queryParams = {
      if (status != null) 'status': status,
    };

    return await _apiService.get<List<DriverBookingModel>>(
      ApiConstants.DRIVER_BOOKINGS,
      queryParams: queryParams,
      fromJson: (json) {
        final List<dynamic> data = json is List ? json : (json['data'] ?? []);
        return data.map((e) => DriverBookingModel.fromJson(e)).toList();
      },
    );
  }

  // ===========================================================================
  // RESERVATIONS (/api/v1/reservations)
  // ===========================================================================

  Future<ApiResponse<ReservationModel>> createReservation({
    required Map<String, dynamic> reservationData,
  }) async {
    Log.info('\n🚗 CREATING CAR RESERVATION');
    return await _apiService.post<ReservationModel>(
      ApiConstants.RESERVATIONS,
      reservationData,
      fromJson: (json) => ReservationModel.fromJson(json),
    );
  }

  Future<ApiResponse<List<ReservationModel>>> getMyReservations({
    String? status,
    String? code,
  }) async {
    Log.info('\n📋 FETCHING MY RESERVATIONS');
    final queryParams = {
      if (status != null) 'status': status,
      if (code != null) 'code': code,
    };

    return await _apiService.get<List<ReservationModel>>(
      ApiConstants.RESERVATIONS,
      queryParams: queryParams,
      fromJson: (json) {
        final List<dynamic> data = json is List ? json : (json['data'] ?? []);
        return data.map((e) => ReservationModel.fromJson(e)).toList();
      },
    );
  }

  Future<ApiResponse<ReservationModel>> getReservationById(String id) async {
    Log.info('\n📋 FETCHING RESERVATION DETAILS: $id');
    return await _apiService.get<ReservationModel>(
      '${ApiConstants.RESERVATIONS}/$id',
      fromJson: (json) => ReservationModel.fromJson(json),
    );
  }

  // ---------------------------------------------------------------------------
  // LEGACY METHODS (Kept for compatibility for now)
  // ---------------------------------------------------------------------------

  Future<ApiResponse<List<BookingModel>>> getBookings() async {
    Log.info('\n📋 FETCHING LEGACY BOOKINGS');
    return await _apiService.get<List<BookingModel>>(
      '/api/v1/bookings',
      fromJson: (json) {
        final List<dynamic> data = json is List ? json : (json['data'] ?? []);
        return data.map((e) => BookingModel.fromJson(e)).toList();
      },
    );
  }

  Future<ApiResponse<BookingModel>> getBookingById(String id) async {
    Log.info('\n📋 FETCHING LEGACY BOOKING: $id');
    return await _apiService.get<BookingModel>(
      '/api/v1/bookings/$id',
      fromJson: (json) => BookingModel.fromJson(json),
    );
  }
}
