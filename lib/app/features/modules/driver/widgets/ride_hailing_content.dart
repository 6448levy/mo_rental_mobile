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
        // Map Placeholder (Enhanced Visual)
        Obx(() {
          if (!controller.isOnline.value) {
            return _buildOfflineState();
          }
          return _buildMapArea();
        }),

        const SizedBox(height: 24),

        // Dynamic Status/Request/Trip Card
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
      height: 220,
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppPalette.pureWhite,
        borderRadius: BorderRadius.circular(24),
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
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppPalette.error.withValues(alpha: 0.05),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.power_off_rounded,
                size: 40, color: AppPalette.error.withValues(alpha: 0.6)),
          ),
          const SizedBox(height: 20),
          const Text(
            "You are currently Offline",
            style: TextStyle(
              color: AppPalette.textPrimary,
              fontSize: 17,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            "Switch the toggle above to start receiving rides",
            style: TextStyle(
              color: AppPalette.textSecondary,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMapArea() {
    return Container(
      height: 320,
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFFF0F4F8),
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: AppPalette.brandBlue.withValues(alpha: 0.08),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Patterned Background Placeholder
          ClipRRect(
            borderRadius: BorderRadius.circular(28),
            child: CustomPaint(
              size: const Size(double.infinity, 320),
              painter: _MapPlaceholderPainter(),
            ),
          ),
          
          // Glossy Overlay
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(28),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.white.withValues(alpha: 0.2),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppPalette.pureWhite,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppPalette.brandBlue.withValues(alpha: 0.2),
                        blurRadius: 15,
                      )
                    ],
                  ),
                  child: const Icon(Icons.my_location_rounded,
                      size: 32, color: AppPalette.brandBlue),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: AppPalette.brandBlue,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    "LIVE GPS CONNECTED",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1),
                  ),
                ),
              ],
            ),
          ),

          Positioned(
            bottom: 20,
            right: 20,
            child: FloatingActionButton(
              onPressed: () {},
              backgroundColor: AppPalette.pureWhite,
              elevation: 4,
              child: const Icon(Icons.add_road_rounded, color: AppPalette.brandBlue),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchingState() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppPalette.pureWhite,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppPalette.brandBlue.withValues(alpha: 0.08),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
        border: Border.all(color: AppPalette.brandBlue.withValues(alpha: 0.05)),
      ),
      child: Row(
        children: [
          const SizedBox(
            height: 24,
            width: 24,
            child: CircularProgressIndicator(
                strokeWidth: 3, color: AppPalette.brandBlue),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Finding the best rides...",
                  style: TextStyle(
                    color: AppPalette.textPrimary,
                    fontWeight: FontWeight.w800,
                    fontSize: 16,
                  ),
                ),
                Text(
                  "Stay in highly populated areas",
                  style: TextStyle(
                    color: AppPalette.textSecondary,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIncomingRequestCard(Map<String, dynamic> request) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppPalette.pureWhite,
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: AppPalette.brandBlue.withValues(alpha: 0.2), width: 2),
        boxShadow: [
          BoxShadow(
            color: AppPalette.brandBlue.withValues(alpha: 0.15),
            blurRadius: 30,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "NEW RIDE",
                    style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w900,
                        color: AppPalette.brandBlue,
                        letterSpacing: 1.5),
                  ),
                  Text(
                    "Incoming Request",
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: AppPalette.textPrimary,
                        letterSpacing: -0.5),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.green.shade500,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(color: Colors.green.withValues(alpha: 0.3), blurRadius: 10)
                  ],
                ),
                child: Text(
                  "\$${request['fare']}",
                  style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                      color: Colors.white),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          _buildLocationEntry(Icons.radio_button_checked_rounded, "Pickup", request['pickup'], Colors.blue),
          const SizedBox(height: 16),
          _buildLocationEntry(Icons.location_on_rounded, "Dropoff", request['dropoff'], Colors.redAccent),
          const SizedBox(height: 28),
          Row(
            children: [
              Expanded(
                child: TextButton(
                  onPressed: () => controller.rejectRequest(),
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                  ),
                  child: const Text("Decline",
                      style: TextStyle(
                          color: AppPalette.textDisabled,
                          fontWeight: FontWeight.w800,
                          fontSize: 15)),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                  onPressed: () => controller.acceptRequest(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppPalette.brandBlue,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                  ),
                  child: const Text("Accept Ride",
                      style: TextStyle(
                          color: AppPalette.pureWhite,
                          fontWeight: FontWeight.w900,
                          fontSize: 15)),
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
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppPalette.pureWhite,
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
        border: Border.all(color: AppPalette.brandBlue.withValues(alpha: 0.1)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppPalette.brandBlue.withValues(alpha: 0.08),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.person_rounded, color: AppPalette.brandBlue),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      trip['passenger'] ?? 'Unknown Passenger',
                      style: const TextStyle(
                          fontWeight: FontWeight.w800, 
                          fontSize: 17,
                          color: AppPalette.textPrimary),
                    ),
                    Text(
                      trip['status'] ?? 'Active Trip',
                      style: TextStyle(
                          fontWeight: FontWeight.w600, 
                          fontSize: 13,
                          color: Colors.green.shade600),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.message_rounded, color: AppPalette.brandBlue),
                style: IconButton.styleFrom(
                  backgroundColor: AppPalette.brandBlue.withValues(alpha: 0.05),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: trip['status'] == 'Picking Up' 
                      ? () => controller.startTrip() 
                      : () => controller.endTrip(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: trip['status'] == 'Picking Up' 
                        ? AppPalette.brandBlue 
                        : AppPalette.error,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                  ),
                  child: Text(
                    trip['status'] == 'Picking Up' ? "Start Trip" : "Finish Trip",
                    style: const TextStyle(
                        color: AppPalette.pureWhite,
                        fontWeight: FontWeight.w900,
                        fontSize: 15),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Container(
                decoration: BoxDecoration(
                  color: AppPalette.brandBlue.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.navigation_rounded, color: AppPalette.brandBlue),
                  padding: const EdgeInsets.all(16),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLocationEntry(IconData icon, String label, String value, Color color) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 22, color: color),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    color: AppPalette.textDisabled,
                    letterSpacing: 1),
              ),
              Text(
                value,
                style: const TextStyle(
                    fontWeight: FontWeight.w600, 
                    fontSize: 14,
                    color: AppPalette.textPrimary),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _MapPlaceholderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black.withValues(alpha: 0.02)
      ..strokeWidth = 1;

    for (double i = 0; i < size.width; i += 20) {
      canvas.drawLine(Offset(i, 0), Offset(i, size.height), paint);
    }
    for (double i = 0; i < size.height; i += 20) {
      canvas.drawLine(Offset(0, i), Offset(size.width, i), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
