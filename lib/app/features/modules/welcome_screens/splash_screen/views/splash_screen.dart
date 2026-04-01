import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../core/themes/app_palette.dart';
import '../../../../../routes/app_routes.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    Timer(const Duration(seconds: 5), () {
      // Navigate to onboarding screen and remove splash from stack
      Get.offNamed(AppRoutes.onboarding);
    });
  }

  @override
  Widget build(BuildContext context) {
    // The splash screen background must be white
    return Scaffold(
      backgroundColor: AppPalette.pureWhite,
      body: Center(
        // The splash image must be centered and properly scaled
        child: Image.asset(
          'assets/images/splash_image.png',
          fit: BoxFit.contain,
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          errorBuilder: (context, error, stackTrace) {
            // Fallback in case the user hasn't placed the splash_image.png file in the assets folder yet
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.car_rental, size: 80, color: AppPalette.brandBlue),
                const SizedBox(height: 16),
                Text(
                  "MO_RENTAL",
                  style: TextStyle(
                    color: AppPalette.brandBlue,
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.5,
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
