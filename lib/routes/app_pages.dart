import 'package:e_square_ott_app/feature/profile/views/privacy_policy_screen.dart';
import 'package:e_square_ott_app/feature/profile/views/saved_series_screen.dart';
import 'package:e_square_ott_app/feature/profile/views/settings_screen.dart';
import 'package:e_square_ott_app/feature/profile/views/term_&_conditions_screen.dart';
import 'package:e_square_ott_app/feature/profile/views/watch_history_screen.dart';
import 'package:get/get.dart';
import '../feature/auth/bindings/auth_binding.dart';
import '../feature/auth/views/choose_interest_screen.dart';
import '../feature/auth/views/login_screen.dart';
import '../feature/auth/views/otp_verify_screen.dart';
import '../feature/auth/views/profile_setup_screen.dart';
import '../feature/explore/bindings/explore_binding.dart';
import '../feature/explore/views/explore_tab_view.dart';
import '../feature/home/bindings/home_binding.dart';
import '../feature/home/views/categories_screen.dart';
import '../feature/home/views/category_dramas_screen.dart';
import '../feature/home/views/continue_watching_screen.dart';
import '../feature/home/views/home_screen.dart';
import '../feature/home/views/new_releases_screen.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const initial = Routes.home;

  static final routes = <GetPage>[
    GetPage(
      name: Routes.login,
      page: () => const LoginScreen(),
      binding: AuthBinding(),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 300),
    ),
    GetPage(
      name: Routes.otpVerify,
      page: () => const OtpVerifyScreen(),
      binding: AuthBinding(),
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 300),
    ),
    GetPage(
      name: Routes.profileSetup,
      page: () => const ProfileSetupScreen(),
      binding: AuthBinding(),
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 300),
    ),
    GetPage(
      name: Routes.chooseInterest,
      page: () => const ChooseInterestScreen(),
      binding: AuthBinding(),
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 300),
    ),
    GetPage(
      name: Routes.home,
      page: () => const HomeScreen(),
      binding: HomeBinding(),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 300),
    ),
    GetPage(
      name: Routes.explore,
      page: () => const ExploreTabView(),
      binding: ExploreBinding(),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 300),
    ),
    GetPage(
      name: Routes.continueWatching,
      page: () => const ContinueWatchingScreen(),
      binding: HomeBinding(),
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 300),
    ),
    GetPage(
      name: Routes.categories,
      page: () => const CategoriesScreen(),
      binding: HomeBinding(),
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 300),
    ),
    GetPage(
      name: Routes.newReleases,
      page: () => const NewReleasesScreen(),
      binding: HomeBinding(),
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 300),
    ),
    GetPage(
      name: Routes.categoryDramas,
      page: () => const CategoryDramasScreen(),
      binding: HomeBinding(),
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 300),
    ),

    GetPage(
      name: Routes.savedSeries,
      page: () => const SavedSeriesScreen(),
      //  binding: HomeBinding(),
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 300),
    ),

    GetPage(
      name: Routes.settings,
      page: () => const SettingsScreen(),
      //  binding: HomeBinding(),
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 300),
    ),
    GetPage(
      name: Routes.watchHistory,
      page: () => const WatchHistoryScreen(),
      //  binding: HomeBinding(),
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 300),
    ),

    GetPage(
      name: Routes.privacyPolicy,
      page: () => const PrivacyPolicyScreen(),
      //  binding: HomeBinding(),
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 300),
    ),
    GetPage(
      name: Routes.termCondition,
      page: () => const TermsConditionsScreen(),
      //  binding: HomeBinding(),
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 300),
    ),
  ];
}
