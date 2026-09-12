export 'app_colors.dart';
export 'app_images.dart';
export 'app_sizes.dart';
export 'app_strings.dart';
export 'app_text_styles.dart';

class AppConstants {
  AppConstants._();

  // Animation Durations
  static const Duration defaultAnimationDuration = Duration(milliseconds: 300);
  static const Duration splashDuration = Duration(seconds: 2);
  static const Duration otpTimeoutDuration = Duration(seconds: 60);

  // Pagination / API defaults
  static const int defaultPageSize = 20;
  static const int apiTimeoutSeconds = 30;
}
