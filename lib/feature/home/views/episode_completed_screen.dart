import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../constants/app_colors.dart';
import '../../../constants/app_images.dart';
import '../../../constants/app_text_styles.dart';
import '../../../routes/app_pages.dart';
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
      _seriesTitle = args['title'] ?? 'If this is Love,\nLet me burn';
      _backdropImage = args['image'] ?? AppImages.banner1;
    } else {
      _seriesTitle = 'If this is Love,\nLet me burn';
      _backdropImage = AppImages.banner1;
    }
  }

  void _toggleMyList() {
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
    setState(() {
      _isLiked = !_isLiked;
    });
    if (_isLiked) {
      AppSnackbar.success(
        'Thank you for liking this drama!',
        title: 'Rated Drama',
      );
    } else {
      AppSnackbar.info(
        'Your rating has been updated.',
        title: 'Rating Removed',
      );
    }
  }

  void _shareDrama() {
    AppSnackbar.info(
      'Sharing link for $_seriesTitle copied to clipboard!',
      title: 'Share Drama',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // ── Blurred & Dimmed Backdrop Artwork
          Image.asset(
            _backdropImage,
            fit: BoxFit.cover,
            errorBuilder: (_, e, s) => Container(color: const Color(0xFF0F0F14)),
          ),

          // ── Smooth Dark Cinematic Overlay Gradient
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.black.withValues(alpha: 0.75),
                    Colors.black.withValues(alpha: 0.88),
                    Colors.black.withValues(alpha: 0.98),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: const [0.0, 0.45, 1.0],
                ),
              ),
            ),
          ),

          // ── Main Scrollable Content
          SafeArea(
            child: Column(
              children: [
                // Top Header with Back Button & Brand Title
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  child: Row(
                    children: [
                      CustomBackButton(onTap: () => Get.back()),
                      const SizedBox(width: 14),
                      Text(
                        'Entertainment Squared',
                        style: AppTextStyles.text14Medium.copyWith(
                          color: AppColors.textSecondary,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ),

                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(height: 16),

                        // ── Radiant Sunburst Checkmark Badge
                        const _RadiantCheckmarkBadge(),
                        const SizedBox(height: 24),

                        // ── Subtitle: "You've completed"
                        Text(
                          "You’ve completed".tr,
                          style: const TextStyle(
                            fontFamily: AppTextStyles.fontFamily,
                            color: Colors.white70,
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),

                        // ── Red Bold Drama Title
                        Text(
                          _seriesTitle,
                          style: const TextStyle(
                            fontFamily: AppTextStyles.fontFamily,
                            color: Color(0xFFE42429),
                            fontSize: 30,
                            fontWeight: FontWeight.w800,
                            height: 1.18,
                            letterSpacing: -0.3,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 28),

                        // ── Primary Action: "Explore More Dramas" (Red Button)
                        AppButton(
                          label: 'Explore More Dramas'.tr,
                          onPressed: () {
                            Get.offAllNamed(Routes.home);
                          },
                          backgroundColor: AppColors.primary,
                          height: 52,
                          borderRadius: 14,
                        ),
                        const SizedBox(height: 12),

                        // ── Secondary Action: "+ Add to my List"
                        GestureDetector(
                          onTap: _toggleMyList,
                          behavior: HitTestBehavior.opaque,
                          child: Container(
                            height: 52,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: const Color(0xFF16161E),
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                color: _isInMyList
                                    ? const Color(0xFF00C853)
                                    : const Color(0xFF282836),
                                width: 1.2,
                              ),
                            ),
                            child: Center(
                              child: Text(
                                _isInMyList ? '✓ In my List' : '+ Add to my List',
                                style: TextStyle(
                                  fontFamily: AppTextStyles.fontFamily,
                                  color: _isInMyList
                                      ? const Color(0xFF00C853)
                                      : Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
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
                                  height: 48,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF16161E),
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: _isLiked
                                          ? const Color(0xFFE42429)
                                          : const Color(0xFF282836),
                                      width: 1,
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        _isLiked
                                            ? Icons.thumb_up_rounded
                                            : Icons.thumb_up_alt_outlined,
                                        color: _isLiked
                                            ? const Color(0xFFE42429)
                                            : Colors.white,
                                        size: 18,
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        'Rate',
                                        style: TextStyle(
                                          fontFamily: AppTextStyles.fontFamily,
                                          color: _isLiked
                                              ? const Color(0xFFE42429)
                                              : Colors.white,
                                          fontSize: 15,
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
                                  height: 48,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF16161E),
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: const Color(0xFF282836),
                                      width: 1,
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: const [
                                      Icon(
                                        Icons.share_outlined,
                                        color: Colors.white,
                                        size: 18,
                                      ),
                                      SizedBox(width: 8),
                                      Text(
                                        'Share',
                                        style: TextStyle(
                                          fontFamily: AppTextStyles.fontFamily,
                                          color: Colors.white,
                                          fontSize: 15,
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
                        const SizedBox(height: 32),

                        // ── "Recommended for you" Section
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Recommended for you',
                            style: AppTextStyles.text18Bold.copyWith(
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(height: 14),

                        // 3 Recommended Drama Poster Cards
                        Row(
                          children: _recommendedDramas.map((drama) {
                            return Expanded(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 4),
                                child: _buildRecommendedPosterCard(drama),
                              ),
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 24),
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
            borderRadius: BorderRadius.circular(12),
            color: const Color(0xFF161620),
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

                // Top Right Plays Badge
                Positioned(
                  top: 6,
                  right: 6,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 5,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.65),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Text(
                      '▶ ${drama['plays']}',
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
      width: 96,
      height: 96,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomPaint(
            size: const Size(96, 96),
            painter: _RadiatingTicksPainter(),
          ),
          const Icon(
            Icons.check_rounded,
            color: Color(0xFF76D275),
            size: 46,
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
      ..color = const Color(0xFF76D275)
      ..strokeWidth = 2.4
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
