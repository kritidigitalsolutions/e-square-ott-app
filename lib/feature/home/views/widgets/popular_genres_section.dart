import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import '../../../../constants/app_images.dart';
import '../../../../constants/app_text_styles.dart';
import '../../../../routes/app_pages.dart';
import '../../controller/home_controller.dart';
import '../../models/category_model.dart';

class _PopularGenreItem {
  final String id;
  final String title;
  final FaIconData icon;
  final Color accentColor;
  final String posterImage;

  const _PopularGenreItem({
    required this.id,
    required this.title,
    required this.icon,
    required this.accentColor,
    required this.posterImage,
  });
}

class PopularGenresSection extends GetView<HomeController> {
  const PopularGenresSection({super.key});

  static const List<_PopularGenreItem> _popularGenres = [
    _PopularGenreItem(
      id: 'drama',
      title: 'Drama',
      icon: FontAwesomeIcons.clapperboard,
      accentColor: Color(0xFF22C55E),
      posterImage: AppImages.dramaImage,
    ),
    _PopularGenreItem(
      id: 'mystery',
      title: 'Mystery',
      icon: FontAwesomeIcons.userSecret,
      accentColor: Color(0xFF00ACC1),
      posterImage: AppImages.mysteryImage,
    ),
    _PopularGenreItem(
      id: 'action',
      title: 'Action',
      icon: FontAwesomeIcons.personRunning,
      accentColor: Color(0xFFFF6B00),
      posterImage: AppImages.actionImage,
    ),
    _PopularGenreItem(
      id: 'horror',
      title: 'Horror',
      icon: FontAwesomeIcons.ghost,
      accentColor: Color(0xFF9C27B0),
      posterImage: AppImages.horrorImage,
    ),
    _PopularGenreItem(
      id: 'thriller',
      title: 'Thriller',
      icon: FontAwesomeIcons.bolt,
      accentColor: Color(0xFFE50914),
      posterImage: AppImages.thrillerImage,
    ),
    _PopularGenreItem(
      id: 'romance',
      title: 'Romance',
      icon: FontAwesomeIcons.solidHeart,
      accentColor: Color(0xFFE91E63),
      posterImage: AppImages.romanceImage,
    ),
    _PopularGenreItem(
      id: 'comedy',
      title: 'Comedy',
      icon: FontAwesomeIcons.faceLaughSquint,
      accentColor: Color(0xFFF39C12),
      posterImage: AppImages.comedyImage,
    ),
    _PopularGenreItem(
      id: 'scifi',
      title: 'Sci-Fi',
      icon: FontAwesomeIcons.rocket,
      accentColor: Color(0xFF0284C7),
      posterImage: AppImages.fantasyImage,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Section Header: Popular Genres >
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: _buildSectionHeader(
            'Popular Genres',
            onTap: () => Get.toNamed(Routes.categories),
          ),
        ),
        const SizedBox(height: 14),

        // ── Horizontal Genre Cards List
        SizedBox(
          height: 82,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: _popularGenres.length,
            separatorBuilder: (context, index) => const SizedBox(width: 10),
            itemBuilder: (context, index) {
              final genre = _popularGenres[index];
              return _buildGenreCard(genre);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildGenreCard(_PopularGenreItem genre) {
    return GestureDetector(
      onTap: () {
        controller.selectedCategory.value = CategoryModel(
          id: genre.id,
          title: genre.title,
          icon: genre.icon,
          posterImage: genre.posterImage,
          accentColor: genre.accentColor,
          gradientColors: [
            genre.accentColor,
            genre.accentColor.withValues(alpha: 0.5),
          ],
        );
        Get.toNamed(
          Routes.categoryDramas,
          arguments: controller.selectedCategory.value,
        );
      },
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: 82,
        height: 82,
        decoration: BoxDecoration(
          color: const Color(0xFF14141E),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: genre.accentColor.withValues(alpha: 0.45),
            width: 1.2,
          ),
          boxShadow: [
            BoxShadow(
              color: genre.accentColor.withValues(alpha: 0.22),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.5),
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
              // ── 1. Full-bleed Background Poster Image
              Positioned.fill(
                child: Image.asset(
                  genre.posterImage,
                  fit: BoxFit.cover,
                  errorBuilder: (_, e, s) => const SizedBox.shrink(),
                ),
              ),

              // ── 2. Dark Multi-stop Gradient Scrim
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withValues(alpha: 0.35),
                        Colors.black.withValues(alpha: 0.7),
                        Colors.black.withValues(alpha: 0.94),
                      ],
                      stops: const [0.0, 0.5, 1.0],
                    ),
                  ),
                ),
              ),

              // ── 3. Subtle Color Accent Ambient Glow
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        genre.accentColor.withValues(alpha: 0.25),
                        Colors.transparent,
                        genre.accentColor.withValues(alpha: 0.25),
                      ],
                    ),
                  ),
                ),
              ),

              // ── 4. Center Icon and Title
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.5),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: genre.accentColor.withValues(alpha: 0.65),
                          width: 1,
                        ),
                      ),
                      child: Center(
                        child: FaIcon(
                          genre.icon,
                          color: Colors.white,
                          size: 13,
                        ),
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      genre.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontFamily: AppTextStyles.fontFamily,
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.2,
                        shadows: [
                          Shadow(
                            color: Colors.black,
                            blurRadius: 4,
                            offset: Offset(0, 1),
                          ),
                        ],
                      ),
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

  Widget _buildSectionHeader(String title, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            style: AppTextStyles.text18Bold.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.3,
            ),
          ),
          const SizedBox(width: 6),
          const FaIcon(
            FontAwesomeIcons.chevronRight,
            color: Color(0xFFE42429),
            size: 13,
          ),
        ],
      ),
    );
  }
}
