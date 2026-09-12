import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/home_controller.dart';
import 'widgets/categories_section.dart';
import 'widgets/continue_watching_section.dart';
import 'widgets/hero_carousel_section.dart';
import 'widgets/new_releases_section.dart';
import 'widgets/recommended_section.dart';
import 'widgets/top_bar_header.dart';
import 'widgets/trending_section.dart';

class HomeTabView extends GetView<HomeController> {
  const HomeTabView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        // ── Top Bar Header (Logo + Notifications)
        TopBarHeader(),

        // ── Scrollable Feed Area (Bounded by Expanded)
        Expanded(
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            padding: EdgeInsets.only(bottom: 110),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 12),

                // ── 1. Hero 3D Carousel (CarouselSlider)
                HeroCarouselSection(),
                SizedBox(height: 24),

                // ── 2. Continue Watching Section
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: ContinueWatchingSection(),
                ),
                SizedBox(height: 28),

                // ── 3. New Releases Section
                NewReleasesSection(),
                SizedBox(height: 28),

                // ── 4. Genre / Category Shortcut Badges
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: CategoriesSection(),
                ),
                SizedBox(height: 28),

                // ── 5. Trending Section (1, 2, 3, 4 Ranking)
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: TrendingSection(),
                ),
                SizedBox(height: 28),

                // ── 6. Recommended for You Section
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: RecommendedSection(),
                ),
                SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
