import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color(0xFF6C63FF);
  static const Color primaryLight = Color(0xFF8F88FF);
  static const Color secondary = Color(0xFF03DAC6);
  static const Color background = Color(0xFFFFFFFF);
  static const Color surface = Color(0xFFF5F5F5);
  static const Color error = Color(0xFFCF6679);
  static const Color textPrimary = Color(0xFF1A1A1A);
  static const Color textSecondary = Color(0xFF757575);
  static const Color textLight = Color(0xFF9E9E9E);
  static const Color border = Color(0xFFE0E0E0);
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFF9800);

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primary, primaryLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
