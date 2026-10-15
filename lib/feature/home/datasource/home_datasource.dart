import 'dart:convert';
import 'package:e_square_ott_app/constants/app_url.dart';
import 'package:e_square_ott_app/models/request/playback_progress_payload.dart';
import 'package:e_square_ott_app/models/response/admin_content_model.dart';
import 'package:e_square_ott_app/models/response/countinue_watching_model.dart';
import 'package:e_square_ott_app/models/response/drama_detail_response.dart';
import 'package:e_square_ott_app/models/response/drama_response.dart';
import 'package:e_square_ott_app/models/response/episode_access_model.dart';
import 'package:e_square_ott_app/models/response/episode_drawer_model.dart';
import 'package:e_square_ott_app/models/response/home_screen_model.dart';
import 'package:e_square_ott_app/models/response/home_section_model.dart';
import 'package:e_square_ott_app/models/response/playback_progress_response.dart';
import 'package:e_square_ott_app/models/response/upload_file_model.dart';
import 'package:e_square_ott_app/models/response/watch_history_model.dart';
import 'package:e_square_ott_app/shared/service/storage_service.dart';
import 'package:e_square_ott_app/shared/utils/log_util.dart';
import 'package:http/http.dart' as http;

class HomeDatasource {
  Future<UploadFileResponseModel?> uploadFileSingle(String filePath) async {
    try {
      final token = await StorageService.getToken();
      final url = Uri.parse(AppUrl.uploadFileSingle);
      final request = http.MultipartRequest('POST', url);

      if (token != null && token.isNotEmpty) {
        request.headers['Authorization'] = 'Bearer $token';
      }
      request.headers['Accept'] = 'application/json';

      request.files.add(await http.MultipartFile.fromPath('file', filePath));

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      LogUtil.log(
        "[HomeDatasource] uploadFileSingle [${response.statusCode}]: ${response.body}",
        name: "HomeDatasource",
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        return UploadFileResponseModel.fromJson(data);
      } else {
        LogUtil.error(
          'File upload failed with status: ${response.statusCode}',
          name: "HomeDatasource",
        );
        return null;
      }
    } catch (e, stack) {
      LogUtil.error(
        'File upload error: $e',
        name: "HomeDatasource",
        error: e,
        stackTrace: stack,
      );
      return null;
    }
  }

  Future<DramasResponse?> allDrama({
    required int pageNo,
    required int pageSize,
  }) async {
    final url = Uri.parse(AppUrl.allDrama(pageNo: pageNo, limit: pageSize));
    var response = await http.get(url);
    LogUtil.log("url: $url", name: "HomeDatasource");
    LogUtil.log(
      "[HomeDatasource] allDrama [${response.statusCode}]: ${response.body}",
      name: "HomeDatasource",
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      return DramasResponse.fromJson(data);
    } else {
      LogUtil.error(
        'All Drama failed with status: ${response.statusCode}',
        name: "HomeDatasource",
      );
      return null;
    }
  }

  Future<DramaDetailsResponse?> dramaDetail({required String id}) async {
    final url = Uri.parse(AppUrl.dramaDetail(id: id));
    final token = await StorageService.getToken();
    final headers = <String, String>{
      "Accept": "application/json",
      if (token != null && token.isNotEmpty) "Authorization": "Bearer $token",
    };
    var response = await http.get(url, headers: headers);
    LogUtil.log(
      "[HomeDatasource] dramaDetail [${response.statusCode}]: ${response.body}",
      name: "HomeDatasource",
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      return DramaDetailsResponse.fromJson(data);
    } else {
      LogUtil.error(
        'Detail Drama failed with status: ${response.statusCode}',
        name: "HomeDatasource",
      );
      return null;
    }
  }

  Future<EpisodesDrawerResponse?> allEpisode({
    required String dramaId,
    required int pageNo,
    required int limit,
  }) async {
    try {
      final token = await StorageService.getToken();
      final url = Uri.parse(
        AppUrl.allEpisode(dramaId: dramaId, pageNo: pageNo, limit: limit),
      );
      final headers = <String, String>{
        "Accept": "application/json",
        if (token != null && token.isNotEmpty) "Authorization": "Bearer $token",
      };
      final response = await http.get(url, headers: headers);
      LogUtil.log(
        "[HomeDatasource] allEpisode [${response.statusCode}]: ${response.body}",
        name: "HomeDatasource",
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        return EpisodesDrawerResponse.fromJson(data);
      } else {
        LogUtil.error(
          'All Episode failed with status: ${response.statusCode}',
          name: "HomeDatasource",
        );
        return null;
      }
    } catch (e, stack) {
      LogUtil.error(
        'All Episode error: $e',
        name: "HomeDatasource",
        error: e,
        stackTrace: stack,
      );
      return null;
    }
  }

  Future<EpisodeAccessResponse?> episodeAccess({
    required String id,
    required int episodeId,
  }) async {
    final token = await StorageService.getToken();
    if (token == null) {
      return null;
    }
    final url = Uri.parse(
      AppUrl.episodeAccess(dramaId: id, episodeNo: episodeId),
    );
    final response = await http.get(
      url,
      headers: {"Authorization": "Bearer $token", "Accept": "application/json"},
    );
    LogUtil.log(
      "[HomeDatasource] episodeAccess [${response.statusCode}]: ${response.body}",
      name: "HomeDatasource",
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      return EpisodeAccessResponse.fromJson(data);
    } else {
      LogUtil.error(
        "Episode access failed with status: ${response.statusCode}",
        name: "HomeDatasource",
      );
      return null;
    }
  }

  Future<PlaybackProgressResponse?> playBackProgress({
    required PlaybackProgressPayload payload,
  }) async {
    final token = await StorageService.getToken();
    if (token == null) {
      return null;
    }
    final url = Uri.parse(AppUrl.playBackProgress);
    final response = await http.post(
      url,
      headers: {
        "Authorization": "Bearer $token",
        "Accept": "application/json",
        "Content-Type": "application/json",
      },
      body: jsonEncode(payload.toJson()),
    );
    LogUtil.log(
      "[HomeDatasource] playBackProgress [${response.statusCode}]: ${response.body}",
      name: "HomeDatasource",
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      return PlaybackProgressResponse.fromJson(data);
    } else {
      LogUtil.error(
        "Playback Progress failed with status: ${response.statusCode}",
        name: "HomeDatasource",
      );
      return null;
    }
  }

  Future<AdminPriorityDramasResponse?> allContents({
    required int pageNo,
    required int size,
  }) async {
    try {
      final url = Uri.parse(AppUrl.homeAllContent(pageNo: pageNo, size: size));
      var response = await http.get(url);
      LogUtil.log("url: $url", name: "HomeDatasource");
      LogUtil.log(
        "[HomeDatasource] allContents [${response.statusCode}]: ${response.body}",
        name: "HomeDatasource",
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        return AdminPriorityDramasResponse.fromJson(data);
      } else {
        LogUtil.error(
          'All Content failed with status: ${response.statusCode}',
          name: "HomeDatasource",
        );
        return null;
      }
    } catch (e, stack) {
      LogUtil.error(
        'All Content error: $e',
        name: "HomeDatasource",
        error: e,
        stackTrace: stack,
      );
      return null;
    }
  }

  Future<ContinueWatchingResponse?> allCountinueWatching({
    required int pageNo,
    required int limit,
  }) async {
    final token = await StorageService.getToken();
    if (token == null || token.isEmpty) {
      LogUtil.log(
        "[HomeDatasource] allCountinueWatching: token is null or empty, user not logged in",
        name: "HomeDatasource",
      );
      return null;
    }
    try {
      final url = Uri.parse(
        AppUrl.countinueWatching(pageNo: pageNo, limit: limit),
      );
      final response = await http.get(
        url,
        headers: {
          "Authorization": "Bearer $token",
          "Accept": "application/json",
        },
      );
      LogUtil.log(
        "[HomeDatasource] allCountinueWatching [${response.statusCode}]: ${response.body}",
        name: "HomeDatasource",
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        final parsed = ContinueWatchingResponse.fromJson(data);
        if (parsed.data.items.isNotEmpty) {
          return parsed;
        }
      }

      // Fallback: If /player/continue-watching has no items or fails, try /watch-history?status=in-progress
      LogUtil.log(
        "[HomeDatasource] Trying fallback to getWatchHistory for continue watching...",
        name: "HomeDatasource",
      );
      final histRes = await getWatchHistory(
        pageNo: pageNo,
        limit: limit,
        status: 'in-progress',
      );
      if (histRes != null && histRes.data.history.isNotEmpty) {
        final convertedItems = histRes.data.history.map((h) {
          return ContinueWatchingItem(
            historyId: h.id.isNotEmpty ? h.id : h.historyId,
            drama: ContinueWatchingDrama(
              id: h.drama.id,
              title: h.drama.title,
              slug: h.drama.slug,
              posterUrl: h.drama.posterUrl,
              bannerUrl: '',
              trailerUrl: '',
              rating: h.drama.rating,
              totalEpisodes: h.drama.totalEpisodes,
              genres: h.drama.genres,
              genreDisplay: h.drama.genreDisplay,
            ),
            episode: ContinueWatchingEpisode(
              id: h.episode.id,
              episodeNumber: h.episode.episodeNumber,
              seasonNumber: h.episode.seasonNumber,
              seasonEpisodeTag: h.episode.seasonEpisodeTag,
              title: h.episode.title,
              durationSeconds: h.episode.durationSeconds,
              formattedDuration: h.episode.formattedDuration,
            ),
            playback: PlaybackHistory(
              watchedSeconds: h.playback.watchedSeconds,
              formattedWatched: h.playback.formattedWatched,
              durationSeconds: h.playback.durationSeconds,
              formattedDuration: h.playback.formattedDuration,
              remainingSeconds: h.playback.remainingSeconds,
              formattedRemaining: h.playback.formattedRemaining,
              progressPercentage: h.playback.progressPercentage,
              isCompleted: h.playback.isCompleted,
              lastWatchedAt: h.timeline.lastWatchedAt,
            ),
          );
        }).toList();

        return ContinueWatchingResponse(
          success: true,
          statusCode: 200,
          message: 'Retrieved from watch history',
          data: ContinueWatchingData(
            items: convertedItems,
            pagination: ContinueWatchingPagination(
              page: histRes.data.pagination.page,
              limit: histRes.data.pagination.limit,
              total: histRes.data.pagination.total,
              totalPages: histRes.data.pagination.totalPages,
              hasNextPage: histRes.data.pagination.hasNextPage,
              hasPrevPage: histRes.data.pagination.hasPrevPage,
            ),
          ),
        );
      }
      return null;
    } catch (e, stack) {
      LogUtil.error(
        "allCountinueWatching error: $e",
        name: "HomeDatasource",
        error: e,
        stackTrace: stack,
      );
      return null;
    }
  }

  Future<WatchHistoryResponseModel?> getWatchHistory({
    required int pageNo,
    required int limit,
    String? search,
    String? status,
    String? sortBy,
    String? period,
  }) async {
    try {
      final token = await StorageService.getToken();
      final url = Uri.parse(
        AppUrl.watchHistory(
          pageNo: pageNo,
          limit: limit,
          search: search,
          status: status,
          sortBy: sortBy,
          period: period,
        ),
      );
      final headers = <String, String>{
        "Accept": "application/json",
        if (token != null && token.isNotEmpty) "Authorization": "Bearer $token",
      };
      final response = await http.get(url, headers: headers);
      LogUtil.log(
        "[HomeDatasource] getWatchHistory [${response.statusCode}]: ${response.body}",
        name: "HomeDatasource",
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        return WatchHistoryResponseModel.fromJson(data);
      } else {
        LogUtil.error(
          "getWatchHistory failed with status: ${response.statusCode}",
          name: "HomeDatasource",
        );
        return null;
      }
    } catch (e, stack) {
      LogUtil.error(
        "getWatchHistory error: $e",
        name: "HomeDatasource",
        error: e,
        stackTrace: stack,
      );
      return null;
    }
  }

  Future<bool> deleteWatchHistoryItem(String historyId) async {
    try {
      final token = await StorageService.getToken();
      final url = Uri.parse(AppUrl.removeWatchHistoryItem(historyId));
      final headers = <String, String>{
        "Accept": "application/json",
        if (token != null && token.isNotEmpty) "Authorization": "Bearer $token",
      };
      final response = await http.delete(url, headers: headers);
      return response.statusCode == 200 || response.statusCode == 204;
    } catch (_) {
      return false;
    }
  }

  Future<bool> clearAllWatchHistory() async {
    try {
      final token = await StorageService.getToken();
      final url = Uri.parse(AppUrl.clearAllWatchHistory);
      final headers = <String, String>{
        "Accept": "application/json",
        if (token != null && token.isNotEmpty) "Authorization": "Bearer $token",
      };
      final response = await http.delete(url, headers: headers);
      return response.statusCode == 200 || response.statusCode == 204;
    } catch (_) {
      return false;
    }
  }

  Future<HomeBannersResponse?> allBanners() async {
    try {
      final token = await StorageService.getToken();
      final url = Uri.parse(AppUrl.allHomePageBanner);
      final headers = <String, String>{
        "Accept": "application/json",
        if (token != null && token.isNotEmpty) "Authorization": "Bearer $token",
      };
      var response = await http.get(url, headers: headers);
      LogUtil.log(
        "Banner response [${response.statusCode}] -> ${response.body}",
        name: "HomeDatasource",
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        return HomeBannersResponse.fromJson(jsonDecode(response.body));
      } else {
        return null;
      }
    } catch (e, stack) {
      LogUtil.error(
        "allBanners error: $e",
        name: "HomeDatasource",
        error: e,
        stackTrace: stack,
      );
      return null;
    }
  }

  Future<HomeSectionsResponse?> allSectionHome({
    required int pageNo,
    required int limit,
  }) async {
    final url = Uri.parse(AppUrl.homeSection(pageNo: pageNo, limit: limit));
    var response = await http.get(url);
    LogUtil.log(
      "[HomeDatasource] allSectionHome [${response.statusCode}]: ${response.body}",
      name: "HomeDatasource",
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      return HomeSectionsResponse.fromJson(data);
    } else {
      LogUtil.error(
        'All Section Home failed with status: ${response.statusCode}',
        name: "HomeDatasource",
      );
      return null;
    }
  }
}
