import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import '../../../constants/app_colors.dart';
import '../../../constants/app_images.dart';
import '../../../constants/app_text_styles.dart';
import '../../../shared/widgets/custom_animation.dart';
import '../../../shared/widgets/custom_buttons.dart';
import '../../home/controller/home_controller.dart';
import '../controller/profile_controller.dart';

class ProfileTabView extends StatelessWidget {
  const ProfileTabView({super.key});

  @override
  Widget build(BuildContext context) {
    // Ensure ProfileController is available
    final controller = Get.put(ProfileController());

    return CustomScaffold(
      showAppBar: false,
      safeArea: false,
      backgroundColor: Colors.transparent,
      body: Stack(
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
                          child: FaIcon(
                            FontAwesomeIcons.chevronLeft,
                            color: Colors.white,
                            size: 15,
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
                            child: const FaIcon(
                              FontAwesomeIcons.solidUser,
                              color: Colors.white70,
                              size: 20,
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
                          icon: FontAwesomeIcons.bookmark,
                          title: 'Saved Series'.tr,
                          onTap: controller.openSavedSeries,
                        ),
                        _ProfileMenuItem(
                          icon: FontAwesomeIcons.clockRotateLeft,
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
                          icon: FontAwesomeIcons.crown,
                          title: 'Subscription'.tr,
                          onTap: controller.openSubscription,
                        ),
                        _ProfileMenuItem(
                          icon: FontAwesomeIcons.bell,
                          title: 'Notification'.tr,
                          onTap: controller.openNotification,
                        ),
                        _ProfileMenuItem(
                          icon: FontAwesomeIcons.gear,
                          title: 'Settings'.tr,
                          onTap: controller.openSettings,
                        ),
                        _ProfileMenuItem(
                          icon: FontAwesomeIcons.sliders,
                          title: 'Notification Settings'.tr,
                          onTap: controller.openNotificationSettings,
                        ),
                        // _ProfileMenuItem(
                        //   icon: FontAwesomeIcons.arrowRightFromBracket,
                        //   title: 'Log Out'.tr,
                        //   onTap: controller.logout,
                        // ),
                      ]),
                      const SizedBox(height: 24),

                      // ── Section 3: Policies & Terms
                      _buildGroupedCard([
                        _ProfileMenuItem(
                          icon: FontAwesomeIcons.shieldHalved,
                          title: 'Privacy Policy'.tr,
                          onTap: controller.openPrivacyPolicy,
                        ),
                        _ProfileMenuItem(
                          icon: FontAwesomeIcons.fileLines,
                          title: 'Terms & Conditions'.tr,
                          onTap: controller.openTermsAndConditions,
                        ),
                      ]),
                      const SizedBox(height: 28),

                      // ── Log Out Action Button
                      AppButton(
                        label: 'Log Out'.tr,
                        onPressed: controller.logout,
                        backgroundColor: const Color(0xFF1C1C26),
                        textColor: Colors.white,
                        height: 50,
                        borderRadius: 12,
                      ),
                      const SizedBox(height: 12),

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
      ),
    );
  }

  // ── Top User Profile Header Card Widget
  Widget _buildUserProfileCard(ProfileController controller) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF14141E).withValues(alpha: 0.85),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.1),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.4),
            blurRadius: 20,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          // Avatar with subtle glow
          Container(
            width: 58,
            height: 58,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: AppColors.primary.withValues(alpha: 0.6),
                width: 1.8,
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.25),
                  blurRadius: 10,
                  spreadRadius: 1,
                ),
              ],
            ),
            child: ClipOval(
              child: Image.asset(
                AppImages.banner1,
                fit: BoxFit.cover,
                errorBuilder: (_, e, s) => Container(
                  color: const Color(0xFF2A2A38),
                  child: const Center(
                    child: FaIcon(
                      FontAwesomeIcons.solidUser,
                      color: Colors.white70,
                      size: 24,
                    ),
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
                      letterSpacing: -0.2,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Obx(
                  () => Text(
                    controller.userEmail.value,
                    style: AppTextStyles.text13Medium.copyWith(
                      color: const Color(0xFF9E9EAE),
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
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF8B1218), Color(0xFFE42429)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFE42429).withValues(alpha: 0.35),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  FaIcon(FontAwesomeIcons.crown, color: Colors.white, size: 13),
                  SizedBox(width: 5),
                  Text(
                    'VIP',
                    style: TextStyle(
                      fontFamily: AppTextStyles.fontFamily,
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.4,
                    ),
                  ),
                ],
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
        color: const Color(0xFF14141E).withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.08),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          for (int i = 0; i < items.length; i++) ...[
            if (i > 0)
              Divider(
                height: 1,
                thickness: 0.8,
                color: Colors.white.withValues(alpha: 0.06),
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

  final FaIconData icon;
  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: const Color(0xFF1E1E2C).withValues(alpha: 0.6),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.06),
                  width: 0.8,
                ),
              ),
              child: Center(
                child: FaIcon(icon, size: 15, color: const Color(0xFFC0C0D4)),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                title,
                style: AppTextStyles.text14SemiBold.copyWith(
                  color: Colors.white,
                  letterSpacing: 0.1,
                ),
              ),
            ),
            const FaIcon(
              FontAwesomeIcons.chevronRight,
              size: 13,
              color: Color(0xFF6E6E82),
            ),
          ],
        ),
      ),
    );
  }
}
