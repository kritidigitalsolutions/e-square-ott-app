import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import '../../../constants/app_colors.dart';
import '../../../constants/app_text_styles.dart';
import '../../../models/response/admin_content_model.dart';
import '../../../shared/widgets/custom_animation.dart';
import '../../../shared/widgets/custom_buttons.dart';
import '../controller/home_controller.dart';
import '../models/category_model.dart';

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

                        // Two-line Title (e.g. "Romance Dramas")
                        Expanded(
                          child: Obx(() {
                            final title =
                                controller.selectedCategory.value.title;
                            return Text(
                              '${title.tr} ${'Dramas'.tr}',
                              style: AppTextStyles.text24Bold.copyWith(
                                color: Colors.white,
                                height: 1.15,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                            );
                          }),
                        ),
                      ],
                    ),
                  ),

                  // ── 2-Column Category Poster Grid
                  Expanded(
                    child: Obx(() {
                      final categoryTitle =
                          controller.selectedCategory.value.title.toLowerCase();
                      final allDramas = controller.allPriorityDramas;

                      final filtered = allDramas.where((d) {
                        final inGenreDisplay = d.genreDisplay
                            .toLowerCase()
                            .contains(categoryTitle);
                        final inGenres = d.genres.any(
                          (g) => g.toLowerCase().contains(categoryTitle),
                        );
                        return inGenreDisplay || inGenres;
                      }).toList();

                      final dramas =
                          filtered.isNotEmpty ? filtered : allDramas;

                      if (dramas.isEmpty) {
                        return Center(
                          child: Text(
                            'No dramas found'.tr,
                            style: AppTextStyles.text16Medium.copyWith(
                              color: Colors.white70,
                            ),
                          ),
                        );
                      }

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
                        itemCount: dramas.length,
                        itemBuilder: (context, index) {
                          return _buildPosterCard(dramas[index]);
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
  Widget _buildPosterCard(PriorityDrama drama) {
    final poster =
        drama.posterUrl.isNotEmpty ? drama.posterUrl : drama.bannerUrl;

    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        controller.onPriorityDramaTap(drama);
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          color: const Color(0xFF161620),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.08),
            width: 1,
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(13),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Poster Artwork
              if (poster.startsWith('http'))
                Image.network(
                  poster,
                  fit: BoxFit.cover,
                  errorBuilder: (_, e, s) => Container(
                    color: const Color(0xFF22222E),
                    child: const Center(
                      child: FaIcon(
                        FontAwesomeIcons.film,
                        color: Colors.white24,
                        size: 32,
                      ),
                    ),
                  ),
                )
              else
                Image.asset(
                  poster,
                  fit: BoxFit.cover,
                  errorBuilder: (_, e, s) => Container(
                    color: const Color(0xFF22222E),
                    child: const Center(
                      child: FaIcon(
                        FontAwesomeIcons.film,
                        color: Colors.white24,
                        size: 32,
                      ),
                    ),
                  ),
                ),

              // Gradient Overlay
              Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.transparent,
                        Colors.black.withValues(alpha: 0.8),
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      stops: const [0.5, 1.0],
                    ),
                  ),
                ),
              ),

              // Plays Badge on Top
              if (drama.viewsFormatted.isNotEmpty)
                Positioned(
                  top: 6,
                  right: 6,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 3,
                    ),
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
                          drama.viewsFormatted,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 9,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

              // Title and episodes at bottom
              Positioned(
                left: 8,
                right: 8,
                bottom: 8,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      drama.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontFamily: AppTextStyles.fontFamily,
                        color: Colors.white,
                        fontSize: 12.5,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    if (drama.genreDisplay.isNotEmpty)
                      Text(
                        drama.genreDisplay,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontFamily: AppTextStyles.fontFamily,
                          color: AppColors.primaryLight.withValues(alpha: 0.8),
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
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
