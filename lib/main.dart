import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'package:provider/provider.dart';
import 'data/services/booking_service.dart' as clean_service;
import 'data/repositories/booking_repository.dart';
import 'presentation/providers/booking_provider.dart';

import 'app/core/themes/app_theme.dart';
import 'app/routes/app_pages.dart';
import 'app/routes/app_routes.dart';

void main() async {
  // Initialize GetStorage
  await GetStorage.init();
  
  final bookingService = clean_service.BookingService();
  final bookingRepository = BookingRepository(service: bookingService);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => BookingProvider(repository: bookingRepository),
        ),
      ],
      child: const MoRentalApp(),
    ),
  );
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
      
      // Enable GetX logging in debug mode
      enableLog: true,
      logWriterCallback: (String text, {bool isError = false}) {
        if (isError || Get.isLogEnable) print(text);
      },
    );
  }
}