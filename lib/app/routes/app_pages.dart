// lib/app/routes/app_pages.dart
import 'package:get/get.dart';
import '../bindings/app_bindings.dart';
import '../features/modules/auth/views/login_screen.dart';
import '../features/modules/auth/views/register_screen.dart';
import '../features/modules/auth/views/verify_email_screen.dart';
import '../features/modules/bindings/rate_plan_binding.dart';
import '../features/modules/rate_plans/views/rate_plans_screen.dart';
import '../features/modules/welcome_screens/onboarding_screens/views/onboarding_screen.dart';
import '../features/modules/welcome_screens/splash_screen/views/splash_screen.dart';
import '../features/widgets/agent_botton_nav/agent_botton_nav_tabs.dart';
import 'app_routes.dart';

// Existing modules
import '../features/modules/promo_code/views/promo_code_screen.dart';
import '../features/modules/driver/views/driver_view.dart';
import '../features/modules/driver/bindings/driver_binding.dart';
import '../features/modules/drivers/views/drivers_view.dart';
import '../features/modules/drivers/bindings/drivers_binding.dart';

// ── New booking modules
import '../features/modules/booking/views/booking_overview_page.dart';
import '../features/modules/booking/views/add_card_page.dart';
import '../features/modules/booking/views/booking_success_page.dart';
import '../../presentation/pages/bookings_page.dart'; // New Clean Arch version
// import '../features/modules/booking/views/my_bookings_page.dart'; // Old GetX version
import '../features/modules/booking/bindings/booking_binding.dart';

class AppPages {
  static final pages = [
    GetPage(
      name: AppRoutes.splash,
      page: () => const SplashScreen(),
    ),
    GetPage(
      name: AppRoutes.onboarding,
      page: () => const OnboardingScreen(),
    ),
    GetPage(
      name: AppRoutes.login,
      page: () => const LoginScreen(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: AppRoutes.register,
      page: () => const RegisterScreen(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: AppRoutes.verifyEmail,
      page: () => const VerifyEmailScreen(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: AppRoutes.main,
      page: () => const MainNavigation(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: AppRoutes.ratePlans,
      page: () => const RatePlansScreen(),
      binding: RatePlanBinding(),
    ),
    GetPage(
      name: AppRoutes.promoCodes,
      page: () => PromoCodeScreen(),
    ),
    GetPage(
      name: AppRoutes.driver,
      page: () => const DriverView(),
      binding: DriverBinding(),
    ),

    // ── Driver discovery (with BookingBinding merged)
    GetPage(
      name: AppRoutes.drivers,
      page: () => const DriversView(),
      bindings: [DriversBinding(), BookingBinding()],
    ),

    // ── Booking flow pages (all share BookingBinding)
    GetPage(
      name: AppRoutes.bookingOverview,
      page: () => const BookingOverviewPage(),
      binding: BookingBinding(),
    ),
    GetPage(
      name: AppRoutes.addCard,
      page: () => const AddCardPage(),
      binding: BookingBinding(),
    ),
    GetPage(
      name: AppRoutes.bookingSuccess,
      page: () => const BookingSuccessPage(),
      binding: BookingBinding(),
    ),
    GetPage(
      name: AppRoutes.myBookings,
      page: () => const MyBookingsPage(),
      binding: BookingBinding(),
    ),
  ];
}