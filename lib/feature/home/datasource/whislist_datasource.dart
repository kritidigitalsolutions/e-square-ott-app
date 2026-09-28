import 'dart:convert';
import 'package:e_square_ott_app/constants/app_url.dart';
import 'package:e_square_ott_app/models/response/check_series_model.dart';
import 'package:e_square_ott_app/models/response/saved_series_response.dart';
import 'package:e_square_ott_app/models/response/toogle_saved_series_model.dart';
import 'package:e_square_ott_app/shared/service/storage_service.dart';
import 'package:e_square_ott_app/shared/utils/log_util.dart';
import 'package:http/http.dart' as http;

class WhislistDatasource {
  Future<SavedSeriesResponse?> getAllSavedSeries({
    required int pageNo,
    required int limit,
  }) async {
    final token = await StorageService.getToken();
    if (token == null) {
      LogUtil.warning("[WhislistDatasource] getAllSavedSeries: No token found", name: "WhislistDatasource");
      return null;
    }
    final url = Uri.parse(AppUrl.allSavedSeries(pageNo: pageNo, limit: limit));
    LogUtil.log("[WhislistDatasource] getAllSavedSeries url: $url", name: "WhislistDatasource");
    var response = await http.get(
      url,
      headers: {"Authorization": "Bearer $token", "Accept": "application/json"},
    );
    LogUtil.log(
      "[WhislistDatasource] getAllSavedSeries [${response.statusCode}]: ${response.body}",
      name: "WhislistDatasource",
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      return SavedSeriesResponse.fromJson(jsonDecode(response.body));
    } else {
      return null;
    }
  }

  Future<bool> deleteSavedSeries({required String id}) async {
    final token = await StorageService.getToken();
    if (token == null) {
      LogUtil.warning("[WhislistDatasource] deleteSavedSeries: No token found", name: "WhislistDatasource");
      return false;
    }
    final url = Uri.parse(AppUrl.singleRemoveWhistlist(id));
    LogUtil.log("[WhislistDatasource] deleteSavedSeries url: $url", name: "WhislistDatasource");
    var response = await http.delete(
      url,
      headers: {"Authorization": "Bearer $token", "Accept": "application/json"},
    );
    LogUtil.log(
      "[WhislistDatasource] deleteSavedSeries [${response.statusCode}]: ${response.body}",
      name: "WhislistDatasource",
    );
    if (response.statusCode == 200 || response.statusCode == 204) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> clearAllSavedSeries() async {
    final token = await StorageService.getToken();
    if (token == null) {
      LogUtil.warning("[WhislistDatasource] clearAllSavedSeries: No token found", name: "WhislistDatasource");
      return false;
    }
    final url = Uri.parse(AppUrl.deleteAllSavedSeries);
    LogUtil.log("[WhislistDatasource] clearAllSavedSeries url: $url", name: "WhislistDatasource");
    var response = await http.delete(
      url,
      headers: {"Authorization": "Bearer $token", "Accept": "application/json"},
    );
    LogUtil.log(
      "[WhislistDatasource] clearAllSavedSeries [${response.statusCode}]: ${response.body}",
      name: "WhislistDatasource",
    );
    if (response.statusCode == 200 || response.statusCode == 204) {
      return true;
    } else {
      return false;
    }
  }

  Future<ToggleSavedSeriesResponse?> toggleSavedSeries({
    required String dramaId,
  }) async {
    final token = await StorageService.getToken();
    if (token == null) {
      LogUtil.warning("[WhislistDatasource] toggleSavedSeries: No token found", name: "WhislistDatasource");
      return null;
    }
    final url = Uri.parse(AppUrl.savedWhistlist(dramaId: dramaId));
    LogUtil.log("[WhislistDatasource] toggleSavedSeries url: $url", name: "WhislistDatasource");
    var response = await http.post(
      url,
      headers: {"Authorization": "Bearer $token", "Accept": "application/json"},
    );
    LogUtil.log(
      "[WhislistDatasource] toggleSavedSeries [${response.statusCode}]: ${response.body}",
      name: "WhislistDatasource",
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      return ToggleSavedSeriesResponse.fromJson(jsonDecode(response.body));
    } else {
      return null;
    }
  }

  Future<CheckSavedSeriesResponse?> checkSavedSeries({
    required String dramaId,
  }) async {
    final token = await StorageService.getToken();
    if (token == null) {
      LogUtil.warning("[WhislistDatasource] checkSavedSeries: No token found", name: "WhislistDatasource");
      return null;
    }
    final url = Uri.parse(AppUrl.checkWhislist(dramaId: dramaId));
    LogUtil.log("[WhislistDatasource] checkSavedSeries url: $url", name: "WhislistDatasource");
    var response = await http.get(
      url,
      headers: {"Authorization": "Bearer $token", "Accept": "application/json"},
    );
    LogUtil.log(
      "[WhislistDatasource] checkSavedSeries [${response.statusCode}]: ${response.body}",
      name: "WhislistDatasource",
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      return CheckSavedSeriesResponse.fromJson(jsonDecode(response.body));
    } else {
      return null;
    }
  }
}
