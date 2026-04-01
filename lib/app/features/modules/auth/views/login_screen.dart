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
    print('\n📱 LOGIN SCREEN INITIALIZED');
    print('📱 Screen size: ${Get.size}');
    print('📱 Theme: ${Get.theme.brightness}');
    print('📱 Authenticated: ${_authController.isAuthenticated}');
    print('📱 Pending verification: ${_authController.pendingVerificationEmail}');
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

      print('\n👤 USER LOGIN ATTEMPT:');
      print('📧 Email: $email');
      print('🔑 Password length: ${password.length}');
      print('📱 Device: ${GetPlatform.isMobile ? 'Mobile' : 'Web'}');

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
    print('🔗 Forgot password clicked');
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
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 60),
              
              // Animated Logo Section
              TweenAnimationBuilder<double>(
                duration: const Duration(milliseconds: 800),
                tween: Tween(begin: 0.0, end: 1.0),
                builder: (context, value, child) {
                  return Opacity(
                    opacity: value,
                    child: Transform.translate(
                      offset: Offset(0, 20 * (1 - value)),
                      child: child,
                    ),
                  );
                },
                child: Column(
                  children: [
                    Image.asset(
                      'assets/images/logo.png',
                      height: 150,
                      errorBuilder: (context, error, stackTrace) =>
                        Icon(Icons.car_rental_rounded, size: 120, color: theme.primaryColor),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Welcome Back',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.displaySmall?.copyWith(
                        fontWeight: FontWeight.w800,
                        color: AppPalette.textPrimary,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Login to your account',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: AppPalette.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 48),
              
              // Login Form
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    CustomTextField(
                      controller: _emailController,
                      labelText: 'Email Address',
                      hintText: 'Enter your email',
                      keyboardType: TextInputType.emailAddress,
                      validator: Validators.validateEmail,
                      prefixIcon: const Icon(Icons.email_outlined),
                    ),
                    const SizedBox(height: 20),
                    Obx(() => CustomTextField(
                      controller: _passwordController,
                      labelText: 'Password',
                      hintText: 'Enter your password',
                      obscureText: !_showPassword.value,
                      validator: (value) => value == null || value.isEmpty ? 'Password is required' : null,
                      prefixIcon: const Icon(Icons.lock_outlined),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _showPassword.value ? Icons.visibility_off : Icons.visibility,
                          color: theme.iconTheme.color?.withOpacity(0.5) ?? Colors.grey,
                          size: 20,
                        ),
                        onPressed: () => _showPassword.value = !_showPassword.value,
                      ),
                    )),
                    
                    const SizedBox(height: 8),
                    
                    // Forgot Password
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: _forgotPassword,
                        style: TextButton.styleFrom(
                          foregroundColor: AppPalette.brandBlue,
                        ),
                        child: const Text('Forgot Password?', style: TextStyle(fontWeight: FontWeight.w600)),
                      ),
                    ),
                    
                    const SizedBox(height: 16),

                    // Error Display (Premium Dark Mode Alert)
                    Obx(() {
                      if (_authController.errorMessage.value.isNotEmpty) {
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
                                  _authController.errorMessage.value,
                                  style: const TextStyle(color: AppPalette.error, fontSize: 13, fontWeight: FontWeight.w500),
                                ),
                              ),
                            ],
                          ),
                        );
                      }
                      return const SizedBox.shrink();
                    }),
                    
                    // Controller Loading Stage
                    Obx(() => CustomElevatedButton(
                      text: 'Login',
                      onPressed: _login,
                      isLoading: _authController.isLoading.value,
                    )),
                  ],
                ),
              ),
              
              const SizedBox(height: 32),
              
              // Register Link
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                   Text("Don't have an account?", style: theme.textTheme.bodyMedium?.copyWith(color: AppPalette.textSecondary)),
                  TextButton(
                     onPressed: () => Get.toNamed('/register'),
                    style: TextButton.styleFrom(foregroundColor: AppPalette.brandBlue),
                    child: const Text(
                      'Register',
                      style: TextStyle(fontWeight: FontWeight.w700),
                    ),
                  ),
                ],
              ),
              
              // Debug Info (Collapsible & Subtle)
              Obx(() {
                if (_debugInfo.value.isNotEmpty) {
                  return Container(
                    margin: const EdgeInsets.symmetric(vertical: 24),
                    decoration: BoxDecoration(
                      color: AppPalette.brandBlue.withOpacity(0.04),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppPalette.outline),
                    ),
                    child: ExpansionTile(
                      shape: const RoundedRectangleBorder(side: BorderSide.none),
                      collapsedShape: const RoundedRectangleBorder(side: BorderSide.none),
                      title: const Text(
                        'Debug Information',
                        style: TextStyle(color: AppPalette.textSecondary, fontSize: 12, fontWeight: FontWeight.bold),
                      ),
                       leading: const Icon(Icons.bug_report_outlined, color: AppPalette.textDisabled, size: 18),
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                          child: SelectableText(
                            _debugInfo.value,
                             style: const TextStyle(color: AppPalette.textDisabled, fontSize: 11, fontFamily: 'monospace'),
                          ),
                        ),
                      ],
                    ),
                  );
                }
                return const SizedBox.shrink();
              }),

              // Footer Info
              const SizedBox(height: 20),
              Center(
                child: Text(
                  'Connected to MoRental Cloud v1.0',
                   style: theme.textTheme.bodySmall?.copyWith(fontSize: 10, letterSpacing: 0.5, color: AppPalette.textDisabled),
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
