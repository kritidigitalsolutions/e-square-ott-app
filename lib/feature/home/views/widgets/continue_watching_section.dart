import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../constants/app_text_styles.dart';
import '../../../../routes/app_pages.dart';
import '../../controller/home_controller.dart';
import '../../models/movie_model.dart';

class ContinueWatchingSection extends GetView<HomeController> {
  const ContinueWatchingSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF15151E),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFF242432), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Title
          GestureDetector(
            onTap: () => Get.toNamed(Routes.continueWatching),
            behavior: HitTestBehavior.opaque,
            child: Text(
              'Continue Watching',
              style: AppTextStyles.text16Bold.copyWith(color: Colors.white),
            ),
          ),
          const SizedBox(height: 10),

          // Non-scrollable Row fitting 3 Cards + View All perfectly
          Row(
            children: [
              ...controller.continueWatchingList.take(3).map((movie) {
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: _buildContinueWatchingCard(movie),
                  ),
                );
              }),

              // View All Button
              GestureDetector(
                onTap: () => Get.toNamed(Routes.continueWatching),
                child: SizedBox(
                  width: 52,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: const Color(0xFF22222E),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: const Color(0xFF323242),
                            width: 1,
                          ),
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.arrow_forward_ios_rounded,
                            color: Colors.white,
                            size: 14,
                          ),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'View All',
                        textAlign: TextAlign.center,
                        style: AppTextStyles.text11Medium.copyWith(
                          color: const Color(0xFF8A8A8A),
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildContinueWatchingCard(MovieModel movie) {
    return GestureDetector(
      onTap: () => controller.onMovieTap(movie),
      child: AspectRatio(
        aspectRatio: 0.72,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Poster Image
              Image.asset(
                movie.image,
                fit: BoxFit.cover,
                errorBuilder: (_, e, s) => Container(
                  color: const Color(0xFF22222E),
                  child: const Icon(Icons.movie, color: Colors.white30, size: 24),
                ),
              ),

              // Top Right Play Badge
              Positioned(
                top: 4,
                right: 4,
                child: _buildMiniDarkBadge('▶ ${movie.plays}'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMiniDarkBadge(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.65),
        borderRadius: BorderRadius.circular(4),
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
