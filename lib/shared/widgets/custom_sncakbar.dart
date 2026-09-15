import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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
              color: const Color(0xFF101018).withValues(alpha: 0.94),
              border: Border.all(
                color: config.accent.withValues(alpha: 0.3),
                width: 1.2,
              ),
              boxShadow: [
                BoxShadow(
                  color: config.accent.withValues(alpha: 0.2),
                  blurRadius: 20,
                  spreadRadius: 1,
                  offset: const Offset(0, 4),
                ),
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.7),
                  blurRadius: 24,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: config.accent.withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: config.accent.withValues(alpha: 0.35),
                      width: 1,
                    ),
                  ),
                  child: FaIcon(
                    config.icon as FaIconData?,
                    color: config.accent,
                    size: 15,
                  ),
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
                          fontFamily: 'AfacadFlux',
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.1,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        message,
                        style: TextStyle(
                          fontFamily: 'AfacadFlux',
                          color: Colors.white.withValues(alpha: 0.78),
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                          height: 1.3,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: () => Get.closeCurrentSnackbar(),
                  behavior: HitTestBehavior.opaque,
                  child: Padding(
                    padding: const EdgeInsets.all(4),
                    child: FaIcon(
                      FontAwesomeIcons.xmark,
                      color: Colors.white.withValues(alpha: 0.4),
                      size: 15,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      backgroundColor: Colors.transparent,
      margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      padding: EdgeInsets.zero,
      snackPosition: SnackPosition.TOP,
      snackStyle: SnackStyle.FLOATING,
      duration: const Duration(seconds: 3),
      forwardAnimationCurve: Curves.easeOutQuart,
      reverseAnimationCurve: Curves.easeInCubic,
      animationDuration: const Duration(milliseconds: 400),
      isDismissible: true,
      dismissDirection: DismissDirection.horizontal,
    );
  }

  static _SnackConfig _getConfig(SnackType type) {
    switch (type) {
      case SnackType.success:
        return _SnackConfig(
          icon: FontAwesomeIcons.check,
          accent: const Color(0xFF2ED573),
        );
      case SnackType.error:
        return _SnackConfig(
          icon: FontAwesomeIcons.circleExclamation,
          accent: const Color(0xFFFF4757),
        );
      case SnackType.info:
        return _SnackConfig(
          icon: FontAwesomeIcons.circleInfo,
          accent: const Color(0xFF3B9EFF),
        );
      case SnackType.warning:
        return _SnackConfig(
          icon: FontAwesomeIcons.triangleExclamation,
          accent: const Color(0xFFFFA502),
        );
    }
  }
}

class _SnackConfig {
  final FaIconData icon; // was: FalconData
  final Color accent;
  _SnackConfig({required this.icon, required this.accent});
}
