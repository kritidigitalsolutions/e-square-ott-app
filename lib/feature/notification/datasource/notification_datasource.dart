import 'dart:convert';
import 'package:e_square_ott_app/constants/app_url.dart';
import 'package:e_square_ott_app/models/request/notification_setting_payload.dart';
import 'package:e_square_ott_app/models/response/all_notification_model.dart';
import 'package:e_square_ott_app/models/response/notification_setting_model.dart';
import 'package:e_square_ott_app/shared/service/storage_service.dart';
import 'package:e_square_ott_app/shared/utils/log_util.dart';
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
      LogUtil.log("[NotificationDatasource] GET $url", name: "NotificationDatasource");
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );
      LogUtil.log(
        "[NotificationDatasource] GET response [${response.statusCode}]: ${response.body}",
        name: "NotificationDatasource",
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        return NotificationsResponse.fromJson(jsonDecode(response.body));
      } else {
        return null;
      }
    } catch (e, stack) {
      LogUtil.error(
        "[NotificationDatasource] allNotification error: $e",
        name: "NotificationDatasource",
        error: e,
        stackTrace: stack,
      );
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
      LogUtil.log(
        "[NotificationDatasource] getUnreadCount [${response.statusCode}]: ${response.body}",
        name: "NotificationDatasource",
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        return UnreadCountResponse.fromJson(jsonDecode(response.body));
      }
      return null;
    } catch (e, stack) {
      LogUtil.error(
        "[NotificationDatasource] getUnreadCount error: $e",
        name: "NotificationDatasource",
        error: e,
        stackTrace: stack,
      );
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
      LogUtil.log(
        "[NotificationDatasource] markSingleAsRead [${response.statusCode}]: ${response.body}",
        name: "NotificationDatasource",
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        return MarkSingleNotificationResponse.fromJson(
          jsonDecode(response.body),
        );
      }
      return null;
    } catch (e, stack) {
      LogUtil.error(
        "[NotificationDatasource] markSingleAsRead error: $e",
        name: "NotificationDatasource",
        error: e,
        stackTrace: stack,
      );
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
      LogUtil.log(
        "[NotificationDatasource] markAllAsRead [${response.statusCode}]: ${response.body}",
        name: "NotificationDatasource",
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        return MarkAllNotificationResponse.fromJson(jsonDecode(response.body));
      }
      return null;
    } catch (e, stack) {
      LogUtil.error(
        "[NotificationDatasource] markAllAsRead error: $e",
        name: "NotificationDatasource",
        error: e,
        stackTrace: stack,
      );
      return null;
    }
  }

  // ── 5. Delete Single Notification ──
  Future<bool> deleteSingleNotification({required String id}) async {
    try {
      final token = await StorageService.getToken();
      if (token == null) {
        return false;
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
      LogUtil.log(
        "[NotificationDatasource] deleteSingleNotification [${response.statusCode}]: ${response.body}",
        name: "NotificationDatasource",
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      }
      return false;
    } catch (e, stack) {
      LogUtil.error(
        "[NotificationDatasource] deleteSingleNotification error: $e",
        name: "NotificationDatasource",
        error: e,
        stackTrace: stack,
      );
      return false;
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
      LogUtil.log(
        "[NotificationDatasource] clearAllNotifications [${response.statusCode}]: ${response.body}",
        name: "NotificationDatasource",
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        return ClearAllNotificationResponse.fromJson(jsonDecode(response.body));
      }
      return null;
    } catch (e, stack) {
      LogUtil.error(
        "[NotificationDatasource] clearAllNotifications error: $e",
        name: "NotificationDatasource",
        error: e,
        stackTrace: stack,
      );
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
      LogUtil.log(
        "[NotificationDatasource] getNotificationSettings [${response.statusCode}]: ${response.body}",
        name: "NotificationDatasource",
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        return NotificationSettingsResponse.fromJson(jsonDecode(response.body));
      }
      return null;
    } catch (e, stack) {
      LogUtil.error(
        "[NotificationDatasource] getNotificationSettings error: $e",
        name: "NotificationDatasource",
        error: e,
        stackTrace: stack,
      );
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
      LogUtil.log(
        "[NotificationDatasource] updateNotification [${response.statusCode}]: ${response.body}",
        name: "NotificationDatasource",
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        return NotificationSettingsResponse.fromJson(jsonDecode(response.body));
      }
      return null;
    } catch (e, stack) {
      LogUtil.error(
        "[NotificationDatasource] updateNotification error: $e",
        name: "NotificationDatasource",
        error: e,
        stackTrace: stack,
      );
      return null;
    }
  }

  // ── 9. Register Device Push Token (FCM) ──
  Future<bool> savedFcm({required String fcmToken}) async {
    try {
      final token = await StorageService.getToken();
      LogUtil.log(
        "[FCM Datasource] savedFcm called | Token exists: ${token != null}",
        name: "FCMDatasource",
      );
      if (token == null) {
        return false;
      }
      final url = Uri.parse(AppUrl.registerFcm);
      LogUtil.log("[FCM Datasource] POST $url | payload: {'fcmToken': '$fcmToken'}", name: "FCMDatasource");
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({'fcmToken': fcmToken}),
      );
      LogUtil.log(
        "[FCM Datasource] POST response [${response.statusCode}]: ${response.body}",
        name: "FCMDatasource",
      );
      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e, stack) {
      LogUtil.error(
        "[NotificationDatasource] savedFcm error: $e",
        name: "NotificationDatasource",
        error: e,
        stackTrace: stack,
      );
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
      LogUtil.log("[FCM Datasource] DELETE $url", name: "FCMDatasource");
      final response = await http.delete(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({'fcmToken': fcmToken}),
      );
      LogUtil.log(
        "[FCM Datasource] DELETE response [${response.statusCode}]: ${response.body}",
        name: "FCMDatasource",
      );
      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e, stack) {
      LogUtil.error(
        "[NotificationDatasource] deleteFcm error: $e",
        name: "NotificationDatasource",
        error: e,
        stackTrace: stack,
      );
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
      LogUtil.log(
        "[NotificationDatasource] seedNotifications [${response.statusCode}]: ${response.body}",
        name: "NotificationDatasource",
      );
      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e, stack) {
      LogUtil.error(
        "[NotificationDatasource] seedNotifications error: $e",
        name: "NotificationDatasource",
        error: e,
        stackTrace: stack,
      );
      return false;
    }
  }
}
