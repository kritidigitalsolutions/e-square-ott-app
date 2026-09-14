import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../constants/app_colors.dart';
import '../../../../constants/app_text_styles.dart';
import '../../controller/home_controller.dart';

class CustomBottomNavBar extends GetView<HomeController> {
  const CustomBottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 16),
      height: 60,
      decoration: BoxDecoration(
        color: const Color(0xFF150A0C).withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(34),
        border: Border.all(color: const Color(0xFF331518), width: 1),
      ),
      child: Obx(() {
        final activeIndex = controller.currentNavIndex.value;
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(
              0,
              'Home'.tr,
              Icons.home_rounded,
              Icons.home_outlined,
              activeIndex,
            ),
            _buildNavItem(
              1,
              'Explore'.tr,
              Icons.smart_display_rounded,
              Icons.smart_display_outlined,
              activeIndex,
            ),
            _buildNavItem(
              2,
              'Profile'.tr,
              Icons.person_rounded,
              Icons.person_outline_rounded,
              activeIndex,
            ),
            _buildNavItem(
              3,
              'Search'.tr,
              Icons.search_rounded,
              Icons.search_rounded,
              activeIndex,
            ),
          ],
        );
      }),
    );
  }

  Widget _buildNavItem(
    int index,
    String label,
    IconData activeIcon,
    IconData inactiveIcon,
    int activeIndex,
  ) {
    final isSelected = activeIndex == index;

    return GestureDetector(
      onTap: () => controller.changeNavIndex(index),
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isSelected ? activeIcon : inactiveIcon,
            color: isSelected ? AppColors.primary : AppColors.white,
            size: 24,
          ),

          Text(
            label,
            style: TextStyle(
              fontFamily: AppTextStyles.fontFamily,
              fontSize: 11,
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              color: isSelected ? AppColors.primary : AppColors.white,
            ),
          ),
        ],
      ),
    );
  }
}
