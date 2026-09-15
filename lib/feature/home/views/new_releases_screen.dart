import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../../constants/app_colors.dart';
import '../../../constants/app_text_styles.dart';
import '../../../shared/widgets/custom_buttons.dart';
import '../controller/home_controller.dart';
import '../models/movie_model.dart';

class NewReleasesScreen extends GetView<HomeController> {
  const NewReleasesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
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
                  // ── Top Header Section (Back Button + Titles / In-line Search Field)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
                    child: Obx(() {
                      if (controller.isNewReleaseSearchOpen.value) {
                        return Row(
                          children: [
                            // Back Button (Always navigates back)
                            CustomBackButton(
                              onTap: () => Get.back(),
                            ),
                            const SizedBox(width: 12),

                            // In-line Search TextField Bar with dedicated Close Button
                            Expanded(
                              child: Container(
                                height: 44,
                                decoration: BoxDecoration(
                                  color: AppColors.cardBackground,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: const Color(0xFF2E2E3C),
                                    width: 1,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    const SizedBox(width: 12),
                                    const Icon(
                                      Icons.search_rounded,
                                      color: Color(0xFF6E6E7E),
                                      size: 20,
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: TextField(
                                        controller: controller
                                            .newReleaseSearchTextController,
                                        autofocus: true,
                                        cursorColor: AppColors.primary,
                                        style: AppTextStyles.text14Medium
                                            .copyWith(color: Colors.white),
                                        decoration: InputDecoration(
                                          hintText: 'Search new releases...',
                                          hintStyle:
                                              AppTextStyles.text14.copyWith(
                                            color: const Color(0xFF6E6E7E),
                                          ),
                                          border: InputBorder.none,
                                          isDense: true,
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                            vertical: 10,
                                          ),
                                        ),
                                      ),
                                    ),
                                    // Dedicated Close Button to hide search
                                    GestureDetector(
                                      onTap: controller.closeNewReleaseSearch,
                                      behavior: HitTestBehavior.opaque,
                                      child: const Padding(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 10,
                                          vertical: 8,
                                        ),
                                        child: Icon(
                                          Icons.close_rounded,
                                          color: Colors.white,
                                          size: 20,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        );
                      }

                      return Row(
                        children: [
                          // Back Button
                          CustomBackButton(onTap: () => Get.back()),
                          const SizedBox(width: 14),

                          // Title & Subtitle
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'New Releases',
                                  style: AppTextStyles.text24Bold.copyWith(
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  'Fresh stories, just for you',
                                  style: AppTextStyles.text14Medium.copyWith(
                                    color: const Color(0xFF8A8A8A),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Search Icon Button (Toggles in-line search)
                          GestureDetector(
                            onTap: controller.toggleNewReleaseSearch,
                            behavior: HitTestBehavior.opaque,
                            child: Container(
                              width: 42,
                              height: 42,
                              decoration: BoxDecoration(
                                color: const Color(0xFF1C1C1C),
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: const Color(0xFF2E2E2E),
                                  width: 1,
                                ),
                              ),
                              child: const Center(
                                child: Icon(
                                  Icons.search_rounded,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    }),
                  ),

                  const SizedBox(height: 6),

                  // ── Genre Filter Pill Bar
                  SizedBox(
                    height: 38,
                    child: ListView.separated(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      itemCount: controller.newReleaseGenres.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(width: 10),
                      itemBuilder: (context, index) {
                        final genre = controller.newReleaseGenres[index];
                        return Obx(() {
                          final isSelected =
                              controller.selectedNewReleaseGenre.value == genre;

                          return GestureDetector(
                            onTap: () =>
                                controller.selectNewReleaseGenre(genre),
                            behavior: HitTestBehavior.opaque,
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 18,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? AppColors.primary
                                    : const Color(0xFF1C1C24),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: isSelected
                                      ? AppColors.primary
                                      : const Color(0xFF2E2E3C),
                                  width: 1,
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  genre,
                                  style: TextStyle(
                                    fontFamily: AppTextStyles.fontFamily,
                                    fontSize: 13,
                                    fontWeight: isSelected
                                        ? FontWeight.w700
                                        : FontWeight.w500,
                                    color: isSelected
                                        ? Colors.white
                                        : const Color(0xFF8A8A9A),
                                  ),
                                ),
                              ),
                            ),
                          );
                        });
                      },
                    ),
                  ),

                  const SizedBox(height: 8),

                  // ── 2-Column Poster Grid
                  Expanded(
                    child: Obx(() {
                      final movies = controller.filteredNewReleases;

                      if (movies.isEmpty) {
                        final isSearching = controller
                            .newReleaseSearchQuery.value.isNotEmpty;
                        return Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 32),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  isSearching
                                      ? Icons.search_off_rounded
                                      : Icons.movie_filter_outlined,
                                  color: const Color(0xFF8A8A9A),
                                  size: 40,
                                ),
                                const SizedBox(height: 14),
                                Text(
                                  isSearching
                                      ? 'No releases found for "${controller.newReleaseSearchQuery.value}"'
                                      : 'No releases in "${controller.selectedNewReleaseGenre.value}"',
                                  textAlign: TextAlign.center,
                                  style: AppTextStyles.text16Bold.copyWith(
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }

                      return GridView.builder(
                        physics: const BouncingScrollPhysics(),
                        padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
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

  // ── Poster Card with Top-Left & Top-Right Badges
  Widget _buildPosterCard(MovieModel movie) {
    return GestureDetector(
      onTap: () => controller.onMovieTap(movie),
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
              Image.asset(
                movie.image,
                fit: BoxFit.cover,
                errorBuilder: (_, e, s) => Container(
                  color: const Color(0xFF22222E),
                  child: const Icon(
                    Icons.movie_outlined,
                    color: Colors.white30,
                    size: 32,
                  ),
                ),
              ),

              // Badges on Top
              Positioned(
                top: 6,
                right: 6,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2.5),
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
                        size: 10,
                      ),
                      const SizedBox(width: 1),
                      Text(
                        movie.plays,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 8.5,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
