import 'package:e_square_ott_app/constants/enum.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import '../../../constants/app_colors.dart';
import '../../../constants/app_images.dart';
import '../../../constants/app_text_styles.dart';
import '../../../shared/widgets/custom_animation.dart';
import '../../../shared/widgets/custom_buttons.dart';
import '../../../shared/widgets/shimmer_loader.dart';
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
                    GestureDetector(
                      onTap: controller.openEditProfile,
                      child: Container(
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
                          child: Obx(() {
                            if (controller.profileStatus.value ==
                                    Status.loading &&
                                controller.profileData.value == null) {
                              return const CustomShimmer(
                                child: ShimmerBox(
                                  width: 44,
                                  height: 44,
                                  shape: BoxShape.circle,
                                ),
                              );
                            }
                            final avatar = controller.userAvatar.value;
                            if (avatar.startsWith('http')) {
                              return Image.network(
                                avatar,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) =>
                                    _buildAvatarFallback(),
                              );
                            }
                            return Image.asset(
                              AppImages.banner1,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) =>
                                  _buildAvatarFallback(),
                            );
                          }),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // ── Scrollable Profile Content
              Expanded(
                child: RefreshIndicator(
                  color: AppColors.primary,
                  backgroundColor: const Color(0xFF161622),
                  onRefresh: controller.fetchProfile,
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(
                      parent: BouncingScrollPhysics(),
                    ),
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
                            icon: FontAwesomeIcons.userPen,
                            title: 'Edit Profile'.tr,
                            onTap: controller.openEditProfile,
                          ),
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
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ── Top User Profile Header Card Widget
  Widget _buildUserProfileCard(ProfileController controller) {
    return Obx(() {
      if (controller.profileStatus.value == Status.loading &&
          controller.profileData.value == null) {
        return const ProfileUserCardShimmer();
      }

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
            // Avatar with subtle glow & tap to edit
            GestureDetector(
              onTap: controller.openEditProfile,
              child: Stack(
                children: [
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
                      child: Obx(() {
                        final avatar = controller.userAvatar.value;
                        if (avatar.startsWith('http')) {
                          return Image.network(
                            avatar,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) =>
                                _buildAvatarFallback(),
                          );
                        }
                        return Image.asset(
                          AppImages.banner1,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => _buildAvatarFallback(),
                        );
                      }),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        gradient: AppColors.primaryGradient,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: const Color(0xFF14141E),
                          width: 1.5,
                        ),
                      ),
                      child: const Center(
                        child: FaIcon(
                          FontAwesomeIcons.pen,
                          color: Colors.white,
                          size: 8,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 14),

            // Name & Email
            Expanded(
              child: GestureDetector(
                onTap: controller.openEditProfile,
                behavior: HitTestBehavior.opaque,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Obx(
                      () => Text(
                        controller.userName.value.isNotEmpty
                            ? controller.userName.value
                            : 'Your Profile',
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
                        controller.userEmail.value.isNotEmpty
                            ? controller.userEmail.value
                            : controller.userPhone.value,
                        style: AppTextStyles.text13Medium.copyWith(
                          color: const Color(0xFF9E9EAE),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // VIP Badge
            GestureDetector(
              onTap: controller.openSubscription,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 11,
                  vertical: 7,
                ),
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.35),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    FaIcon(
                      FontAwesomeIcons.crown,
                      color: Color(0xFF0C0B10),
                      size: 11,
                    ),
                    SizedBox(width: 4),
                    Text(
                      'VIP',
                      style: TextStyle(
                        fontFamily: AppTextStyles.fontFamily,
                        color: Color(0xFF0C0B10),
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.4,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 8),

            // Edit Profile Action Icon Button
            GestureDetector(
              onTap: controller.openEditProfile,
              behavior: HitTestBehavior.opaque,
              child: Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: const Color(0xFF1E1E2C),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.1),
                    width: 1,
                  ),
                ),
                child: const Center(
                  child: FaIcon(
                    FontAwesomeIcons.penToSquare,
                    color: Colors.white,
                    size: 13,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    });
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

  Widget _buildAvatarFallback() {
    return Container(
      color: const Color(0xFF2A2A38),
      child: const Center(
        child: FaIcon(
          FontAwesomeIcons.solidUser,
          color: Colors.white70,
          size: 24,
        ),
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
