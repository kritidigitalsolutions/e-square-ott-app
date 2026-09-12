part of 'app_pages.dart';

abstract class Routes {
  Routes._();

  static const splash = _Paths.splash;
  static const login = _Paths.login;
  static const otpVerify = _Paths.otpVerify;
  static const profileSetup = _Paths.profileSetup;
  static const chooseInterest = _Paths.chooseInterest;
  static const home = _Paths.home;
  static const explore = _Paths.explore;
  static const continueWatching = _Paths.continueWatching;
  static const categories = _Paths.categories;
  static const newReleases = _Paths.newReleases;
  static const categoryDramas = _Paths.categoryDramas;
  static const savedSeries = _Paths.savedSeries;
  static const settings = _Paths.settings;
  static const watchHistory = _Paths.watchHistory;
  static const privacyPolicy = _Paths.privacyPolicy;
  static const termCondition = _Paths.termCondition;
}

abstract class _Paths {
  _Paths._();

  static const splash = '/splash';
  static const login = '/login';
  static const otpVerify = '/otp-verify';
  static const profileSetup = '/profile-setup';
  static const chooseInterest = '/choose-interest';
  static const home = '/home';
  static const explore = '/explore';
  static const continueWatching = '/continue-watching';
  static const categories = '/categories';
  static const newReleases = '/new-releases';
  static const categoryDramas = '/category-dramas';
  static const savedSeries = "/saved-series";
  static const settings = "/settings";
  static const watchHistory = "/watch-history";
  static const privacyPolicy = "/privacy-Policy";
  static const termCondition = "/term-Condition";
}
