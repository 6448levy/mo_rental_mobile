import 'package:flutter/material.dart';
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
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.cloud_off, size: 50, color: Colors.grey[400]),
          const SizedBox(height: 10),
          Text(
            "You are offline",
            style: TextStyle(color: Colors.grey[600], fontSize: 16),
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
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.blue.withOpacity(0.2)),
      ),
      child: Stack(
        children: [
          Center(
            child: Icon(Icons.map, size: 50, color: Colors.blue[200]),
          ),
          Positioned(
            bottom: 16,
            right: 16,
            child: FloatingActionButton(
              onPressed: () {},
              mini: true,
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
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
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
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
          const SizedBox(width: 16),
          const Text("Searching for rides..."),
        ],
      ),
    );
  }

  Widget _buildIncomingRequestCard(Map<String, dynamic> request) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
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
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(
                "\$${request['fare']}",
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green),
              ),
            ],
          ),
          const Divider(height: 30),
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
                    side: const BorderSide(color: Colors.red),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text("Reject", style: TextStyle(color: Colors.red)),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                  onPressed: () => controller.acceptRequest(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text("Accept", style: TextStyle(color: Colors.white)),
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
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.green.withOpacity(0.1),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
        border: Border.all(color: Colors.green.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                trip['status'] ?? 'Unknown',
                style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.green),
              ),
              Row(
                children: [
                  const Icon(Icons.person, size: 16, color: Colors.grey),
                  const SizedBox(width: 4),
                  Text(trip['passenger'] ?? 'Unknown'),
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
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                  child: const Text("Start Trip", style: TextStyle(color: Colors.white)),
                )
              else
                ElevatedButton(
                  onPressed: () => controller.endTrip(),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  child: const Text("End Trip", style: TextStyle(color: Colors.white)),
                ),
              FloatingActionButton.small(
                onPressed: () {}, // Navigate
                backgroundColor: Colors.blue[50],
                child: const Icon(Icons.navigation, color: Colors.blue),
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
        Icon(icon, size: 20, color: Colors.grey[600]),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
        ),
      ],
    );
  }
}
