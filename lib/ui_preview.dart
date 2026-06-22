// Throwaway preview harness — renders the redesigned screens directly (no auth,
// no backend) so they can be screenshotted. Run with:
//   flutter run -d windows -t lib/ui_preview.dart
// Safe to delete; not referenced by the app.
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'app/core/themes/app_palette.dart';
import 'app/core/themes/app_theme.dart';
import 'app/features/modules/car_details/views/car_detail_screen.dart';
import 'app/features/modules/car_listing/data/showcase_cars.dart';
import 'app/features/modules/car_listing/views/car_listing_screen.dart';
import 'app/features/modules/welcome_screens/onboarding_screens/views/onboarding_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  runApp(const _PreviewApp());
}

class _PreviewApp extends StatelessWidget {
  const _PreviewApp();

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.dark,
      home: const _Gallery(),
    );
  }
}

class _Gallery extends StatelessWidget {
  const _Gallery();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0E0E1A),
      body: Center(
        child: FittedBox(
          fit: BoxFit.contain,
          child: Container(
            color: const Color(0xFF0E0E1A),
            padding: const EdgeInsets.all(48),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _phone('Onboarding', const OnboardingScreen()),
                const SizedBox(width: 44),
                _phone('Car Listing', const CarListingScreen()),
                const SizedBox(width: 44),
                _phone('Car Detail', CarDetailsScreen(car: showcaseCars.first)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _phone(String label, Widget screen) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          width: 390,
          height: 780,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(36),
            border: Border.all(color: Colors.white24, width: 6),
            boxShadow: [
              BoxShadow(
                color: AppPalette.accent.withValues(alpha: 0.25),
                blurRadius: 60,
                spreadRadius: 4,
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(30),
            child: MediaQuery(
              // Give the embedded screens a phone-like text scale + insets.
              data: const MediaQueryData(size: Size(390, 780)),
              child: screen,
            ),
          ),
        ),
      ],
    );
  }
}
