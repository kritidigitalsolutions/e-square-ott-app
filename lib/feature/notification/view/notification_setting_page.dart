import 'package:e_square_ott_app/shared/widgets/custom_buttons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../../constants/app_colors.dart';
import '../../../constants/app_text_styles.dart';
import '../../../constants/enum.dart';
import '../../../shared/widgets/custom_animation.dart';
import '../../../shared/widgets/shimmer_loader.dart';
import '../controller/notifcation_controller.dart';

class NotificationSettingPage extends StatelessWidget {
  const NotificationSettingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(NotifcationController());

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: CustomScaffold(
        showAppBar: false,
        safeArea: false,
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
                  // ── Top Header (Aligned with NotificationPage & Other Screens)
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CustomBackButton(onTap: () => Get.back()),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                "Notification Settings".tr,
                                style: AppTextStyles.text20Bold.copyWith(
                                  color: AppColors.white,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                "Manage your alert preferences".tr,
                                style: AppTextStyles.text12.copyWith(
                                  color: AppColors.white.withOpacity(0.5),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

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

                  const SizedBox(height: 12),

                  // ── Alert Toggle Options List
                  Expanded(
                    child: Obx(() {
                      if (controller.getNotificationStatus.value ==
                              Status.loading &&
                          controller.notificationSettingResponse.value ==
                              null) {
                        return _buildShimmerLoading();
                      }

                      return RefreshIndicator(
                        color: AppColors.primary,
                        backgroundColor: const Color(0xFF161622),
                        onRefresh: controller.fetchNotificationSettings,
                        child: ListView(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          physics: const AlwaysScrollableScrollPhysics(
                            parent: BouncingScrollPhysics(),
                          ),
                          children: [
                            // New Episodes
                            _AlertToggleRow(
                              title: "New episodes".tr,
                              subtitle:
                                  "Get notified when a series continues".tr,
                              value: controller.newNotification.value,
                              onChanged: controller.toggleNewEpisodes,
                            ),
                            _buildDivider(),

                            // New Releases
                            _AlertToggleRow(
                              title: "New releases".tr,
                              subtitle: "Discover newly added series".tr,
                              value: controller.newReleases.value,
                              onChanged: controller.toggleNewReleases,
                            ),
                            _buildDivider(),

                            // Recommendations
                            _AlertToggleRow(
                              title: "Recommendations".tr,
                              subtitle: "Personalized stories for you".tr,
                              value: controller.newRecomdation.value,
                              onChanged: controller.toggleRecommendations,
                            ),
                          ],
                        ),
                      );
                    }),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Divider(
      color: Colors.white.withValues(alpha: 0.08),
      height: 32,
      thickness: 1,
    );
  }

  Widget _buildShimmerLoading() {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 3,
      separatorBuilder: (_, __) => _buildDivider(),
      itemBuilder: (_, __) {
        return CustomShimmer(
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    ShimmerBox(
                      width: 130,
                      height: 16,
                      borderRadius: 4,
                    ),
                    SizedBox(height: 8),
                    ShimmerBox(
                      width: 210,
                      height: 12,
                      borderRadius: 4,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              const ShimmerBox(
                width: 48,
                height: 28,
                borderRadius: 14,
              ),
            ],
          ),
        );
      },
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
    return InkWell(
      onTap: () => onChanged(!value),
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Title & Subtitle
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
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

          // iOS-style Custom Switch
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
      ),
    );
  }
}
