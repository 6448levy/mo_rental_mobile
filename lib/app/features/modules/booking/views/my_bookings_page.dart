import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';
import '../controllers/booking_controller.dart';
import '../../../data/models/booking/booking_model.dart';
import '../../../../core/themes/app_palette.dart';

class MyBookingsPage extends GetView<BookingController> {
  const MyBookingsPage({super.key});

  // Theme constants - replaced by AppPalette

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppPalette.pureWhite,
      appBar: AppBar(
        backgroundColor: AppPalette.brandBlue,
        foregroundColor: AppPalette.pureWhite,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: AppPalette.pureWhite),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'My Bookings',
          style: GoogleFonts.poppins(
            color: AppPalette.pureWhite,
            fontWeight: FontWeight.w700,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded, color: AppPalette.pureWhite),
            onPressed: () => controller.fetchBookings(),
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: Obx(() {
        // Loading state
        if (controller.isLoading.value && controller.bookings.isEmpty) {
          return _buildShimmerList();
        }

        // Error state
        if (controller.errorMessage.isNotEmpty && controller.bookings.isEmpty) {
          return _buildErrorState();
        }

        // Empty state
        if (controller.bookings.isEmpty) {
          return _buildEmptyState();
        }

        // Booking list
        return RefreshIndicator(
          onRefresh: () => controller.fetchBookings(),
          color: AppPalette.brandBlue,
          backgroundColor: AppPalette.pureWhite,
          child: ListView.builder(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
            itemCount: controller.bookings.length,
            itemBuilder: (context, index) {
              final booking = controller.bookings[index];
              return _buildBookingCard(booking, index);
            },
          ),
        );
      }),
    );
  }

  // ── Booking Card ────────────────────────────────────────────────────────────

  Widget _buildBookingCard(BookingModel booking, int index) {
    final statusColor = _statusColor(booking);
    return AnimatedContainer(
      duration: Duration(milliseconds: 200 + index * 50),
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: AppPalette.pureWhite,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: statusColor.withOpacity(0.25),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // ── Header with status ─────────────────────────────────────────
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.08),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.confirmation_number_outlined, color: statusColor, size: 16),
                    const SizedBox(width: 6),
                    Text(
                      booking.id.length > 12
                          ? '#${booking.id.substring(booking.id.length - 8).toUpperCase()}'
                          : '#${booking.id.toUpperCase()}',
                      style: GoogleFonts.sourceCodePro(
                        color: AppPalette.textSecondary,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                _statusChip(booking, statusColor),
              ],
            ),
          ),

          // ── Driver Info ────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  children: [
                    // Avatar
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppPalette.brandBlue.withOpacity(0.15),
                      ),
                      child: booking.driverImage != null
                          ? ClipOval(
                              child: Image.network(
                                booking.driverImage!,
                                fit: BoxFit.cover,
                              ),
                            )
                          : Center(
                              child: Text(
                                booking.driverName?.isNotEmpty == true
                                    ? booking.driverName![0].toUpperCase()
                                    : 'D',
                                style: GoogleFonts.poppins(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                   color: AppPalette.brandBlue,
                                 ),
                              ),
                            ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            booking.driverName?.isNotEmpty == true
                                ? booking.driverName!
                                : 'Driver',
                            style: GoogleFonts.poppins(
                              color: AppPalette.textPrimary,
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          if (booking.carModel?.isNotEmpty == true)
                            Text(
                              booking.carModel!,
                               style: GoogleFonts.poppins(
                                color: AppPalette.textSecondary,
                                fontSize: 12,
                              ),
                            ),
                        ],
                      ),
                    ),
                    // Price
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '\$${booking.price.toStringAsFixed(2)}',
                          style: GoogleFonts.poppins(
                            color: AppPalette.brandBlue,
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        Text(
                          'Total',
                          style: GoogleFonts.poppins(
                            color: AppPalette.textDisabled,
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 14),
                const Divider(color: AppPalette.outline, height: 1),
                const SizedBox(height: 14),

                // ── Route ─────────────────────────────────────────────────
                Row(
                  children: [
                    // Left: icons
                    Column(
                      children: [
                        Icon(Icons.radio_button_checked, color: Colors.green.shade600, size: 14),
                        Container(
                          width: 1,
                          height: 20,
                          color: AppPalette.outline,
                        ),
                        const Icon(Icons.location_on, color: AppPalette.brandBlue, size: 14),
                      ],
                    ),
                    const SizedBox(width: 10),
                    // Right: locations
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            booking.pickupLocation,
                           style: GoogleFonts.poppins(
                              color: AppPalette.textPrimary,
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 14),
                          Text(
                            booking.destination,
                            style: GoogleFonts.poppins(
                              color: AppPalette.textPrimary,
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                if (booking.createdAt.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Icon(Icons.calendar_today, color: AppPalette.textDisabled, size: 12),
                      const SizedBox(width: 6),
                      Text(
                        _formatDate(booking.createdAt),
                        style: GoogleFonts.poppins(
                          color: AppPalette.textDisabled,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),

          // ── View Details Button ────────────────────────────────────────
          Container(
            decoration: const BoxDecoration(
              border: Border(top: BorderSide(color: AppPalette.outline)),
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
            ),
            child: TextButton(
              onPressed: () => _showBookingDetails(booking),
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'View Details',
                    style: GoogleFonts.poppins(
                      color: AppPalette.brandBlue,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Icon(Icons.arrow_forward_ios, size: 12, color: AppPalette.brandBlue),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Status helpers ──────────────────────────────────────────────────────────

  Widget _statusChip(BookingModel booking, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.4)),
      ),
      child: Text(
        booking.statusLabel,
        style: GoogleFonts.poppins(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  Color _statusColor(BookingModel booking) {
    if (booking.isActive) return Colors.green.shade600;
    if (booking.isPending) return Colors.orange.shade600;
    if (booking.isCompleted) return AppPalette.brandBlue;
    if (booking.isCancelled) return Colors.red.shade600;
    return AppPalette.textDisabled;
  }

  // ── Bottom sheet with full booking details ──────────────────────────────────

  void _showBookingDetails(BookingModel booking) {
    Get.bottomSheet(
      Container(
        decoration: const BoxDecoration(
          color: AppPalette.pureWhite,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppPalette.outline,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Booking Details',
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 20),
            _detailRow('Booking ID', booking.id.isNotEmpty ? booking.id : 'N/A'),
            _detailRow('Driver', booking.driverName ?? 'N/A'),
            if (booking.carModel?.isNotEmpty == true)
              _detailRow('Car Model', booking.carModel!),
            _detailRow('Pickup', booking.pickupLocation),
            _detailRow('Destination', booking.destination),
            _detailRow('Status', booking.statusLabel),
            _detailRow('Price', '\$${booking.price.toStringAsFixed(2)}'),
            if (booking.paymentMethod?.isNotEmpty == true)
              _detailRow('Payment', booking.paymentMethod!),
            _detailRow('Date', _formatDate(booking.createdAt)),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _detailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 110,
            child: Text(
              label,
              style: GoogleFonts.poppins(color: AppPalette.textSecondary, fontSize: 13),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: GoogleFonts.poppins(
                color: AppPalette.textPrimary,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── States ────────────────────────────────────────────────────────────────

  Widget _buildShimmerList() {
    return Shimmer.fromColors(
      baseColor: const Color(0xFFF1F5F9),
      highlightColor: AppPalette.pureWhite,
      child: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: 5,
        itemBuilder: (_, __) => Container(
          margin: const EdgeInsets.only(bottom: 16),
          height: 180,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppPalette.brandBlue.withOpacity(0.1),
            ),
            child: const Icon(Icons.calendar_today_outlined, size: 48, color: AppPalette.brandBlue),
          ),
          const SizedBox(height: 24),
          Text(
            'No Bookings Yet',
            style: GoogleFonts.poppins(
              color: AppPalette.textPrimary,
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Your booking history will appear here\nafter you make your first booking.',
            style: GoogleFonts.poppins(color: AppPalette.textSecondary, fontSize: 14, height: 1.6),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 28),
          ElevatedButton.icon(
            onPressed: () => Get.back(),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppPalette.brandBlue,
              foregroundColor: AppPalette.pureWhite,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
              elevation: 0,
            ),
            icon: const Icon(Icons.search, size: 18),
            label: Text(
              'Find a Driver',
              style: GoogleFonts.poppins(fontWeight: FontWeight.w700, fontSize: 14),
            ),
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
            const Icon(Icons.wifi_off_rounded, size: 64, color: Colors.redAccent),
            const SizedBox(height: 20),
            Text(
              'Connection Error',
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              controller.errorMessage.value,
              style: GoogleFonts.poppins(color: AppPalette.textSecondary, fontSize: 13),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => controller.fetchBookings(),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppPalette.brandBlue,
                foregroundColor: AppPalette.pureWhite,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                elevation: 0,
              ),
              icon: const Icon(Icons.refresh, size: 18),
              label: Text(
                'Try Again',
                style: GoogleFonts.poppins(fontWeight: FontWeight.w700),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(String raw) {
    if (raw.isEmpty) return 'N/A';
    try {
      final dt = DateTime.parse(raw);
      const months = [
        'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
        'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
      ];
      return '${dt.day} ${months[dt.month - 1]} ${dt.year}';
    } catch (_) {
      return raw.split('T').first;
    }
  }
}
