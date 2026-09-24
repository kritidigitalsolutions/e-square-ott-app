import 'package:e_square_ott_app/constants/enum.dart';
import 'package:e_square_ott_app/feature/notification/datasource/notification_datasource.dart';
import 'package:e_square_ott_app/models/request/notification_setting_payload.dart';
import 'package:e_square_ott_app/models/response/notification_setting_model.dart';
import 'package:e_square_ott_app/shared/widgets/custom_sncakbar.dart';
import 'package:get/get.dart';

class NotifcationController extends GetxController {
  final NotificationDatasource datasource = NotificationDatasource();
  final newNotification = true.obs;
  final newReleases = true.obs;
  final newRecomdation = true.obs;
  final notificationSettingResponse = Rxn<NotificationSettingsResponse?>();
  final notificationSettingStatus = Status.init.obs;
  final getNotificationStatus = Status.init.obs;

  @override
  void onInit() {
    super.onInit();
    fetchNotificationSettings();
  }

  Future<void> fetchNotificationSettings() async {
    getNotificationStatus.value = Status.loading;
    try {
      final result = await datasource.getNotificationSettings();
      if (result != null) {
        notificationSettingResponse.value = result;
        newNotification.value = result.data.settings.newEpisodes;
        newReleases.value = result.data.settings.newReleases;
        newRecomdation.value = result.data.settings.recommendations;
        getNotificationStatus.value = Status.success;
      } else {
        getNotificationStatus.value = Status.error;
      }
    } catch (e) {
      getNotificationStatus.value = Status.error;
      print("fetchNotificationSettings error: $e");
    } finally {
      getNotificationStatus.value = Status.init;
    }
  }

  void toggleNewEpisodes(bool value) async {
    final prev = newNotification.value;
    newNotification.value = value;
    final success = await _updateApiSettings();
    if (!success) {
      newNotification.value = prev;
    }
  }

  void toggleNewReleases(bool value) async {
    final prev = newReleases.value;
    newReleases.value = value;
    final success = await _updateApiSettings();
    if (!success) {
      newReleases.value = prev;
    }
  }

  void toggleRecommendations(bool value) async {
    final prev = newRecomdation.value;
    newRecomdation.value = value;
    final success = await _updateApiSettings();
    if (!success) {
      newRecomdation.value = prev;
    }
  }

  // Aliases for compatibility
  void setNewNotificationStatus(bool value) => toggleNewEpisodes(value);
  void setNewReleaseStatus(bool value) => toggleNewReleases(value);
  void setRecommendationStatus(bool value) => toggleRecommendations(value);

  Future<bool> _updateApiSettings() async {
    notificationSettingStatus.value = Status.loading;
    final payload = NotificationSettingsPayload(
      newEpisodes: newNotification.value,
      newReleases: newReleases.value,
      recommendations: newRecomdation.value,
    );
    try {
      final result = await datasource.updateNotification(payload: payload);
      if (result != null && result.success) {
        notificationSettingResponse.value = result;
        notificationSettingStatus.value = Status.success;
        AppSnackbar.success(
          result.message.isNotEmpty
              ? result.message
              : "Settings updated successfully",
        );
        return true;
      } else {
        notificationSettingStatus.value = Status.error;
        AppSnackbar.error(
          result?.message.isNotEmpty == true
              ? result!.message
              : "Failed to update notification settings",
        );
        return false;
      }
    } catch (e) {
      notificationSettingStatus.value = Status.error;
      AppSnackbar.error("Error updating settings: $e");
      return false;
    } finally {
      notificationSettingStatus.value = Status.init;
    }
  }
}
