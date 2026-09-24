import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import '../../../../constants/app_colors.dart';
import '../../../../constants/app_images.dart';
import '../../../../constants/app_text_styles.dart';
import '../../../../routes/app_pages.dart';
import '../../controller/home_controller.dart';

class TopBarHeader extends GetView<HomeController> {
  const TopBarHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.background.withValues(alpha: 0.85),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // ── App Logo with subtle ambient glow
            GestureDetector(
              onTap: () {},
              child: Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withValues(alpha: 0.2),
                          blurRadius: 16,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: Image.asset(
                      AppImages.appLogo,
                      height: 36,
                      fit: BoxFit.contain,
                      errorBuilder: (_, e, s) => Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          gradient: AppColors.primaryGradient,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Text(
                          'E²',
                          style: TextStyle(
                            color: Color(0xFF0C0B10),
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // ── Right Actions: VIP Badge + Search + Notifications
            Row(
              children: [
                // VIP / Premium Pill
                GestureDetector(
                  onTap: () {
                    HapticFeedback.lightImpact();
                    Get.toNamed(Routes.subscriptionPage);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
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
                      children: [
                        const FaIcon(
                          FontAwesomeIcons.crown,
                          color: Color(0xFF0C0B10),
                          size: 11,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'VIP'.tr,
                          style: const TextStyle(
                            fontFamily: AppTextStyles.fontFamily,
                            color: Color(0xFF0C0B10),
                            fontSize: 11,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 8),

                // Search Button
                GestureDetector(
                  onTap: () {
                    HapticFeedback.lightImpact();
                    controller.changeNavIndex(3);
                  },
                  behavior: HitTestBehavior.opaque,
                  child: Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      color: const Color(0xFF151522),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.1),
                        width: 1,
                      ),
                    ),
                    child: const Center(
                      child: FaIcon(
                        FontAwesomeIcons.magnifyingGlass,
                        color: Colors.white,
                        size: 14,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),

                // Notification Bell Button
                GestureDetector(
                  onTap: () {
                    HapticFeedback.lightImpact();
                    controller.openNotifications();
                  },
                  behavior: HitTestBehavior.opaque,
                  child: Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      color: const Color(0xFF151522),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.1),
                        width: 1,
                      ),
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        const FaIcon(
                          FontAwesomeIcons.bell,
                          color: Colors.white,
                          size: 15,
                        ),
                        Obx(() {
                          final count = controller.unreadNotifications.value;
                          if (count <= 0) {
                            return const SizedBox.shrink();
                          }
                          final countText = count > 99 ? '99+' : '$count';
                          return Positioned(
                            top: 4,
                            right: 4,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 4,
                                vertical: 1.5,
                              ),
                              decoration: BoxDecoration(
                                gradient: AppColors.primaryGradient,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.primary.withValues(
                                      alpha: 0.7,
                                    ),
                                    blurRadius: 6,
                                    spreadRadius: 1,
                                  ),
                                ],
                              ),
                              constraints: const BoxConstraints(
                                minWidth: 16,
                                minHeight: 16,
                              ),
                              child: Center(
                                child: Text(
                                  countText,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    color: Color(0xFF0C0B10),
                                    fontSize: 8.5,
                                    fontWeight: FontWeight.w900,
                                    height: 1.0,
                                  ),
                                ),
                              ),
                            ),
                          );
                        }),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
