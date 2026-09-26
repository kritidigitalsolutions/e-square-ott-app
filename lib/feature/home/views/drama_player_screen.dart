import 'dart:math';
import 'dart:ui';
import 'package:e_square_ott_app/feature/home/datasource/home_datasource.dart';
import 'package:e_square_ott_app/models/response/home_screen_model.dart';
import 'package:e_square_ott_app/models/response/home_section_model.dart'
    as section_model;
import 'package:e_square_ott_app/models/response/saved_series_response.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';
import '../../../constants/app_colors.dart';
import '../../../constants/app_images.dart';
import '../../../constants/app_text_styles.dart';
import '../../../routes/app_pages.dart';
import 'package:e_square_ott_app/shared/widgets/custom_animation.dart';
import '../../../shared/widgets/custom_bottomsheet.dart';
import '../../../shared/widgets/custom_buttons.dart';
import '../../../shared/widgets/custom_sncakbar.dart';
import '../../subscription/controller/subscription_controller.dart';
import '../../../models/response/admin_content_model.dart';
import '../../../models/response/countinue_watching_model.dart';
import '../../../models/response/drama_response.dart';
import '../../../models/response/search_discorvey_model.dart';
import '../../../models/response/search_suggestion_response.dart';
import '../../../shared/service/storage_service.dart';
import '../../../shared/widgets/shimmer_loader.dart';
import '../datasource/search.dart';
import '../controller/search_tab_controller.dart';
import '../controller/whislist_controller.dart';

class DramaPlayerScreen extends StatefulWidget {
  const DramaPlayerScreen({super.key});

  @override
  State<DramaPlayerScreen> createState() => _DramaPlayerScreenState();
}

class _DramaPlayerScreenState extends State<DramaPlayerScreen> {
  late final PageController _pageController;
  int _currentEpisodeIndex = 0;

  // Drama Details from arguments or default fallback
  String _seriesTitle = 'Drama';
  String _dramaDescription = '';
  String _backdropImage = AppImages.banner1;
  String _videoUrl = '';
  String _dramaId = '';

  // Video Player Controller & State
  VideoPlayerController? _videoPlayerController;
  bool _isInitialized = false;
  bool _isPlaying = false;
  bool _showPlayCenterIcon = false;
  Duration _currentPosition = Duration.zero;
  Duration _totalDuration = Duration.zero;

  // Series Completion & Interaction State
  bool _isInMyList = false;
  bool _isLiked = false;

  // Real Recommendations from Search Landing API
  List<RecommendedDrama> _recommendedDramas = [];

  // Playback Settings State
  String _selectedSubtitle = 'Hindi';
  String _selectedQuality = 'Auto';
  String _selectedSpeed = '1x';

  // Dynamic Episodes fetched from Backend API
  List<Map<String, dynamic>> _episodes = [];
  bool _isLoadingEpisodes = false;

  @override
  void initState() {
    super.initState();
    int initialIndex = 0;

    // Extract arguments from Get.arguments
    final args = Get.arguments;
    if (args is PopularSearch) {
      _dramaId = args.id;
      _seriesTitle = args.title;
      _dramaDescription = args.genreDisplay.isNotEmpty
          ? args.genreDisplay
          : 'Rating: ${args.rating} · ${args.viewsFormatted} plays';
      _backdropImage = args.posterUrl;
    } else if (args is RecommendedDrama) {
      _dramaId = args.id;
      _seriesTitle = args.title;
      _dramaDescription = args.synopsis.isNotEmpty
          ? args.synopsis
          : (args.genreDisplay.isNotEmpty
                ? args.genreDisplay
                : 'Rating: ${args.rating}');
      _backdropImage = args.posterUrl.isNotEmpty
          ? args.posterUrl
          : args.bannerUrl;
    } else if (args is SearchSuggestion) {
      _dramaId = args.id;
      _seriesTitle = args.title;
      _dramaDescription = args.viewsFormatted;
      _backdropImage = args.posterUrl;
    } else if (args is SearchDrama) {
      _dramaId = args.id;
      _seriesTitle = args.title;
      _dramaDescription = args.slug;
      _backdropImage = args.posterUrl;
    } else if (args is Drama) {
      _dramaId = args.id;
      _seriesTitle = args.title;
      _dramaDescription = args.synopsis;
      _backdropImage = args.posterUrl.isNotEmpty
          ? args.posterUrl
          : args.bannerUrl;
    } else if (args is section_model.Drama) {
      _dramaId = args.id.isNotEmpty ? args.id : args.mongoId;
      _seriesTitle = args.title.isNotEmpty ? args.title : args.name;
      _dramaDescription = args.synopsis.isNotEmpty
          ? args.synopsis
          : (args.description.isNotEmpty
              ? args.description
              : args.genreDisplay);
      _backdropImage = args.posterUrl.isNotEmpty
          ? args.posterUrl
          : (args.bannerUrl.isNotEmpty
              ? args.bannerUrl
              : (args.thumbnailUrl.isNotEmpty
                  ? args.thumbnailUrl
                  : AppImages.banner1));
    } else if (args is PriorityDrama) {
      _dramaId = args.id;
      _seriesTitle = args.title;
      _dramaDescription = args.synopsis.isNotEmpty
          ? args.synopsis
          : (args.genreDisplay.isNotEmpty
                ? args.genreDisplay
                : 'Rating: ${args.rating}');
      _backdropImage = args.posterUrl.isNotEmpty
          ? args.posterUrl
          : args.bannerUrl;
    } else if (args is ContinueWatchingItem) {
      _dramaId = args.drama.id;
      _seriesTitle = args.drama.title;
      _dramaDescription = args.drama.genreDisplay;
      _backdropImage = args.drama.posterUrl.isNotEmpty
          ? args.drama.posterUrl
          : args.drama.bannerUrl;
      if (args.episode.episodeNumber > 0) {
        initialIndex = (args.episode.episodeNumber - 1);
      }
    } else if (args is HomeBanner) {
      _dramaId = args.dramaId.isNotEmpty ? args.dramaId : args.id;
      _seriesTitle = args.title;
      _dramaDescription = args.synopsis.isNotEmpty
          ? args.synopsis
          : (args.tagline.isNotEmpty ? args.tagline : args.genreDisplay);
      _backdropImage = args.bannerUrl.isNotEmpty
          ? args.bannerUrl
          : (args.posterUrl.isNotEmpty ? args.posterUrl : AppImages.banner1);
      if (args.cta.episodeNumber > 0) {
        initialIndex = (args.cta.episodeNumber - 1);
      }
    } else if (args is SavedSeries) {
      _dramaId = args.drama.id;
      _seriesTitle = args.drama.title;
      _dramaDescription = args.drama.synopsis.isNotEmpty
          ? args.drama.synopsis
          : args.drama.genreDisplay;
      _backdropImage = args.drama.posterUrl.isNotEmpty
          ? args.drama.posterUrl
          : (args.drama.bannerUrl.isNotEmpty
                ? args.drama.bannerUrl
                : AppImages.banner1);
      if (args.watchProgress != null &&
          args.watchProgress!.resumeEpisodeNumber > 0) {
        initialIndex = (args.watchProgress!.resumeEpisodeNumber - 1);
      }
    } else if (args is SavedDrama) {
      _dramaId = args.id;
      _seriesTitle = args.title;
      _dramaDescription = args.synopsis.isNotEmpty
          ? args.synopsis
          : args.genreDisplay;
      _backdropImage = args.posterUrl.isNotEmpty
          ? args.posterUrl
          : (args.bannerUrl.isNotEmpty ? args.bannerUrl : AppImages.banner1);
    } else if (args is ContinueWatchingDrama) {
      _dramaId = args.id;
      _seriesTitle = args.title;
      _dramaDescription = args.genreDisplay;
      _backdropImage = args.posterUrl.isNotEmpty
          ? args.posterUrl
          : args.bannerUrl;
    } else if (args is Map<String, dynamic>) {
      _dramaId = args['id'] ?? '';
      _seriesTitle = args['title'] ?? 'If this is Love,\nLet me burn';
      _dramaDescription =
          args['description'] ??
          'He finally discovers the truth. But the promise he made could cost him everything.';
      _backdropImage = args['image'] ?? AppImages.banner1;
      _videoUrl =
          args['videoUrl'] ?? args['streamUrl'] ?? '';
      if (args['initialEpisodeIndex'] != null) {
        initialIndex = (args['initialEpisodeIndex'] as int);
      }
    } else {
      _seriesTitle = 'If this is Love,\nLet me burn';
      _dramaDescription =
          'He finally discovers the truth. But the promise he made could cost him everything.';
      _backdropImage = AppImages.banner1;
    }

    if (Get.isRegistered<WhislistController>()) {
      _isInMyList = Get.find<WhislistController>().isDramaSaved(_dramaId);
    } else {
      final wCtrl = Get.put(WhislistController());
      _isInMyList = wCtrl.isDramaSaved(_dramaId);
    }

    _currentEpisodeIndex = initialIndex;
    _pageController = PageController(initialPage: initialIndex);
    _loadRecommendations();
    _fetchEpisodes(initialIndex);
  }

  void _fetchEpisodes(int initialIndex) async {
    if (_dramaId.isEmpty) return;
    setState(() {
      _isLoadingEpisodes = true;
    });
    try {
      final res = await HomeDatasource().allEpisode(
        dramaId: _dramaId,
        pageNo: 1,
        limit: 100,
      );
      if (res != null && res.data.episodes.isNotEmpty && mounted) {
        setState(() {
          _episodes = res.data.episodes.map((ep) {
            return {
              'id': ep.id,
              'episodeNumber': ep.seasonEpisodeTag.isNotEmpty
                  ? ep.seasonEpisodeTag
                  : 'S1 · E${ep.episodeNumber.toString().padLeft(2, '0')}',
              'rawEpisodeNumber': ep.episodeNumber,
              'title': ep.title.isNotEmpty
                  ? ep.title
                  : 'Episode ${ep.episodeNumber}',
              'duration': ep.formattedDuration.isNotEmpty
                  ? ep.formattedDuration
                  : '2:00',
              'currentTime': '0:00',
              'totalTime': ep.formattedDuration.isNotEmpty
                  ? ep.formattedDuration
                  : '2:00',
              'progress': 0.0,
              'status': ep.isLocked
                  ? 'Locked'
                  : (ep.watched == true ? 'Watched' : 'Unwatched'),
              'isLocked': ep.isLocked,
              'isFree': ep.isFree,
              'hasAccess': ep.hasAccess,
              'thumbnailUrl': ep.thumbnailUrl,
              'videoUrl': ep.videoUrl,
            };
          }).toList();
        });
        if (_episodes.isNotEmpty) {
          final targetIndex = initialIndex.clamp(0, _episodes.length - 1);
          _currentEpisodeIndex = targetIndex;
          if (_pageController.hasClients) {
            _pageController.jumpToPage(targetIndex);
          }
          _initEpisodeVideo(targetIndex);
        }
      }
    } catch (e) {
      print("[DramaPlayerScreen] _fetchEpisodes error: $e");
    } finally {
      if (mounted) {
        setState(() {
          _isLoadingEpisodes = false;
        });
      }
    }
  }

  void _loadRecommendations() async {
    if (Get.isRegistered<SearchTabController>()) {
      final searchCtrl = Get.find<SearchTabController>();
      if (searchCtrl.recommendedDramas.isNotEmpty) {
        if (mounted) {
          setState(() {
            _recommendedDramas = searchCtrl.recommendedDramas;
          });
        }
        return;
      }
    }

    try {
      final res = await SearchDatasource().searchDiscovery();
      if (res != null && res.data.recommendedForYou.isNotEmpty) {
        if (mounted) {
          setState(() {
            _recommendedDramas = res.data.recommendedForYou;
          });
        }
      }
    } catch (_) {}
  }

  void _initEpisodeVideo(int index) async {
    _videoPlayerController?.removeListener(_onVideoUpdate);
    _videoPlayerController?.dispose();
    _videoPlayerController = null;
    _isInitialized = false;
    _isPlaying = false;

    if (_episodes.isEmpty || index >= _episodes.length) {
      if (mounted) setState(() {});
      return;
    }

    final ep = _episodes[index];
    String rawUrl = (ep['videoUrl'] ?? _videoUrl).toString().trim();

    // If videoUrl not directly in episode list, fetch from episode access
    if (rawUrl.isEmpty && _dramaId.isNotEmpty) {
      try {
        final epNum = ep['rawEpisodeNumber'] ?? (index + 1);
        final accessRes = await HomeDatasource().episodeAccess(
          id: _dramaId,
          episodeId: epNum is int ? epNum : int.tryParse(epNum.toString()) ?? (index + 1),
        );
        if (accessRes != null && accessRes.data.episode.videoUrl.isNotEmpty) {
          rawUrl = accessRes.data.episode.videoUrl.trim();
          ep['videoUrl'] = rawUrl;
        }
      } catch (e) {
        print("[DramaPlayerScreen] episodeAccess error: $e");
      }
    }

    if (rawUrl.isEmpty ||
        (!rawUrl.startsWith('http://') && !rawUrl.startsWith('https://'))) {
      if (mounted) {
        setState(() {
          _isInitialized = false;
        });
      }
      return;
    }

    VideoFormat? formatHint;
    final lower = rawUrl.toLowerCase();
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
            Uri.parse(rawUrl),
            formatHint: formatHint,
            httpHeaders: headers,
            videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true),
          )
          ..initialize()
              .then((_) {
                if (mounted) {
                  setState(() {
                    _isInitialized = true;
                    _totalDuration =
                        _videoPlayerController?.value.duration ?? Duration.zero;
                  });
                  _videoPlayerController?.setLooping(false);
                  _applyCurrentSpeed();
                  _videoPlayerController?.play();
                }
              })
              .catchError((e) {
                if (formatHint != null) {
                  _retryEpisodeWithoutFormatHint(rawUrl);
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

  void _retryEpisodeWithoutFormatHint(String url) async {
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
                    _totalDuration =
                        _videoPlayerController?.value.duration ?? Duration.zero;
                  });
                  _videoPlayerController?.setLooping(false);
                  _applyCurrentSpeed();
                  _videoPlayerController?.play();
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
      final val = _videoPlayerController!.value;
      final playing = val.isPlaying;
      final pos = val.position;
      final dur = val.duration;
      if (playing != _isPlaying ||
          pos.inSeconds != _currentPosition.inSeconds) {
        setState(() {
          _isPlaying = playing;
          _currentPosition = pos;
          if (dur > Duration.zero) _totalDuration = dur;
        });
      }
      if (val.isInitialized &&
          dur > Duration.zero &&
          pos >= dur &&
          !_videoPlayerController!.value.isLooping) {
        _onVideoCompleted();
      }
    }
  }

  void _onVideoCompleted() {
    if (_currentEpisodeIndex < _episodes.length) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
      );
    }
  }

  void _togglePlayPause() {
    if (_videoPlayerController == null || !_isInitialized) return;
    HapticFeedback.lightImpact();
    setState(() {
      if (_videoPlayerController!.value.isPlaying) {
        _videoPlayerController?.pause();
        _showPlayCenterIcon = true;
      } else {
        _videoPlayerController?.play();
        _showPlayCenterIcon = false;
      }
    });

    if (_showPlayCenterIcon) {
      Future.delayed(const Duration(milliseconds: 900), () {
        if (mounted) setState(() => _showPlayCenterIcon = false);
      });
    }
  }

  void _applyCurrentSpeed() {
    double speed = 1.0;
    if (_selectedSpeed == '0.75x')
      speed = 0.75;
    else if (_selectedSpeed == '1x')
      speed = 1.0;
    else if (_selectedSpeed == '1.25x')
      speed = 1.25;
    else if (_selectedSpeed == '1.5x')
      speed = 1.5;
    else if (_selectedSpeed == '2x')
      speed = 2.0;
    _videoPlayerController?.setPlaybackSpeed(speed);
  }

  String _formatDuration(Duration d) {
    final minutes = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    if (d.inHours > 0) {
      return '${d.inHours}:$minutes:$seconds';
    }
    return '$minutes:$seconds';
  }

  Widget _buildBackdropWidget({BoxFit fit = BoxFit.cover}) {
    if (_backdropImage.startsWith('http://') ||
        _backdropImage.startsWith('https://')) {
      return Image.network(
        _backdropImage,
        fit: fit,
        errorBuilder: (_, __, ___) => Container(color: const Color(0xFF14141A)),
      );
    }
    return Image.asset(
      _backdropImage,
      fit: fit,
      errorBuilder: (_, __, ___) => Container(color: const Color(0xFF14141A)),
    );
  }

  @override
  void dispose() {
    _videoPlayerController?.removeListener(_onVideoUpdate);
    _videoPlayerController?.dispose();
    _pageController.dispose();
    super.dispose();
  }

  void _toggleMyList() async {
    HapticFeedback.lightImpact();
    if (_dramaId.isNotEmpty) {
      final whislistController = Get.isRegistered<WhislistController>()
          ? Get.find<WhislistController>()
          : Get.put(WhislistController());
      final res = await whislistController.toggleSavedSeries(dramaId: _dramaId);
      if (mounted && res != null && res.success) {
        setState(() {
          _isInMyList = res.data.isSaved;
        });
      }
    } else {
      setState(() {
        _isInMyList = !_isInMyList;
      });
    }
  }

  void _toggleRate() {
    setState(() {
      _isLiked = !_isLiked;
    });
    if (_isLiked) {
      AppSnackbar.success(
        'Thank you for liking this drama!',
        title: 'Rated Drama',
      );
    } else {
      AppSnackbar.info(
        'Your rating has been updated.',
        title: 'Rating Removed',
      );
    }
  }

  void _shareDrama() {
    AppSnackbar.info(
      'Sharing link for $_seriesTitle copied to clipboard!',
      title: 'Share Drama',
    );
  }

  // ── Open Playback Settings Sheet (Subtitles, Quality, Speed)
  void _openPlaybackSettings() {
    CustomBottomSheet.show(
      context: context,
      child: StatefulBuilder(
        builder: (context, setSheetState) {
          return Container(
            decoration: const BoxDecoration(
              color: Color(0xFF16161F),
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
            child: SafeArea(
              top: false,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header: "Playback Settings" + "Close"
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Playback Settings',
                        style: TextStyle(
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
                  const SizedBox(height: 24),

                  // ── Subtitles
                  _buildSettingOptionRow(
                    title: 'Subtitles',
                    options: const ['Hindi', 'English', 'Off'],
                    selectedValue: _selectedSubtitle,
                    onSelect: (val) {
                      setSheetState(() => _selectedSubtitle = val);
                      setState(() => _selectedSubtitle = val);
                    },
                  ),
                  const Divider(height: 28, color: Color(0xFF282836)),

                  // ── Quality
                  _buildSettingOptionRow(
                    title: 'Quality',
                    options: const ['Auto', '1080p', '720p'],
                    selectedValue: _selectedQuality,
                    onSelect: (val) {
                      setSheetState(() => _selectedQuality = val);
                      setState(() => _selectedQuality = val);
                    },
                  ),
                  const Divider(height: 28, color: Color(0xFF282836)),

                  // ── Playback Speed
                  _buildSettingOptionRow(
                    title: 'Playback Speed',
                    options: const ['0.75x', '1x', '1.25x', '1.5x'],
                    selectedValue: _selectedSpeed,
                    onSelect: (val) {
                      setSheetState(() => _selectedSpeed = val);
                      setState(() {
                        _selectedSpeed = val;
                        _applyCurrentSpeed();
                      });
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSettingOptionRow({
    required String title,
    required List<String> options,
    required String selectedValue,
    required ValueChanged<String> onSelect,
  }) {
    return Row(
      children: [
        SizedBox(
          width: 110,
          child: Text(
            title,
            style: const TextStyle(
              fontFamily: AppTextStyles.fontFamily,
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Expanded(
          child: Wrap(
            spacing: 8,
            children: options.map((option) {
              final isSelected = option == selectedValue;
              return GestureDetector(
                onTap: () => onSelect(option),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? const Color(0xFF381014)
                        : const Color(0xFF20202C),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: isSelected
                          ? const Color(0xFFE42429)
                          : const Color(0xFF2E2E3E),
                      width: 1.0,
                    ),
                  ),
                  child: Text(
                    option,
                    style: TextStyle(
                      fontFamily: AppTextStyles.fontFamily,
                      color: isSelected
                          ? Colors.white
                          : const Color(0xFFA0A0B0),
                      fontSize: 12.5,
                      fontWeight: isSelected
                          ? FontWeight.w700
                          : FontWeight.w500,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  // ── Open Episodes Bottom Sheet (matching screenshot exactly)
  void _openEpisodesSheet() {
    final subController = Get.find<SubscriptionController>();
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
                    'Episodes · ${_episodes.length}',
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
                  final isSubscribed = subController.isSubscribed.value;

                  if (_episodes.isEmpty) {
                    return Center(
                      child: Text(
                        'No episodes available'.tr,
                        style: const TextStyle(
                          color: Colors.white54,
                          fontFamily: AppTextStyles.fontFamily,
                          fontSize: 14,
                        ),
                      ),
                    );
                  }

                  return ListView.separated(
                    physics: const BouncingScrollPhysics(),
                    itemCount: _episodes.length,
                    separatorBuilder: (_, __) =>
                        const Divider(height: 18, color: Color(0xFF242432)),
                    itemBuilder: (context, index) {
                      final ep = _episodes[index];
                      final isCurrent = index == _currentEpisodeIndex;
                      final isLocked = !isSubscribed && index >= 3;

                      return InkWell(
                        onTap: () {
                          Navigator.pop(context);
                          if (_currentEpisodeIndex != index) {
                            _pageController.animateToPage(
                              index,
                              duration: const Duration(milliseconds: 350),
                              curve: Curves.easeInOut,
                            );
                          }
                        },
                        borderRadius: BorderRadius.circular(10),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Row(
                            children: [
                              // Episode Thumbnail with Play icon overlay and Red border if active
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
                                      _buildBackdropWidget(),
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
                                      ep['title']?.toString() ??
                                          'Episode ${index + 1}',
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
                                          ? '${ep['totalTime'] ?? ep['duration'] ?? '2:00'} · Now Playing'
                                          : '${ep['duration'] ?? '2:00'} · ${isLocked ? 'Locked' : 'Watched'}',
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

  @override
  Widget build(BuildContext context) {
    final subController = Get.find<SubscriptionController>();

    return CustomScaffold(
      showAppBar: false,
      safeArea: false,
      backgroundColor: Colors.black,
      body: Obx(() {
        final isSubscribed = subController.isSubscribed.value;

        if (_isLoadingEpisodes && _episodes.isEmpty && !_isInitialized) {
          return const DramaPlayerShimmer();
        }

        if (!_isLoadingEpisodes && _episodes.isEmpty) {
          return _buildNoEpisodesView();
        }

        return PageView.builder(
          controller: _pageController,
          scrollDirection: Axis.vertical,
          physics: const BouncingScrollPhysics(),
          onPageChanged: (index) {
            setState(() {
              _currentEpisodeIndex = index;
            });
            if (_episodes.isNotEmpty && index < _episodes.length) {
              _initEpisodeVideo(index);
            } else if (_episodes.isEmpty) {
              _initEpisodeVideo(0);
            } else {
              _videoPlayerController?.pause();
            }
          },
          itemCount: _episodes.isNotEmpty ? _episodes.length + 1 : 1,
          itemBuilder: (context, index) {
            if (_episodes.isEmpty) {
              return _buildUnlockedEpisodeView({}, 0);
            }

            // End of series / completed page
            if (index == _episodes.length) {
              return _buildSeriesCompletedView();
            }

            final ep = _episodes[index];
            final isLocked =
                !isSubscribed && (ep['isLocked'] == true || index >= 3);

            if (isLocked) {
              return _buildLockedEpisodeView(ep, index);
            }

            return _buildUnlockedEpisodeView(ep, index);
          },
        );
      }),
    );
  }

  // ── 0. Empty State View when no episodes are available
  Widget _buildNoEpisodesView() {
    return Stack(
      fit: StackFit.expand,
      children: [
        // Blurred Backdrop Image
        _buildBackdropWidget(),

        // Dark Blur Filter & Dark Overlay
        BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.black.withValues(alpha: 0.85),
                  Colors.black.withValues(alpha: 0.92),
                  Colors.black.withValues(alpha: 0.98),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: const [0.0, 0.5, 1.0],
              ),
            ),
          ),
        ),

        // Content
        SafeArea(
          child: Column(
            children: [
              // Top Bar with Back Button
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                child: Row(
                  children: [
                    CustomBackButton(onTap: () => Get.back()),
                  ],
                ),
              ),

              const Spacer(),

              // Center Empty State Box
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 28),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: const Color(0xFF1E1E2A),
                        border: Border.all(
                          color: const Color(0xFF323246),
                          width: 1.5,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.4),
                            blurRadius: 20,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: const Center(
                        child: FaIcon(
                          FontAwesomeIcons.film,
                          color: Color(0xFF8E8E9E),
                          size: 28,
                        ),
                      ),
                    ),
                    const SizedBox(height: 22),

                    Text(
                      'No episodes available right now'.tr,
                      style: const TextStyle(
                        fontFamily: AppTextStyles.fontFamily,
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.2,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 10),

                    Text(
                      'Episodes for this drama are currently being prepared or updated. Please check back later.'
                          .tr,
                      style: const TextStyle(
                        fontFamily: AppTextStyles.fontFamily,
                        color: Color(0xFF8E8E9E),
                        fontSize: 13.5,
                        fontWeight: FontWeight.w400,
                        height: 1.45,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 28),

                    // Primary Button: "Go Back"
                    AppButton(
                      label: 'Go Back'.tr,
                      onPressed: () => Get.back(),
                      backgroundColor: AppColors.primary,
                      height: 48,
                      borderRadius: 12,
                    ),
                  ],
                ),
              ),

              const Spacer(flex: 2),
            ],
          ),
        ),
      ],
    );
  }

  // ── 1. Unlocked Episode View (Reel Screen matching Screenshot 1 Left)
  Widget _buildUnlockedEpisodeView(Map<String, dynamic> ep, int index) {
    return GestureDetector(
      onTap: _togglePlayPause,
      behavior: HitTestBehavior.opaque,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Video Player or Backdrop Image
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
            _buildBackdropWidget(),

          // Gradient Vignette Overlay
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.black.withValues(alpha: 0.65),
                    Colors.transparent,
                    Colors.black.withValues(alpha: 0.85),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: const [0.0, 0.45, 1.0],
                ),
              ),
            ),
          ),

          // Center Play/Pause Indicator
          if (_showPlayCenterIcon || (!_isPlaying && _isInitialized))
            Center(
              child: Container(
                width: 60,
                height: 60,
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
                    _isPlaying ? FontAwesomeIcons.pause : FontAwesomeIcons.play,
                    color: Colors.white,
                    size: 22,
                  ),
                ),
              ),
            ),

          // Top Navigation Bar and Bottom Controls
          SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildTopNavBar(ep['episodeNumber']?.toString()),
                _buildBottomControls(ep),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── 2. Locked Episode View (Paywall Screen matching Screenshot 2)
  Widget _buildLockedEpisodeView(Map<String, dynamic> ep, int index) {
    return Stack(
      fit: StackFit.expand,
      children: [
        // Blurred Backdrop Image
        _buildBackdropWidget(),

        // Dark Blur Filter & Dark Overlay
        BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.black.withValues(alpha: 0.75),
                  Colors.black.withValues(alpha: 0.88),
                  Colors.black.withValues(alpha: 0.96),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: const [0.0, 0.5, 1.0],
              ),
            ),
          ),
        ),

        // Main Layout
        SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Top Bar
              _buildTopNavBar(ep['episodeNumber']?.toString()),

              // Center Paywall Box (Lock badge, Title, Description, Unlock button)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Lock Icon Circular Badge
                    Container(
                      width: 76,
                      height: 76,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: const Color(0xFF22222C).withValues(alpha: 0.95),
                        border: Border.all(
                          color: const Color(0xFF383848),
                          width: 1.5,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.4),
                            blurRadius: 18,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: Center(
                        child: Container(
                          width: 44,
                          height: 44,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color(0xFF2D231E),
                          ),
                          child: const FaIcon(
                            FontAwesomeIcons.lock,
                            color: Color(0xFFFFA726), // Amber Gold
                            size: 18,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Title: "The story gets deeper"
                    Text(
                      'The story gets deeper'.tr,
                      style: const TextStyle(
                        fontFamily: AppTextStyles.fontFamily,
                        color: Colors.white,
                        fontSize: 25,
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.3,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 10),

                    // Subtitle
                    RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        style: const TextStyle(
                          fontFamily: AppTextStyles.fontFamily,
                          color: Color(0xFF9E9EA8),
                          fontSize: 13.5,
                          fontWeight: FontWeight.w400,
                          height: 1.45,
                        ),
                        children: [
                          TextSpan(
                            text:
                                "You've reached Episode ${index + 1}. Unlock the rest of $_seriesTitle with ",
                          ),
                          const TextSpan(
                            text: 'Entertainment\u00B2',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Color(0xFFD0D0DE),
                            ),
                          ),
                          const TextSpan(text: ' Premium.'),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Primary Action: "Unlock Premium"
                    AppButton(
                      label: 'Unlock Premium'.tr,
                      onPressed: () async {
                        await Get.toNamed(Routes.subscriptionPage);
                        if (mounted) setState(() {});
                      },
                      backgroundColor: AppColors.primary,
                      height: 52,
                      borderRadius: 14,
                    ),
                    const SizedBox(height: 16),

                    // Secondary Action: "Maybe Later"
                    GestureDetector(
                      onTap: () {
                        if (_currentEpisodeIndex > 0) {
                          _pageController.previousPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        } else {
                          Get.back();
                        }
                      },
                      behavior: HitTestBehavior.opaque,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 6,
                        ),
                        child: Text(
                          'Maybe Later'.tr,
                          style: const TextStyle(
                            fontFamily: AppTextStyles.fontFamily,
                            color: Color(0xFFA0A0B0),
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Bottom Info
              _buildBottomControls(ep),
            ],
          ),
        ),
      ],
    );
  }

  // ── Top Bar Navigation
  Widget _buildTopNavBar(String? episodeNumber) {
    final epText = (episodeNumber != null && episodeNumber.isNotEmpty)
        ? episodeNumber
        : 'S1 · E${(_currentEpisodeIndex + 1).toString().padLeft(2, '0')}';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CustomBackButton(onTap: () => Get.back()),

          // Capsule badge: "S1 · E08" -> Tap to open Episodes Sheet
          GestureDetector(
            onTap: _openEpisodesSheet,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
              decoration: BoxDecoration(
                color: const Color(0xFF16161F).withValues(alpha: 0.9),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFF2E2E3E), width: 1),
              ),
              child: Text(
                epText,
                style: const TextStyle(
                  fontFamily: AppTextStyles.fontFamily,
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ),

          // Options button -> opens Playback Settings Sheet
          IconButton(
            onPressed: _openPlaybackSettings,
            icon: const FaIcon(
              FontAwesomeIcons.ellipsisVertical,
              color: Colors.white,
              size: 18,
            ),
          ),
        ],
      ),
    );
  }

  // ── Bottom Controls (Episodes > button, Title, Description, Progress bar)
  Widget _buildBottomControls(Map<String, dynamic> ep) {
    final isLastEpisode = ep['episodeNumber'] == 'S1 · E12' ||
        (_episodes.isNotEmpty && _currentEpisodeIndex == _episodes.length - 1);

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              // "Episodes >" Chip
              GestureDetector(
                onTap: _openEpisodesSheet,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF181822).withValues(alpha: 0.9),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: const Color(0xFF2C2C3C),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Text(
                        'Episodes',
                        style: TextStyle(
                          fontFamily: AppTextStyles.fontFamily,
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(width: 6),
                      FaIcon(
                        FontAwesomeIcons.chevronRight,
                        color: Color(0xFFE42429),
                        size: 12,
                      ),
                    ],
                  ),
                ),
              ),

              // If last episode, show Finish Series shortcut button
              if (isLastEpisode) ...[
                const SizedBox(width: 10),
                GestureDetector(
                  onTap: () {
                    _pageController.animateToPage(
                      _episodes.length,
                      duration: const Duration(milliseconds: 350),
                      curve: Curves.easeInOut,
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        FaIcon(
                          FontAwesomeIcons.circleCheck,
                          color: Colors.white,
                          size: 13,
                        ),
                        SizedBox(width: 6),
                        Text(
                          'Finish Series',
                          style: TextStyle(
                            fontFamily: AppTextStyles.fontFamily,
                            color: Colors.white,
                            fontSize: 12.5,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 10),

          // Title
          Text(
            _seriesTitle,
            style: const TextStyle(
              fontFamily: AppTextStyles.fontFamily,
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.w700,
              height: 1.15,
            ),
          ),
          const SizedBox(height: 6),

          // Description
          Text(
            _dramaDescription,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontFamily: AppTextStyles.fontFamily,
              color: Color(0xFF8E8E9E),
              fontSize: 12.5,
              height: 1.35,
            ),
          ),
          const SizedBox(height: 14),

          // Playback Progress Bar (Scrubbable / Live indicator)
          if (_isInitialized && _videoPlayerController != null)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 2),
              child: VideoProgressIndicator(
                _videoPlayerController!,
                allowScrubbing: true,
                padding: const EdgeInsets.symmetric(vertical: 4),
                colors: const VideoProgressColors(
                  playedColor: Color(0xFFE42429),
                  bufferedColor: Colors.white30,
                  backgroundColor: Colors.white12,
                ),
              ),
            )
          else
            ClipRRect(
              borderRadius: BorderRadius.circular(2),
              child: Row(
                children: [
                  Expanded(
                    flex: (((ep['progress'] as num?)?.toDouble() ?? 0.0) * 100)
                        .toInt()
                        .clamp(1, 100),
                    child: Container(height: 3, color: const Color(0xFFE42429)),
                  ),
                  Expanded(
                    flex: (((1.0 -
                                    ((ep['progress'] as num?)?.toDouble() ??
                                        0.0)) *
                                100)
                            .toInt())
                        .clamp(0, 100),
                    child: Container(
                      height: 3,
                      color: Colors.white.withValues(alpha: 0.5),
                    ),
                  ),
                ],
              ),
            ),
          const SizedBox(height: 6),

          // Timestamps: 1:31 / 2:14
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                (_isInitialized && _videoPlayerController != null)
                    ? _formatDuration(_currentPosition)
                    : (ep['currentTime']?.toString() ?? '0:00'),
                style: const TextStyle(
                  fontFamily: AppTextStyles.fontFamily,
                  color: Color(0xFFA0A0B0),
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                (_isInitialized &&
                        _videoPlayerController != null &&
                        _totalDuration > Duration.zero)
                    ? _formatDuration(_totalDuration)
                    : (ep['totalTime']?.toString() ??
                        ep['duration']?.toString() ??
                        '2:00'),
                style: const TextStyle(
                  fontFamily: AppTextStyles.fontFamily,
                  color: Color(0xFFA0A0B0),
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ── 3. Series Completed View (matching Screenshot exactly)
  Widget _buildSeriesCompletedView() {
    return Stack(
      fit: StackFit.expand,
      children: [
        // ── Blurred & Dimmed Backdrop Artwork
        _buildBackdropWidget(),

        // ── Dark Cinematic Overlay Gradient
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.black.withValues(alpha: 0.75),
                  Colors.black.withValues(alpha: 0.88),
                  Colors.black.withValues(alpha: 0.98),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: const [0.0, 0.45, 1.0],
              ),
            ),
          ),
        ),

        // ── Main Content
        SafeArea(
          child: Column(
            children: [
              // Top Header with Back Button
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomBackButton(onTap: () => Get.back()),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF16161F).withValues(alpha: 0.9),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: const Color(0xFF2E2E3E),
                          width: 1,
                        ),
                      ),
                      child: const Text(
                        'Completed',
                        style: TextStyle(
                          fontFamily: AppTextStyles.fontFamily,
                          color: Color(0xFF76D275),
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(width: 40),
                  ],
                ),
              ),

              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 16),

                      // ── Radiant Sunburst Checkmark Badge
                      const _RadiantCheckmarkBadge(),
                      const SizedBox(height: 24),

                      // ── Subtitle: "You've completed"
                      const Text(
                        "You’ve completed",
                        style: TextStyle(
                          fontFamily: AppTextStyles.fontFamily,
                          color: Colors.white70,
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),

                      // ── Red Bold Drama Title
                      Text(
                        _seriesTitle,
                        style: const TextStyle(
                          fontFamily: AppTextStyles.fontFamily,
                          color: Color(0xFFE42429),
                          fontSize: 30,
                          fontWeight: FontWeight.w800,
                          height: 1.18,
                          letterSpacing: -0.3,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 28),

                      // ── Primary Action: "Explore More Dramas" (Red Button)
                      AppButton(
                        label: 'Explore More Dramas',
                        onPressed: () {
                          Get.offAllNamed(Routes.home);
                        },
                        backgroundColor: AppColors.primary,
                        height: 52,
                        borderRadius: 14,
                      ),
                      const SizedBox(height: 12),

                      // ── Secondary Action: "+ Add to my List"
                      GestureDetector(
                        onTap: _toggleMyList,
                        behavior: HitTestBehavior.opaque,
                        child: Container(
                          height: 52,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: const Color(0xFF16161E),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: _isInMyList
                                  ? const Color(0xFF00C853)
                                  : const Color(0xFF282836),
                              width: 1.2,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              _isInMyList ? '✓ In my List' : '+ Add to my List',
                              style: TextStyle(
                                fontFamily: AppTextStyles.fontFamily,
                                color: _isInMyList
                                    ? const Color(0xFF00C853)
                                    : Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),

                      // ── Dual Actions: Rate & Share Buttons
                      Row(
                        children: [
                          // Rate Button
                          Expanded(
                            child: GestureDetector(
                              onTap: _toggleRate,
                              behavior: HitTestBehavior.opaque,
                              child: Container(
                                height: 48,
                                decoration: BoxDecoration(
                                  color: const Color(0xFF16161E),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: _isLiked
                                        ? const Color(0xFFE42429)
                                        : const Color(0xFF282836),
                                    width: 1,
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    FaIcon(
                                      _isLiked
                                          ? FontAwesomeIcons.solidThumbsUp
                                          : FontAwesomeIcons.thumbsUp,
                                      color: _isLiked
                                          ? const Color(0xFFE42429)
                                          : Colors.white,
                                      size: 16,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      'Rate',
                                      style: TextStyle(
                                        fontFamily: AppTextStyles.fontFamily,
                                        color: _isLiked
                                            ? const Color(0xFFE42429)
                                            : Colors.white,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),

                          // Share Button
                          Expanded(
                            child: GestureDetector(
                              onTap: _shareDrama,
                              behavior: HitTestBehavior.opaque,
                              child: Container(
                                height: 48,
                                decoration: BoxDecoration(
                                  color: const Color(0xFF16161E),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: const Color(0xFF282836),
                                    width: 1,
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const [
                                    FaIcon(
                                      FontAwesomeIcons.shareNodes,
                                      color: Colors.white,
                                      size: 16,
                                    ),
                                    SizedBox(width: 8),
                                    Text(
                                      'Share',
                                      style: TextStyle(
                                        fontFamily: AppTextStyles.fontFamily,
                                        color: Colors.white,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),

                      // ── "Recommended for you" Section
                      if (_recommendedDramas.isNotEmpty) ...[
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Recommended for you'.tr,
                            style: AppTextStyles.text18Bold.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                        const SizedBox(height: 14),

                        // 3-Column Grid for real Search Landing Recommendations
                        _buildRecommendedGrid(_recommendedDramas),
                        const SizedBox(height: 28),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRecommendedGrid(List<RecommendedDrama> dramas) {
    final rows = <List<RecommendedDrama>>[];
    for (int i = 0; i < dramas.length; i += 3) {
      rows.add(
        dramas.sublist(i, i + 3 > dramas.length ? dramas.length : i + 3),
      );
    }

    return Column(
      children: [
        for (int r = 0; r < rows.length; r++) ...[
          if (r > 0) const SizedBox(height: 14),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (int c = 0; c < 3; c++) ...[
                if (c > 0) const SizedBox(width: 10),
                if (c < rows[r].length)
                  Expanded(child: _buildRecommendedPosterCard(rows[r][c]))
                else
                  const Expanded(child: SizedBox()),
              ],
            ],
          ),
        ],
      ],
    );
  }

  Widget _buildRecommendedPosterCard(RecommendedDrama drama) {
    final poster = drama.posterUrl.isNotEmpty
        ? drama.posterUrl
        : drama.bannerUrl;

    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        Get.offNamed(
          Routes.dramaPlayer,
          arguments: drama,
          preventDuplicates: false,
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AspectRatio(
            aspectRatio: 0.68,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: const Color(0xFF161620),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.45),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.network(
                      poster,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        color: const Color(0xFF22222E),
                        child: const Center(
                          child: FaIcon(
                            FontAwesomeIcons.film,
                            color: Colors.white24,
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                    if (drama.viewsFormatted.isNotEmpty || drama.rating > 0)
                      Positioned(
                        top: 6,
                        right: 6,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 5,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.72),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              FaIcon(
                                drama.rating > 0
                                    ? FontAwesomeIcons.solidStar
                                    : FontAwesomeIcons.play,
                                color: drama.rating > 0
                                    ? const Color(0xFFFFD700)
                                    : Colors.white,
                                size: 8,
                              ),
                              const SizedBox(width: 3),
                              Text(
                                drama.viewsFormatted.isNotEmpty
                                    ? drama.viewsFormatted
                                    : drama.rating.toStringAsFixed(1),
                                style: const TextStyle(
                                  fontFamily: AppTextStyles.fontFamily,
                                  color: Colors.white,
                                  fontSize: 9,
                                  fontWeight: FontWeight.bold,
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
          const SizedBox(height: 6),
          Text(
            drama.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontFamily: AppTextStyles.fontFamily,
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
          if (drama.genreDisplay.isNotEmpty) ...[
            const SizedBox(height: 2),
            Text(
              drama.genreDisplay,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontFamily: AppTextStyles.fontFamily,
                color: Color(0xFF8A8A9E),
                fontSize: 10.5,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// Radiant Sunburst Checkmark Badge Widget
class _RadiantCheckmarkBadge extends StatelessWidget {
  const _RadiantCheckmarkBadge();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 96,
      height: 96,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomPaint(
            size: const Size(96, 96),
            painter: _RadiatingTicksPainter(),
          ),
          const FaIcon(
            FontAwesomeIcons.check,
            color: Color(0xFF76D275),
            size: 40,
          ),
        ],
      ),
    );
  }
}

class _RadiatingTicksPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF76D275)
      ..strokeWidth = 2.4
      ..strokeCap = StrokeCap.round;

    final center = Offset(size.width / 2, size.height / 2);
    const count = 14;
    final innerRadius = size.width * 0.36;
    final outerRadius = size.width * 0.48;

    for (int i = 0; i < count; i++) {
      final angle = (i * 2 * pi) / count;
      final x1 = center.dx + innerRadius * cos(angle);
      final y1 = center.dy + innerRadius * sin(angle);
      final x2 = center.dx + outerRadius * cos(angle);
      final y2 = center.dy + outerRadius * sin(angle);
      canvas.drawLine(Offset(x1, y1), Offset(x2, y2), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
