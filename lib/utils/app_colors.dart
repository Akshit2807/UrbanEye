// utils/app_colors.dart
import 'package:flutter/material.dart';

class AppColors {
  // Dark Primary Palette
  static const Color primary = Color(0xFF6366F1); // Bright indigo
  static const Color primaryLight = Color(0xFF818CF8);
  static const Color primaryDark = Color(0xFF4F46E5);

  // Secondary Palette
  static const Color secondary = Color(0xFF10B981); // Emerald
  static const Color secondaryLight = Color(0xFF34D399);
  static const Color secondaryDark = Color(0xFF059669);

  // Accent Colors
  static const Color accent = Color(0xFFFF6B6B); // Coral
  static const Color accentOrange = Color(0xFFFF8E53);
  static const Color accentYellow = Color(0xFFFFD93D);
  static const Color accentPink = Color(0xFFEC4899);

  // Dark Neutral Palette
  static const Color background = Color(0xFF0F172A); // Dark slate
  static const Color surface = Color(0xFF1E293B); // Slate 800
  static const Color surfaceVariant = Color(0xFF334155); // Slate 700
  static const Color textPrimary = Color(0xFFF8FAFC); // Almost white
  static const Color textSecondary = Color(0xFFCBD5E1); // Slate 300
  static const Color textTertiary = Color(0xFF94A3B8); // Slate 400

  // Status Colors
  static const Color success = Color(0xFF22C55E);
  static const Color warning = Color(0xFFFBBF24);
  static const Color error = Color(0xFFEF4444);
  static const Color info = Color(0xFF3B82F6);

  // Glass effects
  static Color glassWhite = Colors.white.withOpacity(0.1);
  static Color glassBlack = Colors.black.withOpacity(0.3);

  // Dark Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
  );

  static const LinearGradient secondaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF10B981), Color(0xFF059669)],
  );

  static const LinearGradient accentGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFFF6B6B), Color(0xFFFF8E53)],
  );

  static const LinearGradient backgroundGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFF0F172A), Color(0xFF1E293B)],
  );

  static const LinearGradient heroGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF6366F1),
      Color(0xFF8B5CF6),
      Color(0xFFEC4899),
    ],
  );

  static const LinearGradient shimmerGradient = LinearGradient(
    begin: Alignment(-1.0, -0.3),
    end: Alignment(1.0, 0.3),
    colors: [
      Color(0xFF334155),
      Color(0xFF475569),
      Color(0xFF334155),
    ],
  );
}