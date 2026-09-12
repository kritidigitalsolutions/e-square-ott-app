import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../constants/app_colors.dart';
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
    Get.snackbar(
      'Subscription',
      'You are currently an active Premium Member.',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: const Color(0xFF1C1C1C),
      colorText: Colors.white,
    );
  }

  void openNotification() {
    Get.snackbar(
      'Notifications',
      'Opening your notifications inbox...',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: const Color(0xFF1C1C1C),
      colorText: Colors.white,
    );
  }

  void openSettings() {
    Get.toNamed(Routes.settings);
  }

  void openNotificationSettings() {
    Get.snackbar(
      'Notification Settings',
      'Opening push notification preferences...',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: const Color(0xFF1C1C1C),
      colorText: Colors.white,
    );
  }

  void openPrivacyPolicy() {
    Get.toNamed(Routes.privacyPolicy);
  }

  void openTermsAndConditions() {
    Get.toNamed(Routes.termCondition);
  }

  void showDeleteAccountDialog() {
    Get.dialog(
      Dialog(
        backgroundColor: const Color(0xFF1C1C24),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Delete Account',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Are you sure you want to delete your account? All your history, bookmarks, and subscription will be lost permanently.',
                style: TextStyle(
                  color: Color(0xFFA0A0B2),
                  fontSize: 13,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Get.back(),
                    child: const Text(
                      'Cancel',
                      style: TextStyle(color: Colors.white70),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () {
                      Get.back();
                      Get.offAllNamed(Routes.login);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Delete',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void logout() {
    Get.offAllNamed(Routes.login);
  }
}
