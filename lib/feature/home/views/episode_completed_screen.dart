import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import '../../../constants/app_colors.dart';
import '../../../constants/app_images.dart';
import '../../../constants/app_text_styles.dart';
import '../../../routes/app_pages.dart';
import '../../../shared/widgets/custom_animation.dart';
import '../../../shared/widgets/custom_buttons.dart';
import '../../../shared/widgets/custom_sncakbar.dart';
import '../../explore/models/explore_item_model.dart';
import '../models/movie_model.dart';

class EpisodeCompletedScreen extends StatefulWidget {
  const EpisodeCompletedScreen({super.key});

  @override
  State<EpisodeCompletedScreen> createState() => _EpisodeCompletedScreenState();
}

class _EpisodeCompletedScreenState extends State<EpisodeCompletedScreen> {
  late String _seriesTitle;
  late String _backdropImage;
  bool _isInMyList = false;
  bool _isLiked = false;

  final List<Map<String, String>> _recommendedDramas = [
    {
      'title': 'THE CEO HAS MY BACK',
      'plays': '3.5k',
      'image': AppImages.banner1,
    },
    {
      'title': 'THE BILLIONAIRE HOUSEWIFE',
      'plays': '3.5k',
      'image': AppImages.banner3,
    },
    {
      'title': 'UNDERCOVER BOSS LADY',
      'plays': '3.5k',
      'image': AppImages.banner2,
    },
  ];

  @override
  void initState() {
    super.initState();
    final args = Get.arguments;
    if (args is MovieModel) {
      _seriesTitle = args.title;
      _backdropImage = args.image;
    } else if (args is ExploreItemModel) {
      _seriesTitle = args.title;
      _backdropImage = args.image;
    } else if (args is Map<String, dynamic>) {
      _seriesTitle = args['title'] ?? 'The Last Promise';
      _backdropImage = args['image'] ?? AppImages.banner1;
    } else {
      _seriesTitle = 'The Last Promise';
      _backdropImage = AppImages.banner1;
    }
  }

  void _toggleMyList() {
    HapticFeedback.lightImpact();
    setState(() {
      _isInMyList = !_isInMyList;
    });
    if (_isInMyList) {
      AppSnackbar.success(
        '$_seriesTitle has been added to your Saved Series.',
        title: 'Added to List',
      );
    } else {
      AppSnackbar.info(
        '$_seriesTitle has been removed from your Saved Series.',
        title: 'Removed from List',
      );
    }
  }

  void _toggleRate() {
    HapticFeedback.lightImpact();
    setState(() {
      _isLiked = !_isLiked;
    });
    if (_isLiked) {
      AppSnackbar.success(
        'Thank you for liking this drama!',
        title: 'Rate',
      );
    } else {
      AppSnackbar.info(
        'Your rating has been updated.',
        title: 'Rate',
      );
    }
  }

  void _shareDrama() {
    HapticFeedback.lightImpact();
    AppSnackbar.info(
      'Sharing link for $_seriesTitle copied to clipboard!',
      title: 'Share',
    );
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      showAppBar: false,
      safeArea: false,
      backgroundColor: AppColors.background,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // ── Blurred & Dimmed Backdrop Artwork
          Image.asset(
            _backdropImage,
            fit: BoxFit.cover,
            errorBuilder: (_, e, s) =>
                Container(color: const Color(0xFF0A0A0F)),
          ),

          // ── Smooth Dark Cinematic Overlay Gradient
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.black.withValues(alpha: 0.7),
                    Colors.black.withValues(alpha: 0.88),
                    const Color(0xFF09090E).withValues(alpha: 0.98),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: const [0.0, 0.4, 1.0],
                ),
              ),
            ),
          ),

          // ── Main Content
          SafeArea(
            child: Column(
              children: [
                // Top Header with Back Button & Completed Pill Badge
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomBackButton(onTap: () => Get.back()),

                      // Completed Status Tag
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF10B981).withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: const Color(0xFF10B981).withValues(alpha: 0.4),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const FaIcon(
                              FontAwesomeIcons.circleCheck,
                              color: Color(0xFF10B981),
                              size: 11,
                            ),
                            const SizedBox(width: 5),
                            Text(
                              'Completed'.tr,
                              style: const TextStyle(
                                fontFamily: AppTextStyles.fontFamily,
                                color: Color(0xFF10B981),
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.3,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 8,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(height: 12),

                        // ── Radiant Sunburst Checkmark Badge
                        const _RadiantCheckmarkBadge(),
                        const SizedBox(height: 20),

                        // ── Subtitle: "You've completed"
                        Text(
                          "You’ve completed".tr,
                          style: TextStyle(
                            fontFamily: AppTextStyles.fontFamily,
                            color: Colors.white.withValues(alpha: 0.75),
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0.2,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),

                        // ── Luxury Highlight Drama Title
                        ShaderMask(
                          shaderCallback: (bounds) =>
                              AppColors.primaryGradient.createShader(bounds),
                          child: Text(
                            _seriesTitle,
                            style: const TextStyle(
                              fontFamily: AppTextStyles.fontFamily,
                              color: Colors.white,
                              fontSize: 26,
                              fontWeight: FontWeight.w900,
                              height: 1.2,
                              letterSpacing: -0.3,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const SizedBox(height: 26),

                        // ── Primary Action: "Explore More Dramas" (Gold Gradient Button)
                        AppButton(
                          label: 'Explore More Dramas'.tr,
                          onPressed: () {
                            HapticFeedback.lightImpact();
                            Get.offAllNamed(Routes.home);
                          },
                          backgroundColor: AppColors.primary,
                          height: 50,
                          borderRadius: 14,
                        ),
                        const SizedBox(height: 12),

                        // ── Secondary Action: "+ Add to my List"
                        GestureDetector(
                          onTap: _toggleMyList,
                          behavior: HitTestBehavior.opaque,
                          child: Container(
                            height: 48,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: const Color(0xFF14141E),
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                color: _isInMyList
                                    ? AppColors.primary
                                    : Colors.white.withValues(alpha: 0.12),
                                width: 1.2,
                              ),
                              boxShadow: _isInMyList
                                  ? [
                                      BoxShadow(
                                        color: AppColors.primary
                                            .withValues(alpha: 0.2),
                                        blurRadius: 10,
                                      ),
                                    ]
                                  : null,
                            ),
                            child: Center(
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  FaIcon(
                                    _isInMyList
                                        ? FontAwesomeIcons.check
                                        : FontAwesomeIcons.plus,
                                    color: _isInMyList
                                        ? AppColors.primary
                                        : Colors.white,
                                    size: 13,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    _isInMyList
                                        ? '✓ In my List'.tr
                                        : '+ Add to my List'.tr,
                                    style: TextStyle(
                                      fontFamily: AppTextStyles.fontFamily,
                                      color: _isInMyList
                                          ? AppColors.primary
                                          : Colors.white,
                                      fontSize: 14.5,
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: 0.2,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),

                        // ── Dual Actions: Rate & Share Buttons
                        Row(
                          children: [
                            // Rate Button
                            Expanded(
                              child: GestureDetector(
                                onTap: _toggleRate,
                                behavior: HitTestBehavior.opaque,
                                child: Container(
                                  height: 46,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF14141E),
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: _isLiked
                                          ? AppColors.primary
                                          : Colors.white
                                              .withValues(alpha: 0.1),
                                      width: 1,
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      FaIcon(
                                        _isLiked
                                            ? FontAwesomeIcons.solidThumbsUp
                                            : FontAwesomeIcons.thumbsUp,
                                        color: _isLiked
                                            ? AppColors.primary
                                            : Colors.white70,
                                        size: 14,
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        'Rate'.tr,
                                        style: TextStyle(
                                          fontFamily: AppTextStyles.fontFamily,
                                          color: _isLiked
                                              ? AppColors.primary
                                              : Colors.white,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),

                            // Share Button
                            Expanded(
                              child: GestureDetector(
                                onTap: _shareDrama,
                                behavior: HitTestBehavior.opaque,
                                child: Container(
                                  height: 46,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF14141E),
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: Colors.white.withValues(alpha: 0.1),
                                      width: 1,
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const FaIcon(
                                        FontAwesomeIcons.shareNodes,
                                        color: Colors.white70,
                                        size: 14,
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        'Share'.tr,
                                        style: const TextStyle(
                                          fontFamily: AppTextStyles.fontFamily,
                                          color: Colors.white,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 28),

                        // ── "Recommended for you" Section
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
                                    color: AppColors.primary
                                        .withValues(alpha: 0.6),
                                    blurRadius: 6,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Recommended for you'.tr,
                              style: AppTextStyles.text18Bold.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w800,
                                letterSpacing: -0.3,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),

                        // 3 Recommended Drama Poster Cards
                        Row(
                          children: _recommendedDramas.map((drama) {
                            return Expanded(
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 4),
                                child: _buildRecommendedPosterCard(drama),
                              ),
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecommendedPosterCard(Map<String, String> drama) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        Get.toNamed(
          Routes.dramaPlayer,
          arguments: {
            'title': drama['title'],
            'image': drama['image'],
          },
        );
      },
      child: AspectRatio(
        aspectRatio: 0.68,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(13),
            color: const Color(0xFF141420),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.08),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.4),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.asset(
                  drama['image']!,
                  fit: BoxFit.cover,
                  errorBuilder: (_, e, s) => Container(
                    color: const Color(0xFF22222E),
                    child: const Icon(Icons.movie, color: Colors.white30),
                  ),
                ),

                // Bottom gradient for readability
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.transparent,
                          Colors.black.withValues(alpha: 0.8),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        stops: const [0.4, 1.0],
                      ),
                    ),
                  ),
                ),

                // Top Right Plays Badge
                Positioned(
                  top: 6,
                  right: 6,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 5,
                      vertical: 2.5,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.7),
                      borderRadius: BorderRadius.circular(5),
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
                        const SizedBox(width: 3),
                        Text(
                          drama['plays']!,
                          style: const TextStyle(
                            fontFamily: AppTextStyles.fontFamily,
                            color: Colors.white,
                            fontSize: 8.5,
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
      ),
    );
  }
}

/// Radiant Sunburst Checkmark Badge Widget
class _RadiantCheckmarkBadge extends StatelessWidget {
  const _RadiantCheckmarkBadge();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 90,
      height: 90,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomPaint(
            size: const Size(90, 90),
            painter: _RadiatingTicksPainter(),
          ),
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFF10B981).withValues(alpha: 0.15),
              border: Border.all(
                color: const Color(0xFF10B981).withValues(alpha: 0.5),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF10B981).withValues(alpha: 0.3),
                  blurRadius: 16,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: const Center(
              child: FaIcon(
                FontAwesomeIcons.check,
                color: Color(0xFF10B981),
                size: 24,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _RadiatingTicksPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF10B981).withValues(alpha: 0.75)
      ..strokeWidth = 2.2
      ..strokeCap = StrokeCap.round;

    final center = Offset(size.width / 2, size.height / 2);
    const count = 14;
    final innerRadius = size.width * 0.36;
    final outerRadius = size.width * 0.48;

    for (int i = 0; i < count; i++) {
      final angle = (i * 2 * pi) / count;
      final x1 = center.dx + innerRadius * cos(angle);
      final y1 = center.dy + innerRadius * sin(angle);
      final x2 = center.dx + outerRadius * cos(angle);
      final y2 = center.dy + outerRadius * sin(angle);
      canvas.drawLine(Offset(x1, y1), Offset(x2, y2), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
