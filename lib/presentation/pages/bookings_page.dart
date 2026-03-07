// lib/presentation/pages/bookings_page.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';
import '../providers/booking_provider.dart';
import '../widgets/booking_card.dart';

class MyBookingsPage extends StatefulWidget {
  const MyBookingsPage({super.key});

  @override
  State<MyBookingsPage> createState() => _MyBookingsPageState();
}

class _MyBookingsPageState extends State<MyBookingsPage> {
  // Theme constants
  static const _yellow = Color(0xFFFFC107);
  static const _dark = Color(0xFF1A1A2E);
  static const _card = Color(0xFF16213E);

  @override
  void initState() {
    super.initState();
    // Load bookings when page opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<BookingProvider>().loadBookings();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _dark,
      appBar: _buildAppBar(),
      body: Consumer<BookingProvider>(
        builder: (context, provider, child) {
          switch (provider.status) {
            case BookingStatus.loading:
              return _buildLoadingState();
            case BookingStatus.error:
              return _buildErrorState(provider);
            case BookingStatus.empty:
              return _buildEmptyState();
            case BookingStatus.loaded:
              return _buildBookingList(provider);
            default:
              return const SizedBox.shrink();
          }
        },
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      title: Text(
        "My Bookings",
        style: GoogleFonts.poppins(
          color: Colors.white,
          fontWeight: FontWeight.w700,
          fontSize: 18,
        ),
      ),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 18),
        onPressed: () => Navigator.pop(context),
      ),
    );
  }

  Widget _buildLoadingState() {
    return Shimmer.fromColors(
      baseColor: _card,
      highlightColor: const Color(0xFF1E2D4A),
      child: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: 4,
        itemBuilder: (_, __) => Container(
          margin: const EdgeInsets.only(bottom: 20),
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
            padding: const EdgeInsets.all(28),
            decoration: BoxDecoration(
              color: _yellow.withOpacity(0.08),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.calendar_today_outlined, color: _yellow, size: 48),
          ),
          const SizedBox(height: 24),
          Text(
            "No Bookings Found",
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            "Your trip history will appear here once you\nbook your first ride with us.",
            style: GoogleFonts.poppins(color: Colors.white54, fontSize: 13, height: 1.6),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(BookingProvider provider) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline_rounded, color: Colors.redAccent, size: 56),
            const SizedBox(height: 20),
            Text(
              "Connection Error",
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "Something went wrong while fetching your bookings. This typically happens if the server returns HTML instead of JSON.",
              style: GoogleFonts.poppins(color: Colors.white54, fontSize: 13),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => provider.retry(),
              style: ElevatedButton.styleFrom(
                backgroundColor: _yellow,
                foregroundColor: Colors.black,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
              ),
              child: Text(
                "Try Again",
                style: GoogleFonts.poppins(fontWeight: FontWeight.w700),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBookingList(BookingProvider provider) {
    return RefreshIndicator(
      color: _yellow,
      backgroundColor: _card,
      onRefresh: () => provider.loadBookings(),
      child: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: provider.bookings.length,
        itemBuilder: (context, index) {
          final booking = provider.bookings[index];
          return BookingCard(
            booking: booking,
            onViewDetails: () {
              // Details flow would go here
            },
          );
        },
      ),
    );
  }
}
