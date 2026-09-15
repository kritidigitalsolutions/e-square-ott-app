import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Brand / Primary Colors
  static const Color primary = Color(0xFFE42429); // E-Square brand red
  static const Color primaryDark = Color(0xFFC41D22);
  static const Color primaryLight = Color(0xFFFF3D47);
  static const Color primaryGradientStart = Color(0xFFE42429);
  static const Color primaryGradientEnd = Color(0xFFFF4147);
  static const Color accent = Color(0xFFFF9900);

  // Background Colors (Dark OTT Theme)
  static const Color background = Color(0xFF0F0F14);
  static const Color surface = Color(0xFF1A1A24);
  static const Color cardBackground = Color(0xFF202020);
  static const Color bottomNavBackground = Color(0xFF13131A);

  static const Color white = Colors.white;

  // Text Colors
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFFA0A0B2);
  static const Color textMuted = Color(0xFF6E6E82);
  static const Color textDark = Color(0xFF1C1C1E);

  // Border & Divider Colors
  static const Color border = Color(0xFF2E2E40);
  static const Color divider = Color(0xFF252535);

  // Glassmorphic & Surface Colors
  static const Color glassSurface = Color(0xCC14141E);
  static const Color glassBorder = Color(0x1FFFFFFF);
  static const Color glassBorderLight = Color(0x33FFFFFF);
  static const Color glassBackground = Color(0xD90B0B10);

  // Status & Feedback Colors
  static const Color success = Color(0xFF00C853);
  static const Color error = Color(0xFFFF3B30);
  static const Color warning = Color(0xFFFFCC00);
  static const Color info = Color(0xFF0A84FF);

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFFE42429), Color(0xFFFF4147)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient primaryGlowGradient = LinearGradient(
    colors: [Color(0xFFE42429), Color(0xFF8B0D12)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// Login screen background gradient: #010101 → #161616
  static const LinearGradient loginBgGradient = LinearGradient(
    colors: [Color(0xFF010101), Color(0xFF161616)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    stops: [0.0, 0.6],
  );

  static const LinearGradient overlayGradient = LinearGradient(
    colors: [Colors.transparent, Color(0xFF0F0F14)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient cardGradient = LinearGradient(
    colors: [Color(0xFF1E1E2C), Color(0xFF151520)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient glassCardGradient = LinearGradient(
    colors: [Color(0x22FFFFFF), Color(0x08FFFFFF)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
