import 'package:e_square_ott_app/feature/home/views/drama_player_screen.dart';
import 'package:e_square_ott_app/feature/home/views/episode_completed_screen.dart';
import 'package:e_square_ott_app/feature/notification/view/notification_page.dart';
import 'package:e_square_ott_app/feature/notification/view/notification_setting_page.dart';
import 'package:e_square_ott_app/feature/profile/views/privacy_policy_screen.dart';
import 'package:e_square_ott_app/feature/profile/views/saved_series_screen.dart';
import 'package:e_square_ott_app/feature/profile/views/settings_screen.dart';
import 'package:e_square_ott_app/feature/profile/views/term_&_conditions_screen.dart';
import 'package:e_square_ott_app/feature/profile/views/watch_history_screen.dart';
import 'package:e_square_ott_app/feature/profile/views/logout_page.dart';
import 'package:e_square_ott_app/feature/profile/views/delete_account1.dart';
import 'package:e_square_ott_app/feature/profile/views/delete_account2.dart';
import 'package:e_square_ott_app/feature/subscription/views/subscription_confirm_page.dart';
import 'package:e_square_ott_app/feature/subscription/views/subscription_page.dart';
import 'package:animations/animations.dart';
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
import '../shared/widgets/custom_animation.dart';
import '../splash_page.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const initial = Routes.splash;

  static final routes = <GetPage>[
    GetPage(
      name: Routes.splash,
      page: () => const SplashPage(),
      customTransition: FadeThroughPageTransition(),
      transitionDuration: const Duration(milliseconds: 350),
    ),
    GetPage(
      name: Routes.login,
      page: () => const LoginScreen(),
      binding: AuthBinding(),
      customTransition: FadeThroughPageTransition(),
      transitionDuration: const Duration(milliseconds: 350),
    ),
    GetPage(
      name: Routes.otpVerify,
      page: () => const OtpVerifyScreen(),
      binding: AuthBinding(),
      customTransition: SharedAxisPageTransition(
        transitionType: SharedAxisTransitionType.horizontal,
      ),
      transitionDuration: const Duration(milliseconds: 350),
    ),
    GetPage(
      name: Routes.profileSetup,
      page: () => const ProfileSetupScreen(),
      binding: AuthBinding(),
      customTransition: SharedAxisPageTransition(
        transitionType: SharedAxisTransitionType.horizontal,
      ),
      transitionDuration: const Duration(milliseconds: 350),
    ),
    GetPage(
      name: Routes.chooseInterest,
      page: () => const ChooseInterestScreen(),
      binding: AuthBinding(),
      customTransition: SharedAxisPageTransition(
        transitionType: SharedAxisTransitionType.horizontal,
      ),
      transitionDuration: const Duration(milliseconds: 350),
    ),
    GetPage(
      name: Routes.home,
      page: () => const HomeScreen(),
      binding: HomeBinding(),
      customTransition: FadeThroughPageTransition(),
      transitionDuration: const Duration(milliseconds: 350),
    ),
    GetPage(
      name: Routes.explore,
      page: () => const ExploreTabView(),
      binding: ExploreBinding(),
      customTransition: FadeThroughPageTransition(),
      transitionDuration: const Duration(milliseconds: 350),
    ),
    GetPage(
      name: Routes.continueWatching,
      page: () => const ContinueWatchingScreen(),
      binding: HomeBinding(),
      customTransition: SharedAxisPageTransition(
        transitionType: SharedAxisTransitionType.horizontal,
      ),
      transitionDuration: const Duration(milliseconds: 350),
    ),
    GetPage(
      name: Routes.categories,
      page: () => const CategoriesScreen(),
      binding: HomeBinding(),
      customTransition: SharedAxisPageTransition(
        transitionType: SharedAxisTransitionType.horizontal,
      ),
      transitionDuration: const Duration(milliseconds: 350),
    ),
    GetPage(
      name: Routes.newReleases,
      page: () => const NewReleasesScreen(),
      binding: HomeBinding(),
      customTransition: SharedAxisPageTransition(
        transitionType: SharedAxisTransitionType.horizontal,
      ),
      transitionDuration: const Duration(milliseconds: 350),
    ),
    GetPage(
      name: Routes.categoryDramas,
      page: () => const CategoryDramasScreen(),
      binding: HomeBinding(),
      customTransition: SharedAxisPageTransition(
        transitionType: SharedAxisTransitionType.horizontal,
      ),
      transitionDuration: const Duration(milliseconds: 350),
    ),
    GetPage(
      name: Routes.savedSeries,
      page: () => const SavedSeriesScreen(),
      customTransition: SharedAxisPageTransition(
        transitionType: SharedAxisTransitionType.horizontal,
      ),
      transitionDuration: const Duration(milliseconds: 350),
    ),
    GetPage(
      name: Routes.settings,
      page: () => const SettingsScreen(),
      customTransition: SharedAxisPageTransition(
        transitionType: SharedAxisTransitionType.horizontal,
      ),
      transitionDuration: const Duration(milliseconds: 350),
    ),
    GetPage(
      name: Routes.watchHistory,
      page: () => const WatchHistoryScreen(),
      customTransition: SharedAxisPageTransition(
        transitionType: SharedAxisTransitionType.horizontal,
      ),
      transitionDuration: const Duration(milliseconds: 350),
    ),
    GetPage(
      name: Routes.privacyPolicy,
      page: () => const PrivacyPolicyScreen(),
      customTransition: SharedAxisPageTransition(
        transitionType: SharedAxisTransitionType.horizontal,
      ),
      transitionDuration: const Duration(milliseconds: 350),
    ),
    GetPage(
      name: Routes.termCondition,
      page: () => const TermsConditionsScreen(),
      customTransition: SharedAxisPageTransition(
        transitionType: SharedAxisTransitionType.horizontal,
      ),
      transitionDuration: const Duration(milliseconds: 350),
    ),
    GetPage(
      name: Routes.logout,
      page: () => const LogoutPage(),
      customTransition: FadeThroughPageTransition(),
      transitionDuration: const Duration(milliseconds: 300),
    ),
    GetPage(
      name: Routes.deleteAccount1,
      page: () => const DeleteAccount1(),
      customTransition: FadeThroughPageTransition(),
      transitionDuration: const Duration(milliseconds: 300),
    ),
    GetPage(
      name: Routes.deleteAccount2,
      page: () => const DeleteAccount2(),
      customTransition: SharedAxisPageTransition(
        transitionType: SharedAxisTransitionType.horizontal,
      ),
      transitionDuration: const Duration(milliseconds: 350),
    ),
    GetPage(
      name: Routes.subscriptionPage,
      page: () => const SubscriptionPage(),
      customTransition: SharedAxisPageTransition(
        transitionType: SharedAxisTransitionType.vertical,
      ),
      transitionDuration: const Duration(milliseconds: 350),
    ),
    GetPage(
      name: Routes.confirmSubscriptionPage,
      page: () => const SubscriptionConfirmPage(),
      customTransition: SharedAxisPageTransition(
        transitionType: SharedAxisTransitionType.horizontal,
      ),
      transitionDuration: const Duration(milliseconds: 350),
    ),
    GetPage(
      name: Routes.dramaPlayer,
      page: () => const DramaPlayerScreen(),
      customTransition: FadeThroughPageTransition(),
      transitionDuration: const Duration(milliseconds: 350),
    ),
    GetPage(
      name: Routes.notificationPage,
      page: () => const NotificationPage(),
      customTransition: SharedAxisPageTransition(
        transitionType: SharedAxisTransitionType.horizontal,
      ),
      transitionDuration: const Duration(milliseconds: 350),
    ),
    GetPage(
      name: Routes.notificationSetting,
      page: () => const NotificationSettingPage(),
      customTransition: SharedAxisPageTransition(
        transitionType: SharedAxisTransitionType.horizontal,
      ),
      transitionDuration: const Duration(milliseconds: 350),
    ),
    GetPage(
      name: Routes.episodeCompleted,
      page: () => const EpisodeCompletedScreen(),
      customTransition: FadeThroughPageTransition(),
      transitionDuration: const Duration(milliseconds: 350),
    ),
  ];
}
