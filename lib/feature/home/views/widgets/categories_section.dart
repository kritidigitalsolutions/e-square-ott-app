import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import '../../../../constants/app_colors.dart';
import '../../../../constants/app_text_styles.dart';
import '../../../../routes/app_pages.dart';
import '../../controller/home_controller.dart';
import '../../models/category_model.dart';

class CategoriesSection extends GetView<HomeController> {
  const CategoriesSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final categories = controller.categoriesList.take(4).toList();

      return Row(
        children: [
          // 4 Category Cards
          ...categories.map((cat) {
            return Expanded(
              child: Padding(
                padding: const EdgeInsets.only(right: 8),
                child: _buildCategoryCard(cat),
              ),
            );
          }),

          // Dark Circular More Button (>)
          GestureDetector(
            onTap: () {
              HapticFeedback.lightImpact();
              Get.toNamed(Routes.categories);
            },
            behavior: HitTestBehavior.opaque,
            child: Container(
              width: 44,
              height: 76,
              decoration: BoxDecoration(
                color: const Color(0xFF14141E),
                borderRadius: BorderRadius.circular(13),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.1),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.4),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Center(
                child: Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.08),
                    shape: BoxShape.circle,
                  ),
                  child: const Center(
                    child: FaIcon(
                      FontAwesomeIcons.chevronRight,
                      color: Colors.white,
                      size: 12,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      );
    });
  }

  Widget _buildCategoryCard(CategoryModel cat) {
    final accent = cat.accentColor ?? cat.gradientColors.first;
    final isSelected = controller.selectedCategoryFilter.value.toLowerCase() ==
        cat.title.toLowerCase();

    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        controller.selectCategoryFilter(cat.title);
      },
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: 76,
        decoration: BoxDecoration(
          color: const Color(0xFF14141E),
          borderRadius: BorderRadius.circular(13),
          border: Border.all(
            color: isSelected ? Colors.white : accent.withValues(alpha: 0.5),
            width: isSelected ? 2.0 : 1.2,
          ),
          boxShadow: [
            BoxShadow(
              color: isSelected
                  ? accent.withValues(alpha: 0.6)
                  : accent.withValues(alpha: 0.25),
              blurRadius: isSelected ? 14 : 10,
              offset: const Offset(0, 3),
            ),
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.5),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // ── 1. Full-bleed Background Poster Image
              if (cat.posterImage != null)
                Positioned.fill(
                  child: Image.asset(
                    cat.posterImage!,
                    fit: BoxFit.fill,
                    errorBuilder: (_, e, s) => const SizedBox.shrink(),
                  ),
                ),

              // ── 2. Dark Multi-stop Gradient Scrim
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withValues(alpha: isSelected ? 0.15 : 0.3),
                        Colors.black.withValues(alpha: isSelected ? 0.55 : 0.7),
                        Colors.black.withValues(alpha: isSelected ? 0.85 : 0.92),
                      ],
                      stops: const [0.0, 0.5, 1.0],
                    ),
                  ),
                ),
              ),

              // ── 3. Subtle Color Accent Tint
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        accent.withValues(alpha: isSelected ? 0.4 : 0.22),
                        Colors.transparent,
                        accent.withValues(alpha: isSelected ? 0.45 : 0.28),
                      ],
                    ),
                  ),
                ),
              ),

              // ── 4. Center Icon and Title
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.5),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isSelected
                              ? Colors.white
                              : accent.withValues(alpha: 0.6),
                          width: 1,
                        ),
                      ),
                      child: Center(
                        child: FaIcon(
                          cat.icon,
                          color: Colors.white,
                          size: 13,
                        ),
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      cat.title.tr,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: AppTextStyles.fontFamily,
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight:
                            isSelected ? FontWeight.w900 : FontWeight.w700,
                        letterSpacing: 0.2,
                        shadows: const [
                          Shadow(
                            color: Colors.black,
                            blurRadius: 4,
                            offset: Offset(0, 1),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// ── Horizontal Category Filter Pills Bar (All, Romance, Drama, Comedy, etc.)
class CategoryFilterBar extends GetView<HomeController> {
  const CategoryFilterBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final selected = controller.selectedCategoryFilter.value;
      final filters = controller.homeCategoryFilters;

      return SizedBox(
        height: 36,
        child: ListView.separated(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          itemCount: filters.length,
          separatorBuilder: (_, __) => const SizedBox(width: 8),
          itemBuilder: (context, index) {
            final filter = filters[index];
            final isSelected = selected.toLowerCase() == filter.toLowerCase();

            return GestureDetector(
              onTap: () {
                HapticFeedback.selectionClick();
                controller.selectCategoryFilter(filter);
              },
              behavior: HitTestBehavior.opaque,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                decoration: BoxDecoration(
                  gradient: isSelected ? AppColors.primaryGradient : null,
                  color: isSelected ? null : const Color(0xFF14141E),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected
                        ? Colors.transparent
                        : Colors.white.withValues(alpha: 0.12),
                    width: 1,
                  ),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: AppColors.primary.withValues(alpha: 0.4),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ]
                      : null,
                ),
                child: Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (filter == 'All') ...[
                        FaIcon(
                          FontAwesomeIcons.shapes,
                          color: isSelected
                              ? Colors.white
                              : const Color(0xFF8A8A9E),
                          size: 11,
                        ),
                        const SizedBox(width: 6),
                      ],
                      Text(
                        filter.tr,
                        style: TextStyle(
                          fontFamily: AppTextStyles.fontFamily,
                          color: isSelected
                              ? Colors.white
                              : const Color(0xFFB0B0C4),
                          fontSize: 12,
                          fontWeight:
                              isSelected ? FontWeight.w700 : FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      );
    });
  }
}

