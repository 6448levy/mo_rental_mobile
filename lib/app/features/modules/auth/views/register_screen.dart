import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';
import 'package:carrental/app/core/themes/app_palette.dart';
import 'package:carrental/app/core/utils/validators.dart';
import 'package:carrental/app/features/widgets/custom_text_field.dart/custom_text_field.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final AuthController _authController = Get.find<AuthController>();

  // Add this for local error display
  final RxString _localError = ''.obs;

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    _localError.value = ''; // Clear previous errors

    if (_formKey.currentState!.validate()) {
      if (_passwordController.text != _confirmPasswordController.text) {
        _localError.value = 'Passwords do not match';
        Get.snackbar(
          'Error',
          'Passwords do not match',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return;
      }

      // Show loading
      _authController.isLoading.value = true;

      try {
        final response = await _authController.register(
          fullName: _fullNameController.text.trim(),
          email: _emailController.text.trim(),
          phone: _phoneController.text.trim(),
          password: _passwordController.text,
        );

        if (response.success && response.data != null) {
          // Navigate to verify email screen WITH the email
          Get.offNamed(
            '/verify-email',
            arguments: {'email': _emailController.text.trim()},
          );
          Get.snackbar(
            'Success',
            'Registration successful! Please check your email for OTP.',
            backgroundColor: Colors.green,
            colorText: Colors.white,
          );
        } else {
          // Show error on screen AND snackbar
          _localError.value = response.message;
          Get.snackbar(
            'Registration Failed',
            response.message,
            backgroundColor: Colors.red,
            colorText: Colors.white,
            duration: Duration(seconds: 5),
          );
        }
      } catch (e) {
        _localError.value = e.toString();
        Get.snackbar(
          'Registration Error',
          e.toString(),
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: Duration(seconds: 5),
        );
      } finally {
        _authController.isLoading.value = false;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      backgroundColor: AppPalette.pureWhite,
      appBar: AppBar(
        title: Text('Create Account', style: theme.textTheme.headlineSmall?.copyWith(color: AppPalette.pureWhite)),
        backgroundColor: AppPalette.brandBlue,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20, color: AppPalette.pureWhite),
          onPressed: () => Get.back(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 20),
                Text(
                  'Join MoRental',
                  style: theme.textTheme.displaySmall?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: AppPalette.textPrimary,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Start your premium journey today',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: AppPalette.textSecondary,
                  ),
                ),
                const SizedBox(height: 40),
                
                CustomTextField(
                  controller: _fullNameController,
                  labelText: 'Full Name',
                  hintText: 'Enter your full name',
                  validator: Validators.validateFullName,
                  prefixIcon: const Icon(Icons.person_outline_rounded),
                ),
                const SizedBox(height: 20),
                CustomTextField(
                  controller: _emailController,
                  labelText: 'Email Address',
                  hintText: 'Enter your email',
                  keyboardType: TextInputType.emailAddress,
                  validator: Validators.validateEmail,
                  prefixIcon: const Icon(Icons.email_outlined),
                ),
                const SizedBox(height: 20),
                CustomTextField(
                  controller: _phoneController,
                  labelText: 'Phone Number',
                  hintText: 'e.g., +263 771 234 567',
                  keyboardType: TextInputType.phone,
                  validator: Validators.validatePhone,
                  prefixIcon: const Icon(Icons.phone_outlined),
                  maxLength: 15,
                ),
                const SizedBox(height: 20),
                CustomTextField(
                  controller: _passwordController,
                  labelText: 'Password',
                  hintText: 'Enter your password',
                  obscureText: true,
                  validator: Validators.validatePassword,
                  prefixIcon: const Icon(Icons.lock_outlined),
                ),
                const SizedBox(height: 20),
                CustomTextField(
                  controller: _confirmPasswordController,
                  labelText: 'Confirm Password',
                  hintText: 'Re-enter your password',
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please confirm your password';
                    }
                    return null;
                  },
                  prefixIcon: const Icon(Icons.lock_reset_rounded),
                ),

                const SizedBox(height: 24),

                // Error Display (Premium Dark Mode Alert)
                Obx(() {
                  final error = _localError.value.isNotEmpty 
                      ? _localError.value 
                      : (_authController.errorMessage.value.isNotEmpty ? _authController.errorMessage.value : '');
                  
                  if (error.isNotEmpty) {
                    return Container(
                      margin: const EdgeInsets.only(bottom: 24),
                       padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppPalette.error.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppPalette.error.withOpacity(0.2)),
                      ),
                      child: Row(
                         children: [
                          const Icon(Icons.error_outline_rounded, color: AppPalette.error, size: 20),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              error,
                              style: const TextStyle(color: AppPalette.error, fontSize: 13, fontWeight: FontWeight.w500),
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                }),

                Obx(() => CustomElevatedButton(
                  text: 'Register',
                  onPressed: _register,
                  isLoading: _authController.isLoading.value,
                )),
                
                const SizedBox(height: 32),
                
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                   children: [
                    const Text("Already have an account?", style: TextStyle(color: AppPalette.textSecondary)),
                    TextButton(
                       onPressed: () => Get.back(),
                      style: TextButton.styleFrom(foregroundColor: AppPalette.brandBlue),
                      child: const Text(
                        'Sign In',
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
