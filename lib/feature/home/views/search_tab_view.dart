import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../constants/app_colors.dart';
import '../../../constants/app_text_styles.dart';
import '../controller/search_tab_controller.dart';
import '../models/movie_model.dart';

class SearchTabView extends StatelessWidget {
  const SearchTabView({super.key});

  @override
  Widget build(BuildContext context) {
    // Ensure SearchTabController is registered and initialized
    final controller = Get.put(SearchTabController());

    return Stack(
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
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Top Header Section (Back Button + Titles)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header Title
                  Text(
                    'Search',
                    style: AppTextStyles.text24Bold.copyWith(
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),

                  // Subtitle
                  Text(
                    'Find your next story',
                    style: AppTextStyles.text14Medium.copyWith(
                      color: const Color(0xFF8A8A8A),
                    ),
                  ),
                ],
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
      ],
    );
  }

  // ── Search Input Bar Widget
  Widget _buildSearchInputField(SearchTabController controller) {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const SizedBox(width: 14),
          const Icon(Icons.search_rounded, color: Color(0xFF6E6E7E), size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: controller.searchTextController,
              cursorColor: AppColors.primary,
              style: AppTextStyles.text14Medium.copyWith(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Search series, episodes, genres...',
                hintStyle: AppTextStyles.text14.copyWith(
                  color: const Color(0xFF6E6E7E),
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
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: Icon(
                    Icons.close_rounded,
                    color: Color(0xFF8A8A8A),
                    size: 18,
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
                      'Recent Searches',
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
                          'Clear All',
                          style: AppTextStyles.text13Medium.copyWith(
                            color: const Color(0xFF8A8A8A),
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
                  separatorBuilder: (context, index) => const Divider(
                    height: 1,
                    thickness: 0.8,
                    color: Color(0xFF22222E),
                  ),
                  itemBuilder: (context, index) {
                    final item = controller.recentSearches[index];
                    return InkWell(
                      onTap: () => controller.selectSearchQuery(item),
                      borderRadius: BorderRadius.circular(6),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                item,
                                style: AppTextStyles.text14Medium.copyWith(
                                  color: const Color(0xFF8A8A8A),
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () => controller.removeRecentSearch(index),
                              behavior: HitTestBehavior.opaque,
                              child: const Padding(
                                padding: EdgeInsets.all(4.0),
                                child: Icon(
                                  Icons.close_rounded,
                                  size: 16,
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
          Text(
            'Popular Searches',
            style: AppTextStyles.text16Bold.copyWith(color: Colors.white),
          ),
          const SizedBox(height: 12),

          // Popular numbered cards list
          for (final item in controller.popularSearches) ...[
            GestureDetector(
              onTap: () => controller.selectSearchQuery(item['title']!),
              child: Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                decoration: BoxDecoration(
                  color: AppColors.cardBackground,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Text(
                      item['number']!,
                      style: const TextStyle(
                        fontFamily: AppTextStyles.fontFamily,
                        color: AppColors.primary,
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: Center(
                        child: Text(
                          item['title']!,
                          style: AppTextStyles.text14Medium.copyWith(
                            color: const Color(0xFFD0D0DC),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 34), // Balance spacing with number
                  ],
                ),
              ),
            ),
          ],
          const SizedBox(height: 24),

          // ── 3. Recommended for you Section (3-column grid)
          Text(
            'Recommended for you',
            style: AppTextStyles.text16Bold.copyWith(color: Colors.white),
          ),
          const SizedBox(height: 14),

          _buildPostersGrid(controller.searchRecommendedList, controller),
        ],
      ),
    );
  }

  // ── Dynamic 3-Column Poster Grid
  Widget _buildPostersGrid(
    List<MovieModel> movies,
    SearchTabController controller,
  ) {
    // Break list into chunks of 3 for Row-based grid without scroll overflow
    final rows = <List<MovieModel>>[];
    for (int i = 0; i < movies.length; i += 3) {
      rows.add(
        movies.sublist(i, i + 3 > movies.length ? movies.length : i + 3),
      );
    }

    return Column(
      children: [
        for (int r = 0; r < rows.length; r++) ...[
          if (r > 0) const SizedBox(height: 10),
          Row(
            children: [
              for (int c = 0; c < 3; c++) ...[
                if (c > 0) const SizedBox(width: 10),
                if (c < rows[r].length)
                  Expanded(
                    child: _buildSearchPosterCard(
                      rows[r][c],
                      controller,
                      height: 168,
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

  // ── Poster Card with Top Badges matching Screenshot
  Widget _buildSearchPosterCard(
    MovieModel movie,
    SearchTabController controller, {
    required double height,
  }) {
    return GestureDetector(
      onTap: () => controller.onMovieTap(movie),
      child: Container(
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
              // Poster Artwork
              Image.asset(
                movie.image,
                fit: BoxFit.cover,
                errorBuilder: (_, e, s) => Container(
                  color: const Color(0xFF1E1E28),
                  child: const Center(
                    child: Icon(
                      Icons.movie_outlined,
                      color: Color(0xFF4A4A5A),
                      size: 28,
                    ),
                  ),
                ),
              ),

              // Badges on Top
              Positioned(
                top: 6,
                left: 6,
                right: 6,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    // Dark Plays Badge (e.g. 3.5k)
                    _buildDarkBadge('▶ ${movie.plays}'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Top-Right Dark Mini Badge
  Widget _buildDarkBadge(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.65),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 7.5,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  // ── Live Search Results View
  Widget _buildSearchResultsView(SearchTabController controller) {
    final results = controller.searchResults;

    if (results.isEmpty) {
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
                child: const Icon(
                  Icons.search_off_rounded,
                  color: Color(0xFF8A8A9A),
                  size: 32,
                ),
              ),
              const SizedBox(height: 18),
              Text(
                'No results found',
                style: AppTextStyles.text18Bold.copyWith(color: Colors.white),
              ),
              const SizedBox(height: 6),
              Text(
                'We couldn\'t find any series matching "${controller.searchQuery.value}". Try searching for drama, romance, or popular titles.',
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
          Text(
            'Results (${results.length})',
            style: AppTextStyles.text16Bold.copyWith(color: Colors.white),
          ),
          const SizedBox(height: 14),
          _buildPostersGrid(results, controller),
        ],
      ),
    );
  }
}
