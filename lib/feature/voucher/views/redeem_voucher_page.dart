import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../constants/app_colors.dart';
import '../../../constants/app_text_styles.dart';
import '../../../routes/app_pages.dart';
import '../../../shared/widgets/custom_animation.dart';
import '../../../shared/widgets/custom_buttons.dart';
import '../controller/voucher_controller.dart';

class RedeemVoucherPage extends StatelessWidget {
  const RedeemVoucherPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(VoucherController());

    return CustomScaffold(
      showAppBar: false,
      safeArea: false,
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // Background Gradient
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: AppColors.loginBgGradient,
              ),
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                // ── Top Header ──
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  child: Row(
                    children: [
                      CustomBackButton(onTap: () => Get.back()),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Redeem Voucher'.tr,
                              style: AppTextStyles.text20Bold.copyWith(
                                color: Colors.white,
                                height: 1.15,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'Claim your gift or promo VIP access'.tr,
                              style: AppTextStyles.text12Medium.copyWith(
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // ── Segmented Tab Selector ──
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Obx(() {
                    final selectedIndex = controller.selectedTabIndex.value;
                    return Container(
                      height: 48,
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: const Color(0xFF14141E),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.08),
                        ),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: _TabButton(
                              label: 'Redeem Voucher'.tr,
                              icon: FontAwesomeIcons.ticket,
                              isSelected: selectedIndex == 0,
                              onTap: () => controller.selectedTabIndex.value = 0,
                            ),
                          ),
                          Expanded(
                            child: _TabButton(
                              label: 'My History'.tr,
                              icon: FontAwesomeIcons.clockRotateLeft,
                              isSelected: selectedIndex == 1,
                              onTap: () {
                                controller.selectedTabIndex.value = 1;
                                controller.fetchHistory();
                              },
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ),

                // ── Tab Content Views ──
                Expanded(
                  child: Obx(() {
                    if (controller.selectedTabIndex.value == 0) {
                      return _RedeemFormView(controller: controller);
                    } else {
                      return _VoucherHistoryView(controller: controller);
                    }
                  }),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Tab Button Widget ──
class _TabButton extends StatelessWidget {
  final String label;
  final FaIconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _TabButton({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          gradient: isSelected ? AppColors.primaryGradient : null,
          borderRadius: BorderRadius.circular(10),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              FaIcon(
                icon,
                size: 13,
                color: isSelected ? const Color(0xFF0C0B10) : const Color(0xFF8E8E9E),
              ),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  fontFamily: AppTextStyles.fontFamily,
                  color: isSelected ? const Color(0xFF0C0B10) : const Color(0xFF8E8E9E),
                  fontSize: 13,
                  fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Redeem Form View ──
class _RedeemFormView extends StatelessWidget {
  final VoucherController controller;

  const _RedeemFormView({required this.controller});

  void _showSuccessDialog(BuildContext context) {
    final redeemed = controller.redeemedVoucher.value;
    if (redeemed == null) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 20),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: const Color(0xFF14141E),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: AppColors.primary.withValues(alpha: 0.6),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.35),
                blurRadius: 30,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Radiant Crown Icon
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: AppColors.primaryGradient,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.4),
                      blurRadius: 20,
                    ),
                  ],
                ),
                child: const Center(
                  child: FaIcon(
                    FontAwesomeIcons.crown,
                    color: Color(0xFF0C0B10),
                    size: 32,
                  ),
                ),
              ),
              const SizedBox(height: 20),

              Text(
                'VIP Pass Activated!'.tr,
                style: const TextStyle(
                  fontFamily: AppTextStyles.fontFamily,
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),

              Text(
                'Congratulations! Your ${redeemed.planName} (${redeemed.durationDays} Days) has been successfully activated.'
                    .tr,
                style: const TextStyle(
                  fontFamily: AppTextStyles.fontFamily,
                  color: Color(0xFFB0B0C4),
                  fontSize: 13.5,
                  height: 1.4,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),

              // Voucher Details Box
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFF0A0A10),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: const Color(0xFF242432)),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Voucher Code',
                          style: TextStyle(
                            fontFamily: AppTextStyles.fontFamily,
                            color: Color(0xFF7E7E94),
                            fontSize: 12,
                          ),
                        ),
                        Text(
                          redeemed.code,
                          style: const TextStyle(
                            fontFamily: AppTextStyles.fontFamily,
                            color: AppColors.primary,
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Access Granted',
                          style: TextStyle(
                            fontFamily: AppTextStyles.fontFamily,
                            color: Color(0xFF7E7E94),
                            fontSize: 12,
                          ),
                        ),
                        Text(
                          '${redeemed.durationDays} Days VIP',
                          style: const TextStyle(
                            fontFamily: AppTextStyles.fontFamily,
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              AppButton(
                label: 'Start Watching Now'.tr,
                onPressed: () {
                  Get.back(); // close dialog
                  Get.offAllNamed(Routes.home);
                },
                backgroundColor: AppColors.primary,
                height: 50,
                borderRadius: 14,
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Gift Banner Card ──
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF261D0C), Color(0xFF16151E)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: AppColors.primary.withValues(alpha: 0.35),
                width: 1.2,
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.15),
                  blurRadius: 20,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  width: 54,
                  height: 54,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: AppColors.primaryGradient,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.3),
                        blurRadius: 12,
                      ),
                    ],
                  ),
                  child: const Center(
                    child: FaIcon(
                      FontAwesomeIcons.gift,
                      color: Color(0xFF0C0B10),
                      size: 24,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Gift / Giveaway Pass'.tr,
                        style: const TextStyle(
                          fontFamily: AppTextStyles.fontFamily,
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Have a gift card, partner coupon, or giveaway code? Enter below to activate your VIP Pass.'
                            .tr,
                        style: const TextStyle(
                          fontFamily: AppTextStyles.fontFamily,
                          color: Color(0xFFB0B0C4),
                          fontSize: 12,
                          height: 1.35,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // ── Voucher Input Section ──
          Text(
            'Enter Voucher Code'.tr,
            style: const TextStyle(
              fontFamily: AppTextStyles.fontFamily,
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),

          Container(
            decoration: BoxDecoration(
              color: const Color(0xFF14141E),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.12),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                const Padding(
                  padding: EdgeInsets.only(left: 14, right: 8),
                  child: FaIcon(
                    FontAwesomeIcons.ticket,
                    color: AppColors.primary,
                    size: 16,
                  ),
                ),
                Expanded(
                  child: TextField(
                    controller: controller.codeController,
                    textCapitalization: TextCapitalization.characters,
                    style: const TextStyle(
                      fontFamily: AppTextStyles.fontFamily,
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.5,
                    ),
                    decoration: InputDecoration(
                      hintText: 'e.g. VIP1M-GIFT'.tr,
                      hintStyle: TextStyle(
                        fontFamily: AppTextStyles.fontFamily,
                        color: Colors.white.withValues(alpha: 0.3),
                        fontSize: 14,
                        letterSpacing: 1.0,
                        fontWeight: FontWeight.w500,
                      ),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 16,
                      ),
                    ),
                    onChanged: (_) => controller.clearValidation(),
                  ),
                ),

                // Paste button
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: GestureDetector(
                    onTap: controller.pasteFromClipboard,
                    behavior: HitTestBehavior.opaque,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF222230),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        'PASTE'.tr,
                        style: const TextStyle(
                          fontFamily: AppTextStyles.fontFamily,
                          color: AppColors.primary,
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // ── Validate & Redeem Buttons ──
          Obx(() {
            final isValidated = controller.validatedVoucher.value != null;
            final isValidating = controller.isValidating.value;
            final isRedeeming = controller.isRedeeming.value;

            return Column(
              children: [
                if (!isValidated) ...[
                  AppButton(
                    label: 'Verify Voucher'.tr,
                    onPressed: isValidating
                        ? null
                        : () => controller.validateVoucher(),
                    isLoading: isValidating,
                    backgroundColor: const Color(0xFF1E1E2C),
                    textColor: Colors.white,
                    height: 52,
                    borderRadius: 14,
                  ),
                  const SizedBox(height: 10),
                  AppButton(
                    label: 'Redeem Directly'.tr,
                    onPressed: isRedeeming
                        ? null
                        : () async {
                            final ok = await controller.redeemVoucher();
                            if (ok && context.mounted) {
                              _showSuccessDialog(context);
                            }
                          },
                    isLoading: isRedeeming,
                    backgroundColor: AppColors.primary,
                    height: 52,
                    borderRadius: 14,
                  ),
                ],
              ],
            );
          }),

          // ── Validated Voucher Preview Ticket ──
          Obx(() {
            final voucher = controller.validatedVoucher.value;
            if (voucher == null) return const SizedBox.shrink();

            final expiryFormatted = voucher.expiryDate != null
                ? DateFormat('dd MMM yyyy').format(voucher.expiryDate!)
                : 'Lifetime';

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 24),
                Text(
                  'Voucher Details'.tr,
                  style: const TextStyle(
                    fontFamily: AppTextStyles.fontFamily,
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 10),

                // Ticket Card
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color(0xFF14141E),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: AppColors.primary.withValues(alpha: 0.5),
                      width: 1.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.2),
                        blurRadius: 20,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 44,
                                height: 44,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: const Color(0xFF261D0C),
                                  border: Border.all(
                                    color: AppColors.primary,
                                    width: 1.5,
                                  ),
                                ),
                                child: const Center(
                                  child: FaIcon(
                                    FontAwesomeIcons.crown,
                                    color: AppColors.primary,
                                    size: 18,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    voucher.planName,
                                    style: const TextStyle(
                                      fontFamily: AppTextStyles.fontFamily,
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    '${voucher.durationDays} Days Full VIP Access',
                                    style: const TextStyle(
                                      fontFamily: AppTextStyles.fontFamily,
                                      color: Color(0xFF82DC8E),
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFF10B981).withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: const Color(0xFF10B981).withValues(alpha: 0.4),
                              ),
                            ),
                            child: const Text(
                              'VALID',
                              style: TextStyle(
                                fontFamily: AppTextStyles.fontFamily,
                                color: Color(0xFF10B981),
                                fontSize: 11,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      const Divider(color: Color(0xFF222230), height: 1),
                      const SizedBox(height: 14),

                      // Info Details Row
                      if (voucher.campaignName.isNotEmpty) ...[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Campaign',
                              style: TextStyle(
                                fontFamily: AppTextStyles.fontFamily,
                                color: Color(0xFF8E8E9E),
                                fontSize: 12.5,
                              ),
                            ),
                            Text(
                              voucher.campaignName,
                              style: const TextStyle(
                                fontFamily: AppTextStyles.fontFamily,
                                color: Colors.white,
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                      ],

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Expiry Date',
                            style: TextStyle(
                              fontFamily: AppTextStyles.fontFamily,
                              color: Color(0xFF8E8E9E),
                              fontSize: 12.5,
                            ),
                          ),
                          Text(
                            expiryFormatted,
                            style: const TextStyle(
                              fontFamily: AppTextStyles.fontFamily,
                              color: Colors.white,
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // Activate Button
                      AppButton(
                        label: 'Activate VIP Membership Now'.tr,
                        onPressed: controller.isRedeeming.value
                            ? null
                            : () async {
                                final ok = await controller.redeemVoucher(
                                  customCode: voucher.code,
                                );
                                if (ok && context.mounted) {
                                  _showSuccessDialog(context);
                                }
                              },
                        isLoading: controller.isRedeeming.value,
                        backgroundColor: AppColors.primary,
                        height: 52,
                        borderRadius: 14,
                      ),
                    ],
                  ),
                ),
              ],
            );
          }),
          const SizedBox(height: 32),

          // ── Instructions Section ──
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF0F0F16),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFF1E1E2C)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: const [
                    FaIcon(
                      FontAwesomeIcons.circleInfo,
                      color: Color(0xFF8E8E9E),
                      size: 14,
                    ),
                    SizedBox(width: 8),
                    Text(
                      'How Voucher Redemption Works',
                      style: TextStyle(
                        fontFamily: AppTextStyles.fontFamily,
                        color: Color(0xFFC0C0D4),
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                _buildStep(
                  stepNum: '1',
                  text: 'Enter your unique voucher or gift code received from promotions or campaigns.',
                ),
                const SizedBox(height: 8),
                _buildStep(
                  stepNum: '2',
                  text: 'Tap "Verify Voucher" to check plan duration and validity.',
                ),
                const SizedBox(height: 8),
                _buildStep(
                  stepNum: '3',
                  text: 'Tap "Activate VIP" to instantly unlock all premium episodes and series!',
                ),
              ],
            ),
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  Widget _buildStep({required String stepNum, required String text}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            color: const Color(0xFF1E1E2C),
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
          ),
          child: Center(
            child: Text(
              stepNum,
              style: const TextStyle(
                fontFamily: AppTextStyles.fontFamily,
                color: AppColors.primary,
                fontSize: 10.5,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontFamily: AppTextStyles.fontFamily,
              color: Color(0xFF8E8E9E),
              fontSize: 12,
              height: 1.35,
            ),
          ),
        ),
      ],
    );
  }
}

// ── Voucher History View ──
class _VoucherHistoryView extends StatelessWidget {
  final VoucherController controller;

  const _VoucherHistoryView({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoadingHistory.value &&
          controller.voucherHistoryList.isEmpty) {
        return const Center(
          child: CircularProgressIndicator(color: AppColors.primary),
        );
      }

      final list = controller.voucherHistoryList;

      if (list.isEmpty) {
        return RefreshIndicator(
          onRefresh: controller.fetchHistory,
          color: AppColors.primary,
          backgroundColor: const Color(0xFF14141E),
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(
              parent: BouncingScrollPhysics(),
            ),
            children: [
              const SizedBox(height: 80),
              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 70,
                      height: 70,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: const Color(0xFF1A1A26),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.08),
                        ),
                      ),
                      child: const Center(
                        child: FaIcon(
                          FontAwesomeIcons.ticket,
                          color: Color(0xFF6E6E82),
                          size: 28,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No Vouchers Redeemed Yet'.tr,
                      style: const TextStyle(
                        fontFamily: AppTextStyles.fontFamily,
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'When you redeem gift or promotional vouchers, they will appear here.'
                          .tr,
                      style: const TextStyle(
                        fontFamily: AppTextStyles.fontFamily,
                        color: Color(0xFF7E7E94),
                        fontSize: 12.5,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    GestureDetector(
                      onTap: () => controller.selectedTabIndex.value = 0,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          gradient: AppColors.primaryGradient,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          'Redeem a Voucher'.tr,
                          style: const TextStyle(
                            fontFamily: AppTextStyles.fontFamily,
                            color: Color(0xFF0C0B10),
                            fontSize: 13,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }

      return RefreshIndicator(
        onRefresh: controller.fetchHistory,
        color: AppColors.primary,
        backgroundColor: const Color(0xFF14141E),
        child: ListView.separated(
          physics: const AlwaysScrollableScrollPhysics(
            parent: BouncingScrollPhysics(),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          itemCount: list.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final item = list[index];
            final dateStr = item.redeemedAt != null
                ? DateFormat('dd MMM yyyy, hh:mm a').format(item.redeemedAt!)
                : 'Recently';

            return Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF14141E),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.08),
                  width: 1,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF201A10),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: AppColors.primary.withValues(alpha: 0.4),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const FaIcon(
                              FontAwesomeIcons.ticket,
                              color: AppColors.primary,
                              size: 11,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              item.code,
                              style: const TextStyle(
                                fontFamily: AppTextStyles.fontFamily,
                                color: AppColors.primary,
                                fontSize: 12,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 0.8,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF10B981).withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            FaIcon(
                              FontAwesomeIcons.check,
                              color: Color(0xFF10B981),
                              size: 10,
                            ),
                            SizedBox(width: 4),
                            Text(
                              'ACTIVATED',
                              style: TextStyle(
                                fontFamily: AppTextStyles.fontFamily,
                                color: Color(0xFF10B981),
                                fontSize: 10,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  Text(
                    item.planName,
                    style: const TextStyle(
                      fontFamily: AppTextStyles.fontFamily,
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),

                  Row(
                    children: [
                      Text(
                        '${item.durationDays} Days VIP',
                        style: const TextStyle(
                          fontFamily: AppTextStyles.fontFamily,
                          color: Color(0xFF82DC8E),
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      if (item.campaignName.isNotEmpty) ...[
                        const Text(
                          ' • ',
                          style: TextStyle(color: Color(0xFF6E6E82)),
                        ),
                        Text(
                          item.campaignName,
                          style: const TextStyle(
                            fontFamily: AppTextStyles.fontFamily,
                            color: Color(0xFF9E9EAE),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 8),

                  Text(
                    'Redeemed on $dateStr',
                    style: const TextStyle(
                      fontFamily: AppTextStyles.fontFamily,
                      color: Color(0xFF6E6E82),
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      );
    });
  }
}
