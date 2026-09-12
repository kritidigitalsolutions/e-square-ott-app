import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../constants/app_colors.dart';
import '../../../../constants/app_text_styles.dart';
import '../../controller/home_controller.dart';
import '../../models/movie_model.dart';

class RecommendedSection extends GetView<HomeController> {
  const RecommendedSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('Recommended for you', onTap: () {}),
        const SizedBox(height: 14),

        // 3 Column Grid
        Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: _buildPosterCard(
                    controller.recommendedList[0],
                    height: 172,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _buildPosterCard(
                    controller.recommendedList[1],
                    height: 172,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _buildPosterCard(
                    controller.recommendedList[2],
                    height: 172,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: _buildPosterCard(
                    controller.recommendedList[3],
                    height: 172,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _buildPosterCard(
                    controller.recommendedList[4],
                    height: 172,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _buildPosterCard(
                    controller.recommendedList[5],
                    height: 172,
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPosterCard(
    MovieModel movie, {
    double? width,
    required double height,
  }) {
    return GestureDetector(
      onTap: () => controller.onMovieTap(movie),
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          color: const Color(0xFF161620),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(14),
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

              // Badges
              Positioned(
                top: 6,
                left: 6,
                right: 6,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [_buildMiniDarkBadge('▶ ${movie.plays}')],
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
