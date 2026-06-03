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
    return DefaultTabController(
      length: 2,
      child: Scaffold(
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
            'My Activity',
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
          bottom: TabBar(
            indicatorColor: AppPalette.pureWhite,
            indicatorWeight: 3,
            labelStyle: GoogleFonts.poppins(fontWeight: FontWeight.w700, fontSize: 14),
            unselectedLabelStyle: GoogleFonts.poppins(fontWeight: FontWeight.w500, fontSize: 14),
            tabs: const [
              Tab(text: 'Rides'),
              Tab(text: 'Rentals'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // --- RIDES TAB ---
            Obx(() {
              if (controller.isLoading.value && controller.driverBookings.isEmpty) {
                return _buildShimmerList();
              }
              if (controller.driverBookings.isEmpty) {
                return _buildEmptyState('No Rides Yet', 'Your ride history will appear here.');
              }
              return RefreshIndicator(
                onRefresh: () => controller.fetchBookings(),
                child: ListView.builder(
                  padding: const EdgeInsets.all(20),
                  itemCount: controller.driverBookings.length,
                  itemBuilder: (context, index) => _buildDriverBookingCard(controller.driverBookings[index], index),
                ),
              );
            }),

            // --- RENTALS TAB ---
            Obx(() {
              if (controller.isLoading.value && controller.reservations.isEmpty) {
                return _buildShimmerList();
              }
              if (controller.reservations.isEmpty) {
                return _buildEmptyState('No Rentals Yet', 'Your car rental history will appear here.');
              }
              return RefreshIndicator(
                onRefresh: () => controller.fetchBookings(),
                child: ListView.builder(
                  padding: const EdgeInsets.all(20),
                  itemCount: controller.reservations.length,
                  itemBuilder: (context, index) => _buildRentalCard(controller.reservations[index], index),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  // ── Booking Card ────────────────────────────────────────────────────────────

  // ── Driver Booking Card ──────────────────────────────────────────────────────
  Widget _buildDriverBookingCard(dynamic booking, int index) {
    final statusColor = _statusColor(booking.status);
    return AnimatedContainer(
      duration: Duration(milliseconds: 200 + index * 50),
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: AppPalette.pureWhite,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: statusColor.withValues(alpha: 0.25)),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 12, offset: const Offset(0, 4))],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(color: statusColor.withValues(alpha: 0.08), borderRadius: const BorderRadius.vertical(top: Radius.circular(20))),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('#${booking.code.toUpperCase()}', style: GoogleFonts.sourceCodePro(color: AppPalette.textSecondary, fontSize: 12, fontWeight: FontWeight.w600)),
                _statusChip(booking.status, statusColor),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  children: [
                    CircleAvatar(backgroundColor: AppPalette.brandBlue.withValues(alpha: 0.1), child: const Icon(Icons.person, color: AppPalette.brandBlue)),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text('Ride to Destination', style: GoogleFonts.poppins(color: AppPalette.textPrimary, fontSize: 15, fontWeight: FontWeight.w700)),
                        Text('Driver Requested', style: GoogleFonts.poppins(color: AppPalette.textSecondary, fontSize: 12)),
                      ]),
                    ),
                    Text('\$${booking.pricing.totalAmount.toStringAsFixed(2)}', style: GoogleFonts.poppins(color: AppPalette.brandBlue, fontSize: 18, fontWeight: FontWeight.w800)),
                  ],
                ),
                const SizedBox(height: 14),
                const Divider(color: AppPalette.outline, height: 1),
                const SizedBox(height: 14),
                _locationRow(Icons.radio_button_checked, Colors.green, booking.pickupLocation.address),
                const SizedBox(height: 8),
                _locationRow(Icons.location_on, AppPalette.brandBlue, booking.dropoffLocation.address),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Rental Card ─────────────────────────────────────────────────────────────
  Widget _buildRentalCard(dynamic reservation, int index) {
    final statusColor = _statusColor(reservation.status);
    return AnimatedContainer(
      duration: Duration(milliseconds: 200 + index * 50),
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: AppPalette.pureWhite,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: statusColor.withValues(alpha: 0.25)),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 12, offset: const Offset(0, 4))],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(color: statusColor.withValues(alpha: 0.08), borderRadius: const BorderRadius.vertical(top: Radius.circular(20))),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('#${reservation.code.toUpperCase()}', style: GoogleFonts.sourceCodePro(color: AppPalette.textSecondary, fontSize: 12, fontWeight: FontWeight.w600)),
                _statusChip(reservation.status, statusColor),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      width: 50, height: 50,
                      decoration: BoxDecoration(color: AppPalette.brandBlue.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(10)),
                      child: const Icon(Icons.directions_car, color: AppPalette.brandBlue),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text('Car Rental', style: GoogleFonts.poppins(color: AppPalette.textPrimary, fontSize: 15, fontWeight: FontWeight.w700)),
                        Text('Vehicle Reservation', style: GoogleFonts.poppins(color: AppPalette.textSecondary, fontSize: 12)),
                      ]),
                    ),
                    Text('\$${reservation.pricing.grandTotal}', style: GoogleFonts.poppins(color: AppPalette.brandBlue, fontSize: 18, fontWeight: FontWeight.w800)),
                  ],
                ),
                const SizedBox(height: 14),
                const Divider(color: AppPalette.outline, height: 1),
                const SizedBox(height: 14),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _dateInfo('Pickup', reservation.pickup.at),
                    const Icon(Icons.arrow_forward, color: AppPalette.outline, size: 16),
                    _dateInfo('Dropoff', reservation.dropoff.at),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _locationRow(IconData icon, Color color, String address) {
    return Row(children: [
      Icon(icon, color: color, size: 14),
      const SizedBox(width: 10),
      Expanded(child: Text(address, style: GoogleFonts.poppins(color: AppPalette.textPrimary, fontSize: 13, fontWeight: FontWeight.w500), overflow: TextOverflow.ellipsis)),
    ]);
  }

  Widget _dateInfo(String label, DateTime? date) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(label, style: GoogleFonts.poppins(color: AppPalette.textDisabled, fontSize: 10, fontWeight: FontWeight.w600)),
      Text(date != null ? '${date.day}/${date.month}/${date.year}' : 'N/A', style: GoogleFonts.poppins(color: AppPalette.textPrimary, fontSize: 13, fontWeight: FontWeight.w600)),
    ]);
  }

  Widget _statusChip(String status, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(color: color.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(20), border: Border.all(color: color.withValues(alpha: 0.4))),
      child: Text(status.toUpperCase(), style: GoogleFonts.poppins(color: color, fontSize: 11, fontWeight: FontWeight.w700)),
    );
  }

  Color _statusColor(String status) {
    final s = status.toLowerCase();
    if (s == 'active' || s == 'confirmed' || s == 'paid') return Colors.green.shade600;
    if (s == 'pending' || s == 'requested') return Colors.orange.shade600;
    if (s == 'completed') return AppPalette.brandBlue;
    if (s == 'cancelled' || s == 'failed') return Colors.red.shade600;
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
                color: AppPalette.textPrimary,
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 20),
            _detailRow(
                'Booking ID', booking.id.isNotEmpty ? booking.id : 'N/A'),
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
              style: GoogleFonts.poppins(
                  color: AppPalette.textSecondary, fontSize: 13),
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

  Widget _buildEmptyState(String title, String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppPalette.brandBlue.withValues(alpha: 0.1),
            ),
            child: const Icon(Icons.calendar_today_outlined,
                size: 48, color: AppPalette.brandBlue),
          ),
          const SizedBox(height: 24),
          Text(
            title,
            style: GoogleFonts.poppins(
              color: AppPalette.textPrimary,
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            message,
            style: GoogleFonts.poppins(
                color: AppPalette.textSecondary, fontSize: 14, height: 1.6),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 28),
          ElevatedButton.icon(
            onPressed: () => Get.back(),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppPalette.brandBlue,
              foregroundColor: AppPalette.pureWhite,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14)),
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
              elevation: 0,
            ),
            icon: const Icon(Icons.search, size: 18),
            label: Text(
              'Explore Now',
              style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w700, fontSize: 14),
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
            const Icon(Icons.wifi_off_rounded,
                size: 64, color: Colors.redAccent),
            const SizedBox(height: 20),
            Text(
              'Connection Error',
              style: GoogleFonts.poppins(
                color: AppPalette.textPrimary,
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
              onPressed: () => controller.fetchBookings(),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppPalette.brandBlue,
                foregroundColor: AppPalette.pureWhite,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14)),
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
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
        'Jan',
        'Feb',
        'Mar',
        'Apr',
        'May',
        'Jun',
        'Jul',
        'Aug',
        'Sep',
        'Oct',
        'Nov',
        'Dec',
      ];
      return '${dt.day} ${months[dt.month - 1]} ${dt.year}';
    } catch (_) {
      return raw.split('T').first;
    }
  }
}
