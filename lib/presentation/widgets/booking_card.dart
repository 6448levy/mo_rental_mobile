import 'package:flutter/material.dart';
import '../../data/models/booking_model.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../app/core/themes/app_palette.dart';

class BookingCard extends StatelessWidget {
  final BookingModel booking;
  final VoidCallback onViewDetails;

  const BookingCard({
    super.key, 
    required this.booking, 
    required this.onViewDetails
  });

  // Theme constants - replaced by AppPalette

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
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
          // ── Header Area ─────────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: AppPalette.brandBlue.withOpacity(0.1),
                  child: const Icon(Icons.person, color: AppPalette.brandBlue),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        booking.driverName,
                        style: GoogleFonts.poppins(
                          color: AppPalette.textPrimary,
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        booking.carModel,
                        style: GoogleFonts.poppins(
                          color: AppPalette.textSecondary,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: _getStatusColor(booking.status).withOpacity(0.12),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    booking.statusDisplay,
                    style: GoogleFonts.poppins(
                      color: _getStatusColor(booking.status),
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const Divider(color: AppPalette.outline, height: 1),

          // ── Route Info ──────────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                _buildRouteItem(Icons.radio_button_checked, Colors.green.shade600, "Pickup", booking.pickupLocation),
                const SizedBox(height: 12),
                _buildRouteItem(Icons.location_on, AppPalette.brandBlue, "Destination", booking.destination),
              ],
            ),
          ),

          // ── Footer with Price & Date ────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Price",
                      style: GoogleFonts.poppins(color: AppPalette.textDisabled, fontSize: 11),
                    ),
                    Text(
                      "\$${booking.price.toStringAsFixed(2)}",
                      style: GoogleFonts.poppins(
                        color: AppPalette.brandBlue,
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      "Date",
                      style: GoogleFonts.poppins(color: AppPalette.textDisabled, fontSize: 11),
                    ),
                    Text(
                      _formatDate(booking.createdAt),
                      style: GoogleFonts.poppins(color: AppPalette.textSecondary, fontSize: 12),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          // ── Action Button ───────────────────────────────────────────────────
          InkWell(
            onTap: onViewDetails,
            borderRadius: const BorderRadius.vertical(bottom: Radius.circular(20)),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 14),
              decoration: const BoxDecoration(
                border: Border(top: BorderSide(color: AppPalette.outline)),
              ),
              child: Center(
                child: Text(
                  "View Details",
                  style: GoogleFonts.poppins(
                    color: AppPalette.brandBlue,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRouteItem(IconData icon, Color color, String label, String value) {
    return Row(
      children: [
        Icon(icon, color: color, size: 16),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            value,
            style: GoogleFonts.poppins(
              color: AppPalette.textPrimary,
              fontSize: 13,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'active': return Colors.green.shade600;
      case 'pending': return Colors.orange.shade600;
      case 'completed': return AppPalette.brandBlue;
      case 'cancelled': return Colors.red.shade600;
      default: return AppPalette.textDisabled;
    }
  }

  String _formatDate(String isoString) {
    if (isoString.isEmpty) return "N/A";
    try {
      final dt = DateTime.parse(isoString);
      return "${dt.day}/${dt.month}/${dt.year}";
    } catch (_) {
      return isoString;
    }
  }
}
