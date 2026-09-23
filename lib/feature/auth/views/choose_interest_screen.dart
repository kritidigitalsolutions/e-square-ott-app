import 'package:e_square_ott_app/constants/app_colors.dart';
import 'package:e_square_ott_app/constants/enum.dart';
import 'package:e_square_ott_app/models/response/get_genre_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import '../../../constants/app_images.dart';
import '../../../constants/app_sizes.dart';
import '../../../constants/app_text_styles.dart';
import '../../../shared/widgets/custom_animation.dart';
import '../../../shared/widgets/custom_buttons.dart';
import '../controller/auth_controller.dart';

class GenreItemDisplay {
  final String id;
  final String slug;
  final String name;
  final FaIconData icon;
  final Color accentColor;
  final String? networkImageUrl;
  final String localPosterImage;
  final Alignment imageAlignment;

  const GenreItemDisplay({
    required this.id,
    required this.slug,
    required this.name,
    required this.icon,
    required this.accentColor,
    this.networkImageUrl,
    required this.localPosterImage,
    this.imageAlignment = Alignment.centerRight,
  });
}

class ChooseInterestScreen extends GetView<AuthController> {
  const ChooseInterestScreen({super.key});

  // Fallback static genres in case API is unreachable
  static const List<GenreItemDisplay> _fallbackGenres = [
    GenreItemDisplay(
      id: 'romance',
      slug: 'romance',
      name: 'Romance',
      icon: FontAwesomeIcons.solidHeart,
      accentColor: Color(0xFFEC4899),
      localPosterImage: AppImages.romanceImage,
    ),
    GenreItemDisplay(
      id: 'thriller',
      slug: 'thriller',
      name: 'Thriller',
      icon: FontAwesomeIcons.bolt,
      accentColor: Color(0xFF0091FF),
      localPosterImage: AppImages.thrillerImage,
    ),
    GenreItemDisplay(
      id: 'drama',
      slug: 'drama',
      name: 'Drama',
      icon: FontAwesomeIcons.masksTheater,
      accentColor: Color(0xFFF5A623),
      localPosterImage: AppImages.dramaImage,
    ),
    GenreItemDisplay(
      id: 'mystery',
      slug: 'mystery',
      name: 'Mystery',
      icon: FontAwesomeIcons.userSecret,
      accentColor: Color(0xFFA855F7),
      localPosterImage: AppImages.mysteryImage,
    ),
    GenreItemDisplay(
      id: 'action',
      slug: 'action',
      name: 'Action',
      icon: FontAwesomeIcons.personRunning,
      accentColor: Color(0xFFFF6B00),
      localPosterImage: AppImages.actionImage,
    ),
    GenreItemDisplay(
      id: 'horror',
      slug: 'horror',
      name: 'Horror',
      icon: FontAwesomeIcons.ghost,
      accentColor: Color(0xFF8B5CF6),
      localPosterImage: AppImages.horrorImage,
    ),
    GenreItemDisplay(
      id: 'comedy',
      slug: 'comedy',
      name: 'Comedy',
      icon: FontAwesomeIcons.faceLaughSquint,
      accentColor: Color(0xFFEAB308),
      localPosterImage: AppImages.comedyImage,
    ),
    GenreItemDisplay(
      id: 'fantasy',
      slug: 'fantasy',
      name: 'Fantasy',
      icon: FontAwesomeIcons.wandMagicSparkles,
      accentColor: Color(0xFF06B6D4),
      localPosterImage: AppImages.fantasyImage,
    ),
  ];

  static GenreItemDisplay _mapApiGenreToDisplay(GenreModel model) {
    final lowerName = model.name.toLowerCase();
    final lowerSlug = model.slug.toLowerCase();

    FaIconData icon = FontAwesomeIcons.film;
    Color accentColor = AppColors.primary;
    String localPoster = AppImages.romanceImage;

    if (lowerName.contains('romance') || lowerSlug.contains('romance')) {
      icon = FontAwesomeIcons.solidHeart;
      accentColor = const Color(0xFFEC4899);
      localPoster = AppImages.romanceImage;
    } else if (lowerName.contains('thrill') || lowerSlug.contains('thrill')) {
      icon = FontAwesomeIcons.bolt;
      accentColor = const Color(0xFF0091FF);
      localPoster = AppImages.thrillerImage;
    } else if (lowerName.contains('drama') || lowerSlug.contains('drama')) {
      icon = FontAwesomeIcons.masksTheater;
      accentColor = const Color(0xFFF5A623);
      localPoster = AppImages.dramaImage;
    } else if (lowerName.contains('mystery') || lowerSlug.contains('mystery')) {
      icon = FontAwesomeIcons.userSecret;
      accentColor = const Color(0xFFA855F7);
      localPoster = AppImages.mysteryImage;
    } else if (lowerName.contains('action') || lowerSlug.contains('action')) {
      icon = FontAwesomeIcons.personRunning;
      accentColor = const Color(0xFFFF6B00);
      localPoster = AppImages.actionImage;
    } else if (lowerName.contains('horror') || lowerSlug.contains('horror')) {
      icon = FontAwesomeIcons.ghost;
      accentColor = const Color(0xFF8B5CF6);
      localPoster = AppImages.horrorImage;
    } else if (lowerName.contains('comedy') || lowerSlug.contains('comedy')) {
      icon = FontAwesomeIcons.faceLaughSquint;
      accentColor = const Color(0xFFEAB308);
      localPoster = AppImages.comedyImage;
    } else if (lowerName.contains('fantasy') || lowerSlug.contains('fantasy')) {
      icon = FontAwesomeIcons.wandMagicSparkles;
      accentColor = const Color(0xFF06B6D4);
      localPoster = AppImages.fantasyImage;
    } else if (lowerName.contains('sci') || lowerSlug.contains('sci')) {
      icon = FontAwesomeIcons.shuttleSpace;
      accentColor = const Color(0xFF38BDF8);
      localPoster = AppImages.mysteryImage;
    }

    return GenreItemDisplay(
      id: model.id.isNotEmpty ? model.id : model.name,
      slug: model.slug.isNotEmpty ? model.slug : model.name,
      name: model.name,
      icon: icon,
      accentColor: accentColor,
      networkImageUrl: model.imageUrl.isNotEmpty
          ? model.imageUrl
          : (model.iconUrl.isNotEmpty ? model.iconUrl : null),
      localPosterImage: localPoster,
    );
  }

  @override
  Widget build(BuildContext context) {
    // Eagerly fetch genres if not yet loaded
    if (controller.allGenreResponse.value == null &&
        controller.allGenre.value != Status.loading) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        controller.getAllGenres();
      });
    }

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: CustomScaffold(
        showAppBar: false,
        safeArea: false,
        backgroundColor: const Color(0xFF010101),
        resizeToAvoidBottomInset: false,
        body: Stack(
          children: [
            // ── Background Image
            Positioned.fill(
              child: Image.asset(
                AppImages.bg,
                fit: BoxFit.cover,
                errorBuilder: (_, e, s) => const SizedBox.shrink(),
              ),
            ),

            // ── Gradient Overlay
            Positioned.fill(
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xCC010101), Color(0xF80B0B10)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    stops: [0.0, 0.55],
                  ),
                ),
              ),
            ),

            // ── Fixed Top-Left Back Button
            Positioned(
              left: AppSizes.p20,
              top: MediaQuery.of(context).padding.top + 16,
              child: CustomBackButton(onTap: () => Get.back()),
            ),

            // ── Content Area
            SafeArea(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: constraints.maxHeight,
                      ),
                      child: IntrinsicHeight(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSizes.p20,
                            vertical: 16,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Top space below back button
                              const SizedBox(height: 52),

                              // ── Heading: Choose your Interest
                              Text.rich(
                                TextSpan(
                                  children: [
                                    TextSpan(
                                      text: 'Choose your '.tr,
                                      style: const TextStyle(
                                        fontFamily: AppTextStyles.fontFamily,
                                        fontSize: 28,
                                        fontWeight: FontWeight.w800,
                                        color: Colors.white,
                                        height: 1.15,
                                        letterSpacing: -0.5,
                                      ),
                                    ),
                                    TextSpan(
                                      text: 'Interest'.tr,
                                      style: const TextStyle(
                                        fontFamily: AppTextStyles.fontFamily,
                                        fontSize: 28,
                                        fontWeight: FontWeight.w800,
                                        color: AppColors.primary,
                                        height: 1.15,
                                        letterSpacing: -0.5,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 10),

                              // ── Subtitle
                              Text(
                                "Pick a few genres you love. We'll use them to\npersonalize your Entertainment experience."
                                    .tr,
                                style: const TextStyle(
                                  fontFamily: AppTextStyles.fontFamily,
                                  fontSize: 13,
                                  color: Color(0xFF9E9EA8),
                                  height: 1.4,
                                ),
                              ),
                              const SizedBox(height: 22),

                              // ── 2-Column Dynamic Genre Cards Grid
                              Obx(() {
                                final isGenresLoading =
                                    controller.allGenre.value ==
                                            Status.loading &&
                                        controller.allGenreResponse.value ==
                                            null;

                                if (isGenresLoading) {
                                  return const Padding(
                                    padding: EdgeInsets.symmetric(
                                      vertical: 40,
                                    ),
                                    child: Center(
                                      child: SpinKitThreeBounce(
                                        color: AppColors.primary,
                                        size: 28,
                                      ),
                                    ),
                                  );
                                }

                                final apiGenres = controller
                                    .allGenreResponse.value?.data.genres;

                                final List<GenreItemDisplay> items =
                                    (apiGenres != null && apiGenres.isNotEmpty)
                                        ? apiGenres
                                            .map(_mapApiGenreToDisplay)
                                            .toList()
                                        : _fallbackGenres;

                                return Column(
                                  children: [
                                    for (
                                      int i = 0;
                                      i < items.length;
                                      i += 2
                                    ) ...[
                                      if (i > 0) const SizedBox(height: 10),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Obx(() {
                                              final item = items[i];
                                              final isSelected = controller
                                                      .selectedGenres
                                                      .contains(item.name) ||
                                                  controller.selectedGenres
                                                      .contains(item.slug) ||
                                                  controller.selectedGenres
                                                      .contains(item.id);

                                              return _CinematicGenreCard(
                                                genre: item,
                                                isSelected: isSelected,
                                                onTap: () {
                                                  HapticFeedback
                                                      .selectionClick();
                                                  // Select by genre name or slug
                                                  controller.toggleGenre(
                                                    item.name,
                                                  );
                                                },
                                              );
                                            }),
                                          ),
                                          const SizedBox(width: 10),
                                          if (i + 1 < items.length)
                                            Expanded(
                                              child: Obx(() {
                                                final item = items[i + 1];
                                                final isSelected = controller
                                                        .selectedGenres
                                                        .contains(item.name) ||
                                                    controller.selectedGenres
                                                        .contains(item.slug) ||
                                                    controller.selectedGenres
                                                        .contains(item.id);

                                                return _CinematicGenreCard(
                                                  genre: item,
                                                  isSelected: isSelected,
                                                  onTap: () {
                                                    HapticFeedback
                                                        .selectionClick();
                                                    controller.toggleGenre(
                                                      item.name,
                                                    );
                                                  },
                                                );
                                              }),
                                            )
                                          else
                                            const Expanded(
                                              child: SizedBox.shrink(),
                                            ),
                                        ],
                                      ),
                                    ],
                                  ],
                                );
                              }),

                              const Spacer(),
                              const SizedBox(height: 20),

                              // ── Continue Button (with API saving state)
                              Obx(() {
                                final hasSelection =
                                    controller.selectedGenres.isNotEmpty;
                                final isSaving =
                                    controller.selectInterestStatus.value ==
                                        Status.loading;

                                return GestureDetector(
                                  onTap: (hasSelection && !isSaving)
                                      ? () {
                                          HapticFeedback.mediumImpact();
                                          controller.completeOnboarding();
                                        }
                                      : null,
                                  child: AnimatedContainer(
                                    duration:
                                        const Duration(milliseconds: 220),
                                    width: double.infinity,
                                    height: 52,
                                    decoration: BoxDecoration(
                                      color: hasSelection
                                          ? null
                                          : const Color(0xFF1E1E28),
                                      gradient: hasSelection
                                          ? AppColors.primaryGradient
                                          : null,
                                      borderRadius:
                                          BorderRadius.circular(14),
                                      border: Border.all(
                                        color: hasSelection
                                            ? AppColors.primary
                                            : const Color(0xFF2E2E3E),
                                        width: 1,
                                      ),
                                      boxShadow: hasSelection
                                          ? [
                                              BoxShadow(
                                                color: AppColors.primary
                                                    .withValues(alpha: 0.35),
                                                blurRadius: 18,
                                                offset: const Offset(0, 6),
                                              ),
                                            ]
                                          : null,
                                    ),
                                    child: isSaving
                                        ? const Center(
                                            child: SpinKitThreeBounce(
                                              color: Color(0xFF0C0B10),
                                              size: 22,
                                            ),
                                          )
                                        : Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                'Continue'.tr,
                                                style: TextStyle(
                                                  fontFamily:
                                                      AppTextStyles.fontFamily,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w700,
                                                  color: hasSelection
                                                      ? const Color(
                                                          0xFF0C0B10,
                                                        )
                                                      : const Color(
                                                          0xFF6E6E7E,
                                                        ),
                                                ),
                                              ),
                                              const SizedBox(width: 8),
                                              FaIcon(
                                                FontAwesomeIcons.arrowRight,
                                                color: hasSelection
                                                    ? const Color(0xFF0C0B10)
                                                    : const Color(0xFF6E6E7E),
                                                size: 14,
                                              ),
                                            ],
                                          ),
                                  ),
                                );
                              }),
                              const SizedBox(height: 14),

                              // ── Skip for Now
                              Center(
                                child: GestureDetector(
                                  onTap: () {
                                    HapticFeedback.lightImpact();
                                    controller.completeOnboarding();
                                  },
                                  behavior: HitTestBehavior.opaque,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 6,
                                      horizontal: 16,
                                    ),
                                    child: Text(
                                      'Skip for Now'.tr,
                                      style: const TextStyle(
                                        fontFamily: AppTextStyles.fontFamily,
                                        fontSize: 13,
                                        fontWeight: FontWeight.w500,
                                        color: Color(0xFF8A8A98),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 10),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Cinematic Interactive Genre Card
class _CinematicGenreCard extends StatefulWidget {
  const _CinematicGenreCard({
    required this.genre,
    required this.isSelected,
    required this.onTap,
  });

  final GenreItemDisplay genre;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  State<_CinematicGenreCard> createState() => _CinematicGenreCardState();
}

class _CinematicGenreCardState extends State<_CinematicGenreCard> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final genre = widget.genre;
    final isSelected = widget.isSelected;

    return GestureDetector(
      onTap: widget.onTap,
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      behavior: HitTestBehavior.opaque,
      child: AnimatedScale(
        scale: _isPressed ? 0.96 : (isSelected ? 1.02 : 1.0),
        duration: const Duration(milliseconds: 140),
        curve: Curves.easeOutCubic,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          height: 78,
          decoration: BoxDecoration(
            color: const Color(0xFF0D0D16),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: isSelected
                  ? genre.accentColor
                  : genre.accentColor.withValues(alpha: 0.45),
              width: isSelected ? 1.6 : 1.0,
            ),
            boxShadow: [
              if (isSelected)
                BoxShadow(
                  color: genre.accentColor.withValues(alpha: 0.35),
                  blurRadius: 14,
                  spreadRadius: 1,
                  offset: const Offset(0, 3),
                )
              else
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.4),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(13),
            child: Stack(
              fit: StackFit.expand,
              children: [
                // ── 1. Right-side Poster Backdrop Image (Network or Asset)
                Positioned(
                  right: 0,
                  top: 0,
                  bottom: 0,
                  width: 95,
                  child: ShaderMask(
                    shaderCallback: (rect) {
                      return const LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [Colors.transparent, Colors.white],
                        stops: [0.0, 0.55],
                      ).createShader(rect);
                    },
                    blendMode: BlendMode.dstIn,
                    child: (genre.networkImageUrl != null &&
                            genre.networkImageUrl!.startsWith('http'))
                        ? Image.network(
                            genre.networkImageUrl!,
                            fit: BoxFit.cover,
                            alignment: genre.imageAlignment,
                            errorBuilder: (_, __, ___) => Image.asset(
                              genre.localPosterImage,
                              fit: BoxFit.cover,
                              alignment: genre.imageAlignment,
                              errorBuilder: (_, __, ___) =>
                                  Container(color: const Color(0xFF1E1E28)),
                            ),
                          )
                        : Image.asset(
                            genre.localPosterImage,
                            fit: BoxFit.cover,
                            alignment: genre.imageAlignment,
                            errorBuilder: (_, __, ___) =>
                                Container(color: const Color(0xFF1E1E28)),
                          ),
                  ),
                ),

                // ── 2. Cinematic Colored Ambient Lighting Overlay
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          genre.accentColor.withValues(alpha: 0.12),
                          Colors.transparent,
                          genre.accentColor.withValues(
                            alpha: isSelected ? 0.3 : 0.18,
                          ),
                        ],
                        stops: const [0.0, 0.45, 1.0],
                      ),
                    ),
                  ),
                ),

                // ── 3. Content: Icon & Title on Left
                Positioned(
                  left: 12,
                  right: 36,
                  top: 8,
                  bottom: 8,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Vector Icon with Glow
                      FaIcon(genre.icon, size: 20, color: genre.accentColor),
                      const SizedBox(height: 6),
                      // Title Text
                      Text(
                        genre.name.tr,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontFamily: AppTextStyles.fontFamily,
                          color: Colors.white,
                          fontSize: 12.5,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.1,
                        ),
                      ),
                    ],
                  ),
                ),

                // ── 4. Top-Right Selection Indicator (Circle Checkbox)
                Positioned(
                  top: 8,
                  right: 8,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isSelected
                          ? genre.accentColor
                          : Colors.transparent,
                      border: Border.all(
                        color: isSelected
                            ? genre.accentColor
                            : Colors.white.withValues(alpha: 0.55),
                        width: isSelected ? 1.5 : 1.4,
                      ),
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                color:
                                    genre.accentColor.withValues(alpha: 0.6),
                                blurRadius: 6,
                                spreadRadius: 0.5,
                              ),
                            ]
                          : null,
                    ),
                    child: isSelected
                        ? const Center(
                            child: FaIcon(
                              FontAwesomeIcons.check,
                              color: Colors.white,
                              size: 10,
                            ),
                          )
                        : null,
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
