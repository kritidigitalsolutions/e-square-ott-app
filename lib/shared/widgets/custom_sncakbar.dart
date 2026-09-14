import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:ui';

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
    _show(title: title ?? 'Heads up', message: message, type: SnackType.info);
  }

  static void warning(String message, {String? title}) {
    _show(title: title ?? 'Warning', message: message, type: SnackType.warning);
  }

  static void _show({
    required String title,
    required String message,
    required SnackType type,
  }) {
    if (Get.isSnackbarOpen) Get.closeCurrentSnackbar();

    final config = _getConfig(type);

    Get.snackbar(
      '',
      '',
      titleText: const SizedBox.shrink(),
      messageText: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: const Color(0xFF141414).withOpacity(0.92),
              border: Border.all(
                color: Colors.white.withOpacity(0.08),
                width: 1,
              ),
            ),
            padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Left accent strip
                Container(
                  width: 3,
                  height: 38,
                  margin: const EdgeInsets.only(right: 12, top: 1),
                  decoration: BoxDecoration(
                    color: config.accent,
                    borderRadius: BorderRadius.circular(4),
                    boxShadow: [
                      BoxShadow(
                        color: config.accent.withOpacity(0.6),
                        blurRadius: 8,
                        spreadRadius: 0.5,
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(7),
                  decoration: BoxDecoration(
                    color: config.accent.withOpacity(0.15),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(config.icon, color: config.accent, size: 18),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14.5,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.1,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        message,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.7),
                          fontSize: 12.5,
                          fontWeight: FontWeight.w400,
                          height: 1.35,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 6),
                GestureDetector(
                  onTap: () => Get.closeCurrentSnackbar(),
                  child: Padding(
                    padding: const EdgeInsets.all(2),
                    child: Icon(
                      Icons.close_rounded,
                      color: Colors.white.withOpacity(0.35),
                      size: 17,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      backgroundColor: Colors.transparent,
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      padding: EdgeInsets.zero,
      snackPosition: SnackPosition.TOP,
      snackStyle: SnackStyle.FLOATING,
      duration: const Duration(seconds: 3),
      forwardAnimationCurve: Curves.easeOutQuart,
      reverseAnimationCurve: Curves.easeInCubic,
      animationDuration: const Duration(milliseconds: 450),
      isDismissible: true,
      dismissDirection: DismissDirection.horizontal,
      boxShadows: [
        BoxShadow(
          color: Colors.black.withOpacity(0.4),
          blurRadius: 20,
          offset: const Offset(0, 8),
        ),
      ],
    );
  }

  static _SnackConfig _getConfig(SnackType type) {
    switch (type) {
      case SnackType.success:
        return _SnackConfig(
          icon: Icons.check_rounded,
          accent: const Color(0xFF2ED573),
        );
      case SnackType.error:
        return _SnackConfig(
          icon: Icons.priority_high_rounded,
          accent: const Color(0xFFFF4757),
        );
      case SnackType.info:
        return _SnackConfig(
          icon: Icons.info_rounded,
          accent: const Color(0xFF3B9EFF),
        );
      case SnackType.warning:
        return _SnackConfig(
          icon: Icons.warning_rounded,
          accent: const Color(0xFFFFA502),
        );
    }
  }
}

class _SnackConfig {
  final IconData icon;
  final Color accent;
  _SnackConfig({required this.icon, required this.accent});
}
