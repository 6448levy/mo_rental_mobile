// lib/data/services/booking_service.dart
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:get_storage/get_storage.dart';
import '../../app/core/constants/api_constants.dart';
import '../models/booking_model.dart';

class BookingService {
  final GetStorage _storage = GetStorage();

  Map<String, String> get _authHeaders {
    final token = _storage.read('auth_token') ?? '';
    return {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      if (token.isNotEmpty) 'Authorization': 'Bearer $token',
    };
  }

  /// Fetch bookings from the API with HTML response prevention
  Future<List<BookingModel>> getBookings() async {
    final urlStr = ApiConstants.join('api/v1/bookings');
    final url = Uri.parse(urlStr);

    try {
      final response = await http.get(url, headers: _authHeaders);

      // Log raw response for debugging
      debugPrint('--- API DEBUG: GET /bookings ---');
      debugPrint('Status: ${response.statusCode}');
      debugPrint('Content-Type: ${response.headers['content-type']}');
      debugPrint('Body: ${response.body}');
      debugPrint('--------------------------------');

      // Prevent HTML parsing
      final contentType = response.headers['content-type'] ?? '';
      if (!contentType.contains('application/json')) {
        throw FormatException(
          'Server returned HTML instead of JSON (Status ${response.statusCode}). '
          'The /api/v1/bookings endpoint may not exist or requires authentication.',
        );
      }

      if (response.statusCode == 200) {
        final dynamic decoded = jsonDecode(response.body);
        // Handle both: direct list [] or wrapped { data: [] }
        final List<dynamic> jsonList =
            decoded is List ? decoded : (decoded['data'] ?? []);
        return jsonList.map((e) => BookingModel.fromJson(e)).toList();
      } else {
        final decoded = jsonDecode(response.body);
        throw Exception(
          decoded['message'] ?? 'API Error (${response.statusCode})',
        );
      }
    } catch (e) {
      rethrow;
    }
  }

  /// Single booking info
  Future<BookingModel> getBookingById(String id) async {
    final urlStr = ApiConstants.join('api/v1/bookings/$id');
    final url = Uri.parse(urlStr);
    try {
      final response = await http.get(url, headers: _authHeaders);

      if (response.headers['content-type']?.contains('application/json') !=
          true) {
        throw FormatException('Server returned HTML instead of JSON');
      }

      if (response.statusCode == 200) {
        return BookingModel.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Failed to load booking details');
      }
    } catch (e) {
      rethrow;
    }
  }
}
