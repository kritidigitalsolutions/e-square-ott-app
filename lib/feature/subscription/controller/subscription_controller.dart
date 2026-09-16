import 'package:get/get.dart';
import '../../../shared/widgets/custom_sncakbar.dart';
import '../../profile/controller/profile_controller.dart';

enum SubscriptionPlanType { weekly, monthly, yearly }

class SubscriptionController extends GetxController {
  final RxBool isSubscribed = false.obs;
  final Rx<SubscriptionPlanType> currentPlan = SubscriptionPlanType.monthly.obs;
  Rx<SubscriptionPlanType> get selectedPlan => currentPlan;
  final RxString activePlanTitle = ''.obs;
  final RxString activePlanPrice = ''.obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    // Default initial state: unsubscribed
    isSubscribed.value = false;
  }

  bool get hasActiveSubscription => isSubscribed.value;

  /// Free users get first 3 episodes (Index 0, 1, 2).
  /// Subscribed users unlock all episodes (Index 3, 4, 5, 6, 7, ...).
  bool isEpisodeUnlocked(int episodeIndex) {
    if (isSubscribed.value) return true;
    return episodeIndex < 3;
  }

  /// Select a plan
  void selectPlan(SubscriptionPlanType plan) {
    currentPlan.value = plan;
  }

  /// Purchase / Subscribe action
  Future<bool> subscribe({SubscriptionPlanType? plan}) async {
    isLoading.value = true;
    final targetPlan = plan ?? currentPlan.value;

    // Simulate network delay for real feel
    await Future.delayed(const Duration(milliseconds: 600));

    isSubscribed.value = true;
    currentPlan.value = targetPlan;
    activePlanTitle.value = targetPlan == SubscriptionPlanType.monthly
        ? 'Monthly Plan'
        : 'Yearly Plan';
    activePlanPrice.value = targetPlan == SubscriptionPlanType.monthly
        ? '₹199 / month'
        : '₹1,499 / year';

    // Sync with ProfileController if registered
    if (Get.isRegistered<ProfileController>()) {
      Get.find<ProfileController>().isPremium.value = true;
    }

    isLoading.value = false;

    AppSnackbar.success(
      'You have unlocked unlimited access to all episodes and stories.',
      title: 'Subscription Activated',
    );

    return true;
  }

  /// Cancel subscription (for testing / account settings)
  void cancelSubscription() {
    isSubscribed.value = false;
    activePlanTitle.value = '';
    activePlanPrice.value = '';
    if (Get.isRegistered<ProfileController>()) {
      Get.find<ProfileController>().isPremium.value = false;
    }

    AppSnackbar.info(
      'Your membership has been cancelled.',
      title: 'Subscription Cancelled',
    );
  }
}
