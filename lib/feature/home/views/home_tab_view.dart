import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../constants/app_colors.dart';
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
        children: [
          // ── Top Bar Header (Logo + Notifications)
          const TopBarHeader(),

          // ── Scrollable Feed Area (Bounded by Expanded) with Pull-To-Refresh
          Expanded(
            child: RefreshIndicator(
              color: AppColors.primary,
              backgroundColor: const Color(0xFF14141E),
              onRefresh: () async {
                await Future.wait([
                  controller.getAllContent(),
                  controller.getAllContinueWatching(),
                  controller.getAllDrama(),
                  controller.fetchUnreadCount(),
                ]);
              },
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(
                  parent: BouncingScrollPhysics(),
                ),
                padding: const EdgeInsets.only(bottom: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    SizedBox(height: 12),

                    // ── 1. Hero 3D Carousel (Feature Banners)
                    HeroCarouselSection(),
                    SizedBox(height: 24),

                    // ── 2. Continue Watching Section (Hides if empty)
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: ContinueWatchingSection(),
                    ),

                    // ── 3. Trending Section (Hides if empty)
                    TrendingSection(),

                    // ── 4. Recommended for you (Hides if empty)
                    RecommendedSection(),

                    // ── 5. Popular Genres (Glass Genre Cards with Vector Icons)
                    PopularGenresSection(),
                    SizedBox(height: 28),

                    // ── 6. New Releases Section (Hides if empty)
                    NewReleasesSection(),
                    SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
