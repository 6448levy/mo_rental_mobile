import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import '../../../../core/themes/app_palette.dart';
import '../../../data/models/fleet/vehicle_model.dart';
import '../../booking/controllers/rental_booking_controller.dart';

class CarDetailsScreen extends StatefulWidget {
  final VehicleModel model;
  
  const CarDetailsScreen({super.key, required this.model});

  @override
  State<CarDetailsScreen> createState() => _CarDetailsScreenState();
}

class _CarDetailsScreenState extends State<CarDetailsScreen> {
  final RentalBookingController controller = Get.put(RentalBookingController());

  @override
  void initState() {
    super.initState();
    // Initialize controller with current vehicle and a default branch
    controller.setupRental(widget.model, '6750f1e0c1a2b34de0branch01'); 
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppPalette.pureWhite,
      body: Stack(
        children: [
          // --- Hero Image ---
          _buildHeroImage(),

          // --- Content Container ---
          _buildContent(context),

          // --- Back Button ---
          Positioned(
            top: 48,
            left: 20,
            child: _buildCircleButton(
              icon: Icons.arrow_back_ios_new_rounded,
              onTap: () => Navigator.pop(context),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeroImage() {
    return Container(
      height: 400,
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppPalette.outline.withValues(alpha: 0.3),
      ),
      child: Hero(
        tag: 'car_${widget.model.id}',
        child: widget.model.imageUrl.startsWith('http')
            ? Image.network(widget.model.imageUrl, fit: BoxFit.cover)
            : Image.asset(widget.model.imageUrl, fit: BoxFit.cover, errorBuilder: (_, __, ___) => const Icon(Icons.directions_car_rounded, size: 100)),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    return Positioned.fill(
      top: 360,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        decoration: const BoxDecoration(
          color: AppPalette.pureWhite,
          borderRadius: BorderRadius.vertical(top: Radius.circular(36)),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 20,
              offset: Offset(0, -10),
            ),
          ],
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title & Category
              _buildHeader(),

              const SizedBox(height: 24),

              // Specs Grid
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _specItem(Icons.airline_seat_recline_normal_rounded, '${widget.model.seats} Seats'),
                  _specItem(Icons.door_front_door_rounded, '${widget.model.doors} Doors'),
                  _specItem(Icons.settings_input_component_rounded, widget.model.transmission.name.capitalizeFirst!),
                  _specItem(Icons.local_gas_station_rounded, widget.model.fuelType.name.capitalizeFirst!),
                ],
              ),

              const SizedBox(height: 32),

              // Rental Dates Selection
              Text(
                'Rental Period',
                style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w700, color: AppPalette.textPrimary),
              ),
              const SizedBox(height: 12),
              _buildDatePicker(context),

              const SizedBox(height: 32),

              // Price Breakdown (Only if dates selected)
              Obx(() => controller.selectedDates.value != null ? _buildPriceBreakdown() : const SizedBox.shrink()),

              const SizedBox(height: 32),

              // Features
              Text(
                'Features',
                style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w700, color: AppPalette.textPrimary),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: widget.model.features.map((f) => _featureChip(f)).toList(),
              ),

              const SizedBox(height: 40),

              // Final Button
              _buildFooterButton(),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.model.make,
                style: GoogleFonts.poppins(fontSize: 16, color: AppPalette.textSecondary, fontWeight: FontWeight.w500),
              ),
              Text(
                widget.model.model,
                style: GoogleFonts.poppins(fontSize: 28, color: AppPalette.textPrimary, fontWeight: FontWeight.w700, height: 1.1),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(color: AppPalette.brandBlue.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(20)),
          child: Text(
            widget.model.category,
            style: GoogleFonts.poppins(color: AppPalette.brandBlue, fontWeight: FontWeight.w600, fontSize: 12),
          ),
        ),
      ],
    );
  }

  Widget _buildDatePicker(BuildContext context) {
    return Obx(() {
      final range = controller.selectedDates.value;
      return GestureDetector(
        onTap: () async {
          final picked = await showDateRangePicker(
            context: context,
            firstDate: DateTime.now(),
            lastDate: DateTime.now().add(const Duration(days: 90)),
            builder: (context, child) => Theme(
              data: ThemeData.light().copyWith(colorScheme: const ColorScheme.light(primary: AppPalette.brandBlue)),
              child: child!,
            ),
          );
          if (picked != null) controller.onDatesSelected(picked);
        },
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppPalette.pureWhite,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: range != null ? AppPalette.brandBlue : AppPalette.outline),
          ),
          child: Row(
            children: [
              const Icon(Icons.calendar_today_rounded, color: AppPalette.brandBlue, size: 20),
              const SizedBox(width: 12),
              Text(
                range == null ? 'Choose your rental dates' : '${range.start.day}/${range.start.month} - ${range.end.day}/${range.end.month} (${controller.rentalDays} Days)',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: range != null ? FontWeight.w600 : FontWeight.w400,
                  color: range != null ? AppPalette.textPrimary : AppPalette.textSecondary,
                ),
              ),
              const Spacer(),
              const Icon(Icons.edit_rounded, color: AppPalette.textDisabled, size: 16),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildPriceBreakdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Price Summary',
          style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w700, color: AppPalette.textPrimary),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(color: AppPalette.outline.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(16)),
          child: Column(
            children: [
              _priceRow('Base Rental (${controller.rentalDays} days)', controller.basePrice.value),
              _priceRow('Taxes (VAT 15%)', controller.taxTotal.value),
              _priceRow('Service Fees', controller.feeTotal.value),
              const Divider(height: 24),
              _priceRow('Total Amount', controller.finalTotal.value, isTotal: true),
            ],
          ),
        ),
      ],
    );
  }

  Widget _priceRow(String label, double amount, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: GoogleFonts.poppins(fontSize: isTotal ? 15 : 13, fontWeight: isTotal ? FontWeight.w700 : FontWeight.w400, color: isTotal ? AppPalette.textPrimary : AppPalette.textSecondary)),
          Text(
            '\$${amount.toStringAsFixed(2)}',
            style: GoogleFonts.poppins(fontSize: isTotal ? 18 : 13, fontWeight: isTotal ? FontWeight.w800 : FontWeight.w600, color: isTotal ? AppPalette.brandBlue : AppPalette.textPrimary),
          ),
        ],
      ),
    );
  }

  Widget _buildFooterButton() {
    return Obx(() {
      final isReady = controller.selectedDates.value != null;
      return SizedBox(
        width: double.infinity,
        height: 60,
        child: ElevatedButton(
          onPressed: isReady ? () => _startReservation() : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppPalette.brandBlue,
            disabledBackgroundColor: AppPalette.textDisabled.withValues(alpha: 0.3),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            elevation: 0,
          ),
          child: Text(
            isReady ? 'Confirm Reservation' : 'Select Dates to Continue',
            style: GoogleFonts.poppins(fontWeight: FontWeight.w700, fontSize: 16, color: AppPalette.pureWhite),
          ),
        ),
      );
    });
  }

  void _startReservation() {
    controller.confirmBooking();
  }

  Widget _specItem(IconData icon, String label) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(color: AppPalette.outline.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(12)),
          child: Icon(icon, color: AppPalette.textPrimary, size: 22),
        ),
        const SizedBox(height: 8),
        Text(label, style: GoogleFonts.poppins(fontSize: 12, color: AppPalette.textSecondary, fontWeight: FontWeight.w500)),
      ],
    );
  }

  Widget _featureChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(color: AppPalette.pureWhite, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppPalette.outline)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.check_circle_rounded, color: AppPalette.success, size: 16),
          const SizedBox(width: 6),
          Text(label, style: GoogleFonts.poppins(fontSize: 13, color: AppPalette.textPrimary, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  Widget _buildCircleButton({required IconData icon, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(color: AppPalette.pureWhite, shape: BoxShape.circle, boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 10, offset: const Offset(0, 4))]),
        child: Icon(icon, color: AppPalette.textPrimary, size: 20),
      ),
    );
  }
}
