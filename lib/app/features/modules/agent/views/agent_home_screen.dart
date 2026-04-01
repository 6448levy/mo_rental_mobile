import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../../data/services/rate_plan_service.dart';
import '../../../widgets/sidebar_widget/sidebar_widget.dart';
import '../../car_details/views/car_detail_screen.dart';
import '../../promo_code/views/promo_code_screen.dart';
import '../../rate_plans/controllers/rate_plan_controller.dart';


import '../../../../core/themes/app_palette.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Ensure services are initialized
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!Get.isRegistered<RatePlanService>()) {
        Get.put(RatePlanService());
      }
      if (!Get.isRegistered<RatePlanController>()) {
        Get.put(RatePlanController());
      }
    });

    return SidebarWidget(
      initiallyOpen: false,
      child: _HomeContent(), // Content wrapped in sidebar
    );
  }
}

class _HomeContent extends StatelessWidget {
  _HomeContent();

  final GetStorage storage = GetStorage();

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> userData = storage.read('user_data') ?? {};

    return Scaffold(
      backgroundColor: AppPalette.pureWhite,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top padding to avoid overlap with sidebar toggle button
            const SizedBox(height: 70),

            // User Info Card
            Container(
              decoration: BoxDecoration(
                color: AppPalette.pureWhite,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppPalette.outline),
                boxShadow: [
                  BoxShadow(
                    color: AppPalette.cardShadow.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 28,
                      backgroundColor: AppPalette.brandBlue.withValues(alpha: 0.1),
                      child: Text(
                        userData['full_name'] != null
                            ? userData['full_name'][0].toUpperCase()
                            : 'G',
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: AppPalette.brandBlue,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            userData['full_name'] ?? 'Guest User',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppPalette.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            userData['email'] ?? 'Not logged in',
                            style: const TextStyle(
                              fontSize: 13,
                              color: AppPalette.textSecondary,
                            ),
                          ),
                          if (userData['status'] != null)
                            Container(
                              margin: const EdgeInsets.only(top: 6),
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                              decoration: BoxDecoration(
                                color: (userData['status'] == 'active' ? Colors.green : Colors.orange).withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                'Status: ${userData['status']}',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: userData['status'] == 'active'
                                      ? Colors.green.shade700
                                      : Colors.orange.shade700,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                    // Quick Access to Promo Codes
                    IconButton(
                      onPressed: () {
                        Get.to(() => const PromoCodeScreen());
                      },
                      icon: const Icon(Icons.local_offer, color: AppPalette.brandBlue),
                      tooltip: 'View Promo Codes',
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 30),

            const Text(
              "Find your perfect ride",
              style: TextStyle(
                fontSize: 26, 
                fontWeight: FontWeight.bold,
                color: AppPalette.textPrimary,
              ),
            ),
            const SizedBox(height: 20),

            SizedBox(
              height: 220,
              child: ListView(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                children: [
                  carCard(context,
                      "assets/images/campbell-3ZUsNJhi_Ik-unsplash.jpg", "BMW M4"),
                  carCard(context,
                      "assets/images/joshua-koblin-eqW1MPinEV4-unsplash.jpg",
                      "Mercedes AMG"),
                  carCard(context,
                      "assets/images/peter-broomfield-m3m-lnR90uM-unsplash.jpg",
                      "Audi R8"),
                ],
              ),
            ),

            // Quick Stats
            const SizedBox(height: 35),
            const Text(
              "Quick Stats",
              style: TextStyle(
                fontSize: 20, 
                fontWeight: FontWeight.bold,
                color: AppPalette.textSecondary,
              ),
            ),
            const SizedBox(height: 20),

            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 1.4, // Wider than tall — prevents overflow
              children: [
                _buildStatCard(
                  icon: Icons.calendar_today,
                  title: "Bookings",
                  value: "0",
                  color: Colors.blueAccent,
                ),
                _buildStatCard(
                  icon: Icons.local_offer,
                  title: "Active Promos",
                  value: "0",
                  color: AppPalette.brandBlue,
                  onTap: () => Get.to(() => const PromoCodeScreen()),
                ),
                _buildStatCard(
                  icon: Icons.favorite,
                  title: "Favorites",
                  value: "0",
                  color: Colors.redAccent,
                ),
                _buildStatCard(
                  icon: Icons.history,
                  title: "History",
                  value: "0",
                  color: Colors.greenAccent,
                ),
              ],
            ),

            // Promo Code Banner
            const SizedBox(height: 35),
            _buildPromoBanner(),

            // Recent Activity
            const SizedBox(height: 35),
            _buildRecentActivity(),
            const SizedBox(height: 80), // Space for FAB
          ],
        ),
      ),

      // Floating Action Button for Promo Codes
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Get.to(() => const PromoCodeScreen());
        },
        icon: const Icon(Icons.local_offer),
        label: const Text('Promo Codes'),
        backgroundColor: AppPalette.brandBlue,
        foregroundColor: AppPalette.pureWhite,
        elevation: 8,
        tooltip: 'View all promo codes',
      ),
    );
  }

  Widget carCard(BuildContext context, String img, String name) {
    return GestureDetector(
      onTap: () {
        Get.to(
          () => CarDetailsScreen(carName: name, image: img),
        );
      },
      child: Container(
        width: 250,
        margin: const EdgeInsets.only(right: 18),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: AppPalette.outline),
          image: DecorationImage(image: AssetImage(img), fit: BoxFit.cover),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.3),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Container(
          alignment: Alignment.bottomLeft,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: [
                Colors.black.withValues(alpha: 0.9), 
                Colors.black.withValues(alpha: 0.4),
                Colors.transparent
              ],
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: const TextStyle(
                  fontSize: 22, 
                  fontWeight: FontWeight.bold, 
                  color: AppPalette.pureWhite,
                ),
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  const Icon(Icons.star, color: Colors.orange, size: 14),
                  const SizedBox(width: 4),
                  Text(
                    "4.8 (120 reviews)",
                    style: TextStyle(color: AppPalette.pureWhite.withValues(alpha: 0.8), fontSize: 12),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppPalette.pureWhite,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppPalette.outline),
          boxShadow: [
            BoxShadow(
              color: AppPalette.cardShadow.withValues(alpha: 0.04),
              offset: const Offset(0, 4),
              blurRadius: 8,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, size: 24, color: color),
                ),
                const SizedBox(height: 8),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    value,
                    style: const TextStyle(
                      fontSize: 22, 
                      fontWeight: FontWeight.bold,
                      color: AppPalette.textPrimary,
                    ),
                    maxLines: 1,
                  ),
                ),
                const SizedBox(height: 4),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 11, 
                      color: AppPalette.textSecondary,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPromoBanner() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppPalette.pureWhite,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppPalette.brandBlue.withValues(alpha: 0.2)),
        gradient: LinearGradient(
          colors: [
            AppPalette.brandBlue.withValues(alpha: 0.05),
            Colors.transparent,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppPalette.brandBlue.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.local_offer_outlined,
              size: 32,
              color: AppPalette.brandBlue,
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Special Offers!',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppPalette.brandBlue,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Check active codes for exclusive discounts.',
                  style: TextStyle(
                    fontSize: 13,
                    color: AppPalette.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          ElevatedButton(
            onPressed: () {
              Get.to(() => const PromoCodeScreen());
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppPalette.brandBlue,
              foregroundColor: AppPalette.pureWhite,
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text('View', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentActivity() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Recent Activity",
          style: TextStyle(
            fontSize: 20, 
            fontWeight: FontWeight.bold,
            color: AppPalette.textSecondary,
          ),
        ),
        const SizedBox(height: 18),
        Container(
          decoration: BoxDecoration(
            color: AppPalette.pureWhite,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppPalette.outline),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Column(
              children: [
                _activityTile(
                  icon: Icons.local_offer,
                  color: Colors.greenAccent,
                  title: 'Promo Code Applied',
                  subtitle: 'SUMMER25 - 25% off',
                  time: 'Just now',
                ),
                const Divider(color: AppPalette.outline, indent: 64, endIndent: 16),
                _activityTile(
                  icon: Icons.car_rental,
                  color: Colors.blueAccent,
                  title: 'Car Booking',
                  subtitle: 'BMW M4 - 2 days',
                  time: '2 hours ago',
                ),
                const Divider(color: AppPalette.outline, indent: 64, endIndent: 16),
                _activityTile(
                  icon: Icons.payment,
                  color: Colors.purpleAccent,
                  title: 'Payment Received',
                  subtitle: 'Booking #ORD-12345',
                  time: '1 day ago',
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _activityTile({
    required IconData icon,
    required Color color,
    required String title,
    required String subtitle,
    required String time,
  }) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: color, size: 20),
      ),
      title: Text(
        title,
        style: const TextStyle(color: AppPalette.textPrimary, fontSize: 14, fontWeight: FontWeight.w600),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(color: AppPalette.textSecondary, fontSize: 12),
      ),
      trailing: Text(
        time,
        style: const TextStyle(color: AppPalette.textDisabled, fontSize: 10),
      ),
    );
  }
}
