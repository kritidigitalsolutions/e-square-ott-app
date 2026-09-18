import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
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
            onTap: () => Get.toNamed(Routes.categories),
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

    return GestureDetector(
      onTap: () => controller.onCategoryTap(cat),
      behavior: HitTestBehavior.opaque,
      child: Container(
        height: 76,
        decoration: BoxDecoration(
          color: const Color(0xFF14141E),
          borderRadius: BorderRadius.circular(13),
          border: Border.all(
            color: accent.withValues(alpha: 0.5),
            width: 1.2,
          ),
          boxShadow: [
            BoxShadow(
              color: accent.withValues(alpha: 0.25),
              blurRadius: 10,
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
                    fit: BoxFit.cover,
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
                        Colors.black.withValues(alpha: 0.3),
                        Colors.black.withValues(alpha: 0.7),
                        Colors.black.withValues(alpha: 0.92),
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
                        accent.withValues(alpha: 0.22),
                        Colors.transparent,
                        accent.withValues(alpha: 0.28),
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
                          color: accent.withValues(alpha: 0.6),
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
                      style: const TextStyle(
                        fontFamily: AppTextStyles.fontFamily,
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.2,
                        shadows: [
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
