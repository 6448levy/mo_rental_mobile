// lib/app/features/modules/drivers/views/drivers_view.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import '../controllers/drivers_controller.dart';
import '../../../data/models/driver/driver_profile_model.dart';

class DriversView extends GetView<DriversController> {
  const DriversView({super.key});

  static const _yellow = Color(0xFFFFC107);
  static const _dark = Color(0xFF1A1A2E);
  static const _card = Color(0xFF16213E);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _dark,
      body: CustomScrollView(
        slivers: [
          // ── Sticky header ──────────────────────────────────────────────────
          SliverAppBar(
            pinned: true,
            backgroundColor: _dark,
            foregroundColor: Colors.white,
            elevation: 0,
            expandedHeight: 130,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
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
                              color: _yellow,
                            ),
                          )
                        : const Icon(Icons.refresh_rounded, color: _yellow),
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
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                      fontSize: 20,
                    ),
                  ),
                  Obx(() => Text(
                        controller.drivers.isEmpty
                            ? 'No drivers found'
                            : '${controller.drivers.length} drivers available',
                        style: GoogleFonts.poppins(
                          color: _yellow,
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
                    colors: [Color(0xFF0F3460), Color(0xFF1A1A2E)],
                  ),
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
                      _filterChip('All', controller.filterStatus.value == 'all', 'all'),
                      const SizedBox(width: 10),
                      _filterChip('Online', controller.filterStatus.value == 'online', 'online'),
                      const SizedBox(width: 10),
                      _filterChip('Offline', controller.filterStatus.value == 'offline', 'offline'),
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
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? _yellow : _card,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selected ? _yellow : Colors.white12,
          ),
        ),
        child: Text(
          label,
          style: GoogleFonts.poppins(
            color: selected ? Colors.black : Colors.white70,
            fontWeight: selected ? FontWeight.w700 : FontWeight.w400,
            fontSize: 13,
          ),
        ),
      ),
    );
  }

  Widget _buildShimmerCard() {
    return Shimmer.fromColors(
      baseColor: _card,
      highlightColor: const Color(0xFF1E2D4A),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        height: 200,
        decoration: BoxDecoration(
          color: Colors.white12,
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
              color: _yellow.withOpacity(0.1),
            ),
            child: const Icon(Icons.person_search, size: 44, color: _yellow),
          ),
          const SizedBox(height: 20),
          Text(
            'No Drivers Available',
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Try refreshing or change the filter',
            style: GoogleFonts.poppins(color: Colors.white54, fontSize: 13),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => controller.fetchDrivers(),
            style: ElevatedButton.styleFrom(
              backgroundColor: _yellow,
              foregroundColor: Colors.black,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              elevation: 0,
            ),
            icon: const Icon(Icons.refresh, size: 18),
            label: Text('Refresh', style: GoogleFonts.poppins(fontWeight: FontWeight.w700)),
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
            const Icon(Icons.wifi_off_rounded, size: 64, color: Colors.redAccent),
            const SizedBox(height: 20),
            Text(
              'Connection Failed',
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              controller.errorMessage.value,
              style: GoogleFonts.poppins(color: Colors.white54, fontSize: 13),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => controller.fetchDrivers(),
              style: ElevatedButton.styleFrom(
                backgroundColor: _yellow,
                foregroundColor: Colors.black,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                elevation: 0,
              ),
              icon: const Icon(Icons.refresh, size: 18),
              label: Text('Try Again', style: GoogleFonts.poppins(fontWeight: FontWeight.w700)),
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

  static const _yellow = Color(0xFFFFC107);
  static const _card = Color(0xFF16213E);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: _card,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: driver.isAvailable
              ? _yellow.withOpacity(0.2)
              : Colors.white12,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // ── Top row: Avatar + Info ────────────────────────────────────
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Avatar with status dot
                Stack(
                  children: [
                    Container(
                      width: 70,
                      height: 70,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: driver.isAvailable
                              ? [_yellow.withOpacity(0.4), _yellow.withOpacity(0.1)]
                              : [Colors.white12, Colors.white.withOpacity(0.05)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        border: Border.all(
                          color: driver.isAvailable ? _yellow : Colors.white24,
                          width: 2,
                        ),
                      ),
                      child: driver.profileImage != null
                          ? ClipOval(
                              child: Image.network(
                                driver.profileImage!,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => _avatarFallback(),
                              ),
                            )
                          : _avatarFallback(),
                    ),
                    // Online dot
                    Positioned(
                      right: 2,
                      bottom: 2,
                      child: Container(
                        width: 16,
                        height: 16,
                        decoration: BoxDecoration(
                          color: driver.isAvailable ? Colors.greenAccent : Colors.grey,
                          shape: BoxShape.circle,
                          border: Border.all(color: _card, width: 2),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 14),

                // Driver details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Name & price badge
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              driver.displayName,
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: _yellow,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              '\$${driver.hourlyRate.toStringAsFixed(0)}/hr',
                              style: GoogleFonts.poppins(
                                color: Colors.black,
                                fontWeight: FontWeight.w800,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),

                      // Rating
                      Row(
                        children: [
                          const Icon(Icons.star_rounded, color: _yellow, size: 16),
                          const SizedBox(width: 3),
                          Text(
                            driver.ratingAverage.toStringAsFixed(1),
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                            ),
                          ),
                          Text(
                            '  (${driver.ratingCount} reviews)',
                            style: GoogleFonts.poppins(
                              color: Colors.white54,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 8),

                      // Meta chips row
                      Wrap(
                        spacing: 6,
                        runSpacing: 4,
                        children: [
                          if (driver.baseCity.isNotEmpty)
                            _metaChip(Icons.location_on, driver.baseCity),
                          _metaChip(
                            Icons.work_history,
                            '${driver.yearsExperience} yrs',
                          ),
                          if (driver.languages.isNotEmpty)
                            _metaChip(Icons.language, driver.languages.first),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 14),
            const Divider(color: Colors.white12, height: 1),
            const SizedBox(height: 14),

            // ── Bottom row: Status + Book Now ─────────────────────────────
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Status badge
                Row(
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: driver.isAvailable
                            ? Colors.greenAccent
                            : Colors.grey,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      driver.isAvailable ? 'Online' : 'Offline',
                      style: GoogleFonts.poppins(
                        color: driver.isAvailable
                            ? Colors.greenAccent
                            : Colors.white54,
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),

                // Book Now button
                ElevatedButton(
                  onPressed: driver.isAvailable ? onBook : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: driver.isAvailable ? _yellow : Colors.white12,
                    disabledBackgroundColor: Colors.white10,
                    foregroundColor:
                        driver.isAvailable ? Colors.black : Colors.white38,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 10,
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    driver.isAvailable ? 'Book Now' : 'Unavailable',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _avatarFallback() {
    return Center(
      child: Text(
        driver.displayName.isNotEmpty ? driver.displayName[0].toUpperCase() : '?',
        style: GoogleFonts.poppins(
          fontSize: 26,
          fontWeight: FontWeight.w800,
          color: _yellow,
        ),
      ),
    );
  }

  Widget _metaChip(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.06),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 11, color: Colors.white54),
          const SizedBox(width: 4),
          Text(
            label,
            style: GoogleFonts.poppins(
              color: Colors.white60,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}
