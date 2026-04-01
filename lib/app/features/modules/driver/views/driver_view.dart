import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:carrental/app/core/themes/app_palette.dart';
import '../controllers/driver_controller.dart';

import '../widgets/driver_profile_header.dart';
import '../widgets/ride_hailing_content.dart';
import '../widgets/car_rental_content.dart';
import '../widgets/earnings_card.dart';
import '../widgets/document_list.dart';

class DriverView extends GetView<DriverController> {
  const DriverView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppPalette.pureWhite,
      child: SafeArea(
        child: Obx(() {
          // Show loading spinner while profile is loading
          if (controller.isLoadingProfile.value &&
              controller.driverProfile.value == null) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                   CircularProgressIndicator(color: AppPalette.brandBlue),
                  SizedBox(height: 16),
                  Text('Loading driver profile...', style: TextStyle(color: AppPalette.textSecondary)),
                ],
              ),
            );
          }

          // Show error state
          if (controller.profileError.value.isNotEmpty &&
              controller.driverProfile.value == null) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline,
                        color: AppPalette.error, size: 48),
                    const SizedBox(height: 16),
                    Text(
                      controller.profileError.value,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: AppPalette.error),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: controller.refreshProfile,
                      style: ElevatedButton.styleFrom(backgroundColor: AppPalette.brandBlue),
                      icon: const Icon(Icons.refresh, color: AppPalette.pureWhite),
                      label: const Text('Retry', style: TextStyle(color: AppPalette.pureWhite)),
                    ),
                  ],
                ),
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: controller.refreshProfile,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 1. Driver Profile Section (real API data)
                  Obx(() => DriverProfileHeader(
                        name: controller.driverName,
                        phoneNumber: controller.baseCity.isNotEmpty
                            ? '📍 ${controller.baseCity}, ${controller.driverProfile.value?.baseCountry ?? ''}'
                            : 'Location not set',
                        rating: controller.driverRating,
                        ratingCount: controller.driverProfile.value?.ratingCount ?? 0,
                        isVerified: controller.isVerified,
                        profileImageUrl: controller.profileImageUrl,
                        bio: controller.bio,
                        hourlyRate: controller.hourlyRate,
                        yearsExperience: controller.yearsExperience,
                        languages: controller.languages,
                        isLoading: controller.isLoadingProfile.value,
                      )),

                  const SizedBox(height: 24),

                  // 2. Mode Selector
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: AppPalette.brandBlue.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Obx(() => Row(
                          children: [
                            _buildModeButton(
                              title: "Ride-Hailing",
                              icon: Icons.local_taxi,
                              isSelected: controller.isRideHailingMode.value,
                              onTap: () {
                                if (!controller.isRideHailingMode.value) {
                                  controller.toggleMode();
                                }
                              },
                            ),
                            _buildModeButton(
                              title: "Car Rental",
                              icon: Icons.directions_car,
                              isSelected: !controller.isRideHailingMode.value,
                              onTap: () {
                                if (controller.isRideHailingMode.value) {
                                  controller.toggleMode();
                                }
                              },
                            ),
                          ],
                        )),
                  ),

                  const SizedBox(height: 24),

                  // 3. Online/Offline Switch + Mode Content
                  Obx(() {
                    if (controller.isRideHailingMode.value) {
                      return Column(
                        children: [
                          _buildOnlineSwitch(),
                          const SizedBox(height: 24),
                          const RideHailingContent(),
                        ],
                      );
                    }
                    return const CarRentalContent();
                  }),

                  const SizedBox(height: 24),
                  const EarningsCard(),

                  const SizedBox(height: 24),
                  const DocumentList(),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildModeButton({
    required String title,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? AppPalette.pureWhite : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: AppPalette.brandBlue.withOpacity(0.1),
                      blurRadius: 5,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : [],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: isSelected ? AppPalette.brandBlue : AppPalette.textSecondary,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  color: isSelected ? AppPalette.brandBlue : AppPalette.textSecondary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOnlineSwitch() {
    return Obx(() => Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: controller.isOnline.value
                ? Colors.green.shade50
                : AppPalette.pureWhite,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: controller.isOnline.value
                  ? Colors.green.withOpacity(0.3)
                  : AppPalette.outline,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color:
                          controller.isOnline.value ? Colors.green.shade600 : AppPalette.textDisabled,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.power_settings_new,
                        color: Colors.white, size: 20),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        controller.isOnline.value
                            ? "You are Online"
                            : "You are Offline",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: AppPalette.textPrimary,
                        ),
                      ),
                      Text(
                        controller.isOnline.value
                            ? "Receiving requests"
                            : "Go online to start",
                        style: TextStyle(
                          color: AppPalette.textSecondary,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Switch(
                value: controller.isOnline.value,
                onChanged: controller.toggleOnlineStatus,
                activeColor: Colors.green.shade600,
              ),
            ],
          ),
        ));
  }
}
