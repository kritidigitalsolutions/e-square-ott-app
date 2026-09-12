import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../constants/app_images.dart';
import '../models/movie_model.dart';
import 'home_controller.dart';

class SearchTabController extends GetxController {
  final TextEditingController searchTextController = TextEditingController();
  final RxString searchQuery = ''.obs;

  // ── Recent Searches List
  final RxList<String> recentSearches = <String>[
    'The Last Promise',
    'Behind Lies',
    'Romance',
  ].obs;

  // ── Popular Searches List
  final RxList<Map<String, String>> popularSearches = <Map<String, String>>[
    {'number': '01', 'title': 'The Last promise'},
    {'number': '02', 'title': 'The Last promise'},
    {'number': '03', 'title': 'The Last promise'},
  ].obs;

  // ── Recommended Posters for Search Tab (3 columns)
  final RxList<MovieModel> searchRecommendedList = <MovieModel>[
    const MovieModel(
      id: 'sr1',
      title: 'MAFIA ROMANCE',
      image: AppImages.banner1,
      views: '2.5k',
      plays: '3.5k',
    ),
    const MovieModel(
      id: 'sr2',
      title: 'BILLIONAIRE BRIDE',
      image: AppImages.banner2,
      views: '2.5k',
      plays: '3.5k',
    ),
    const MovieModel(
      id: 'sr3',
      title: 'MAKKAR CEO WIFE',
      image: AppImages.banner3,
      views: '2.5k',
      plays: '3.5k',
    ),
    const MovieModel(
      id: 'sr4',
      title: 'MAFIA ROMANCE',
      image: AppImages.banner1,
      views: '2.5k',
      plays: '3.5k',
    ),
    const MovieModel(
      id: 'sr5',
      title: 'BILLIONAIRE BRIDE',
      image: AppImages.banner2,
      views: '2.5k',
      plays: '3.5k',
    ),
    const MovieModel(
      id: 'sr6',
      title: 'MAKKAR CEO WIFE',
      image: AppImages.banner3,
      views: '2.5k',
      plays: '3.5k',
    ),
  ].obs;

  // ── Searchable catalog for dynamic filtering
  final RxList<MovieModel> allCatalog = <MovieModel>[
    const MovieModel(
      id: 'c1',
      title: 'The Last Promise',
      image: AppImages.banner1,
      subtitle: 'Episode 24 • Romance / Drama',
      genre: 'Romance',
      views: '2.5k',
      plays: '3.5k',
    ),
    const MovieModel(
      id: 'c2',
      title: 'Behind Lies',
      image: AppImages.banner2,
      subtitle: 'Episode 18 • Suspense',
      genre: 'Suspense',
      views: '3.1k',
      plays: '4.2k',
    ),
    const MovieModel(
      id: 'c3',
      title: 'MAFIA ROMANCE',
      image: AppImages.banner1,
      subtitle: 'Episode 10 • Crime / Romance',
      genre: 'Romance',
      views: '2.5k',
      plays: '3.5k',
    ),
    const MovieModel(
      id: 'c4',
      title: 'BILLIONAIRE BRIDE',
      image: AppImages.banner2,
      subtitle: 'Episode 15 • Drama',
      genre: 'Drama',
      views: '2.5k',
      plays: '3.5k',
    ),
    const MovieModel(
      id: 'c5',
      title: 'MAKKAR CEO WIFE',
      image: AppImages.banner3,
      subtitle: 'Episode 30 • Comedy / Romance',
      genre: 'Comedy',
      views: '2.5k',
      plays: '3.5k',
    ),
    const MovieModel(
      id: 'c6',
      title: 'How SPARKED CEO',
      image: AppImages.banner2,
      subtitle: 'Episode 18 • Romantic Comedy',
      genre: 'Comedy',
      views: '3.1k',
      plays: '4.2k',
    ),
    const MovieModel(
      id: 'c7',
      title: 'ATE... KING',
      image: AppImages.banner3,
      subtitle: 'Episode 12 • Royal Romance',
      genre: 'Romance',
      views: '2.8k',
      plays: '3.8k',
    ),
    const MovieModel(
      id: 'c8',
      title: 'ZINDA HOON MAIN',
      image: AppImages.banner2,
      subtitle: 'Episode 5 • Action / Drama',
      genre: 'Drama',
      views: '3.5k',
      plays: '3.5k',
    ),
  ].obs;

  List<MovieModel> get searchResults {
    final query = searchQuery.value.trim().toLowerCase();
    if (query.isEmpty) return [];
    return allCatalog.where((movie) {
      final titleMatch = movie.title.toLowerCase().contains(query);
      final genreMatch = movie.genre?.toLowerCase().contains(query) ?? false;
      final subtitleMatch = movie.subtitle?.toLowerCase().contains(query) ?? false;
      return titleMatch || genreMatch || subtitleMatch;
    }).toList();
  }

  @override
  void onInit() {
    super.onInit();
    searchTextController.addListener(() {
      searchQuery.value = searchTextController.text;
    });
  }

  @override
  void onClose() {
    searchTextController.dispose();
    super.onClose();
  }

  void onQueryChanged(String query) {
    searchQuery.value = query;
  }

  void selectSearchQuery(String query) {
    searchTextController.text = query;
    searchTextController.selection = TextSelection.fromPosition(
      TextPosition(offset: query.length),
    );
    searchQuery.value = query;
    addRecentSearch(query);
  }

  void addRecentSearch(String query) {
    final trimmed = query.trim();
    if (trimmed.isEmpty) return;
    recentSearches.removeWhere(
      (item) => item.toLowerCase() == trimmed.toLowerCase(),
    );
    recentSearches.insert(0, trimmed);
    if (recentSearches.length > 8) {
      recentSearches.removeLast();
    }
  }

  void removeRecentSearch(int index) {
    if (index >= 0 && index < recentSearches.length) {
      recentSearches.removeAt(index);
    }
  }

  void clearRecentSearches() {
    recentSearches.clear();
  }

  void clearSearch() {
    searchTextController.clear();
    searchQuery.value = '';
  }

  void onMovieTap(MovieModel movie) {
    addRecentSearch(movie.title);
    if (Get.isRegistered<HomeController>()) {
      Get.find<HomeController>().onMovieTap(movie);
    }
  }

  void handleBackPress() {
    if (searchQuery.value.isNotEmpty) {
      clearSearch();
    } else {
      if (Get.isRegistered<HomeController>()) {
        Get.find<HomeController>().changeNavIndex(0);
      }
    }
  }
}
