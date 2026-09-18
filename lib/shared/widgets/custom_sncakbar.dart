import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_text_styles.dart';

enum SnackType { success, error, info, warning }

class AppSnackbar {
  AppSnackbar._();

  static void success(String message, {String? title}) {
    _show(title: title ?? 'Success', message: message, type: SnackType.success);
  }

  static void error(String message, {String? title}) {
    _show(title: title ?? 'Oops!', message: message, type: SnackType.error);
  }

  static void info(String message, {String? title}) {
    _show(
      title: title ?? 'Notification',
      message: message,
      type: SnackType.info,
    );
  }

  static void warning(String message, {String? title}) {
    _show(title: title ?? 'Warning', message: message, type: SnackType.warning);
  }

  static void _show({
    required String title,
    required String message,
    required SnackType type,
  }) {
    HapticFeedback.lightImpact();

    if (Get.isSnackbarOpen) Get.closeCurrentSnackbar();

    final config = _getConfig(type);

    Get.snackbar(
      '',
      '',
      titleText: const SizedBox.shrink(),
      messageText: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xFF11111A).withValues(alpha: 0.95),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: config.accent.withValues(alpha: 0.35),
                width: 1.2,
              ),
              boxShadow: [
                BoxShadow(
                  color: config.accent.withValues(alpha: 0.22),
                  blurRadius: 24,
                  spreadRadius: 1,
                  offset: const Offset(0, 4),
                ),
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.75),
                  blurRadius: 28,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // ── Glowing Vertical Accent Line
                Container(
                  width: 3.5,
                  height: 36,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        config.accent.withValues(alpha: 0.6),
                        config.accent,
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                    borderRadius: BorderRadius.circular(2),
                    boxShadow: [
                      BoxShadow(
                        color: config.accent.withValues(alpha: 0.8),
                        blurRadius: 8,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),

                // ── Glowing Circular Icon Badge
                Container(
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    color: config.accent.withValues(alpha: 0.16),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: config.accent.withValues(alpha: 0.4),
                      width: 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: config.accent.withValues(alpha: 0.2),
                        blurRadius: 10,
                      ),
                    ],
                  ),
                  child: Center(
                    child: FaIcon(config.icon, color: config.accent, size: 14),
                  ),
                ),
                const SizedBox(width: 12),

                // ── Title & Message
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        title.tr,
                        style: const TextStyle(
                          fontFamily: AppTextStyles.fontFamily,
                          color: Colors.white,
                          fontSize: 14.5,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.2,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        message.tr,
                        style: TextStyle(
                          fontFamily: AppTextStyles.fontFamily,
                          color: Colors.white.withValues(alpha: 0.8),
                          fontSize: 12.5,
                          fontWeight: FontWeight.w400,
                          height: 1.3,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),

                // ── Close Button
                GestureDetector(
                  onTap: () => Get.closeCurrentSnackbar(),
                  behavior: HitTestBehavior.opaque,
                  child: Container(
                    width: 26,
                    height: 26,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.08),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: FaIcon(
                        FontAwesomeIcons.xmark,
                        color: Colors.white.withValues(alpha: 0.6),
                        size: 11,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      backgroundColor: Colors.transparent,
      margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      padding: EdgeInsets.zero,
      snackPosition: SnackPosition.TOP,
      snackStyle: SnackStyle.FLOATING,
      duration: const Duration(seconds: 3),
      forwardAnimationCurve: Curves.easeOutCubic,
      reverseAnimationCurve: Curves.easeInCubic,
      animationDuration: const Duration(milliseconds: 380),
      isDismissible: true,
      dismissDirection: DismissDirection.horizontal,
    );
  }

  static _SnackConfig _getConfig(SnackType type) {
    switch (type) {
      case SnackType.success:
        return _SnackConfig(
          icon: FontAwesomeIcons.check,
          accent: const Color(0xFF10B981), // Emerald Mint
        );
      case SnackType.error:
        return _SnackConfig(
          icon: FontAwesomeIcons.circleExclamation,
          accent: const Color(0xFFFF3B4E), // Coral Crimson
        );
      case SnackType.info:
        return _SnackConfig(
          icon: FontAwesomeIcons.circleInfo,
          accent: AppColors.primary, // Radiant Gold
        );
      case SnackType.warning:
        return _SnackConfig(
          icon: FontAwesomeIcons.triangleExclamation,
          accent: const Color(0xFFFFB800), // Radiant Amber Gold
        );
    }
  }
}

class _SnackConfig {
  final FaIconData icon;
  final Color accent;
  _SnackConfig({required this.icon, required this.accent});
}
