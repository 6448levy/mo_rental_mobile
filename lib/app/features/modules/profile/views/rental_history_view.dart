import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/themes/app_palette.dart';
import '../../../data/models/booking/reservation_model.dart';
import '../controllers/rental_history_controller.dart';

class RentalHistoryView extends StatelessWidget {
  const RentalHistoryView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(RentalHistoryController());

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: AppPalette.pureWhite,
        appBar: AppBar(
          backgroundColor: AppPalette.pureWhite,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppPalette.textPrimary),
            onPressed: () => Get.back(),
          ),
          title: Text(
            'My Rentals',
            style: GoogleFonts.poppins(color: AppPalette.textPrimary, fontWeight: FontWeight.w700, fontSize: 20),
          ),
          bottom: TabBar(
            indicatorColor: AppPalette.brandBlue,
            labelColor: AppPalette.brandBlue,
            unselectedLabelColor: AppPalette.textDisabled,
            labelStyle: GoogleFonts.poppins(fontWeight: FontWeight.w700, fontSize: 14),
            unselectedLabelStyle: GoogleFonts.poppins(fontWeight: FontWeight.w500, fontSize: 14),
            tabs: const [
              Tab(text: 'Active'),
              Tab(text: 'History'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildList(controller, controller.activeReservations, 'No active rentals found.'),
            _buildList(controller, controller.pastReservations, 'No rental history found.'),
          ],
        ),
      ),
    );
  }

  Widget _buildList(RentalHistoryController controller, RxList<ReservationModel> list, String emptyMsg) {
    return Obx(() {
      if (controller.isLoading.value && list.isEmpty) {
        return const Center(child: CircularProgressIndicator(color: AppPalette.brandBlue));
      }

      if (list.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.directions_car_filled_outlined, size: 64, color: AppPalette.outline.withValues(alpha: 0.5)),
              const SizedBox(height: 16),
              Text(emptyMsg, style: GoogleFonts.poppins(color: AppPalette.textSecondary, fontSize: 15)),
            ],
          ),
        );
      }

      return RefreshIndicator(
        onRefresh: () => controller.refreshHistory(),
        child: ListView.builder(
          padding: const EdgeInsets.all(20),
          itemCount: list.length,
          itemBuilder: (context, index) {
            final reservation = list[index];
            return _buildReservationCard(reservation);
          },
        ),
      );
    });
  }

  Widget _buildReservationCard(ReservationModel r) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: AppPalette.pureWhite,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppPalette.outline),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Icon / Avatar Placeholder
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: AppPalette.brandBlue.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.car_rental_rounded, color: AppPalette.brandBlue),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        r.code.isNotEmpty ? r.code : 'Booking ID: ${r.id.substring(0, 8)}',
                        style: GoogleFonts.poppins(fontWeight: FontWeight.w700, fontSize: 15),
                      ),
                      Text(
                        '${r.pickup.at?.day}/${r.pickup.at?.month} - ${r.dropoff.at?.day}/${r.dropoff.at?.month}',
                        style: GoogleFonts.poppins(color: AppPalette.textSecondary, fontSize: 13),
                      ),
                    ],
                  ),
                ),
                _buildStatusTag(r.status),
              ],
            ),
          ),
          const Divider(height: 1, indent: 16, endIndent: 16),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Total Amount', style: GoogleFonts.poppins(color: AppPalette.textSecondary, fontSize: 12)),
                    Text('${r.pricing.currency} ${r.pricing.grandTotal}', style: GoogleFonts.poppins(fontWeight: FontWeight.w700, color: AppPalette.brandBlue)),
                  ],
                ),
                ElevatedButton(
                  onPressed: () {
                    // TODO: Open Details
                    Get.snackbar("Details", "Booking detail view coming soon!");
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppPalette.outline.withValues(alpha: 0.2),
                    foregroundColor: AppPalette.textPrimary,
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: Text('Details', style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 12)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusTag(String status) {
    Color color;
    switch (status.toLowerCase()) {
      case 'confirmed':
      case 'checked_out':
        color = AppPalette.success;
        break;
      case 'pending':
        color = AppPalette.warning;
        break;
      case 'cancelled':
      case 'no_show':
        color = AppPalette.error;
        break;
      default:
        color = AppPalette.brandBlue;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        status.toUpperCase(),
        style: GoogleFonts.poppins(color: color, fontSize: 10, fontWeight: FontWeight.w700),
      ),
    );
  }
}
