import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/themes/app_palette.dart';
import '../../../../core/utils/validators.dart';
import '../../../widgets/custom_text_field.dart/custom_text_field.dart';
import '../controllers/auth_controller.dart';

class VerifyEmailScreen extends StatefulWidget {
  const VerifyEmailScreen({super.key}); // Remove required parameter

  @override
  State<VerifyEmailScreen> createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends State<VerifyEmailScreen> {
  final _formKey = GlobalKey<FormState>();
  final List<TextEditingController> _otpControllers =
      List.generate(6, (index) => TextEditingController());
  final List<FocusNode> _otpFocusNodes = List.generate(6, (index) => FocusNode());
  final AuthController _authController = Get.find<AuthController>();
  
  // Get email from Get.arguments
  String get email => Get.arguments?['email'] ?? '';

  @override
  void initState() {
    super.initState();
    // Check if email is provided
    if (email.isEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Get.back();
        Get.snackbar('Error', 'Email not provided');
      });
    }
  }

  @override
  void dispose() {
    for (var controller in _otpControllers) {
      controller.dispose();
    }
    for (var focusNode in _otpFocusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }

  String _getOtp() {
    return _otpControllers.map((c) => c.text).join();
  }

  Future<void> _verifyEmail() async {
    if (_formKey.currentState!.validate()) {
      final otp = _getOtp();
      
      final response = await _authController.verifyEmail(
        email: email, // Use email getter
        otp: otp,
      );

      if (response.success && response.data != null) {
        Get.offAllNamed('/home');
        Get.snackbar(
          'Success',
          'Email verified successfully!',
          backgroundColor: Colors.green.shade600,
          colorText: AppPalette.pureWhite,
        );
      } else {
        Get.snackbar(
          'Verification Failed',
          response.message,
          backgroundColor: AppPalette.error,
          colorText: AppPalette.pureWhite,
        );
      }
    }
  }

  void _handleOtpChange(int index, String value) {
    if (value.isNotEmpty && index < 5) {
      _otpFocusNodes[index + 1].requestFocus();
    }
    if (value.isEmpty && index > 0) {
      _otpFocusNodes[index - 1].requestFocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppPalette.pureWhite,
      appBar: AppBar(
        title: const Text('Verify Email'),
        centerTitle: true,
        backgroundColor: AppPalette.brandBlue,
        foregroundColor: AppPalette.pureWhite,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20, color: AppPalette.pureWhite),
          onPressed: () => Get.back(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 40),
              const Icon(
                Icons.mark_email_read,
                size: 80,
                color: AppPalette.brandBlue,
              ),
              const SizedBox(height: 20),
              const Text(
                'Verify Your Email',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppPalette.textPrimary,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Enter the 6-digit OTP sent to $email', // Use email getter
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                  color: AppPalette.textSecondary,
                ),
              ),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(6, (index) {
                  return SizedBox(
                    width: 50,
                    child: CustomTextField(
                      controller: _otpControllers[index],
                      labelText: '',
                      hintText: '',
                      maxLength: 1,
                      keyboardType: TextInputType.number,
                      validator: (value) => Validators.validateOtp(_getOtp()),
                      onChanged: (value) => _handleOtpChange(index, value),
                      prefixIcon: null,
                    ),
                  );
                }),
              ),
              const SizedBox(height: 30),
              Obx(() => CustomElevatedButton(
                    text: 'Verify Email',
                    onPressed: _verifyEmail,
                    isLoading: _authController.isLoading.value,
                  )),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                 children: [
                  const Text("Didn't receive OTP?", style: TextStyle(color: AppPalette.textSecondary)),
                  TextButton(
                    onPressed: () {
                      Get.snackbar(
                        'Info',
                        'OTP resend functionality to be implemented',
                      );
                    },
                     child: const Text(
                      'Resend OTP',
                      style: TextStyle(color: AppPalette.brandBlue, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}