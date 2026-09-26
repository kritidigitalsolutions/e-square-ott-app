import 'dart:convert';

import 'package:e_square_ott_app/constants/app_url.dart';
import 'package:e_square_ott_app/models/response/check_series_model.dart';
import 'package:e_square_ott_app/models/response/saved_series_response.dart';
import 'package:e_square_ott_app/models/response/toogle_saved_series_model.dart';
import 'package:e_square_ott_app/shared/service/storage_service.dart';
import 'package:http/http.dart' as http;

class WhislistDatasource {
  Future<SavedSeriesResponse?> getAllSavedSeries({
    required int pageNo,
    required int limit,
  }) async {
    final token = await StorageService.getToken();
    if (token == null) {
      print("[WhislistDatasource] getAllSavedSeries: No token found");
      return null;
    }
    final url = Uri.parse(AppUrl.allSavedSeries(pageNo: pageNo, limit: limit));
    print("[WhislistDatasource] getAllSavedSeries url: $url");
    var response = await http.get(
      url,
      headers: {"Authorization": "Bearer $token", "Accept": "application/json"},
    );
    print(
      "[WhislistDatasource] getAllSavedSeries [${response.statusCode}]: ${response.body}",
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
      print("[WhislistDatasource] deleteSavedSeries: No token found");
      return false;
    }
    final url = Uri.parse(AppUrl.singleRemoveWhistlist(id));
    print("[WhislistDatasource] deleteSavedSeries url: $url");
    var response = await http.delete(
      url,
      headers: {"Authorization": "Bearer $token", "Accept": "application/json"},
    );
    print(
      "[WhislistDatasource] deleteSavedSeries [${response.statusCode}]: ${response.body}",
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
      print("[WhislistDatasource] clearAllSavedSeries: No token found");
      return false;
    }
    final url = Uri.parse(AppUrl.deleteAllSavedSeries);
    print("[WhislistDatasource] clearAllSavedSeries url: $url");
    var response = await http.delete(
      url,
      headers: {"Authorization": "Bearer $token", "Accept": "application/json"},
    );
    print(
      "[WhislistDatasource] clearAllSavedSeries [${response.statusCode}]: ${response.body}",
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
      print("[WhislistDatasource] toggleSavedSeries: No token found");
      return null;
    }
    final url = Uri.parse(AppUrl.savedWhistlist(dramaId: dramaId));
    print("[WhislistDatasource] toggleSavedSeries url: $url");
    var response = await http.post(
      url,
      headers: {"Authorization": "Bearer $token", "Accept": "application/json"},
    );
    print(
      "[WhislistDatasource] toggleSavedSeries [${response.statusCode}]: ${response.body}",
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
      print("[WhislistDatasource] checkSavedSeries: No token found");
      return null;
    }
    final url = Uri.parse(AppUrl.checkWhislist(dramaId: dramaId));
    print("[WhislistDatasource] checkSavedSeries url: $url");
    var response = await http.get(
      url,
      headers: {"Authorization": "Bearer $token", "Accept": "application/json"},
    );
    print(
      "[WhislistDatasource] checkSavedSeries [${response.statusCode}]: ${response.body}",
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      return CheckSavedSeriesResponse.fromJson(jsonDecode(response.body));
    } else {
      return null;
    }
  }
}
