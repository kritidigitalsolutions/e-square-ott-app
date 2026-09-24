import 'package:e_square_ott_app/firebase_options.dart';
import 'package:e_square_ott_app/shared/service/notification_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'constants/app_colors.dart';
import 'core/localization/app_translations.dart';
import 'core/localization/locale_controller.dart';
import 'feature/subscription/controller/subscription_controller.dart';
import 'routes/app_pages.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    FirebaseMessaging.onBackgroundMessage(
      NotificationService.firebaseMessagingBackgroundHandler,
    );
    await NotificationService.initialize();
  } catch (e) {
    debugPrint("[Firebase Init Error]: $e");
  }

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
          useMaterial3: true,
          brightness: Brightness.dark,
          colorScheme: const ColorScheme.dark(
            primary: AppColors.primary,
            surface: AppColors.surface,
            onPrimary: Colors.white,
            onSurface: AppColors.textPrimary,
          ),
          scaffoldBackgroundColor: AppColors.background,
          fontFamily: 'Raleway',
          fontFamilyFallback: const [
            'Noto Sans Devanagari',
            'Noto Sans Tamil',
            'Noto Sans Telugu',
            'Noto Sans Kannada',
            'Noto Sans Malayalam',
            'Roboto',
            'sans-serif',
          ],
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          dividerColor: AppColors.divider,
          textSelectionTheme: const TextSelectionThemeData(
            cursorColor: AppColors.primary,
            // RED: selectionColor: Color(0x66E42429),
            selectionColor: Color(0x66FFB823),
            selectionHandleColor: AppColors.primary,
          ),
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.transparent,
            elevation: 0,
            scrolledUnderElevation: 0,
          ),
        ),
        translations: AppTranslations(),
        locale: localeController.currentLocale.value,
        fallbackLocale: const Locale('en', 'US'),
        builder: (context, child) {
          final isNonEnglish =
              localeController.currentLocale.value.languageCode != 'en';
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(
              textScaler: TextScaler.linear(isNonEnglish ? 0.90 : 1.0),
            ),
            child: child ?? const SizedBox.shrink(),
          );
        },
        // customTransition: FadeThroughPageTransition(),
        defaultTransition: Transition.native,
        transitionDuration: const Duration(milliseconds: 350),
        initialRoute: AppPages.initial,
        getPages: AppPages.routes,
      );
    });
  }
}
