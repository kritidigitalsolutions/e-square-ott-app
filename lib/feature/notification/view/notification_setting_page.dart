import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import '../../../constants/app_colors.dart';
import '../../../constants/app_text_styles.dart';
import '../../../shared/widgets/custom_animation.dart';
import '../../../shared/widgets/custom_sncakbar.dart';

class NotificationSetting {
  final String key;
  final String title;
  final String subtitle;
  bool isEnabled;

  NotificationSetting({
    required this.key,
    required this.title,
    required this.subtitle,
    this.isEnabled = false,
  });
}

class NotificationSettingPage extends StatefulWidget {
  const NotificationSettingPage({super.key});

  @override
  State<NotificationSettingPage> createState() =>
      _NotificationSettingPageState();
}

class _NotificationSettingPageState extends State<NotificationSettingPage> {
  final List<NotificationSetting> alertSettings = [
    NotificationSetting(
      key: "new_episodes",
      title: "New episodes",
      subtitle: "Get notified when a series continues",
      isEnabled: true,
    ),
    NotificationSetting(
      key: "new_releases",
      title: "New releases",
      subtitle: "Discover newly added series",
      isEnabled: true,
    ),
    NotificationSetting(
      key: "recommendations",
      title: "Recommendations",
      subtitle: "Personalized stories for you",
      isEnabled: false,
    ),
  ];

  void _toggleSetting(int index, bool value) {
    setState(() {
      alertSettings[index].isEnabled = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: CustomScaffold(
        showAppBar: false,
        safeArea: true,
        backgroundColor: const Color(0xFF09090D),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 12),

            // ── Header (Back Button + Two-line Title)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Back button card
                  GestureDetector(
                    onTap: () => Get.back(),
                    child: Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: const Color(0xFF16161E),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.08),
                          width: 1,
                        ),
                      ),
                      child: const Center(
                        child: FaIcon(
                          FontAwesomeIcons.chevronLeft,
                          color: Colors.white,
                          size: 15,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),

                  // Multi-line Title matching screenshot
                  Expanded(
                    child: Text(
                      "Notifications Settings".tr,
                      style: const TextStyle(
                        fontFamily: AppTextStyles.fontFamily,
                        fontSize: 26,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        height: 1.15,
                        letterSpacing: 0.1,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 36),

            // ── Section Label (ALERTS)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                "A L E R T S",
                style: TextStyle(
                  fontFamily: AppTextStyles.fontFamily,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.white.withValues(alpha: 0.45),
                  letterSpacing: 2.2,
                ),
              ),
            ),

            const SizedBox(height: 16),

            // ── Alert Toggle Options List
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                physics: const BouncingScrollPhysics(),
                itemCount: alertSettings.length,
                separatorBuilder: (_, __) => Divider(
                  color: Colors.white.withValues(alpha: 0.08),
                  height: 36,
                  thickness: 1,
                ),
                itemBuilder: (context, index) {
                  final item = alertSettings[index];
                  return _AlertToggleRow(
                    title: item.title,
                    subtitle: item.subtitle,
                    value: item.isEnabled,
                    onChanged: (value) => _toggleSetting(index, value),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AlertToggleRow extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _AlertToggleRow({
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Title & Subtitle
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontFamily: AppTextStyles.fontFamily,
                  fontSize: 16.5,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                  letterSpacing: 0.1,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: TextStyle(
                  fontFamily: AppTextStyles.fontFamily,
                  fontSize: 12.5,
                  fontWeight: FontWeight.w400,
                  color: Colors.white.withValues(alpha: 0.4),
                  height: 1.3,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 16),

        // iOS-style Custom Red Switch matching design
        Switch.adaptive(
          value: value,
          onChanged: onChanged,
          activeColor: Colors.white,
          activeTrackColor: AppColors.primary,
          inactiveThumbColor: const Color(0xFF8E8E93),
          inactiveTrackColor: const Color(0xFF2C2C36),
          trackOutlineColor: WidgetStateProperty.all(Colors.transparent),
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
      ],
    );
  }
}
