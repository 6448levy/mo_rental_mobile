import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final String hintText;
  final bool obscureText;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final int? maxLength;
  final bool enabled;
  final void Function(String)? onChanged;
  final Color? fillColor;
  final Color? textColor;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.labelText,
    required this.hintText,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.prefixIcon,
    this.suffixIcon,
    this.maxLength,
    this.enabled = true,
    this.onChanged,
    this.fillColor,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      validator: validator,
      maxLength: maxLength,
      enabled: enabled,
      onChanged: onChanged,
      style: TextStyle(color: textColor ?? (isDark ? Colors.white : Colors.black)),
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: TextStyle(color: (isDark ? Colors.white70 : Colors.black54)),
        hintText: hintText,
        hintStyle: TextStyle(color: (isDark ? Colors.white38 : Colors.black38)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: isDark ? Colors.white10 : Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: isDark ? Colors.white10 : Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 2),
        ),
        prefixIcon: prefixIcon != null ? IconTheme(
          data: IconThemeData(color: isDark ? Colors.white70 : Colors.black54),
          child: prefixIcon!,
        ) : null,
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: fillColor ?? (isDark ? const Color(0xFF16213E) : Colors.grey[50]),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 18,
        ),
      ),
    );
  }
}

class CustomElevatedButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isLoading;
  final double height;
  final Color? backgroundColor;
  final Color? textColor;

  const CustomElevatedButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.height = 50,
    this.backgroundColor,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: height,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor ?? Theme.of(context).primaryColor,
          foregroundColor: textColor ?? Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 2,
        ),
        child: isLoading
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation(Colors.white),
                ),
              )
            : Text(
                text,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
      ),
    );
  }
}
