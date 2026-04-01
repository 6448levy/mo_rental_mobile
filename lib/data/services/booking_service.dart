// lib/data/services/booking_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../app/core/constants/api_constants.dart';
import '../models/booking_model.dart';

class BookingService {
  /// Fetch bookings from the API with HTML response prevention
  Future<List<BookingModel>> fetchBookings() async {
    final urlStr = ApiConstants.join('api/v1/bookings');
    final url = Uri.parse(urlStr);
    
    try {
      final response = await http.get(url, headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      });

      // 1. Log raw response for debugging (Required fix)
      print('--- API DEBUG: GET /bookings ---');
      print('Status: ${response.statusCode}');
      print('Body: ${response.body}');
      print('-------------------------------');

      // 2. Prevent HTML parsing (Required fix)
      final contentType = response.headers['content-type'] ?? '';
      if (!contentType.contains('application/json')) {
        throw FormatException('Invalid Server Response: Expected JSON but received HTML.');
      }

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = jsonDecode(response.body);
        return jsonList.map((e) => BookingModel.fromJson(e)).toList();
      } else {
        throw Exception('API Error (${response.statusCode}): ${response.body}');
      }
    } catch (e) {
      rethrow;
    }
  }

  /// Single booking info
  Future<BookingModel> fetchBookingById(String id) async {
    final urlStr = ApiConstants.join('api/v1/bookings/$id');
    final url = Uri.parse(urlStr);
    try {
      final response = await http.get(url, headers: {
        'Accept': 'application/json',
      });

      if (response.headers['content-type']?.contains('application/json') != true) {
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
