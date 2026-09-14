import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../constants/app_colors.dart';
import '../../../constants/app_images.dart';
import '../../../constants/app_text_styles.dart';
import '../../../shared/widgets/custom_buttons.dart';
import '../../home/controller/home_controller.dart';
import '../controller/profile_controller.dart';

class ProfileTabView extends StatelessWidget {
  const ProfileTabView({super.key});

  @override
  Widget build(BuildContext context) {
    // Ensure ProfileController is available
    final controller = Get.put(ProfileController());

    return Stack(
      children: [
        Positioned.fill(
          child: Container(
            decoration: const BoxDecoration(
              gradient: AppColors.loginBgGradient,
            ),
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Top Header matching screenshot (< Profile Your Entertainment² space  [Avatar])
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 10),
              child: Row(
                children: [
                  // Back button
                  GestureDetector(
                    onTap: () {
                      if (Get.isRegistered<HomeController>()) {
                        Get.find<HomeController>().currentNavIndex.value = 0;
                      } else {
                        Get.back();
                      }
                    },
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
                        child: Icon(
                          Icons.arrow_back_ios_new_rounded,
                          color: Colors.white,
                          size: 18,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),

                  // Title & Subtitle
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Profile".tr,
                          style: AppTextStyles.text22Bold.copyWith(
                            color: AppColors.textPrimary,
                            height: 1.15,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          "Your Entertainment² space".tr,
                          style: AppTextStyles.text13Medium.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // User Avatar at top right
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.15),
                        width: 1.2,
                      ),
                    ),
                    child: ClipOval(
                      child: Image.asset(
                        AppImages.banner1,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          color: const Color(0xFF2A2A38),
                          child: const Icon(
                            Icons.person,
                            color: Colors.white70,
                            size: 24,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // ── Scrollable Profile Content
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 110),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ── Top User Profile Header Card
                    _buildUserProfileCard(controller),
                    const SizedBox(height: 24),

                    // ── Section 1: Your Library
                    Text(
                      'Your Library'.tr,
                      style: AppTextStyles.text16Bold.copyWith(
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildGroupedCard([
                      _ProfileMenuItem(
                        icon: Icons.bookmark_border_rounded,
                        title: 'Saved Series'.tr,
                        onTap: controller.openSavedSeries,
                      ),
                      _ProfileMenuItem(
                        icon: Icons.history_rounded,
                        title: 'Watch history'.tr,
                        onTap: controller.openWatchHistory,
                      ),
                    ]),
                    const SizedBox(height: 24),

                    // ── Section 2: Account
                    Text(
                      'Account'.tr,
                      style: AppTextStyles.text16Bold.copyWith(
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildGroupedCard([
                      _ProfileMenuItem(
                        icon: Icons.military_tech_rounded,
                        title: 'Subscription'.tr,
                        onTap: controller.openSubscription,
                      ),
                      _ProfileMenuItem(
                        icon: Icons.notifications_none_rounded,
                        title: 'Notification'.tr,
                        onTap: controller.openNotification,
                      ),
                      _ProfileMenuItem(
                        icon: Icons.settings_outlined,
                        title: 'Settings'.tr,
                        onTap: controller.openSettings,
                      ),
                      _ProfileMenuItem(
                        icon: Icons.notifications_active_outlined,
                        title: 'Notification Settings'.tr,
                        onTap: controller.openNotificationSettings,
                      ),
                    ]),
                    const SizedBox(height: 24),

                    // ── Section 3: Policies & Terms
                    _buildGroupedCard([
                      _ProfileMenuItem(
                        icon: Icons.verified_user_outlined,
                        title: 'Privacy Policy'.tr,
                        onTap: controller.openPrivacyPolicy,
                      ),
                      _ProfileMenuItem(
                        icon: Icons.description_outlined,
                        title: 'Terms & Conditions'.tr,
                        onTap: controller.openTermsAndConditions,
                      ),
                    ]),
                    const SizedBox(height: 28),

                    // ── Delete Account Button (Red solid)
                    AppButton(
                      label: 'Delete Account'.tr,
                      onPressed: controller.showDeleteAccountDialog,
                      backgroundColor: AppColors.primary,
                      height: 50,
                      borderRadius: 12,
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // ── Top User Profile Header Card Widget
  Widget _buildUserProfileCard(ProfileController controller) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          // Avatar
          Container(
            width: 58,
            height: 58,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0xFF3A3A4A), width: 1.5),
            ),
            child: ClipOval(
              child: Image.asset(
                AppImages.banner1,
                fit: BoxFit.cover,
                errorBuilder: (_, e, s) => Container(
                  color: const Color(0xFF2A2A38),
                  child: const Icon(
                    Icons.person,
                    color: Colors.white70,
                    size: 30,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 14),

          // Name & Email
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Obx(
                  () => Text(
                    controller.userName.value,
                    style: AppTextStyles.text20Bold.copyWith(
                      color: Colors.white,
                      height: 1.2,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Obx(
                  () => Text(
                    controller.userEmail.value,
                    style: AppTextStyles.text13Medium.copyWith(
                      color: const Color(0xFF8A8A8A),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Premium Badge Button
          GestureDetector(
            onTap: controller.openSubscription,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFF6B151B),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFF9E1E26), width: 0.8),
              ),
              child: const Text(
                'Premium',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Grouped Container Card Widget
  Widget _buildGroupedCard(List<_ProfileMenuItem> items) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          for (int i = 0; i < items.length; i++) ...[
            if (i > 0)
              Divider(
                height: 1,
                thickness: 1,
                color: AppColors.white.withValues(alpha: 0.1),
                indent: 16,
                endIndent: 16,
              ),
            items[i],
          ],
        ],
      ),
    );
  }
}

// ── Profile Menu List Item
class _ProfileMenuItem extends StatelessWidget {
  const _ProfileMenuItem({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Icon(icon, size: 20, color: const Color(0xFFB0B0C0)),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                title,
                style: AppTextStyles.text14Medium.copyWith(color: Colors.white),
              ),
            ),
            const Icon(
              Icons.chevron_right_rounded,
              size: 20,
              color: Color(0xFF6E6E7E),
            ),
          ],
        ),
      ),
    );
  }
}
