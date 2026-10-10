import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../constants/app_colors.dart';
import '../../../constants/app_text_styles.dart';
import '../../../constants/enum.dart';
import '../../../models/response/all_plans_model.dart';
import '../../../routes/app_pages.dart';
import '../../../shared/widgets/custom_animation.dart';
import '../../../shared/widgets/custom_buttons.dart';
import '../../../shared/widgets/custom_sncakbar.dart';
import '../controller/subscription_controller.dart';

class SubscriptionPage extends StatelessWidget {
  const SubscriptionPage({super.key});

  @override
  Widget build(BuildContext context) {
    final subController = Get.find<SubscriptionController>();

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
                // ── Top Bar Header
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  child: Row(
                    children: [
                      CustomBackButton(onTap: () => Get.back()),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Text(
                          'VIP Membership'.tr,
                          style: AppTextStyles.text20Bold.copyWith(
                            color: Colors.white,
                            height: 1.15,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Obx(() {
                        if (subController.isVip) {
                          return Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 5,
                            ),
                            decoration: BoxDecoration(
                              gradient: AppColors.primaryGradient,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: const [
                                FaIcon(
                                  FontAwesomeIcons.crown,
                                  color: Color(0xFF0C0B10),
                                  size: 11,
                                ),
                                SizedBox(width: 4),
                                Text(
                                  'ACTIVE VIP',
                                  style: TextStyle(
                                    fontFamily: AppTextStyles.fontFamily,
                                    color: Color(0xFF0C0B10),
                                    fontSize: 10.5,
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: 0.4,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }
                        return const SizedBox.shrink();
                      }),
                    ],
                  ),
                ),

                // ── Scrollable Body Content
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 8,
                    ),
                    child: Obx(() {
                      final isUserVip = subController.isVip;

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(height: 4),

                          // ── Active VIP Subscription Card (When User already has active plan) ──
                          if (isUserVip) ...[
                            _ActiveSubscriptionCard(
                              subController: subController,
                            ),
                            const SizedBox(height: 16),
                          ] else ...[
                            // ── Main Headline for Non-VIP Users
                            const Text(
                              'Unlock All Stories.\nMore Entertainment.',
                              style: TextStyle(
                                fontFamily: AppTextStyles.fontFamily,
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.w800,
                                height: 1.25,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 8),

                            // ── Subtitle for Non-VIP Users
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                              ),
                              child: RichText(
                                textAlign: TextAlign.center,
                                text: const TextSpan(
                                  style: TextStyle(
                                    fontFamily: AppTextStyles.fontFamily,
                                    color: Color(0xFFA0A0B0),
                                    fontSize: 13.5,
                                    fontWeight: FontWeight.w400,
                                    height: 1.45,
                                  ),
                                  children: [
                                    TextSpan(text: 'Instant access to locked '),
                                    TextSpan(
                                      text: 'Episodes 4+',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        color: Colors.white,
                                      ),
                                    ),
                                    TextSpan(
                                      text:
                                          ', 1080p Full HD & 100% Ad-Free streaming.',
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),

                            // ── 7-Day Free Trial Banner (₹2 Token Mandate)
                            if (subController.canClaimTrial) ...[
                              _TrialBanner(subController: subController),
                              const SizedBox(height: 16),
                            ],
                          ],

                          // ── Plans List Header
                          if (isUserVip) ...[
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                  left: 4,
                                  bottom: 10,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: const [
                                    Text(
                                      'Subscription Plans',
                                      style: TextStyle(
                                        fontFamily: AppTextStyles.fontFamily,
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    SizedBox(height: 2),
                                    Text(
                                      'Plan changes & upgrades are disabled while subscription is active',
                                      style: TextStyle(
                                        fontFamily: AppTextStyles.fontFamily,
                                        color: Color(0xFF888898),
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],

                          // ── Plans List ──
                          if (subController.allPlansStatus.value ==
                                  Status.loading &&
                              subController.plans.isEmpty) ...[
                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 30),
                              child: Center(
                                child: CircularProgressIndicator(
                                  color: AppColors.primary,
                                  strokeWidth: 2.5,
                                ),
                              ),
                            ),
                          ] else if (subController.plans.isEmpty) ...[
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 20),
                              child: Column(
                                children: [
                                  const Text(
                                    'No plans available right now.',
                                    style: TextStyle(
                                      fontFamily: AppTextStyles.fontFamily,
                                      color: Color(0xFF9E9EAE),
                                      fontSize: 13.5,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  GestureDetector(
                                    onTap: () => subController.getAllPlans(),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 16,
                                        vertical: 8,
                                      ),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFF1F1F2C),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: const Text(
                                        'Retry',
                                        style: TextStyle(
                                          fontFamily: AppTextStyles.fontFamily,
                                          color: AppColors.primary,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 13,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ] else ...[
                            ...subController.plans.map((plan) {
                              final isCurrentActivePlan =
                                  isUserVip &&
                                  (plan.code == subController.currentPlanCode ||
                                      plan.name.toLowerCase() ==
                                          subController.currentPlanName
                                              .toLowerCase());

                              final isSelected =
                                  !isUserVip &&
                                  !subController.isTrialSelected.value &&
                                  (subController.selectedPlan.value?.id ==
                                          plan.id ||
                                      subController.selectedPlan.value?.code ==
                                          plan.code);

                              return Padding(
                                padding: const EdgeInsets.only(bottom: 12),
                                child: PlanOptionCard(
                                  plan: plan,
                                  isSelected: isCurrentActivePlan || isSelected,
                                  isCurrentActive: isCurrentActivePlan,
                                  isLocked: isUserVip && !isCurrentActivePlan,
                                  onTap: () {
                                    if (isUserVip) {
                                      AppSnackbar.warning(
                                        'You already have an active subscription. Plan changes or upgrades are not allowed.',
                                        title: 'Subscription Active',
                                      );
                                    } else {
                                      subController.selectPlan(plan);
                                    }
                                  },
                                ),
                              );
                            }),
                          ],
                          const SizedBox(height: 14),

                          // ── Features 2x2 Grid (VIP Fayde)
                          Row(
                            children: const [
                              Expanded(
                                child: SubscriptionFeatureCard(
                                  icon: FaIcon(
                                    FontAwesomeIcons.lockOpen,
                                    color: AppColors.primary,
                                    size: 19,
                                  ),
                                  title: 'Episodes 4+ Unlocked',
                                  label: 'Unlimited access to all episodes',
                                ),
                              ),
                              SizedBox(width: 10),
                              Expanded(
                                child: SubscriptionFeatureCard(
                                  icon: _AdFreeIconBadge(),
                                  title: '100% Ad-Free',
                                  label: 'Zero ads & uninterrupted binge',
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: const [
                              Expanded(
                                child: SubscriptionFeatureCard(
                                  icon: _HdIconBadge(),
                                  title: '1080p Full HD',
                                  label: 'Ultra high-definition video',
                                ),
                              ),
                              SizedBox(width: 10),
                              Expanded(
                                child: SubscriptionFeatureCard(
                                  icon: FaIcon(
                                    FontAwesomeIcons.wandMagicSparkles,
                                    color: AppColors.primary,
                                    size: 19,
                                  ),
                                  title: 'Early Access',
                                  label: 'New series released weekly',
                                ),
                              ),
                            ],
                          ),
                          // ── Redeem Gift Voucher Banner ──
                          GestureDetector(
                            onTap: () => Get.toNamed(Routes.redeemVoucher),
                            behavior: HitTestBehavior.opaque,
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 14,
                              ),
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [Color(0xFF221706), Color(0xFF16151E)],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: AppColors.primary.withValues(alpha: 0.35),
                                  width: 1.2,
                                ),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: 38,
                                    height: 38,
                                    decoration: BoxDecoration(
                                      color: AppColors.primary.withValues(alpha: 0.15),
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Center(
                                      child: FaIcon(
                                        FontAwesomeIcons.gift,
                                        color: AppColors.primary,
                                        size: 16,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: const [
                                        Text(
                                          'Have a Gift Voucher?',
                                          style: TextStyle(
                                            fontFamily: AppTextStyles.fontFamily,
                                            color: Colors.white,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                        SizedBox(height: 2),
                                        Text(
                                          'Redeem code for instant free VIP access',
                                          style: TextStyle(
                                            fontFamily: AppTextStyles.fontFamily,
                                            color: Color(0xFF9E9EAE),
                                            fontSize: 11.5,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const FaIcon(
                                    FontAwesomeIcons.chevronRight,
                                    color: AppColors.primary,
                                    size: 13,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),

                          // ── Bottom Action Button ──
                          if (isUserVip) ...[
                            // User is already VIP -> Show "Explore VIP Content" / "Start Watching"
                            AppButton(
                              label: 'Start Watching VIP Content',
                              icon: const FaIcon(
                                FontAwesomeIcons.play,
                                color: Color(0xFF0C0B10),
                                size: 14,
                              ),
                              onPressed: () {
                                if (Get.previousRoute.isNotEmpty &&
                                    Get.previousRoute !=
                                        Routes.subscriptionPage &&
                                    Get.previousRoute !=
                                        Routes.confirmSubscriptionPage) {
                                  Get.back();
                                } else {
                                  Get.offAllNamed(Routes.home);
                                }
                              },
                              backgroundColor: AppColors.primary,
                              height: 52,
                              borderRadius: 14,
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'Your VIP membership is active. Enjoy unlimited streaming!',
                              style: TextStyle(
                                fontFamily: AppTextStyles.fontFamily,
                                color: Color(0xFF888898),
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ] else ...[
                            // User does NOT have subscription -> Allow Continue to Confirm
                            Builder(
                              builder: (context) {
                                final isTrial =
                                    subController.isTrialSelected.value;
                                final selected =
                                    subController.selectedPlan.value;
                                final payable = subController.payableAmount.toInt();

                                String buttonLabel = 'Continue';
                                if (isTrial) {
                                  buttonLabel = 'Start 7-Day Free Trial (₹2)';
                                } else if (selected != null) {
                                  buttonLabel =
                                      'Continue with ${selected.name} (₹$payable)';
                                }

                                return AppButton(
                                  label: buttonLabel,
                                  onPressed: () {
                                    Get.toNamed(Routes.confirmSubscriptionPage);
                                  },
                                  isLoading: subController.isLoading.value,
                                  backgroundColor: AppColors.primary,
                                  height: 52,
                                  borderRadius: 14,
                                );
                              },
                            ),
                          ],
                          const SizedBox(height: 14),

                          // ── UPI AutoPay & Terms Note ──
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 12,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFF101017),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: const Color(0xFF1E1E28),
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                Text(
                                  '• Seamless recurring payments via Razorpay UPI AutoPay (PhonePe, Google Pay, Paytm).',
                                  style: TextStyle(
                                    fontFamily: AppTextStyles.fontFamily,
                                    color: Color(0xFF888898),
                                    fontSize: 11.5,
                                    height: 1.4,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  '• To cancel AutoPay, revoke mandate anytime in your UPI app (GPay / PhonePe / Paytm).',
                                  style: TextStyle(
                                    fontFamily: AppTextStyles.fontFamily,
                                    color: Color(0xFF888898),
                                    fontSize: 11.5,
                                    height: 1.4,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  '• Plan change and upgrades are locked during active subscription periods.',
                                  style: TextStyle(
                                    fontFamily: AppTextStyles.fontFamily,
                                    color: Color(0xFF888898),
                                    fontSize: 11.5,
                                    height: 1.4,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 24),
                        ],
                      );
                    }),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Active Subscription Card for Users with Active VIP Plan
class _ActiveSubscriptionCard extends StatelessWidget {
  const _ActiveSubscriptionCard({required this.subController});

  final SubscriptionController subController;

  @override
  Widget build(BuildContext context) {
    final planName = subController.currentPlanName.isNotEmpty
        ? subController.currentPlanName
        : (subController.selectedPlan.value?.name ?? 'VIP Membership');
    final daysRemaining = subController.daysRemaining;
    final expiresAt = subController.expiresAt;
    final isTrial = subController.isTrialActive;

    String expiryFormatted = '';
    if (expiresAt != null) {
      expiryFormatted = DateFormat('dd MMM yyyy').format(expiresAt);
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF261D0A), Color(0xFF181512), Color(0xFF121218)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.8),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.18),
            blurRadius: 20,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Header: Crown + Active Status
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      gradient: AppColors.primaryGradient,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withValues(alpha: 0.4),
                          blurRadius: 10,
                        ),
                      ],
                    ),
                    child: const Center(
                      child: FaIcon(
                        FontAwesomeIcons.crown,
                        color: Color(0xFF0C0B10),
                        size: 18,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Active Subscription',
                        style: TextStyle(
                          fontFamily: AppTextStyles.fontFamily,
                          color: AppColors.primary,
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.5,
                        ),
                      ),
                      Text(
                        planName,
                        style: const TextStyle(
                          fontFamily: AppTextStyles.fontFamily,
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E3A1E),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: const Color(0xFF43A047),
                    width: 0.8,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: const BoxDecoration(
                        color: Color(0xFF4CAF50),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 5),
                    Text(
                      isTrial ? 'TRIAL' : 'ACTIVE',
                      style: const TextStyle(
                        fontFamily: AppTextStyles.fontFamily,
                        color: Color(0xFF81C784),
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // ── Validity / Days Left Info Row
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: const Color(0xFF0E0E14),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFF222230)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const FaIcon(
                      FontAwesomeIcons.clockRotateLeft,
                      color: Color(0xFFA0A0B0),
                      size: 13,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      daysRemaining > 0
                          ? '$daysRemaining days remaining'
                          : 'Active',
                      style: const TextStyle(
                        fontFamily: AppTextStyles.fontFamily,
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                if (expiryFormatted.isNotEmpty)
                  Text(
                    'Expires: $expiryFormatted',
                    style: const TextStyle(
                      fontFamily: AppTextStyles.fontFamily,
                      color: Color(0xFF9E9EAE),
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // ── Warning / Restriction Notice (Cannot Change or Upgrade)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF2B1C10),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: const Color(0xFFD97706).withValues(alpha: 0.6),
                width: 1.0,
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.only(top: 2),
                  child: FaIcon(
                    FontAwesomeIcons.circleExclamation,
                    color: Color(0xFFFBBF24),
                    size: 15,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'Plan Change & Upgrade Disabled',
                        style: TextStyle(
                          fontFamily: AppTextStyles.fontFamily,
                          color: Color(0xFFFDE68A),
                          fontSize: 12.5,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'You already have an active subscription. You cannot change, repurchase, or upgrade your plan until your current period ends.',
                        style: TextStyle(
                          fontFamily: AppTextStyles.fontFamily,
                          color: Color(0xFFE5D4B8),
                          fontSize: 11.5,
                          height: 1.35,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// 7-Day Free Trial Banner Widget
class _TrialBanner extends StatelessWidget {
  const _TrialBanner({required this.subController});

  final SubscriptionController subController;

  @override
  Widget build(BuildContext context) {
    final isSelected = subController.isTrialSelected.value;

    return GestureDetector(
      onTap: subController.selectTrialOption,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: isSelected
              ? const LinearGradient(
                  colors: [Color(0xFF281E08), Color(0xFF1E1708)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : const LinearGradient(
                  colors: [Color(0xFF161622), Color(0xFF111118)],
                ),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: isSelected ? AppColors.primary : const Color(0xFF333346),
            width: isSelected ? 1.8 : 1.0,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.25),
                    blurRadius: 18,
                    spreadRadius: 1,
                  ),
                ]
              : null,
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
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    gradient: AppColors.primaryGradient,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    '⚡ 7-DAY FREE TRIAL',
                    style: TextStyle(
                      fontFamily: AppTextStyles.fontFamily,
                      color: Color(0xFF0C0B10),
                      fontSize: 11,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
                Text(
                  '₹2 Token Mandate',
                  style: TextStyle(
                    fontFamily: AppTextStyles.fontFamily,
                    color: isSelected
                        ? AppColors.primary
                        : const Color(0xFFE0E0EC),
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            const Text(
              'Pay ₹2 token today via UPI AutoPay (PhonePe/GPay). Full 7 days VIP access. Auto-debit of ₹99 starts on Day 7.',
              style: TextStyle(
                fontFamily: AppTextStyles.fontFamily,
                color: Color(0xFFB0B0C0),
                fontSize: 12.5,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: const [
                FaIcon(
                  FontAwesomeIcons.shieldHalved,
                  color: Color(0xFF6BBA75),
                  size: 12,
                ),
                SizedBox(width: 6),
                Text(
                  'Cancel anytime in UPI app before Day 7',
                  style: TextStyle(
                    fontFamily: AppTextStyles.fontFamily,
                    color: Color(0xFF6BBA75),
                    fontSize: 11.5,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Reusable Dynamic Plan Selector Card Widget
class PlanOptionCard extends StatelessWidget {
  const PlanOptionCard({
    super.key,
    required this.plan,
    required this.isSelected,
    required this.onTap,
    this.isCurrentActive = false,
    this.isLocked = false,
  });

  final SubscriptionPlan plan;
  final bool isSelected;
  final bool isCurrentActive;
  final bool isLocked;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: isCurrentActive
              ? const Color(0xFF221A08)
              : (isSelected
                    ? const Color(0xFF1D1609)
                    : (isLocked
                          ? const Color(0xFF101015)
                          : const Color(0xFF14141C))),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isCurrentActive
                ? AppColors.primary
                : (isSelected
                      ? AppColors.primary
                      : (isLocked
                            ? const Color(0xFF1C1C26)
                            : const Color(0xFF262636))),
            width: (isCurrentActive || isSelected) ? 1.8 : 1.0,
          ),
          boxShadow: (isCurrentActive || isSelected)
              ? [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.22),
                    blurRadius: 18,
                    spreadRadius: 1,
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Plan Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          plan.name,
                          style: TextStyle(
                            fontFamily: AppTextStyles.fontFamily,
                            color: isLocked
                                ? const Color(0xFF7E7E8E)
                                : Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (isCurrentActive) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            gradient: AppColors.primaryGradient,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Text(
                            'CURRENT PLAN',
                            style: TextStyle(
                              fontFamily: AppTextStyles.fontFamily,
                              color: Color(0xFF0C0B10),
                              fontSize: 10.5,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                      ] else if (plan.badge.isNotEmpty && !isLocked) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppColors.primary
                                : const Color(0xFF2A2A3C),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            plan.badge,
                            style: TextStyle(
                              fontFamily: AppTextStyles.fontFamily,
                              color: isSelected
                                  ? const Color(0xFF0C0B10)
                                  : const Color(0xFFE0E0EE),
                              fontSize: 10.5,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ] else if (isLocked) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFF1E1E28),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: const [
                              FaIcon(
                                FontAwesomeIcons.lock,
                                color: Color(0xFF888898),
                                size: 9,
                              ),
                              SizedBox(width: 4),
                              Text(
                                'LOCKED',
                                style: TextStyle(
                                  fontFamily: AppTextStyles.fontFamily,
                                  color: Color(0xFF888898),
                                  fontSize: 9.5,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text(
                        '₹${plan.price.toInt()}',
                        style: TextStyle(
                          fontFamily: AppTextStyles.fontFamily,
                          color: isLocked
                              ? const Color(0xFF888898)
                              : Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        '/ ${plan.durationDays} days',
                        style: TextStyle(
                          fontFamily: AppTextStyles.fontFamily,
                          color: isLocked
                              ? const Color(0xFF5E5E6E)
                              : const Color(0xFF8E8E9E),
                          fontSize: 13.5,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      if (plan.originalPrice > plan.price) ...[
                        const SizedBox(width: 8),
                        Text(
                          '₹${plan.originalPrice.toInt()}',
                          style: const TextStyle(
                            fontFamily: AppTextStyles.fontFamily,
                            color: Color(0xFF6E6E7E),
                            fontSize: 13.5,
                            fontWeight: FontWeight.w500,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),

            // Radio / Status Indicator
            if (isCurrentActive)
              Container(
                width: 26,
                height: 26,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.primary,
                ),
                child: const Center(
                  child: Icon(Icons.check, color: Color(0xFF0C0B10), size: 16),
                ),
              )
            else if (isLocked)
              Container(
                width: 26,
                height: 26,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFF1E1E28),
                ),
                child: const Center(
                  child: FaIcon(
                    FontAwesomeIcons.lock,
                    color: Color(0xFF6E6E7E),
                    size: 11,
                  ),
                ),
              )
            else
              _PlanRadioIndicator(isSelected: isSelected),
          ],
        ),
      ),
    );
  }
}

/// Custom Radio Button Indicator
class _PlanRadioIndicator extends StatelessWidget {
  const _PlanRadioIndicator({required this.isSelected});

  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: 26,
      height: 26,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isSelected ? const Color(0xFF261C0A) : Colors.transparent,
        border: Border.all(
          color: isSelected ? AppColors.primary : const Color(0xFF383848),
          width: 2.0,
        ),
      ),
      child: Center(
        child: isSelected
            ? Container(
                width: 13,
                height: 13,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.primary,
                ),
              )
            : null,
      ),
    );
  }
}

/// Reusable Subscription Feature Grid Item Card
class SubscriptionFeatureCard extends StatelessWidget {
  const SubscriptionFeatureCard({
    super.key,
    required this.icon,
    required this.title,
    required this.label,
  });

  final Widget icon;
  final String title;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 88),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF13131A),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFF22222E), width: 1.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          icon,
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(
              fontFamily: AppTextStyles.fontFamily,
              color: Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.w700,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(
              fontFamily: AppTextStyles.fontFamily,
              color: Color(0xFFA0A0B0),
              fontSize: 11,
              fontWeight: FontWeight.w400,
              height: 1.25,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

/// Custom Ad-Free Strikethrough Icon Badge
class _AdFreeIconBadge extends StatelessWidget {
  const _AdFreeIconBadge();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 20,
      child: Stack(
        alignment: Alignment.centerLeft,
        children: [
          const Text(
            'AD',
            style: TextStyle(
              fontFamily: AppTextStyles.fontFamily,
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.5,
            ),
          ),
          Positioned(
            left: 0,
            child: Transform.rotate(
              angle: -0.45,
              child: Container(
                width: 24,
                height: 2,
                decoration: BoxDecoration(
                  color: const Color(0xFFE42429),
                  borderRadius: BorderRadius.circular(1),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Custom HD Icon Badge
class _HdIconBadge extends StatelessWidget {
  const _HdIconBadge();

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: 20,
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          'HD',
          style: TextStyle(
            fontFamily: AppTextStyles.fontFamily,
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w800,
            letterSpacing: 0.5,
          ),
        ),
      ),
    );
  }
}
