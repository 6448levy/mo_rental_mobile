import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/booking_controller.dart';
import 'package:carrental/app/core/themes/app_palette.dart';

class AddCardPage extends GetView<BookingController> {
  const AddCardPage({super.key});

  // Theme constants - replaced by AppPalette

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
            Obx(() {
              final name = controller.cardNameController.text.isEmpty
                  ? 'YOUR NAME'
                  : controller.cardNameController.text.toUpperCase();
              final number = controller.cardNumberController.text.isEmpty
                  ? '**** **** **** ****'
                  : _formatCardNumber(controller.cardNumberController.text);
              final expiry = controller.cardExpiryController.text.isEmpty
                  ? 'MM/YY'
                  : controller.cardExpiryController.text;

              return Container(
                height: 200,
                width: double.infinity,
                padding: EdgeInsets.all(24),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFF1565C0),
                      Color(0xFF0D47A1),
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blue.withValues(alpha: 0.4),
                      blurRadius: 20,
                      offset: Offset(0, 10),
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
                          'MoRental',
                          style: GoogleFonts.poppins(
                            color: Colors.white70,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Row(
                          children: [
                            Container(
                              width: 28,
                              height: 28,
                              decoration: BoxDecoration(
                                color: Colors.orange.withValues(alpha: 0.9),
                                shape: BoxShape.circle,
                              ),
                            ),
                            Transform.translate(
                              offset: Offset(-10, 0),
                              child: Container(
                                width: 28,
                                height: 28,
                                decoration: BoxDecoration(
                                  color: Colors.redAccent.withValues(alpha: 0.8),
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Spacer(),
                    Text(
                      number,
                      style: GoogleFonts.sourceCodePro(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 3,
                      ),
                    ),
                    SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'CARD HOLDER',
                              style: GoogleFonts.poppins(
                                color: Colors.white54,
                                fontSize: 9,
                                letterSpacing: 1.2,
                              ),
                            ),
                            Text(
                              name,
                              style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              'EXPIRES',
                              style: GoogleFonts.poppins(
                                color: Colors.white54,
                                fontSize: 9,
                                letterSpacing: 1.2,
                              ),
                            ),
                            Text(
                              expiry,
                              style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              );
            }),

            const SizedBox(height: 36),

            // ── Form fields ────────────────────────────────────────────────
            _fieldLabel('Cardholder Name'),
            const SizedBox(height: 8),
            _buildField(
              controller: controller.cardNameController,
              hint: 'John Doe',
              inputType: TextInputType.name,
              icon: Icons.person_outline,
            ),

            const SizedBox(height: 20),
            _fieldLabel('Card Number'),
            const SizedBox(height: 8),
            _buildField(
              controller: controller.cardNumberController,
              hint: '1234 5678 9012 3456',
              inputType: TextInputType.number,
              icon: Icons.credit_card,
              formatters: [
                FilteringTextInputFormatter.digitsOnly,
                _CardNumberFormatter(),
              ],
              maxLength: 19,
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
  }) {
    return TextField(
      controller: controller,
      keyboardType: inputType,
      obscureText: obscureText,
      inputFormatters: formatters,
      maxLength: maxLength,
      onChanged: (_) {},
      style: GoogleFonts.poppins(color: AppPalette.textPrimary, fontSize: 15),
      decoration: InputDecoration(
        filled: true,
        fillColor: AppPalette.pureWhite,
        counterText: '',
        hintText: hint,
        hintStyle: GoogleFonts.poppins(color: AppPalette.textDisabled, fontSize: 14),
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

  String _formatCardNumber(String raw) {
    final digits = raw.replaceAll(' ', '');
    final buffer = StringBuffer();
    for (int i = 0; i < digits.length; i++) {
      if (i > 0 && i % 4 == 0) buffer.write(' ');
      buffer.write(digits[i]);
    }
    // Pad remaining
    final remaining = 16 - digits.length;
    for (int i = 0; i < remaining; i++) {
      if ((digits.length + i) % 4 == 0 && digits.length + i > 0) buffer.write(' ');
      buffer.write('*');
    }
    return buffer.toString();
  }
}

// ── Input formatters ───────────────────────────────────────────────────────

class _CardNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text.replaceAll(' ', '');
    final buffer = StringBuffer();
    for (int i = 0; i < text.length; i++) {
      if (i > 0 && i % 4 == 0) buffer.write(' ');
      buffer.write(text[i]);
    }
    final formatted = buffer.toString();
    return newValue.copyWith(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}

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
