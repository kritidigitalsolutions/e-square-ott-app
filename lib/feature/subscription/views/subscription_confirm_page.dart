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
                        'Entertainment Square',
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
    final success = await subController.subscribe();

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

    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(maxWidth: 400),
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 30),
      decoration: BoxDecoration(
        color: const Color(0xFF14141A),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: const Color(0xFF22222E), width: 1.2),
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
          const SizedBox(height: 8),

          // ── Glowing Radiant Checkmark Icon Badge
          Container(
            width: 76,
            height: 76,
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
                FontAwesomeIcons.check,
                color: Colors.white,
                size: 34,
              ),
            ),
          ),
          const SizedBox(height: 22),

          // ── Title
          const Text(
            'Membership Selected',
            style: TextStyle(
              fontFamily: AppTextStyles.fontFamily,
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.2,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),

          // ── Subtitle / Description
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                style: const TextStyle(
                  fontFamily: AppTextStyles.fontFamily,
                  color: Color(0xFF9E9EA8),
                  fontSize: 14.0,
                  fontWeight: FontWeight.w400,
                  height: 1.45,
                ),
                children: [
                  const TextSpan(text: 'Your '),
                  const TextSpan(
                    text: 'Entertainment\u00B2',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Color(0xFFD0D0DE),
                    ),
                  ),
                  TextSpan(
                    text:
                        ' ${subController.selectedPlan.value == SubscriptionPlanType.monthly ? "Monthly (₹199/mo)" : "Yearly (₹1,499/yr)"} membership is ready. Complete payment to unlock the full library.',
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 30),

          // ── Primary Action: Continue to Pay Button (Using AppButton)
          Obx(() {
            return AppButton(
              label: 'Continue to Pay',
              onPressed: subController.isLoading.value ? null : _handlePayment,
              isLoading: subController.isLoading.value,
              backgroundColor: AppColors.primary,
              height: 52,
              borderRadius: 14,
            );
          }),
          const SizedBox(height: 14),

          // ── Secondary Action: Change Plan Button
          GestureDetector(
            onTap: () => Get.back(),
            behavior: HitTestBehavior.opaque,
            child: Container(
              height: 52,
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
                    fontSize: 15.5,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 6),
        ],
      ),
    );
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
