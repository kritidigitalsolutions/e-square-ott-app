import 'package:e_square_ott_app/constants/enum.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import '../../../constants/app_colors.dart';
import '../../../constants/app_text_styles.dart';
import '../../../models/response/saved_series_response.dart';
import '../../../routes/app_pages.dart';
import '../../../shared/widgets/custom_animation.dart';
import '../../../shared/widgets/custom_buttons.dart';
import '../../home/controller/whislist_controller.dart';

class SavedSeriesScreen extends StatefulWidget {
  const SavedSeriesScreen({super.key});

  @override
  State<SavedSeriesScreen> createState() => _SavedSeriesScreenState();
}

class _SavedSeriesScreenState extends State<SavedSeriesScreen> {
  late final WhislistController controller =
      Get.isRegistered<WhislistController>()
          ? Get.find<WhislistController>()
          : Get.put(WhislistController());

  final ScrollController _scrollController = ScrollController();
  String _selectedGenre = 'All';

  final List<String> _genres = const [
    'All',
    'Romance',
    'Drama',
    'Mystery',
    'Action',
    'Comedy',
    'Thriller',
  ];

  @override
  void initState() {
    super.initState();
    controller.getAllSavedWhislist();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 200 &&
        controller.isMoreWhislist.value &&
        controller.getOtherWhislistStatus.value != Status.loading) {
      controller.getOtherWhislist();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      showAppBar: false,
      safeArea: false,
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // ── Background Gradient
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
                            "Saved Series".tr,
                            style: AppTextStyles.text18Bold.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w800,
                              letterSpacing: -0.2,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Obx(() {
                            final count = controller.totalSavedCount;
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
                        if (controller.savedSeriesList.isEmpty) {
                          return const SizedBox.shrink();
                        }
                        return GestureDetector(
                          onTap: () => _confirmClearAll(context),
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

                // ── Genre Filter Pills
                Obx(() {
                  if (controller.savedSeriesList.isEmpty) {
                    return const SizedBox.shrink();
                  }
                  return Container(
                    height: 36,
                    margin: const EdgeInsets.only(top: 8, bottom: 12),
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      physics: const BouncingScrollPhysics(),
                      itemCount: _genres.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 8),
                      itemBuilder: (context, index) {
                        final genre = _genres[index];
                        final isSelected = _selectedGenre == genre;

                        return GestureDetector(
                          onTap: () {
                            HapticFeedback.lightImpact();
                            setState(() => _selectedGenre = genre);
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              gradient: isSelected
                                  ? AppColors.primaryGradient
                                  : null,
                              color: isSelected
                                  ? null
                                  : const Color(0xFF141420),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: isSelected
                                    ? Colors.transparent
                                    : Colors.white.withValues(alpha: 0.1),
                                width: 1,
                              ),
                              boxShadow: isSelected
                                  ? [
                                      BoxShadow(
                                        color: AppColors.primary
                                            .withValues(alpha: 0.35),
                                        blurRadius: 10,
                                        offset: const Offset(0, 2),
                                      ),
                                    ]
                                  : null,
                            ),
                            child: Center(
                              child: Text(
                                genre.tr,
                                style: TextStyle(
                                  fontFamily: AppTextStyles.fontFamily,
                                  color: isSelected
                                      ? const Color(0xFF0C0B10)
                                      : Colors.white70,
                                  fontSize: 12,
                                  fontWeight: isSelected
                                      ? FontWeight.w900
                                      : FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  );
                }),

                // ── Saved Series List / Empty / Loading State
                Expanded(
                  child: Obx(() {
                    final status = controller.getAllSavedWhislistStatus.value;
                    final allItems = controller.savedSeriesList;

                    if (status == Status.loading && allItems.isEmpty) {
                      return const Center(
                        child: CircularProgressIndicator(
                          color: AppColors.primary,
                        ),
                      );
                    }

                    if (status == Status.error && allItems.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const FaIcon(
                              FontAwesomeIcons.circleExclamation,
                              color: Colors.white54,
                              size: 36,
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'Failed to load saved series'.tr,
                              style: AppTextStyles.text14Medium.copyWith(
                                color: Colors.white70,
                              ),
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: () =>
                                  controller.getAllSavedWhislist(),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                foregroundColor: Colors.black,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: Text('Retry'.tr),
                            ),
                          ],
                        ),
                      );
                    }

                    final filtered = _selectedGenre == 'All'
                        ? allItems
                        : allItems.where((e) {
                            final genre = _selectedGenre.toLowerCase();
                            return e.drama.genreDisplay
                                    .toLowerCase()
                                    .contains(genre) ||
                                e.drama.genres.any(
                                  (g) => g.toLowerCase().contains(genre),
                                );
                          }).toList();

                    if (filtered.isEmpty) {
                      return _buildEmptyState();
                    }

                    return RefreshIndicator(
                      color: AppColors.primary,
                      backgroundColor: const Color(0xFF14141E),
                      onRefresh: () => controller.getAllSavedWhislist(),
                      child: ListView.separated(
                        controller: _scrollController,
                        padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
                        physics: const AlwaysScrollableScrollPhysics(
                          parent: BouncingScrollPhysics(),
                        ),
                        itemCount: filtered.length +
                            (controller.getOtherWhislistStatus.value ==
                                    Status.loading
                                ? 1
                                : 0),
                        separatorBuilder: (_, __) =>
                            const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          if (index == filtered.length) {
                            return const Padding(
                              padding: EdgeInsets.symmetric(vertical: 16),
                              child: Center(
                                child: SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2.5,
                                    color: AppColors.primary,
                                  ),
                                ),
                              ),
                            );
                          }

                          final item = filtered[index];
                          final targetId = item.savedId.isNotEmpty
                              ? item.savedId
                              : (item.id.isNotEmpty
                                  ? item.id
                                  : item.drama.id);

                          return _SavedSeriesCard(
                            item: item,
                            onRemove: () => controller.deleteSavedSeries(
                              id: targetId,
                              dramaId: item.drama.id,
                            ),
                          );
                        },
                      ),
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
                  FontAwesomeIcons.bookmark,
                  color: AppColors.primary,
                  size: 30,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'No Saved Series Yet'.tr,
              style: const TextStyle(
                fontFamily: AppTextStyles.fontFamily,
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Save your favorite dramas and series to watch them anytime.'.tr,
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

  void _confirmClearAll(BuildContext context) {
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
          'Clear Saved Series?'.tr,
          style: const TextStyle(
            fontFamily: AppTextStyles.fontFamily,
            color: Colors.white,
            fontWeight: FontWeight.w800,
            fontSize: 18,
          ),
        ),
        content: Text(
          'Are you sure you want to clear all your saved series?'.tr,
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
              controller.clearAllSavedSeries();
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

class _SavedSeriesCard extends StatelessWidget {
  final SavedSeries item;
  final VoidCallback onRemove;

  const _SavedSeriesCard({
    required this.item,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final poster = item.drama.posterUrl.isNotEmpty
        ? item.drama.posterUrl
        : (item.drama.bannerUrl.isNotEmpty
            ? item.drama.bannerUrl
            : item.drama.poster);

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
                    arguments: item,
                  );
                },
                child: SizedBox(
                  width: 78,
                  height: 106,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        if (poster.startsWith('http'))
                          Image.network(
                            poster,
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
                          )
                        else
                          Image.asset(
                            poster,
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
                                  Colors.black.withValues(alpha: 0.75),
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
                            width: 26,
                            height: 26,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.black.withValues(alpha: 0.65),
                              border: Border.all(
                                color:
                                    AppColors.primary.withValues(alpha: 0.8),
                                width: 1,
                              ),
                            ),
                            child: const Center(
                              child: Padding(
                                padding: EdgeInsets.only(left: 1),
                                child: FaIcon(
                                  FontAwesomeIcons.play,
                                  color: AppColors.primary,
                                  size: 9,
                                ),
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
                      item.drama.title,
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

                    // Badges row: Category + Episodes
                    Row(
                      children: [
                        if (item.drama.genreDisplay.isNotEmpty)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.08),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              item.drama.genreDisplay.tr,
                              style: const TextStyle(
                                fontFamily: AppTextStyles.fontFamily,
                                color: AppColors.primaryLight,
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        if (item.drama.genreDisplay.isNotEmpty &&
                            item.drama.totalEpisodes > 0)
                          const SizedBox(width: 6),
                        if (item.drama.totalEpisodes > 0)
                          Text(
                            '${item.drama.totalEpisodes} ${"Episodes".tr}',
                            style: TextStyle(
                              fontFamily: AppTextStyles.fontFamily,
                              color: Colors.white.withValues(alpha: 0.6),
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 10),

                    // Actions Row: Watch Button + Remove Icon
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            HapticFeedback.lightImpact();
                            Get.toNamed(
                              Routes.dramaPlayer,
                              arguments: item,
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
                                  item.watchProgress?.actionLabel.isNotEmpty ==
                                          true
                                      ? item.watchProgress!.actionLabel.tr
                                      : 'Watch Now'.tr,
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

                        // Remove from Saved
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
