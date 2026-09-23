import 'dart:convert';
import 'package:e_square_ott_app/constants/app_url.dart';
import 'package:e_square_ott_app/models/response/upload_file_model.dart';
import 'package:e_square_ott_app/shared/service/storage_service.dart';
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

      print("[HomeDatasource] uploadFileSingle [${response.statusCode}]: ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        return UploadFileResponseModel.fromJson(data);
      } else {
        print('File upload failed with status: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('File upload error: $e');
      return null;
    }
  }
}
