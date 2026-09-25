import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import '../../../../constants/app_colors.dart';
import '../../../../constants/app_text_styles.dart';
import '../../../../models/response/admin_content_model.dart';
import '../../controller/home_controller.dart';

class TrendingSection extends GetView<HomeController> {
  const TrendingSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final trendingMovies = controller.trendingDramas;
      if (trendingMovies.isEmpty) return const SizedBox.shrink();

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Section Header: Trending >
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: _buildSectionHeader('Trending'.tr, onTap: () {}),
          ),
          const SizedBox(height: 14),

          // ── Netflix / Prime Top 10 Horizontal Carousel
          SizedBox(
            height: 200,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              itemCount: trendingMovies.length,
              separatorBuilder: (context, index) => const SizedBox(width: 12),
              itemBuilder: (context, index) {
                final drama = trendingMovies[index];
                final rank = index + 1;
                return _TrendingCard(
                  drama: drama,
                  rank: rank,
                  isFirst: index == 0,
                );
              },
            ),
          ),
          const SizedBox(height: 24),
        ],
      );
    });
  }

  Widget _buildSectionHeader(String title, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
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
              Text(
                title,
                style: AppTextStyles.text18Bold.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.3,
                ),
              ),
            ],
          ),
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
      ),
    );
  }
}

class _TrendingCard extends StatefulWidget {
  final PriorityDrama drama;
  final int rank;
  final bool isFirst;

  const _TrendingCard({
    required this.drama,
    required this.rank,
    required this.isFirst,
  });

  @override
  State<_TrendingCard> createState() => _TrendingCardState();
}

class _TrendingCardState extends State<_TrendingCard> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final drama = widget.drama;
    final rank = widget.rank;
    final isFirst = widget.isFirst;
    final String posterUrl = drama.posterUrl.isNotEmpty
        ? drama.posterUrl
        : drama.bannerUrl;

    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        Get.find<HomeController>().onPriorityDramaTap(drama);
      },
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) => setState(() => _pressed = false),
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedScale(
        scale: _pressed ? 0.96 : 1.0,
        duration: const Duration(milliseconds: 120),
        curve: Curves.easeOutCubic,
        child: SizedBox(
          width: 160,
          height: 200,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              // ── 1. Giant Stylized Gold Rank Number (Behind on Left)
              Positioned(
                left: -6,
                bottom: -16,
                child: ShaderMask(
                  shaderCallback: (bounds) =>
                      AppColors.primaryGradient.createShader(bounds),
                  child: Text(
                    '$rank',
                    style: TextStyle(
                      fontFamily: AppTextStyles.fontFamily,
                      fontSize: 110,
                      fontWeight: FontWeight.w900,
                      letterSpacing: -6,
                      color: Colors.white,
                      shadows: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.8),
                          blurRadius: 12,
                          offset: const Offset(3, 3),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // ── 2. Cinematic Overlapping Poster Card (On Right)
              Positioned(
                left: 46,
                right: 0,
                top: 0,
                bottom: 0,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: const Color(0xFF151522),
                    border: Border.all(
                      color: isFirst
                          ? AppColors.primary
                          : Colors.white.withValues(alpha: 0.12),
                      width: isFirst ? 1.5 : 1.0,
                    ),
                    boxShadow: [
                      if (isFirst)
                        BoxShadow(
                          color: AppColors.primary.withValues(alpha: 0.35),
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
                    borderRadius: BorderRadius.circular(14),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        // Poster Image
                        Image.network(
                          posterUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
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
                                  Colors.black.withValues(alpha: 0.2),
                                  Colors.transparent,
                                  Colors.black.withValues(alpha: 0.88),
                                ],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                stops: const [0.0, 0.45, 1.0],
                              ),
                            ),
                          ),
                        ),

                        // Top-Left #1 Crown Badge
                        if (isFirst)
                          Positioned(
                            top: 6,
                            left: 6,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 5,
                                vertical: 2.5,
                              ),
                              decoration: BoxDecoration(
                                gradient: AppColors.primaryGradient,
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: const [
                                  FaIcon(
                                    FontAwesomeIcons.crown,
                                    color: Color(0xFF0C0B10),
                                    size: 8,
                                  ),
                                  SizedBox(width: 3),
                                  Text(
                                    'TOP 1',
                                    style: TextStyle(
                                      color: Color(0xFF0C0B10),
                                      fontSize: 7.5,
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                        // Top-Right Plays / Rating Badge
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
                              border: Border.all(
                                color: Colors.white.withValues(alpha: 0.1),
                                width: 0.8,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const FaIcon(
                                  FontAwesomeIcons.play,
                                  color: AppColors.primary,
                                  size: 7,
                                ),
                                const SizedBox(width: 3.5),
                                Text(
                                  drama.viewsFormatted.isNotEmpty
                                      ? drama.viewsFormatted
                                      : (drama.rating > 0
                                          ? '★ ${drama.rating.toStringAsFixed(1)}'
                                          : '3.5k'),
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
                            drama.title,
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
      ),
    );
  }
}
