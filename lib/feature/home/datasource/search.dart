import 'dart:convert';

import 'package:e_square_ott_app/constants/app_url.dart';
import 'package:e_square_ott_app/models/response/search_discorvey_model.dart';
import 'package:e_square_ott_app/models/response/search_suggestion_response.dart';
import 'package:e_square_ott_app/shared/service/storage_service.dart';
import 'package:http/http.dart' as http;

class SearchDatasource {
  Future<SearchDiscoveryResponse?> searchDiscovery() async {
    try {
      final token = await StorageService.getToken();
      if (token == null) {
        return null;
      }
      final url = Uri.parse(AppUrl.searchLanding);
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        return SearchDiscoveryResponse.fromJson(jsonDecode(response.body));
      }
      return null;
    } catch (e) {
      print("[SeachDatasource] searchDiscovery error: $e");
      return null;
    }
  }

  Future<SearchSuggestionsResponse?> searchSuggestion({
    required String query,
    required int limit,
  }) async {
    try {
      final token = await StorageService.getToken();
      if (token == null) {
        return null;
      }
      final url = Uri.parse(AppUrl.search(title: query, limit: limit));
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        return SearchSuggestionsResponse.fromJson(jsonDecode(response.body));
      }
      return null;
    } catch (e) {
      print("[SeachDatasource] searchSuggestion error: $e");
      return null;
    }
  }
}
