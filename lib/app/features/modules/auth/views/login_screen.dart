import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';
import 'package:carrental/app/core/themes/app_palette.dart';
import 'package:carrental/app/core/utils/validators.dart';
import 'package:carrental/app/features/widgets/custom_text_field.dart/custom_text_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final AuthController _authController = Get.find<AuthController>();

  final RxBool _showPassword = false.obs;
  final RxString _debugInfo = ''.obs;

  @override
  void initState() {
    super.initState();
    // Clear any previous errors
    _authController.errorMessage.value = '';

    // Print debug info
    debugPrint('\n📱 LOGIN SCREEN INITIALIZED');
    debugPrint('📱 Screen size: ${Get.size}');
    debugPrint('📱 Theme: ${Get.theme.brightness}');
    debugPrint('📱 Authenticated: ${_authController.isAuthenticated}');
    debugPrint(
        '📱 Pending verification: ${_authController.pendingVerificationEmail}');
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    _authController.errorMessage.value = '';
    _debugInfo.value = '';

    if (_formKey.currentState!.validate()) {
      final email = _emailController.text.trim();
      final password = _passwordController.text;

      // Update debug info
      _debugInfo.value = '''
🔵 LOGIN ATTEMPT:
📧 Email: $email
🔑 Password: ${'*' * password.length}
⏰ Time: ${DateTime.now()}
      ''';

      debugPrint('\n👤 USER LOGIN ATTEMPT:');
      debugPrint('📧 Email: $email');
      debugPrint('🔑 Password length: ${password.length}');
      debugPrint('📱 Device: ${GetPlatform.isMobile ? 'Mobile' : 'Web'}');

      final response = await _authController.login(
        email: email,
        password: password,
      );

      // Update debug info with response
      _debugInfo.value += '''
      
🟡 LOGIN RESPONSE:
✅ Success: ${response.success}
📝 Message: ${response.message}
📊 Data: ${response.data != null ? 'Received' : 'None'}
❌ Error: ${response.error ?? 'None'}
      ''';
    }
  }

  void _forgotPassword() {
    debugPrint('🔗 Forgot password clicked');
    Get.snackbar(
      'Forgot Password',
      'Password reset functionality coming soon',
      backgroundColor: Colors.blue,
      colorText: Colors.white,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC), // Subtle off-white background
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420), // Max width for the card to look like a clean web portal on larger screens
            child: Container(
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 30,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Geometric Logo
                    const Center(
                      child: Icon(
                        Icons.hexagon_outlined, // Stylized geometric logo
                        size: 48,
                        color: AppPalette.brandBlue,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Header
                    const Text(
                      'Welcome Back',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF1A1A1A),
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Subtitle
                    const Text(
                      'Sign in or create your account.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 15,
                        color: Color(0xFF666666),
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Error Display
                    Obx(() {
                      if (_authController.errorMessage.value.isNotEmpty) {
                        return Container(
                          margin: const EdgeInsets.only(bottom: 24),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppPalette.error.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                                color: AppPalette.error.withValues(alpha: 0.2)),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.error_outline_rounded,
                                  color: AppPalette.error, size: 20),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  _authController.errorMessage.value,
                                  style: const TextStyle(
                                      color: AppPalette.error,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                            ],
                          ),
                        );
                      }
                      return const SizedBox.shrink();
                    }),

                    // Email Field
                    const Text(
                      'Email or Username',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF4A4A4A),
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      validator: Validators.validateEmail,
                      decoration: InputDecoration(
                        hintText: 'Email or Username',
                        hintStyle: const TextStyle(color: Color(0xFFA0A0A0)),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: AppPalette.brandBlue, width: 2),
                        ),
                        filled: true,
                        fillColor: const Color(0xFFFDFDFD),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Password Field
                    const Text(
                      'Password',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF4A4A4A),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Obx(() => TextFormField(
                          controller: _passwordController,
                          obscureText: !_showPassword.value,
                          validator: (value) => value == null || value.isEmpty
                              ? 'Password is required'
                              : null,
                          decoration: InputDecoration(
                            hintText: 'Password',
                            hintStyle: const TextStyle(color: Color(0xFFA0A0A0)),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(color: AppPalette.brandBlue, width: 2),
                            ),
                            filled: true,
                            fillColor: const Color(0xFFFDFDFD),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _showPassword.value
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                color: const Color(0xFFA0A0A0),
                                size: 20,
                              ),
                              onPressed: () =>
                                  _showPassword.value = !_showPassword.value,
                            ),
                          ),
                        )),

                    // Forgot Password
                    Align(
                      alignment: Alignment.centerLeft,
                      child: TextButton(
                        onPressed: _forgotPassword,
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 0),
                          foregroundColor: AppPalette.brandBlue,
                        ),
                        child: const Text('Forgot Password?',
                            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Sign In Button
                    Obx(() => ElevatedButton(
                          onPressed: _authController.isLoading.value ? null : _login,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppPalette.brandBlue,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: _authController.isLoading.value
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                  ),
                                )
                              : const Text(
                                  'Sign In',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                        )),
                    const SizedBox(height: 24),

                    // Separator
                    Row(
                      children: [
                        const Expanded(child: Divider(color: Color(0xFFE0E0E0), thickness: 1)),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            'or',
                            style: TextStyle(
                              color: Colors.grey.shade500,
                              fontSize: 14,
                            ),
                          ),
                        ),
                        const Expanded(child: Divider(color: Color(0xFFE0E0E0), thickness: 1)),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Create Account Section
                    const Text(
                      'New here?',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF666666),
                      ),
                    ),
                    const SizedBox(height: 12),
                    OutlinedButton(
                      onPressed: () => Get.toNamed('/register'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppPalette.brandBlue,
                        side: const BorderSide(color: AppPalette.brandBlue, width: 1.5),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Create an Account',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Social Logins
                    _buildSocialButton(
                      text: 'Continue with Google',
                      icon: Icons.g_mobiledata, // Placeholder for Google logo
                      iconColor: Colors.red,
                      onTap: () {},
                    ),
                    const SizedBox(height: 12),
                    _buildSocialButton(
                      text: 'Continue with Apple',
                      icon: Icons.apple,
                      iconColor: Colors.black,
                      onTap: () {},
                    ),
                    const SizedBox(height: 12),
                    _buildSocialButton(
                      text: 'Continue with MoRental',
                      icon: Icons.car_rental,
                      iconColor: AppPalette.brandBlue,
                      onTap: () {},
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSocialButton({
    required String text,
    required IconData icon,
    required Color iconColor,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(100),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0xFFE0E0E0)),
          borderRadius: BorderRadius.circular(100), // Pill shape
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: iconColor, size: 24),
            const SizedBox(width: 12),
            Text(
              text,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFF333333),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
