import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import '../../../../constants/app_colors.dart';
import '../../../../constants/app_text_styles.dart';
import '../../../../models/response/admin_content_model.dart';
import '../../../../models/response/home_screen_model.dart';
import '../../../../shared/widgets/custom_sncakbar.dart';
import '../../controller/home_controller.dart';
import '../../controller/whislist_controller.dart';
import '../../datasource/whislist_datasource.dart';

class HeroCarouselSection extends GetView<HomeController> {
  const HeroCarouselSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final banners = controller.homeBanners;
      final fallbackDramas = controller.allPriorityDramas;

      if (banners.isEmpty && fallbackDramas.isEmpty) {
        return const SizedBox.shrink();
      }

      final itemCount = banners.isNotEmpty ? banners.length : fallbackDramas.length;

      return Column(
        children: [
          SizedBox(
            height: 410,
            child: CarouselSlider.builder(
              itemCount: itemCount,
              options: CarouselOptions(
                height: 410,
                viewportFraction: 0.82,
                enlargeCenterPage: true,
                enlargeFactor: 0.16,
                autoPlay: true,
                autoPlayInterval: const Duration(seconds: 5),
                autoPlayAnimationDuration: const Duration(milliseconds: 650),
                autoPlayCurve: Curves.fastOutSlowIn,
                enableInfiniteScroll: itemCount > 1,
                onPageChanged: (index, reason) =>
                    controller.onHeroPageChanged(index),
              ),
              itemBuilder: (context, index, realIndex) {
                if (banners.isNotEmpty) {
                  return _HeroHomeBannerCard(banner: banners[index]);
                } else {
                  return _HeroPriorityDramaCard(drama: fallbackDramas[index]);
                }
              },
            ),
          ),
          const SizedBox(height: 14),

          // ── Animated Page Indicator Dots / Capsule
          Obx(() {
            final activeIndex =
                controller.currentHeroIndex.value % itemCount;
            final visibleDots = itemCount > 8 ? 8 : itemCount;

            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                visibleDots,
                (index) {
                  final isSelected = (activeIndex % visibleDots) == index;
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
    });
  }
}

class _HeroHomeBannerCard extends GetView<HomeController> {
  const _HeroHomeBannerCard({required this.banner});

  final HomeBanner banner;

  @override
  Widget build(BuildContext context) {
    final poster = banner.posterUrl.isNotEmpty
        ? banner.posterUrl
        : (banner.bannerUrl.isNotEmpty ? banner.bannerUrl : '');

    final badgeText = banner.badge.isNotEmpty
        ? banner.badge
        : (banner.isPaid ? 'EXCLUSIVE' : 'TRENDING');

    final watchButtonLabel = banner.cta.primaryLabel.isNotEmpty
        ? banner.cta.primaryLabel
        : 'Watch Now';

    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        controller.onBannerTap(banner);
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
              if (poster.startsWith('http'))
                Image.network(
                  poster,
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
                )
              else if (poster.isNotEmpty)
                Image.asset(
                  poster,
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
                )
              else
                Container(
                  color: const Color(0xFF161622),
                  child: const Center(
                    child: FaIcon(
                      FontAwesomeIcons.film,
                      color: Colors.white24,
                      size: 40,
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

              // ── 3. Top Badges (Trending / Exclusive Pill + Plays)
              Positioned(
                top: 14,
                left: 14,
                right: 14,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Badge Pill
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
                            badgeText.tr.toUpperCase(),
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
                    if (banner.views.isNotEmpty || banner.viewsCount > 0)
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
                              banner.views.isNotEmpty
                                  ? banner.views
                                  : '${banner.viewsCount}',
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
                    // Tagline / Subtitle / Genre Info
                    if (banner.tagline.isNotEmpty ||
                        banner.genreDisplay.isNotEmpty ||
                        banner.totalEpisodes > 0) ...[
                      Text(
                        banner.tagline.isNotEmpty
                            ? banner.tagline
                            : '${banner.totalEpisodes > 0 ? "Episode ${banner.totalEpisodes} • " : ""}${banner.genreDisplay}',
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
                      banner.title,
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
                              controller.onBannerTap(banner);
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
                                    watchButtonLabel.tr,
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
                          onTap: () async {
                            HapticFeedback.lightImpact();
                            final targetId = banner.dramaId.isNotEmpty
                                ? banner.dramaId
                                : banner.id;
                            if (targetId.isNotEmpty) {
                              final whislistController =
                                  Get.isRegistered<WhislistController>()
                                      ? Get.find<WhislistController>()
                                      : Get.put(WhislistController());
                              await whislistController.toggleSavedSeries(
                                dramaId: targetId,
                              );
                            } else {
                              controller.onBannerTap(banner);
                            }
                          },
                          child: Obx(() {
                            final whislistController =
                                Get.isRegistered<WhislistController>()
                                    ? Get.find<WhislistController>()
                                    : Get.put(WhislistController());
                            final targetId = banner.dramaId.isNotEmpty
                                ? banner.dramaId
                                : banner.id;
                            final isSaved =
                                whislistController.isDramaSaved(targetId) ||
                                    banner.isSaved ||
                                    banner.isInWatchlist;

                            return Container(
                              width: 38,
                              height: 38,
                              decoration: BoxDecoration(
                                color: isSaved
                                    ? AppColors.primary.withValues(alpha: 0.25)
                                    : Colors.white.withValues(alpha: 0.12),
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: isSaved
                                      ? AppColors.primary.withValues(alpha: 0.6)
                                      : Colors.white.withValues(alpha: 0.2),
                                  width: 1,
                                ),
                              ),
                              child: Center(
                                child: FaIcon(
                                  isSaved
                                      ? FontAwesomeIcons.check
                                      : FontAwesomeIcons.plus,
                                  color: isSaved
                                      ? AppColors.primary
                                      : Colors.white,
                                  size: 13,
                                ),
                              ),
                            );
                          }),
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

class _HeroPriorityDramaCard extends GetView<HomeController> {
  const _HeroPriorityDramaCard({required this.drama});

  final PriorityDrama drama;

  @override
  Widget build(BuildContext context) {
    final poster = drama.posterUrl.isNotEmpty ? drama.posterUrl : drama.bannerUrl;

    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        controller.onPriorityDramaTap(drama);
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
              if (poster.startsWith('http'))
                Image.network(
                  poster,
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
                )
              else
                Image.asset(
                  poster,
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

              // ── 3. Top Badges (Trending / Exclusive Pill + Plays)
              Positioned(
                top: 14,
                left: 14,
                right: 14,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
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
                            drama.isTrending ? 'TRENDING'.tr : 'EXCLUSIVE'.tr,
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
                    if (drama.viewsFormatted.isNotEmpty)
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
                              drama.viewsFormatted,
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
                    if (drama.genreDisplay.isNotEmpty || drama.totalEpisodes > 0) ...[
                      Text(
                        '${drama.totalEpisodes > 0 ? "Episode ${drama.totalEpisodes} • " : ""}${drama.genreDisplay}',
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
                    Text(
                      drama.title,
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
                    Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              HapticFeedback.lightImpact();
                              controller.onPriorityDramaTap(drama);
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
                        GestureDetector(
                          onTap: () {
                            HapticFeedback.lightImpact();
                            controller.onPriorityDramaTap(drama);
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
