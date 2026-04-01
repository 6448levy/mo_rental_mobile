import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../core/themes/app_palette.dart';
import '../../../auth/views/login_screen.dart';
import '../../../auth/views/register_screen.dart';
import '../../../../../routes/app_routes.dart';

class FinalOnboardPage extends StatelessWidget {
  const FinalOnboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppPalette.pureWhite,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Branding Logo
            Image.asset(
              'assets/images/logo.png',
              height: 50,
              errorBuilder: (context, error, stackTrace) => 
                const Icon(Icons.car_rental, size: 100, color: AppPalette.brandBlue),
            ),
            const SizedBox(height: 40),

            const Text(
              "Create an account\nand get started!",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: AppPalette.textPrimary,
              ),
            ),
            const SizedBox(height: 30),

            // Login Button
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppPalette.brandBlue,
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
              onPressed: () {
                // Navigate to LoginScreen using named route to trigger binding
                Get.toNamed(AppRoutes.login);
              },
              child: const Text(
                "Login",
                style: TextStyle(
                  fontSize: 18,
                  color: AppPalette.pureWhite,
                ),
              ),
            ),

            const SizedBox(height: 15),

            // Register Button
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                side: const BorderSide(color: AppPalette.brandBlue, width: 2),
              ),
              onPressed: () {
                // Navigate to RegisterScreen using named route to trigger binding
                Get.toNamed(AppRoutes.register);
              },
              child: const Text(
                "Create an account",
                style: TextStyle(
                  fontSize: 18,
                  color: AppPalette.brandBlue,
                ),
              ),
            ),
              ],
            ),
          ),
        ),
      ),
    ),
    );
  }
}
