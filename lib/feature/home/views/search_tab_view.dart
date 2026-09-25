import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import '../../../constants/app_colors.dart';
import '../../../constants/app_text_styles.dart';
import '../../../constants/enum.dart';
import '../../../models/response/search_discorvey_model.dart';
import '../../../models/response/search_suggestion_response.dart';
import '../../../shared/widgets/custom_animation.dart';
import '../controller/search_tab_controller.dart';

class SearchTabView extends StatelessWidget {
  const SearchTabView({super.key});

  @override
  Widget build(BuildContext context) {
    // Ensure SearchTabController is registered and initialized
    final controller = Get.put(SearchTabController());

    return CustomScaffold(
      showAppBar: false,
      safeArea: false,
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          // ── Background Ambient Gradient
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: AppColors.loginBgGradient,
              ),
            ),
          ),

          // ── Main Content Area
          SafeArea(
            bottom: false,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Top Header Section
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
                  child: Obx(
                    () => Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          controller.discoveryTitle.tr,
                          style: AppTextStyles.text24Bold.copyWith(
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          controller.discoverySubtitle.tr,
                          style: AppTextStyles.text14Medium.copyWith(
                            color: const Color(0xFF8A8A8A),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // ── Search Input Field
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: _buildSearchInputField(controller),
                ),
                const SizedBox(height: 16),

                // ── Body Area (Dynamic: Default Views vs Search Results)
                Expanded(
                  child: Obx(() {
                    final query = controller.searchQuery.value.trim();

                    if (query.isNotEmpty) {
                      return _buildSearchResultsView(controller);
                    }

                    return _buildDefaultSearchView(controller);
                  }),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Search Input Bar Widget
  Widget _buildSearchInputField(SearchTabController controller) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: const Color(0xFF14141E).withValues(alpha: 0.85),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.1),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.35),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          const SizedBox(width: 14),
          const FaIcon(
            FontAwesomeIcons.magnifyingGlass,
            color: Color(0xFF8E8E9E),
            size: 16,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              controller: controller.searchTextController,
              cursorColor: AppColors.primary,
              style: AppTextStyles.text14Medium.copyWith(
                color: Colors.white,
                letterSpacing: 0.2,
              ),
              decoration: InputDecoration(
                hintText: 'Search dramas, genres...'.tr,
                hintStyle: AppTextStyles.text14.copyWith(
                  color: const Color(0xFF5A5A6E),
                ),
                border: InputBorder.none,
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
          Obx(() {
            if (controller.searchQuery.value.isNotEmpty) {
              return GestureDetector(
                onTap: controller.clearSearch,
                behavior: HitTestBehavior.opaque,
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  child: FaIcon(
                    FontAwesomeIcons.xmark,
                    color: Color(0xFF8A8A9E),
                    size: 15,
                  ),
                ),
              );
            }
            return const SizedBox(width: 6);
          }),
        ],
      ),
    );
  }

  // ── Default View (Recent Searches + Popular Searches + Recommended)
  Widget _buildDefaultSearchView(SearchTabController controller) {
    if (controller.landingSearchStatus.value == Status.loading &&
        controller.popularSearches.isEmpty &&
        controller.recommendedDramas.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(
          color: AppColors.primary,
        ),
      );
    }

    if (controller.landingSearchStatus.value == Status.error &&
        controller.popularSearches.isEmpty &&
        controller.recommendedDramas.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const FaIcon(
              FontAwesomeIcons.triangleExclamation,
              color: Color(0xFF8A8A9A),
              size: 32,
            ),
            const SizedBox(height: 12),
            Text(
              'Failed to load search recommendations'.tr,
              style: AppTextStyles.text14Medium.copyWith(color: Colors.white70),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: controller.setLandingSearch,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
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

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 110),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── 1. Recent Searches Section
          Obx(() {
            if (controller.recentSearches.isEmpty) {
              return const SizedBox.shrink();
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Recent Searches'.tr,
                      style: AppTextStyles.text16Bold.copyWith(
                        color: Colors.white,
                      ),
                    ),
                    GestureDetector(
                      onTap: controller.clearRecentSearches,
                      behavior: HitTestBehavior.opaque,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Text(
                          'Clear All'.tr,
                          style: AppTextStyles.text13Medium.copyWith(
                            color: const Color(0xFF8A8A9E),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                // Recent searches list items
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: controller.recentSearches.length,
                  separatorBuilder: (context, index) => Divider(
                    height: 1,
                    thickness: 0.8,
                    color: Colors.white.withValues(alpha: 0.06),
                  ),
                  itemBuilder: (context, index) {
                    final item = controller.recentSearches[index];
                    return InkWell(
                      onTap: () => controller.selectSearchQuery(item),
                      borderRadius: BorderRadius.circular(8),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: Row(
                          children: [
                            const FaIcon(
                              FontAwesomeIcons.clockRotateLeft,
                              size: 14,
                              color: Color(0xFF6E6E82),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                item,
                                style: AppTextStyles.text14Medium.copyWith(
                                  color: const Color(0xFFC0C0D0),
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () => controller.removeRecentSearch(index),
                              behavior: HitTestBehavior.opaque,
                              child: const Padding(
                                padding: EdgeInsets.all(6.0),
                                child: FaIcon(
                                  FontAwesomeIcons.xmark,
                                  size: 13,
                                  color: Color(0xFF6E6E7E),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 24),
              ],
            );
          }),

          // ── 2. Popular Searches Section
          if (controller.popularSearches.isNotEmpty) ...[
            Text(
              'Popular Searches'.tr,
              style: AppTextStyles.text16Bold.copyWith(color: Colors.white),
            ),
            const SizedBox(height: 12),

            for (final item in controller.popularSearches) ...[
              GestureDetector(
                onTap: () => controller.onPopularSearchTap(item),
                child: Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF14141E).withValues(alpha: 0.8),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.07),
                      width: 0.8,
                    ),
                  ),
                  child: Row(
                    children: [
                      // Rank Indicator Badge
                      Container(
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                          color: item.displayRank <= 3
                              ? AppColors.primary.withValues(alpha: 0.2)
                              : Colors.white.withValues(alpha: 0.06),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: item.displayRank <= 3
                                ? AppColors.primary.withValues(alpha: 0.45)
                                : Colors.white.withValues(alpha: 0.12),
                            width: 1,
                          ),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          item.displayRank > 0
                              ? '${item.displayRank}'
                              : (item.rank.isNotEmpty ? item.rank : '•'),
                          style: TextStyle(
                            fontFamily: AppTextStyles.fontFamily,
                            color: item.displayRank <= 3
                                ? AppColors.primary
                                : const Color(0xFFA0A0B0),
                            fontWeight: FontWeight.w700,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),

                      // Thumbnail (if available)
                      if (item.posterUrl.isNotEmpty) ...[
                        ClipRRect(
                          borderRadius: BorderRadius.circular(6),
                          child: SizedBox(
                            width: 38,
                            height: 50,
                            child: Image.network(
                              item.posterUrl,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => Container(
                                color: const Color(0xFF22222E),
                                child: const Center(
                                  child: FaIcon(
                                    FontAwesomeIcons.film,
                                    size: 14,
                                    color: Color(0xFF6E6E7E),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                      ],

                      // Title & Subtitle Info
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppTextStyles.text14SemiBold.copyWith(
                                color: const Color(0xFFE0E0EC),
                              ),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              [
                                if (item.viewsFormatted.isNotEmpty)
                                  '${item.viewsFormatted} plays',
                                if (item.genreDisplay.isNotEmpty)
                                  item.genreDisplay
                                else if (item.rating > 0)
                                  '★ ${item.rating.toStringAsFixed(1)}',
                              ].join(' · '),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppTextStyles.text12.copyWith(
                                color: const Color(0xFF7A7A8E),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),

                      const FaIcon(
                        FontAwesomeIcons.chevronRight,
                        size: 12,
                        color: Color(0xFF6E6E7E),
                      ),
                    ],
                  ),
                ),
              ),
            ],
            const SizedBox(height: 24),
          ],

          // ── 3. Recommended for you Section (3-column grid)
          if (controller.recommendedDramas.isNotEmpty) ...[
            Text(
              'Recommended for you'.tr,
              style: AppTextStyles.text16Bold.copyWith(color: Colors.white),
            ),
            const SizedBox(height: 14),

            _buildRecommendedGrid(controller.recommendedDramas, controller),
          ],
        ],
      ),
    );
  }

  // ── Dynamic 3-Column Poster Grid for Recommended Dramas
  Widget _buildRecommendedGrid(
    List<RecommendedDrama> dramas,
    SearchTabController controller,
  ) {
    final rows = <List<RecommendedDrama>>[];
    for (int i = 0; i < dramas.length; i += 3) {
      rows.add(
        dramas.sublist(i, i + 3 > dramas.length ? dramas.length : i + 3),
      );
    }

    return Column(
      children: [
        for (int r = 0; r < rows.length; r++) ...[
          if (r > 0) const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (int c = 0; c < 3; c++) ...[
                if (c > 0) const SizedBox(width: 10),
                if (c < rows[r].length)
                  Expanded(
                    child: _buildRecommendedPosterCard(
                      rows[r][c],
                      controller,
                      height: 165,
                    ),
                  )
                else
                  const Expanded(child: SizedBox()),
              ],
            ],
          ),
        ],
      ],
    );
  }

  // ── Recommended Drama Poster Card
  Widget _buildRecommendedPosterCard(
    RecommendedDrama drama,
    SearchTabController controller, {
    required double height,
  }) {
    return GestureDetector(
      onTap: () => controller.onRecommendedDramaTap(drama),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: height,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: AppColors.cardBackground,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  // Poster Artwork from API
                  Image.network(
                    drama.posterUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      color: const Color(0xFF1E1E28),
                      child: const Center(
                        child: FaIcon(
                          FontAwesomeIcons.film,
                          color: Color(0xFF4A4A5A),
                          size: 24,
                        ),
                      ),
                    ),
                  ),

                  // Top-Right Plays / Rating Badge
                  Positioned(
                    top: 6,
                    right: 6,
                    child: _buildDarkBadge(
                      drama.viewsFormatted.isNotEmpty
                          ? '▶ ${drama.viewsFormatted}'
                          : '★ ${drama.rating.toStringAsFixed(1)}',
                    ),
                  ),

                  // Bottom Gradient
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    height: 40,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.transparent,
                            Colors.black.withValues(alpha: 0.8),
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            drama.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.text12SemiBold.copyWith(
              color: const Color(0xFFE0E0EC),
            ),
          ),
        ],
      ),
    );
  }

  // ── Top-Right Dark Mini Badge
  Widget _buildDarkBadge(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2.5),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 8.5,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  // ── Live Search Results View (From API)
  Widget _buildSearchResultsView(SearchTabController controller) {
    if (controller.searchStatus.value == Status.loading) {
      return const Center(
        child: CircularProgressIndicator(
          color: AppColors.primary,
        ),
      );
    }

    final suggestions = controller.suggestions;
    final dramas = controller.searchDramas;

    if (suggestions.isEmpty && dramas.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 68,
                height: 68,
                decoration: BoxDecoration(
                  color: const Color(0xFF1C1C26),
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color(0xFF2E2E3E), width: 1),
                ),
                child: const Center(
                  child: FaIcon(
                    FontAwesomeIcons.magnifyingGlass,
                    color: Color(0xFF8A8A9A),
                    size: 26,
                  ),
                ),
              ),
              const SizedBox(height: 18),
              Text(
                'No results found'.tr,
                style: AppTextStyles.text18Bold.copyWith(color: Colors.white),
              ),
              const SizedBox(height: 6),
              Text(
                'We couldn\'t find any series matching "${controller.searchQuery.value}". Try searching for other titles or genres.'.tr,
                textAlign: TextAlign.center,
                style: AppTextStyles.text13Medium.copyWith(
                  color: const Color(0xFF8A8A8A),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 110),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Suggestions List
          if (suggestions.isNotEmpty) ...[
            Text(
              'Suggestions (${suggestions.length})'.tr,
              style: AppTextStyles.text16Bold.copyWith(color: Colors.white),
            ),
            const SizedBox(height: 12),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: suggestions.length,
              separatorBuilder: (context, index) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final suggestion = suggestions[index];
                return GestureDetector(
                  onTap: () => controller.onSuggestionTap(suggestion),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF14141E).withValues(alpha: 0.8),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.06),
                        width: 0.8,
                      ),
                    ),
                    child: Row(
                      children: [
                        if (suggestion.posterUrl.isNotEmpty) ...[
                          ClipRRect(
                            borderRadius: BorderRadius.circular(6),
                            child: SizedBox(
                              width: 38,
                              height: 50,
                              child: Image.network(
                                suggestion.posterUrl,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => Container(
                                  color: const Color(0xFF22222E),
                                  child: const Center(
                                    child: FaIcon(
                                      FontAwesomeIcons.film,
                                      size: 14,
                                      color: Color(0xFF6E6E7E),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                        ],
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                suggestion.title,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: AppTextStyles.text14SemiBold.copyWith(
                                  color: const Color(0xFFE0E0EC),
                                ),
                              ),
                              if (suggestion.viewsFormatted.isNotEmpty ||
                                  suggestion.rating > 0) ...[
                                const SizedBox(height: 3),
                                Text(
                                  [
                                    if (suggestion.viewsFormatted.isNotEmpty)
                                      '${suggestion.viewsFormatted} plays',
                                    if (suggestion.rating > 0)
                                      '★ ${suggestion.rating.toStringAsFixed(1)}',
                                  ].join(' · '),
                                  style: AppTextStyles.text12.copyWith(
                                    color: const Color(0xFF7A7A8E),
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        const FaIcon(
                          FontAwesomeIcons.chevronRight,
                          size: 12,
                          color: Color(0xFF6E6E7E),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 20),
          ],

          // ── Search Dramas Grid
          if (dramas.isNotEmpty) ...[
            Text(
              'Dramas (${dramas.length})'.tr,
              style: AppTextStyles.text16Bold.copyWith(color: Colors.white),
            ),
            const SizedBox(height: 14),
            _buildSearchDramasGrid(dramas, controller),
          ],
        ],
      ),
    );
  }

  // ── Dynamic 3-Column Poster Grid for Search Dramas
  Widget _buildSearchDramasGrid(
    List<SearchDrama> dramas,
    SearchTabController controller,
  ) {
    final rows = <List<SearchDrama>>[];
    for (int i = 0; i < dramas.length; i += 3) {
      rows.add(
        dramas.sublist(i, i + 3 > dramas.length ? dramas.length : i + 3),
      );
    }

    return Column(
      children: [
        for (int r = 0; r < rows.length; r++) ...[
          if (r > 0) const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (int c = 0; c < 3; c++) ...[
                if (c > 0) const SizedBox(width: 10),
                if (c < rows[r].length)
                  Expanded(
                    child: GestureDetector(
                      onTap: () => controller.onSearchDramaTap(rows[r][c]),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 165,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: AppColors.cardBackground,
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.network(
                                rows[r][c].posterUrl,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => Container(
                                  color: const Color(0xFF1E1E28),
                                  child: const Center(
                                    child: FaIcon(
                                      FontAwesomeIcons.film,
                                      color: Color(0xFF4A4A5A),
                                      size: 24,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            rows[r][c].title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.text12SemiBold.copyWith(
                              color: const Color(0xFFE0E0EC),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                else
                  const Expanded(child: SizedBox()),
              ],
            ],
          ),
        ],
      ],
    );
  }
}
