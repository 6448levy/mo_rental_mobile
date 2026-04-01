import 'package:flutter/material.dart';
import '../../../../core/themes/app_palette.dart';
import 'package:get/get.dart';
import '../controllers/driver_controller.dart';

class RideHailingContent extends GetView<DriverController> {
  const RideHailingContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Map Placeholder (In real app, use GoogleMap)
        Obx(() {
          if (!controller.isOnline.value) {
            return _buildOfflineState();
          }
          return _buildMapArea();
        }),
        
        const SizedBox(height: 20),

        // Dynamic Bottom Sheet Area for Requests/Trips
        Obx(() {
          if (!controller.isOnline.value) return const SizedBox.shrink();

          if (controller.activeTrip.value != null) {
            return _buildActiveTripCard(controller.activeTrip.value!);
          } else if (controller.incomingRequest.value != null) {
            return _buildIncomingRequestCard(controller.incomingRequest.value!);
          } else {
            return _buildSearchingState();
          }
        }),
      ],
    );
  }

  Widget _buildOfflineState() {
    return Container(
      height: 200,
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppPalette.brandBlue.withOpacity(0.04),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppPalette.outline),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.cloud_off_rounded, size: 50, color: AppPalette.textDisabled),
          const SizedBox(height: 10),
          Text(
            "You are offline",
            style: TextStyle(color: AppPalette.textSecondary, fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget _buildMapArea() {
    // Placeholder for Map
    return Container(
      height: 300,
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppPalette.brandBlue.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppPalette.brandBlue.withOpacity(0.1)),
      ),
      child: Stack(
        children: [
          Center(
            child: Icon(Icons.map_rounded, size: 50, color: AppPalette.brandBlue.withOpacity(0.2)),
          ),
          Positioned(
            bottom: 16,
            right: 16,
            child: FloatingActionButton(
              onPressed: () {},
              mini: true,
              backgroundColor: AppPalette.brandBlue,
              foregroundColor: AppPalette.pureWhite,
              child: const Icon(Icons.my_location),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchingState() {
    return Container(
      padding: const EdgeInsets.all(20),
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
      child: Row(
        children: [
          const SizedBox(
            height: 20,
            width: 20,
            child: CircularProgressIndicator(strokeWidth: 2, color: AppPalette.brandBlue),
          ),
          const SizedBox(width: 16),
          const Text("Searching for rides...", style: TextStyle(color: AppPalette.textPrimary, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  Widget _buildIncomingRequestCard(Map<String, dynamic> request) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppPalette.pureWhite,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppPalette.brandBlue.withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color: AppPalette.brandBlue.withOpacity(0.1),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "New Ride Request!",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppPalette.textPrimary),
              ),
              Text(
                "\$${request['fare']}",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green.shade700),
              ),
            ],
          ),
          const Divider(height: 30, color: AppPalette.outline),
          _buildLocationRow(Icons.my_location, request['pickup']),
          const SizedBox(height: 12),
          _buildLocationRow(Icons.location_on, request['dropoff']),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => controller.rejectRequest(),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    side: const BorderSide(color: AppPalette.error),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text("Reject", style: TextStyle(color: AppPalette.error, fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                  onPressed: () => controller.acceptRequest(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green.shade600,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text("Accept", style: TextStyle(color: AppPalette.pureWhite, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActiveTripCard(Map<String, dynamic> trip) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppPalette.pureWhite,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.green.withOpacity(0.1),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
        border: Border.all(color: Colors.green.shade300),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                trip['status'] ?? 'Unknown',
                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green.shade700),
              ),
              Row(
                children: [
                  const Icon(Icons.person_rounded, size: 16, color: AppPalette.textDisabled),
                  const SizedBox(width: 4),
                  Text(trip['passenger'] ?? 'Unknown', style: const TextStyle(color: AppPalette.textPrimary, fontWeight: FontWeight.w500)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              if (trip['status'] == 'Picking Up')
                ElevatedButton(
                  onPressed: () => controller.startTrip(),
                  style: ElevatedButton.styleFrom(backgroundColor: AppPalette.brandBlue),
                  child: const Text("Start Trip", style: TextStyle(color: AppPalette.pureWhite, fontWeight: FontWeight.bold)),
                )
              else
                ElevatedButton(
                  onPressed: () => controller.endTrip(),
                  style: ElevatedButton.styleFrom(backgroundColor: AppPalette.error),
                  child: const Text("End Trip", style: TextStyle(color: AppPalette.pureWhite, fontWeight: FontWeight.bold)),
                ),
              FloatingActionButton.small(
                onPressed: () {}, // Navigate
                backgroundColor: AppPalette.brandBlue.withOpacity(0.1),
                child: const Icon(Icons.navigation_rounded, color: AppPalette.brandBlue),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLocationRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 20, color: AppPalette.textSecondary),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(fontWeight: FontWeight.w500, color: AppPalette.textPrimary),
          ),
        ),
      ],
    );
  }
}
