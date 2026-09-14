import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LocaleController extends GetxController {
  final RxString currentLanguage = 'English'.obs;
  final Rx<Locale> currentLocale = const Locale('en', 'US').obs;

  static const List<String> supportedLanguages = ['English', 'Hindi', 'Punjabi'];

  @override
  void onInit() {
    super.onInit();
    // Default to English
    currentLanguage.value = 'English';
    currentLocale.value = const Locale('en', 'US');
  }

  void changeLanguage(String languageName) {
    currentLanguage.value = languageName;
    Locale newLocale;
    switch (languageName) {
      case 'Hindi':
        newLocale = const Locale('hi', 'IN');
        break;
      case 'Punjabi':
        newLocale = const Locale('pa', 'IN');
        break;
      case 'English':
      default:
        newLocale = const Locale('en', 'US');
        break;
    }
    currentLocale.value = newLocale;
    Get.updateLocale(newLocale);
  }
}
