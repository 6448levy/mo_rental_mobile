import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../modules/agent/views/agent_home_screen.dart';
import '../../modules/auth/controllers/auth_controller.dart';
import '../../modules/bindings/rate_plan_binding.dart';
import '../../modules/driver/views/driver_view.dart';
import '../../modules/driver/bindings/driver_binding.dart'; // Added
import '../../modules/car_listing/views/car_listing_screen.dart';
import '../../modules/profile/views/profile_screen.dart';
import '../../modules/rate_plans/views/rate_plans_screen.dart';
import '../../modules/chat/pages/chat_screen.dart';
import 'package:carrental/app/core/themes/app_palette.dart';



class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 0;
  final GetStorage _storage = GetStorage();
  final AuthController _authController = Get.find<AuthController>();
  
  // Create instances of Bindings
  final RatePlanBinding _ratePlanBinding = RatePlanBinding();
  final DriverBinding _driverBinding = DriverBinding(); // Added

  @override
  void initState() {
    super.initState();
    
    // Initialize dependencies immediately so they are available for the first build
    print('🔄 Initializing RatePlan dependencies in MainNavigation');
    _ratePlanBinding.dependencies();
    print('🔄 Initializing Driver dependencies in MainNavigation');
    _driverBinding.dependencies(); 
    
    _checkAuth();
  }

  void _checkAuth() {
    if (!_authController.isAuthenticated) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Get.offAllNamed('/login');
        Get.snackbar(
          'Session Expired',
          'Please login again',
          backgroundColor: Colors.orange,
          colorText: Colors.white,
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final userData = _storage.read('user_data') ?? {};

    // Define screens and titles inside build to support Hot Reload
    final List<Widget> screens = [
      HomeScreen(),
      CarListingScreen(),
      const DriverView(),
      RatePlansScreen(),
      const ChatScreen(driverName: 'Driver Match', vehicleInfo: 'Available Models',), // NEW: Replaces profile for now or added alongside
      ProfileScreen(),
    ];

    final List<String> appBarTitles = [
      'Home',
      'Cars',
      'Driver',
      'Rate Plans',
      'Chat',
      'Profile',
    ];

    return Scaffold(
      backgroundColor: AppPalette.pureWhite,
      appBar: AppBar(
        backgroundColor: AppPalette.pureWhite,
        elevation: 0,
        centerTitle: false,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              appBarTitles[_currentIndex],
              style: const TextStyle(color: AppPalette.textPrimary, fontWeight: FontWeight.bold),
            ),
            if (_currentIndex == 0 && userData['full_name'] != null)
              Text(
                "Welcome, ${userData['full_name']}!",
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.normal, color: AppPalette.textSecondary),
              ),
          ],
        ),
        actions: [
          if (_currentIndex != 5) // Profile is now 5
            IconButton(
              icon: const Icon(Icons.logout, color: AppPalette.textPrimary),
              onPressed: () {
                _authController.logout();
              },
              tooltip: 'Logout',
            ),
        ],
      ),
      body: screens[_currentIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) => setState(() => _currentIndex = index),
          backgroundColor: AppPalette.pureWhite,
          selectedItemColor: AppPalette.brandBlue,
          unselectedItemColor: AppPalette.textDisabled,
          type: BottomNavigationBarType.fixed,
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
          unselectedLabelStyle: const TextStyle(fontSize: 12),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home_rounded),
              label: "Home",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.directions_car_outlined),
              activeIcon: Icon(Icons.directions_car_rounded),
              label: "Cars",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_search_outlined),
              activeIcon: Icon(Icons.person_search_rounded),
              label: "Driver",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.monetization_on_outlined),
              activeIcon: Icon(Icons.monetization_on_rounded),
              label: "Rates",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.chat_bubble_outline),
              activeIcon: Icon(Icons.chat_bubble_rounded),
              label: "Chat",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline_rounded),
              activeIcon: Icon(Icons.person_rounded),
              label: "Profile",
            ),
          ],
        ),
      ),
    );
  }
}

