import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
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
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.25),
              blurRadius: 40,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // ── Poster Image
              Image.asset(
                movie.image,
                fit: BoxFit.cover,
                errorBuilder: (_, e, s) => Container(
                  color: const Color(0xFF1E1E26),
                  child: const Center(
                    child: Icon(Icons.movie, color: Colors.white30, size: 50),
                  ),
                ),
              ),

              // ── Dark Gradient Overlay

              // ── Top Badges (Views & Plays)
              Positioned(
                top: 12,
                left: 12,
                right: 12,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [_buildDarkBadge('▶ ${movie.plays}')],
                ),
              ),

              // ── Bottom Title & Subtitle
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDarkBadge(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.65),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 9,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
