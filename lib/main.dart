import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'constants/app_colors.dart';
import 'core/localization/app_translations.dart';
import 'core/localization/locale_controller.dart';
import 'feature/subscription/controller/subscription_controller.dart';
import 'routes/app_pages.dart';
import 'shared/widgets/custom_animation.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Get.put(SubscriptionController(), permanent: true);
  Get.put(LocaleController(), permanent: true);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final localeController = Get.find<LocaleController>();

    return Obx(() {
      return GetMaterialApp(
        title: 'E-Square OTT',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.dark(
            primary: AppColors.primary,
            surface: AppColors.surface,
          ),
          scaffoldBackgroundColor: AppColors.background,
          fontFamily: 'AfacadFlux',
        ),
        translations: AppTranslations(),
        locale: localeController.currentLocale.value,
        fallbackLocale: const Locale('en', 'US'),
        customTransition: FadeThroughPageTransition(),
        defaultTransition: Transition.native,
        transitionDuration: const Duration(milliseconds: 350),
        initialRoute: AppPages.initial,
        getPages: AppPages.routes,
      );
    });
  }
}
