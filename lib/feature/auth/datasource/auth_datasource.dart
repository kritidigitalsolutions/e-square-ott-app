import 'dart:convert';
import 'package:e_square_ott_app/constants/app_url.dart';
import 'package:e_square_ott_app/models/request/edit_profile_payload.dart';
import 'package:e_square_ott_app/models/response/edit_profile_model.dart';
import 'package:e_square_ott_app/models/response/get_genre_model.dart';
import 'package:e_square_ott_app/models/response/otp_response.dart';
import 'package:e_square_ott_app/models/response/profile_model.dart';
import 'package:e_square_ott_app/models/response/resend_otp_response.dart';
import 'package:e_square_ott_app/models/response/saved_interest_model.dart';
import 'package:e_square_ott_app/models/response/user_model.dart';
import 'package:e_square_ott_app/models/response/verify_otp_response.dart';
import 'package:e_square_ott_app/shared/service/storage_service.dart';
import 'package:e_square_ott_app/shared/utils/log_util.dart';
import 'package:http/http.dart' as http;

class AuthDatasource {
  Future<OtpResponseModel?> requestOtp({
    required String phone,
    required String code,
  }) async {
    try {
      final url = Uri.parse(AppUrl.requestOtp);
      final body = jsonEncode({"phoneNumber": phone, "countryCode": code});
      LogUtil.log(
        "[AuthDatasource] POST $url | body: $body",
        name: "AuthDatasource",
      );
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: body,
      );

      LogUtil.log(
        "[AuthDatasource] requestOtp response [${response.statusCode}]: ${response.body}",
        name: "AuthDatasource",
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        return OtpResponseModel.fromJson(data);
      } else {
        return null;
      }
    } catch (e, stack) {
      LogUtil.error(
        "[AuthDatasource] requestOtp error: $e",
        name: "AuthDatasource",
        error: e,
        stackTrace: stack,
      );
      return null;
    }
  }

  Future<VerifyOtpResponseModel?> verifyOtp({
    required String phone,
    required String code,
    required String otp,
  }) async {
    try {
      final url = Uri.parse(AppUrl.verifyOtp);
      final body = jsonEncode({
        "phoneNumber": phone,
        "countryCode": code,
        "otp": otp,
      });
      LogUtil.log(
        "[AuthDatasource] POST $url | body: $body",
        name: "AuthDatasource",
      );
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: body,
      );

      LogUtil.log(
        "[AuthDatasource] verifyOtp response [${response.statusCode}]: ${response.body}",
        name: "AuthDatasource",
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        if (data["data"] != null && data["data"]["token"] != null) {
          await StorageService.saveToken(data["data"]["token"] as String);
        }
        return VerifyOtpResponseModel.fromJson(data);
      } else {
        return null;
      }
    } catch (e, stack) {
      LogUtil.error(
        "[AuthDatasource] verifyOtp error: $e",
        name: "AuthDatasource",
        error: e,
        stackTrace: stack,
      );
      return null;
    }
  }

  Future<ResendOtpResponseModel?> resendOtp({
    required String phone,
    required String code,
  }) async {
    try {
      final url = Uri.parse(AppUrl.resendOtp);
      final body = jsonEncode({"phoneNumber": phone, "countryCode": code});
      LogUtil.log(
        "[AuthDatasource] POST $url | body: $body",
        name: "AuthDatasource",
      );
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: body,
      );

      LogUtil.log(
        "[AuthDatasource] resendOtp response [${response.statusCode}]: ${response.body}",
        name: "AuthDatasource",
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        return ResendOtpResponseModel.fromJson(data);
      } else {
        return null;
      }
    } catch (e, stack) {
      LogUtil.error(
        "[AuthDatasource] resendOtp error: $e",
        name: "AuthDatasource",
        error: e,
        stackTrace: stack,
      );
      return null;
    }
  }

  Future<CompleteProfileResponseModel?> completeProfile({
    required String name,
    required String email,
    required String lastname,
    String? avatarUrl,
  }) async {
    try {
      final token = await StorageService.getToken();

      if (token == null || token.isEmpty) {
        LogUtil.warning("Token is null!", name: "AuthDatasource");
        return null;
      }

      final url = Uri.parse(AppUrl.completeProfile);

      final Map<String, dynamic> bodyMap = {
        'firstName': name,
        'lastName': lastname,
        'email': email,
      };
      if (avatarUrl != null && avatarUrl.isNotEmpty) {
        bodyMap['avatarUrl'] = avatarUrl;
      }

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(bodyMap),
      );

      LogUtil.log(
        "[AuthDatasource] completeProfile response [${response.statusCode}]: ${response.body}",
        name: "AuthDatasource",
      );

      final Map<String, dynamic> data = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        LogUtil.info(
          "Profile completed: ${data['message']}",
          name: "AuthDatasource",
        );

        // Save new token returned by profile API
        final newToken = data['data']?['token'];

        if (newToken != null && newToken.toString().isNotEmpty) {
          await StorageService.saveToken(newToken.toString());
          LogUtil.info("New token saved successfully", name: "AuthDatasource");
        }

        return CompleteProfileResponseModel.fromJson(data);
      }

      LogUtil.error(
        "Profile completion failed: ${response.statusCode} ${response.body}",
        name: "AuthDatasource",
      );

      return null;
    } catch (e, stack) {
      LogUtil.error(
        "Complete profile error: $e",
        name: "AuthDatasource",
        error: e,
        stackTrace: stack,
      );
      return null;
    }
  }

  Future<ProfileResponseModel?> getProfile() async {
    try {
      final token = await StorageService.getToken();
      if (token == null || token.isEmpty) {
        LogUtil.warning(
          "[AuthDatasource] getProfile: token not available",
          name: "AuthDatasource",
        );
        return null;
      }
      final url = Uri.parse(AppUrl.getProfile);
      LogUtil.log("[AuthDatasource] GET $url", name: "AuthDatasource");
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      LogUtil.log(
        "[AuthDatasource] getProfile response [${response.statusCode}]: ${response.body}",
        name: "AuthDatasource",
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        return ProfileResponseModel.fromJson(data);
      } else {
        return null;
      }
    } catch (e, stack) {
      LogUtil.error(
        "[AuthDatasource] getProfile error: $e",
        name: "AuthDatasource",
        error: e,
        stackTrace: stack,
      );
      return null;
    }
  }

  Future<bool> logout() async {
    final token = await StorageService.getToken();
    if (token == null) {
      return false;
    }
    final url = Uri.parse(AppUrl.logoutProfile);
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    LogUtil.log(
      "[AuthDatasource] logout response [${response.statusCode}]: ${response.body}",
      name: "AuthDatasource",
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      LogUtil.info("logout!", name: "AuthDatasource");
      return true;
    } else {
      LogUtil.warning("not logout!", name: "AuthDatasource");
      return false;
    }
  }

  Future<GenreResponseModel?> allGenre() async {
    final url = Uri.parse(AppUrl.getGenre);
    final response = await http.get(url);
    LogUtil.log(
      "[AuthDatasource] allGenre response [${response.statusCode}]: ${response.body}",
      name: "AuthDatasource",
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      return GenreResponseModel.fromJson(data);
    } else {
      return null;
    }
  }

  Future<SaveInterestResponseModel?> saveInterests({
    required List<String> interests,
  }) async {
    try {
      final token = await StorageService.getToken();

      if (token == null || token.isEmpty) {
        LogUtil.warning("Token is null!", name: "AuthDatasource");
        return null;
      }

      final url = Uri.parse(AppUrl.selectGenre);

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({'interests': interests}),
      );

      LogUtil.log(
        "[AuthDatasource] saveInterests response [${response.statusCode}]: ${response.body}",
        name: "AuthDatasource",
      );

      final Map<String, dynamic> data = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        LogUtil.info(
          "Interests saved: ${data['message']}",
          name: "AuthDatasource",
        );
        return SaveInterestResponseModel.fromJson(data);
      }

      LogUtil.error(
        "Interests not saved: ${response.statusCode} ${response.body}",
        name: "AuthDatasource",
      );

      return null;
    } catch (e, stack) {
      LogUtil.error(
        "Save interests error: $e",
        name: "AuthDatasource",
        error: e,
        stackTrace: stack,
      );
      return null;
    }
  }

  Future<bool> refreshToken() async {
    try {
      final token = await StorageService.getToken();

      if (token == null || token.isEmpty) {
        LogUtil.warning("Token is null or empty", name: "AuthDatasource");
        return false;
      }

      final url = Uri.parse(AppUrl.refreshToken);

      final response = await http.post(
        url,
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
      );

      LogUtil.log(
        "[AuthDatasource] refreshToken response [${response.statusCode}]: ${response.body}",
        name: "AuthDatasource",
      );

      final Map<String, dynamic> data = jsonDecode(response.body);

      if ((response.statusCode == 200 || response.statusCode == 201) &&
          data["success"] == true) {
        final newToken = data["data"]?["token"];

        if (newToken != null && newToken.toString().isNotEmpty) {
          await StorageService.saveToken(newToken.toString());
          LogUtil.info(
            "Token refreshed and saved successfully",
            name: "AuthDatasource",
          );
          return true;
        }

        LogUtil.warning(
          "New token not found in response",
          name: "AuthDatasource",
        );
        return false;
      }

      LogUtil.error(
        "Token not refreshed: ${response.statusCode} ${response.body}",
        name: "AuthDatasource",
      );

      return false;
    } catch (e, stack) {
      LogUtil.error(
        "Refresh token error: $e",
        name: "AuthDatasource",
        error: e,
        stackTrace: stack,
      );
      return false;
    }
  }

  Future<Map<String, dynamic>?> requestAccountDeletion({
    String? reason,
    String? feedback,
  }) async {
    final token = await StorageService.getToken();
    if (token == null) {
      return null;
    }
    final url = Uri.parse(AppUrl.requestDeleteAccount);
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        if (reason != null && reason.isNotEmpty) 'reason': reason,
        if (feedback != null && feedback.isNotEmpty) 'feedback': feedback,
      }),
    );
    LogUtil.log(
      "[AuthDatasource] requestAccountDeletion response [${response.statusCode}]: ${response.body}",
      name: "AuthDatasource",
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      final decoded = jsonDecode(response.body);
      return decoded is Map<String, dynamic> ? decoded : null;
    } else {
      LogUtil.warning("requestAccountDeletion failed!", name: "AuthDatasource");
      return null;
    }
  }

  Future<bool> deleteAccount() async {
    final res = await requestAccountDeletion();
    return res != null && res['success'] == true;
  }

  Future<bool> cancelAccountDeletionRequest() async {
    final token = await StorageService.getToken();
    if (token == null) {
      return false;
    }
    final url = Uri.parse(AppUrl.cancelDeleteRequest);
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    LogUtil.log(
      "[AuthDatasource] cancelAccountDeletionRequest response [${response.statusCode}]: ${response.body}",
      name: "AuthDatasource",
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      final decoded = jsonDecode(response.body);
      return decoded['success'] == true;
    } else {
      return false;
    }
  }

  Future<EditProfileResponse?> editProfile({
    required EditProfilePayload payload,
  }) async {
    final token = await StorageService.getToken();
    if (token == null) {
      return null;
    }
    final url = Uri.parse(AppUrl.editProfile);
    final response = await http.put(
      url,
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
        "Authorization": "Bearer $token",
      },
      body: jsonEncode(payload.toJson()),
    );
    LogUtil.log(
      "[AuthDatasource] editProfile response [${response.statusCode}]: ${response.body}",
      name: "AuthDatasource",
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      LogUtil.info("edit profile", name: "AuthDatasource");
      return EditProfileResponse.fromJson(data);
    } else {
      LogUtil.error("not edit!", name: "AuthDatasource");
      return null;
    }
  }
}
