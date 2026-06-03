import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/booking_controller.dart';
import '../../../../core/themes/app_palette.dart';
import '../../../data/models/payment/payment_model.dart';

class BookingOverviewPage extends GetView<BookingController> {
  const BookingOverviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppPalette.pureWhite,
      appBar: AppBar(
        backgroundColor: AppPalette.pureWhite,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppPalette.textPrimary, size: 20),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'Booking Overview',
          style: GoogleFonts.poppins(
            color: AppPalette.textPrimary,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- Driver Info Card ---
              _buildSectionHeader('Driver Details'),
              const SizedBox(height: 12),
              _buildDriverCard(),

              const SizedBox(height: 32),

              // --- Promo Code Section ---
              _buildSectionHeader('Promo Code'),
              const SizedBox(height: 12),
              _buildPromoSection(),

              const SizedBox(height: 32),

              // --- Payment Method Section ---
              _buildSectionHeader('Payment Method'),
              const SizedBox(height: 12),
              _buildPaymentMethods(),

              const SizedBox(height: 32),

              // --- Price Summary ---
              _buildSectionHeader('Price Details'),
              const SizedBox(height: 12),
              _buildPriceSummary(),

              const SizedBox(height: 40),

              // --- Confirm Button ---
              _buildConfirmButton(),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: GoogleFonts.poppins(
        color: AppPalette.textPrimary,
        fontSize: 16,
        fontWeight: FontWeight.w700,
      ),
    );
  }

  Widget _buildDriverCard() {
    return Obx(() {
      final driver = controller.selectedDriver.value;
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppPalette.pureWhite,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppPalette.outline),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 28,
              backgroundColor: AppPalette.brandBlue.withValues(alpha: 0.1),
              child: const Icon(Icons.person, color: AppPalette.brandBlue, size: 32),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    driver?.displayName ?? 'Select a Driver',
                    style: GoogleFonts.poppins(
                      color: AppPalette.textPrimary,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    'Professional Driver',
                    style: GoogleFonts.poppins(
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
    });
  }

  Widget _buildPromoSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            color: AppPalette.pureWhite,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppPalette.outline),
          ),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: controller.promoCodeController,
                  decoration: InputDecoration(
                    hintText: 'Enter promo code',
                    hintStyle: GoogleFonts.poppins(color: AppPalette.textDisabled, fontSize: 14),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                  ),
                ),
              ),
              Obx(() => controller.isApplyingPromo.value
                  ? const Padding(
                      padding: EdgeInsets.all(12.0),
                      child: SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2)),
                    )
                  : TextButton(
                      onPressed: () => controller.applyPromoCode(),
                      child: Text(
                        'Apply',
                        style: GoogleFonts.poppins(
                          color: AppPalette.brandBlue,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    )),
            ],
          ),
        ),
        Obx(() => controller.promoMessage.value.isNotEmpty
            ? Padding(
                padding: const EdgeInsets.only(top: 8.0, left: 4.0),
                child: Text(
                  controller.promoMessage.value,
                  style: GoogleFonts.poppins(
                    color: controller.promoDiscount.value > 0 ? AppPalette.success : AppPalette.error,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              )
            : const SizedBox.shrink()),
      ],
    );
  }

  Widget _buildPaymentMethods() {
    return Column(
      children: [
        _buildPaymentOption(
          method: PaymentMethod.mobile_wallet,
          title: 'EcoCash / OneMoney',
          subtitle: 'Mobile USSD Push',
          icon: Icons.smartphone_rounded,
        ),
        const SizedBox(height: 12),
        _buildPaymentOption(
          method: PaymentMethod.paynow,
          title: 'Paynow',
          subtitle: 'Bank / Multi-channel',
          icon: Icons.account_balance_rounded,
        ),
      ],
    );
  }

  Widget _buildPaymentOption({
    required PaymentMethod method,
    required String title,
    required String subtitle,
    required IconData icon,
  }) {
    return Obx(() {
      final isSelected = controller.selectedPaymentMethod.value == method;
      return GestureDetector(
        onTap: () => controller.selectedPaymentMethod.value = method,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isSelected ? AppPalette.brandBlue.withValues(alpha: 0.05) : AppPalette.pureWhite,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isSelected ? AppPalette.brandBlue : AppPalette.outline,
              width: isSelected ? 2 : 1,
            ),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: isSelected ? AppPalette.brandBlue : AppPalette.outline.withValues(alpha: 0.5),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: isSelected ? AppPalette.pureWhite : AppPalette.textSecondary, size: 20),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.poppins(
                        color: AppPalette.textPrimary,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: GoogleFonts.poppins(
                        color: AppPalette.textSecondary,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              if (isSelected)
                const Icon(Icons.check_circle_rounded, color: AppPalette.brandBlue, size: 24),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildPriceSummary() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppPalette.pureWhite,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppPalette.outline),
      ),
      child: Column(
        children: [
          _priceRow('Base Amount', controller.baseAmount, isTotal: false),
          const SizedBox(height: 12),
          _priceRow('Promo Discount', controller.promoDiscount, isTotal: false, isDiscount: true),
          const Divider(height: 32, color: AppPalette.outline),
          _priceRow('Total Amount', controller.finalAmount.value > 0 ? controller.finalAmount : controller.baseAmount, isTotal: true),
        ],
      ),
    );
  }

  Widget _priceRow(String label, RxDouble amount, {required bool isTotal, bool isDiscount = false}) {
    return Obx(() => Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: GoogleFonts.poppins(
                color: isTotal ? AppPalette.textPrimary : AppPalette.textSecondary,
                fontSize: isTotal ? 16 : 14,
                fontWeight: isTotal ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
            Text(
              '${isDiscount ? "-" : ""}\$${amount.value.toStringAsFixed(2)}',
              style: GoogleFonts.poppins(
                color: isDiscount ? AppPalette.success : AppPalette.textPrimary,
                fontSize: isTotal ? 20 : 14,
                fontWeight: isTotal ? FontWeight.w800 : FontWeight.w600,
              ),
            ),
          ],
        ));
  }

  Widget _buildConfirmButton() {
    return Obx(() {
      final isLoading = controller.isCreatingBooking.value || controller.isPolling.value;
      return SizedBox(
        width: double.infinity,
        height: 60,
        child: ElevatedButton(
          onPressed: isLoading ? null : () => controller.confirmBooking(),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppPalette.brandBlue,
            foregroundColor: AppPalette.pureWhite,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            elevation: 0,
          ),
          child: isLoading
              ? const SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(color: AppPalette.pureWhite, strokeWidth: 2),
                )
              : Text(
                  'Confirm & Pay',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
        ),
      );
    });
  }
}