import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import '../../../constants/app_text_styles.dart';
import '../../../models/response/countinue_watching_model.dart';
import '../../../shared/widgets/custom_animation.dart';
import '../../../shared/widgets/custom_buttons.dart';
import '../controller/home_controller.dart';

class ContinueWatchingScreen extends StatefulWidget {
  const ContinueWatchingScreen({super.key});

  @override
  State<ContinueWatchingScreen> createState() => _ContinueWatchingScreenState();
}

class _ContinueWatchingScreenState extends State<ContinueWatchingScreen> {
  final HomeController controller = Get.find<HomeController>();
  String _selectedFilter = 'All';
  bool _isGridView = true;

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: CustomScaffold(
        showAppBar: false,
        safeArea: false,
        backgroundColor: const Color(0xFF06060A),
        body: Stack(
          children: [
            // Deep Atmosphere Background
            Positioned.fill(
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(0xFF120E1A),
                      Color(0xFF08070D),
                      Color(0xFF050508),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    stops: [0.0, 0.45, 1.0],
                  ),
                ),
              ),
            ),

            // Scarlet Glow Blob
            Positioned(
              top: -90,
              right: -70,
              child: Container(
                width: 280,
                height: 280,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFFE50914).withValues(alpha: 0.14),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFE50914).withValues(alpha: 0.2),
                      blurRadius: 130,
                      spreadRadius: 45,
                    ),
                  ],
                ),
              ),
            ),

            SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTopNavBar(context),
                  _buildControlsRow(),
                  const SizedBox(height: 10),
                  Expanded(
                    child: Obx(() {
                      final allItems = controller.continueWatchingItems;
                      final filteredItems = _selectedFilter == 'All'
                          ? allItems.toList()
                          : allItems.where((item) {
                              final filter = _selectedFilter.toLowerCase();
                              return item.drama.genreDisplay
                                      .toLowerCase()
                                      .contains(filter) ||
                                  item.drama.genres.any(
                                    (g) => g.toLowerCase().contains(filter),
                                  );
                            }).toList();

                      if (allItems.isEmpty) {
                        return _buildEmptyState();
                      }

                      if (filteredItems.isEmpty) {
                        return Center(
                          child: Text(
                            'No shows found in "$_selectedFilter"',
                            style: const TextStyle(
                              fontFamily: AppTextStyles.fontFamily,
                              color: Color(0xFF8E8E9F),
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        );
                      }

                      return CustomScrollView(
                        physics: const BouncingScrollPhysics(),
                        slivers: [
                          if (_selectedFilter == 'All' &&
                              filteredItems.isNotEmpty)
                            SliverToBoxAdapter(
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(
                                  16,
                                  4,
                                  16,
                                  18,
                                ),
                                child: _SpotlightHeroCard(
                                  item: filteredItems[0],
                                  onResume: () =>
                                      controller.onContinueWatchingItemTap(
                                    filteredItems[0],
                                  ),
                                  onDelete: () =>
                                      controller.removeContinueWatching(
                                    filteredItems[0].historyId,
                                  ),
                                ),
                              ),
                            ),

                          if (_selectedFilter == 'All' &&
                              filteredItems.length > 1)
                            SliverToBoxAdapter(
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(
                                  16,
                                  0,
                                  16,
                                  12,
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 3.5,
                                      height: 14,
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFE50914),
                                        borderRadius: BorderRadius.circular(2),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      'More In Progress (${filteredItems.length - 1})',
                                      style: const TextStyle(
                                        fontFamily: AppTextStyles.fontFamily,
                                        color: Colors.white,
                                        fontSize: 14.5,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),

                          if (_isGridView)
                            _buildGridSliver(
                              _selectedFilter == 'All' &&
                                      filteredItems.isNotEmpty
                                  ? filteredItems.sublist(1)
                                  : filteredItems,
                            )
                          else
                            _buildListSliver(
                              _selectedFilter == 'All' &&
                                      filteredItems.isNotEmpty
                                  ? filteredItems.sublist(1)
                                  : filteredItems,
                            ),

                          const SliverToBoxAdapter(child: SizedBox(height: 36)),
                        ],
                      );
                    }),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopNavBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 6, 16, 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Row(
              children: [
                CustomBackButton(onTap: () => Get.back()),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 7,
                            height: 7,
                            decoration: BoxDecoration(
                              color: const Color(0xFFE50914),
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(
                                    0xFFE50914,
                                  ).withValues(alpha: 0.8),
                                  blurRadius: 8,
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              'Continue Watching'.tr.toUpperCase(),
                              style: const TextStyle(
                                fontFamily: AppTextStyles.fontFamily,
                                color: Color(0xFFE50914),
                                fontSize: 10,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 1.5,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Resume Playing'.tr,
                        style: const TextStyle(
                          fontFamily: AppTextStyles.fontFamily,
                          color: Colors.white,
                          fontSize: 19,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.4,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Obx(() {
            final count = controller.continueWatchingItems.length;
            if (count == 0) return const SizedBox.shrink();

            return GestureDetector(
              onTap: () => _showClearConfirmation(context),
              behavior: HitTestBehavior.opaque,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.06),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.08),
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const FaIcon(
                      FontAwesomeIcons.trashCan,
                      color: Color(0xFFB0B0C0),
                      size: 11,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      'Clear ($count)',
                      style: const TextStyle(
                        fontFamily: AppTextStyles.fontFamily,
                        color: Color(0xFFD0D0E0),
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
    );
  }

  Widget _buildControlsRow() {
    final filters = ['All', 'Romance', 'Drama', 'Action', 'Thriller'];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: SizedBox(
              height: 36,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                itemCount: filters.length,
                separatorBuilder: (_, __) => const SizedBox(width: 7),
                itemBuilder: (context, index) {
                  final filter = filters[index];
                  final isSelected = _selectedFilter == filter;

                  return GestureDetector(
                    onTap: () {
                      HapticFeedback.lightImpact();
                      setState(() => _selectedFilter = filter);
                    },
                    behavior: HitTestBehavior.opaque,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      curve: Curves.easeOutCubic,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 13,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? const Color(0xFFE50914)
                            : const Color(0xFF141420),
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(
                          color: isSelected
                              ? const Color(0xFFFF4D58)
                              : Colors.white.withValues(alpha: 0.07),
                          width: 1,
                        ),
                        boxShadow: isSelected
                            ? [
                                BoxShadow(
                                  color: const Color(
                                    0xFFE50914,
                                  ).withValues(alpha: 0.35),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ]
                            : [],
                      ),
                      child: Center(
                        child: Text(
                          filter,
                          style: TextStyle(
                            fontFamily: AppTextStyles.fontFamily,
                            color: isSelected
                                ? Colors.white
                                : const Color(0xFF9E9EAE),
                            fontSize: 11.5,
                            fontWeight: isSelected
                                ? FontWeight.w800
                                : FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.all(3),
            decoration: BoxDecoration(
              color: const Color(0xFF141420),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.08),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                _buildToggleButton(
                  icon: FontAwesomeIcons.tableCellsLarge,
                  isActive: _isGridView,
                  onTap: () => setState(() => _isGridView = true),
                ),
                _buildToggleButton(
                  icon: FontAwesomeIcons.list,
                  isActive: !_isGridView,
                  onTap: () => setState(() => _isGridView = false),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildToggleButton({
    required FaIconData icon,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.selectionClick();
        onTap();
      },
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        width: 30,
        height: 28,
        decoration: BoxDecoration(
          color: isActive ? const Color(0xFFE50914) : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: FaIcon(
            icon,
            color: isActive ? Colors.white : const Color(0xFF8E8E9F),
            size: 11.5,
          ),
        ),
      ),
    );
  }

  Widget _buildGridSliver(List<ContinueWatchingItem> items) {
    if (items.isEmpty) {
      return const SliverToBoxAdapter(child: SizedBox.shrink());
    }

    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      sliver: SliverGrid(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 14,
          childAspectRatio: 0.64,
        ),
        delegate: SliverChildBuilderDelegate((context, index) {
          final item = items[index];
          return _GridContinueWatchingCard(
            item: item,
            onTap: () => controller.onContinueWatchingItemTap(item),
            onDelete: () => controller.removeContinueWatching(item.historyId),
          );
        }, childCount: items.length),
      ),
    );
  }

  Widget _buildListSliver(List<ContinueWatchingItem> items) {
    if (items.isEmpty) {
      return const SliverToBoxAdapter(child: SizedBox.shrink());
    }

    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate((context, index) {
          final item = items[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Dismissible(
              key: ValueKey(item.historyId),
              direction: DismissDirection.endToStart,
              onDismissed: (_) =>
                  controller.removeContinueWatching(item.historyId),
              background: Container(
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.only(right: 20),
                decoration: BoxDecoration(
                  color: const Color(0xFFE50914),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const FaIcon(
                  FontAwesomeIcons.trashCan,
                  color: Colors.white,
                  size: 18,
                ),
              ),
              child: _ListContinueWatchingCard(
                item: item,
                onTap: () => controller.onContinueWatchingItemTap(item),
                onDelete: () =>
                    controller.removeContinueWatching(item.historyId),
              ),
            ),
          );
        }, childCount: items.length),
      ),
    );
  }

  void _showClearConfirmation(BuildContext context) {
    HapticFeedback.mediumImpact();
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return Container(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
          decoration: BoxDecoration(
            color: const Color(0xFF141420),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.1),
              width: 1,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 20),
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: const Color(0xFFE50914).withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: const Color(0xFFE50914).withValues(alpha: 0.35),
                    width: 1.5,
                  ),
                ),
                child: const Center(
                  child: FaIcon(
                    FontAwesomeIcons.trashCan,
                    color: Color(0xFFE50914),
                    size: 22,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Clear Watch History?',
                style: TextStyle(
                  fontFamily: AppTextStyles.fontFamily,
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'This will remove all items from your continue watching queue.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: AppTextStyles.fontFamily,
                  color: Color(0xFF8E8E9F),
                  fontSize: 13,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => Navigator.pop(ctx),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 13),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1E1E2D),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.08),
                            width: 1,
                          ),
                        ),
                        child: const Center(
                          child: Text(
                            'Cancel',
                            style: TextStyle(
                              fontFamily: AppTextStyles.fontFamily,
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pop(ctx);
                        controller.clearAllContinueWatching();
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 13),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFFE50914), Color(0xFFB81D24)],
                          ),
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(
                                0xFFE50914,
                              ).withValues(alpha: 0.4),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: const Center(
                          child: Text(
                            'Clear All',
                            style: TextStyle(
                              fontFamily: AppTextStyles.fontFamily,
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 88,
              height: 88,
              decoration: BoxDecoration(
                color: const Color(0xFF141422),
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.08),
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.6),
                    blurRadius: 24,
                  ),
                ],
              ),
              child: const Center(
                child: FaIcon(
                  FontAwesomeIcons.film,
                  color: Color(0xFF6E6E82),
                  size: 34,
                ),
              ),
            ),
            const SizedBox(height: 22),
            const Text(
              'No Shows In Progress',
              style: TextStyle(
                fontFamily: AppTextStyles.fontFamily,
                color: Colors.white,
                fontSize: 19,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Shows you start watching will appear here with your saved resume progress.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: AppTextStyles.fontFamily,
                color: Color(0xFF8A8A9C),
                fontSize: 13,
                height: 1.45,
              ),
            ),
            const SizedBox(height: 26),
            GestureDetector(
              onTap: () => Get.back(),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 13,
                ),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFE50914), Color(0xFFB81D24)],
                  ),
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFE50914).withValues(alpha: 0.4),
                      blurRadius: 16,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Text(
                  'Explore Trending Shows',
                  style: TextStyle(
                    fontFamily: AppTextStyles.fontFamily,
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SpotlightHeroCard extends StatefulWidget {
  final ContinueWatchingItem item;
  final VoidCallback onResume;
  final VoidCallback onDelete;

  const _SpotlightHeroCard({
    required this.item,
    required this.onResume,
    required this.onDelete,
  });

  @override
  State<_SpotlightHeroCard> createState() => _SpotlightHeroCardState();
}

class _SpotlightHeroCardState extends State<_SpotlightHeroCard> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final item = widget.item;
    final poster = item.drama.posterUrl.isNotEmpty
        ? item.drama.posterUrl
        : item.drama.bannerUrl;
    final rawProgress = item.playback.progressPercentage;
    final progress = (rawProgress > 1.0 ? rawProgress / 100.0 : rawProgress)
        .clamp(0.0, 1.0);
    final percent = (progress * 100).toInt();

    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        widget.onResume();
      },
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      behavior: HitTestBehavior.opaque,
      child: AnimatedScale(
        scale: _isPressed ? 0.98 : 1.0,
        duration: const Duration(milliseconds: 130),
        curve: Curves.easeOutCubic,
        child: Container(
          height: 195,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22),
            border: Border.all(
              color: const Color(0xFFE50914).withValues(alpha: 0.35),
              width: 1.2,
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFE50914).withValues(alpha: 0.15),
                blurRadius: 20,
                offset: const Offset(0, 6),
              ),
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.7),
                blurRadius: 16,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(21),
            child: Stack(
              fit: StackFit.expand,
              children: [
                if (poster.startsWith('http'))
                  Image.network(
                    poster,
                    fit: BoxFit.cover,
                    errorBuilder: (_, e, s) =>
                        Container(color: const Color(0xFF181824)),
                  )
                else
                  Image.asset(
                    poster,
                    fit: BoxFit.cover,
                    errorBuilder: (_, e, s) =>
                        Container(color: const Color(0xFF181824)),
                  ),
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.black.withValues(alpha: 0.25),
                        Colors.black.withValues(alpha: 0.55),
                        const Color(0xFF07070A).withValues(alpha: 0.96),
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      stops: const [0.0, 0.45, 1.0],
                    ),
                  ),
                ),
                Positioned(
                  top: 12,
                  left: 12,
                  right: 12,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 9,
                          vertical: 4.5,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE50914),
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(
                                0xFFE50914,
                              ).withValues(alpha: 0.6),
                              blurRadius: 10,
                            ),
                          ],
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            FaIcon(
                              FontAwesomeIcons.fire,
                              color: Colors.white,
                              size: 10,
                            ),
                            SizedBox(width: 5),
                            Text(
                              'LAST WATCHED',
                              style: TextStyle(
                                fontFamily: AppTextStyles.fontFamily,
                                color: Colors.white,
                                fontSize: 9.5,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 0.8,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.7),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.15),
                            width: 1,
                          ),
                        ),
                        child: Text(
                          item.episode.seasonEpisodeTag.isNotEmpty
                              ? item.episode.seasonEpisodeTag
                              : 'Episode ${item.episode.episodeNumber}',
                          style: const TextStyle(
                            fontFamily: AppTextStyles.fontFamily,
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Center(
                  child: Container(
                    width: 46,
                    height: 46,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: const LinearGradient(
                        colors: [Color(0xFFE50914), Color(0xFFB81D24)],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFE50914).withValues(alpha: 0.7),
                          blurRadius: 18,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: const Center(
                      child: Padding(
                        padding: EdgeInsets.only(left: 3),
                        child: FaIcon(
                          FontAwesomeIcons.play,
                          color: Colors.white,
                          size: 15,
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: 14,
                  right: 14,
                  bottom: 12,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        item.drama.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontFamily: AppTextStyles.fontFamily,
                          color: Colors.white,
                          fontSize: 15.5,
                          fontWeight: FontWeight.w900,
                          letterSpacing: -0.2,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const FaIcon(
                                FontAwesomeIcons.clock,
                                color: Color(0xFFB0B0C0),
                                size: 10,
                              ),
                              const SizedBox(width: 5),
                              Text(
                                item.playback.formattedRemaining.isNotEmpty
                                    ? '${item.playback.formattedRemaining} remaining'
                                    : 'In progress',
                                style: const TextStyle(
                                  fontFamily: AppTextStyles.fontFamily,
                                  color: Color(0xFFD0D0E0),
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          Text(
                            '$percent%',
                            style: const TextStyle(
                              fontFamily: AppTextStyles.fontFamily,
                              color: Color(0xFFFF4D58),
                              fontSize: 11,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: Container(
                          height: 4,
                          width: double.infinity,
                          color: Colors.white.withValues(alpha: 0.15),
                          child: FractionallySizedBox(
                            alignment: Alignment.centerLeft,
                            widthFactor: progress,
                            child: Container(
                              decoration: const BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Color(0xFFFF5260),
                                    Color(0xFFE50914),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _GridContinueWatchingCard extends StatefulWidget {
  final ContinueWatchingItem item;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const _GridContinueWatchingCard({
    required this.item,
    required this.onTap,
    required this.onDelete,
  });

  @override
  State<_GridContinueWatchingCard> createState() =>
      _GridContinueWatchingCardState();
}

class _GridContinueWatchingCardState extends State<_GridContinueWatchingCard> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final item = widget.item;
    final poster = item.drama.posterUrl.isNotEmpty
        ? item.drama.posterUrl
        : item.drama.bannerUrl;
    final rawProgress = item.playback.progressPercentage;
    final progress = (rawProgress > 1.0 ? rawProgress / 100.0 : rawProgress)
        .clamp(0.0, 1.0);
    final percent = (progress * 100).toInt();

    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        widget.onTap();
      },
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      behavior: HitTestBehavior.opaque,
      child: AnimatedScale(
        scale: _isPressed ? 0.96 : 1.0,
        duration: const Duration(milliseconds: 130),
        curve: Curves.easeOutCubic,
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xFF131320),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.08),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.5),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      if (poster.startsWith('http'))
                        Image.network(
                          poster,
                          fit: BoxFit.cover,
                          errorBuilder: (_, e, s) => Container(
                            color: const Color(0xFF1E1E2C),
                            child: const Center(
                              child: FaIcon(
                                FontAwesomeIcons.film,
                                color: Colors.white24,
                                size: 24,
                              ),
                            ),
                          ),
                        )
                      else
                        Image.asset(
                          poster,
                          fit: BoxFit.cover,
                          errorBuilder: (_, e, s) => Container(
                            color: const Color(0xFF1E1E2C),
                            child: const Center(
                              child: FaIcon(
                                FontAwesomeIcons.film,
                                color: Colors.white24,
                                size: 24,
                              ),
                            ),
                          ),
                        ),
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
                              stops: const [0.35, 1.0],
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 6,
                        right: 6,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2.5,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE50914),
                            borderRadius: BorderRadius.circular(6),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(
                                  0xFFE50914,
                                ).withValues(alpha: 0.6),
                                blurRadius: 6,
                              ),
                            ],
                          ),
                          child: Text(
                            item.episode.seasonEpisodeTag.isNotEmpty
                                ? item.episode.seasonEpisodeTag
                                : 'EP ${item.episode.episodeNumber}',
                            style: const TextStyle(
                              fontFamily: AppTextStyles.fontFamily,
                              color: Colors.white,
                              fontSize: 9,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 6,
                        left: 6,
                        child: GestureDetector(
                          onTap: () {
                            HapticFeedback.lightImpact();
                            widget.onDelete();
                          },
                          behavior: HitTestBehavior.opaque,
                          child: Container(
                            width: 26,
                            height: 26,
                            decoration: BoxDecoration(
                              color: Colors.black.withValues(alpha: 0.65),
                              shape: BoxShape.circle,
                            ),
                            child: const Center(
                              child: FaIcon(
                                FontAwesomeIcons.trashCan,
                                color: Color(0xFFB0B0C0),
                                size: 10,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Center(
                        child: Container(
                          width: 34,
                          height: 34,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.black.withValues(alpha: 0.65),
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.35),
                              width: 1.2,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(
                                  0xFFE50914,
                                ).withValues(alpha: 0.4),
                                blurRadius: 10,
                              ),
                            ],
                          ),
                          child: const Center(
                            child: Padding(
                              padding: EdgeInsets.only(left: 2),
                              child: FaIcon(
                                FontAwesomeIcons.play,
                                color: Colors.white,
                                size: 12,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        left: 6,
                        bottom: 6,
                        child: Row(
                          children: [
                            const FaIcon(
                              FontAwesomeIcons.clock,
                              color: Colors.white70,
                              size: 8.5,
                            ),
                            const SizedBox(width: 3),
                            Text(
                              item.playback.formattedRemaining.isNotEmpty
                                  ? item.playback.formattedRemaining
                                  : 'In progress',
                              style: const TextStyle(
                                fontFamily: AppTextStyles.fontFamily,
                                color: Colors.white,
                                fontSize: 9.5,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(9, 8, 9, 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.drama.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontFamily: AppTextStyles.fontFamily,
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '$percent% watched',
                            style: const TextStyle(
                              fontFamily: AppTextStyles.fontFamily,
                              color: Color(0xFF9E9EAE),
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const FaIcon(
                            FontAwesomeIcons.circleChevronRight,
                            color: Color(0xFFE50914),
                            size: 11,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                ClipRRect(
                  child: SizedBox(
                    height: 3,
                    width: double.infinity,
                    child: Stack(
                      children: [
                        Container(color: Colors.white.withValues(alpha: 0.1)),
                        FractionallySizedBox(
                          alignment: Alignment.centerLeft,
                          widthFactor: progress,
                          child: Container(
                            decoration: const BoxDecoration(
                              gradient: LinearGradient(
                                colors: [Color(0xFFFF3B4E), Color(0xFFE50914)],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ListContinueWatchingCard extends StatefulWidget {
  final ContinueWatchingItem item;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const _ListContinueWatchingCard({
    required this.item,
    required this.onTap,
    required this.onDelete,
  });

  @override
  State<_ListContinueWatchingCard> createState() =>
      _ListContinueWatchingCardState();
}

class _ListContinueWatchingCardState extends State<_ListContinueWatchingCard> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final item = widget.item;
    final poster = item.drama.posterUrl.isNotEmpty
        ? item.drama.posterUrl
        : item.drama.bannerUrl;
    final rawProgress = item.playback.progressPercentage;
    final progress = (rawProgress > 1.0 ? rawProgress / 100.0 : rawProgress)
        .clamp(0.0, 1.0);
    final percent = (progress * 100).toInt();

    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        widget.onTap();
      },
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      behavior: HitTestBehavior.opaque,
      child: AnimatedScale(
        scale: _isPressed ? 0.98 : 1.0,
        duration: const Duration(milliseconds: 130),
        curve: Curves.easeOutCubic,
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xFF12121D),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.07),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.45),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(11),
                  child: Row(
                    children: [
                      Container(
                        width: 90,
                        height: 105,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              if (poster.startsWith('http'))
                                Image.network(
                                  poster,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, e, s) => Container(
                                    color: const Color(0xFF1E1E2C),
                                  ),
                                )
                              else
                                Image.asset(
                                  poster,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, e, s) => Container(
                                    color: const Color(0xFF1E1E2C),
                                  ),
                                ),
                              Positioned(
                                top: 5,
                                left: 5,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 5,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFE50914),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: Text(
                                    item.episode.seasonEpisodeTag.isNotEmpty
                                        ? item.episode.seasonEpisodeTag
                                        : 'EP ${item.episode.episodeNumber}',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 8.5,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                ),
                              ),
                              Center(
                                child: Container(
                                  width: 30,
                                  height: 30,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.black.withValues(alpha: 0.65),
                                  ),
                                  child: const Center(
                                    child: Padding(
                                      padding: EdgeInsets.only(left: 2),
                                      child: FaIcon(
                                        FontAwesomeIcons.play,
                                        color: Colors.white,
                                        size: 11,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    item.drama.title,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontFamily: AppTextStyles.fontFamily,
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    HapticFeedback.lightImpact();
                                    widget.onDelete();
                                  },
                                  child: const Padding(
                                    padding: EdgeInsets.all(4),
                                    child: FaIcon(
                                      FontAwesomeIcons.trashCan,
                                      color: Color(0xFF8E8E9F),
                                      size: 12,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Text(
                              item.episode.title.isNotEmpty
                                  ? item.episode.title
                                  : 'Episode ${item.episode.episodeNumber}',
                              style: const TextStyle(
                                fontFamily: AppTextStyles.fontFamily,
                                color: Color(0xFF9E9EAE),
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  item.playback.formattedRemaining.isNotEmpty
                                      ? '${item.playback.formattedRemaining} left'
                                      : 'In progress',
                                  style: const TextStyle(
                                    fontFamily: AppTextStyles.fontFamily,
                                    color: Color(0xFF8E8E9F),
                                    fontSize: 10.5,
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 9,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFE50914),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: const Text(
                                    'Resume',
                                    style: TextStyle(
                                      fontFamily: AppTextStyles.fontFamily,
                                      color: Colors.white,
                                      fontSize: 10.5,
                                      fontWeight: FontWeight.w800,
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
                Container(
                  height: 3,
                  width: double.infinity,
                  color: Colors.white.withValues(alpha: 0.08),
                  child: FractionallySizedBox(
                    alignment: Alignment.centerLeft,
                    widthFactor: progress,
                    child: Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Color(0xFFFF3B4E), Color(0xFFE50914)],
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
    );
  }
}
