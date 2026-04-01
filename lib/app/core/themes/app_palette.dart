// core/themes/app_palette.dart
import 'package:flutter/material.dart';

class AppPalette {
  // Brand Primary Colors (MoRental Brand Identity)
  static const Color brandBlue = Color(0xFF0078D4); // Microsoft Azure Blue
  static const Color brandLightBlue = Color(0xFF50A8E8); // Azure Light Blue accent
  static const Color pureWhite = Color(0xFFFFFFFF); // Pure White (#FFFFFF)
  static const Color background = Color(0xFFFFFFFF); // Main background

  // Additional brand neutral shades for text and UI
  static const Color textPrimary = Color(0xFF1E293B); // Dark grey / black for readability
  static const Color textSecondary = Color(0xFF64748B); // Lighter text
  static const Color textDisabled = Color(0xFF94A3B8);
  static const Color outline = Color(0xFFE2E8F0); // For borders
  static const Color cardShadow = Color(0x1A000000); // Light shadow for cards
  
  // Semantic colors
  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);
  static const Color info = Color(0xFF3B82F6);
  
  // Gradient definitions
  static const LinearGradient brandGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [brandBlue, brandLightBlue],
  );

  // Legacy deep blue kept for reference if needed
  static const Color deepBlue = Color(0xFF0A3D7C);
}
