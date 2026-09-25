import 'dart:convert';

import 'package:e_square_ott_app/constants/app_url.dart';
import 'package:e_square_ott_app/models/response/legal_document_model.dart';
import 'package:http/http.dart' as http;

class ProfileDatasource {
  Future<LegalDocumentResponse?> privacyPolicy() async {
    final url = Uri.parse(AppUrl.privacyPolicy);
    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      return LegalDocumentResponse.fromJson(jsonDecode(response.body));
    }
    return null;
  }

  Future<LegalDocumentResponse?> termAndCondition() async {
    final url = Uri.parse(AppUrl.termAndCondition);
    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      return LegalDocumentResponse.fromJson(jsonDecode(response.body));
    }
    return null;
  }
}
