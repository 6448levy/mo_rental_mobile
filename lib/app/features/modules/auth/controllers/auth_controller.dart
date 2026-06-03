import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../../../../domain/repositories/auth_repository.dart';
import '../../../data/models/auth_models/api_response.dart' as api_models; 
import '../../../data/models/auth_models/login_request.dart';
import '../../../data/models/auth_models/login_response.dart';
import '../../../data/models/auth_models/register_request.dart';
import '../../../data/models/auth_models/register_response.dart';
import '../../../data/models/auth_models/verify_email_request.dart';
import '../../../data/models/auth_models/verify_email_response.dart';

// FIX: Ensure this path matches your folder structure exactly
import '../../../data/models/user_model.dart';

class AuthController extends GetxController {
  final AuthRepository _authRepository = AuthRepository();
  final GetStorage _storage = GetStorage();

  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  void _printDebugInfo(String operation, dynamic request, api_models.ApiResponse response) {
    debugPrint('\n🔵🔵🔵 AUTH DEBUG INFO 🔵🔵🔵');
    debugPrint('Operation: $operation');
    debugPrint('Time: ${DateTime.now()}');
    debugPrint('Request: $request');
    debugPrint('Response Success: ${response.success}');
    debugPrint('Response Message: ${response.message}');
    debugPrint('Response Data: ${response.data}');
    debugPrint('Response Error: ${response.error}');
    debugPrint('🔵🔵🔵 END DEBUG INFO 🔵🔵🔵\n');
  }

  // Registration
  Future<api_models.ApiResponse<RegisterResponse>> register({
    required String fullName,
    required String email,
    required String phone,
    required String password,
  }) async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      final request = RegisterRequest(
        fullName: fullName,
        email: email,
        phone: phone,
        password: password,
      );

      final response = await _authRepository.register(request);
      _printDebugInfo('REGISTRATION', request.toJson(), response);

      if (!response.success) {
        errorMessage.value = response.message;
        Get.snackbar('Registration Failed', response.message, backgroundColor: Colors.red, colorText: Colors.white);
      } else {
        _storage.write('pending_verification_email', email);
      }
      return response;
    } catch (e) {
      errorMessage.value = e.toString();
      return api_models.ApiResponse(success: false, message: e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  // Login
  Future<api_models.ApiResponse<LoginResponse>> login({
    required String email,
    required String password,
  }) async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      final request = LoginRequest(email: email, password: password);
      final response = await _authRepository.login(request);
      _printDebugInfo('LOGIN', request.toJson(), response);

      if (response.success && response.data != null) {
        _storage.write('auth_token', response.data!.token);
        _storage.write('user_email', email);
        _storage.write('user_data', response.data!.user.toJson());

        if (!response.data!.user.emailVerified) {
          _storage.write('pending_verification_email', email);
          Get.offNamed('/verify-email', arguments: {'email': email});
        } else {
          Get.offAllNamed('/main');
        }
      } else {
        errorMessage.value = response.message;
        Get.snackbar('Login Failed', response.message, backgroundColor: Colors.red, colorText: Colors.white);
      }
      return response;
    } catch (e) {
      errorMessage.value = e.toString();
      return api_models.ApiResponse(success: false, message: e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  // Verify Email
  Future<api_models.ApiResponse<VerifyEmailResponse>> verifyEmail({
    required String email,
    required String otp,
  }) async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      final request = VerifyEmailRequest(email: email, otp: otp);
      final response = await _authRepository.verifyEmail(request);
      _printDebugInfo('EMAIL VERIFICATION', request.toJson(), response);

      if (response.success && response.data != null) {
        _storage.write('auth_token', response.data!.token);
        _storage.write('user_email', email);
        _storage.remove('pending_verification_email');
        Get.offAllNamed('/main');
      } else {
        errorMessage.value = response.message;
        Get.snackbar('Verification Failed', response.message, backgroundColor: Colors.red, colorText: Colors.white);
      }
      return response;
    } catch (e) {
      errorMessage.value = e.toString();
      return api_models.ApiResponse(success: false, message: e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  String? get pendingVerificationEmail => _storage.read('pending_verification_email');

  // FIX: This will now work once the import at line 13 is corrected
  UserModel? get user {
    final data = _storage.read('user_data');
    if (data == null) return null;
    try {
      return UserModel.fromJson(data);
    } catch (e) {
      debugPrint('Error parsing UserModel: $e');
      return null;
    }
  }

  void logout() {
    _storage.remove('auth_token');
    _storage.remove('user_email');
    _storage.remove('user_data');
    _storage.remove('pending_verification_email');
    Get.offAllNamed('/login');
  }

  bool get isAuthenticated => _storage.read('auth_token') != null;

  bool get isAdminOrManager {
    final currentUser = user;
    if (currentUser == null) return false;
    return currentUser.isAdmin || currentUser.isManager;
  }

  void printUserRoleInfo() {
    final currentUser = user;
    if (currentUser == null) return;
    debugPrint('\n👤 ========== USER ROLE INFO ==========');
    debugPrint('👤 Email: ${currentUser.email}');
    debugPrint('👤 Is Admin/Manager: $isAdminOrManager');
    debugPrint('👤 =================================\n');
  }
}