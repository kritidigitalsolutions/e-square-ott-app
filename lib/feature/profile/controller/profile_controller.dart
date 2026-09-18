import 'package:get/get.dart';
import '../../../constants/app_images.dart';
import '../../../routes/app_pages.dart';
import '../../../shared/widgets/custom_sncakbar.dart';
import '../../subscription/controller/subscription_controller.dart';

class SavedSeriesModel {
  final String id;
  final String title;
  final String category;
  final int episodes;
  final String posterAsset;
  final String views;

  const SavedSeriesModel({
    required this.id,
    required this.title,
    required this.category,
    required this.episodes,
    required this.posterAsset,
    required this.views,
  });
}

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
  final RxString userName = 'Aryan'.obs;
  final RxString userEmail = 'aryan@example.com'.obs;
  final RxBool isPremium = false.obs;

  // ── Saved Series Reactive List
  final RxList<SavedSeriesModel> savedSeriesList = <SavedSeriesModel>[
    const SavedSeriesModel(
      id: 'ss1',
      title: 'FATAL ATTRACTION: DARK MAFIA ROMANCE',
      category: 'Romance',
      episodes: 36,
      posterAsset: AppImages.banner1,
      views: '5.2k',
    ),
    const SavedSeriesModel(
      id: 'ss2',
      title: 'FROM DIVORCEE TO BILLIONAIRE BRIDE',
      category: 'Drama',
      episodes: 24,
      posterAsset: AppImages.banner2,
      views: '7.8k',
    ),
    const SavedSeriesModel(
      id: 'ss3',
      title: 'SECURITY GUARD KI CEO GF',
      category: 'Romance',
      episodes: 18,
      posterAsset: AppImages.banner3,
      views: '4.6k',
    ),
    const SavedSeriesModel(
      id: 'ss4',
      title: 'धोखा A DARK SIDE OF LOVE',
      category: 'Mystery',
      episodes: 28,
      posterAsset: AppImages.mysteryImage,
      views: '6.1k',
    ),
    const SavedSeriesModel(
      id: 'ss5',
      title: 'UNDERCOVER BOSS LADY',
      category: 'Action',
      episodes: 40,
      posterAsset: AppImages.actionImage,
      views: '3.9k',
    ),
  ].obs;

  // ── Watch History Reactive List
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
    if (Get.isRegistered<SubscriptionController>()) {
      final sub = Get.find<SubscriptionController>();
      isPremium.value = sub.isSubscribed.value;
      ever(sub.isSubscribed, (val) => isPremium.value = val);
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

  void logout() {
    Get.toNamed(Routes.logout);
  }

  // ── Saved Series Actions
  void removeSavedSeries(String id) {
    final item = savedSeriesList.firstWhereOrNull((e) => e.id == id);
    savedSeriesList.removeWhere((e) => e.id == id);
    AppSnackbar.info(
      '${item?.title ?? "Series"} has been removed from Saved Series.',
      title: 'Removed from List',
    );
  }

  void clearAllSavedSeries() {
    savedSeriesList.clear();
    AppSnackbar.info(
      'Saved Series list has been cleared.',
      title: 'List Cleared',
    );
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
