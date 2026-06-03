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
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "ACTIVE RENTAL",
              style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w900,
                  color: AppPalette.brandBlue,
                  letterSpacing: 1.5),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppPalette.brandBlue.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.history_rounded, size: 14, color: AppPalette.brandBlue),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Obx(() {
          if (controller.activeRental.value != null) {
            return _buildActiveRentalCard(controller.activeRental.value!);
          }
          return _buildNoActiveRental();
        }),

        const SizedBox(height: 32),
        const Text(
          "UPCOMING RENTALS",
          style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w900,
              color: AppPalette.brandBlue,
              letterSpacing: 1.5),
        ),
        const SizedBox(height: 16),
        // Placeholder list
        _buildUpcomingRentalCard("Mercedes-Benz GLA", "Apr 02 - Apr 08"),
        const SizedBox(height: 12),
        _buildUpcomingRentalCard("BMW X5 M-Sport", "Apr 15 - Apr 20"),
      ],
    );
  }

  Widget _buildActiveRentalCard(Map<String, dynamic> rental) {
    return Container(
      decoration: BoxDecoration(
        color: AppPalette.pureWhite,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: AppPalette.brandBlue.withValues(alpha: 0.08),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
        border: Border.all(color: AppPalette.brandBlue.withValues(alpha: 0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Premium Car Image Area
          Container(
            height: 180,
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFFE3F2FD),
                  Color(0xFFBBDEFB),
                ],
              ),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Positioned(
                  right: -10,
                  bottom: -10,
                  child: Icon(
                    Icons.directions_car_filled_rounded,
                    size: 150,
                    color: AppPalette.pureWhite.withValues(alpha: 0.4),
                  ),
                ),
                const Icon(Icons.directions_car_filled_rounded,
                    size: 80, color: AppPalette.brandBlue),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            rental['carModel'] ?? 'Unknown Vehicle',
                            style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w800,
                                color: AppPalette.textPrimary,
                                letterSpacing: -0.5),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            rental['plateNumber'] ?? 'UNAVAILABLE',
                            style: const TextStyle(
                                color: AppPalette.brandBlue,
                                fontWeight: FontWeight.w700,
                                fontSize: 13,
                                letterSpacing: 1),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.green.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        (rental['status'] ?? 'Active').toUpperCase(),
                        style: TextStyle(
                            color: Colors.green.shade700,
                            fontWeight: FontWeight.w900,
                            fontSize: 11,
                            letterSpacing: 1),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                
                // Timeline Style Trip Info
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppPalette.brandBlue.withValues(alpha: 0.03),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildDateColumn("START DATE", rental['startDate'] ?? '---'),
                      const Icon(Icons.arrow_forward_rounded,
                          color: AppPalette.brandBlue, size: 18),
                      _buildDateColumn("END DATE", rental['endDate'] ?? '---'),
                    ],
                  ),
                ),

                const SizedBox(height: 28),
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () {},
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16)),
                        ),
                        child: const Text("EXTEND",
                            style: TextStyle(
                                color: AppPalette.textDisabled,
                                fontWeight: FontWeight.w800,
                                fontSize: 14,
                                letterSpacing: 1)),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppPalette.error,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16)),
                        ),
                        child: const Text("END RENTAL",
                            style: TextStyle(
                                color: AppPalette.pureWhite,
                                fontWeight: FontWeight.w900,
                                fontSize: 14,
                                letterSpacing: 1)),
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
      padding: const EdgeInsets.all(32),
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppPalette.pureWhite,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: AppPalette.outline.withValues(alpha: 0.5)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppPalette.textDisabled.withValues(alpha: 0.05),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.car_rental_rounded,
                size: 40, color: AppPalette.textDisabled.withValues(alpha: 0.5)),
          ),
          const SizedBox(height: 20),
          const Text("No Active Rentals",
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: AppPalette.textPrimary,
                  letterSpacing: -0.5)),
          const SizedBox(height: 8),
          const Text("Explore premium vehicles to start a new ride",
              textAlign: TextAlign.center,
              style: TextStyle(color: AppPalette.textSecondary, fontSize: 13)),
        ],
      ),
    );
  }

  Widget _buildUpcomingRentalCard(String model, String dates) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppPalette.pureWhite,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: AppPalette.outline.withValues(alpha: 0.5)),
      ),
      child: Row(
        children: [
          Container(
            width: 54,
            height: 54,
            decoration: BoxDecoration(
              color: AppPalette.brandBlue.withValues(alpha: 0.06),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(Icons.directions_car_filled_rounded,
                color: AppPalette.brandBlue, size: 24),
          ),
          const SizedBox(width: 18),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(model,
                    style: const TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 15,
                        color: AppPalette.textPrimary)),
                const SizedBox(height: 2),
                Text(dates,
                    style: const TextStyle(
                        color: AppPalette.textSecondary, 
                        fontWeight: FontWeight.w500,
                        fontSize: 12)),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppPalette.brandBlue.withValues(alpha: 0.05),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.chevron_right_rounded,
                color: AppPalette.brandBlue, size: 20),
          ),
        ],
      ),
    );
  }

  Widget _buildDateColumn(String label, String date) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(
              color: AppPalette.textDisabled, 
              fontSize: 10,
              fontWeight: FontWeight.w800,
              letterSpacing: 1,
            )),
        const SizedBox(height: 4),
        Text(date,
            style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w800, 
                color: AppPalette.textPrimary)),
      ],
    );
  }
}
