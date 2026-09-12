import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../constants/app_colors.dart';
import '../../../constants/app_text_styles.dart';

import '../controller/explore_controller.dart';
import '../models/explore_item_model.dart';

class ExploreTabView extends StatelessWidget {
  const ExploreTabView({super.key});

  @override
  Widget build(BuildContext context) {
    // Ensure ExploreController is initialized
    final controller = Get.put(ExploreController());

    return Scaffold(
      backgroundColor: Colors.black,
      body: PageView.builder(
        controller: controller.pageController,
        scrollDirection: Axis.vertical,
        physics: const BouncingScrollPhysics(),
        onPageChanged: controller.onPageChanged,
        itemCount: controller.exploreList.length,
        itemBuilder: (context, index) {
          final item = controller.exploreList[index];
          return _ExploreCard(item: item);
        },
      ),
    );
  }
}

class _ExploreCard extends StatelessWidget {
  const _ExploreCard({required this.item});

  final ExploreItemModel item;

  @override
  Widget build(BuildContext context) {
    final exploreController = Get.find<ExploreController>();

    return Stack(
      fit: StackFit.expand,
      children: [
        // ── Full-Screen Cinematic Backdrop Poster
        Image.asset(
          item.image,
          fit: BoxFit.cover,
          errorBuilder: (_, e, s) => Container(
            color: const Color(0xFF161620),
            child: const Center(
              child: Icon(Icons.movie, size: 60, color: Colors.white24),
            ),
          ),
        ),

        // ── Smooth Dark Gradient Overlay for readability
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0x55000000),
                Colors.transparent,
                Color(0x88000000),
                Color(0xF5000000),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: [0.0, 0.35, 0.65, 1.0],
            ),
          ),
        ),

        // ── Bottom Content Area
        Positioned(
          left: 20,
          right: 20,
          bottom: 96, // Space above floating bottom navigation bar
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Tag: "TRAILER PREVIEW"
              Text(
                item.tag,
                style: TextStyle(
                  fontFamily: AppTextStyles.fontFamily,
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  color: AppColors.primary,
                  letterSpacing: 1.8,
                ),
              ),
              const SizedBox(height: 6),

              // Title: "The Last Promise"
              Text(
                item.title,
                style: AppTextStyles.text24Bold.copyWith(
                  color: Colors.white,
                  height: 1.18,
                  shadows: [const Shadow(color: Colors.black, blurRadius: 10)],
                ),
              ),
              const SizedBox(height: 4),

              // Genre: "Romance • Drama"
              Text(
                item.genre,
                style: AppTextStyles.text13Medium.copyWith(
                  color: const Color(0xFF8A8A8A),
                ),
              ),
              const SizedBox(height: 8),

              // Synopsis / Description
              Text(
                item.description,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.text13.copyWith(
                  color: const Color(0xFFCCCCCC),
                  height: 1.45,
                  shadows: [const Shadow(color: Colors.black87, blurRadius: 6)],
                ),
              ),
              const SizedBox(height: 18),

              // ── Buttons Row: [ ▶ Watch Now ]  [ + My List ]
              Row(
                children: [
                  // Watch Now Button
                  GestureDetector(
                    onTap: () => exploreController.watchNow(item),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withValues(alpha: 0.4),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.play_arrow_rounded,
                            color: Colors.white,
                            size: 20,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'Watch Now',
                            style: AppTextStyles.text14SemiBold.copyWith(
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),

                  // + My List Button
                  Obx(() {
                    final inList = item.isInMyList.value;
                    return GestureDetector(
                      onTap: () => exploreController.toggleMyList(item),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 18,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF141414).withValues(alpha: 0.8),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: inList
                                ? AppColors.primary
                                : const Color(0xFF4E4E4E),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              inList ? Icons.check_rounded : Icons.add_rounded,
                              color: inList ? AppColors.primary : Colors.white,
                              size: 18,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              inList ? 'In My List' : '+ My List',
                              style: AppTextStyles.text13SemiBold.copyWith(
                                color: inList
                                    ? AppColors.primary
                                    : Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
