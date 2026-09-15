import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import '../../../constants/app_images.dart';
import '../../../routes/app_pages.dart';
import '../../../shared/widgets/custom_sncakbar.dart';
import '../models/category_model.dart';
import '../models/movie_model.dart';

class HomeController extends GetxController {
  // ── Bottom Navigation State (0: Home, 1: Explore, 2: Profile, 3: Search)
  final RxInt currentNavIndex = 0.obs;

  // ── Hero Banner Carousel State
  late final PageController heroPageController;
  final RxInt currentHeroIndex = 0.obs;

  // ── Notification Unread Count
  final RxInt unreadNotifications = 4.obs;

  // ── Hero 3D Banners
  final heroBanners = <MovieModel>[
    const MovieModel(
      id: 'h1',
      title: 'If This Is LOVE Let Me Burn',
      image: AppImages.banner1,
      subtitle: 'Episode 24 • Romance / Drama',
      views: '2.5k',
      plays: '3.5k',
    ),
    const MovieModel(
      id: 'h2',
      title: 'How SPARKED CEO',
      image: AppImages.banner2,
      subtitle: 'Episode 18 • Romantic Comedy',
      views: '3.1k',
      plays: '4.2k',
    ),
    const MovieModel(
      id: 'h3',
      title: 'ATE... KING',
      image: AppImages.banner3,
      subtitle: 'Episode 12 • Royal Romance',
      views: '2.8k',
      plays: '3.8k',
    ),
  ].obs;

  // ── Continue Watching List
  final continueWatchingList = <MovieModel>[
    const MovieModel(
      id: 'cw1',
      title: 'Fatal Attraction: Dark Mafia Romance',
      image: AppImages.banner1,
      episodeInfo: 'Episode 4 of 36',
      remainingTime: '18 min remaining',
      progress: 0.72,
      views: '4.8k',
      plays: '5.5k',
      genre: 'Romance',
    ),
    const MovieModel(
      id: 'cw2',
      title: 'From Divorcee to Billionaire Bride',
      image: AppImages.banner2,
      episodeInfo: 'Episode 12 of 24',
      remainingTime: '8 min remaining',
      progress: 0.85,
      views: '6.2k',
      plays: '7.1k',
      genre: 'Drama',
    ),
    const MovieModel(
      id: 'cw3',
      title: 'Security Guard Ki CEO GF',
      image: AppImages.banner3,
      episodeInfo: 'Episode 2 of 18',
      remainingTime: '24 min remaining',
      progress: 0.35,
      views: '3.4k',
      plays: '4.2k',
      genre: 'Romance',
    ),
    const MovieModel(
      id: 'cw4',
      title: 'Undercover Billionaire Heir',
      image: AppImages.actionImage,
      episodeInfo: 'Episode 7 of 40',
      remainingTime: '14 min remaining',
      progress: 0.54,
      views: '5.1k',
      plays: '6.0k',
      genre: 'Action',
    ),
    const MovieModel(
      id: 'cw5',
      title: 'Zinda Hoon Main: Revenge',
      image: AppImages.thrillerImage,
      episodeInfo: 'Episode 19 of 20',
      remainingTime: '6 min remaining',
      progress: 0.92,
      views: '8.4k',
      plays: '9.8k',
      genre: 'Thriller',
    ),
  ].obs;

  // ── New Releases List
  final newReleasesList = <MovieModel>[
    const MovieModel(
      id: 'nr1',
      title: 'SECURITY GUARD KI CEO GF',
      image: AppImages.banner1,
      views: '2.5k',
      plays: '3.5k',
      genre: 'Romance',
    ),
    const MovieModel(
      id: 'nr2',
      title: 'ZINDA HOON MAIN',
      image: AppImages.banner2,
      views: '3.5k',
      plays: '3.5k',
      genre: 'Drama',
    ),
    const MovieModel(
      id: 'nr3',
      title: 'MY WIFE Rented Me Out',
      image: AppImages.banner3,
      views: '2.5k',
      plays: '3.5k',
      genre: 'Mystery',
    ),
  ].obs;

  // ── Full All New Releases List (2-Column Grid matching New Releases Screen)
  final allNewReleasesList = <MovieModel>[
    const MovieModel(
      id: 'anr1',
      title: 'SECURITY GUARD KI CEO GF',
      image: AppImages.banner1,
      views: '2.5k',
      plays: '3.5k',
      genre: 'Romance',
    ),
    const MovieModel(
      id: 'anr2',
      title: 'ZINDA HOON MAIN',
      image: AppImages.banner2,
      views: '3.5k',
      plays: '3.5k',
      genre: 'Drama',
    ),
    const MovieModel(
      id: 'anr3',
      title: 'MY WIFE Rented Me Out',
      image: AppImages.banner3,
      views: '2.5k',
      plays: '3.5k',
      genre: 'Mystery',
    ),
    const MovieModel(
      id: 'anr4',
      title: 'धोखा A Dark Side of Love',
      image: AppImages.banner1,
      views: '2.5k',
      plays: '3.5k',
      genre: 'Drama',
    ),
    const MovieModel(
      id: 'anr5',
      title: 'SECURITY GUARD KI CEO GF',
      image: AppImages.banner1,
      views: '2.5k',
      plays: '3.5k',
      genre: 'Romance',
    ),
    const MovieModel(
      id: 'anr6',
      title: 'ZINDA HOON MAIN',
      image: AppImages.banner2,
      views: '3.5k',
      plays: '3.5k',
      genre: 'Drama',
    ),
    const MovieModel(
      id: 'anr7',
      title: 'MY WIFE Rented Me Out',
      image: AppImages.banner3,
      views: '2.5k',
      plays: '3.5k',
      genre: 'Mystery',
    ),
    const MovieModel(
      id: 'anr8',
      title: 'धोखा A Dark Side of Love',
      image: AppImages.banner1,
      views: '2.5k',
      plays: '3.5k',
      genre: 'Drama',
    ),
  ].obs;

  // ── Genre Filter & Search State for New Releases
  final RxString selectedNewReleaseGenre = 'All'.obs;
  final List<String> newReleaseGenres = const [
    'All',
    'Romance',
    'Drama',
    'Mystery',
    'Comedy',
  ];

  final RxBool isNewReleaseSearchOpen = false.obs;
  final TextEditingController newReleaseSearchTextController =
      TextEditingController();
  final RxString newReleaseSearchQuery = ''.obs;

  List<MovieModel> get filteredNewReleases {
    final genre = selectedNewReleaseGenre.value;
    final query = newReleaseSearchQuery.value.trim().toLowerCase();

    return allNewReleasesList.where((m) {
      final matchesGenre =
          genre == 'All' || (m.genre?.toLowerCase() == genre.toLowerCase());
      final matchesQuery =
          query.isEmpty ||
          m.title.toLowerCase().contains(query) ||
          (m.genre?.toLowerCase().contains(query) ?? false);
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

  // ── Trending Top Ranked List (1, 2, 3, 4)
  final trendingList = <MovieModel>[
    const MovieModel(
      id: 'tr1',
      title: 'SECURITY GUARD KI CEO GF',
      image: AppImages.banner1,
      ranking: 1,
      views: '2.5k',
      plays: '3.5k',
    ),
    const MovieModel(
      id: 'tr2',
      title: 'ZINDA HOON MAIN',
      image: AppImages.banner2,
      ranking: 2,
      views: '3.5k',
      plays: '3.5k',
    ),
    const MovieModel(
      id: 'tr3',
      title: 'MY WIFE Rented Me Out',
      image: AppImages.banner3,
      ranking: 3,
      views: '2.5k',
      plays: '3.5k',
    ),
    const MovieModel(
      id: 'tr4',
      title: 'धोखा A Dark Side of Love',
      image: AppImages.banner1,
      ranking: 4,
      views: '2.5k',
      plays: '3.8k',
    ),
    const MovieModel(
      id: 'tr5',
      title: 'THE CEO HAS MY BACK',
      image: AppImages.banner2,
      ranking: 5,
      views: '4.1k',
      plays: '4.8k',
    ),
    const MovieModel(
      id: 'tr6',
      title: 'UNDERCOVER BOSS LADY',
      image: AppImages.banner3,
      ranking: 6,
      views: '3.9k',
      plays: '4.2k',
    ),
  ].obs;

  // ── Recommended for You List
  final recommendedList = <MovieModel>[
    const MovieModel(
      id: 'rec1',
      title: 'TU ISSAQ MERA',
      image: AppImages.banner2,
      views: '2.5k',
      plays: '3.5k',
    ),
    const MovieModel(
      id: 'rec2',
      title: 'TU ISSAQ 2 MERA',
      image: AppImages.banner3,
      views: '2.5k',
      plays: '3.5k',
    ),
    const MovieModel(
      id: 'rec3',
      title: 'DEEWANGI',
      image: AppImages.banner1,
      views: '3.5k',
      plays: '3.5k',
    ),
    const MovieModel(
      id: 'rec4',
      title: 'SAY NO TO PIRACY',
      image: AppImages.banner2,
      views: '2.5k',
      plays: '3.5k',
    ),
    const MovieModel(
      id: 'rec5',
      title: 'THE UNTOUCHABLE CEO',
      image: AppImages.banner3,
      views: '3.5k',
      plays: '3.5k',
    ),
    const MovieModel(
      id: 'rec6',
      title: 'LUXURY EMPLOYEE',
      image: AppImages.banner1,
      views: '2.5k',
      plays: '3.5k',
    ),
  ].obs;

  @override
  void onInit() {
    super.onInit();
    heroPageController = PageController(viewportFraction: 0.72, initialPage: 0);
    newReleaseSearchTextController.addListener(() {
      newReleaseSearchQuery.value = newReleaseSearchTextController.text;
    });
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
    unreadNotifications.value = 0;
    Get.toNamed(Routes.notificationPage);
  }

  void onMovieTap(MovieModel movie) {
    Get.toNamed(Routes.dramaPlayer, arguments: movie);
  }

  void removeContinueWatching(String id) {
    continueWatchingList.removeWhere((item) => item.id == id);
    AppSnackbar.info('Series removed from Continue Watching', title: 'Removed');
  }

  void clearAllContinueWatching() {
    continueWatchingList.clear();
    AppSnackbar.info('Continue Watching history cleared', title: 'Cleared');
  }

  void resumeWatching(MovieModel movie) {
    Get.toNamed(Routes.dramaPlayer, arguments: movie);
  }

  // ── Selected Category & Category Dramas List (matching Category Dramas Screen)
  final Rx<CategoryModel> selectedCategory = CategoryModel(
    id: 'romance',
    title: 'Romance',
    icon: FontAwesomeIcons.solidHeart,
    gradientColors: [Color(0xFFD32F2F), Color(0xFF6A0C0C)],
  ).obs;

  final RxList<MovieModel> categoryDramas = <MovieModel>[
    const MovieModel(
      id: 'cd1',
      title: 'FATAL ATTRACTION: A DARK MAFIA ROMANCE',
      image: AppImages.banner1,
      views: '2.5k',
      plays: '3.5k',
      genre: 'Romance',
    ),
    const MovieModel(
      id: 'cd2',
      title: 'FROM DIVORCEE TO BILLIONAIRE BRIDE',
      image: AppImages.banner2,
      views: '2.5k',
      plays: '3.5k',
      genre: 'Romance',
    ),
    const MovieModel(
      id: 'cd3',
      title: 'MAKKAR CEO WIFE',
      image: AppImages.banner3,
      views: '2.5k',
      plays: '3.5k',
      genre: 'Romance',
    ),
    const MovieModel(
      id: 'cd4',
      title: 'FATAL ATTRACTION: A DARK MAFIA ROMANCE',
      image: AppImages.banner1,
      views: '2.5k',
      plays: '3.5k',
      genre: 'Romance',
    ),
    const MovieModel(
      id: 'cd5',
      title: 'FATAL ATTRACTION: A DARK MAFIA ROMANCE',
      image: AppImages.banner1,
      views: '2.5k',
      plays: '3.5k',
      genre: 'Romance',
    ),
    const MovieModel(
      id: 'cd6',
      title: 'FROM DIVORCEE TO BILLIONAIRE BRIDE',
      image: AppImages.banner2,
      views: '2.5k',
      plays: '3.5k',
      genre: 'Romance',
    ),
    const MovieModel(
      id: 'cd7',
      title: 'MAKKAR CEO WIFE',
      image: AppImages.banner3,
      views: '2.5k',
      plays: '3.5k',
      genre: 'Romance',
    ),
    const MovieModel(
      id: 'cd8',
      title: 'FATAL ATTRACTION: A DARK MAFIA ROMANCE',
      image: AppImages.banner1,
      views: '2.5k',
      plays: '3.5k',
      genre: 'Romance',
    ),
  ].obs;

  void onCategoryTap(CategoryModel category) {
    selectedCategory.value = category;
    Get.toNamed(Routes.categoryDramas, arguments: category);
  }
}
