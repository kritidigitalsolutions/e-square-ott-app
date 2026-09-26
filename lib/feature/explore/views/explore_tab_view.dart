import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';
import '../../../constants/app_colors.dart';
import '../../../constants/app_text_styles.dart';
import '../../../constants/enum.dart';
import '../../../models/response/admin_content_model.dart';
import '../../../routes/app_pages.dart';
import '../../../shared/service/storage_service.dart';
import '../../../shared/widgets/custom_animation.dart';
import '../../../shared/widgets/custom_bottomsheet.dart';
import '../../../shared/widgets/shimmer_loader.dart';
import '../controller/explore_controller.dart';

class ExploreTabView extends StatelessWidget {
  const ExploreTabView({super.key});

  @override
  Widget build(BuildContext context) {
    // Ensure ExploreController is initialized
    final controller = Get.put(ExploreController());

    return CustomScaffold(
      showAppBar: false,
      safeArea: false,
      backgroundColor: Colors.black,
      body: Obx(() {
        if (controller.exploreStatus.value == Status.loading &&
            controller.exploreList.isEmpty) {
          return const ExploreReelShimmer();
        }

        if (controller.exploreStatus.value == Status.error &&
            controller.exploreList.isEmpty) {
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
                  'Failed to load trailer reels'.tr,
                  style: AppTextStyles.text14Medium.copyWith(
                    color: Colors.white70,
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: controller.fetchExploreDramas,
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

        return PageView.builder(
          controller: controller.pageController,
          scrollDirection: Axis.vertical,
          physics: const BouncingScrollPhysics(),
          onPageChanged: controller.onPageChanged,
          itemCount: controller.exploreList.length,
          itemBuilder: (context, index) {
            final drama = controller.exploreList[index];
            return _ExploreReelCard(drama: drama, index: index);
          },
        );
      }),
    );
  }
}

class _ExploreReelCard extends StatefulWidget {
  final PriorityDrama drama;
  final int index;

  const _ExploreReelCard({required this.drama, required this.index});

  @override
  State<_ExploreReelCard> createState() => _ExploreReelCardState();
}

class _ExploreReelCardState extends State<_ExploreReelCard> {
  final ExploreController controller = Get.find<ExploreController>();
  VideoPlayerController? _videoPlayerController;
  bool _isInitialized = false;
  bool _isPlaying = false;
  bool _showPlayIcon = false;
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    _initVideoIfActive();
  }

  void _initVideoIfActive() async {
    final trailerUrl = widget.drama.trailerUrl.trim();
    if (trailerUrl.isNotEmpty &&
        (trailerUrl.startsWith('http://') ||
            trailerUrl.startsWith('https://'))) {
      VideoFormat? formatHint;
      final lower = trailerUrl.toLowerCase();
      if (lower.contains('.m3u8') ||
          lower.contains('/hls/') ||
          lower.contains('m3u8') ||
          lower.contains('format=m3u8')) {
        formatHint = VideoFormat.hls;
      } else if (lower.contains('.mpd') || lower.contains('/dash/')) {
        formatHint = VideoFormat.dash;
      } else if (lower.contains('.mp4')) {
        formatHint = VideoFormat.other;
      }

      final token = await StorageService.getToken();
      final headers = <String, String>{
        if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
      };

      _videoPlayerController =
          VideoPlayerController.networkUrl(
              Uri.parse(trailerUrl),
              formatHint: formatHint,
              httpHeaders: headers,
              videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true),
            )
            ..initialize()
                .then((_) {
                  if (mounted) {
                    setState(() {
                      _isInitialized = true;
                    });
                    _videoPlayerController?.setLooping(true);
                    _syncPlaybackWithIndex();
                  }
                })
                .catchError((e) {
                  if (formatHint != null) {
                    _retryWithoutFormatHint(trailerUrl);
                  } else {
                    if (mounted) {
                      setState(() {
                        _isInitialized = false;
                      });
                    }
                  }
                });

      _videoPlayerController?.addListener(_onVideoUpdate);
    }
  }

  void _retryWithoutFormatHint(String url) async {
    _videoPlayerController?.removeListener(_onVideoUpdate);
    _videoPlayerController?.dispose();

    final token = await StorageService.getToken();
    final headers = <String, String>{
      if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
    };

    _videoPlayerController =
        VideoPlayerController.networkUrl(
            Uri.parse(url),
            httpHeaders: headers,
            videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true),
          )
          ..initialize()
              .then((_) {
                if (mounted) {
                  setState(() {
                    _isInitialized = true;
                  });
                  _videoPlayerController?.setLooping(true);
                  _syncPlaybackWithIndex();
                }
              })
              .catchError((e) {
                if (mounted) {
                  setState(() {
                    _isInitialized = false;
                  });
                }
              });

    _videoPlayerController?.addListener(_onVideoUpdate);
  }

  void _onVideoUpdate() {
    if (mounted && _videoPlayerController != null) {
      final playing = _videoPlayerController!.value.isPlaying;
      if (playing != _isPlaying) {
        setState(() {
          _isPlaying = playing;
        });
      }
    }
  }

  void _syncPlaybackWithIndex() {
    if (_videoPlayerController == null || !_isInitialized) return;
    final isActive = controller.currentExploreIndex.value == widget.index;
    if (isActive) {
      _videoPlayerController?.setVolume(controller.isMuted.value ? 0.0 : 1.0);
      _videoPlayerController?.play();
    } else {
      _videoPlayerController?.pause();
      _videoPlayerController?.seekTo(Duration.zero);
    }
  }

  @override
  void didUpdateWidget(covariant _ExploreReelCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    _syncPlaybackWithIndex();
  }

  @override
  void dispose() {
    _videoPlayerController?.removeListener(_onVideoUpdate);
    _videoPlayerController?.dispose();
    super.dispose();
  }

  void _togglePlayPause() {
    if (_videoPlayerController == null || !_isInitialized) return;
    HapticFeedback.lightImpact();
    setState(() {
      if (_videoPlayerController!.value.isPlaying) {
        _videoPlayerController?.pause();
        _showPlayIcon = true;
      } else {
        _videoPlayerController?.play();
        _showPlayIcon = false;
      }
    });

    if (_showPlayIcon) {
      Future.delayed(const Duration(milliseconds: 900), () {
        if (mounted) setState(() => _showPlayIcon = false);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final drama = widget.drama;
    final String posterUrl = drama.posterUrl.isNotEmpty
        ? drama.posterUrl
        : drama.bannerUrl;

    return Obx(() {
      // Listen to current page & mute changes
      final isActive = controller.currentExploreIndex.value == widget.index;
      if (isActive && _isInitialized && _videoPlayerController != null) {
        _videoPlayerController!.setVolume(controller.isMuted.value ? 0.0 : 1.0);
        if (!_videoPlayerController!.value.isPlaying && !_showPlayIcon) {
          _videoPlayerController!.play();
        }
      } else if (!isActive &&
          _isInitialized &&
          _videoPlayerController != null) {
        if (_videoPlayerController!.value.isPlaying) {
          _videoPlayerController!.pause();
        }
      }

      return GestureDetector(
        onTap: _togglePlayPause,
        behavior: HitTestBehavior.opaque,
        child: Stack(
          fit: StackFit.expand,
          children: [
            // ── 1. Video Player or Poster Backdrop
            if (_isInitialized && _videoPlayerController != null)
              SizedBox.expand(
                child: FittedBox(
                  fit: BoxFit.cover,
                  child: SizedBox(
                    width: _videoPlayerController!.value.size.width,
                    height: _videoPlayerController!.value.size.height,
                    child: VideoPlayer(_videoPlayerController!),
                  ),
                ),
              )
            else
              Image.network(
                posterUrl,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
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

            // ── 2. Cinematic Gradient Overlays
            Positioned.fill(
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(0x77000000),
                      Colors.transparent,
                      Color(0x99000000),
                      Color(0xFA000000),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    stops: [0.0, 0.35, 0.65, 1.0],
                  ),
                ),
              ),
            ),

            // ── 3. Animated Play/Pause Center Indicator
            if (_showPlayIcon || (!_isPlaying && _isInitialized))
              Center(
                child: AnimatedOpacity(
                  opacity: 0.9,
                  duration: const Duration(milliseconds: 200),
                  child: Container(
                    width: 65,
                    height: 65,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.black.withValues(alpha: 0.6),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.3),
                        width: 1.5,
                      ),
                    ),
                    child: Center(
                      child: FaIcon(
                        _isPlaying
                            ? FontAwesomeIcons.pause
                            : FontAwesomeIcons.play,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                  ),
                ),
              ),

            // ── 4. Right Floating Action Column (Reels Sidebar)
            Positioned(
              right: 14,
              bottom: 110,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Mute / Unmute Button
                  _buildFloatingAction(
                    icon: controller.isMuted.value
                        ? FontAwesomeIcons.volumeXmark
                        : FontAwesomeIcons.volumeHigh,
                    label: controller.isMuted.value ? 'Muted' : 'Sound',
                    onTap: controller.toggleMute,
                  ),
                  const SizedBox(height: 18),

                  // Episodes Drawer Button
                  _buildFloatingAction(
                    icon: FontAwesomeIcons.layerGroup,
                    label: 'Episodes',
                    onTap: () => _openEpisodesSheet(context, drama),
                  ),
                  const SizedBox(height: 18),

                  // Watchlist (+ My List) Button
                  Obx(() {
                    final isInList = controller.isDramaInMyList(drama.id);
                    return _buildFloatingAction(
                      icon: isInList
                          ? FontAwesomeIcons.check
                          : FontAwesomeIcons.plus,
                      label: 'My List',
                      iconColor: isInList ? AppColors.primary : Colors.white,
                      onTap: () => controller.toggleMyList(drama),
                    );
                  }),
                ],
              ),
            ),

            // ── 6. Bottom Information Overlay
            Positioned(
              left: 18,
              right: 80,
              bottom: 28,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Tag: TRAILER PREVIEW
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 7,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      gradient: AppColors.primaryGradient,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: const Text(
                      'TRAILER PREVIEW',
                      style: TextStyle(
                        fontFamily: AppTextStyles.fontFamily,
                        fontSize: 9.5,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF0C0B10),
                        letterSpacing: 1.1,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Title
                  Text(
                    drama.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.text22Bold.copyWith(
                      color: Colors.white,
                      height: 1.15,
                      shadows: [
                        const Shadow(color: Colors.black, blurRadius: 10),
                      ],
                    ),
                  ),
                  const SizedBox(height: 4),

                  // Genre & Views
                  Text(
                    [
                      if (drama.genreDisplay.isNotEmpty) drama.genreDisplay,
                      if (drama.viewsFormatted.isNotEmpty)
                        '${drama.viewsFormatted} plays',
                      if (drama.rating > 0)
                        '★ ${drama.rating.toStringAsFixed(1)}',
                    ].join(' • '),
                    style: AppTextStyles.text12Medium.copyWith(
                      color: const Color(0xFFB0B0C0),
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Synopsis with expand/collapse
                  if (drama.synopsis.isNotEmpty) ...[
                    GestureDetector(
                      onTap: () => setState(() => _isExpanded = !_isExpanded),
                      child: Text(
                        drama.synopsis,
                        maxLines: _isExpanded ? 6 : 2,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.text13.copyWith(
                          color: const Color(0xFFCCCCCC),
                          height: 1.4,
                          shadows: [
                            const Shadow(color: Colors.black87, blurRadius: 6),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),
                  ],

                  // ── Action Buttons Row
                  Row(
                    children: [
                      // Watch Now CTA Button
                      GestureDetector(
                        onTap: () => controller.watchNow(drama),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 18,
                            vertical: 11,
                          ),
                          decoration: BoxDecoration(
                            gradient: AppColors.primaryGradient,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.primary.withValues(
                                  alpha: 0.45,
                                ),
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
                                size: 13,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Watch Series'.tr,
                                style: AppTextStyles.text13Bold.copyWith(
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),

                      // Quick Episodes CTA
                      GestureDetector(
                        onTap: () => _openEpisodesSheet(context, drama),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 11,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(
                              0xFF181822,
                            ).withValues(alpha: 0.88),
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
                                size: 13,
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
                    ],
                  ),
                ],
              ),
            ),

            // ── 7. Slim Video Progress Bar at Very Bottom
            if (_isInitialized && _videoPlayerController != null)
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: VideoProgressIndicator(
                  _videoPlayerController!,
                  allowScrubbing: true,
                  colors: const VideoProgressColors(
                    playedColor: AppColors.primary,
                    bufferedColor: Colors.white24,
                    backgroundColor: Colors.transparent,
                  ),
                ),
              ),
          ],
        ),
      );
    });
  }

  Widget _buildFloatingAction({
    required FaIconData icon,
    required String label,
    required VoidCallback onTap,
    Color iconColor = Colors.white,
  }) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        onTap();
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFF14141E).withValues(alpha: 0.75),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.12),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.4),
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Center(child: FaIcon(icon, color: iconColor, size: 19)),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              fontFamily: AppTextStyles.fontFamily,
              color: Colors.white,
              fontSize: 10.5,
              fontWeight: FontWeight.w600,
              shadows: [Shadow(color: Colors.black, blurRadius: 4)],
            ),
          ),
        ],
      ),
    );
  }

  // ── Episodes Bottom Sheet for Reel/Explore View with Real API Data
  void _openEpisodesSheet(BuildContext context, PriorityDrama drama) {
    controller.fetchEpisodesForDrama(drama.id);

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
          child: Obx(() {
            final drawerResponse = controller.episodesCache[drama.id];
            final episodes = drawerResponse?.data.episodes ?? [];
            final isLoading = controller.isLoadingEpisodes.value;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header: "Episodes · N" + "Close"
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Episodes ${episodes.isNotEmpty ? '· ${episodes.length}' : ''}',
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

                // List of episodes or Loading
                Expanded(
                  child: isLoading
                      ? const Center(
                          child: CircularProgressIndicator(
                            color: AppColors.primary,
                          ),
                        )
                      : episodes.isEmpty
                      ? Center(
                          child: Text(
                            'No episodes available for this drama yet'.tr,
                            style: const TextStyle(
                              color: Color(0xFF8E8E9E),
                              fontSize: 14,
                            ),
                          ),
                        )
                      : ListView.separated(
                          physics: const BouncingScrollPhysics(),
                          itemCount: episodes.length,
                          separatorBuilder: (_, __) => const Divider(
                            height: 18,
                            color: Color(0xFF242432),
                          ),
                          itemBuilder: (context, index) {
                            final ep = episodes[index];
                            final isCurrent = index == 0;
                            final isLocked = ep.isVip;

                            return InkWell(
                              onTap: () {
                                Navigator.pop(context);
                                Get.toNamed(
                                  Routes.dramaPlayer,
                                  arguments: {
                                    'id': drama.id,
                                    'title': drama.title,
                                    'description': drama.synopsis,
                                    'image': ep.thumbnailUrl.isNotEmpty
                                        ? ep.thumbnailUrl
                                        : drama.posterUrl,
                                    'initialEpisodeIndex': index,
                                  },
                                );
                              },
                              borderRadius: BorderRadius.circular(10),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 4,
                                ),
                                child: Row(
                                  children: [
                                    // Episode Thumbnail
                                    Container(
                                      width: 64,
                                      height: 64,
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
                                            Image.network(
                                              ep.thumbnailUrl.isNotEmpty
                                                  ? ep.thumbnailUrl
                                                  : drama.posterUrl,
                                              fit: BoxFit.cover,
                                              errorBuilder: (_, __, ___) =>
                                                  Container(
                                                    color: const Color(
                                                      0xFF22222E,
                                                    ),
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
                                                  color: Colors.black
                                                      .withValues(alpha: 0.55),
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

                                    // Episode Title & Tag
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            ep.title.isNotEmpty
                                                ? ep.title
                                                : 'Episode ${ep.episodeNumber}',
                                            style: TextStyle(
                                              fontFamily:
                                                  AppTextStyles.fontFamily,
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
                                            [
                                              if (ep
                                                  .durationFormatted
                                                  .isNotEmpty)
                                                ep.durationFormatted,
                                              if (ep.accessType.isNotEmpty)
                                                ep.accessType.toUpperCase(),
                                            ].join(' · '),
                                            style: const TextStyle(
                                              fontFamily:
                                                  AppTextStyles.fontFamily,
                                              color: Color(0xFF8E8E9E),
                                              fontSize: 12,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),

                                    // VIP Lock Icon
                                    if (isLocked)
                                      Container(
                                        padding: const EdgeInsets.all(6),
                                        decoration: BoxDecoration(
                                          color: Colors.black.withValues(
                                            alpha: 0.6,
                                          ),
                                          shape: BoxShape.circle,
                                        ),
                                        child: const FaIcon(
                                          FontAwesomeIcons.lock,
                                          color: Color(0xFFFFD700),
                                          size: 12,
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }
}
