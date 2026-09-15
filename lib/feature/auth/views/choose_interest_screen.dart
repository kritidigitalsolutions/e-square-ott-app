import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import '../../../constants/app_images.dart';
import '../../../constants/app_sizes.dart';
import '../../../constants/app_text_styles.dart';
import '../../../shared/widgets/custom_buttons.dart';
import '../controller/auth_controller.dart';

class GenreItem {
  final String id;
  final String name;
  final FaIconData icon;
  final Color accentColor;
  final String posterImage;
  final Alignment imageAlignment;

  const GenreItem({
    required this.id,
    required this.name,
    required this.icon,
    required this.accentColor,
    required this.posterImage,
    this.imageAlignment = Alignment.centerRight,
  });
}

class ChooseInterestScreen extends GetView<AuthController> {
  const ChooseInterestScreen({super.key});

  static const List<GenreItem> _genres = [
    GenreItem(
      id: 'Romance',
      name: 'Romance',
      icon: FontAwesomeIcons.solidHeart,
      accentColor: Color(0xFFE50914),
      posterImage: AppImages.romanceImage,
      imageAlignment: Alignment.centerRight,
    ),
    GenreItem(
      id: 'Thriller',
      name: 'Thriller',
      icon: FontAwesomeIcons.bolt,
      accentColor: Color(0xFF0091FF),
      posterImage: AppImages.thrillerImage,
      imageAlignment: Alignment.centerRight,
    ),
    GenreItem(
      id: 'Drama',
      name: 'Drama',
      icon: FontAwesomeIcons.masksTheater,
      accentColor: Color(0xFFF5A623),
      posterImage: AppImages.dramaImage,
      imageAlignment: Alignment.centerRight,
    ),
    GenreItem(
      id: 'Mystery',
      name: 'Mystery',
      icon: FontAwesomeIcons.userSecret,
      accentColor: Color(0xFFA855F7),
      posterImage: AppImages.mysteryImage,
      imageAlignment: Alignment.centerRight,
    ),
    GenreItem(
      id: 'Action',
      name: 'Action',
      icon: FontAwesomeIcons.personRunning,
      accentColor: Color(0xFFFF6B00),
      posterImage: AppImages.actionImage,
      imageAlignment: Alignment.centerRight,
    ),
    GenreItem(
      id: 'Horror',
      name: 'Horror',
      icon: FontAwesomeIcons.ghost,
      accentColor: Color(0xFFDC2626),
      posterImage: AppImages.horrorImage,
      imageAlignment: Alignment.centerRight,
    ),
    GenreItem(
      id: 'Comedy',
      name: 'Comedy',
      icon: FontAwesomeIcons.faceLaughSquint,
      accentColor: Color(0xFFEAB308),
      posterImage: AppImages.comedyImage,
      imageAlignment: Alignment.centerRight,
    ),
    GenreItem(
      id: 'Fantasy',
      name: 'Fantasy',
      icon: FontAwesomeIcons.wandMagicSparkles,
      accentColor: Color(0xFF06B6D4),
      posterImage: AppImages.fantasyImage,
      imageAlignment: Alignment.centerRight,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
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

                              // ── Heading: Choose your Interest (with Red 'Interest')
                              Text.rich(
                                TextSpan(
                                  children: [
                                    const TextSpan(
                                      text: 'Choose your\n',
                                      style: TextStyle(
                                        fontFamily: AppTextStyles.fontFamily,
                                        fontSize: 28,
                                        fontWeight: FontWeight.w800,
                                        color: Colors.white,
                                        height: 1.15,
                                        letterSpacing: -0.5,
                                      ),
                                    ),
                                    const TextSpan(
                                      text: 'Interest',
                                      style: TextStyle(
                                        fontFamily: AppTextStyles.fontFamily,
                                        fontSize: 28,
                                        fontWeight: FontWeight.w800,
                                        color: Color(0xFFE50914),
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
                                "Pick a few genres you love. We'll use them to\npersonalize your Entertainment experience.",
                                style: TextStyle(
                                  fontFamily: AppTextStyles.fontFamily,
                                  fontSize: 13,
                                  color: const Color(0xFF9E9EA8),
                                  height: 1.4,
                                ),
                              ),
                              const SizedBox(height: 22),

                              // ── 2-Column Genre Cards Grid
                              Column(
                                children: [
                                  for (
                                    int i = 0;
                                    i < _genres.length;
                                    i += 2
                                  ) ...[
                                    if (i > 0) const SizedBox(height: 10),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Obx(() {
                                            final isSelected = controller
                                                .selectedGenres
                                                .contains(_genres[i].id);
                                            return _CinematicGenreCard(
                                              genre: _genres[i],
                                              isSelected: isSelected,
                                              onTap: () {
                                                HapticFeedback.selectionClick();
                                                controller.toggleGenre(
                                                  _genres[i].id,
                                                );
                                              },
                                            );
                                          }),
                                        ),
                                        const SizedBox(width: 10),
                                        if (i + 1 < _genres.length)
                                          Expanded(
                                            child: Obx(() {
                                              final isSelected = controller
                                                  .selectedGenres
                                                  .contains(_genres[i + 1].id);
                                              return _CinematicGenreCard(
                                                genre: _genres[i + 1],
                                                isSelected: isSelected,
                                                onTap: () {
                                                  HapticFeedback.selectionClick();
                                                  controller.toggleGenre(
                                                    _genres[i + 1].id,
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
                              ),

                              const Spacer(),
                              const SizedBox(height: 20),

                              // ── Continue Button (Solid Red with Arrow)
                              Obx(() {
                                final hasSelection =
                                    controller.selectedGenres.isNotEmpty;
                                return GestureDetector(
                                  onTap: hasSelection
                                      ? () {
                                          HapticFeedback.mediumImpact();
                                          controller.completeOnboarding();
                                        }
                                      : null,
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 220),
                                    width: double.infinity,
                                    height: 52,
                                    decoration: BoxDecoration(
                                      color: hasSelection
                                          ? const Color(0xFFE50914)
                                          : const Color(0xFF1E1E28),
                                      borderRadius: BorderRadius.circular(14),
                                      border: Border.all(
                                        color: hasSelection
                                            ? const Color(0xFFE50914)
                                            : const Color(0xFF2E2E3E),
                                        width: 1,
                                      ),
                                      boxShadow: hasSelection
                                          ? [
                                              BoxShadow(
                                                color: const Color(
                                                  0xFFE50914,
                                                ).withValues(alpha: 0.45),
                                                blurRadius: 18,
                                                offset: const Offset(0, 6),
                                              ),
                                            ]
                                          : null,
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          'Continue',
                                          style: TextStyle(
                                            fontFamily:
                                                AppTextStyles.fontFamily,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w700,
                                            color: hasSelection
                                                ? Colors.white
                                                : const Color(0xFF6E6E7E),
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        FaIcon(
                                          FontAwesomeIcons.arrowRight,
                                          color: hasSelection
                                              ? Colors.white
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
                                      'Skip for Now',
                                      style: TextStyle(
                                        fontFamily: AppTextStyles.fontFamily,
                                        fontSize: 13,
                                        fontWeight: FontWeight.w500,
                                        color: const Color(0xFF8A8A98),
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

/// Cinematic Interactive Genre Card matching the screenshot
class _CinematicGenreCard extends StatefulWidget {
  const _CinematicGenreCard({
    required this.genre,
    required this.isSelected,
    required this.onTap,
  });

  final GenreItem genre;
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
      // onTapCancel: (_) => setState(() => _isPressed = false),
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
                // ── 1. Right-side Poster Backdrop Image
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
                    child: Image.asset(
                      genre.posterImage,
                      fit: BoxFit.cover,
                      alignment: genre.imageAlignment,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(color: const Color(0xFF1E1E28));
                      },
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
                  top: 10,
                  bottom: 10,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Vector Icon with Glow
                      FaIcon(genre.icon, size: 20, color: genre.accentColor),
                      const SizedBox(height: 8),
                      // Title Text
                      Text(
                        genre.name,
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
                                color: genre.accentColor.withValues(alpha: 0.6),
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
