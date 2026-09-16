import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../shared/widgets/custom_animation.dart';
import '../controller/home_controller.dart';
import 'widgets/continue_watching_section.dart';
import 'widgets/hero_carousel_section.dart';
import 'widgets/new_releases_section.dart';
import 'widgets/popular_genres_section.dart';
import 'widgets/recommended_section.dart';
import 'widgets/top_bar_header.dart';
import 'widgets/trending_section.dart';

class HomeTabView extends GetView<HomeController> {
  const HomeTabView({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      showAppBar: false,
      safeArea: false,
      backgroundColor: Colors.transparent,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          // ── Top Bar Header (Logo + Notifications)
          TopBarHeader(),

          // ── Scrollable Feed Area (Bounded by Expanded)
          Expanded(
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              padding: EdgeInsets.only(bottom: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 12),

                  // ── 1. Hero 3D Carousel (Top Auto-Playing Feature Banners)
                  HeroCarouselSection(),
                  SizedBox(height: 28),

                  // ── 6. Continue Watching Section
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: ContinueWatchingSection(),
                  ),
                  // ── 2. Trending (Netflix Top 10 Horizontal Scroll)
                  TrendingSection(),
                  SizedBox(height: 24),

                  // ── 3. Category / Genre 4 Gradient Pills + Arrow Button
                  // Padding(
                  //   padding: EdgeInsets.symmetric(horizontal: 16),
                  //   child: CategoriesSection(),
                  // ),
                  // SizedBox(height: 26),

                  // ── 4. Recommended for you (Horizontal Carousel)
                  RecommendedSection(),
                  SizedBox(height: 26),

                  // ── 5. Popular Genres (Glass Genre Cards with Vector Icons)
                  PopularGenresSection(),

                  SizedBox(height: 28),

                  // ── 7. New Releases Section
                  NewReleasesSection(),
                  SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
