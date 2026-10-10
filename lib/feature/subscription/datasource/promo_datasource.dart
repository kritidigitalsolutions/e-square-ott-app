import 'dart:convert';
import 'package:e_square_ott_app/constants/app_url.dart';
import 'package:e_square_ott_app/models/request/validate_promo_payload.dart';
import 'package:e_square_ott_app/models/response/validate_promo_response.dart';
import 'package:e_square_ott_app/shared/service/storage_service.dart';
import 'package:e_square_ott_app/shared/utils/log_util.dart';
import 'package:http/http.dart' as http;

class PromoDatasource {
  Future<ValidatePromoResponse?> validatePromo({
    required String code,
    required String planId,
  }) async {
    try {
      final token = await StorageService.getToken();
      final url = Uri.parse(AppUrl.validatePromo);
      final headers = <String, String>{
        "Content-Type": "application/json",
      };
      if (token != null && token.isNotEmpty) {
        headers["Authorization"] = "Bearer $token";
      }

      final payload = ValidatePromoPayload(code: code, planId: planId);
      final response = await http.post(
        url,
        headers: headers,
        body: jsonEncode(payload.toJson()),
      );

      LogUtil.log(
        "[PromoDatasource] validatePromo [${response.statusCode}]: ${response.body}",
        name: "PromoDatasource",
      );

      final decoded = jsonDecode(response.body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        return ValidatePromoResponse.fromJson(decoded);
      } else {
        String msg = 'Invalid or expired promo code';
        if (decoded is Map) {
          msg = decoded['message'] ?? decoded['error'] ?? 'Invalid or expired promo code';
        }
        return ValidatePromoResponse(
          success: false,
          statusCode: response.statusCode,
          message: msg,
        );
      }
    } catch (e, stack) {
      LogUtil.error(
        "[PromoDatasource] validatePromo exception: $e",
        name: "PromoDatasource",
        error: e,
        stackTrace: stack,
      );
      return ValidatePromoResponse(
        success: false,
        statusCode: 500,
        message: 'Network error validating promo code',
      );
    }
  }
}
