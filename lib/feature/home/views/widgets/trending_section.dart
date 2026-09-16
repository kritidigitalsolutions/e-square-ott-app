import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import '../../../../constants/app_colors.dart';
import '../../../../constants/app_text_styles.dart';
import '../../controller/home_controller.dart';
import '../../models/movie_model.dart';

class TrendingSection extends GetView<HomeController> {
  const TrendingSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Section Header: Trending >
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: _buildSectionHeader('Trending', onTap: () {}),
        ),
        const SizedBox(height: 14),

        // ── Netflix Style Horizontal Carousel
        SizedBox(
          height: 196,
          child: Obx(() {
            final trendingMovies = controller.trendingList;

            return ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              itemCount: trendingMovies.length,
              separatorBuilder: (context, index) => const SizedBox(width: 12),
              itemBuilder: (context, index) {
                final movie = trendingMovies[index];
                final rank = movie.ranking ?? (index + 1);
                return _buildNetflixTrendingCard(
                  movie,
                  rank,
                  isFirst: index == 0,
                );
              },
            );
          }),
        ),
      ],
    );
  }

  // ── Netflix Top 10 Card (Giant Solid Red Number + Overlapping Poster)
  Widget _buildNetflixTrendingCard(
    MovieModel movie,
    int rank, {
    required bool isFirst,
  }) {
    return GestureDetector(
      onTap: () => controller.onMovieTap(movie),
      child: SizedBox(
        width: 156,
        height: 196,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            // ── 1. Giant Stylized Solid Red Number (Behind on Left)
            Positioned(
              left: -4,
              bottom: -18,
              child: Text(
                '$rank',
                style: TextStyle(
                  fontFamily: AppTextStyles.fontFamily,
                  fontSize: 108,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -6,
                  color: const Color(0xFFE42429),
                  shadows: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.6),
                      blurRadius: 8,
                      offset: const Offset(2, 2),
                    ),
                  ],
                ),
              ),
            ),

            // ── 2. Cinematic Overlapping Poster Card (On Right)
            Positioned(
              left: 44,
              right: 0,
              top: 0,
              bottom: 0,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  color: const Color(0xFF161620),
                  border: Border.all(
                    color: isFirst
                        ? const Color(0xFFE42429)
                        : Colors.white.withValues(alpha: 0.12),
                    width: isFirst ? 1.8 : 1.0,
                  ),
                  boxShadow: [
                    if (isFirst)
                      BoxShadow(
                        color: const Color(0xFFE42429).withValues(alpha: 0.45),
                        blurRadius: 14,
                        spreadRadius: 1,
                        offset: const Offset(0, 3),
                      )
                    else
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.55),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(13),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      // Poster Image
                      Image.asset(
                        movie.image,
                        fit: BoxFit.cover,
                        errorBuilder: (_, e, s) => Container(
                          color: const Color(0xFF1E1E26),
                          child: const Center(
                            child: FaIcon(
                              FontAwesomeIcons.film,
                              color: Colors.white24,
                              size: 24,
                            ),
                          ),
                        ),
                      ),

                      // Gradient Overlay for Readability
                      Positioned.fill(
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.black.withValues(alpha: 0.15),
                                Colors.transparent,
                                Colors.black.withValues(alpha: 0.85),
                              ],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              stops: const [0.0, 0.45, 1.0],
                            ),
                          ),
                        ),
                      ),

                      // Top-Right Plays Badge
                      Positioned(
                        top: 6,
                        right: 6,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 5.5,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.72),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const FaIcon(
                                FontAwesomeIcons.play,
                                color: Colors.white,
                                size: 7,
                              ),
                              const SizedBox(width: 3.5),
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

                      // Bottom Title
                      Positioned(
                        left: 8,
                        right: 8,
                        bottom: 8,
                        child: Text(
                          movie.title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontFamily: AppTextStyles.fontFamily,
                            color: Colors.white,
                            fontSize: 10.5,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.1,
                            height: 1.2,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            style: AppTextStyles.text18Bold.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.3,
            ),
          ),
          const SizedBox(width: 6),
          const FaIcon(
            FontAwesomeIcons.chevronRight,
            color: Color(0xFFE42429),
            size: 13,
          ),
        ],
      ),
    );
  }
}
