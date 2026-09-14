import 'package:e_square_ott_app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../constants/app_colors.dart';
import '../../../constants/app_text_styles.dart';
import '../../../shared/widgets/custom_buttons.dart';
import '../controller/subscription_controller.dart';

class SubscriptionPage extends StatelessWidget {
  const SubscriptionPage({super.key});

  @override
  Widget build(BuildContext context) {
    final subController = Get.find<SubscriptionController>();

    return Scaffold(
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
                      Text(
                        'Premium\nMembership',
                        style: AppTextStyles.text20Bold.copyWith(
                          color: Colors.white,
                          height: 1.15,
                        ),
                      ),
                    ],
                  ),
                ),

                // ── Scrollable Body Content
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 8,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(height: 12),

                        // ── Main Headline
                        const Text(
                          'More stories.\nMore Entertainment.',
                          style: TextStyle(
                            fontFamily: AppTextStyles.fontFamily,
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                            height: 1.25,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 12),

                        // ── Subtitle
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                              style: TextStyle(
                                fontFamily: AppTextStyles.fontFamily,
                                color: const Color(0xFFA0A0B0),
                                fontSize: 13.5,
                                fontWeight: FontWeight.w400,
                                height: 1.45,
                              ),
                              children: const [
                                TextSpan(
                                  text:
                                      'Get unlimited access to the complete premium ',
                                ),
                                TextSpan(
                                  text: 'Entertainment\u00B2',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFFD0D0DE),
                                  ),
                                ),
                                TextSpan(
                                  text: ' library with one simple membership.',
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 28),

                        // ── Plan 1: Monthly Plan Card
                        Obx(() {
                          final isMonthly =
                              subController.selectedPlan.value ==
                              SubscriptionPlanType.monthly;
                          return PlanOptionCard(
                            title: 'Monthly Plan',
                            price: '₹199',
                            period: '/ month',
                            isSelected: isMonthly,
                            onTap: () => subController.selectPlan(
                              SubscriptionPlanType.monthly,
                            ),
                          );
                        }),
                        const SizedBox(height: 14),

                        // ── Plan 2: Yearly Plan Card
                        Obx(() {
                          final isYearly =
                              subController.selectedPlan.value ==
                              SubscriptionPlanType.yearly;
                          return PlanOptionCard(
                            title: 'Yearly Plan',
                            price: '₹1,499',
                            period: '/ year',
                            isSelected: isYearly,
                            onTap: () => subController.selectPlan(
                              SubscriptionPlanType.yearly,
                            ),
                          );
                        }),
                        const SizedBox(height: 24),

                        // ── Features 2x2 Grid
                        Row(
                          children: const [
                            Expanded(
                              child: SubscriptionFeatureCard(
                                icon: Icon(
                                  Icons.all_inclusive_rounded,
                                  color: Colors.white,
                                  size: 24,
                                ),
                                label: 'Unlimited episodes',
                              ),
                            ),
                            SizedBox(width: 12),
                            Expanded(
                              child: SubscriptionFeatureCard(
                                icon: _AdFreeIconBadge(),
                                label: 'Ad-free watching',
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: const [
                            Expanded(
                              child: SubscriptionFeatureCard(
                                icon: _HdIconBadge(),
                                label: 'High-quality\nstreaming',
                              ),
                            ),
                            SizedBox(width: 12),
                            Expanded(
                              child: SubscriptionFeatureCard(
                                icon: Icon(
                                  Icons.add_rounded,
                                  color: Colors.white,
                                  size: 24,
                                ),
                                label: 'New stories added\nregularly',
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 28),

                        // ── Action Button (Reusable AppButton)
                        Obx(() {
                          final isMonthly =
                              subController.selectedPlan.value ==
                              SubscriptionPlanType.monthly;
                          return AppButton(
                            label: isMonthly
                                ? 'Continue with Monthly'
                                : 'Continue with Yearly',
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

                        // ── Cancellation Disclaimer Note
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            'Cancel anytime. Your membership automatically renews unless cancelled before the renewal date.',
                            style: TextStyle(
                              fontFamily: AppTextStyles.fontFamily,
                              color: const Color(0xFF6E6E7E),
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              height: 1.4,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const SizedBox(height: 20),
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

/// Reusable Plan Selector Card Widget
class PlanOptionCard extends StatelessWidget {
  const PlanOptionCard({
    super.key,
    required this.title,
    required this.price,
    required this.period,
    required this.isSelected,
    required this.onTap,
  });

  final String title;
  final String price;
  final String period;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF140D10) : const Color(0xFF14141A),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected
                ? const Color(0xFFE42429)
                : const Color(0xFF262634),
            width: isSelected ? 1.6 : 1.0,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: const Color(0xFFE42429).withValues(alpha: 0.18),
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
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontFamily: AppTextStyles.fontFamily,
                    color: Colors.white,
                    fontSize: 19,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(
                      price,
                      style: const TextStyle(
                        fontFamily: AppTextStyles.fontFamily,
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      period,
                      style: const TextStyle(
                        fontFamily: AppTextStyles.fontFamily,
                        color: Color(0xFF8E8E9E),
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),

            // Radio Button Indicator
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
      width: 28,
      height: 28,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isSelected ? const Color(0xFF1E0E12) : Colors.transparent,
        border: Border.all(
          color: isSelected ? const Color(0xFFE42429) : const Color(0xFF383848),
          width: 2.0,
        ),
      ),
      child: Center(
        child: isSelected
            ? Container(
                width: 14,
                height: 14,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFFE42429),
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
    required this.label,
  });

  final Widget icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 82,
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
          Text(
            label,
            style: const TextStyle(
              fontFamily: AppTextStyles.fontFamily,
              color: Color(0xFFA0A0B0),
              fontSize: 12.5,
              fontWeight: FontWeight.w500,
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
      height: 22,
      child: Stack(
        alignment: Alignment.centerLeft,
        children: [
          const Text(
            'AD',
            style: TextStyle(
              fontFamily: AppTextStyles.fontFamily,
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.5,
            ),
          ),
          Positioned(
            left: 0,
            child: Transform.rotate(
              angle: -0.45,
              child: Container(
                width: 26,
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
      height: 22,
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          'HD',
          style: TextStyle(
            fontFamily: AppTextStyles.fontFamily,
            color: Colors.white,
            fontSize: 15,
            fontWeight: FontWeight.w800,
            letterSpacing: 0.5,
          ),
        ),
      ),
    );
  }
}
