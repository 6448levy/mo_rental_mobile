// lib/presentation/widgets/booking_card.dart
import 'package:flutter/material.dart';
import '../../data/models/booking_model.dart';
import 'package:google_fonts/google_fonts.dart';

class BookingCard extends StatelessWidget {
  final BookingModel booking;
  final VoidCallback onViewDetails;

  const BookingCard({
    super.key, 
    required this.booking, 
    required this.onViewDetails
  });

  // Dark/Yellow Theme constants
  static const _yellow = Color(0xFFFFC107);
  static const _card = Color(0xFF16213E);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: _card,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
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
                  backgroundColor: _yellow.withOpacity(0.1),
                  child: const Icon(Icons.person, color: _yellow),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        booking.driverName,
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        booking.carModel,
                        style: GoogleFonts.poppins(
                          color: Colors.white60,
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

          const Divider(color: Colors.white12, height: 1),

          // ── Route Info ──────────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                _buildRouteItem(Icons.radio_button_checked, Colors.greenAccent, "Pickup", booking.pickupLocation),
                const SizedBox(height: 12),
                _buildRouteItem(Icons.location_on, _yellow, "Destination", booking.destination),
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
                      style: GoogleFonts.poppins(color: Colors.white38, fontSize: 11),
                    ),
                    Text(
                      "\$${booking.price.toStringAsFixed(2)}",
                      style: GoogleFonts.poppins(
                        color: _yellow,
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
                      style: GoogleFonts.poppins(color: Colors.white38, fontSize: 11),
                    ),
                    Text(
                      _formatDate(booking.createdAt),
                      style: GoogleFonts.poppins(color: Colors.white70, fontSize: 12),
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
                border: Border(top: BorderSide(color: Colors.white12)),
              ),
              child: Center(
                child: Text(
                  "View Details",
                  style: GoogleFonts.poppins(
                    color: _yellow,
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
              color: Colors.white.withOpacity(0.85),
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
      case 'active': return Colors.greenAccent;
      case 'pending': return _yellow;
      case 'completed': return Colors.blueAccent;
      case 'cancelled': return Colors.redAccent;
      default: return Colors.white54;
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
