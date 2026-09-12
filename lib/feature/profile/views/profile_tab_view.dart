import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../constants/app_colors.dart';
import '../../../constants/app_images.dart';
import '../../../constants/app_text_styles.dart';
import '../../../shared/widgets/custom_buttons.dart';
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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Profile",
                    style: AppTextStyles.text20Bold.copyWith(
                      color: AppColors.textPrimary,
                    ),
                  ),
                  Text(
                    "Your Entertainment² space",
                    style: AppTextStyles.text14Medium.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 110),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ── Top User Profile Header Card
                    _buildUserProfileCard(controller),
                    const SizedBox(height: 24),

                    // ── Section 1: Your Library
                    Text(
                      'Your Library',
                      style: AppTextStyles.text16Bold.copyWith(
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildGroupedCard([
                      _ProfileMenuItem(
                        icon: Icons.bookmark_border_rounded,
                        title: 'Saved Series',
                        onTap: controller.openSavedSeries,
                      ),
                      _ProfileMenuItem(
                        icon: Icons.history_rounded,
                        title: 'Watch history',
                        onTap: controller.openWatchHistory,
                      ),
                    ]),
                    const SizedBox(height: 24),

                    // ── Section 2: Account
                    Text(
                      'Account',
                      style: AppTextStyles.text16Bold.copyWith(
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildGroupedCard([
                      _ProfileMenuItem(
                        icon: Icons.workspace_premium_outlined,
                        title: 'Subscription',
                        onTap: controller.openSubscription,
                      ),
                      _ProfileMenuItem(
                        icon: Icons.notifications_none_rounded,
                        title: 'Notification',
                        onTap: controller.openNotification,
                      ),
                      _ProfileMenuItem(
                        icon: Icons.settings_outlined,
                        title: 'Settings',
                        onTap: controller.openSettings,
                      ),
                      _ProfileMenuItem(
                        icon: Icons.notifications_active_outlined,
                        title: 'Notification Settings',
                        onTap: controller.openNotificationSettings,
                      ),
                    ]),
                    const SizedBox(height: 24),

                    // ── Section 3: Policies & Terms
                    _buildGroupedCard([
                      _ProfileMenuItem(
                        icon: Icons.shield_outlined,
                        title: 'Privacy Policy',
                        onTap: controller.openPrivacyPolicy,
                      ),
                      _ProfileMenuItem(
                        icon: Icons.description_outlined,
                        title: 'Terms & Conditions',
                        onTap: controller.openTermsAndConditions,
                      ),
                    ]),
                    const SizedBox(height: 28),

                    // ── Delete Account Button (Red solid)
                    AppButton(
                      label: 'Delete Account',
                      onPressed: controller.showDeleteAccountDialog,
                      backgroundColor: AppColors.primary,
                      height: 50,
                      borderRadius: 10,
                    ),
                    const SizedBox(height: 14),

                    // ── Log Out Button (Dark outlined)
                    GestureDetector(
                      onTap: controller.logout,
                      behavior: HitTestBehavior.opaque,
                      child: Container(
                        height: 50,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: const Color(0xFF14141A),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: const Color(0xFF383848),
                            width: 1,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            'Log Out',
                            style: AppTextStyles.text16SemiBold.copyWith(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
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
