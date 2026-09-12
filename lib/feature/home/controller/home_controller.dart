import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../constants/app_images.dart';
import '../../../routes/app_pages.dart';
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
      title: 'Fatah Aashiqan Ki Dark Mafia Romance',
      image: AppImages.banner1,
      episodeInfo: 'Episode 3 of 42',
      remainingTime: '12 min remaining',
      progress: 0.65,
      views: '1.8k',
      plays: '3.5k',
    ),
    const MovieModel(
      id: 'cw2',
      title: 'Fatah Aashiqan Ki Dark Mafia Romance',
      image: AppImages.banner1,
      episodeInfo: 'Episode 3 of 42',
      remainingTime: '12 min remaining',
      progress: 0.65,
      views: '2.1k',
      plays: '3.5k',
    ),
    const MovieModel(
      id: 'cw3',
      title: 'Fatah Aashiqan Ki Dark Mafia Romance',
      image: AppImages.banner1,
      episodeInfo: 'Episode 3 of 42',
      remainingTime: '12 min remaining',
      progress: 0.65,
      views: '3.4k',
      plays: '3.5k',
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

  // ── Category / Genre shortcut badges
  final categoriesList = <CategoryModel>[
    const CategoryModel(
      id: 'comedy',
      title: 'Comedy',
      emoji: '😂',
      gradientColors: [Color(0xFFE5A00D), Color(0xFF8A4F00)],
    ),
    const CategoryModel(
      id: 'suspense',
      title: 'Suspense',
      emoji: '🎭',
      gradientColors: [Color(0xFF6B38D8), Color(0xFF331668)],
    ),
    const CategoryModel(
      id: 'romance',
      title: 'Romance',
      emoji: '❤️',
      gradientColors: [Color(0xFFD32F2F), Color(0xFF6A0C0C)],
    ),
  ].obs;

  // ── All Categories Full List (2x4 Grid matching Categories Screen)
  final allCategoriesList = <CategoryModel>[
    const CategoryModel(
      id: 'comedy1',
      title: 'Comedy',
      emoji: '😂',
      gradientColors: [Color(0xFFE5A00D), Color(0xFF8A4F00)],
    ),
    const CategoryModel(
      id: 'suspense1',
      title: 'Suspense',
      emoji: '🎭',
      gradientColors: [Color(0xFF6B38D8), Color(0xFF331668)],
    ),
    const CategoryModel(
      id: 'romance1',
      title: 'Romance',
      emoji: '❤️',
      gradientColors: [Color(0xFFD32F2F), Color(0xFF6A0C0C)],
    ),
    const CategoryModel(
      id: 'comedy2',
      title: 'Comedy',
      emoji: '😂',
      gradientColors: [Color(0xFFE5A00D), Color(0xFF8A4F00)],
    ),
    const CategoryModel(
      id: 'comedy3',
      title: 'Comedy',
      emoji: '😂',
      gradientColors: [Color(0xFFE5A00D), Color(0xFF8A4F00)],
    ),
    const CategoryModel(
      id: 'suspense2',
      title: 'Suspense',
      emoji: '🎭',
      gradientColors: [Color(0xFF6B38D8), Color(0xFF331668)],
    ),
    const CategoryModel(
      id: 'romance2',
      title: 'Romance',
      emoji: '❤️',
      gradientColors: [Color(0xFFD32F2F), Color(0xFF6A0C0C)],
    ),
    const CategoryModel(
      id: 'comedy4',
      title: 'Comedy',
      emoji: '😂',
      gradientColors: [Color(0xFFE5A00D), Color(0xFF8A4F00)],
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
    Get.snackbar(
      'Removed',
      'Series removed from Continue Watching',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: const Color(0xFF1C1C1C),
      colorText: Colors.white,
      duration: const Duration(seconds: 2),
    );
  }

  void resumeWatching(MovieModel movie) {
    Get.toNamed(Routes.dramaPlayer, arguments: movie);
  }

  // ── Selected Category & Category Dramas List (matching Category Dramas Screen)
  final Rx<CategoryModel> selectedCategory = const CategoryModel(
    id: 'romance',
    title: 'Romance',
    emoji: '❤️',
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
