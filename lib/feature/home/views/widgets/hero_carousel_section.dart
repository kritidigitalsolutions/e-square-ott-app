import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import '../../../../constants/app_colors.dart';
import '../../../../constants/app_text_styles.dart';
import '../../controller/home_controller.dart';
import '../../models/movie_model.dart';

class HeroCarouselSection extends GetView<HomeController> {
  const HeroCarouselSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 410,
          child: CarouselSlider.builder(
            itemCount: controller.heroBanners.length,
            options: CarouselOptions(
              height: 410,
              viewportFraction: 0.82,
              enlargeCenterPage: true,
              enlargeFactor: 0.16,
              autoPlay: true,
              autoPlayInterval: const Duration(seconds: 5),
              autoPlayAnimationDuration: const Duration(milliseconds: 650),
              autoPlayCurve: Curves.fastOutSlowIn,
              enableInfiniteScroll: true,
              onPageChanged: (index, reason) =>
                  controller.onHeroPageChanged(index),
            ),
            itemBuilder: (context, index, realIndex) {
              final movie = controller.heroBanners[index];
              return _HeroBannerCard(movie: movie);
            },
          ),
        ),
        const SizedBox(height: 14),

        // ── Animated Page Indicator Dots / Capsule
        Obx(() {
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              controller.heroBanners.length,
              (index) {
                final isSelected = controller.currentHeroIndex.value == index;
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeOutCubic,
                  margin: const EdgeInsets.symmetric(horizontal: 3.5),
                  height: 6,
                  width: isSelected ? 22 : 6,
                  decoration: BoxDecoration(
                    gradient: isSelected ? AppColors.primaryGradient : null,
                    color: isSelected
                        ? null
                        : Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(4),
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: AppColors.primary.withValues(alpha: 0.5),
                              blurRadius: 6,
                              spreadRadius: 1,
                            ),
                          ]
                        : null,
                  ),
                );
              },
            ),
          );
        }),
      ],
    );
  }
}

class _HeroBannerCard extends GetView<HomeController> {
  const _HeroBannerCard({required this.movie});

  final MovieModel movie;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        controller.onMovieTap(movie);
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.12),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.15),
              blurRadius: 30,
              offset: const Offset(0, 10),
            ),
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.6),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(21),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // ── 1. Poster Image
              Image.asset(
                movie.image,
                fit: BoxFit.cover,
                errorBuilder: (_, e, s) => Container(
                  color: const Color(0xFF161622),
                  child: const Center(
                    child: FaIcon(
                      FontAwesomeIcons.film,
                      color: Colors.white24,
                      size: 40,
                    ),
                  ),
                ),
              ),

              // ── 2. Cinematic Multi-Stop Vignette Overlay
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.black.withValues(alpha: 0.35),
                        Colors.transparent,
                        Colors.black.withValues(alpha: 0.65),
                        Colors.black.withValues(alpha: 0.95),
                      ],
                      stops: const [0.0, 0.35, 0.7, 1.0],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ),
              ),

              // ── 3. Top Badges (Trending Pill + Plays)
              Positioned(
                top: 14,
                left: 14,
                right: 14,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Trending / Exclusive Tag
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.6),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: AppColors.primary.withValues(alpha: 0.6),
                          width: 0.8,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const FaIcon(
                            FontAwesomeIcons.fire,
                            color: AppColors.primary,
                            size: 10,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'EXCLUSIVE'.tr,
                            style: const TextStyle(
                              fontFamily: AppTextStyles.fontFamily,
                              color: AppColors.primary,
                              fontSize: 9.5,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Plays Badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.65),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.15),
                          width: 0.8,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const FaIcon(
                            FontAwesomeIcons.play,
                            color: Colors.white,
                            size: 8,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            movie.plays,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // ── 4. Bottom Info & CTA Action Buttons
              Positioned(
                left: 14,
                right: 14,
                bottom: 14,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Subtitle / Tag line
                    if (movie.subtitle != null) ...[
                      Text(
                        movie.subtitle!,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontFamily: AppTextStyles.fontFamily,
                          color: AppColors.primaryLight.withValues(alpha: 0.9),
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.2,
                        ),
                      ),
                      const SizedBox(height: 3),
                    ],

                    // Title
                    Text(
                      movie.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontFamily: AppTextStyles.fontFamily,
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                        letterSpacing: -0.3,
                        shadows: [
                          Shadow(
                            color: Colors.black,
                            blurRadius: 8,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Action Button Row
                    Row(
                      children: [
                        // Watch Now (Gold Gradient)
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              HapticFeedback.lightImpact();
                              controller.onMovieTap(movie);
                            },
                            child: Container(
                              height: 38,
                              decoration: BoxDecoration(
                                gradient: AppColors.primaryGradient,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.primary
                                        .withValues(alpha: 0.35),
                                    blurRadius: 10,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const FaIcon(
                                    FontAwesomeIcons.play,
                                    color: Color(0xFF0C0B10),
                                    size: 12,
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    'Watch Now'.tr,
                                    style: const TextStyle(
                                      fontFamily: AppTextStyles.fontFamily,
                                      color: Color(0xFF0C0B10),
                                      fontSize: 12.5,
                                      fontWeight: FontWeight.w900,
                                      letterSpacing: -0.2,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),

                        // My List Button (Glass)
                        GestureDetector(
                          onTap: () {
                            HapticFeedback.lightImpact();
                            controller.onMovieTap(movie);
                          },
                          child: Container(
                            width: 38,
                            height: 38,
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: Colors.white.withValues(alpha: 0.2),
                                width: 1,
                              ),
                            ),
                            child: const Center(
                              child: FaIcon(
                                FontAwesomeIcons.plus,
                                color: Colors.white,
                                size: 13,
                              ),
                            ),
                          ),
                        ),
                      ],
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
