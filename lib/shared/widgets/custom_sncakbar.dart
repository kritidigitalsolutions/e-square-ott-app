import 'dart:async';
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

  static OverlayEntry? _currentEntry;
  static Timer? _dismissTimer;

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

    try {
      _dismissTimer?.cancel();
      _currentEntry?.remove();
      _currentEntry = null;
    } catch (_) {}

    OverlayState? overlay;
    try {
      if (Get.key.currentState?.overlay != null) {
        overlay = Get.key.currentState!.overlay;
      }
    } catch (_) {}

    if (overlay == null && Get.overlayContext != null) {
      try {
        overlay = Overlay.maybeOf(Get.overlayContext!);
      } catch (_) {}
    }

    if (overlay == null && Get.context != null) {
      try {
        overlay = Overlay.maybeOf(Get.context!);
      } catch (_) {}
    }

    final config = _getConfig(type);

    if (overlay == null) {
      Get.rawSnackbar(
        titleText: Text(
          title.tr,
          style: const TextStyle(
            fontFamily: AppTextStyles.fontFamily,
            color: Colors.white,
            fontSize: 14.5,
            fontWeight: FontWeight.w800,
            letterSpacing: 0.2,
          ),
        ),
        messageText: Text(
          message.tr,
          style: TextStyle(
            fontFamily: AppTextStyles.fontFamily,
            color: Colors.white.withValues(alpha: 0.8),
            fontSize: 12.5,
            fontWeight: FontWeight.w400,
            height: 1.3,
          ),
        ),
        backgroundColor: const Color(0xFF11111A),
        borderColor: config.accent.withValues(alpha: 0.35),
        borderWidth: 1.2,
        borderRadius: 18,
        margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        snackPosition: SnackPosition.TOP,
        duration: const Duration(seconds: 3),
        icon: Padding(
          padding: const EdgeInsets.only(left: 12),
          child: FaIcon(config.icon, color: config.accent, size: 16),
        ),
      );
      return;
    }

    late final OverlayEntry entry;

    entry = OverlayEntry(
      builder: (ctx) => _SnackToastWidget(
        title: title,
        message: message,
        config: config,
        onDismiss: () {
          try {
            if (_currentEntry == entry) {
              _dismissTimer?.cancel();
              _currentEntry = null;
            }
            entry.remove();
          } catch (_) {}
        },
      ),
    );

    _currentEntry = entry;
    overlay.insert(entry);
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

class _SnackToastWidget extends StatefulWidget {
  final String title;
  final String message;
  final _SnackConfig config;
  final VoidCallback onDismiss;

  const _SnackToastWidget({
    required this.title,
    required this.message,
    required this.config,
    required this.onDismiss,
  });

  @override
  State<_SnackToastWidget> createState() => _SnackToastWidgetState();
}

class _SnackToastWidgetState extends State<_SnackToastWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fadeAnimation;
  late final Animation<Offset> _slideAnimation;
  Timer? _autoDismissTimer;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 380),
      reverseDuration: const Duration(milliseconds: 280),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
      reverseCurve: Curves.easeInCubic,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, -0.6),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
      reverseCurve: Curves.easeInCubic,
    ));

    _controller.forward();

    _autoDismissTimer = Timer(const Duration(seconds: 3), () {
      _dismiss();
    });
  }

  void _dismiss() async {
    _autoDismissTimer?.cancel();
    if (mounted) {
      await _controller.reverse();
      if (mounted) {
        widget.onDismiss();
      }
    }
  }

  @override
  void dispose() {
    _autoDismissTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;

    return Positioned(
      top: topPadding + 8,
      left: 14,
      right: 14,
      child: Material(
        type: MaterialType.transparency,
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: SlideTransition(
            position: _slideAnimation,
            child: Dismissible(
              key: UniqueKey(),
              direction: DismissDirection.horizontal,
              onDismissed: (_) {
                widget.onDismiss();
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(18),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFF11111A).withValues(alpha: 0.95),
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(
                        color: widget.config.accent.withValues(alpha: 0.35),
                        width: 1.2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: widget.config.accent.withValues(alpha: 0.22),
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
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 12,
                    ),
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
                                widget.config.accent.withValues(alpha: 0.6),
                                widget.config.accent,
                              ],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ),
                            borderRadius: BorderRadius.circular(2),
                            boxShadow: [
                              BoxShadow(
                                color: widget.config.accent.withValues(alpha: 0.8),
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
                            color: widget.config.accent.withValues(alpha: 0.16),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: widget.config.accent.withValues(alpha: 0.4),
                              width: 1,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: widget.config.accent.withValues(alpha: 0.2),
                                blurRadius: 10,
                              ),
                            ],
                          ),
                          child: Center(
                            child: FaIcon(
                              widget.config.icon,
                              color: widget.config.accent,
                              size: 14,
                            ),
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
                                widget.title.tr,
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
                                widget.message.tr,
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
                          onTap: _dismiss,
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
            ),
          ),
        ),
      ),
    );
  }
}
