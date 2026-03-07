// lib/app/features/modules/booking/views/booking_overview_page.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import '../controllers/booking_controller.dart';
import '../../../../../../app/routes/app_routes.dart';

class BookingOverviewPage extends GetView<BookingController> {
  const BookingOverviewPage({super.key});

  // Brand accent colour
  static const _yellow = Color(0xFFFFC107);
  static const _dark = Color(0xFF1A1A2E);
  static const _card = Color(0xFF16213E);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _dark,
      body: Obx(() {
        final driver = controller.selectedDriver.value;
        if (driver == null) {
          return const Center(
            child: Text('No driver selected', style: TextStyle(color: Colors.white)),
          );
        }

        return CustomScrollView(
          slivers: [
            // ── Custom App Bar ──────────────────────────────────────────────
            SliverAppBar(
              expandedHeight: 60,
              floating: true,
              backgroundColor: _dark,
              foregroundColor: Colors.white,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
                onPressed: () => Get.back(),
              ),
              title: Text(
                'Booking Overview',
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 18,
                ),
              ),
              centerTitle: true,
            ),

            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8),

                    // ── Pickup time row ─────────────────────────────────────
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.access_time, color: _yellow, size: 18),
                            const SizedBox(width: 6),
                            Text(
                              'Pickup: ${_currentTime()}',
                              style: GoogleFonts.poppins(
                                color: Colors.white70,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                        TextButton.icon(
                          onPressed: () {},
                          icon: const Icon(Icons.my_location, size: 14, color: _yellow),
                          label: Text(
                            'Track driver',
                            style: GoogleFonts.poppins(
                              color: _yellow,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // ── Car / Driver banner card ────────────────────────────
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: _card,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: _yellow.withValues(alpha: 0.3), width: 1),
                      ),
                      child: Column(
                        children: [
                          // Car image placeholder
                          ClipRRect(
                            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                            child: Container(
                              height: 180,
                              width: double.infinity,
                              color: const Color(0xFF0F3460),
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  // Animated car icon
                                  const Icon(
                                    Icons.directions_car,
                                    size: 90,
                                    color: Color(0xFF1A6FA8),
                                  ),
                                  // Yellow glow
                                  Positioned.fill(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        gradient: RadialGradient(
                                          colors: [
                                            _yellow.withValues(alpha: 0.12),
                                            Colors.transparent,
                                          ],
                                          radius: 0.8,
                                        ),
                                      ),
                                    ),
                                  ),
                                  // Car model label
                                  Positioned(
                                    bottom: 12,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 16,
                                        vertical: 6,
                                      ),
                                      decoration: BoxDecoration(
                                        color: _yellow,
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Text(
                                        driver.displayName,
                                        style: GoogleFonts.poppins(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 13,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          // Driver info strip
                          Padding(
                            padding: const EdgeInsets.all(16),
                            child: Row(
                              children: [
                                // Avatar
                                CircleAvatar(
                                  radius: 24,
                                  backgroundColor: _yellow.withValues(alpha: 0.2),
                                  backgroundImage: driver.profileImage != null
                                      ? NetworkImage(driver.profileImage!)
                                      : null,
                                  child: driver.profileImage == null
                                      ? Text(
                                          driver.displayName.isNotEmpty
                                              ? driver.displayName[0].toUpperCase()
                                              : '?',
                                          style: GoogleFonts.poppins(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: _yellow,
                                          ),
                                        )
                                      : null,
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        driver.displayName,
                                        style: GoogleFonts.poppins(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w700,
                                          fontSize: 15,
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          const Icon(Icons.star, color: _yellow, size: 14),
                                          const SizedBox(width: 4),
                                          Text(
                                            '${driver.ratingAverage.toStringAsFixed(1)} · ${driver.yearsExperience} yrs exp',
                                            style: GoogleFonts.poppins(
                                              color: Colors.white60,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: _yellow,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    '\$${driver.hourlyRate.toStringAsFixed(0)}/hr',
                                    style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w800,
                                      fontSize: 14,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // ── Ride details card ───────────────────────────────────
                    _sectionLabel('Ride Details'),
                    const SizedBox(height: 10),
                    Container(
                      decoration: BoxDecoration(
                        color: _card,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        children: [
                          _locationTile(
                            icon: Icons.radio_button_checked,
                            color: Colors.greenAccent,
                            label: 'Pickup',
                            controller: controller.pickupController,
                          ),
                          Divider(color: Colors.white12, height: 1, indent: 56),
                          _locationTile(
                            icon: Icons.location_on,
                            color: _yellow,
                            label: 'Destination',
                            controller: controller.destinationController,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // ── Payment method ──────────────────────────────────────
                    _sectionLabel('Payment Method'),
                    const SizedBox(height: 10),
                    Obx(
                      () => InkWell(
                        onTap: () => Get.toNamed(AppRoutes.addCard),
                        borderRadius: BorderRadius.circular(14),
                        child: Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: _card,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: Colors.white12,
                            ),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 44,
                                height: 32,
                                decoration: BoxDecoration(
                                  color: const Color(0xFF1565C0),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: const Icon(
                                  Icons.credit_card,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  controller.selectedPaymentMethod.value,
                                  style: GoogleFonts.poppins(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              const Icon(Icons.chevron_right, color: Colors.white54),
                            ],
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // ── Ride cost summary ───────────────────────────────────
                    _sectionLabel('Cost Estimate'),
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: _card,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        children: [
                          _costRow('Hourly Rate', '\$${driver.hourlyRate.toStringAsFixed(0)}/hr'),
                          const SizedBox(height: 8),
                          _costRow('Service Fee', '\$2.00'),
                          const Divider(color: Colors.white12, height: 24),
                          _costRow(
                            'Estimated Total',
                            '\$${(driver.hourlyRate + 2).toStringAsFixed(2)}',
                            isTotal: true,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // ── Ride status ─────────────────────────────────────────
                    _sectionLabel('Ride Status'),
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: _card,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 10,
                            height: 10,
                            decoration: const BoxDecoration(
                              color: Colors.greenAccent,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            driver.isAvailable ? 'Driver Available — Ready to go' : 'Driver Offline',
                            style: GoogleFonts.poppins(
                              color: driver.isAvailable ? Colors.greenAccent : Colors.white54,
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // ── Cancel ride ─────────────────────────────────────────
                    TextButton(
                      onPressed: () => _showCancelDialog(),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.cancel_outlined, color: Colors.redAccent, size: 18),
                          const SizedBox(width: 6),
                          Text(
                            'Cancel Ride',
                            style: GoogleFonts.poppins(
                              color: Colors.redAccent,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // ── Confirm Pay button ──────────────────────────────────
                    Obx(
                      () => SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          onPressed: controller.isCreatingBooking.value
                              ? null
                              : () => controller.confirmBooking(),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _yellow,
                            disabledBackgroundColor: _yellow.withValues(alpha: 0.5),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            elevation: 0,
                          ),
                          child: controller.isCreatingBooking.value
                              ? const SizedBox(
                                  width: 22,
                                  height: 22,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2.5,
                                    color: Colors.black,
                                  ),
                                )
                              : Text(
                                  'Confirm & Pay',
                                  style: GoogleFonts.poppins(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w800,
                                    fontSize: 16,
                                  ),
                                ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ],
        );
      }),
    );
  }

  // ── Helpers ─────────────────────────────────────────────────────────────────

  Widget _sectionLabel(String text) => Text(
        text,
        style: GoogleFonts.poppins(
          color: Colors.white70,
          fontSize: 12,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.8,
        ),
      );

  Widget _locationTile({
    required IconData icon,
    required Color color,
    required String label,
    required TextEditingController controller,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Icon(icon, color: color, size: 22),
          const SizedBox(width: 14),
          Expanded(
            child: TextField(
              controller: controller,
              style: GoogleFonts.poppins(color: Colors.white, fontSize: 14),
              decoration: InputDecoration(
                labelText: label,
                labelStyle: GoogleFonts.poppins(color: Colors.white54, fontSize: 12),
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _costRow(String label, String value, {bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
            color: isTotal ? Colors.white : Colors.white60,
            fontSize: isTotal ? 15 : 13,
            fontWeight: isTotal ? FontWeight.w700 : FontWeight.w400,
          ),
        ),
        Text(
          value,
          style: GoogleFonts.poppins(
            color: isTotal ? _yellow : Colors.white,
            fontSize: isTotal ? 16 : 13,
            fontWeight: isTotal ? FontWeight.w800 : FontWeight.w500,
          ),
        ),
      ],
    );
  }

  void _showCancelDialog() {
    Get.dialog(
      AlertDialog(
        backgroundColor: const Color(0xFF16213E),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          'Cancel Ride?',
          style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w700),
        ),
        content: Text(
          'Are you sure you want to cancel this ride?',
          style: GoogleFonts.poppins(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('Keep Ride', style: GoogleFonts.poppins(color: Colors.white70)),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back(); // Close dialog
              Get.back(); // Go back to drivers
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: Text(
              'Cancel Ride',
              style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  String _currentTime() {
    final now = DateTime.now();
    final hour = now.hour > 12 ? now.hour - 12 : now.hour;
    final minute = now.minute.toString().padLeft(2, '0');
    final period = now.hour >= 12 ? 'PM' : 'AM';
    return '$hour:$minute $period';
  }
}
