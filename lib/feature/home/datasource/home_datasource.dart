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
    var response = await http.get(url);
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
    final token = await StorageService.getToken();
    if (token == null) {
      return null;
    }
    final url = Uri.parse(
      AppUrl.allEpisode(dramaId: dramaId, pageNo: pageNo, limit: limit),
    );
    final response = await http.get(
      url,
      headers: {"Authorization": "Bearer $token"},
    );
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
    if (token == null) {
      return null;
    }
    final url = Uri.parse(
      AppUrl.countinueWatching(pageNo: pageNo, limit: limit),
    );
    final response = await http.get(
      url,
      headers: {"Authorization": "Bearer $token", "Accept": "application/json"},
    );
    LogUtil.log(
      "[HomeDatasource] allCountinueWatching [${response.statusCode}]: ${response.body}",
      name: "HomeDatasource",
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      return ContinueWatchingResponse.fromJson(data);
    } else {
      LogUtil.error(
        "All Countinue Watching failed with status: ${response.statusCode}",
        name: "HomeDatasource",
      );
      return null;
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
      LogUtil.log("Banner response [${response.statusCode}] -> ${response.body}", name: "HomeDatasource");
      if (response.statusCode == 200 || response.statusCode == 201) {
        return HomeBannersResponse.fromJson(jsonDecode(response.body));
      } else {
        return null;
      }
    } catch (e, stack) {
      LogUtil.error("allBanners error: $e", name: "HomeDatasource", error: e, stackTrace: stack);
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
