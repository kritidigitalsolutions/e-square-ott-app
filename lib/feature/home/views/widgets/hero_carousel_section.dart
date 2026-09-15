import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import '../../../../constants/app_colors.dart';
import '../../controller/home_controller.dart';
import '../../models/movie_model.dart';

class HeroCarouselSection extends GetView<HomeController> {
  const HeroCarouselSection({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 380,
      child: CarouselSlider.builder(
        itemCount: controller.heroBanners.length,
        options: CarouselOptions(
          height: 380,
          viewportFraction: 0.72,
          enlargeCenterPage: true,
          enlargeFactor: 0.18,
          autoPlay: true,
          autoPlayInterval: const Duration(seconds: 4),
          autoPlayAnimationDuration: const Duration(milliseconds: 600),
          autoPlayCurve: Curves.fastOutSlowIn,
          enableInfiniteScroll: true,
          onPageChanged: (index, reason) => controller.onHeroPageChanged(index),
        ),
        itemBuilder: (context, index, realIndex) {
          final movie = controller.heroBanners[index];
          return _HeroBannerCard(movie: movie);
        },
      ),
    );
  }
}

class _HeroBannerCard extends GetView<HomeController> {
  const _HeroBannerCard({required this.movie});

  final MovieModel movie;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => controller.onMovieTap(movie),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.1),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.22),
              blurRadius: 36,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Poster Image
              Image.asset(
                movie.image,
                fit: BoxFit.cover,
                errorBuilder: (_, e, s) => Container(
                  color: const Color(0xFF1E1E26),
                  child: const Center(
                    child: FaIcon(FontAwesomeIcons.film, color: Colors.white30, size: 40),
                  ),
                ),
              ),

              // Gradient Vignette Overlay
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.black.withValues(alpha: 0.3),
                        Colors.transparent,
                        Colors.black.withValues(alpha: 0.85),
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      stops: const [0.0, 0.45, 1.0],
                    ),
                  ),
                ),
              ),

              // Top Badges (Views & Plays)
              Positioned(
                top: 12,
                right: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.65),
                    borderRadius: BorderRadius.circular(12),
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
                        size: 9,
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
