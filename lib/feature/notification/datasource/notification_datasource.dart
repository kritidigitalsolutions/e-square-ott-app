import 'dart:convert';
import 'package:e_square_ott_app/constants/app_url.dart';
import 'package:e_square_ott_app/models/request/notification_setting_payload.dart';
import 'package:e_square_ott_app/models/response/all_notification_model.dart';
import 'package:e_square_ott_app/models/response/notification_setting_model.dart';
import 'package:e_square_ott_app/shared/service/storage_service.dart';
import 'package:http/http.dart' as http;

class NotificationDatasource {
  // ── 1. Get Notification List (Paginated & Date-Grouped) ──
  Future<NotificationsResponse?> allNotification({
    required int pageNo,
    required int size,
    String? type,
    bool? unreadOnly,
  }) async {
    try {
      final token = await StorageService.getToken();
      if (token == null) {
        return null;
      }
      final url = Uri.parse(
        AppUrl.allNotification(
          page: pageNo,
          size: size,
          type: type,
          unreadOnly: unreadOnly,
        ),
      );
      print("[NotificationDatasource] GET $url");
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );
      print(
        "[NotificationDatasource] GET response [${response.statusCode}]: ${response.body}",
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        return NotificationsResponse.fromJson(jsonDecode(response.body));
      } else {
        return null;
      }
    } catch (e) {
      print("[NotificationDatasource] allNotification error: $e");
      return null;
    }
  }

  // ── 2. Get Unread Count ──
  Future<UnreadCountResponse?> getUnreadCount() async {
    try {
      final token = await StorageService.getToken();
      if (token == null) {
        return null;
      }
      final url = Uri.parse(AppUrl.allUnreadNotification);
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        return UnreadCountResponse.fromJson(jsonDecode(response.body));
      }
      return null;
    } catch (e) {
      print("[NotificationDatasource] getUnreadCount error: $e");
      return null;
    }
  }

  // ── 3. Mark Single Notification as Read ──
  Future<MarkSingleNotificationResponse?> markSingleAsRead({
    required String id,
  }) async {
    try {
      final token = await StorageService.getToken();
      if (token == null) {
        return null;
      }
      final url = Uri.parse(AppUrl.markedSingleNotification(id: id));
      final response = await http.patch(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        return MarkSingleNotificationResponse.fromJson(
          jsonDecode(response.body),
        );
      }
      return null;
    } catch (e) {
      print("[NotificationDatasource] markSingleAsRead error: $e");
      return null;
    }
  }

  // ── 4. Mark All Notifications as Read ──
  Future<MarkAllNotificationResponse?> markAllAsRead() async {
    try {
      final token = await StorageService.getToken();
      if (token == null) {
        return null;
      }
      final url = Uri.parse(AppUrl.markAllNotification);
      final response = await http.patch(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        return MarkAllNotificationResponse.fromJson(jsonDecode(response.body));
      }
      return null;
    } catch (e) {
      print("[NotificationDatasource] markAllAsRead error: $e");
      return null;
    }
  }

  // ── 5. Delete Single Notification ──
  Future<CommonNotificationResponse?> deleteSingleNotification({
    required String id,
  }) async {
    try {
      final token = await StorageService.getToken();
      if (token == null) {
        return null;
      }
      final url = Uri.parse(AppUrl.deleteSingleNotification(id: id));
      final response = await http.delete(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        return CommonNotificationResponse.fromJson(jsonDecode(response.body));
      }
      return null;
    } catch (e) {
      print("[NotificationDatasource] deleteSingleNotification error: $e");
      return null;
    }
  }

  // ── 6. Clear All Notifications ──
  Future<ClearAllNotificationResponse?> clearAllNotifications() async {
    try {
      final token = await StorageService.getToken();
      if (token == null) {
        return null;
      }
      final url = Uri.parse(AppUrl.deleteAllNotification);
      final response = await http.delete(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        return ClearAllNotificationResponse.fromJson(jsonDecode(response.body));
      }
      return null;
    } catch (e) {
      print("[NotificationDatasource] clearAllNotifications error: $e");
      return null;
    }
  }

  // ── 7. Get Notification Settings ──
  Future<NotificationSettingsResponse?> getNotificationSettings() async {
    try {
      final token = await StorageService.getToken();
      if (token == null) {
        return null;
      }
      final url = Uri.parse(AppUrl.getNotificationSetting);
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        return NotificationSettingsResponse.fromJson(jsonDecode(response.body));
      }
      return null;
    } catch (e) {
      print("[NotificationDatasource] getNotificationSettings error: $e");
      return null;
    }
  }

  // ── 8. Update Notification Settings ──
  Future<NotificationSettingsResponse?> updateNotification({
    required NotificationSettingsPayload payload,
  }) async {
    try {
      final token = await StorageService.getToken();
      if (token == null) {
        return null;
      }
      final url = Uri.parse(AppUrl.updateNotficationsetting);
      final response = await http.put(
        url,
        body: jsonEncode(payload.toJson()),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        return NotificationSettingsResponse.fromJson(jsonDecode(response.body));
      }
      return null;
    } catch (e) {
      print("[NotificationDatasource] updateNotification error: $e");
      return null;
    }
  }

  // ── 9. Register Device Push Token (FCM) ──
  Future<bool> savedFcm({required String fcmToken}) async {
    try {
      final token = await StorageService.getToken();
      print("[FCM Datasource] savedFcm called | Token exists: ${token != null}");
      if (token == null) {
        return false;
      }
      final url = Uri.parse(AppUrl.registerFcm);
      print("[FCM Datasource] POST $url | payload: {'fcmToken': '$fcmToken'}");
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({'fcmToken': fcmToken}),
      );
      print(
        "[FCM Datasource] POST response [${response.statusCode}]: ${response.body}",
      );
      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      print("[NotificationDatasource] savedFcm error: $e");
      return false;
    }
  }

  // ── 10. Unregister Device Push Token (FCM) ──
  Future<bool> deleteFcm({required String fcmToken}) async {
    try {
      final token = await StorageService.getToken();
      if (token == null) {
        return false;
      }
      final url = Uri.parse(AppUrl.deleteFcm);
      print("[FCM Datasource] DELETE $url");
      final response = await http.delete(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({'fcmToken': fcmToken}),
      );
      print(
        "[FCM Datasource] DELETE response [${response.statusCode}]: ${response.body}",
      );
      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      print("[NotificationDatasource] deleteFcm error: $e");
      return false;
    }
  }

  // ── 11. Seed Sample Notifications ──
  Future<bool> seedNotifications({bool reset = true}) async {
    try {
      final token = await StorageService.getToken();
      if (token == null) {
        return false;
      }
      final url = Uri.parse(AppUrl.seedNotifications(reset: reset));
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );
      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      print("[NotificationDatasource] seedNotifications error: $e");
      return false;
    }
  }
}
