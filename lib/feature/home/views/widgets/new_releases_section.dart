import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import '../../../../constants/app_colors.dart';
import '../../../../constants/app_text_styles.dart';
import '../../../../routes/app_pages.dart';
import '../../controller/home_controller.dart';
import '../../models/movie_model.dart';

class NewReleasesSection extends GetView<HomeController> {
  const NewReleasesSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Header
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: _buildSectionHeader(
            'New Releases'.tr,
            onTap: () => Get.toNamed(Routes.newReleases),
          ),
        ),
        const SizedBox(height: 14),

        // Horizontal List
        SizedBox(
          height: 184,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: controller.newReleasesList.length,
            separatorBuilder: (context, index) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final movie = controller.newReleasesList[index];
              return _buildPosterCard(movie, width: 116, height: 184);
            },
          ),
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
                      const FaIcon(
                        FontAwesomeIcons.play,
                        color: Colors.white,
                        size: 8,
                      ),
                      const SizedBox(width: 3),
                      Text(
                        movie.plays,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 8.5,
                          fontWeight: FontWeight.bold,
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
          const SizedBox(width: 6),
          const FaIcon(
            FontAwesomeIcons.chevronRight,
            color: AppColors.primary,
            size: 13,
          ),
        ],
      ),
    );
  }
}
