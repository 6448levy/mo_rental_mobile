import 'dart:async';

import 'package:carrental/app/core/utils/app_logger.dart';
import 'package:carrental/app/core/utils/crash_reporter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'app/core/themes/app_theme.dart';
import 'app/core/widgets/responsive_shell.dart';
import 'app/routes/app_pages.dart';
import 'app/routes/app_routes.dart';

void main() {
  // Run inside a guarded zone so async errors are captured centrally.
  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();

    await GetStorage.init();
    await CrashReporter.instance.initialize();

    // Route Flutter framework errors to the crash reporter.
    FlutterError.onError = (details) {
      FlutterError.presentError(details);
      CrashReporter.instance.recordError(details.exception, details.stack, fatal: true);
    };

    runApp(const MoRentalApp());
  }, (error, stack) {
    // Uncaught async errors.
    CrashReporter.instance.recordError(error, stack, fatal: true);
  });
}

class MoRentalApp extends StatelessWidget {
  const MoRentalApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: "MoRental",
      
      // Theme setup
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.dark,

      // Navigation setup
      initialRoute: AppRoutes.login,
      getPages: AppPages.pages,

      // Responsive shell — centres the mobile UI on large screens so the app
      // fits any screen size (phone, tablet, laptop, desktop, web).
      builder: (context, child) => ResponsiveShell(child: child ?? const SizedBox.shrink()),

      // Enable GetX logging in debug mode
      enableLog: true,
      logWriterCallback: (String text, {bool isError = false}) {
        if (isError || Get.isLogEnable) AppLogger.d(text);
      },
    );
  }
}