import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../../models/response/redeem_voucher_response.dart';
import '../../../models/response/validate_voucher_response.dart';
import '../../../models/response/voucher_history_response.dart';
import '../../../shared/widgets/custom_sncakbar.dart';
import '../../profile/controller/profile_controller.dart';
import '../../subscription/controller/subscription_controller.dart';
import '../datasource/voucher_datasource.dart';

class VoucherController extends GetxController {
  final VoucherDatasource datasource = VoucherDatasource();

  // ── Form Controllers & State ──
  final TextEditingController codeController = TextEditingController();
  final RxInt selectedTabIndex = 0.obs; // 0: Redeem, 1: History

  // ── Loading Statuses ──
  final RxBool isValidating = false.obs;
  final RxBool isRedeeming = false.obs;
  final RxBool isLoadingHistory = false.obs;

  // ── Reactive Data ──
  final Rxn<ValidatedVoucherData> validatedVoucher = Rxn<ValidatedVoucherData>();
  final Rxn<RedeemedVoucherData> redeemedVoucher = Rxn<RedeemedVoucherData>();
  final RxList<VoucherHistoryItem> voucherHistoryList = <VoucherHistoryItem>[].obs;
  final RxString validationError = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchHistory();
  }

  @override
  void onClose() {
    codeController.dispose();
    super.onClose();
  }

  String _getUserPhoneNumber() {
    if (Get.isRegistered<ProfileController>()) {
      final prof = Get.find<ProfileController>();
      final phone = prof.profileData.value?.data?.user?.phoneNumber ??
          prof.userPhone.value;
      if (phone.isNotEmpty) return phone.replaceAll('+', '').trim();
    }
    return '';
  }

  /// Paste voucher code from clipboard
  Future<void> pasteFromClipboard() async {
    final data = await Clipboard.getData(Clipboard.kTextPlain);
    if (data?.text != null && data!.text!.trim().isNotEmpty) {
      codeController.text = data.text!.trim().toUpperCase();
      clearValidation();
      AppSnackbar.info('Pasted code from clipboard', title: 'Clipboard');
    }
  }

  /// Clear the validated preview
  void clearValidation() {
    validatedVoucher.value = null;
    validationError.value = '';
  }

  /// Validate voucher code
  Future<bool> validateVoucher({String? customCode}) async {
    final code = (customCode ?? codeController.text).trim().toUpperCase();
    if (code.isEmpty) {
      AppSnackbar.error('Please enter a voucher code', title: 'Code Required');
      return false;
    }

    isValidating.value = true;
    validationError.value = '';
    validatedVoucher.value = null;

    try {
      final res = await datasource.validateVoucher(code: code);
      isValidating.value = false;

      if (res != null && res.success && res.data != null) {
        validatedVoucher.value = res.data;
        codeController.text = res.data!.code;
        AppSnackbar.success(
          res.message.isNotEmpty ? res.message : 'Voucher is valid!',
          title: 'Valid Voucher',
        );
        return true;
      } else {
        validationError.value = res?.message ?? 'Invalid or expired voucher code';
        AppSnackbar.error(validationError.value, title: 'Voucher Invalid');
        return false;
      }
    } catch (e) {
      isValidating.value = false;
      validationError.value = 'Error validating voucher';
      AppSnackbar.error(validationError.value, title: 'Error');
      return false;
    }
  }

  /// Redeem voucher code to grant VIP access
  Future<bool> redeemVoucher({String? customCode}) async {
    final code = (customCode ?? codeController.text).trim().toUpperCase();
    if (code.isEmpty) {
      AppSnackbar.error('Please enter a voucher code', title: 'Code Required');
      return false;
    }

    isRedeeming.value = true;
    final phone = _getUserPhoneNumber();

    try {
      final res = await datasource.redeemVoucher(
        code: code,
        phoneNumber: phone.isNotEmpty ? phone : null,
      );

      isRedeeming.value = false;

      if (res != null && res.success && res.data != null) {
        redeemedVoucher.value = res.data;
        validatedVoucher.value = null;
        codeController.clear();

        // Refresh user's subscription and profile status
        if (Get.isRegistered<SubscriptionController>()) {
          final sub = Get.find<SubscriptionController>();
          sub.isSubscribed.value = true;
          await sub.userPlanStatus();
        }

        if (Get.isRegistered<ProfileController>()) {
          final prof = Get.find<ProfileController>();
          prof.isPremium.value = true;
          await prof.fetchProfile();
        }

        // Refresh history
        await fetchHistory();

        AppSnackbar.success(
          res.message.isNotEmpty
              ? res.message
              : 'Voucher redeemed successfully! VIP activated.',
          title: 'Congratulations!',
        );
        return true;
      } else {
        final errMsg = res?.message ?? 'Failed to redeem voucher';
        AppSnackbar.error(errMsg, title: 'Redemption Failed');
        return false;
      }
    } catch (e) {
      isRedeeming.value = false;
      AppSnackbar.error('An unexpected error occurred while redeeming voucher.', title: 'Error');
      return false;
    }
  }

  /// Fetch redemption history
  Future<void> fetchHistory() async {
    final phone = _getUserPhoneNumber();
    if (phone.isEmpty) return;

    isLoadingHistory.value = true;
    try {
      final res = await datasource.getVoucherHistory(phoneNumber: phone);
      isLoadingHistory.value = false;

      if (res != null && res.success && res.data != null) {
        voucherHistoryList.assignAll(res.data!.history);
      }
    } catch (e) {
      isLoadingHistory.value = false;
    }
  }
}
