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
import 'dart:convert';

import 'package:http/http.dart' as http;

class AuthDatasource {
  Future<OtpResponseModel?> requestOtp({
    required String phone,
    required String code,
  }) async {
    try {
      final url = Uri.parse(AppUrl.requestOtp);
      final body = jsonEncode({"phoneNumber": phone, "countryCode": code});
      print("[AuthDatasource] POST $url | body: $body");
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: body,
      );

      print(
        "[AuthDatasource] requestOtp response [${response.statusCode}]: ${response.body}",
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        return OtpResponseModel.fromJson(data);
      } else {
        return null;
      }
    } catch (e, stack) {
      print("[AuthDatasource] requestOtp error: $e\n$stack");
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
      print("[AuthDatasource] POST $url | body: $body");
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: body,
      );

      print(
        "[AuthDatasource] verifyOtp response [${response.statusCode}]: ${response.body}",
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
      print("[AuthDatasource] verifyOtp error: $e\n$stack");
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
      print("[AuthDatasource] POST $url | body: $body");
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: body,
      );

      print(
        "[AuthDatasource] resendOtp response [${response.statusCode}]: ${response.body}",
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        return ResendOtpResponseModel.fromJson(data);
      } else {
        return null;
      }
    } catch (e, stack) {
      print("[AuthDatasource] resendOtp error: $e\n$stack");
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
        print("Token is null!");
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

      final Map<String, dynamic> data = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        print("Profile completed: ${data['message']}");

        // Save new token returned by profile API
        final newToken = data['data']?['token'];

        if (newToken != null && newToken.toString().isNotEmpty) {
          await StorageService.saveToken(newToken.toString());
          print("New token saved successfully");
        }

        return CompleteProfileResponseModel.fromJson(data);
      }

      print(
        "Profile completion failed: "
        "${response.statusCode} ${response.body}",
      );

      return null;
    } catch (e) {
      print("Complete profile error: $e");
      return null;
    }
  }

  Future<ProfileResponseModel?> getProfile() async {
    try {
      final token = await StorageService.getToken();
      if (token == null || token.isEmpty) {
        print("[AuthDatasource] getProfile: token not available");
        return null;
      }
      final url = Uri.parse(AppUrl.getProfile);
      print("[AuthDatasource] GET $url");
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      print(
        "[AuthDatasource] getProfile response [${response.statusCode}]: ${response.body}",
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        return ProfileResponseModel.fromJson(data);
      } else {
        return null;
      }
    } catch (e, stack) {
      print("[AuthDatasource] getProfile error: $e\n$stack");
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
    if (response.statusCode == 200 || response.statusCode == 201) {
      print("logout!");
      return true;
    } else {
      print("not logout!");
      return false;
    }
  }

  Future<GenreResponseModel?> allGenre() async {
    final url = Uri.parse(AppUrl.getGenre);
    final response = await http.get(url);
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
        print("Token is null!");
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

      final Map<String, dynamic> data = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        print("Interests saved: ${data['message']}");

        return SaveInterestResponseModel.fromJson(data);
      }

      print(
        "Interests not saved: "
        "${response.statusCode} ${response.body}",
      );

      return null;
    } catch (e) {
      print("Save interests error: $e");
      return null;
    }
  }

  Future<bool> refreshToken() async {
    try {
      final token = await StorageService.getToken();

      if (token == null || token.isEmpty) {
        print("Token is null or empty");
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

      final Map<String, dynamic> data = jsonDecode(response.body);

      if ((response.statusCode == 200 || response.statusCode == 201) &&
          data["success"] == true) {
        final newToken = data["data"]?["token"];

        if (newToken != null && newToken.toString().isNotEmpty) {
          await StorageService.saveToken(newToken.toString());

          print("Token refreshed successfully");
          print("New token saved");

          return true;
        }

        print("New token not found in response");
        return false;
      }

      print(
        "Token not refreshed: "
        "${response.statusCode} ${response.body}",
      );

      return false;
    } catch (e) {
      print("Refresh token error: $e");
      return false;
    }
  }

  Future<bool> deleteAccount() async {
    final token = await StorageService.getToken();
    if (token == null) {
      return false;
    }
    final url = Uri.parse(AppUrl.deleteAccount);
    final response = await http.delete(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      print("account delete!");
      return true;
    } else {
      print("account not delete!");
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
    if (response.statusCode == 200 || response.statusCode == 201) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      print("edit profile");
      return EditProfileResponse.fromJson(data);
    } else {
      print("not edit!");
      return null;
    }
  }
}
