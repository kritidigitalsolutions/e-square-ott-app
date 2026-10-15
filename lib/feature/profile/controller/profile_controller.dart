import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../constants/app_images.dart';
import '../../../constants/enum.dart';
import '../../../models/request/edit_profile_payload.dart';
import '../../../models/response/profile_model.dart';
import '../../../routes/app_pages.dart';
import '../../../shared/service/notification_service.dart';
import '../../../shared/service/storage_service.dart';
import '../../../shared/utils/log_util.dart';
import '../../../shared/widgets/custom_sncakbar.dart';
import '../../auth/datasource/auth_datasource.dart';
import '../../home/datasource/home_datasource.dart';
import '../../subscription/controller/subscription_controller.dart';
import '../../../models/response/watch_history_model.dart';



class WatchHistoryItemModel {
  final String id;
  final String dramaId;
  final String title;
  final String category;
  final int currentEpisode;
  final int totalEpisodes;
  final double progress;
  final String remainingTime;
  final String posterAsset;
  final String? posterUrl;
  final String relativeTime;

  const WatchHistoryItemModel({
    required this.id,
    this.dramaId = '',
    required this.title,
    required this.category,
    required this.currentEpisode,
    required this.totalEpisodes,
    required this.progress,
    required this.remainingTime,
    required this.posterAsset,
    this.posterUrl,
    this.relativeTime = '',
  });
}

class ProfileController extends GetxController {
  final AuthDatasource _datasource = AuthDatasource();
  final Rx<Status> profileStatus = Status.init.obs;
  final Rxn<ProfileResponseModel> profileData = Rxn<ProfileResponseModel>();

  final RxString userName = ''.obs;
  final RxString userEmail = ''.obs;
  final RxString userPhone = ''.obs;
  final RxString userAvatar = ''.obs;
  final RxBool isPremium = false.obs;

  // ── Edit Profile State
  final TextEditingController firstNameEditController = TextEditingController();
  final TextEditingController lastNameEditController = TextEditingController();
  final TextEditingController emailEditController = TextEditingController();
  final TextEditingController phoneEditController = TextEditingController();
  final Rx<Status> updateProfileStatus = Status.init.obs;
  final Rx<Status> watchHistoryStatus = Status.init.obs;
  final Rx<WatchHistorySummary?> watchHistorySummary = Rxn<WatchHistorySummary>();
  final RxList<WatchHistoryItemModel> watchHistoryList = <WatchHistoryItemModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchProfile();
    if (Get.isRegistered<SubscriptionController>()) {
      final sub = Get.find<SubscriptionController>();
      isPremium.value = sub.isSubscribed.value;
      ever(sub.isSubscribed, (val) => isPremium.value = val);
    }
  }

  Future<void> fetchProfile() async {
    profileStatus.value = Status.loading;
    try {
      final result = await _datasource.getProfile();
      if (result != null) {
        profileData.value = result;
        final user = result.data!.user;
        final full = user!.fullName.isNotEmpty
            ? user.fullName
            : '${user.firstName} ${user.lastName}'.trim();
        userName.value = full.isNotEmpty
            ? full
            : (user.phoneNumber.isNotEmpty ? user.phoneNumber : 'User');
        userEmail.value = (user.email != null && user.email!.isNotEmpty)
            ? user.email!
            : (user.phoneNumber.isNotEmpty
                  ? '${user.countryCode} ${user.phoneNumber}'
                  : '');
        userPhone.value = '${user.countryCode} ${user.phoneNumber}'.trim();
        userAvatar.value = user.avatarUrl;
        isPremium.value = user.isVip;
        profileStatus.value = Status.success;
      } else {
        profileStatus.value = Status.error;
      }
    } catch (e, stack) {
      profileStatus.value = Status.error;
      LogUtil.error("fetchProfile error in ProfileController: $e", name: "ProfileController", error: e, stackTrace: stack);
    }
  }

  void openSavedSeries() {
    Get.toNamed(Routes.savedSeries);
  }

  void openWatchHistory() {
    fetchWatchHistory();
    Get.toNamed(Routes.watchHistory);
  }

  void openSubscription() {
    Get.toNamed(Routes.subscriptionPage);
  }

  void openRedeemVoucher() {
    Get.toNamed(Routes.redeemVoucher);
  }

  void openNotification() {
    Get.toNamed(Routes.notificationPage);
  }

  void openSettings() {
    Get.toNamed(Routes.settings);
  }

  void openNotificationSettings() {
    Get.toNamed(Routes.notificationSetting);
  }

  void openPrivacyPolicy() {
    Get.toNamed(Routes.privacyPolicy);
  }

  void openTermsAndConditions() {
    Get.toNamed(Routes.termCondition);
  }

  void showDeleteAccountDialog() {
    Get.toNamed(Routes.deleteAccount1);
  }

  void openEditProfile() {
    final user = profileData.value?.data!.user;
    if (user != null) {
      firstNameEditController.text = user.firstName;
      lastNameEditController.text = user.lastName;
      emailEditController.text = user.email ?? '';
      phoneEditController.text = '${user.countryCode} ${user.phoneNumber}'
          .trim();
      userAvatar.value = user.avatarUrl;
    } else {
      final names = userName.value.split(' ');
      firstNameEditController.text = names.isNotEmpty ? names.first : '';
      lastNameEditController.text = names.length > 1
          ? names.sublist(1).join(' ')
          : '';
      emailEditController.text = userEmail.value;
      phoneEditController.text = userPhone.value;
    }
    Get.toNamed(Routes.editProfile);
  }

  Future<void> updateProfile() async {
    final first = firstNameEditController.text.trim();
    final last = lastNameEditController.text.trim();
    final em = emailEditController.text.trim();

    if (first.isEmpty) {
      AppSnackbar.error('First name cannot be empty');
      return;
    }

    updateProfileStatus.value = Status.loading;
    try {
      final payload = EditProfilePayload(
        firstName: first,
        lastName: last,
        email: em,
        avatarUrl: userAvatar.value,
      );

      final result = await _datasource.editProfile(payload: payload);

      if (result != null && result.success) {
        updateProfileStatus.value = Status.success;
        AppSnackbar.success(
          result.message.isNotEmpty
              ? result.message
              : 'Profile updated successfully',
        );
        await fetchProfile();
        Get.back();
      } else {
        updateProfileStatus.value = Status.error;
        AppSnackbar.error(
          result?.message.isNotEmpty == true
              ? result!.message
              : 'Failed to update profile. Please try again.',
        );
      }
    } catch (e) {
      updateProfileStatus.value = Status.error;
      AppSnackbar.error('Error updating profile: $e');
    } finally {
      updateProfileStatus.value = Status.init;
    }
  }

  void logout() {
    Get.toNamed(Routes.logout);
  }

  Future<void> performLogout() async {
    await NotificationService.instance.unregisterTokenFromBackend();
    await StorageService.logout();
    userName.value = '';
    userEmail.value = '';
    userPhone.value = '';
    userAvatar.value = '';
    profileData.value = null;
    AppSnackbar.success('Logged out successfully');
    Get.offAllNamed(Routes.login);
  }

  Future<void> performDeleteAccount({String? reason, String? feedback}) async {
    final result = await _datasource.requestAccountDeletion(
      reason: reason,
      feedback: feedback,
    );
    if (result != null && result['success'] == true) {
      await fetchProfile();
      AppSnackbar.success(
        'Your account deletion request has been sent. Your account will be verified and deleted within 24 hours by an administrator.'.tr,
        title: 'Deletion Requested'.tr,
      );
      Get.back();
    } else {
      AppSnackbar.error('Failed to submit deletion request. Please try again.'.tr);
    }
  }

  Future<void> cancelDeletionRequest() async {
    final success = await _datasource.cancelAccountDeletionRequest();
    if (success) {
      await fetchProfile();
      AppSnackbar.success(
        'Your account deletion request has been cancelled. Your account remains active.'.tr,
        title: 'Request Cancelled'.tr,
      );
    } else {
      AppSnackbar.error('Failed to cancel deletion request. Please try again.'.tr);
    }
  }

  @override
  void onClose() {
    firstNameEditController.dispose();
    lastNameEditController.dispose();
    emailEditController.dispose();
    phoneEditController.dispose();
    super.onClose();
  }



  // ── Watch History Actions
  Future<void> fetchWatchHistory() async {
    watchHistoryStatus.value = Status.loading;
    try {
      final res = await HomeDatasource().getWatchHistory(pageNo: 1, limit: 50);
      if (res != null && res.success) {
        watchHistorySummary.value = res.data.summary;
        final mapped = res.data.history.map((it) {
          final progress = (it.playback.progressPercentage / 100.0).clamp(0.0, 1.0);
          final remSeconds = it.playback.remainingSeconds;
          final remTime = it.playback.formattedRemaining.isNotEmpty
              ? it.playback.formattedRemaining
              : (remSeconds > 0 ? '${(remSeconds / 60).ceil()} min left' : 'Completed');

          return WatchHistoryItemModel(
            id: it.id.isNotEmpty ? it.id : it.historyId,
            dramaId: it.drama.id,
            title: it.drama.title,
            category: it.drama.genreDisplay.isNotEmpty
                ? it.drama.genreDisplay
                : (it.drama.genres.isNotEmpty ? it.drama.genres.join(' / ') : 'Drama'),
            currentEpisode: it.episode.episodeNumber,
            totalEpisodes: it.drama.totalEpisodes,
            progress: progress,
            remainingTime: remTime,
            posterAsset: AppImages.banner1,
            posterUrl: it.drama.posterUrl.isNotEmpty ? it.drama.posterUrl : null,
            relativeTime: it.timeline.relativeTime,
          );
        }).toList();

        watchHistoryList.assignAll(mapped);
        watchHistoryStatus.value = Status.success;
      } else {
        watchHistoryStatus.value = Status.success;
      }
    } catch (e, stack) {
      LogUtil.error("fetchWatchHistory error: $e", name: "ProfileController", error: e, stackTrace: stack);
      watchHistoryStatus.value = Status.error;
    }
  }

  void removeWatchHistory(String id) async {
    final item = watchHistoryList.firstWhereOrNull((e) => e.id == id);
    watchHistoryList.removeWhere((e) => e.id == id);
    HomeDatasource().deleteWatchHistoryItem(id);
    AppSnackbar.info(
      '${item?.title ?? "Series"} removed from Watch History.',
      title: 'Removed from History',
    );
  }

  void clearAllWatchHistory() async {
    watchHistoryList.clear();
    HomeDatasource().clearAllWatchHistory();
    AppSnackbar.info(
      'Watch history has been cleared.',
      title: 'History Cleared',
    );
  }
}
