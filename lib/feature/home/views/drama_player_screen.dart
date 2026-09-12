import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../constants/app_colors.dart';
import '../../../constants/app_images.dart';
import '../../../constants/app_text_styles.dart';
import '../../../routes/app_pages.dart';
import '../../../shared/widgets/custom_buttons.dart';
import '../../explore/models/explore_item_model.dart';
import '../models/movie_model.dart';

class DramaPlayerScreen extends StatefulWidget {
  const DramaPlayerScreen({super.key});

  @override
  State<DramaPlayerScreen> createState() => _DramaPlayerScreenState();
}

class _DramaPlayerScreenState extends State<DramaPlayerScreen> {
  late final PageController _pageController;
  int _currentEpisodeIndex = 0;

  // Drama Details from arguments or default fallback
  late String _seriesTitle;
  late String _dramaDescription;
  late String _backdropImage;

  // Playback Settings State
  String _selectedSubtitle = 'Hindi';
  String _selectedQuality = 'Auto';
  String _selectedSpeed = '1x';

  // 12 Total Episodes for the Reel Viewer
  final List<Map<String, dynamic>> _episodes = [
    {
      'episodeNumber': 'S1 • E01',
      'title': 'Episode 01 • The Beginning',
      'duration': '2:08',
      'currentTime': '1:31',
      'totalTime': '2:14',
      'progress': 0.70,
      'status': 'Watched',
      'isLocked': false,
    },
    {
      'episodeNumber': 'S1 • E02',
      'title': 'Episode 02 • Hidden Whispers',
      'duration': '2:15',
      'currentTime': '0:45',
      'totalTime': '2:15',
      'progress': 0.35,
      'status': 'Watched',
      'isLocked': false,
    },
    {
      'episodeNumber': 'S1 • E03',
      'title': 'Episode 03 • The Betrayal',
      'duration': '2:20',
      'currentTime': '2:00',
      'totalTime': '2:20',
      'progress': 0.90,
      'status': 'Watched',
      'isLocked': false,
    },
    {
      'episodeNumber': 'S1 • E04',
      'title': 'Episode 04 • Forbidden Fire',
      'duration': '2:18',
      'currentTime': '0:00',
      'totalTime': '2:18',
      'progress': 0.0,
      'status': 'Locked',
      'isLocked': true,
    },
    {
      'episodeNumber': 'S1 • E05',
      'title': 'Episode 05 • Shattered Vows',
      'duration': '2:12',
      'currentTime': '0:00',
      'totalTime': '2:12',
      'progress': 0.0,
      'status': 'Locked',
      'isLocked': true,
    },
    {
      'episodeNumber': 'S1 • E06',
      'title': 'Episode 06 • The Confrontation',
      'duration': '2:25',
      'currentTime': '0:00',
      'totalTime': '2:25',
      'progress': 0.0,
      'status': 'Locked',
      'isLocked': true,
    },
    {
      'episodeNumber': 'S1 • E07',
      'title': 'Episode 07 • The Secret',
      'duration': '2:14',
      'currentTime': '0:00',
      'totalTime': '2:14',
      'progress': 0.0,
      'status': 'Locked',
      'isLocked': true,
    },
    {
      'episodeNumber': 'S1 • E08',
      'title': 'Episode 08 • Dangerous Game',
      'duration': '2:30',
      'currentTime': '0:00',
      'totalTime': '2:30',
      'progress': 0.0,
      'status': 'Locked',
      'isLocked': true,
    },
    {
      'episodeNumber': 'S1 • E09',
      'title': 'Episode 09 • A Dark Lie',
      'duration': '2:10',
      'currentTime': '0:00',
      'totalTime': '2:10',
      'progress': 0.0,
      'status': 'Locked',
      'isLocked': true,
    },
    {
      'episodeNumber': 'S1 • E10',
      'title': 'Episode 10 • Redemption',
      'duration': '2:22',
      'currentTime': '0:00',
      'totalTime': '2:22',
      'progress': 0.0,
      'status': 'Locked',
      'isLocked': true,
    },
    {
      'episodeNumber': 'S1 • E11',
      'title': 'Episode 11 • The Final Trap',
      'duration': '2:40',
      'currentTime': '0:00',
      'totalTime': '2:40',
      'progress': 0.0,
      'status': 'Locked',
      'isLocked': true,
    },
    {
      'episodeNumber': 'S1 • E12',
      'title': 'Episode 12 • Forever Mine',
      'duration': '2:50',
      'currentTime': '0:00',
      'totalTime': '2:50',
      'progress': 0.0,
      'status': 'Locked',
      'isLocked': true,
    },
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);

    // Extract arguments from Get.arguments
    final args = Get.arguments;
    if (args is MovieModel) {
      _seriesTitle = args.title;
      _dramaDescription =
          args.subtitle ?? 'He finally discovers the truth. But the promise he made could cost him everything.';
      _backdropImage = args.image;
    } else if (args is ExploreItemModel) {
      _seriesTitle = args.title;
      _dramaDescription = args.description;
      _backdropImage = args.image;
    } else if (args is Map<String, dynamic>) {
      _seriesTitle = args['title'] ?? 'If this is Love,\nLet me burn';
      _dramaDescription = args['description'] ??
          'He finally discovers the truth. But the promise he made could cost him everything.';
      _backdropImage = args['image'] ?? AppImages.banner1;
    } else {
      _seriesTitle = 'If this is Love,\nLet me burn';
      _dramaDescription =
          'He finally discovers the truth. But the promise he made could cost him everything.';
      _backdropImage = AppImages.banner1;
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  // ── Open Playback Settings Sheet (Subtitles, Quality, Speed)
  void _openPlaybackSettings() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => StatefulBuilder(
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
                      setState(() => _selectedSpeed = val);
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
                      color: isSelected ? Colors.white : const Color(0xFFA0A0B0),
                      fontSize: 12.5,
                      fontWeight:
                          isSelected ? FontWeight.w700 : FontWeight.w500,
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

  // ── Open Episodes Bottom Sheet (12 Episodes list with status & thumbnails)
  void _openEpisodesSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.65,
          decoration: const BoxDecoration(
            color: Color(0xFF16161F),
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
          child: SafeArea(
            top: false,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header: "Episodes • 12" + "Close"
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Episodes • ${_episodes.length}',
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
                  child: ListView.separated(
                    physics: const BouncingScrollPhysics(),
                    itemCount: _episodes.length,
                    separatorBuilder: (_, __) =>
                        const Divider(height: 16, color: Color(0xFF242432)),
                    itemBuilder: (context, index) {
                      final ep = _episodes[index];
                      final isCurrent = index == _currentEpisodeIndex;
                      final isLocked = ep['isLocked'] == true;

                      return InkWell(
                        onTap: () {
                          Navigator.pop(context);
                          _pageController.animateToPage(
                            index,
                            duration: const Duration(milliseconds: 350),
                            curve: Curves.easeInOut,
                          );
                        },
                        borderRadius: BorderRadius.circular(10),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Row(
                            children: [
                              // Episode Thumbnail with Play icon overlay
                              Stack(
                                alignment: Alignment.center,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.asset(
                                      _backdropImage,
                                      width: 60,
                                      height: 60,
                                      fit: BoxFit.cover,
                                      errorBuilder: (_, e, s) => Container(
                                        width: 60,
                                        height: 60,
                                        color: const Color(0xFF22222E),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width: 24,
                                    height: 24,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.black.withValues(alpha: 0.6),
                                    ),
                                    child: const Icon(
                                      Icons.play_arrow_rounded,
                                      color: Colors.white,
                                      size: 16,
                                    ),
                                  ),
                                ],
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
                                        color: isCurrent
                                            ? const Color(0xFFE42429)
                                            : Colors.white,
                                        fontSize: 14,
                                        fontWeight: isCurrent
                                            ? FontWeight.w700
                                            : FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      isCurrent
                                          ? '${ep['duration']} • Now Playing'
                                          : '${ep['duration']} • ${ep['status']}',
                                      style: TextStyle(
                                        fontFamily: AppTextStyles.fontFamily,
                                        color: const Color(0xFF8E8E9E),
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              // Trailing Lock Icon
                              if (isLocked)
                                const Icon(
                                  Icons.lock_outline_rounded,
                                  color: Color(0xFF8E8E9E),
                                  size: 18,
                                ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: PageView.builder(
        controller: _pageController,
        scrollDirection: Axis.vertical,
        physics: const BouncingScrollPhysics(),
        onPageChanged: (index) {
          setState(() {
            _currentEpisodeIndex = index;
          });
        },
        itemCount: _episodes.length,
        itemBuilder: (context, index) {
          final ep = _episodes[index];
          final isLocked = ep['isLocked'] == true;

          if (isLocked) {
            return _buildLockedEpisodeView(ep, index);
          }

          return _buildUnlockedEpisodeView(ep, index);
        },
      ),
    );
  }

  // ── 1. Unlocked Episode View (Reel Screen matching Screenshot 1 Left)
  Widget _buildUnlockedEpisodeView(Map<String, dynamic> ep, int index) {
    return Stack(
      fit: StackFit.expand,
      children: [
        // Backdrop Image
        Image.asset(
          _backdropImage,
          fit: BoxFit.cover,
          errorBuilder: (_, e, s) => Container(color: const Color(0xFF14141A)),
        ),

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

        // Top Navigation Bar
        SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildTopNavBar(ep['episodeNumber']),
              _buildBottomControls(ep),
            ],
          ),
        ),
      ],
    );
  }

  // ── 2. Locked Episode View (Paywall Screen matching Screenshot 2)
  Widget _buildLockedEpisodeView(Map<String, dynamic> ep, int index) {
    return Stack(
      fit: StackFit.expand,
      children: [
        // Blurred Backdrop Image
        Image.asset(
          _backdropImage,
          fit: BoxFit.cover,
          errorBuilder: (_, e, s) => Container(color: const Color(0xFF14141A)),
        ),

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
              _buildTopNavBar(ep['episodeNumber']),

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
                          child: const Icon(
                            Icons.lock_rounded,
                            color: Color(0xFFFFA726), // Amber Gold
                            size: 24,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Title: "The story gets deeper"
                    const Text(
                      'The story gets deeper',
                      style: TextStyle(
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
                      label: 'Unlock Premium',
                      onPressed: () {
                        Get.toNamed(Routes.subscriptionPage);
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
                      child: const Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 6,
                        ),
                        child: Text(
                          'Maybe Later',
                          style: TextStyle(
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
  Widget _buildTopNavBar(String episodeNumber) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CustomBackButton(onTap: () => Get.back()),

          // Capsule badge: "S1 • E01"
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
            decoration: BoxDecoration(
              color: const Color(0xFF16161F).withValues(alpha: 0.9),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFF2E2E3E), width: 1),
            ),
            child: Text(
              episodeNumber,
              style: const TextStyle(
                fontFamily: AppTextStyles.fontFamily,
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5,
              ),
            ),
          ),

          // Options button -> opens Playback Settings Sheet
          IconButton(
            onPressed: _openPlaybackSettings,
            icon: const Icon(
              Icons.more_vert_rounded,
              color: Colors.white,
              size: 24,
            ),
          ),
        ],
      ),
    );
  }

  // ── Bottom Controls (Episodes > button, Title, Description, Progress bar)
  Widget _buildBottomControls(Map<String, dynamic> ep) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // "Episodes >" Chip
          GestureDetector(
            onTap: _openEpisodesSheet,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFF181822).withValues(alpha: 0.9),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFF2C2C3C), width: 1),
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
                  SizedBox(width: 4),
                  Icon(
                    Icons.chevron_right_rounded,
                    color: Color(0xFFE42429),
                    size: 16,
                  ),
                ],
              ),
            ),
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

          // Playback Progress Bar (Red + White/Grey)
          ClipRRect(
            borderRadius: BorderRadius.circular(2),
            child: Row(
              children: [
                Expanded(
                  flex: ((ep['progress'] as double) * 100).toInt().clamp(1, 100),
                  child: Container(
                    height: 3,
                    color: const Color(0xFFE42429),
                  ),
                ),
                Expanded(
                  flex: (((1.0 - (ep['progress'] as double)) * 100).toInt())
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
                ep['currentTime'],
                style: const TextStyle(
                  fontFamily: AppTextStyles.fontFamily,
                  color: Color(0xFFA0A0B0),
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                ep['totalTime'],
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
}
