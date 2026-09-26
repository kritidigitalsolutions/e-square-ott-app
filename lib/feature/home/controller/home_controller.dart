import 'package:e_square_ott_app/constants/enum.dart';
import 'package:e_square_ott_app/feature/home/datasource/home_datasource.dart';
import 'package:e_square_ott_app/feature/notification/datasource/notification_datasource.dart';
import 'package:e_square_ott_app/models/request/playback_progress_payload.dart';
import 'package:e_square_ott_app/models/response/admin_content_model.dart';
import 'package:e_square_ott_app/models/response/countinue_watching_model.dart';
import 'package:e_square_ott_app/models/response/drama_detail_response.dart';
import 'package:e_square_ott_app/models/response/drama_response.dart';
import 'package:e_square_ott_app/models/response/episode_access_model.dart';
import 'package:e_square_ott_app/models/response/episode_drawer_model.dart';
import 'package:e_square_ott_app/models/response/home_screen_model.dart';
import 'package:e_square_ott_app/models/response/home_section_model.dart'
    as section_model;
import 'package:e_square_ott_app/models/response/playback_progress_response.dart';
import 'package:e_square_ott_app/shared/service/notification_service.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import '../../../constants/app_images.dart';
import '../../../routes/app_pages.dart';
import '../../../shared/widgets/custom_sncakbar.dart';
import '../models/category_model.dart';

class HomeController extends GetxController {
  final NotificationDatasource _notificationDatasource =
      NotificationDatasource();

  // ── Bottom Navigation State (0: Home, 1: Explore, 2: Profile, 3: Search)
  final RxInt currentNavIndex = 0.obs;

  // ── Hero Banner Carousel State
  late final PageController heroPageController;
  final RxInt currentHeroIndex = 0.obs;

  // ── Notification Unread Count
  final RxInt unreadNotifications = 0.obs;

  // ── Genre Filter & Search State for New Releases
  final RxString selectedNewReleaseGenre = 'All'.obs;
  final List<String> newReleaseGenres = const [
    'All',
    'Romance',
    'Drama',
    'Mystery',
    'Comedy',
    'Action',
    'Thriller',
  ];

  final RxBool isNewReleaseSearchOpen = false.obs;
  final TextEditingController newReleaseSearchTextController =
      TextEditingController();
  final RxString newReleaseSearchQuery = ''.obs;

  List<PriorityDrama> get filteredNewReleases {
    final genre = selectedNewReleaseGenre.value;
    final query = newReleaseSearchQuery.value.trim().toLowerCase();
    final dramas = newReleasesDramas.isNotEmpty
        ? newReleasesDramas
        : allPriorityDramas;

    return dramas.where((m) {
      final matchesGenre =
          genre == 'All' ||
          m.genreDisplay.toLowerCase().contains(genre.toLowerCase()) ||
          m.genres.any((g) => g.toLowerCase().contains(genre.toLowerCase()));
      final matchesQuery =
          query.isEmpty ||
          m.title.toLowerCase().contains(query) ||
          m.genreDisplay.toLowerCase().contains(query) ||
          m.genres.any((g) => g.toLowerCase().contains(query));
      return matchesGenre && matchesQuery;
    }).toList();
  }

  void selectNewReleaseGenre(String genre) {
    selectedNewReleaseGenre.value = genre;
  }

  void toggleNewReleaseSearch() {
    isNewReleaseSearchOpen.value = !isNewReleaseSearchOpen.value;
    if (!isNewReleaseSearchOpen.value) {
      clearNewReleaseSearch();
    }
  }

  void closeNewReleaseSearch() {
    isNewReleaseSearchOpen.value = false;
    clearNewReleaseSearch();
  }

  void clearNewReleaseSearch() {
    newReleaseSearchTextController.clear();
    newReleaseSearchQuery.value = '';
  }

  // ── Category / Genre shortcut badges (4 chips matching screenshot)
  final categoriesList = <CategoryModel>[
    CategoryModel(
      id: 'comedy',
      title: 'Comedy',
      icon: FontAwesomeIcons.faceLaughSquint,
      posterImage: AppImages.comedyImage,
      accentColor: const Color(0xFFF39C12),
      gradientColors: const [Color(0xFFF39C12), Color(0xFF9A5500)],
    ),
    CategoryModel(
      id: 'suspense',
      title: 'Suspense',
      icon: FontAwesomeIcons.masksTheater,
      posterImage: AppImages.thrillerImage,
      accentColor: const Color(0xFF8B5CF6),
      gradientColors: const [Color(0xFF7B3FE4), Color(0xFF451A9A)],
    ),
    CategoryModel(
      id: 'romance',
      title: 'Romance',
      icon: FontAwesomeIcons.solidHeart,
      posterImage: AppImages.romanceImage,
      accentColor: const Color(0xFFE50914),
      gradientColors: const [Color(0xFFE42429), Color(0xFF7E0B0F)],
    ),
    CategoryModel(
      id: 'action',
      title: 'Action',
      icon: FontAwesomeIcons.personRunning,
      posterImage: AppImages.actionImage,
      accentColor: const Color(0xFFFF6B00),
      gradientColors: const [Color(0xFF1976D2), Color(0xFF0A3D78)],
    ),
  ].obs;

  // ── All Categories Full List (2x4 Grid matching Categories Screen)
  final allCategoriesList = <CategoryModel>[
    CategoryModel(
      id: 'comedy1',
      title: 'Comedy',
      icon: FontAwesomeIcons.faceLaughSquint,
      accentColor: const Color(0xFFF39C12),
      posterImage: AppImages.comedyImage,
      seriesCount: '32+ Series',
      tag: 'POPULAR',
      gradientColors: const [Color(0xFFE5A00D), Color(0xFF8A4F00)],
    ),
    CategoryModel(
      id: 'suspense1',
      title: 'Suspense',
      icon: FontAwesomeIcons.masksTheater,
      accentColor: const Color(0xFF8B5CF6),
      posterImage: AppImages.thrillerImage,
      seriesCount: '28+ Series',
      tag: 'TRENDING',
      gradientColors: const [Color(0xFF6B38D8), Color(0xFF331668)],
    ),
    CategoryModel(
      id: 'romance1',
      title: 'Romance',
      icon: FontAwesomeIcons.solidHeart,
      accentColor: const Color(0xFFE50914),
      posterImage: AppImages.romanceImage,
      seriesCount: '54+ Series',
      tag: 'TOP RATED',
      gradientColors: const [Color(0xFFE42429), Color(0xFF7A070B)],
    ),
    CategoryModel(
      id: 'drama1',
      title: 'Drama',
      icon: FontAwesomeIcons.clapperboard,
      accentColor: const Color(0xFF22C55E),
      posterImage: AppImages.dramaImage,
      seriesCount: '45+ Series',
      tag: 'HOT',
      gradientColors: const [Color(0xFF2E7D32), Color(0xFF1B5E20)],
    ),
    CategoryModel(
      id: 'mystery1',
      title: 'Mystery',
      icon: FontAwesomeIcons.userSecret,
      accentColor: const Color(0xFF00ACC1),
      posterImage: AppImages.mysteryImage,
      seriesCount: '19+ Series',
      gradientColors: const [Color(0xFF00838F), Color(0xFF004D40)],
    ),
    CategoryModel(
      id: 'action1',
      title: 'Action',
      icon: FontAwesomeIcons.personRunning,
      accentColor: const Color(0xFFFF6B00),
      posterImage: AppImages.actionImage,
      seriesCount: '38+ Series',
      tag: 'EXPLOSIVE',
      gradientColors: const [Color(0xFFC2185B), Color(0xFF880E4F)],
    ),
    CategoryModel(
      id: 'thriller1',
      title: 'Thriller',
      icon: FontAwesomeIcons.bolt,
      accentColor: const Color(0xFFE50914),
      posterImage: AppImages.horrorImage,
      seriesCount: '26+ Series',
      gradientColors: const [Color(0xFFD32F2F), Color(0xFF6A0C0C)],
    ),
    CategoryModel(
      id: 'scifi1',
      title: 'Sci-Fi',
      icon: FontAwesomeIcons.rocket,
      accentColor: const Color(0xFF0284C7),
      posterImage: AppImages.fantasyImage,
      seriesCount: '15+ Series',
      gradientColors: const [Color(0xFF1976D2), Color(0xFF0D47A1)],
    ),
  ].obs;

  @override
  void onInit() {
    super.onInit();
    NotificationService.instance.registerAfterLogin();
    fetchUnreadCount();
    heroPageController = PageController(viewportFraction: 0.72, initialPage: 0);
    newReleaseSearchTextController.addListener(() {
      newReleaseSearchQuery.value = newReleaseSearchTextController.text;
    });

    // ── Fetch live backend data ──
    fetchAllBanner();
    fetchAllSectionsHome();
    getAllContent();
    getAllContinueWatching();
    getAllDrama();
  }

  // ── Dynamic Getters for Home Sections (Using Live API Data) ──
  List<section_model.HomeSection> get homeSections =>
      homeSectionsResponse.value?.data.sections ?? [];

  List<HomeBanner> get homeBanners =>
      homeBannerResponse.value?.data.banners ?? [];

  List<ContinueWatchingItem> get continueWatchingItems =>
      continueWatchingResponse.value?.data.items ?? [];

  List<PriorityDrama> get allPriorityDramas =>
      allContentResponse.value?.data.dramas ?? [];

  List<PriorityDrama> get trendingDramas {
    final trending = allPriorityDramas.where((d) => d.isTrending).toList();
    if (trending.isNotEmpty) {
      trending.sort((a, b) {
        final rankA = a.trendingRank ?? (a.priority > 0 ? a.priority : 999);
        final rankB = b.trendingRank ?? (b.priority > 0 ? b.priority : 999);
        return rankA.compareTo(rankB);
      });
      return trending;
    }
    return allPriorityDramas.take(10).toList();
  }

  List<PriorityDrama> get recommendedDramas => allPriorityDramas;

  List<PriorityDrama> get newReleasesDramas {
    final newReleases = allPriorityDramas.where((d) => d.isNewRelease).toList();
    if (newReleases.isNotEmpty) return newReleases;
    return allPriorityDramas.reversed.take(10).toList();
  }

  List<Drama> get allDramas => allDramaResponse.value?.data.dramas ?? [];

  void onBannerTap(HomeBanner banner) {
    Get.toNamed(Routes.dramaPlayer, arguments: banner);
  }

  void onPriorityDramaTap(PriorityDrama drama) {
    Get.toNamed(Routes.dramaPlayer, arguments: drama);
  }

  void onDramaTap(Drama drama) {
    Get.toNamed(Routes.dramaPlayer, arguments: drama);
  }

  void onContinueWatchingItemTap(ContinueWatchingItem item) {
    Get.toNamed(Routes.dramaPlayer, arguments: item);
  }

  Future<void> fetchUnreadCount() async {
    try {
      final res = await _notificationDatasource.getUnreadCount();
      if (res != null && res.success) {
        unreadNotifications.value = res.unreadCount;
      }
    } catch (e) {
      print("[HomeController] fetchUnreadCount error: $e");
    }
  }

  @override
  void onClose() {
    heroPageController.dispose();
    newReleaseSearchTextController.dispose();
    super.onClose();
  }

  void changeNavIndex(int index) {
    currentNavIndex.value = index;
  }

  void onHeroPageChanged(int index) {
    currentHeroIndex.value = index;
  }

  void openNotifications() {
    Get.toNamed(Routes.notificationPage)?.then((_) {
      fetchUnreadCount();
    });
  }

  void removeContinueWatching(String historyId) {
    if (continueWatchingResponse.value != null) {
      final currentItems = continueWatchingResponse.value!.data.items
          .where((i) => i.historyId != historyId)
          .toList();
      continueWatchingResponse.value = ContinueWatchingResponse(
        success: continueWatchingResponse.value!.success,
        statusCode: continueWatchingResponse.value!.statusCode,
        message: continueWatchingResponse.value!.message,
        data: ContinueWatchingData(
          items: currentItems,
          pagination: continueWatchingResponse.value!.data.pagination,
        ),
      );
    }
    AppSnackbar.info('Series removed from Continue Watching', title: 'Removed');
  }

  void clearAllContinueWatching() {
    if (continueWatchingResponse.value != null) {
      continueWatchingResponse.value = ContinueWatchingResponse(
        success: continueWatchingResponse.value!.success,
        statusCode: continueWatchingResponse.value!.statusCode,
        message: continueWatchingResponse.value!.message,
        data: ContinueWatchingData(
          items: [],
          pagination: continueWatchingResponse.value!.data.pagination,
        ),
      );
    }
    AppSnackbar.info('Continue Watching history cleared', title: 'Cleared');
  }

  // ── Selected Category (matching Category Dramas Screen)
  final Rx<CategoryModel> selectedCategory = CategoryModel(
    id: 'romance',
    title: 'Romance',
    icon: FontAwesomeIcons.solidHeart,
    gradientColors: [Color(0xFFD32F2F), Color(0xFF6A0C0C)],
  ).obs;

  void onCategoryTap(CategoryModel category) {
    selectedCategory.value = category;
    Get.toNamed(Routes.categoryDramas, arguments: category);
  }

  final HomeDatasource datasource = HomeDatasource();
  final allDramaStatus = Status.init.obs;
  final singleDramaStatus = Status.init.obs;
  final allEpisodeStatus = Status.init.obs;
  final allDramaResponse = Rxn<DramasResponse?>();
  final singleDramaResponse = Rxn<DramaDetailsResponse?>();
  final allEpisodeResponse = Rxn<EpisodesDrawerResponse?>();
  final hasMoreEpisode = false.obs;
  final episodePageNo = 0.obs;
  final episodePageSize = 3.obs;
  final moreEpisodeResponse = Rxn<EpisodesDrawerResponse?>();
  final pageNo = 0.obs;
  final pageSize = 10.obs;
  final hasMore = false.obs;
  final moreDramaResponse = Rxn<DramasResponse?>();
  final accessEpisodeStatus = Status.init.obs;
  final accessEpisodeResponse = Rxn<EpisodeAccessResponse?>();
  final playBackProgressStatus = Status.init.obs;
  final playBackProgressResponse = Rxn<PlaybackProgressResponse?>();
  final homeContentStatus = Status.init.obs;
  final allContentResponse = Rxn<AdminPriorityDramasResponse?>();
  final moreAllContentResponse = Rxn<AdminPriorityDramasResponse?>();
  final hasMoreContent = false.obs;
  final contentPageNo = 0.obs;
  final contentPageSize = 10.obs;
  final continueWatchingStatus = Status.init.obs;
  final continueWatchingResponse = Rxn<ContinueWatchingResponse?>();
  final moreContinueWatchingResponse = Rxn<ContinueWatchingResponse?>();
  final hasMoreContinueWatching = false.obs;
  final continueWatchingPageNo = 0.obs;
  final continueWatchingLimit = 10.obs;
  final isHomeBannerStatus = Status.init.obs;
  final homeBannerResponse = Rxn<HomeBannersResponse?>();
  final homeSectionsStatus = Status.init.obs;
  final homeSectionsResponse = Rxn<section_model.HomeSectionsResponse?>();
  final homeSectionsPageNo = 1.obs;
  final homeSectionsLimit = 20.obs;

  Future<void> fetchAllSectionsHome() async {
    homeSectionsStatus.value = Status.loading;
    try {
      final response = await datasource.allSectionHome(
        pageNo: homeSectionsPageNo.value,
        limit: homeSectionsLimit.value,
      );
      if (response != null && response.success) {
        homeSectionsResponse.value = response;
        homeSectionsStatus.value = Status.success;
      } else {
        homeSectionsStatus.value = Status.error;
      }
    } catch (e) {
      print("[HomeController] fetchAllSectionsHome error: $e");
      homeSectionsStatus.value = Status.error;
    }
  }

  Future<void> fetchAllBanner() async {
    isHomeBannerStatus.value = Status.loading;
    final response = await datasource.allBanners();
    if (response != null) {
      homeBannerResponse.value = response;
      isHomeBannerStatus.value = Status.success;
    } else {
      isHomeBannerStatus.value = Status.error;
    }
  }

  Future<void> fetchSingleDrama({required String id}) async {
    singleDramaStatus.value = Status.loading;
    final response = await datasource.dramaDetail(id: id);
    if (response != null) {
      singleDramaResponse.value = response;
      singleDramaStatus.value = Status.success;
    } else {
      singleDramaStatus.value = Status.error;
    }
  }

  Future<void> getAllDrama() async {
    allDramaStatus.value = Status.loading;

    pageNo.value = 1;

    final result = await datasource.allDrama(
      pageNo: pageNo.value,
      pageSize: pageSize.value,
    );

    if (result != null) {
      allDramaResponse.value = result;

      hasMore.value = result.data.pagination.hasNextPage;

      allDramaStatus.value = Status.success;
    } else {
      allDramaStatus.value = Status.error;
    }
  }

  Future<void> getMoreDrama() async {
    if (!hasMore.value) return;

    final nextPage = pageNo.value + 1;

    final result = await datasource.allDrama(
      pageNo: nextPage,
      pageSize: pageSize.value,
    );

    if (result != null) {
      moreDramaResponse.value = result;

      pageNo.value = nextPage;

      hasMore.value = result.data.pagination.hasNextPage;

      // Existing dramas + new dramas
      final currentDramas = allDramaResponse.value?.data.dramas ?? [];

      final newDramas = result.data.dramas;

      allDramaResponse.value = DramasResponse(
        success: result.success,
        statusCode: result.statusCode,
        message: result.message,
        data: DramasData(
          dramas: [...currentDramas, ...newDramas],
          pagination: result.data.pagination,
        ),
      );
    }
  }

  Future<void> getAllEpisode({required String dramaId}) async {
    allEpisodeStatus.value = Status.loading;

    episodePageNo.value = 1;

    final result = await datasource.allEpisode(
      dramaId: dramaId,
      pageNo: episodePageNo.value,
      limit: episodePageSize.value,
    );

    if (result != null) {
      allEpisodeResponse.value = result;

      hasMoreEpisode.value = result.data.pagination.hasNextPage;

      allEpisodeStatus.value = Status.success;
    } else {
      allEpisodeStatus.value = Status.error;
    }
  }

  Future<void> getMoreEpisode({required String dramaId}) async {
    if (!hasMoreEpisode.value) return;

    final nextPage = episodePageNo.value + 1;

    final result = await datasource.allEpisode(
      dramaId: dramaId,
      pageNo: nextPage,
      limit: episodePageSize.value,
    );

    if (result != null) {
      moreEpisodeResponse.value = result;

      episodePageNo.value = nextPage;

      hasMoreEpisode.value = result.data.pagination.hasNextPage;

      // Existing dramas + new dramas
      final currentDramas = allEpisodeResponse.value?.data.episodes ?? [];

      final newDramas = result.data.episodes;

      allEpisodeResponse.value = EpisodesDrawerResponse(
        success: result.success,
        statusCode: result.statusCode,
        message: result.message,
        data: EpisodesDrawerData(
          drama: allEpisodeResponse.value?.data.drama ?? result.data.drama,
          episodes: [...currentDramas, ...newDramas],
          pagination: result.data.pagination,
          userHasVip: result.data.userHasVip,
        ),
      );
    }
  }

  Future<EpisodeAccessResponse?> checkEpisodeAccess({
    required String dramaId,
    required int episodeNumber,
  }) async {
    accessEpisodeStatus.value = Status.loading;
    try {
      final result = await datasource.episodeAccess(
        id: dramaId,
        episodeId: episodeNumber,
      );
      if (result != null) {
        accessEpisodeResponse.value = result;
        accessEpisodeStatus.value = Status.success;
        return result;
      } else {
        accessEpisodeStatus.value = Status.error;
        return null;
      }
    } catch (e) {
      accessEpisodeStatus.value = Status.error;
      return null;
    }
  }

  Future<PlaybackProgressResponse?> updatePlaybackProgress({
    required String dramaId,
    required int episodeNumber,
    required int watchedSeconds,
    required int durationSeconds,
  }) async {
    playBackProgressStatus.value = Status.loading;
    try {
      final payload = PlaybackProgressPayload(
        dramaId: dramaId,
        episodeNumber: episodeNumber,
        watchedSeconds: watchedSeconds,
        durationSeconds: durationSeconds,
      );
      final result = await datasource.playBackProgress(payload: payload);
      if (result != null) {
        playBackProgressResponse.value = result;
        playBackProgressStatus.value = Status.success;
        return result;
      } else {
        playBackProgressStatus.value = Status.error;
        return null;
      }
    } catch (e) {
      playBackProgressStatus.value = Status.error;
      return null;
    }
  }

  Future<void> getAllContent() async {
    homeContentStatus.value = Status.loading;

    contentPageNo.value = 1;

    final result = await datasource.allContents(
      pageNo: contentPageNo.value,
      size: contentPageSize.value,
    );

    if (result != null) {
      allContentResponse.value = result;

      homeContentStatus.value = Status.success;

      contentPageNo.value = result.data.pagination.page;

      hasMoreContent.value = result.data.pagination.hasNextPage;
    } else {
      homeContentStatus.value = Status.error;
    }
  }

  Future<void> loadMoreContent() async {
    try {
      if (hasMoreContent.value && homeContentStatus.value != Status.loading) {
        homeContentStatus.value = Status.loading;

        final result = await datasource.allContents(
          pageNo: contentPageNo.value + 1,
          size: contentPageSize.value,
        );

        if (result != null) {
          moreAllContentResponse.value = result;

          final currentDramas =
              allContentResponse.value?.data.dramas ?? <PriorityDrama>[];
          final newDramas = result.data.dramas;

          allContentResponse.value = AdminPriorityDramasResponse(
            success: result.success,
            statusCode: result.statusCode,
            message: result.message,
            data: AdminPriorityDramasData(
              dramas: [...currentDramas, ...newDramas],
              pagination: result.data.pagination,
            ),
          );

          contentPageNo.value = result.data.pagination.page;
          hasMoreContent.value = result.data.pagination.hasNextPage;

          homeContentStatus.value = Status.success;
        } else {
          homeContentStatus.value = Status.error;
        }
      }
    } catch (e) {
      homeContentStatus.value = Status.error;
    }
  }

  Future<void> getAllContinueWatching() async {
    continueWatchingStatus.value = Status.loading;
    continueWatchingPageNo.value = 1;

    final result = await datasource.allCountinueWatching(
      pageNo: continueWatchingPageNo.value,
      limit: continueWatchingLimit.value,
    );

    if (result != null) {
      continueWatchingResponse.value = result;
      continueWatchingStatus.value = Status.success;
      continueWatchingPageNo.value = result.data.pagination.page;
      hasMoreContinueWatching.value = result.data.pagination.hasNextPage;
    } else {
      continueWatchingStatus.value = Status.error;
    }
  }

  Future<void> loadMoreContinueWatching() async {
    try {
      if (hasMoreContinueWatching.value &&
          continueWatchingStatus.value != Status.loading) {
        continueWatchingStatus.value = Status.loading;

        final result = await datasource.allCountinueWatching(
          pageNo: continueWatchingPageNo.value + 1,
          limit: continueWatchingLimit.value,
        );

        if (result != null) {
          moreContinueWatchingResponse.value = result;

          final currentItems =
              continueWatchingResponse.value?.data.items ??
              <ContinueWatchingItem>[];
          final newItems = result.data.items;

          continueWatchingResponse.value = ContinueWatchingResponse(
            success: result.success,
            statusCode: result.statusCode,
            message: result.message,
            data: ContinueWatchingData(
              items: [...currentItems, ...newItems],
              pagination: result.data.pagination,
            ),
          );

          continueWatchingPageNo.value = result.data.pagination.page;
          hasMoreContinueWatching.value = result.data.pagination.hasNextPage;
          continueWatchingStatus.value = Status.success;
        } else {
          continueWatchingStatus.value = Status.error;
        }
      }
    } catch (e) {
      continueWatchingStatus.value = Status.error;
    }
  }
}
