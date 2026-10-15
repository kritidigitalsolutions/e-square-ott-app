import 'package:e_square_ott_app/constants/enum.dart';
import 'package:e_square_ott_app/feature/home/controller/home_controller.dart';
import 'package:e_square_ott_app/feature/home/controller/whislist_controller.dart';
import 'package:e_square_ott_app/feature/home/datasource/home_datasource.dart';
import 'package:e_square_ott_app/models/response/admin_content_model.dart';
import 'package:e_square_ott_app/models/response/episode_drawer_model.dart';
import 'package:e_square_ott_app/routes/app_pages.dart';
import 'package:e_square_ott_app/shared/widgets/custom_sncakbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class ExploreController extends GetxController {
  final HomeDatasource datasource = HomeDatasource();
  final PageController pageController = PageController();

  // ── States ──
  final Rx<Status> exploreStatus = Status.init.obs;
  final RxList<PriorityDrama> exploreList = <PriorityDrama>[].obs;
  final RxInt currentExploreIndex = 0.obs;
  final RxBool isMuted = false.obs;
  final RxBool isFullScreenCleanMode = false.obs;
  final RxInt currentPage = 1.obs;
  final RxBool hasMore = true.obs;
  final RxBool isLoadingMore = false.obs;

  // ── User Interaction Sets ──
  final RxSet<String> likedDramaIds = <String>{}.obs;
  final RxSet<String> myWatchlistDramaIds = <String>{}.obs;

  // ── Episodes Drawer State ──
  final RxMap<String, EpisodesDrawerResponse> episodesCache =
      <String, EpisodesDrawerResponse>{}.obs;
  final RxBool isLoadingEpisodes = false.obs;

  @override
  void onInit() {
    super.onInit();
    _populateFromHomeIfAvailable();
    fetchExploreDramas();
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }

  void _populateFromHomeIfAvailable() {
    if (Get.isRegistered<HomeController>()) {
      final homeController = Get.find<HomeController>();
      if (homeController.allPriorityDramas.isNotEmpty) {
        exploreList.assignAll(homeController.allPriorityDramas);
        exploreStatus.value = Status.success;
      }
    }
  }

  Future<void> fetchExploreDramas() async {
    if (exploreList.isEmpty) {
      exploreStatus.value = Status.loading;
    }
    currentPage.value = 1;
    episodesCache.clear();
    try {
      final res = await datasource.allContents(pageNo: 1, size: 20);
      if (res != null && res.data.dramas.isNotEmpty) {
        exploreList.assignAll(res.data.dramas);
        hasMore.value = res.data.pagination.hasNextPage;
        exploreStatus.value = Status.success;
      } else {
        // Fallback to allDrama if allContents is empty
        final dramaRes = await datasource.allDrama(pageNo: 1, pageSize: 20);
        if (dramaRes != null && dramaRes.data.dramas.isNotEmpty) {
          final mapped = dramaRes.data.dramas.map((d) {
            return PriorityDrama(
              id: d.id,
              title: d.title,
              slug: d.slug,
              synopsis: d.synopsis,
              posterUrl: d.posterUrl,
              bannerUrl: d.bannerUrl,
              trailerUrl: d.trailerUrl,
              genres: d.genres,
              genreDisplay: d.genreDisplay,
              totalEpisodes: d.totalEpisodes,
              viewsCount: d.viewsCount,
              viewsFormatted: d.rating > 0
                  ? '★ ${d.rating}'
                  : '${d.viewsCount}',
              rating: d.rating,
              priority: 1,
              isTrending: d.isTrending,
              isNewRelease: d.isNewRelease,
              trendingRank: null,
              releaseDate: null,
            );
          }).toList();
          exploreList.assignAll(mapped);
          hasMore.value = dramaRes.data.pagination.hasNextPage;
          exploreStatus.value = Status.success;
        } else {
          if (exploreList.isEmpty) {
            exploreStatus.value = Status.error;
          }
        }
      }
    } catch (e) {
      if (exploreList.isEmpty) {
        exploreStatus.value = Status.error;
      }
    }
  }

  Future<void> loadMoreExploreDramas() async {
    if (!hasMore.value || isLoadingMore.value) return;
    isLoadingMore.value = true;
    final nextPage = currentPage.value + 1;
    try {
      final res = await datasource.allContents(pageNo: nextPage, size: 20);
      if (res != null && res.data.dramas.isNotEmpty) {
        currentPage.value = nextPage;
        exploreList.addAll(res.data.dramas);
        hasMore.value = res.data.pagination.hasNextPage;
      } else {
        hasMore.value = false;
      }
    } catch (_) {
      hasMore.value = false;
    } finally {
      isLoadingMore.value = false;
    }
  }

  void onPageChanged(int index) {
    currentExploreIndex.value = index;
    // Load more when nearing end
    if (index >= exploreList.length - 3 && hasMore.value) {
      loadMoreExploreDramas();
    }
  }

  void toggleMute() {
    isMuted.value = !isMuted.value;
  }

  void toggleFullScreenCleanMode() {
    isFullScreenCleanMode.value = !isFullScreenCleanMode.value;
    HapticFeedback.mediumImpact();
  }

  void toggleLike(String dramaId) {
    if (likedDramaIds.contains(dramaId)) {
      likedDramaIds.remove(dramaId);
    } else {
      likedDramaIds.add(dramaId);
    }
  }

  bool isDramaInMyList(String dramaId) {
    final whislistController = Get.isRegistered<WhislistController>()
        ? Get.find<WhislistController>()
        : Get.put(WhislistController());
    return whislistController.isDramaSaved(dramaId) ||
        myWatchlistDramaIds.contains(dramaId);
  }

  Future<void> toggleMyList(PriorityDrama drama) async {
    if (drama.id.isNotEmpty) {
      final whislistController = Get.isRegistered<WhislistController>()
          ? Get.find<WhislistController>()
          : Get.put(WhislistController());
      final res = await whislistController.toggleSavedSeries(dramaId: drama.id);
      if (res != null && res.success) {
        if (res.data.isSaved) {
          myWatchlistDramaIds.add(drama.id);
        } else {
          myWatchlistDramaIds.remove(drama.id);
        }
      }
    }
  }

  Future<EpisodesDrawerResponse?> fetchEpisodesForDrama(
    String dramaId, {
    String? slug,
  }) async {
    final cacheKey = dramaId.isNotEmpty ? dramaId : (slug ?? '');
    if (cacheKey.isNotEmpty && episodesCache.containsKey(cacheKey)) {
      return episodesCache[cacheKey];
    }
    isLoadingEpisodes.value = true;
    try {
      final targetId = dramaId.isNotEmpty ? dramaId : (slug ?? '');

      // 1. Primary: Fetch full drama detail via GET /dramas/:id (contains all episodes)
      if (targetId.isNotEmpty) {
        final detailRes = await datasource.dramaDetail(id: targetId);
        if (detailRes != null && detailRes.data.drama.episodes.isNotEmpty) {
          final drawerResponse = EpisodesDrawerResponse(
            success: true,
            statusCode: 200,
            message: detailRes.message,
            data: EpisodesDrawerData(
              drama: DrawerDrama(
                id: detailRes.data.drama.id.isNotEmpty
                    ? detailRes.data.drama.id
                    : targetId,
                title: detailRes.data.drama.title,
                slug: detailRes.data.drama.slug,
                posterUrl: detailRes.data.drama.posterUrl,
                totalEpisodes: detailRes.data.drama.totalEpisodes > 0
                    ? detailRes.data.drama.totalEpisodes
                    : detailRes.data.drama.episodes.length,
                genreDisplay: detailRes.data.drama.genres.join(' / '),
              ),
              episodes: detailRes.data.drama.episodes.map((ep) {
                return DrawerEpisode(
                  id: ep.id,
                  seasonNumber: 1,
                  episodeNumber: ep.episodeNumber,
                  seasonEpisodeTag:
                      'S1 · E${ep.episodeNumber.toString().padLeft(2, '0')}',
                  title: ep.title,
                  durationSeconds: ep.durationSeconds,
                  formattedDuration:
                      ep.duration.isNotEmpty ? ep.duration : '2:00',
                  thumbnailUrl: ep.thumbnailUrl.isNotEmpty
                      ? ep.thumbnailUrl
                      : detailRes.data.drama.posterUrl,
                  videoUrl: ep.videoUrl,
                  isFree: ep.isFree,
                  hasAccess: ep.isFree,
                  isLocked: !ep.isFree,
                  isCurrent: ep.episodeNumber == 1,
                  watched: false,
                );
              }).toList(),
              pagination: EpisodesPagination(
                page: 1,
                limit: detailRes.data.drama.episodes.length,
                total: detailRes.data.drama.episodes.length,
                totalPages: 1,
                hasNextPage: false,
                hasPrevPage: false,
              ),
              userHasVip: false,
            ),
          );

          if (cacheKey.isNotEmpty) episodesCache[cacheKey] = drawerResponse;
          if (dramaId.isNotEmpty) episodesCache[dramaId] = drawerResponse;
          if (slug != null && slug.isNotEmpty) episodesCache[slug] = drawerResponse;
          isLoadingEpisodes.value = false;
          return drawerResponse;
        }
      }

      // 2. Fallback: allEpisode API (GET /player/episodes/:id)
      if (targetId.isNotEmpty) {
        final res = await datasource.allEpisode(
          dramaId: targetId,
          pageNo: 1,
          limit: 100,
        );
        if (res != null && res.data.episodes.isNotEmpty) {
          if (cacheKey.isNotEmpty) episodesCache[cacheKey] = res;
          if (dramaId.isNotEmpty) episodesCache[dramaId] = res;
          if (slug != null && slug.isNotEmpty) episodesCache[slug] = res;
          isLoadingEpisodes.value = false;
          return res;
        }
      }

      // 3. Fallback: Try with slug if dramaId failed and slug is different
      if (slug != null && slug.isNotEmpty && slug != targetId) {
        final detailRes = await datasource.dramaDetail(id: slug);
        if (detailRes != null && detailRes.data.drama.episodes.isNotEmpty) {
          final drawerResponse = EpisodesDrawerResponse(
            success: true,
            statusCode: 200,
            message: detailRes.message,
            data: EpisodesDrawerData(
              drama: DrawerDrama(
                id: detailRes.data.drama.id.isNotEmpty
                    ? detailRes.data.drama.id
                    : slug,
                title: detailRes.data.drama.title,
                slug: detailRes.data.drama.slug,
                posterUrl: detailRes.data.drama.posterUrl,
                totalEpisodes: detailRes.data.drama.totalEpisodes,
                genreDisplay: detailRes.data.drama.genres.join(' / '),
              ),
              episodes: detailRes.data.drama.episodes.map((ep) {
                return DrawerEpisode(
                  id: ep.id,
                  seasonNumber: 1,
                  episodeNumber: ep.episodeNumber,
                  seasonEpisodeTag:
                      'S1 · E${ep.episodeNumber.toString().padLeft(2, '0')}',
                  title: ep.title,
                  durationSeconds: ep.durationSeconds,
                  formattedDuration:
                      ep.duration.isNotEmpty ? ep.duration : '2:00',
                  thumbnailUrl: ep.thumbnailUrl.isNotEmpty
                      ? ep.thumbnailUrl
                      : detailRes.data.drama.posterUrl,
                  videoUrl: ep.videoUrl,
                  isFree: ep.isFree,
                  hasAccess: ep.isFree,
                  isLocked: !ep.isFree,
                  isCurrent: ep.episodeNumber == 1,
                  watched: false,
                );
              }).toList(),
              pagination: EpisodesPagination(
                page: 1,
                limit: detailRes.data.drama.episodes.length,
                total: detailRes.data.drama.episodes.length,
                totalPages: 1,
                hasNextPage: false,
                hasPrevPage: false,
              ),
              userHasVip: false,
            ),
          );

          if (cacheKey.isNotEmpty) episodesCache[cacheKey] = drawerResponse;
          if (dramaId.isNotEmpty) episodesCache[dramaId] = drawerResponse;
          episodesCache[slug] = drawerResponse;
          isLoadingEpisodes.value = false;
          return drawerResponse;
        }
      }

      isLoadingEpisodes.value = false;
      return null;
    } catch (e) {
      isLoadingEpisodes.value = false;
      return null;
    }
  }

  void watchNow(PriorityDrama drama, {int episodeIndex = 0}) {
    Get.toNamed(
      Routes.dramaPlayer,
      arguments: {
        'id': drama.id.isNotEmpty ? drama.id : drama.slug,
        'title': drama.title,
        'description': drama.synopsis,
        'image': drama.posterUrl,
        'initialEpisodeIndex': episodeIndex,
      },
    );
  }
}
