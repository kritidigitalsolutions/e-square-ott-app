import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../../constants/app_colors.dart';
import '../../../constants/app_text_styles.dart';
import '../../../shared/widgets/custom_animation.dart';
import '../../../shared/widgets/custom_buttons.dart';
import '../controller/home_controller.dart';
import '../models/category_model.dart';
import '../models/movie_model.dart';

class CategoryDramasScreen extends GetView<HomeController> {
  const CategoryDramasScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final CategoryModel? passedCategory = Get.arguments as CategoryModel?;
    if (passedCategory != null) {
      controller.selectedCategory.value = passedCategory;
    }

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: CustomScaffold(
        showAppBar: false,
        safeArea: false,
        backgroundColor: const Color(0xFF0D0D12),
        body: Stack(
          children: [
            // ── Background Ambient Gradient
            Positioned.fill(
              child: Container(
                decoration: const BoxDecoration(
                  gradient: AppColors.loginBgGradient,
                ),
              ),
            ),

            // ── Main Content
            SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Top Header Section (Back Button + Two-line Title)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Back Button
                        CustomBackButton(onTap: () => Get.back()),
                        const SizedBox(width: 14),

                        // Two-line Title (e.g. "Romance\nDramas")
                        Obx(() {
                          final title = controller.selectedCategory.value.title;
                          return Text(
                            '$title Dramas',
                            style: AppTextStyles.text24Bold.copyWith(
                              color: Colors.white,
                              height: 1.15,
                            ),
                          );
                        }),
                      ],
                    ),
                  ),

                  // ── 2-Column Category Poster Grid
                  Expanded(
                    child: Obx(() {
                      final movies = controller.categoryDramas;

                      return GridView.builder(
                        physics: const BouncingScrollPhysics(),
                        padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 12,
                              mainAxisSpacing: 14,
                              childAspectRatio: 0.68,
                            ),
                        itemCount: movies.length,
                        itemBuilder: (context, index) {
                          return _buildPosterCard(movies[index]);
                        },
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

  // ── Category Drama Poster Card with Dual Badges
  Widget _buildPosterCard(MovieModel movie) {
    return GestureDetector(
      onTap: () => controller.onMovieTap(movie),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          color: const Color(0xFF161620),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(14),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Poster Artwork
              Image.asset(
                movie.image,
                fit: BoxFit.cover,
                errorBuilder: (_, e, s) => Container(
                  color: const Color(0xFF22222E),
                  child: const Icon(
                    Icons.movie,
                    color: Colors.white30,
                    size: 32,
                  ),
                ),
              ),

              // Badges on Top
              Positioned(
                top: 6,
                left: 6,
                right: 6,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.65),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.play_arrow_rounded,
                            color: Colors.white,
                            size: 11,
                          ),
                          const SizedBox(width: 2),
                          Text(
                            movie.plays,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 9,
                              fontWeight: FontWeight.w700,
                            ),
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
