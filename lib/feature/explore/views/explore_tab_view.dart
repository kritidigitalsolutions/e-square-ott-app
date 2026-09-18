import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import '../../../constants/app_colors.dart';
import '../../../constants/app_text_styles.dart';
import '../../../routes/app_pages.dart';
import '../../../shared/widgets/custom_animation.dart';
import '../../../shared/widgets/custom_bottomsheet.dart';
import '../../subscription/controller/subscription_controller.dart';
import '../controller/explore_controller.dart';
import '../models/explore_item_model.dart';

class ExploreTabView extends StatelessWidget {
  const ExploreTabView({super.key});

  @override
  Widget build(BuildContext context) {
    // Ensure ExploreController is initialized
    final controller = Get.put(ExploreController());

    return CustomScaffold(
      showAppBar: false,
      safeArea: false,
      backgroundColor: Colors.transparent,
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
              child: FaIcon(
                FontAwesomeIcons.film,
                size: 48,
                color: Colors.white24,
              ),
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
          bottom: 24, // Clean spacing right above the docked BottomAppBar
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

              // ── Buttons Row: [ Watch Now ]  [ Episodes ]  [ + My List ]
              Row(
                children: [
                  // Watch Now Button
                  GestureDetector(
                    onTap: () => exploreController.watchNow(item),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 11,
                      ),
                      decoration: BoxDecoration(
                        gradient: AppColors.primaryGradient,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withValues(alpha: 0.4),
                            blurRadius: 14,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const FaIcon(
                            FontAwesomeIcons.play,
                            color: Colors.white,
                            size: 14,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Watch Now'.tr,
                            style: AppTextStyles.text14Bold.copyWith(
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),

                  // Episodes Switcher Button
                  GestureDetector(
                    onTap: () => _openEpisodesSheet(context, item),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 11,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF181822).withValues(alpha: 0.88),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: const Color(0xFF383848),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const FaIcon(
                            FontAwesomeIcons.layerGroup,
                            color: Colors.white,
                            size: 14,
                          ),
                          const SizedBox(width: 7),
                          Text(
                            'Episodes'.tr,
                            style: AppTextStyles.text13SemiBold.copyWith(
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),

                  // + My List Button
                  Obx(() {
                    final inList = item.isInMyList.value;
                    return GestureDetector(
                      onTap: () => exploreController.toggleMyList(item),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 13,
                          vertical: 11,
                        ),
                        decoration: BoxDecoration(
                          color: inList
                              ? AppColors.primary.withValues(alpha: 0.15)
                              : const Color(0xFF141418).withValues(alpha: 0.88),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: inList
                                ? AppColors.primary
                                : const Color(0xFF383848),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            FaIcon(
                              inList
                                  ? FontAwesomeIcons.check
                                  : FontAwesomeIcons.plus,
                              color: inList ? AppColors.primary : Colors.white,
                              size: 14,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              inList ? 'In List'.tr : 'List'.tr,
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

  // ── Episodes Bottom Sheet for Reel/Explore View
  void _openEpisodesSheet(BuildContext context, ExploreItemModel item) {
    final List<Map<String, dynamic>> episodes = [
      {
        'title': 'Episode 01 · The Beginning',
        'duration': '2:08',
        'status': 'Watched',
        'isLocked': false,
      },
      {
        'title': 'Episode 02 · Hidden Whispers',
        'duration': '2:15',
        'status': 'Watched',
        'isLocked': false,
      },
      {
        'title': 'Episode 03 · The Betrayal',
        'duration': '2:20',
        'status': 'Watched',
        'isLocked': false,
      },
      {
        'title': 'Episode 04 · Forbidden Fire',
        'duration': '2:18',
        'status': 'Locked',
        'isLocked': true,
      },
      {
        'title': 'Episode 05 · Shattered Vows',
        'duration': '2:12',
        'status': 'Locked',
        'isLocked': true,
      },
      {
        'title': 'Episode 06 · The Confrontation',
        'duration': '2:25',
        'status': 'Locked',
        'isLocked': true,
      },
      {
        'title': 'Episode 07 · The Secret',
        'duration': '2:14',
        'status': 'Locked',
        'isLocked': true,
      },
      {
        'title': 'Episode 08 · Dangerous Game',
        'duration': '2:30',
        'status': 'Locked',
        'isLocked': true,
      },
      {
        'title': 'Episode 09 · A Dark Lie',
        'duration': '2:10',
        'status': 'Locked',
        'isLocked': true,
      },
      {
        'title': 'Episode 10 · Redemption',
        'duration': '2:22',
        'status': 'Locked',
        'isLocked': true,
      },
      {
        'title': 'Episode 11 · The Final Trap',
        'duration': '2:40',
        'status': 'Locked',
        'isLocked': true,
      },
      {
        'title': 'Episode 12 · Forever Mine',
        'duration': '2:50',
        'status': 'Locked',
        'isLocked': true,
      },
    ];

    CustomBottomSheet.show(
      context: context,
      child: Container(
        height: MediaQuery.of(context).size.height * 0.65,
        decoration: const BoxDecoration(
          color: Color(0xFF141419),
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
        child: SafeArea(
          top: false,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header: "Episodes · 12" + "Close"
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Episodes · ${episodes.length}',
                    style: const TextStyle(
                      fontFamily: AppTextStyles.fontFamily,
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF22222E),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: const Color(0xFF323242),
                          width: 1,
                        ),
                      ),
                      child: const Text(
                        'Close',
                        style: TextStyle(
                          fontFamily: AppTextStyles.fontFamily,
                          color: Colors.white70,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // List of episodes
              Expanded(
                child: Obx(() {
                  final subController = Get.find<SubscriptionController>();
                  final isSubscribed = subController.isSubscribed.value;

                  return ListView.separated(
                    physics: const BouncingScrollPhysics(),
                    itemCount: episodes.length,
                    separatorBuilder: (_, __) =>
                        const Divider(height: 18, color: Color(0xFF242432)),
                    itemBuilder: (context, index) {
                      final ep = episodes[index];
                      final isCurrent = index == 0;
                      final isLocked = !isSubscribed && index >= 3;

                      return InkWell(
                        onTap: () {
                          Navigator.pop(context);
                          Get.toNamed(
                            Routes.dramaPlayer,
                            arguments: {
                              'title': item.title,
                              'description': item.description,
                              'image': item.image,
                              'initialEpisodeIndex': index,
                            },
                          );
                        },
                        borderRadius: BorderRadius.circular(10),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Row(
                            children: [
                              // Episode Thumbnail with Play icon overlay
                              Container(
                                width: 62,
                                height: 62,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  border: isCurrent
                                      ? Border.all(
                                          color: AppColors.primary,
                                          width: 2,
                                        )
                                      : Border.all(
                                          color: const Color(0xFF282836),
                                          width: 1,
                                        ),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(6),
                                  child: Stack(
                                    alignment: Alignment.center,
                                    fit: StackFit.expand,
                                    children: [
                                      Image.asset(
                                        item.image,
                                        fit: BoxFit.cover,
                                        errorBuilder: (_, e, s) => Container(
                                          color: const Color(0xFF22222E),
                                        ),
                                      ),
                                      Container(
                                        color: Colors.black.withValues(
                                          alpha: 0.25,
                                        ),
                                      ),
                                      Center(
                                        child: Container(
                                          width: 22,
                                          height: 22,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Colors.black.withValues(
                                              alpha: 0.55,
                                            ),
                                          ),
                                          child: const FaIcon(
                                            FontAwesomeIcons.play,
                                            color: Colors.white,
                                            size: 10,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(width: 14),

                              // Episode Title & status
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      ep['title'],
                                      style: TextStyle(
                                        fontFamily: AppTextStyles.fontFamily,
                                        color: Colors.white,
                                        fontSize: 14,
                                        fontWeight: isCurrent
                                            ? FontWeight.w700
                                            : FontWeight.w600,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      isCurrent
                                          ? '${ep['duration']} · Now Playing'
                                          : '${ep['duration']} · ${ep['status']}',
                                      style: const TextStyle(
                                        fontFamily: AppTextStyles.fontFamily,
                                        color: Color(0xFF8E8E9E),
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              // Trailing Lock Icon
                              if (isLocked)
                                const FaIcon(
                                  FontAwesomeIcons.lock,
                                  color: Color(0xFF8E8E9E),
                                  size: 14,
                                ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
