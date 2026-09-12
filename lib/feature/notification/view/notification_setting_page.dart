import 'package:e_square_ott_app/constants/app_colors.dart';
import 'package:e_square_ott_app/constants/app_text_styles.dart';
import 'package:e_square_ott_app/shared/widgets/custom_buttons.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/route_manager.dart';

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
  // Replace with real data from your controller/provider.
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
    // TODO: persist this change via your controller/API.
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: AppColors.loginBgGradient,
              ),
            ),
          ),
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomBackButton(onTap: () => Get.back()),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Text(
                          "Notifications Settings",
                          style: AppTextStyles.text24Bold.copyWith(
                            color: AppColors.white,
                            height: 1.18,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // Section label
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    "ALERTS",
                    style: AppTextStyles.text12.copyWith(
                      color: AppColors.white.withOpacity(0.5),
                      letterSpacing: 3,
                    ),
                  ),
                ),

                const SizedBox(height: 8),

                // Alerts list
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    itemCount: alertSettings.length,
                    separatorBuilder: (_, __) => Divider(
                      color: AppColors.white.withOpacity(0.1),
                      height: 32,
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
        ],
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
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppTextStyles.text18.copyWith(color: AppColors.white),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: AppTextStyles.text14.copyWith(
                  color: AppColors.white.withOpacity(0.5),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        Transform.scale(
          scale: 0.9,
          child: Switch(
            value: value,
            onChanged: onChanged,
            activeColor: Colors.white,
            activeTrackColor: const Color(0xFFE53935),
            inactiveThumbColor: Colors.grey.shade400,
            inactiveTrackColor: Colors.grey.shade800,
            trackOutlineColor: WidgetStateProperty.all(Colors.transparent),
          ),
        ),
      ],
    );
  }
}
