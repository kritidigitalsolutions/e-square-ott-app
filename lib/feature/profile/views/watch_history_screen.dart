import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import '../../../constants/app_colors.dart';
import '../../../constants/app_text_styles.dart';
import '../../../routes/app_pages.dart';
import '../../../shared/widgets/custom_animation.dart';
import '../../../shared/widgets/custom_buttons.dart';
import '../controller/profile_controller.dart';

class WatchHistoryScreen extends StatelessWidget {
  const WatchHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ProfileController controller =
        Get.isRegistered<ProfileController>()
            ? Get.find<ProfileController>()
            : Get.put(ProfileController());

    return CustomScaffold(
      showAppBar: false,
      safeArea: false,
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // ── Background
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: AppColors.loginBgGradient,
              ),
            ),
          ),

          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Top Header
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          CustomBackButton(onTap: () => Get.back()),
                          const SizedBox(width: 12),
                          Container(
                            width: 3.5,
                            height: 18,
                            decoration: BoxDecoration(
                              gradient: AppColors.primaryGradient,
                              borderRadius: BorderRadius.circular(2),
                              boxShadow: [
                                BoxShadow(
                                  color:
                                      AppColors.primary.withValues(alpha: 0.6),
                                  blurRadius: 6,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            "Watch History".tr,
                            style: AppTextStyles.text18Bold.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w800,
                              letterSpacing: -0.2,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Obx(() {
                            final count = controller.watchHistoryList.length;
                            return Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 7,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.08),
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: Colors.white.withValues(alpha: 0.1),
                                  width: 0.8,
                                ),
                              ),
                              child: Text(
                                '$count',
                                style: const TextStyle(
                                  fontFamily: AppTextStyles.fontFamily,
                                  color: AppColors.primary,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            );
                          }),
                        ],
                      ),

                      // Clear All Action
                      Obx(() {
                        if (controller.watchHistoryList.isEmpty) {
                          return const SizedBox.shrink();
                        }
                        return GestureDetector(
                          onTap: () => _confirmClearAll(context, controller),
                          behavior: HitTestBehavior.opaque,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 5,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.06),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: Colors.white.withValues(alpha: 0.08),
                                width: 0.8,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const FaIcon(
                                  FontAwesomeIcons.trashCan,
                                  color: Colors.white60,
                                  size: 11,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  'Clear All'.tr,
                                  style: const TextStyle(
                                    fontFamily: AppTextStyles.fontFamily,
                                    color: Colors.white70,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                    ],
                  ),
                ),
                const SizedBox(height: 10),

                // ── Watch History List / Empty State
                Expanded(
                  child: Obx(() {
                    final items = controller.watchHistoryList;

                    if (items.isEmpty) {
                      return _buildEmptyState();
                    }

                    return ListView.separated(
                      padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
                      physics: const BouncingScrollPhysics(),
                      itemCount: items.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final item = items[index];
                        return _WatchHistoryCard(
                          item: item,
                          onRemove: () =>
                              controller.removeWatchHistory(item.id),
                        );
                      },
                    );
                  }),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 76,
              height: 76,
              decoration: BoxDecoration(
                color: const Color(0xFF141420),
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.primary.withValues(alpha: 0.3),
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.15),
                    blurRadius: 20,
                  ),
                ],
              ),
              child: const Center(
                child: FaIcon(
                  FontAwesomeIcons.clockRotateLeft,
                  color: AppColors.primary,
                  size: 30,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'No Watch History Yet'.tr,
              style: const TextStyle(
                fontFamily: AppTextStyles.fontFamily,
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Your recently watched dramas and episodes will appear here.'
                  .tr,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: AppTextStyles.fontFamily,
                color: Colors.white.withValues(alpha: 0.6),
                fontSize: 13,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: 160,
              child: AppButton(
                label: 'Explore Dramas'.tr,
                onPressed: () => Get.offAllNamed(Routes.home),
                height: 44,
                borderRadius: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _confirmClearAll(BuildContext context, ProfileController controller) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF161622),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
          side: BorderSide(
            color: Colors.white.withValues(alpha: 0.1),
            width: 1,
          ),
        ),
        title: Text(
          'Clear Watch History?'.tr,
          style: const TextStyle(
            fontFamily: AppTextStyles.fontFamily,
            color: Colors.white,
            fontWeight: FontWeight.w800,
            fontSize: 18,
          ),
        ),
        content: Text(
          'Are you sure you want to clear your entire watch history?'.tr,
          style: TextStyle(
            fontFamily: AppTextStyles.fontFamily,
            color: Colors.white.withValues(alpha: 0.7),
            fontSize: 14,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(
              'Cancel'.tr,
              style: TextStyle(
                fontFamily: AppTextStyles.fontFamily,
                color: Colors.white.withValues(alpha: 0.6),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              controller.clearAllWatchHistory();
            },
            child: Text(
              'Clear All'.tr,
              style: const TextStyle(
                fontFamily: AppTextStyles.fontFamily,
                color: AppColors.primary,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _WatchHistoryCard extends StatelessWidget {
  final WatchHistoryItemModel item;
  final VoidCallback onRemove;

  const _WatchHistoryCard({
    required this.item,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final progress = item.progress.clamp(0.0, 1.0);

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF12121C),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.08),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.4),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // ── Poster Thumbnail
              GestureDetector(
                onTap: () {
                  HapticFeedback.lightImpact();
                  Get.toNamed(
                    Routes.dramaPlayer,
                    arguments: {
                      'title': item.title,
                      'image': item.posterAsset,
                    },
                  );
                },
                child: SizedBox(
                  width: 80,
                  height: 108,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Image.asset(
                          item.posterAsset,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                            color: const Color(0xFF1E1E28),
                            child: const Center(
                              child: FaIcon(
                                FontAwesomeIcons.film,
                                color: Colors.white24,
                                size: 22,
                              ),
                            ),
                          ),
                        ),

                        // Vignette
                        Positioned.fill(
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Colors.transparent,
                                  Colors.black.withValues(alpha: 0.8),
                                ],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                stops: const [0.4, 1.0],
                              ),
                            ),
                          ),
                        ),

                        // Center Play Button Overlay
                        Center(
                          child: Container(
                            width: 28,
                            height: 28,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.black.withValues(alpha: 0.65),
                              border: Border.all(
                                color: AppColors.primary
                                    .withValues(alpha: 0.8),
                                width: 1,
                              ),
                            ),
                            child: const Center(
                              child: Padding(
                                padding: EdgeInsets.only(left: 1),
                                child: FaIcon(
                                  FontAwesomeIcons.play,
                                  color: AppColors.primary,
                                  size: 10,
                                ),
                              ),
                            ),
                          ),
                        ),

                        // Top Right Episode Pill
                        Positioned(
                          top: 5,
                          right: 5,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 5,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              gradient: AppColors.primaryGradient,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              'EP ${item.currentEpisode}',
                              style: const TextStyle(
                                fontFamily: AppTextStyles.fontFamily,
                                color: Color(0xFF0C0B10),
                                fontSize: 8,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 14),

              // ── Info Column
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Title
                    Text(
                      item.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontFamily: AppTextStyles.fontFamily,
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.2,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 6),

                    // Progress info text
                    Text(
                      'Ep ${item.currentEpisode} of ${item.totalEpisodes} • ${item.remainingTime}',
                      style: TextStyle(
                        fontFamily: AppTextStyles.fontFamily,
                        color: Colors.white.withValues(alpha: 0.65),
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 6),

                    // Glowing Gold Progress Bar
                    ClipRRect(
                      borderRadius: BorderRadius.circular(3),
                      child: SizedBox(
                        height: 3.5,
                        child: Stack(
                          children: [
                            Container(
                              color: Colors.white.withValues(alpha: 0.15),
                            ),
                            FractionallySizedBox(
                              widthFactor: progress,
                              child: Container(
                                decoration: const BoxDecoration(
                                  gradient: AppColors.primaryGradient,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Actions Row: Resume Button + Delete Icon
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            HapticFeedback.lightImpact();
                            Get.toNamed(
                              Routes.dramaPlayer,
                              arguments: {
                                'title': item.title,
                                'image': item.posterAsset,
                              },
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              gradient: AppColors.primaryGradient,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.primary
                                      .withValues(alpha: 0.3),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const FaIcon(
                                  FontAwesomeIcons.play,
                                  color: Color(0xFF0C0B10),
                                  size: 9,
                                ),
                                const SizedBox(width: 5),
                                Text(
                                  'Resume'.tr,
                                  style: const TextStyle(
                                    fontFamily: AppTextStyles.fontFamily,
                                    color: Color(0xFF0C0B10),
                                    fontSize: 11.5,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const Spacer(),

                        // Remove from History
                        GestureDetector(
                          onTap: () {
                            HapticFeedback.lightImpact();
                            onRemove();
                          },
                          behavior: HitTestBehavior.opaque,
                          child: Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.06),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: Colors.white.withValues(alpha: 0.08),
                                width: 0.8,
                              ),
                            ),
                            child: const Center(
                              child: FaIcon(
                                FontAwesomeIcons.trashCan,
                                color: Colors.white60,
                                size: 12,
                              ),
                            ),
                          ),
                        ),
                      ],
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
}
