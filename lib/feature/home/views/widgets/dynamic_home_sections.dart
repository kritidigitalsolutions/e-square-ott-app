import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import '../../../../constants/app_colors.dart';
import '../../../../constants/app_images.dart';
import '../../../../constants/app_text_styles.dart';
import '../../../../models/response/home_section_model.dart';
import '../../../../routes/app_pages.dart';
import '../../controller/home_controller.dart';

class DynamicHomeSections extends GetView<HomeController> {
  const DynamicHomeSections({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final sections = controller.homeSections;
      if (sections.isEmpty) {
        return const SizedBox.shrink();
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: sections.map((section) {
          if (section.dramas.isEmpty) {
            return const SizedBox.shrink();
          }

          final isTrendingLayout = section.sectionType.toLowerCase() == 'trending' ||
              section.slug.toLowerCase().contains('trending') ||
              section.layout.toLowerCase().contains('top10') ||
              section.layout.toLowerCase().contains('rank');

          return Padding(
            padding: const EdgeInsets.only(bottom: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Dynamic Section Header (from API, no static text)
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
          );
        }).toList(),
      );
    });
  }

  Widget _buildSectionHeader(HomeSection section) {
    return Row(
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

              // Dynamic Title + Subtitle
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      section.title,
                      style: AppTextStyles.text18Bold.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.3,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (section.subtitle.isNotEmpty) ...[
                      const SizedBox(height: 2),
                      Text(
                        section.subtitle,
                        style: const TextStyle(
                          fontFamily: AppTextStyles.fontFamily,
                          color: Color(0xFF8A8A9E),
                          fontSize: 11.5,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),

        // Optional View All Icon
        if (section.viewAllEnabled)
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.05),
              shape: BoxShape.circle,
            ),
            child: const FaIcon(
              FontAwesomeIcons.chevronRight,
              color: AppColors.primary,
              size: 11,
            ),
          ),
      ],
    );
  }

  // ── Standard Poster List (Portrait cards)
  Widget _buildStandardList(List<Drama> dramas) {
    return SizedBox(
      height: 195,
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
      height: 200,
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
            : (drama.thumbnailUrl.isNotEmpty ? drama.thumbnailUrl : AppImages.banner1));

    final title = drama.title.isNotEmpty ? drama.title : drama.name;
    final genre = drama.genreDisplay.isNotEmpty
        ? drama.genreDisplay
        : (drama.genres.isNotEmpty ? drama.genres.first : drama.genre);

    final ratingText = drama.rating > 0
        ? drama.rating.toStringAsFixed(1)
        : (drama.viewsFormatted.isNotEmpty ? drama.viewsFormatted : '');

    return GestureDetector(
      onTap: () {
        Get.toNamed(Routes.dramaPlayer, arguments: drama);
      },
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 115,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Poster Artwork with VIP/Free chip and Glass Highlight
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    CachedNetworkImage(
                      imageUrl: poster,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        color: const Color(0xFF1B1B26),
                      ),
                      errorWidget: (context, url, error) => Image.asset(
                        AppImages.banner1,
                        fit: BoxFit.cover,
                      ),
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

                    // Free / VIP Badge (Top-Right)
                    Positioned(
                      top: 6,
                      right: 6,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2.5,
                        ),
                        decoration: BoxDecoration(
                          color: drama.isPaid
                              ? const Color(0xFFFFB300)
                              : AppColors.primary,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          drama.isPaid ? 'VIP' : 'FREE',
                          style: const TextStyle(
                            fontFamily: AppTextStyles.fontFamily,
                            color: Colors.white,
                            fontSize: 9,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ),

                    // Rating / Views Badge (Bottom-Left)
                    if (ratingText.isNotEmpty)
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
                              FaIcon(
                                drama.rating > 0
                                    ? FontAwesomeIcons.solidStar
                                    : FontAwesomeIcons.play,
                                color: drama.rating > 0
                                    ? const Color(0xFFFFD700)
                                    : AppColors.primary,
                                size: 8,
                              ),
                              const SizedBox(width: 3),
                              Text(
                                ratingText,
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
            const SizedBox(height: 6),

            // Drama Title
            Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontFamily: AppTextStyles.fontFamily,
                color: Colors.white,
                fontSize: 12.5,
                fontWeight: FontWeight.w600,
              ),
            ),

            // Genre
            if (genre.isNotEmpty) ...[
              const SizedBox(height: 2),
              Text(
                genre,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontFamily: AppTextStyles.fontFamily,
                  color: Color(0xFF8A8A9E),
                  fontSize: 10.5,
                ),
              ),
            ],
          ],
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
            : (drama.thumbnailUrl.isNotEmpty ? drama.thumbnailUrl : AppImages.banner1));

    final title = drama.title.isNotEmpty ? drama.title : drama.name;

    return GestureDetector(
      onTap: () {
        Get.toNamed(Routes.dramaPlayer, arguments: drama);
      },
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 140,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            // Poster Image
            Positioned(
              right: 0,
              top: 0,
              bottom: 24,
              width: 110,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    CachedNetworkImage(
                      imageUrl: poster,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        color: const Color(0xFF1B1B26),
                      ),
                      errorWidget: (context, url, error) => Image.asset(
                        AppImages.banner1,
                        fit: BoxFit.cover,
                      ),
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
                  ],
                ),
              ),
            ),

            // Giant Rank Number (Netflix style)
            Positioned(
              left: 0,
              bottom: 12,
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
              bottom: 12,
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

            // Bottom Title
            Positioned(
              left: 30,
              right: 0,
              bottom: 0,
              child: Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontFamily: AppTextStyles.fontFamily,
                  color: Colors.white,
                  fontSize: 11.5,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
