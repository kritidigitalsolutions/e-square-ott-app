import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import '../../../../constants/app_colors.dart';
import '../../../../constants/app_images.dart';
import '../../../../constants/app_text_styles.dart';
import '../../../../models/response/home_section_model.dart';
import '../../../../routes/app_pages.dart';
import '../../controller/home_controller.dart';
import '../../models/category_model.dart';
import 'popular_genres_section.dart';

class DynamicHomeSections extends GetView<HomeController> {
  const DynamicHomeSections({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final rawSections = controller.homeSections;
      final selectedCategory = controller.selectedCategoryFilter.value;

      List<HomeSection> sections;
      if (selectedCategory.toLowerCase() == 'all') {
        sections = rawSections;
      } else {
        final filterLower = selectedCategory.toLowerCase();
        sections = rawSections
            .map((sec) {
              final matchingDramas = sec.dramas.where((d) {
                final genreMatch =
                    d.genreDisplay.toLowerCase().contains(filterLower) ||
                    d.genres.any(
                      (g) => g.toLowerCase().contains(filterLower),
                    ) ||
                    d.genre.toLowerCase().contains(filterLower) ||
                    d.title.toLowerCase().contains(filterLower) ||
                    d.name.toLowerCase().contains(filterLower) ||
                    d.synopsis.toLowerCase().contains(filterLower) ||
                    d.description.toLowerCase().contains(filterLower);
                final sectionMatch =
                    sec.title.toLowerCase().contains(filterLower) ||
                    sec.slug.toLowerCase().contains(filterLower) ||
                    (sec.genre?.name.toLowerCase().contains(filterLower) ??
                        false);
                return genreMatch || sectionMatch;
              }).toList();

              return HomeSection(
                id: sec.id,
                title: sec.title,
                slug: sec.slug,
                subtitle: sec.subtitle,
                sectionType: sec.sectionType,
                genre: sec.genre,
                layout: sec.layout,
                displayOrder: sec.displayOrder,
                viewAllEnabled: sec.viewAllEnabled,
                totalItems: matchingDramas.length,
                dramas: matchingDramas,
              );
            })
            .where((sec) => sec.dramas.isNotEmpty)
            .toList();

        // Fallback: If no dynamic sections matched, extract matching dramas from all rawSections
        if (sections.isEmpty) {
          final allSectionDramas = <String, Drama>{};
          for (final sec in rawSections) {
            for (final d in sec.dramas) {
              final key = d.id.isNotEmpty
                  ? d.id
                  : (d.mongoId.isNotEmpty ? d.mongoId : d.title);
              allSectionDramas[key] = d;
            }
          }

          final fallbackDramas = allSectionDramas.values.where((d) {
            return d.genreDisplay.toLowerCase().contains(filterLower) ||
                d.genres.any((g) => g.toLowerCase().contains(filterLower)) ||
                d.genre.toLowerCase().contains(filterLower) ||
                d.title.toLowerCase().contains(filterLower) ||
                d.name.toLowerCase().contains(filterLower);
          }).toList();

          if (fallbackDramas.isNotEmpty) {
            sections = [
              HomeSection(
                id: 'filtered_$filterLower',
                title: '$selectedCategory Series',
                slug: filterLower,
                subtitle: 'Top handpicked $selectedCategory dramas',
                sectionType: 'standard',
                genre: null,
                layout: 'standard',
                displayOrder: 1,
                viewAllEnabled: false,
                totalItems: fallbackDramas.length,
                dramas: fallbackDramas,
              ),
            ];
          }
        }
      }

      if (sections.isEmpty && selectedCategory.toLowerCase() != 'all') {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildEmptyFilterState(selectedCategory),
            const SizedBox(height: 12),
            const PopularGenresSection(),
          ],
        );
      }

      if (sections.isEmpty) {
        return const PopularGenresSection();
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ...sections.asMap().entries.map((entry) {
            final index = entry.key;
            final section = entry.value;
            if (section.dramas.isEmpty) {
              return const SizedBox.shrink();
            }

            final isTrendingLayout =
                section.sectionType.toLowerCase() == 'trending' ||
                section.slug.toLowerCase().contains('trending') ||
                section.layout.toLowerCase().contains('top10') ||
                section.layout.toLowerCase().contains('rank');

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ── Dynamic Section Header
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: _buildSectionHeader(section),
                      ),
                      const SizedBox(height: 14),

                      // ── Dramas Horizontal List
                      if (isTrendingLayout)
                        _buildTrendingList(section.dramas)
                      else
                        _buildStandardList(section.dramas),
                    ],
                  ),
                ),

                // ── Insert Popular Genres after 2nd Section (Index 1)
                if (index == 1)
                  const Padding(
                    padding: EdgeInsets.only(bottom: 24),
                    child: PopularGenresSection(),
                  ),
              ],
            );
          }),

          // Fallback: If less than 2 dynamic sections, still show Popular Genres at the end
          if (sections.length < 2)
            const Padding(
              padding: EdgeInsets.only(bottom: 24),
              child: PopularGenresSection(),
            ),
        ],
      );
    });
  }

  Widget _buildEmptyFilterState(String category) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF14141E),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.08),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: const Center(
              child: FaIcon(
                FontAwesomeIcons.film,
                color: AppColors.primary,
                size: 20,
              ),
            ),
          ),
          const SizedBox(height: 14),
          Text(
            'No shows found in $category',
            textAlign: TextAlign.center,
            style: AppTextStyles.text16Bold.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Try picking another category or reset to explore all shows',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: AppTextStyles.fontFamily,
              color: Colors.white.withValues(alpha: 0.6),
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 16),
          GestureDetector(
            onTap: () {
              HapticFeedback.lightImpact();
              controller.resetCategoryFilter();
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                'Show All Shows',
                style: TextStyle(
                  fontFamily: AppTextStyles.fontFamily,
                  color: Colors.white,
                  fontSize: 12.5,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(HomeSection section) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        final titleLower = section.title.toLowerCase();
        final slugLower = section.slug.toLowerCase();

        if (titleLower.contains('new release') ||
            slugLower.contains('new_release') ||
            slugLower.contains('new-release') ||
            titleLower.contains('latest')) {
          Get.toNamed(Routes.newReleases);
        } else if (titleLower.contains('popular genre') ||
            titleLower.contains('categories') ||
            slugLower.contains('category')) {
          Get.toNamed(Routes.categories);
        } else {
          Get.toNamed(
            Routes.categoryDramas,
            arguments: CategoryModel(
              id: section.id,
              title: section.title,
              seriesCount: '${section.dramas.length} Dramas',
            ),
          );
        }
      },
      behavior: HitTestBehavior.opaque,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Row(
              children: [
                // Red Accent Bar
                Container(
                  width: 3.5,
                  height: 16,
                  decoration: BoxDecoration(
                    gradient: AppColors.primaryGradient,
                    borderRadius: BorderRadius.circular(2),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.6),
                        blurRadius: 6,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),

                // Dynamic Title Only
                Flexible(
                  child: Text(
                    section.title,
                    style: AppTextStyles.text18Bold.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.3,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),

          // View All Arrow Button
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.06),
              shape: BoxShape.circle,
            ),
            child: const Center(
              child: FaIcon(
                FontAwesomeIcons.chevronRight,
                color: AppColors.primary,
                size: 11,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Standard Poster List (Portrait cards)
  Widget _buildStandardList(List<Drama> dramas) {
    return SizedBox(
      height: 165,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: dramas.length,
        separatorBuilder: (context, index) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final drama = dramas[index];
          return _DynamicDramaPosterCard(drama: drama);
        },
      ),
    );
  }

  // ── Top 10 Ranked List (Trending Layout)
  Widget _buildTrendingList(List<Drama> dramas) {
    return SizedBox(
      height: 165,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: dramas.length,
        separatorBuilder: (context, index) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final drama = dramas[index];
          final rank = drama.trendingRank ?? (index + 1);
          return _DynamicTrendingCard(drama: drama, rank: rank);
        },
      ),
    );
  }
}

class _DynamicDramaPosterCard extends StatelessWidget {
  final Drama drama;
  const _DynamicDramaPosterCard({required this.drama});

  @override
  Widget build(BuildContext context) {
    final poster = drama.posterUrl.isNotEmpty
        ? drama.posterUrl
        : (drama.bannerUrl.isNotEmpty
              ? drama.bannerUrl
              : (drama.thumbnailUrl.isNotEmpty
                    ? drama.thumbnailUrl
                    : AppImages.banner1));

    final viewsText = drama.viewsFormatted.isNotEmpty
        ? drama.viewsFormatted
        : (drama.views.isNotEmpty
              ? drama.views
              : (drama.viewsCount > 0
                    ? (drama.viewsCount >= 1000000
                          ? '${(drama.viewsCount / 1000000).toStringAsFixed(1)}M'
                          : (drama.viewsCount >= 1000
                                ? '${(drama.viewsCount / 1000).toStringAsFixed(1)}k'
                                : '${drama.viewsCount}'))
                    : '1.2k'));

    return GestureDetector(
      onTap: () {
        Get.toNamed(Routes.dramaPlayer, arguments: drama);
      },
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 115,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Stack(
            fit: StackFit.expand,
            children: [
              CachedNetworkImage(
                imageUrl: poster,
                fit: BoxFit.fill,
                placeholder: (context, url) =>
                    Container(color: const Color(0xFF1B1B26)),
                errorWidget: (context, url, error) =>
                    Image.asset(AppImages.banner1, fit: BoxFit.fill),
              ),

              // Dark Bottom Gradient
              Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withValues(alpha: 0.75),
                      ],
                      stops: const [0.6, 1.0],
                    ),
                  ),
                ),
              ),

              // Top-Right Views Count Badge
              Positioned(
                top: 6,
                right: 6,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 5.5,
                    vertical: 2.5,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.72),
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.18),
                      width: 0.6,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.4),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const FaIcon(
                        FontAwesomeIcons.fire,
                        color: AppColors.primary,
                        size: 8.5,
                      ),
                      const SizedBox(width: 3.5),
                      Text(
                        viewsText,
                        style: const TextStyle(
                          fontFamily: AppTextStyles.fontFamily,
                          color: Colors.white,
                          fontSize: 9,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.2,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Rating Badge (Bottom-Left)
              if (drama.rating > 0)
                Positioned(
                  bottom: 6,
                  left: 6,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 5,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.75),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const FaIcon(
                          FontAwesomeIcons.solidStar,
                          color: Color(0xFFFFD700),
                          size: 8,
                        ),
                        const SizedBox(width: 3),
                        Text(
                          drama.rating.toStringAsFixed(1),
                          style: const TextStyle(
                            fontFamily: AppTextStyles.fontFamily,
                            color: Colors.white,
                            fontSize: 9,
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

class _DynamicTrendingCard extends StatelessWidget {
  final Drama drama;
  final int rank;

  const _DynamicTrendingCard({required this.drama, required this.rank});

  @override
  Widget build(BuildContext context) {
    final poster = drama.posterUrl.isNotEmpty
        ? drama.posterUrl
        : (drama.bannerUrl.isNotEmpty
              ? drama.bannerUrl
              : (drama.thumbnailUrl.isNotEmpty
                    ? drama.thumbnailUrl
                    : AppImages.banner1));

    final viewsText = drama.viewsFormatted.isNotEmpty
        ? drama.viewsFormatted
        : (drama.views.isNotEmpty
              ? drama.views
              : (drama.viewsCount > 0
                    ? (drama.viewsCount >= 1000000
                          ? '${(drama.viewsCount / 1000000).toStringAsFixed(1)}M'
                          : (drama.viewsCount >= 1000
                                ? '${(drama.viewsCount / 1000).toStringAsFixed(1)}k'
                                : '${drama.viewsCount}'))
                    : '1.2k'));

    return GestureDetector(
      onTap: () {
        Get.toNamed(Routes.dramaPlayer, arguments: drama);
      },
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 135,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            // Poster Image
            Positioned(
              right: 0,
              top: 0,
              bottom: 0,
              width: 110,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    CachedNetworkImage(
                      imageUrl: poster,
                      fit: BoxFit.fill,
                      placeholder: (context, url) =>
                          Container(color: const Color(0xFF1B1B26)),
                      errorWidget: (context, url, error) =>
                          Image.asset(AppImages.banner1, fit: BoxFit.fill),
                    ),
                    Positioned.fill(
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.black.withValues(alpha: 0.7),
                            ],
                            stops: const [0.65, 1.0],
                          ),
                        ),
                      ),
                    ),

                    // Top-Right Views Count Badge
                    Positioned(
                      top: 6,
                      right: 6,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 5.5,
                          vertical: 2.5,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.72),
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.18),
                            width: 0.6,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const FaIcon(
                              FontAwesomeIcons.fire,
                              color: AppColors.primary,
                              size: 8.5,
                            ),
                            const SizedBox(width: 3.5),
                            Text(
                              viewsText,
                              style: const TextStyle(
                                fontFamily: AppTextStyles.fontFamily,
                                color: Colors.white,
                                fontSize: 9,
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

            // Giant Rank Number (Netflix style)
            Positioned(
              left: 0,
              bottom: 0,
              child: Text(
                '$rank',
                style: TextStyle(
                  fontFamily: AppTextStyles.fontFamily,
                  fontSize: 72,
                  fontWeight: FontWeight.w900,
                  height: 0.9,
                  foreground: Paint()
                    ..style = PaintingStyle.stroke
                    ..strokeWidth = 3
                    ..color = AppColors.primary,
                  shadows: [
                    Shadow(
                      color: Colors.black.withValues(alpha: 0.9),
                      blurRadius: 10,
                      offset: const Offset(2, 2),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              left: 0,
              bottom: 0,
              child: Text(
                '$rank',
                style: const TextStyle(
                  fontFamily: AppTextStyles.fontFamily,
                  fontSize: 72,
                  fontWeight: FontWeight.w900,
                  height: 0.9,
                  color: Color(0xFF14141E),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

