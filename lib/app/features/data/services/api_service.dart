import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:get_storage/get_storage.dart';
import '../../../../app/core/constants/api_constants.dart';
import '../../../../app/core/utils/logger.dart';
import '../models/auth_models/api_response.dart';

class ApiService extends GetxService {
  static ApiService get to => Get.find();

  final String baseUrl = ApiConstants.baseUrl;
  final Duration timeout = ApiConstants.apiTimeout;
  final GetStorage _storage = GetStorage();

  Map<String, String> get _authHeaders {
    final token = _storage.read('auth_token') ?? '';
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      if (token.isNotEmpty) 'Authorization': 'Bearer $token',
    };
  }

  // POST method
  Future<ApiResponse<T>> post<T>(
    String endpoint,
    Map<String, dynamic> body, {
    Map<String, String>? headers,
    T Function(dynamic)? fromJson,
  }) async {
    final Stopwatch stopwatch = Stopwatch()..start();

    try {
      Log.info('\n🌐 API CALL STARTED');
      final String fullUrl = ApiConstants.join(endpoint);
      Log.info('📡 URL: $fullUrl');
      Log.info('📦 REQUEST BODY: $body');
      Log.info('⏰ Timeout: ${timeout.inSeconds} seconds');

      final url = Uri.parse(fullUrl);
      final response = await http
          .post(
            url,
            headers: {..._authHeaders, ...?headers},
            body: json.encode(body),
          )
          .timeout(timeout, onTimeout: () {
            throw http.ClientException(
                'Request timeout after ${timeout.inSeconds} seconds');
          });

      stopwatch.stop();

      Log.info('✅ API CALL COMPLETED');
      Log.info('⏱️  Response Time: ${stopwatch.elapsedMilliseconds}ms');
      Log.info('📊 Status Code: ${response.statusCode}');
      Log.info('📄 Response Headers: ${response.headers}');
      Log.info('📝 Response Body: ${response.body}');

      final contentType = response.headers['content-type'] ?? '';
      if (!contentType.contains('application/json')) {
        Log.info('❌ INVALID CONTENT TYPE: $contentType');
        return ApiResponse<T>(
          success: false,
          message:
              'Server returned an invalid response (HTML instead of JSON). Status: ${response.statusCode}',
        );
      }

      final dynamic decoded = json.decode(response.body);
      final Map<String, dynamic> responseData = decoded is Map<String, dynamic>
          ? decoded
          : {'data': decoded, 'message': 'Success'};

      if (response.statusCode == 201 || response.statusCode == 200) {
        Log.info('🎉 API SUCCESS');
        return ApiResponse<T>(
          success: true,
          message: responseData['message'] ?? 'Success',
          data: fromJson != null && responseData['data'] != null
              ? fromJson(responseData['data'])
              : null,
        );
      } else {
        String errorMessage = responseData['message'] ?? 'Request failed';

        // Check for duplicate key errors
        if (responseData['message']?.contains('duplicate key') ?? false) {
          if (responseData['message']?.contains('email') ?? false) {
            errorMessage = 'Email is already registered';
          } else if (responseData['message']?.contains('phone') ?? false) {
            errorMessage = 'Phone number is already registered';
          }
        }

        Log.info('❌ API ERROR: $errorMessage');
        return ApiResponse<T>(
          success: false,
          message: errorMessage,
          error: responseData,
        );
      }
    } on http.ClientException catch (e) {
      stopwatch.stop();
      Log.info('❌ HTTP CLIENT ERROR: $e');
      Log.info('⏱️  Failed after: ${stopwatch.elapsedMilliseconds}ms');

      String msg = 'Network error: ${e.message}';
      if (GetPlatform.isWeb && e.message.contains('Failed to fetch')) {
        msg =
            'Network error: Failed to fetch (Possible CORS issue, server is down, or wrong URL).';
        Log.info(
            '💡 PRO-TIP: If you are running locally, ensure your backend is on port 8000 with CORS enabled.');
        Log.info(
            '💡 PRO-TIP: You can also try switching to the Render URL in api_constants.dart if the local server is not intended.');
      }

      return ApiResponse<T>(
        success: false,
        message: msg,
        error: e,
      );
    } on FormatException catch (e) {
      stopwatch.stop();
      Log.info('❌ JSON FORMAT ERROR: $e');
      return ApiResponse<T>(
        success: false,
        message: 'Invalid response from server',
        error: e,
      );
    } catch (e) {
      stopwatch.stop();
      Log.info('❌ UNEXPECTED ERROR: $e');
      Log.info('⏱️  Failed after: ${stopwatch.elapsedMilliseconds}ms');
      return ApiResponse<T>(
        success: false,
        message: 'An unexpected error occurred: ${e.toString()}',
        error: e.toString(),
      );
    }
  }

  // GET method
  Future<ApiResponse<T>> get<T>(
    String endpoint, {
    Map<String, String>? headers,
    Map<String, dynamic>? queryParams,
    T Function(dynamic)? fromJson,
  }) async {
    final Stopwatch stopwatch = Stopwatch()..start();

    try {
      Log.info('\n🌐 API CALL STARTED');
      final String fullUrl = ApiConstants.join(endpoint);
      String finalUrl = fullUrl;

      // Add query parameters if any
      if (queryParams != null && queryParams.isNotEmpty) {
        final queryString = Uri(queryParameters: queryParams).query;
        finalUrl += '?$queryString';
      }

      Log.info('📡 URL: $finalUrl');

      final response = await http
          .get(
            Uri.parse(finalUrl),
            headers: {..._authHeaders, ...?headers},
          )
          .timeout(timeout);

      stopwatch.stop();

      Log.info('✅ API CALL COMPLETED');
      Log.info('⏱️ Response Time: ${stopwatch.elapsedMilliseconds}ms');
      Log.info('📊 Status Code: ${response.statusCode}');
      Log.info('📄 Response Headers: ${response.headers}');
      Log.info('📝 Response Body: ${response.body}');

      final contentType = response.headers['content-type'] ?? '';
      if (!contentType.contains('application/json')) {
        Log.info('❌ INVALID CONTENT TYPE: $contentType');
        return ApiResponse<T>(
          success: false,
          message:
              'Server returned an invalid response (HTML instead of JSON). Status: ${response.statusCode}',
        );
      }

      final dynamic decoded = json.decode(response.body);
      final Map<String, dynamic> responseData = decoded is Map<String, dynamic>
          ? decoded
          : {'data': decoded, 'message': 'Success'};

      if (response.statusCode == 200) {
        Log.info('🎉 API SUCCESS');
        return ApiResponse<T>(
          success: true,
          message: responseData['message'] ?? 'Success',
          data: fromJson != null && responseData['data'] != null
              ? fromJson(responseData['data'])
              : null,
        );
      } else {
        Log.info('❌ API ERROR');
        Log.info('❌ Error Message: ${responseData['message']}');
        Log.info('❌ Error Details: $responseData');

        return ApiResponse<T>(
          success: false,
          message: responseData['message'] ??
              'Request failed with status ${response.statusCode}',
          error: responseData,
        );
      }
    } on http.ClientException catch (e) {
      stopwatch.stop();
      Log.info('❌ HTTP CLIENT ERROR: $e');
      return ApiResponse<T>(
        success: false,
        message: 'Network error: ${e.message}',
        error: e,
      );
    } catch (e) {
      stopwatch.stop();
      Log.info('❌ UNEXPECTED ERROR: $e');
      return ApiResponse<T>(
        success: false,
        message: 'An unexpected error occurred: ${e.toString()}',
        error: e.toString(),
      );
    }
  }

  // PUT method
  Future<ApiResponse<T>> put<T>(
    String endpoint,
    Map<String, dynamic> body, {
    Map<String, String>? headers,
    T Function(dynamic)? fromJson,
  }) async {
    final Stopwatch stopwatch = Stopwatch()..start();

    try {
      Log.info('\n🌐 PUT API CALL STARTED');
      final String fullUrl = ApiConstants.join(endpoint);
      final url = Uri.parse(fullUrl);
      Log.info('📡 URL: $fullUrl');
      Log.info('📦 REQUEST BODY: $body');

      final response = await http
          .put(
            url,
            headers: {..._authHeaders, ...?headers},
            body: json.encode(body),
          )
          .timeout(timeout);

      stopwatch.stop();

      Log.info('✅ PUT API CALL COMPLETED');
      Log.info('⏱️ Response Time: ${stopwatch.elapsedMilliseconds}ms');
      Log.info('📊 Status Code: ${response.statusCode}');
      Log.info('📝 Response Body: ${response.body}');

      final contentType = response.headers['content-type'] ?? '';
      if (!contentType.contains('application/json')) {
        Log.info('❌ INVALID CONTENT TYPE: $contentType');
        return ApiResponse<T>(
          success: false,
          message:
              'Server returned an invalid response (HTML instead of JSON). Status: ${response.statusCode}',
        );
      }

      final dynamic decoded = json.decode(response.body);
      final Map<String, dynamic> responseData = decoded is Map<String, dynamic>
          ? decoded
          : {'data': decoded, 'message': 'Success'};

      if (response.statusCode == 200) {
        Log.info('🎉 PUT API SUCCESS');
        return ApiResponse<T>(
          success: true,
          message: responseData['message'] ?? 'Success',
          data: fromJson != null && responseData['data'] != null
              ? fromJson(responseData['data'])
              : null,
        );
      } else {
        Log.info('❌ PUT API ERROR');
        Log.info('❌ Error Message: ${responseData['message']}');

        return ApiResponse<T>(
          success: false,
          message: responseData['message'] ?? 'Request failed',
          error: responseData,
        );
      }
    } catch (e) {
      stopwatch.stop();
      Log.info('❌ PUT API ERROR: $e');
      return ApiResponse<T>(
        success: false,
        message: e.toString(),
        error: e,
      );
    }
  }

  // PATCH method
  Future<ApiResponse<T>> patch<T>(
    String endpoint,
    Map<String, dynamic> body, {
    Map<String, String>? headers,
    T Function(dynamic)? fromJson,
  }) async {
    final Stopwatch stopwatch = Stopwatch()..start();

    try {
      Log.info('\n🌐 PATCH API CALL STARTED');
      final String fullUrl = ApiConstants.join(endpoint);
      final url = Uri.parse(fullUrl);
      Log.info('📡 URL: $fullUrl');
      Log.info('📦 REQUEST BODY: $body');

      final response = await http
          .patch(
            url,
            headers: {..._authHeaders, ...?headers},
            body: json.encode(body),
          )
          .timeout(timeout);

      stopwatch.stop();

      Log.info('✅ PATCH API CALL COMPLETED');
      Log.info('⏱️ Response Time: ${stopwatch.elapsedMilliseconds}ms');
      Log.info('📊 Status Code: ${response.statusCode}');
      Log.info('📝 Response Body: ${response.body}');

      final contentType = response.headers['content-type'] ?? '';
      if (!contentType.contains('application/json')) {
        Log.info('❌ INVALID CONTENT TYPE: $contentType');
        return ApiResponse<T>(
          success: false,
          message:
              'Server returned an invalid response (HTML instead of JSON). Status: ${response.statusCode}',
        );
      }

      final dynamic decoded = json.decode(response.body);
      final Map<String, dynamic> responseData = decoded is Map<String, dynamic>
          ? decoded
          : {'data': decoded, 'message': 'Success'};

      if (response.statusCode == 200) {
        Log.info('🎉 PATCH API SUCCESS');
        return ApiResponse<T>(
          success: true,
          message: responseData['message'] ?? 'Success',
          data: fromJson != null && responseData['data'] != null
              ? fromJson(responseData['data'])
              : null,
        );
      } else {
        Log.info('❌ PATCH API ERROR');
        Log.info('❌ Error Message: ${responseData['message']}');

        return ApiResponse<T>(
          success: false,
          message: responseData['message'] ?? 'Request failed',
          error: responseData,
        );
      }
    } catch (e) {
      stopwatch.stop();
      Log.info('❌ PATCH API ERROR: $e');
      return ApiResponse<T>(
        success: false,
        message: e.toString(),
        error: e,
      );
    }
  }

  // DELETE method
  Future<ApiResponse<T>> delete<T>(
    String endpoint, {
    Map<String, String>? headers,
  }) async {
    final Stopwatch stopwatch = Stopwatch()..start();

    try {
      Log.info('\n🌐 DELETE API CALL STARTED');
      final String fullUrl = ApiConstants.join(endpoint);
      final url = Uri.parse(fullUrl);
      Log.info('📡 URL: $fullUrl');

      final response = await http
          .delete(
            url,
            headers: {..._authHeaders, ...?headers},
          )
          .timeout(timeout);

      stopwatch.stop();

      Log.info('✅ DELETE API CALL COMPLETED');
      Log.info('⏱️ Response Time: ${stopwatch.elapsedMilliseconds}ms');
      Log.info('📊 Status Code: ${response.statusCode}');
      Log.info('📝 Response Body: ${response.body}');

      final contentType = response.headers['content-type'] ?? '';
      if (!contentType.contains('application/json')) {
        Log.info('❌ INVALID CONTENT TYPE: $contentType');
        return ApiResponse<T>(
          success: false,
          message:
              'Server returned an invalid response (HTML instead of JSON). Status: ${response.statusCode}',
        );
      }

      final dynamic decoded = json.decode(response.body);
      final Map<String, dynamic> responseData = decoded is Map<String, dynamic>
          ? decoded
          : {'data': decoded, 'message': 'Success'};

      if (response.statusCode == 200) {
        Log.info('🎉 DELETE API SUCCESS');
        return ApiResponse<T>(
          success: true,
          message: responseData['message'] ?? 'Success',
        );
      } else {
        Log.info('❌ DELETE API ERROR');
        Log.info('❌ Error Message: ${responseData['message']}');

        return ApiResponse<T>(
          success: false,
          message: responseData['message'] ?? 'Request failed',
          error: responseData,
        );
      }
    } catch (e) {
      stopwatch.stop();
      Log.info('❌ DELETE API ERROR: $e');
      return ApiResponse<T>(
        success: false,
        message: e.toString(),
        error: e,
      );
    }
  }
}
