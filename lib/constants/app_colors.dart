import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // ============================================================
  // Brand / Primary Colors (Cinematic Ruby & Crimson Velvet OTT)
  // ============================================================
  // OLD: static const Color primary = Color(0xFFE42429); // Plain normal red
  static const Color primary = Color(0xFFFF2B43); // Vibrant Cinematic Crimson

  // OLD: static const Color primaryDark = Color(0xFFC41D22);
  static const Color primaryDark = Color(0xFFA70019); // Deep Velvet Wine

  // OLD: static const Color primaryLight = Color(0xFFFF3D47);
  static const Color primaryLight = Color(
    0xFFFF4D6D,
  ); // Electric Rose Red / Neon Glow

  // OLD: static const Color primaryGradientStart = Color(0xFFE42429);
  static const Color primaryGradientStart = Color(0xFFFF334B);

  // OLD: static const Color primaryGradientEnd = Color(0xFFFF4147);
  static const Color primaryGradientEnd = Color(0xFFB8001F);

  // OLD: static const Color accent = Color(0xFFFF9900);
  static const Color accent = Color(0xFFFFB300); // Warm Amber Gold Accent

  // ============================================================
  // Background Colors (Deep Obsidian & Midnight OTT Theme)
  // ============================================================
  // OLD: static const Color background = Color(0xFF0F0F14);
  static const Color background = Color(0xFF0A0A0F);

  // OLD: static const Color scaffoldBackground = Color(0xFF0F0F14);
  static const Color scaffoldBackground = Color(0xFF0A0A0F);

  // OLD: static const Color surface = Color(0xFF1A1A24);
  static const Color surface = Color(0xFF13131C);

  // OLD: static const Color cardBackground = Color(0xFF202020);
  static const Color cardBackground = Color(0xFF181824);

  // OLD: static const Color bottomNavBackground = Color(0xFF13131A);
  static const Color bottomNavBackground = Color(0xFF0E0E14);

  static const Color white = Colors.white;

  // ============================================================
  // Text Colors
  // ============================================================
  static const Color textPrimary = Color(0xFFFFFFFF);

  // OLD: static const Color textSecondary = Color(0xFFA0A0B2);
  static const Color textSecondary = Color(0xFFB0B0C4);

  // OLD: static const Color textMuted = Color(0xFF6E6E82);
  static const Color textMuted = Color(0xFF68687E);

  static const Color textDark = Color(0xFF121216);

  // ============================================================
  // Border & Divider Colors
  // ============================================================
  // OLD: static const Color border = Color(0xFF2E2E40);
  static const Color border = Color(0xFF28283C);

  // OLD: static const Color divider = Color(0xFF252535);
  static const Color divider = Color(0xFF1E1E2E);

  // ============================================================
  // Glassmorphic & Surface Colors
  // ============================================================
  // OLD: static const Color glassSurface = Color(0xCC14141E);
  static const Color glassSurface = Color(0xDD12121B);

  // OLD: static const Color glassBorder = Color(0x1FFFFFFF);
  static const Color glassBorder = Color(
    0x24FF2B43,
  ); // Subtle crimson sheen border

  static const Color glassBorderLight = Color(0x33FFFFFF);

  // OLD: static const Color glassBackground = Color(0xD90B0B10);
  static const Color glassBackground = Color(0xE60A0A0F);

  // ============================================================
  // Status & Feedback Colors
  // ============================================================
  static const Color success = Color(0xFF00E676);
  static const Color error = Color(0xFFFF2D55);
  static const Color warning = Color(0xFFFFB300);
  static const Color info = Color(0xFF2979FF);

  // ============================================================
  // Gradients (Luxury Multi-Stop Cinematic Gradients)
  // ============================================================
  // OLD:
  // static const LinearGradient primaryGradient = LinearGradient(
  //   colors: [Color(0xFFE42429), Color(0xFFFF4147)],
  //   begin: Alignment.topLeft,
  //   end: Alignment.bottomRight,
  // );
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFFFF334B), Color(0xFFE50914), Color(0xFF9E0018)],
    stops: [0.0, 0.55, 1.0],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // OLD:
  // static const LinearGradient primaryGlowGradient = LinearGradient(
  //   colors: [Color(0xFFE42429), Color(0xFF8B0D12)],
  //   begin: Alignment.topLeft,
  //   end: Alignment.bottomRight,
  // );
  static const LinearGradient primaryGlowGradient = LinearGradient(
    colors: [Color(0xFFFF2B43), Color(0xFF5E000E)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // OLD:
  // static const LinearGradient loginBgGradient = LinearGradient(
  //   colors: [Color(0xFF010101), Color(0xFF161616)],
  //   begin: Alignment.topCenter,
  //   end: Alignment.bottomCenter,
  //   stops: [0.0, 0.6],
  // );
  static const LinearGradient loginBgGradient = LinearGradient(
    colors: [
      Color(0xFF1A0508), // Cinematic dark burgundy tint at top
      Color(0xFF0E0E14),
      Color(0xFF08080C),
    ],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    stops: [0.0, 0.45, 1.0],
  );

  // OLD:
  // static const LinearGradient overlayGradient = LinearGradient(
  //   colors: [Colors.transparent, Color(0xFF0F0F14)],
  //   begin: Alignment.topCenter,
  //   end: Alignment.bottomCenter,
  // );
  static const LinearGradient overlayGradient = LinearGradient(
    colors: [Colors.transparent, Color(0xFF0A0A0F)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  // OLD:
  // static const LinearGradient cardGradient = LinearGradient(
  //   colors: [Color(0xFF1E1E2C), Color(0xFF151520)],
  //   begin: Alignment.topLeft,
  //   end: Alignment.bottomRight,
  // );
  static const LinearGradient cardGradient = LinearGradient(
    colors: [Color(0xFF1C1C2A), Color(0xFF12121C)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient glassCardGradient = LinearGradient(
    colors: [Color(0x22FFFFFF), Color(0x08FFFFFF)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
