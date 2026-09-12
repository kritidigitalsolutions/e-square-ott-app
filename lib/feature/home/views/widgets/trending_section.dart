import 'package:flutter/material.dart';
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
        _buildSectionHeader('Trending', onTap: () {}),
        const SizedBox(height: 14),

        // 2x2 Grid using Column of Rows for optimal performance
        Column(
          children: [
            Row(
              children: [
                Expanded(child: _buildTrendingCard(controller.trendingList[0])),
                const SizedBox(width: 12),
                Expanded(child: _buildTrendingCard(controller.trendingList[1])),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(child: _buildTrendingCard(controller.trendingList[2])),
                const SizedBox(width: 12),
                Expanded(child: _buildTrendingCard(controller.trendingList[3])),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTrendingCard(MovieModel movie) {
    return GestureDetector(
      onTap: () => controller.onMovieTap(movie),
      child: Container(
        height: 230,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: const Color(0xFF161620),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Poster
              Image.asset(
                movie.image,
                fit: BoxFit.cover,
                errorBuilder: (_, e, s) =>
                    Container(color: const Color(0xFF1E1E26)),
              ),

              // Top Badges
              Positioned(
                top: 8,
                left: 8,
                right: 8,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [_buildMiniDarkBadge('▶ ${movie.plays}')],
                ),
              ),

              // Large Trending Ranking Number (1, 2, 3, 4) in Center
              if (movie.ranking != null)
                Center(
                  child: Text(
                    '${movie.ranking}',
                    style: TextStyle(
                      fontFamily: AppTextStyles.fontFamily,
                      fontSize: 78,
                      fontWeight: FontWeight.w900,
                      color: Colors.white.withValues(alpha: 0.9),
                      shadows: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.8),
                          blurRadius: 18,
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

  Widget _buildSectionHeader(String title, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            style: AppTextStyles.text18Bold.copyWith(color: Colors.white),
          ),
          const SizedBox(width: 4),
          const Icon(
            Icons.chevron_right_rounded,
            color: AppColors.primary,
            size: 20,
          ),
        ],
      ),
    );
  }

  Widget _buildMiniDarkBadge(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 7.5,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
