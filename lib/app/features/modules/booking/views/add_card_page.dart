import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/booking_controller.dart';
import 'package:carrental/app/core/themes/app_palette.dart';

class AddCardPage extends GetView<BookingController> {
  const AddCardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppPalette.pureWhite,
      appBar: AppBar(
        backgroundColor: AppPalette.brandBlue,
        foregroundColor: AppPalette.pureWhite,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: AppPalette.pureWhite),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'Add Payment Card',
          style: GoogleFonts.poppins(
            color: AppPalette.pureWhite,
            fontWeight: FontWeight.w700,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Card visual preview ────────────────────────────────────────
            // UPDATED: Now uses .value from the controller's observables
      Obx(() {
              final name = controller.cardName.value.isEmpty
                  ? 'CUSTOMER NAME'
                  : controller.cardName.value.toUpperCase();
              final phoneNumber = controller.cardNumber.value.isEmpty
                  ? '+263 77-000-0000'
                  : controller.cardNumber.value;

              return Container(
                height: 180,
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFF2E7D32), // EcoCash Green
                      Color(0xFF1B5E20),
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.green.withValues(alpha: 0.3),
                      blurRadius: 20,
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
                        Text(
                          'MOBILE WALLET',
                          style: GoogleFonts.poppins(
                            color: Colors.white70,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const Icon(Icons.account_balance_wallet, color: Colors.white70),
                      ],
                    ),
                    const Spacer(),
                    Text(
                      phoneNumber,
                      style: GoogleFonts.sourceCodePro(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      name,
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              );
            }),

            const SizedBox(height: 36),

            // ── Form fields ────────────────────────────────────────────────
          
        _fieldLabel('Full Name'), // Changed from Cardholder Name
const SizedBox(height: 8),
_buildField(
  controller: controller.cardNameController,
  hint: 'Benjamin Levi',
  inputType: TextInputType.name,
  icon: Icons.person_outline,
  onChanged: (val) => controller.cardName.value = val,
),
_fieldLabel('Mobile Money Number'), // Changed from Card Number
const SizedBox(height: 8),
_buildField(
  controller: controller.cardNumberController,
  hint: '0771 234 567', // Changed hint
  inputType: TextInputType.phone, // Changed to phone
  icon: Icons.phone_android, // Changed icon
  onChanged: (val) => controller.cardNumber.value = val,
  maxLength: 10, // Changed to 10 for ZIM mobile numbers
),

            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _fieldLabel('Expiry Date'),
                      const SizedBox(height: 8),
                      _buildField(
                        controller: controller.cardExpiryController,
                        hint: 'MM/YY',
                        inputType: TextInputType.number,
                        icon: Icons.calendar_today,
                        onChanged: (val) =>
                            controller.cardExpiry.value = val, // UPDATED
                        formatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          _ExpiryFormatter(),
                        ],
                        maxLength: 5,
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _fieldLabel('CVV'),
                      const SizedBox(height: 8),
                      _buildField(
                        controller: controller.cardCvvController,
                        hint: '•••',
                        inputType: TextInputType.number,
                        icon: Icons.lock_outline,
                        obscureText: true,
                        formatters: [FilteringTextInputFormatter.digitsOnly],
                        maxLength: 3,
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 36),

            // ── Save button ────────────────────────────────────────────────
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: () => controller.saveCard(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppPalette.brandBlue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  'Save Card',
                  style: GoogleFonts.poppins(
                    color: AppPalette.pureWhite,
                    fontWeight: FontWeight.w800,
                    fontSize: 16,
                  ),
                ),
              ),
            ),

            SizedBox(height: 16),
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.lock, size: 14, color: AppPalette.textDisabled),
                  SizedBox(width: 6),
                  Text(
                    'Your payment info is encrypted & secure',
                    style: GoogleFonts.poppins(
                      color: AppPalette.textDisabled,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _fieldLabel(String label) => Text(
        label,
        style: GoogleFonts.poppins(
          color: AppPalette.textPrimary,
          fontSize: 13,
          fontWeight: FontWeight.w600,
        ),
      );

  Widget _buildField({
    required TextEditingController controller,
    required String hint,
    required TextInputType inputType,
    required IconData icon,
    bool obscureText = false,
    List<TextInputFormatter>? formatters,
    int? maxLength,
    Function(String)? onChanged,
  }) {
    return TextField(
      controller: controller,
      keyboardType: inputType,
      obscureText: obscureText,
      inputFormatters: formatters,
      maxLength: maxLength,
      onChanged: onChanged,
      style: GoogleFonts.poppins(color: AppPalette.textPrimary, fontSize: 15),
      decoration: InputDecoration(
        filled: true,
        fillColor: AppPalette.pureWhite,
        counterText: '',
        hintText: hint,
        hintStyle:
            GoogleFonts.poppins(color: AppPalette.textDisabled, fontSize: 14),
        prefixIcon: Icon(icon, color: AppPalette.textDisabled, size: 20),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppPalette.outline),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppPalette.outline),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: AppPalette.brandBlue, width: 2),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
    );
  }
}

// ── Input formatters ───────────────────────────────────────────────────────

class _ExpiryFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    var text = newValue.text;
    if (text.length == 2 && !text.contains('/')) {
      text = '$text/';
    }
    return newValue.copyWith(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
    );
  }
}
