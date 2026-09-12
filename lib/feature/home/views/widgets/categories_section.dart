import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../constants/app_text_styles.dart';
import '../../../../routes/app_pages.dart';
import '../../controller/home_controller.dart';
import '../../models/category_model.dart';

class CategoriesSection extends GetView<HomeController> {
  const CategoriesSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ...controller.categoriesList.take(3).map((cat) {
          return Expanded(
            child: Padding(
              padding: const EdgeInsets.only(right: 8),
              child: _buildCategoryCard(cat),
            ),
          );
        }),

        // Arrow Button
        GestureDetector(
          onTap: () => Get.toNamed(Routes.categories),
          child: Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: const Color(0xFF1E1E26),
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0xFF2C2C3A), width: 1),
            ),
            child: const Center(
              child: Icon(
                Icons.arrow_forward_ios_rounded,
                color: Colors.white,
                size: 14,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryCard(CategoryModel cat) {
    return GestureDetector(
      onTap: () => controller.onCategoryTap(cat),
      behavior: HitTestBehavior.opaque,
      child: Container(
      height: 78,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: cat.gradientColors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: cat.gradientColors.first.withValues(alpha: 0.35),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(cat.emoji, style: const TextStyle(fontSize: 22)),
          Text(
            cat.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.text13SemiBold.copyWith(color: Colors.white),
          ),
        ],
      ),
    ),
  );
}
}
