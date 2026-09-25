import 'package:e_square_ott_app/constants/enum.dart';
import 'package:e_square_ott_app/feature/subscription/datasource/subscription_datasource.dart';
import 'package:e_square_ott_app/models/request/create_order_payload.dart';
import 'package:e_square_ott_app/models/request/verify_subscription_payload.dart';
import 'package:e_square_ott_app/models/response/all_plans_model.dart';
import 'package:e_square_ott_app/models/response/create_order_model.dart';
import 'package:e_square_ott_app/models/response/subscription_status_model.dart';
import 'package:e_square_ott_app/models/response/upgrade_order_response.dart';
import 'package:e_square_ott_app/models/response/verify_subscription_model.dart';
import 'package:get/get.dart';
import '../../../shared/widgets/custom_sncakbar.dart';
import '../../profile/controller/profile_controller.dart';

class SubscriptionController extends GetxController {
  final SubscriptionDatasource datasource = SubscriptionDatasource();

  // ── Reactive States ──
  final RxBool isSubscribed = false.obs;
  final RxBool isLoading = false.obs;

  // Selected Plan & Trial State
  final Rxn<SubscriptionPlan> selectedPlan = Rxn<SubscriptionPlan>();
  final RxBool isTrialSelected = false.obs;

  // API Responses
  final Rxn<SubscriptionPlansResponse> allPlanResponse =
      Rxn<SubscriptionPlansResponse>();
  final Rxn<SubscriptionStatusResponse> planStatusResponse =
      Rxn<SubscriptionStatusResponse>();
  final Rxn<CreateOrderResponse> createOrderResponse =
      Rxn<CreateOrderResponse>();
  final Rxn<UpgradeOrderResponse> upgradeOrderResponse =
      Rxn<UpgradeOrderResponse>();
  final Rxn<VerifySubscriptionResponse> verifyOrderResponse =
      Rxn<VerifySubscriptionResponse>();

  // API Statuses
  final Rx<Status> allPlansStatus = Status.init.obs;
  final Rx<Status> planStatusStatus = Status.init.obs;
  final Rx<Status> createOrderStatus = Status.init.obs;
  final Rx<Status> upgradeOrderStatus = Status.init.obs;
  final Rx<Status> verifyOrderStatus = Status.init.obs;

  // Form / Payload State Fields
  final RxString planId = "".obs;
  final RxBool isTrial = false.obs;
  final RxString orderId = "".obs;
  final RxString paymentId = "".obs;
  final RxString signature = "".obs;
  final RxString verifyPlanId = "".obs;
  final RxBool verifyIsTrial = false.obs;

  // ── Setters ──
  void setPlanId(String val) {
    planId.value = val;
  }

  void setIsTrial(bool val) {
    isTrial.value = val;
  }

  void setOrderId(String val) {
    orderId.value = val;
  }

  void setPaymentId(String val) {
    paymentId.value = val;
  }

  void setSignature(String val) {
    signature.value = val;
  }

  void setVerifyPlanId(String val) {
    verifyPlanId.value = val;
  }

  void setVerifyIsTrial(bool val) {
    verifyIsTrial.value = val;
  }

  // ── Legacy / UI helper getters ──
  String get activePlanTitle =>
      selectedPlan.value?.name ??
      (isVip ? (planStatusResponse.value?.data.planName ?? '') : '');

  String get activePlanPrice => selectedPlan.value != null
      ? '₹${selectedPlan.value!.price.toInt()}'
      : '';

  @override
  void onInit() {
    super.onInit();
    getAllPlans();
    userPlanStatus();
  }

  // ── Status Getters ──
  bool get isVip =>
      (planStatusResponse.value?.data.isVip ?? false) || isSubscribed.value;

  bool get isTrialActive =>
      planStatusResponse.value?.data.isTrial ?? false;

  int get daysRemaining =>
      planStatusResponse.value?.data.daysRemaining ?? 0;

  DateTime? get expiresAt => planStatusResponse.value?.data.expiresAt;

  String get currentPlanCode =>
      planStatusResponse.value?.data.planCode ?? '';

  String get currentPlanName =>
      planStatusResponse.value?.data.planName ?? '';

  bool get canClaimTrial =>
      planStatusResponse.value?.data.canClaimTrial ?? false;

  String get subscriptionState =>
      planStatusResponse.value?.data.status ?? (isVip ? 'ACTIVE' : 'EXPIRED');

  TrialConfig? get trialConfig => allPlanResponse.value?.data?.trialConfig;

  List<SubscriptionPlan> get plans =>
      allPlanResponse.value?.data?.plans ?? [];

  /// Free users get first 3 episodes (Index 0, 1, 2).
  /// VIP users unlock all episodes (Index 3, 4, 5, 6, 7, ...).
  bool isEpisodeUnlocked(int episodeIndex) {
    if (isVip) return true;
    return episodeIndex < 3;
  }

  /// Select a plan
  void selectPlan(SubscriptionPlan plan) {
    selectedPlan.value = plan;
    isTrialSelected.value = false;
    setPlanId(plan.id);
    setIsTrial(false);
  }

  /// Select 7-Day Free Trial (Rs. 2 Token Mandate)
  void selectTrialOption() {
    isTrialSelected.value = true;
    setIsTrial(true);
    final trialPlan = plans.firstWhereOrNull(
          (p) => p.trialEligible || p.code == 'PLAN_1M',
        ) ??
        plans.firstOrNull;
    if (trialPlan != null) {
      selectedPlan.value = trialPlan;
      setPlanId(trialPlan.id);
    }
  }

  /// Check if user is upgrading from their current active plan
  bool isUpgradePlan(SubscriptionPlan targetPlan) {
    if (!isVip) return false;
    if (currentPlanCode == 'PLAN_1M' &&
        (targetPlan.code == 'PLAN_6M' || targetPlan.code == 'PLAN_12M')) {
      return true;
    }
    if (currentPlanCode == 'PLAN_6M' && targetPlan.code == 'PLAN_12M') {
      return true;
    }
    return false;
  }

  /// Calculate Time Stacking info for upgrades
  int calculateStackedDays(SubscriptionPlan targetPlan) {
    final remaining = daysRemaining;
    return remaining + targetPlan.durationDays;
  }

  // ── Fetch All Plans API ──
  Future<void> getAllPlans() async {
    allPlansStatus.value = Status.loading;
    try {
      final res = await datasource.allPlans();
      if (res != null) {
        allPlanResponse.value = res;
        if (res.data?.plans.isNotEmpty == true && selectedPlan.value == null) {
          final popular = res.data!.plans.firstWhereOrNull(
                (p) => p.code == 'PLAN_6M' || p.code == 'PLAN_12M',
              ) ??
              res.data!.plans.first;
          selectPlan(popular);
        }
        allPlansStatus.value = Status.success;
      } else {
        allPlansStatus.value = Status.error;
      }
    } catch (e) {
      allPlansStatus.value = Status.error;
    }
  }

  // ── Fetch User VIP Status API ──
  Future<void> userPlanStatus() async {
    planStatusStatus.value = Status.loading;
    try {
      final res = await datasource.statusSubscription();
      if (res != null) {
        planStatusResponse.value = res;
        isSubscribed.value = res.data.isVip;
        planStatusStatus.value = Status.success;

        if (Get.isRegistered<ProfileController>()) {
          Get.find<ProfileController>().isPremium.value = res.data.isVip;
        }
      } else {
        planStatusStatus.value = Status.error;
      }
    } catch (e) {
      planStatusStatus.value = Status.error;
    }
  }

  // ── Create Order API (Direct call) ──
  Future<void> setCreateOrder() async {
    createOrderStatus.value = Status.loading;
    try {
      final targetPlanId = planId.value.isNotEmpty
          ? planId.value
          : (selectedPlan.value?.id ?? '');
      final targetIsTrial = isTrial.value || isTrialSelected.value;

      final payload = CreateOrderPayload(
        planId: targetPlanId,
        isTrial: targetIsTrial,
      );
      final res = await datasource.createOrder(payload: payload);
      if (res != null) {
        createOrderResponse.value = res;
        createOrderStatus.value = Status.success;
        setOrderId(res.data.orderId);
        setVerifyPlanId(targetPlanId);
        setVerifyIsTrial(targetIsTrial);
      } else {
        createOrderStatus.value = Status.error;
      }
    } catch (e) {
      createOrderStatus.value = Status.error;
    }
  }

  // ── Verify Order API (Direct call) ──
  Future<void> setVerifyOrder() async {
    verifyOrderStatus.value = Status.loading;
    try {
      final verify = VerifySubscriptionPayload(
        orderId: orderId.value,
        paymentId: paymentId.value,
        signature: signature.value,
        planId: verifyPlanId.value.isNotEmpty
            ? verifyPlanId.value
            : (selectedPlan.value?.id ?? ''),
        isTrial: verifyIsTrial.value,
      );
      final res = await datasource.verifySubscription(payload: verify);
      if (res != null && res.success) {
        verifyOrderResponse.value = res;
        verifyOrderStatus.value = Status.success;
        isSubscribed.value = true;
        await userPlanStatus();
        if (Get.isRegistered<ProfileController>()) {
          Get.find<ProfileController>().isPremium.value = true;
        }
      } else {
        verifyOrderStatus.value = Status.error;
      }
    } catch (e) {
      verifyOrderStatus.value = Status.error;
    }
  }

  // ── Upgrade Order API (Direct call) ──
  Future<void> setUpgradeOrder() async {
    upgradeOrderStatus.value = Status.loading;
    try {
      final targetPlanId = planId.value.isNotEmpty
          ? planId.value
          : (selectedPlan.value?.id ?? '');
      final res = await datasource.upgradePlan(id: targetPlanId);
      if (res != null) {
        upgradeOrderResponse.value = res;
        upgradeOrderStatus.value = Status.success;
        if (res.data != null) {
          setOrderId(res.data!.orderId);
          setVerifyPlanId(targetPlanId);
          setVerifyIsTrial(false);
        }
      } else {
        upgradeOrderStatus.value = Status.error;
      }
    } catch (e) {
      upgradeOrderStatus.value = Status.error;
    }
  }

  // ── Initiate Purchase / Order (UI Button trigger) ──
  Future<bool> initiatePurchase() async {
    final plan = selectedPlan.value;
    if (plan == null) {
      AppSnackbar.error(
        'Please select a plan to proceed.',
        title: 'Plan Required',
      );
      return false;
    }

    isLoading.value = true;
    try {
      final isUpgrade = isUpgradePlan(plan);

      if (isUpgrade) {
        setPlanId(plan.id);
        await setUpgradeOrder();
        if (upgradeOrderStatus.value == Status.success &&
            upgradeOrderResponse.value?.data != null) {
          final resData = upgradeOrderResponse.value!.data!;
          return await _processVerification(
            targetOrderId: resData.orderId,
            targetPlanId: plan.id,
            isTrialParam: false,
            stackedDays: resData.timeStacking?.totalNewDays,
          );
        } else {
          isLoading.value = false;
          AppSnackbar.error('Failed to initiate plan upgrade.', title: 'Error');
          return false;
        }
      } else {
        setPlanId(plan.id);
        setIsTrial(isTrialSelected.value);
        await setCreateOrder();
        if (createOrderStatus.value == Status.success &&
            createOrderResponse.value?.data != null) {
          final resData = createOrderResponse.value!.data;
          return await _processVerification(
            targetOrderId: resData.orderId,
            targetPlanId: plan.id,
            isTrialParam: isTrialSelected.value,
          );
        } else {
          isLoading.value = false;
          AppSnackbar.error('Failed to create order.', title: 'Error');
          return false;
        }
      }
    } catch (e) {
      isLoading.value = false;
      AppSnackbar.error(
        'Payment initiation failed. Please try again.',
        title: 'Error',
      );
      return false;
    }
  }

  Future<bool> _processVerification({
    required String targetOrderId,
    required String targetPlanId,
    required bool isTrialParam,
    int? stackedDays,
  }) async {
    verifyOrderStatus.value = Status.loading;
    try {
      setOrderId(targetOrderId);
      setPaymentId('pay_${DateTime.now().millisecondsSinceEpoch}');
      setSignature('sig_${DateTime.now().millisecondsSinceEpoch}');
      setVerifyPlanId(targetPlanId);
      setVerifyIsTrial(isTrialParam);

      await setVerifyOrder();

      if (verifyOrderStatus.value == Status.success) {
        isLoading.value = false;

        final successMsg = stackedDays != null
            ? 'Plan Upgraded! Total $stackedDays days VIP access stacked.'
            : (isTrialParam
                ? '7-Day Free Trial activated successfully!'
                : 'VIP Membership activated successfully!');

        AppSnackbar.success(successMsg, title: 'Success');
        return true;
      } else {
        isLoading.value = false;
        AppSnackbar.error('Payment verification failed.', title: 'Error');
        return false;
      }
    } catch (e) {
      verifyOrderStatus.value = Status.error;
      isLoading.value = false;
      AppSnackbar.error('Verification error occurred.', title: 'Error');
      return false;
    }
  }

  // ── Backward compatible subscribe method for existing views ──
  Future<bool> subscribe() async {
    return await initiatePurchase();
  }
}
