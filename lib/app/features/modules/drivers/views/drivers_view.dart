import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';
import '../controllers/drivers_controller.dart';
import '../../../data/models/driver/driver_profile_model.dart';
import 'package:carrental/app/core/themes/app_palette.dart';
import '../../../widgets/custom_text_field.dart/custom_text_field.dart';

class DriversView extends GetView<DriversController> {
  const DriversView({super.key});

  // Theme constants - replaced by AppPalette

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppPalette.pureWhite,
      body: CustomScrollView(
        slivers: [
          // ── Sticky header ──────────────────────────────────────────────────
          SliverAppBar(
            pinned: true,
            backgroundColor: AppPalette.brandBlue,
            foregroundColor: AppPalette.pureWhite,
            elevation: 0,
            expandedHeight: 140,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded,
                  size: 20, color: AppPalette.pureWhite),
              onPressed: () => Get.back(),
            ),
            actions: [
              Obx(() => IconButton(
                    icon: controller.isLoading.value
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: AppPalette.pureWhite,
                            ),
                          )
                        : const Icon(Icons.refresh_rounded,
                            color: AppPalette.pureWhite),
                    onPressed: () => controller.fetchDrivers(),
                  )),
            ],
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: const EdgeInsets.fromLTRB(56, 0, 56, 16),
              title: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Find a Driver',
                    style: GoogleFonts.poppins(
                      color: AppPalette.pureWhite,
                      fontWeight: FontWeight.w800,
                      fontSize: 20,
                      letterSpacing: -0.5,
                    ),
                  ),
                  Obx(() => Text(
                        controller.drivers.isEmpty
                            ? 'Looking for drivers...'
                            : '${controller.drivers.length} drivers available',
                        style: GoogleFonts.poppins(
                          color: AppPalette.pureWhite.withValues(alpha: 0.7),
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                        ),
                      )),
                ],
              ),
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppPalette.brandBlue,
                      Color(0xFF1E88E5), // Lighter blue
                      Color(0xFF1976D2), // Medium blue
                    ],
                  ),
                ),
                child: Stack(
                  children: [
                    Positioned(
                      right: -50,
                      top: -20,
                      child: Icon(
                        Icons.local_taxi_rounded,
                        size: 200,
                        color: AppPalette.pureWhite.withValues(alpha: 0.05),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // ── Status filter bar ──────────────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
              child: Obx(() => Row(
                    children: [
                      _filterChip(
                          'All', controller.filterStatus.value == 'all', 'all'),
                      const SizedBox(width: 10),
                      _filterChip('Online',
                          controller.filterStatus.value == 'online', 'online'),
                      const SizedBox(width: 10),
                      _filterChip(
                          'Offline',
                          controller.filterStatus.value == 'offline',
                          'offline'),
                    ],
                  )),
            ),
          ),

          // ── Driver list ────────────────────────────────────────────────────
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
            sliver: Obx(() {
              if (controller.isLoading.value && controller.drivers.isEmpty) {
                return SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (_, __) => _buildShimmerCard(),
                    childCount: 4,
                  ),
                );
              }

              if (controller.errorMessage.isNotEmpty &&
                  controller.drivers.isEmpty) {
                return SliverToBoxAdapter(child: _buildErrorState());
              }

              final filtered = controller.filteredDrivers;

              if (filtered.isEmpty) {
                return SliverToBoxAdapter(child: _buildEmptyState());
              }

              return SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final driver = filtered[index];
                    return _DriverCard(
                      driver: driver,
                      onBook: () => controller.bookDriver(driver),
                    );
                  },
                  childCount: filtered.length,
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _filterChip(String label, bool selected, String value) {
    return GestureDetector(
      onTap: () => controller.filterStatus.value = value,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutCubic,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: selected ? AppPalette.brandBlue : AppPalette.pureWhite,
          borderRadius: BorderRadius.circular(16),
          boxShadow: selected
              ? [
                  BoxShadow(
                    color: AppPalette.brandBlue.withValues(alpha: 0.2),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  )
                ]
              : [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.03),
                    blurRadius: 5,
                    offset: const Offset(0, 2),
                  )
                ],
          border: Border.all(
            color: selected
                ? AppPalette.brandBlue
                : AppPalette.brandBlue.withValues(alpha: 0.1),
          ),
        ),
        child: Text(
          label,
          style: GoogleFonts.poppins(
            color: selected ? AppPalette.pureWhite : AppPalette.textSecondary,
            fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
            fontSize: 13,
          ),
        ),
      ),
    );
  }

  Widget _buildShimmerCard() {
    return Shimmer.fromColors(
      baseColor: const Color(0xFFF1F5F9),
      highlightColor: AppPalette.pureWhite,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        height: 200,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 40),
          Container(
            width: 90,
            height: 90,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppPalette.brandBlue.withValues(alpha: 0.1),
            ),
            child: const Icon(Icons.person_search,
                size: 44, color: AppPalette.brandBlue),
          ),
          const SizedBox(height: 20),
          Text(
            'No Drivers Available',
            style: GoogleFonts.poppins(
              color: AppPalette.textPrimary,
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Try refreshing or change the filter',
            style: GoogleFonts.poppins(
                color: AppPalette.textSecondary, fontSize: 13),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => controller.fetchDrivers(),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppPalette.brandBlue,
              foregroundColor: AppPalette.pureWhite,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14)),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              elevation: 0,
            ),
            icon: const Icon(Icons.refresh, size: 18),
            label: Text('Refresh',
                style: GoogleFonts.poppins(fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 40),
            const Icon(Icons.wifi_off_rounded,
                size: 64, color: Colors.redAccent),
            const SizedBox(height: 20),
            Text(
              'Connection Failed',
              style: GoogleFonts.poppins(
                color: AppPalette.textPrimary, // Changed from Colors.white
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              controller.errorMessage.value,
              style: GoogleFonts.poppins(
                  color: AppPalette.textSecondary, fontSize: 13),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => controller.fetchDrivers(),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppPalette.brandBlue,
                foregroundColor: AppPalette.pureWhite,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14)),
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                elevation: 0,
              ),
              icon: const Icon(Icons.refresh, size: 18),
              label: Text('Try Again',
                  style: GoogleFonts.poppins(fontWeight: FontWeight.w700)),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Driver Card — extracted as separate StatelessWidget for performance ────────

class _DriverCard extends StatelessWidget {
  final DriverProfileModel driver;
  final VoidCallback onBook;

  const _DriverCard({required this.driver, required this.onBook});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: AppPalette.pureWhite,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: AppPalette.brandBlue.withValues(alpha: 0.08),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
        border: Border.all(
          color: AppPalette.brandBlue.withValues(alpha: 0.08),
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Avatar Section with Glossy Effect
                  Stack(
                    children: [
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            colors: [
                              AppPalette.brandBlue.withValues(alpha: 0.1),
                              AppPalette.brandBlue.withValues(alpha: 0.02),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          border: Border.all(
                            color: AppPalette.brandBlue.withValues(alpha: 0.1),
                            width: 1,
                          ),
                        ),
                        child: ClipOval(
                          child: driver.profileImage != null
                              ? Image.network(
                                  driver.profileImage!,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) => _avatarFallback(),
                                )
                              : _avatarFallback(),
                        ),
                      ),
                      Positioned(
                        right: 4,
                        bottom: 4,
                        child: Container(
                          width: 18,
                          height: 18,
                          decoration: BoxDecoration(
                            color: driver.isAvailable
                                ? Colors.green.shade500
                                : Colors.grey.shade400,
                            shape: BoxShape.circle,
                            border: Border.all(
                                color: AppPalette.pureWhite, width: 3),
                            boxShadow: [
                              BoxShadow(
                                color: (driver.isAvailable
                                        ? Colors.green
                                        : Colors.grey)
                                    .withValues(alpha: 0.3),
                                blurRadius: 4,
                                spreadRadius: 1,
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 18),

                  // Driver Details
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                driver.displayName,
                                style: GoogleFonts.poppins(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w700,
                                  color: AppPalette.textPrimary,
                                  letterSpacing: -0.3,
                                ),
                              ),
                            ),
                            // Glassmorphism Price Tag
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: AppPalette.brandBlue.withValues(alpha: 0.08),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                    color: AppPalette.brandBlue
                                        .withValues(alpha: 0.1)),
                              ),
                              child: Text(
                                '\$${driver.hourlyRate.toStringAsFixed(0)}/hr',
                                style: GoogleFonts.poppins(
                                  color: AppPalette.brandBlue,
                                  fontWeight: FontWeight.w800,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            const Icon(Icons.star_rounded,
                                color: Colors.amber, size: 18),
                            const SizedBox(width: 4),
                            Text(
                              driver.ratingAverage.toStringAsFixed(1),
                              style: GoogleFonts.poppins(
                                color: AppPalette.textPrimary,
                                fontWeight: FontWeight.w600,
                                fontSize: 13,
                              ),
                            ),
                            Text(
                              ' • ${driver.ratingCount} reviews',
                              style: GoogleFonts.poppins(
                                color: AppPalette.textDisabled,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 8,
                          runSpacing: 6,
                          children: [
                            if (driver.baseCity.isNotEmpty)
                              _metaChip(Icons.location_on_rounded, driver.baseCity),
                            _metaChip(Icons.history_rounded,
                                '${driver.yearsExperience} yrs exp'),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            
            // Bottom Action Area
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              decoration: BoxDecoration(
                color: AppPalette.brandBlue.withValues(alpha: 0.03),
                border: Border(
                  top: BorderSide(
                    color: AppPalette.brandBlue.withValues(alpha: 0.05),
                  ),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        driver.isAvailable ? 'AVAILABLE NOW' : 'NOT AVAILABLE',
                        style: GoogleFonts.poppins(
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1,
                          color: driver.isAvailable
                              ? Colors.green.shade700
                              : AppPalette.textDisabled,
                        ),
                      ),
                      Text(
                        driver.isAvailable ? 'Ready for pickup' : 'Currently busy',
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: AppPalette.textSecondary,
                        ),
                      ),
                    ],
                  ),
                  CustomElevatedButton(
                    text: driver.isAvailable ? 'Book Now' : 'Unavailable',
                    width: 120,
                    height: 44,
                    onPressed: driver.isAvailable ? onBook : () {},
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _avatarFallback() {
    return Center(
      child: Text(
        driver.displayName.isNotEmpty
            ? driver.displayName[0].toUpperCase()
            : '?',
        style: GoogleFonts.poppins(
          fontSize: 26,
          fontWeight: FontWeight.w800,
          color: AppPalette.brandBlue,
        ),
      ),
    );
  }

  Widget _metaChip(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 11, color: AppPalette.textSecondary),
          const SizedBox(width: 4),
          Text(
            label,
            style: GoogleFonts.poppins(
              color: AppPalette.textSecondary,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}
