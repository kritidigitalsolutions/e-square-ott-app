import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import '../../../constants/app_colors.dart';
import '../../../constants/app_text_styles.dart';
import '../../../constants/enum.dart';
import '../../../models/response/all_plans_model.dart';
import '../../../routes/app_pages.dart';
import '../../../shared/widgets/custom_animation.dart';
import '../../../shared/widgets/custom_buttons.dart';
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
                              children: [
                                const FaIcon(
                                  FontAwesomeIcons.crown,
                                  color: Color(0xFF0C0B10),
                                  size: 11,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  'ACTIVE VIP',
                                  style: const TextStyle(
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(height: 4),

                        // ── Main Headline
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

                        // ── Subtitle
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
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
                        Obx(() {
                          if (!subController.canClaimTrial ||
                              subController.isVip) {
                            return const SizedBox.shrink();
                          }
                          final isSelected =
                              subController.isTrialSelected.value;

                          return Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: GestureDetector(
                              onTap: subController.selectTrialOption,
                              behavior: HitTestBehavior.opaque,
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 220),
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  gradient: isSelected
                                      ? const LinearGradient(
                                          colors: [
                                            Color(0xFF281E08),
                                            Color(0xFF1E1708),
                                          ],
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                        )
                                      : const LinearGradient(
                                          colors: [
                                            Color(0xFF161622),
                                            Color(0xFF111118),
                                          ],
                                        ),
                                  borderRadius: BorderRadius.circular(18),
                                  border: Border.all(
                                    color: isSelected
                                        ? AppColors.primary
                                        : const Color(0xFF333346),
                                    width: isSelected ? 1.8 : 1.0,
                                  ),
                                  boxShadow: isSelected
                                      ? [
                                          BoxShadow(
                                            color: AppColors.primary.withValues(
                                              alpha: 0.25,
                                            ),
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 10,
                                            vertical: 4,
                                          ),
                                          decoration: BoxDecoration(
                                            gradient: AppColors.primaryGradient,
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                          ),
                                          child: const Text(
                                            '⚡ 7-DAY FREE TRIAL',
                                            style: TextStyle(
                                              fontFamily:
                                                  AppTextStyles.fontFamily,
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
                                            fontFamily:
                                                AppTextStyles.fontFamily,
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
                                            fontFamily:
                                                AppTextStyles.fontFamily,
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
                            ),
                          );
                        }),

                        // ── Active Plans List ──
                        Obx(() {
                          if (subController.allPlansStatus.value ==
                                  Status.loading &&
                              subController.plans.isEmpty) {
                            return const Padding(
                              padding: EdgeInsets.symmetric(vertical: 30),
                              child: Center(
                                child: CircularProgressIndicator(
                                  color: AppColors.primary,
                                  strokeWidth: 2.5,
                                ),
                              ),
                            );
                          }

                          final plans = subController.plans;
                          if (plans.isEmpty) {
                            return Padding(
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
                            );
                          }

                          final selected = subController.selectedPlan.value;
                          final isTrial = subController.isTrialSelected.value;

                          return Column(
                            children: plans.map((plan) {
                              final isSelected =
                                  !isTrial &&
                                  (selected?.id == plan.id ||
                                      selected?.code == plan.code);
                              final isUpgrade = subController.isUpgradePlan(
                                plan,
                              );
                              final stackedDays = isUpgrade
                                  ? subController.calculateStackedDays(plan)
                                  : null;

                              return Padding(
                                padding: const EdgeInsets.only(bottom: 12),
                                child: PlanOptionCard(
                                  plan: plan,
                                  isSelected: isSelected,
                                  isUpgrade: isUpgrade,
                                  stackedDays: stackedDays,
                                  remainingDays: subController.daysRemaining,
                                  onTap: () => subController.selectPlan(plan),
                                ),
                              );
                            }).toList(),
                          );
                        }),
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
                          children: [
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
                        const SizedBox(height: 24),

                        // ── Action Button (Continue to Pay / Upgrade)
                        Obx(() {
                          final isTrial = subController.isTrialSelected.value;
                          final selected = subController.selectedPlan.value;
                          final isUpgrade =
                              selected != null &&
                              subController.isUpgradePlan(selected);

                          String buttonLabel = 'Continue';
                          if (isTrial) {
                            buttonLabel = 'Start 7-Day Free Trial (₹2)';
                          } else if (isUpgrade && selected != null) {
                            buttonLabel =
                                'Upgrade to ${selected.name} (₹${selected.price.toInt()})';
                          } else if (selected != null) {
                            buttonLabel =
                                'Continue with ${selected.name} (₹${selected.price.toInt()})';
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
                        }),
                        const SizedBox(height: 14),

                        // ── UPI AutoPay & Zero-Grace Terms Note ──
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFF101017),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: const Color(0xFF1E1E28)),
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
                                '• Zero Grace Period: Plan expires immediately if payment renewal fails.',
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
}

/// Reusable Dynamic Plan Selector Card Widget
class PlanOptionCard extends StatelessWidget {
  const PlanOptionCard({
    super.key,
    required this.plan,
    required this.isSelected,
    required this.onTap,
    this.isUpgrade = false,
    this.stackedDays,
    this.remainingDays = 0,
  });

  final SubscriptionPlan plan;
  final bool isSelected;
  final bool isUpgrade;
  final int? stackedDays;
  final int remainingDays;
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
          color: isSelected ? const Color(0xFF1D1609) : const Color(0xFF14141C),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppColors.primary : const Color(0xFF262636),
            width: isSelected ? 1.8 : 1.0,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.22),
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
                              style: const TextStyle(
                                fontFamily: AppTextStyles.fontFamily,
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (plan.badge.isNotEmpty) ...[
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
                            style: const TextStyle(
                              fontFamily: AppTextStyles.fontFamily,
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            '/ ${plan.durationDays} days',
                            style: const TextStyle(
                              fontFamily: AppTextStyles.fontFamily,
                              color: Color(0xFF8E8E9E),
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

                // Radio Button Indicator
                _PlanRadioIndicator(isSelected: isSelected),
              ],
            ),

            // Time Stacking banner for Upgrade
            if (isUpgrade && stackedDays != null) ...[
              const SizedBox(height: 10),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E2818),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: const Color(0xFF4A8B3C),
                    width: 0.8,
                  ),
                ),
                child: Row(
                  children: [
                    const FaIcon(
                      FontAwesomeIcons.layerGroup,
                      color: Color(0xFF6BBA75),
                      size: 13,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Time Stacking: Remaining $remainingDays days + ${plan.durationDays} days = $stackedDays Days Total VIP!',
                        style: const TextStyle(
                          fontFamily: AppTextStyles.fontFamily,
                          color: Color(0xFF82DC8E),
                          fontSize: 11.5,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
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
