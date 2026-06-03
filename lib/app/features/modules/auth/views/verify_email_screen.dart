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
  final List<FocusNode> _otpFocusNodes =
      List.generate(6, (index) => FocusNode());
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
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded,
              size: 20, color: AppPalette.brandBlue),
          onPressed: () => Get.back(),
        ),
      ),
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppPalette.pureWhite,
              Color(0xFFF0F7FD), // Light blue tint
              Color(0xFFD9ECFA), // Deeper light blue tint
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 60),

                // Animated Icon Section
                TweenAnimationBuilder<double>(
                  duration: const Duration(milliseconds: 1200),
                  curve: Curves.elasticOut,
                  tween: Tween(begin: 0.0, end: 1.0),
                  builder: (context, value, child) {
                    return Transform.scale(
                      scale: value,
                      child: Opacity(
                        opacity: value.clamp(0.0, 1.0),
                        child: child,
                      ),
                    );
                  },
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppPalette.pureWhite,
                          boxShadow: [
                            BoxShadow(
                              color:
                                  AppPalette.brandBlue.withValues(alpha: 0.15),
                              blurRadius: 30,
                              offset: const Offset(0, 15),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.mark_email_read_rounded,
                          size: 60,
                          color: AppPalette.brandBlue,
                        ),
                      ),
                      const SizedBox(height: 32),
                      Text(
                        'Verify Your Email',
                        textAlign: TextAlign.center,
                        style: theme.textTheme.displaySmall?.copyWith(
                          fontWeight: FontWeight.w800,
                          color: AppPalette.textPrimary,
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                          'Enter the 6-digit OTP sent to\n$email',
                          textAlign: TextAlign.center,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: AppPalette.textSecondary,
                            height: 1.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 48),

                // OTP Form Container
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: AppPalette.pureWhite,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: AppPalette.brandBlue.withValues(alpha: 0.08),
                        blurRadius: 24,
                        offset: const Offset(0, 8),
                      ),
                    ],
                    border: Border.all(
                        color: AppPalette.brandBlue.withValues(alpha: 0.1)),
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: List.generate(6, (index) {
                            return SizedBox(
                              width: 42,
                              child: CustomTextField(
                                controller: _otpControllers[index],
                                labelText: '',
                                hintText: '',
                                maxLength: 1,
                                keyboardType: TextInputType.number,
                                textAlign: TextAlign.center,
                                validator: (value) =>
                                    index == 5 ? Validators.validateOtp(_getOtp()) : null,
                                onChanged: (value) {
                                  _handleOtpChange(index, value);
                                  if (value.length == 1 && index == 5) {
                                    FocusScope.of(context).unfocus();
                                  }
                                },
                                prefixIcon: null,
                              ),
                            );
                          }),
                        ),
                        const SizedBox(height: 32),
                        Obx(() => CustomElevatedButton(
                              text: 'Verify Email',
                              onPressed: _verifyEmail,
                              isLoading: _authController.isLoading.value,
                            )),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 32),

                // Resend Link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Didn't receive OTP?",
                        style: theme.textTheme.bodyMedium
                            ?.copyWith(color: AppPalette.textSecondary)),
                    TextButton(
                      onPressed: () {
                        // Implement resend logic
                        Get.snackbar(
                          'Info',
                          'OTP resend functionality to be implemented',
                          backgroundColor: AppPalette.brandBlue,
                          colorText: AppPalette.pureWhite,
                        );
                      },
                      style: TextButton.styleFrom(
                          foregroundColor: AppPalette.brandBlue),
                      child: const Text(
                        'Resend OTP',
                        style: TextStyle(fontWeight: FontWeight.w700),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
