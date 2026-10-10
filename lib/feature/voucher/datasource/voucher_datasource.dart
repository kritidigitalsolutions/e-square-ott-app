import 'dart:convert';
import 'package:e_square_ott_app/constants/app_url.dart';
import 'package:e_square_ott_app/models/request/redeem_voucher_payload.dart';
import 'package:e_square_ott_app/models/request/validate_voucher_payload.dart';
import 'package:e_square_ott_app/models/response/redeem_voucher_response.dart';
import 'package:e_square_ott_app/models/response/validate_voucher_response.dart';
import 'package:e_square_ott_app/models/response/voucher_history_response.dart';
import 'package:e_square_ott_app/shared/service/storage_service.dart';
import 'package:e_square_ott_app/shared/utils/log_util.dart';
import 'package:http/http.dart' as http;

class VoucherDatasource {
  Future<ValidateVoucherResponse?> validateVoucher({
    required String code,
  }) async {
    try {
      final token = await StorageService.getToken();
      final url = Uri.parse(AppUrl.validateVoucher);
      final headers = <String, String>{
        "Content-Type": "application/json",
      };
      if (token != null && token.isNotEmpty) {
        headers["Authorization"] = "Bearer $token";
      }

      final payload = ValidateVoucherPayload(code: code);
      final response = await http.post(
        url,
        headers: headers,
        body: jsonEncode(payload.toJson()),
      );

      LogUtil.log(
        "[VoucherDatasource] validateVoucher [${response.statusCode}]: ${response.body}",
        name: "VoucherDatasource",
      );

      final decoded = jsonDecode(response.body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        return ValidateVoucherResponse.fromJson(decoded);
      } else {
        String msg = 'Invalid voucher code';
        if (decoded is Map) {
          msg = decoded['message'] ?? decoded['error'] ?? 'Invalid voucher code';
        }
        return ValidateVoucherResponse(
          success: false,
          statusCode: response.statusCode,
          message: msg,
        );
      }
    } catch (e, stack) {
      LogUtil.error(
        "[VoucherDatasource] validateVoucher error: $e",
        name: "VoucherDatasource",
        error: e,
        stackTrace: stack,
      );
      return ValidateVoucherResponse(
        success: false,
        statusCode: 500,
        message: 'Network error validating voucher',
      );
    }
  }

  Future<RedeemVoucherResponse?> redeemVoucher({
    required String code,
    String? phoneNumber,
  }) async {
    try {
      final token = await StorageService.getToken();
      final url = Uri.parse(AppUrl.redeemVoucher);
      final headers = <String, String>{
        "Content-Type": "application/json",
      };
      if (token != null && token.isNotEmpty) {
        headers["Authorization"] = "Bearer $token";
      }

      final payload = RedeemVoucherPayload(
        code: code,
        phoneNumber: phoneNumber,
      );
      final response = await http.post(
        url,
        headers: headers,
        body: jsonEncode(payload.toJson()),
      );

      LogUtil.log(
        "[VoucherDatasource] redeemVoucher [${response.statusCode}]: ${response.body}",
        name: "VoucherDatasource",
      );

      final decoded = jsonDecode(response.body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        return RedeemVoucherResponse.fromJson(decoded);
      } else {
        String msg = 'Failed to redeem voucher';
        if (decoded is Map) {
          msg = decoded['message'] ?? decoded['error'] ?? 'Failed to redeem voucher';
        }
        return RedeemVoucherResponse(
          success: false,
          statusCode: response.statusCode,
          message: msg,
        );
      }
    } catch (e, stack) {
      LogUtil.error(
        "[VoucherDatasource] redeemVoucher error: $e",
        name: "VoucherDatasource",
        error: e,
        stackTrace: stack,
      );
      return RedeemVoucherResponse(
        success: false,
        statusCode: 500,
        message: 'Network error redeeming voucher',
      );
    }
  }

  Future<VoucherHistoryResponse?> getVoucherHistory({
    required String phoneNumber,
  }) async {
    try {
      final token = await StorageService.getToken();
      final url = Uri.parse(AppUrl.voucherHistory(phoneNumber: phoneNumber));
      final headers = <String, String>{
        "Content-Type": "application/json",
      };
      if (token != null && token.isNotEmpty) {
        headers["Authorization"] = "Bearer $token";
      }

      final response = await http.get(url, headers: headers);

      LogUtil.log(
        "[VoucherDatasource] getVoucherHistory [${response.statusCode}]: ${response.body}",
        name: "VoucherDatasource",
      );

      final decoded = jsonDecode(response.body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        return VoucherHistoryResponse.fromJson(decoded);
      } else {
        return VoucherHistoryResponse(
          success: false,
          statusCode: response.statusCode,
          message: decoded['message'] ?? 'Failed to fetch history',
        );
      }
    } catch (e, stack) {
      LogUtil.error(
        "[VoucherDatasource] getVoucherHistory error: $e",
        name: "VoucherDatasource",
        error: e,
        stackTrace: stack,
      );
      return VoucherHistoryResponse(
        success: false,
        statusCode: 500,
        message: 'Network error fetching voucher history',
      );
    }
  }
}
