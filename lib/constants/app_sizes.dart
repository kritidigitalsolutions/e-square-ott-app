import 'package:flutter/material.dart';

class AppSizes {
  AppSizes._();

  // Spacing & Padding
  static const double p4 = 4.0;
  static const double p8 = 8.0;
  static const double p12 = 12.0;
  static const double p16 = 16.0;
  static const double p20 = 20.0;
  static const double p24 = 24.0;
  static const double p28 = 28.0;
  static const double p32 = 32.0;
  static const double p40 = 40.0;
  static const double p48 = 48.0;

  // Border Radii
  static const double radiusSmall = 6.0;
  static const double radiusMedium = 12.0;
  static const double radiusLarge = 16.0;
  static const double radiusExtraLarge = 24.0;
  static const double radiusCircular = 100.0;

  static BorderRadius get borderRadiusSmall => BorderRadius.circular(radiusSmall);
  static BorderRadius get borderRadiusMedium => BorderRadius.circular(radiusMedium);
  static BorderRadius get borderRadiusLarge => BorderRadius.circular(radiusLarge);
  static BorderRadius get borderRadiusExtraLarge => BorderRadius.circular(radiusExtraLarge);
  static BorderRadius get borderRadiusCircular => BorderRadius.circular(radiusCircular);

  // Icon Sizes
  static const double iconSmall = 16.0;
  static const double iconMedium = 24.0;
  static const double iconLarge = 32.0;
  static const double iconExtraLarge = 48.0;

  // Button Heights
  static const double buttonHeight = 52.0;
  static const double buttonHeightSmall = 40.0;

  // Vertical SizedBox Spacers
  static const SizedBox vGap4 = SizedBox(height: 4.0);
  static const SizedBox vGap8 = SizedBox(height: 8.0);
  static const SizedBox vGap12 = SizedBox(height: 12.0);
  static const SizedBox vGap16 = SizedBox(height: 16.0);
  static const SizedBox vGap20 = SizedBox(height: 20.0);
  static const SizedBox vGap24 = SizedBox(height: 24.0);
  static const SizedBox vGap32 = SizedBox(height: 32.0);
  static const SizedBox vGap40 = SizedBox(height: 40.0);
  static const SizedBox vGap48 = SizedBox(height: 48.0);

  // Horizontal SizedBox Spacers
  static const SizedBox hGap4 = SizedBox(width: 4.0);
  static const SizedBox hGap8 = SizedBox(width: 8.0);
  static const SizedBox hGap12 = SizedBox(width: 12.0);
  static const SizedBox hGap16 = SizedBox(width: 16.0);
  static const SizedBox hGap20 = SizedBox(width: 20.0);
  static const SizedBox hGap24 = SizedBox(width: 24.0);
  static const SizedBox hGap32 = SizedBox(width: 32.0);
}
