import 'dart:async';
import 'package:e_square_ott_app/constants/enum.dart';
import 'package:e_square_ott_app/feature/home/datasource/search.dart';
import 'package:e_square_ott_app/models/response/search_discorvey_model.dart';
import 'package:e_square_ott_app/models/response/search_suggestion_response.dart';
import 'package:e_square_ott_app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'home_controller.dart';

class SearchTabController extends GetxController {
  final SearchDatasource datasource = SearchDatasource();
  final TextEditingController searchTextController = TextEditingController();
  final RxString searchQuery = ''.obs;
  final int limit = 10;

  // ── API Statuses & Responses ──
  final Rx<Status> landingSearchStatus = Status.init.obs;
  final Rx<Status> searchStatus = Status.init.obs;
  final Rxn<SearchDiscoveryResponse> landingResponse =
      Rxn<SearchDiscoveryResponse>();
  final Rxn<SearchSuggestionsResponse> searchResponse =
      Rxn<SearchSuggestionsResponse>();

  // ── Recent Searches (Local user history) ──
  final RxList<String> recentSearches = <String>[].obs;

  Timer? _debounce;

  // ── Getters for Real API Data ──
  List<PopularSearch> get popularSearches =>
      landingResponse.value?.data.popularSearches ?? [];

  List<RecommendedDrama> get recommendedDramas =>
      landingResponse.value?.data.recommendedForYou ?? [];

  List<SearchSuggestion> get suggestions =>
      searchResponse.value?.data.suggestions ?? [];

  List<SearchDrama> get searchDramas =>
      searchResponse.value?.data.dramas ?? [];

  String get discoveryTitle =>
      landingResponse.value?.data.title.isNotEmpty == true
          ? landingResponse.value!.data.title
          : 'Search';

  String get discoverySubtitle =>
      landingResponse.value?.data.subtitle.isNotEmpty == true
          ? landingResponse.value!.data.subtitle
          : 'Find a story that matches your mood';

  @override
  void onInit() {
    super.onInit();
    setLandingSearch();

    searchTextController.addListener(() {
      final text = searchTextController.text;
      searchQuery.value = text;
      _onSearchInputChanged(text);
    });
  }

  @override
  void onClose() {
    _debounce?.cancel();
    searchTextController.dispose();
    super.onClose();
  }

  void _onSearchInputChanged(String query) {
    _debounce?.cancel();
    final trimmed = query.trim();

    if (trimmed.isEmpty) {
      searchStatus.value = Status.init;
      searchResponse.value = null;
      return;
    }

    _debounce = Timer(const Duration(milliseconds: 350), () {
      setSearch(title: trimmed);
    });
  }

  // ── Fetch Discovery / Landing Data ──
  Future<void> setLandingSearch() async {
    landingSearchStatus.value = Status.loading;
    try {
      final res = await datasource.searchDiscovery();
      if (res != null) {
        landingResponse.value = res;
        landingSearchStatus.value = Status.success;
      } else {
        landingSearchStatus.value = Status.error;
      }
    } catch (e) {
      landingSearchStatus.value = Status.error;
    }
  }

  // ── Search Suggestions / Dramas API ──
  Future<void> setSearch({required String title}) async {
    final query = title.trim();
    if (query.isEmpty) return;

    searchStatus.value = Status.loading;
    try {
      final res = await datasource.searchSuggestion(
        query: query,
        limit: limit,
      );
      if (res != null) {
        searchResponse.value = res;
        searchStatus.value = Status.success;
      } else {
        searchStatus.value = Status.error;
      }
    } catch (e) {
      searchStatus.value = Status.error;
    }
  }

  // ── Actions ──
  void selectSearchQuery(String query) {
    searchTextController.text = query;
    searchTextController.selection = TextSelection.fromPosition(
      TextPosition(offset: query.length),
    );
    searchQuery.value = query;
    addRecentSearch(query);
    setSearch(title: query);
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
    _debounce?.cancel();
    searchTextController.clear();
    searchQuery.value = '';
    searchStatus.value = Status.init;
    searchResponse.value = null;
  }

  void onPopularSearchTap(PopularSearch item) {
    addRecentSearch(item.title);
    Get.toNamed(Routes.dramaPlayer, arguments: item);
  }

  void onRecommendedDramaTap(RecommendedDrama drama) {
    addRecentSearch(drama.title);
    Get.toNamed(Routes.dramaPlayer, arguments: drama);
  }

  void onSuggestionTap(SearchSuggestion suggestion) {
    addRecentSearch(suggestion.title);
    Get.toNamed(Routes.dramaPlayer, arguments: suggestion);
  }

  void onSearchDramaTap(SearchDrama drama) {
    addRecentSearch(drama.title);
    Get.toNamed(Routes.dramaPlayer, arguments: drama);
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
