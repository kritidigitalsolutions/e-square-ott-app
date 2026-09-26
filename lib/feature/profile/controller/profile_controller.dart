import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../constants/app_images.dart';
import '../../../constants/enum.dart';
import '../../../models/request/edit_profile_payload.dart';
import '../../../models/response/profile_model.dart';
import '../../../routes/app_pages.dart';
import '../../../shared/service/notification_service.dart';
import '../../../shared/service/storage_service.dart';
import '../../../shared/widgets/custom_sncakbar.dart';
import '../../auth/datasource/auth_datasource.dart';
import '../../subscription/controller/subscription_controller.dart';



class WatchHistoryItemModel {
  final String id;
  final String title;
  final String category;
  final int currentEpisode;
  final int totalEpisodes;
  final double progress;
  final String remainingTime;
  final String posterAsset;

  const WatchHistoryItemModel({
    required this.id,
    required this.title,
    required this.category,
    required this.currentEpisode,
    required this.totalEpisodes,
    required this.progress,
    required this.remainingTime,
    required this.posterAsset,
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
  final RxList<WatchHistoryItemModel> watchHistoryList =
      <WatchHistoryItemModel>[
        const WatchHistoryItemModel(
          id: 'wh1',
          title: 'FATAL ATTRACTION: DARK MAFIA ROMANCE',
          category: 'Romance',
          currentEpisode: 14,
          totalEpisodes: 36,
          progress: 0.72,
          remainingTime: '8 min left',
          posterAsset: AppImages.banner1,
        ),
        const WatchHistoryItemModel(
          id: 'wh2',
          title: 'FROM DIVORCEE TO BILLIONAIRE BRIDE',
          category: 'Drama',
          currentEpisode: 8,
          totalEpisodes: 24,
          progress: 0.45,
          remainingTime: '16 min left',
          posterAsset: AppImages.banner2,
        ),
        const WatchHistoryItemModel(
          id: 'wh3',
          title: 'SECURITY GUARD KI CEO GF',
          category: 'Romance',
          currentEpisode: 17,
          totalEpisodes: 18,
          progress: 0.94,
          remainingTime: '2 min left',
          posterAsset: AppImages.banner3,
        ),
        const WatchHistoryItemModel(
          id: 'wh4',
          title: 'ZINDA HOON MAIN: REVENGE',
          category: 'Thriller',
          currentEpisode: 4,
          totalEpisodes: 20,
          progress: 0.28,
          remainingTime: '22 min left',
          posterAsset: AppImages.thrillerImage,
        ),
      ].obs;

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
    } catch (e) {
      profileStatus.value = Status.error;
      print("fetchProfile error in ProfileController: $e");
    }
  }

  void openSavedSeries() {
    Get.toNamed(Routes.savedSeries);
  }

  void openWatchHistory() {
    Get.toNamed(Routes.watchHistory);
  }

  void openSubscription() {
    Get.toNamed(Routes.subscriptionPage);
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

  Future<void> performDeleteAccount() async {
    final success = await _datasource.deleteAccount();
    if (success) {
      await NotificationService.instance.unregisterTokenFromBackend();
      await StorageService.logout();
      userName.value = '';
      userEmail.value = '';
      userPhone.value = '';
      userAvatar.value = '';
      profileData.value = null;
      AppSnackbar.success('Account deleted successfully');
      Get.offAllNamed(Routes.login);
    } else {
      AppSnackbar.error('Failed to delete account. Please try again.');
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
  void removeWatchHistory(String id) {
    final item = watchHistoryList.firstWhereOrNull((e) => e.id == id);
    watchHistoryList.removeWhere((e) => e.id == id);
    AppSnackbar.info(
      '${item?.title ?? "Series"} removed from Watch History.',
      title: 'Removed from History',
    );
  }

  void clearAllWatchHistory() {
    watchHistoryList.clear();
    AppSnackbar.info(
      'Watch history has been cleared.',
      title: 'History Cleared',
    );
  }
}
