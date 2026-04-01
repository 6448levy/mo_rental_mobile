import 'package:flutter/material.dart';
import '../../../../core/themes/app_palette.dart';
import 'package:get/get.dart';
import '../controllers/driver_controller.dart';

class CarRentalContent extends GetView<DriverController> {
  const CarRentalContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Active Rental",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppPalette.textPrimary),
        ),
        const SizedBox(height: 16),
        Obx(() {
          if (controller.activeRental.value != null) {
            return _buildActiveRentalCard(controller.activeRental.value!);
          }
          return _buildNoActiveRental();
        }),

        const SizedBox(height: 24),
        const Text(
          "Upcoming Rentals",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppPalette.textPrimary),
        ),
        const SizedBox(height: 16),
        // Placeholder list
        _buildUpcomingRentalCard(),
        const SizedBox(height: 12),
        _buildUpcomingRentalCard(),
      ],
    );
  }

  Widget _buildActiveRentalCard(Map<String, dynamic> rental) {
    return Container(
      decoration: BoxDecoration(
        color: AppPalette.pureWhite,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppPalette.outline),
        boxShadow: [
          BoxShadow(
            color: AppPalette.cardShadow.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Car Image Area
          Container(
            height: 150,
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppPalette.brandBlue.withOpacity(0.1),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            ),
            child: const Center(
              child: Icon(Icons.directions_car_rounded, size: 60, color: AppPalette.brandBlue),
            ),
          ),
          
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      rental['carModel'] ?? 'Unknown Vehicle',
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppPalette.textPrimary),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppPalette.brandBlue.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        rental['status'] ?? 'Unknown',
                        style: const TextStyle(color: AppPalette.brandBlue, fontWeight: FontWeight.bold, fontSize: 12),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  rental['plateNumber'] ?? '---',
                  style: TextStyle(color: AppPalette.textSecondary),
                ),
                const SizedBox(height: 16),
                const Divider(color: AppPalette.outline),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildDateColumn("Start Date", rental['startDate']),
                    const Icon(Icons.arrow_forward_rounded, color: AppPalette.textDisabled, size: 16),
                    _buildDateColumn("End Date", rental['endDate']),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {}, // Extend logic
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: AppPalette.brandBlue),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        child: const Text("Extend Rental", style: TextStyle(color: AppPalette.brandBlue)),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {}, // End trip logic
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppPalette.error,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        child: const Text("End Rental", style: TextStyle(color: AppPalette.pureWhite, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNoActiveRental() {
    return Container(
      padding: const EdgeInsets.all(24),
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppPalette.pureWhite,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppPalette.outline),
      ),
      child: Column(
        children: [
          Icon(Icons.car_rental_rounded, size: 40, color: AppPalette.textDisabled),
          const SizedBox(height: 12),
          const Text("No active rentals", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppPalette.textPrimary)),
          const SizedBox(height: 4),
          const Text("Browse cars to start driving", style: TextStyle(color: AppPalette.textSecondary)),
        ],
      ),
    );
  }

  Widget _buildUpcomingRentalCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppPalette.pureWhite,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppPalette.outline),
      ),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 40,
            decoration: BoxDecoration(
              color: AppPalette.brandBlue.withOpacity(0.05),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.directions_car_rounded, color: AppPalette.brandBlue, size: 20),
          ),
          const SizedBox(width: 16),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Toyota Corolla", style: TextStyle(fontWeight: FontWeight.bold, color: AppPalette.textPrimary)),
                Text("Mar 20 - Mar 25", style: TextStyle(color: AppPalette.textSecondary, fontSize: 12)),
              ],
            ),
          ),
          const Icon(Icons.chevron_right_rounded, color: AppPalette.textDisabled),
        ],
      ),
    );
  }

   Widget _buildDateColumn(String label, String date) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(color: AppPalette.textSecondary, fontSize: 12)),
        const SizedBox(height: 4),
        Text(date, style: const TextStyle(fontWeight: FontWeight.bold, color: AppPalette.textPrimary)),
      ],
    );
  }
}
