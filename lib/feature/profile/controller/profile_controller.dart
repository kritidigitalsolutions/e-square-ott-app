import 'package:e_square_ott_app/feature/notification/view/notification_page.dart';
import 'package:e_square_ott_app/feature/notification/view/notification_setting_page.dart';
import 'package:get/get.dart';
import '../../../routes/app_pages.dart';

class ProfileController extends GetxController {
  final RxString userName = 'Aryan'.obs;
  final RxString userEmail = 'aryan@example.com'.obs;
  final RxBool isPremium = true.obs;

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
    Get.to(NotificationPage());
  }

  void openSettings() {
    Get.toNamed(Routes.settings);
  }

  void openNotificationSettings() {
    Get.to(NotificationSettingPage());
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

  void logout() {
    Get.toNamed(Routes.logout);
  }
}
