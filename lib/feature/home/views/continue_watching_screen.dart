import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../../constants/app_colors.dart';
import '../../../constants/app_text_styles.dart';
import '../../../shared/widgets/custom_buttons.dart';
import '../controller/home_controller.dart';
import '../models/movie_model.dart';

class ContinueWatchingScreen extends GetView<HomeController> {
  const ContinueWatchingScreen({super.key});

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
                  // ── Top Header (Back Button + Title)
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    child: Row(
                      children: [
                        CustomBackButton(
                          onTap: () => Get.back(),
                        ),
                        const SizedBox(width: 16),
                        Text(
                          'Continue Watching',
                          style: AppTextStyles.text22Bold.copyWith(
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // ── Cards List Area
                  Expanded(
                    child: Obx(() {
                      final items = controller.continueWatchingList;

                      if (items.isEmpty) {
                        return Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 32),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  width: 72,
                                  height: 72,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF1C1C26),
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: const Color(0xFF2E2E3E),
                                      width: 1,
                                    ),
                                  ),
                                  child: const Icon(
                                    Icons.video_library_outlined,
                                    color: Color(0xFF8A8A9A),
                                    size: 32,
                                  ),
                                ),
                                const SizedBox(height: 18),
                                Text(
                                  'No items in Continue Watching',
                                  style: AppTextStyles.text18Bold.copyWith(
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  'Shows you start watching will appear here so you can easily resume anytime.',
                                  textAlign: TextAlign.center,
                                  style: AppTextStyles.text13Medium.copyWith(
                                    color: const Color(0xFF8A8A8A),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }

                      return ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
                        itemCount: items.length,
                        itemBuilder: (context, index) {
                          return _buildContinueWatchingItemCard(items[index]);
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

  // ── Continue Watching Item Card matching Screenshot
  Widget _buildContinueWatchingItemCard(MovieModel movie) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          // ── Upper Row: Thumbnail + Info
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Movie Thumbnail Poster with Top Play Badge
              Container(
                width: 90,
                height: 110,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: const Color(0xFF161620),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.asset(
                        movie.image,
                        fit: BoxFit.cover,
                        errorBuilder: (_, e, s) => Container(
                          color: const Color(0xFF22222E),
                          child: const Icon(
                            Icons.movie,
                            color: Colors.white30,
                            size: 28,
                          ),
                        ),
                      ),
                      Positioned(
                        top: 4,
                        right: 4,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 4,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.65),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            '▶ ${movie.plays}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 7.5,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 14),

              // ── Details (Title, Delete Icon, Episode, Progress Bar, Remaining)
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title + Delete Icon
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            movie.title,
                            style: AppTextStyles.text16Bold.copyWith(
                              color: Colors.white,
                              height: 1.25,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        GestureDetector(
                          onTap: () => controller.removeContinueWatching(movie.id),
                          behavior: HitTestBehavior.opaque,
                          child: const Padding(
                            padding: EdgeInsets.only(left: 8, bottom: 4),
                            child: Icon(
                              Icons.delete_outline_rounded,
                              color: Color(0xFFB0B0C0),
                              size: 20,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),

                    // Episode Count
                    Text(
                      movie.episodeInfo ?? 'Episode 3 of 42',
                      style: AppTextStyles.text13Medium.copyWith(
                        color: const Color(0xFF8A8A8A),
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Progress Bar
                    ClipRRect(
                      borderRadius: BorderRadius.circular(3),
                      child: LinearProgressIndicator(
                        value: movie.progress ?? 0.65,
                        minHeight: 3.5,
                        backgroundColor: const Color(0xFF33333F),
                        valueColor: const AlwaysStoppedAnimation<Color>(
                          AppColors.primary,
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),

                    // Time Remaining
                    Text(
                      movie.remainingTime ?? '12 min remaining',
                      style: AppTextStyles.text12Medium.copyWith(
                        color: const Color(0xFF8A8A8A),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // ── Full-Width Red "Resume Watching" Button
          GestureDetector(
            onTap: () => controller.resumeWatching(movie),
            behavior: HitTestBehavior.opaque,
            child: Container(
              height: 44,
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Text(
                  'Resume Watching',
                  style: AppTextStyles.text14Bold.copyWith(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
