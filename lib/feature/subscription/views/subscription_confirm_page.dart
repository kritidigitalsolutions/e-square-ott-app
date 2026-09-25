import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import '../../../constants/app_colors.dart';
import '../../../constants/app_text_styles.dart';
import '../../../routes/app_pages.dart';
import '../../../shared/widgets/custom_animation.dart';
import '../../../shared/widgets/custom_bottomsheet.dart';
import '../../../shared/widgets/custom_buttons.dart';
import '../controller/subscription_controller.dart';

class SubscriptionConfirmPage extends StatefulWidget {
  const SubscriptionConfirmPage({super.key});

  /// Helper to show this confirmation as a bottom sheet
  static Future<T?> showBottomSheet<T>(BuildContext context) {
    return CustomBottomSheet.show<T>(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.8),
      child: const SubscriptionConfirmBottomSheetContent(),
    );
  }

  /// Helper to show this confirmation as a dialog
  static Future<T?> showConfirmDialog<T>(BuildContext context) {
    return showDialog<T>(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.8),
      builder: (context) => const Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: EdgeInsets.symmetric(horizontal: 20),
        child: SubscriptionConfirmCard(),
      ),
    );
  }

  @override
  State<SubscriptionConfirmPage> createState() =>
      _SubscriptionConfirmPageState();
}

class _SubscriptionConfirmPageState extends State<SubscriptionConfirmPage> {
  @override
  Widget build(BuildContext context) {
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
                // Top App Bar / Header
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  child: Row(
                    children: [
                      CustomBackButton(onTap: () => Get.back()),
                      const SizedBox(width: 14),
                      Text(
                        'Confirm Subscription',
                        style: AppTextStyles.text14Medium.copyWith(
                          color: AppColors.textSecondary,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ),

                // Main Center Content
                const Expanded(
                  child: Center(
                    child: SingleChildScrollView(
                      physics: BouncingScrollPhysics(),
                      padding: EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 16,
                      ),
                      child: SubscriptionConfirmCard(),
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

/// Subscription Confirm Card Widget
class SubscriptionConfirmCard extends StatefulWidget {
  const SubscriptionConfirmCard({super.key});

  @override
  State<SubscriptionConfirmCard> createState() =>
      _SubscriptionConfirmCardState();
}

class _SubscriptionConfirmCardState extends State<SubscriptionConfirmCard> {
  void _handlePayment() async {
    final subController = Get.find<SubscriptionController>();
    final success = await subController.initiatePurchase();

    if (success && mounted) {
      Get.until(
        (route) =>
            route.settings.name != Routes.confirmSubscriptionPage &&
            route.settings.name != Routes.subscriptionPage,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final subController = Get.find<SubscriptionController>();

    return Obx(() {
      final isTrial = subController.isTrialSelected.value;
      final selectedPlan = subController.selectedPlan.value;
      final isUpgrade =
          selectedPlan != null && subController.isUpgradePlan(selectedPlan);
      final stackedDays = isUpgrade && selectedPlan != null
          ? subController.calculateStackedDays(selectedPlan)
          : null;

      final planTitle = isTrial
          ? '7-Day Free Trial (₹2 Token)'
          : (selectedPlan?.name ?? 'VIP Membership');

      final payAmount = isTrial
          ? '₹2'
          : (selectedPlan != null ? '₹${selectedPlan.price.toInt()}' : '₹99');

      return Container(
        width: double.infinity,
        constraints: const BoxConstraints(maxWidth: 400),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 26),
        decoration: BoxDecoration(
          color: const Color(0xFF14141C),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: const Color(0xFF242432), width: 1.2),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.6),
              blurRadius: 30,
              spreadRadius: 4,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // ── Radiant Crown / Checkmark Badge
            Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF221706),
                border: Border.all(color: AppColors.primary, width: 2.0),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.35),
                    blurRadius: 20,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: const Center(
                child: FaIcon(
                  FontAwesomeIcons.crown,
                  color: AppColors.primary,
                  size: 30,
                ),
              ),
            ),
            const SizedBox(height: 18),

            // ── Title
            Text(
              isUpgrade ? 'Upgrade Membership' : 'Order Summary',
              style: const TextStyle(
                fontFamily: AppTextStyles.fontFamily,
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.w800,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),

            // ── Plan Breakdown Box
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF0E0E14),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFF20202C)),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Selected Plan',
                        style: TextStyle(
                          fontFamily: AppTextStyles.fontFamily,
                          color: Color(0xFF8E8E9E),
                          fontSize: 13,
                        ),
                      ),
                      Text(
                        planTitle,
                        style: const TextStyle(
                          fontFamily: AppTextStyles.fontFamily,
                          color: Colors.white,
                          fontSize: 13.5,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  const Divider(color: Color(0xFF20202C), height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Amount Payable',
                        style: TextStyle(
                          fontFamily: AppTextStyles.fontFamily,
                          color: Color(0xFF8E8E9E),
                          fontSize: 13,
                        ),
                      ),
                      Text(
                        payAmount,
                        style: const TextStyle(
                          fontFamily: AppTextStyles.fontFamily,
                          color: AppColors.primary,
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                  if (isTrial) ...[
                    const Divider(color: Color(0xFF20202C), height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text(
                          'Day 7 Auto-Debit',
                          style: TextStyle(
                            fontFamily: AppTextStyles.fontFamily,
                            color: Color(0xFF8E8E9E),
                            fontSize: 12.5,
                          ),
                        ),
                        Text(
                          '₹99 / month',
                          style: TextStyle(
                            fontFamily: AppTextStyles.fontFamily,
                            color: Color(0xFFC0C0D0),
                            fontSize: 12.5,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                  if (isUpgrade && stackedDays != null) ...[
                    const Divider(color: Color(0xFF20202C), height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Total Stacked Days',
                          style: TextStyle(
                            fontFamily: AppTextStyles.fontFamily,
                            color: Color(0xFF82DC8E),
                            fontSize: 12.5,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          '$stackedDays Days VIP',
                          style: const TextStyle(
                            fontFamily: AppTextStyles.fontFamily,
                            color: Color(0xFF82DC8E),
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 16),

            // ── AutoPay Info ──
            Row(
              children: [
                FaIcon(
                  FontAwesomeIcons.shield,
                  color: Color(0xFF6BBA75),
                  size: 14,
                ),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    '100% Secure payment via Razorpay UPI AutoPay (PhonePe, GPay, Paytm).',
                    style: TextStyle(
                      fontFamily: AppTextStyles.fontFamily,
                      color: Color(0xFF8E8E9E),
                      fontSize: 11.5,
                      height: 1.3,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // ── Primary Action: Pay Button
            AppButton(
              label: isTrial
                  ? 'Pay ₹2 & Start Trial'
                  : 'Pay $payAmount & Activate VIP',
              onPressed: subController.isLoading.value ? null : _handlePayment,
              isLoading: subController.isLoading.value,
              backgroundColor: AppColors.primary,
              height: 52,
              borderRadius: 14,
            ),
            const SizedBox(height: 12),

            // ── Secondary Action: Change Plan Button
            GestureDetector(
              onTap: () => Get.back(),
              behavior: HitTestBehavior.opaque,
              child: Container(
                height: 50,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color(0xFF1A1A24),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.1),
                    width: 1,
                  ),
                ),
                child: const Center(
                  child: Text(
                    'Change Plan',
                    style: TextStyle(
                      fontFamily: AppTextStyles.fontFamily,
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}

/// Subscription Confirm Bottom Sheet Layout
class SubscriptionConfirmBottomSheetContent extends StatelessWidget {
  const SubscriptionConfirmBottomSheetContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF0D0D12),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(28),
          topRight: Radius.circular(28),
        ),
      ),
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
      child: SafeArea(
        top: false,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Drag Handle bar
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: const Color(0xFF383844),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SubscriptionConfirmCard(),
            ],
          ),
        ),
      ),
    );
  }
}
