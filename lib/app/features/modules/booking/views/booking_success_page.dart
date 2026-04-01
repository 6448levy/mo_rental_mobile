import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/booking_controller.dart';
import '../../../../../../app/routes/app_routes.dart';
import '../../../../../../app/core/themes/app_palette.dart';

class BookingSuccessPage extends GetView<BookingController> {
  const BookingSuccessPage({super.key});

  // Theme constants - replaced by AppPalette

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppPalette.pureWhite,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Column(
            children: [
              const Spacer(),

              // ── Success animation circle ──────────────────────────────────
              Container(
                width: 130,
                height: 130,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppPalette.brandBlue.withOpacity(0.15),
                  border: Border.all(color: AppPalette.brandBlue.withOpacity(0.4), width: 2),
                ),
                child: Center(
                  child: Container(
                    width: 90,
                    height: 90,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppPalette.brandBlue,
                    ),
                    child: const Icon(
                      Icons.check_rounded,
                      color: AppPalette.pureWhite,
                      size: 50,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 32),

              Text(
                'Booking Confirmed!',
                 style: GoogleFonts.poppins(
                  color: AppPalette.textPrimary,
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                'Your ride has been booked successfully.\nYour driver is on the way.',
                 style: GoogleFonts.poppins(
                  color: AppPalette.textSecondary,
                  fontSize: 15,
                  height: 1.6,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 36),

              // ── Booking summary card ────────────────────────────────────
              Obx(() {
                final booking = controller.latestBooking.value;
                final driver = controller.selectedDriver.value;

                return Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                   decoration: BoxDecoration(
                    color: AppPalette.pureWhite,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppPalette.outline),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.04),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      _summaryRow(
                        icon: Icons.person,
                        label: 'Driver',
                        value: driver?.displayName ?? 'N/A',
                      ),
                      const SizedBox(height: 12),
                      _summaryRow(
                        icon: Icons.radio_button_checked,
                        label: 'Pickup',
                        value: controller.pickupController.text.isNotEmpty
                            ? controller.pickupController.text
                            : 'Harare CBD',
                        iconColor: Colors.green.shade600,
                      ),
                      const SizedBox(height: 12),
                      _summaryRow(
                        icon: Icons.location_on,
                        label: 'Destination',
                        value: controller.destinationController.text.isNotEmpty
                            ? controller.destinationController.text
                            : 'Borrowdale',
                        iconColor: AppPalette.brandBlue,
                      ),
                      const SizedBox(height: 12),
                      _summaryRow(
                        icon: Icons.receipt_long,
                        label: 'Status',
                        value: booking?.statusLabel ?? 'Pending',
                        valueColor: AppPalette.brandBlue,
                      ),
                      if (booking?.id != null && booking!.id.isNotEmpty) ...[
                        const SizedBox(height: 12),
                        _summaryRow(
                          icon: Icons.confirmation_number,
                          label: 'Booking ID',
                          value: booking.id,
                        ),
                      ],
                    ],
                  ),
                );
              }),

              const Spacer(),

              // ── CTA Buttons ───────────────────────────────────────────────
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => Get.offAllNamed(AppRoutes.main),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: AppPalette.outline),
                        foregroundColor: AppPalette.textPrimary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      icon: const Icon(Icons.home_outlined, size: 18),
                      label: Text(
                        'Back Home',
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => Get.toNamed(AppRoutes.myBookings),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppPalette.brandBlue,
                        foregroundColor: AppPalette.pureWhite,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        elevation: 0,
                      ),
                      icon: const Icon(Icons.my_location, size: 18),
                      label: Text(
                        'Track Ride',
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                          color: AppPalette.pureWhite,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _summaryRow({
    required IconData icon,
    required String label,
    required String value,
    Color? iconColor,
    Color? valueColor,
  }) {
    return Row(
      children: [
        Icon(icon, color: iconColor ?? AppPalette.textSecondary, size: 18),
        const SizedBox(width: 12),
        Text(
          '$label: ',
          style: GoogleFonts.poppins(
            color: AppPalette.textSecondary,
            fontSize: 13,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: GoogleFonts.poppins(
              color: valueColor ?? AppPalette.textPrimary,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.end,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
