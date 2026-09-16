import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../../constants/app_colors.dart';
import '../../../constants/app_images.dart';
import '../../../constants/app_sizes.dart';
import '../../../constants/app_text_styles.dart';
import '../../../shared/widgets/custom_animation.dart';
import '../../../shared/widgets/custom_buttons.dart';
import '../../../shared/widgets/custom_loading.dart';
import '../controller/auth_controller.dart';

class OtpVerifyScreen extends GetView<AuthController> {
  const OtpVerifyScreen({super.key});

  String _getMaskedPhoneSubtitle(String rawPhone) {
    final phone = rawPhone.trim();
    if (phone.isEmpty) {
      return "We've sent a 4-digit OTP to +91 73••••••77";
    }

    final parts = phone.split(' ');
    if (parts.length >= 2) {
      final countryCode = parts[0];
      final number = parts.sublist(1).join();
      if (number.length >= 4) {
        final prefix = number.substring(0, 2);
        final suffix = number.substring(number.length - 2);
        final bullets = '•' * (number.length - 4 > 0 ? (number.length - 4) : 6);
        return "We've sent a 4-digit OTP to $countryCode $prefix$bullets$suffix";
      }
    } else if (phone.length >= 6) {
      final prefix = phone.substring(0, 3);
      final suffix = phone.substring(phone.length - 2);
      final bullets = '•' * (phone.length - 5 > 0 ? (phone.length - 5) : 6);
      return "We've sent a 4-digit OTP to $prefix$bullets$suffix";
    }

    return "We've sent a 4-digit OTP to $phone";
  }

  @override
  Widget build(BuildContext context) {
    final phone = (Get.arguments as Map<String, dynamic>?)?['phone'] ?? '';

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: CustomScaffold(
        showAppBar: false,
        safeArea: false,
        backgroundColor: const Color(0xFF010101),
        resizeToAvoidBottomInset: true,
        body: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Stack(
            children: [
              // ── Background image
              Positioned.fill(
                child: Image.asset(
                  AppImages.bg,
                  fit: BoxFit.cover,
                  errorBuilder: (_, e, s) => const SizedBox.shrink(),
                ),
              ),

              // ── Gradient overlay
              Positioned.fill(
                child: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0x99010101), Color(0xF5161616)],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      stops: [0.0, 0.6],
                    ),
                  ),
                ),
              ),

              // ── Fixed Custom Back Button at Top-Left
              Positioned(
                left: AppSizes.p20,
                top: MediaQuery.of(context).padding.top + 16,
                child: CustomBackButton(onTap: () => Get.back()),
              ),

              // ── Vertically Centered Scrollable Content
              SafeArea(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return SingleChildScrollView(
                      physics: const ClampingScrollPhysics(),
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          minHeight: constraints.maxHeight,
                        ),
                        child: IntrinsicHeight(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppSizes.p24,
                              vertical: 24,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                // Heading
                                Text(
                                  'Verify your\nmobile number',
                                  style: AppTextStyles.text28Bold.copyWith(
                                    letterSpacing: -0.5,
                                    height: 1.25,
                                  ),
                                ),
                                AppSizes.vGap8,

                                // Subtitle with masked phone
                                Text(
                                  _getMaskedPhoneSubtitle(phone),
                                  style: AppTextStyles.text13.copyWith(
                                    color: const Color(0xFF8A8A8A),
                                    height: 1.4,
                                  ),
                                ),
                                const SizedBox(height: 20),

                                // OTP input boxes row
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  spacing: 15,
                                  children: List.generate(
                                    4,
                                    (i) => _OtpBox(
                                      controller: controller.otpControllers[i],
                                      focusNode: controller.otpFocusNodes[i],
                                      onChanged: (v) =>
                                          controller.onOtpDigitChanged(i, v),
                                      onBackspaceOnEmpty: () {
                                        if (i > 0) {
                                          controller.otpFocusNodes[i - 1]
                                              .requestFocus();
                                        }
                                      },
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 25),

                                // Verify & Continue button
                                Obx(
                                  () => AppButton(
                                    label: 'Verify & Continue',
                                    onPressed: controller.isOtpComplete.value
                                        ? controller.verifyOtp
                                        : null,
                                    isLoading: controller.isLoading.value,
                                    isEnabled: true,
                                    height: AppSizes.buttonHeight,
                                  ),
                                ),
                                AppSizes.vGap24,

                                // Resend text with countdown
                                Center(
                                  child: Obx(() {
                                    final seconds =
                                        controller.otpCountdown.value;
                                    if (seconds > 0) {
                                      return Text.rich(
                                        TextSpan(
                                          children: [
                                            TextSpan(
                                              text: "Didn't receive it? ",
                                              style: AppTextStyles.text13
                                                  .copyWith(
                                                    color: const Color(
                                                      0xFF8A8A8A,
                                                    ),
                                                  ),
                                            ),
                                            TextSpan(
                                              text:
                                                  'Resend again (${seconds}s)',
                                              style: AppTextStyles.text13Medium
                                                  .copyWith(
                                                    color: const Color(
                                                      0xFF6E6E6E,
                                                    ),
                                                  ),
                                            ),
                                          ],
                                        ),
                                      );
                                    }

                                    return GestureDetector(
                                      onTap: controller.resendOtp,
                                      child: Text.rich(
                                        TextSpan(
                                          children: [
                                            TextSpan(
                                              text: "Didn't receive it? ",
                                              style: AppTextStyles.text13
                                                  .copyWith(
                                                    color: const Color(
                                                      0xFF8A8A8A,
                                                    ),
                                                  ),
                                            ),
                                            TextSpan(
                                              text: 'Resend again',
                                              style: AppTextStyles
                                                  .text13SemiBold
                                                  .copyWith(
                                                    color: AppColors.primary,
                                                  ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  }),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

              // ── Custom Loading Overlay
              Obx(() {
                if (!controller.isLoading.value) return const SizedBox.shrink();
                return const LoadingOverlay(message: 'Verifying OTP...');
              }),
            ],
          ),
        ),
      ),
    );
  }
}

/// OTP digit box with auto-focus and styling
class _OtpBox extends StatelessWidget {
  const _OtpBox({
    required this.controller,
    required this.focusNode,
    required this.onChanged,
    this.onBackspaceOnEmpty,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final ValueChanged<String> onChanged;
  final VoidCallback? onBackspaceOnEmpty;

  @override
  Widget build(BuildContext context) {
    return Focus(
      onKeyEvent: (node, event) {
        if (event is KeyDownEvent &&
            event.logicalKey == LogicalKeyboardKey.backspace &&
            controller.text.isEmpty) {
          onBackspaceOnEmpty?.call();
          return KeyEventResult.handled;
        }
        return KeyEventResult.ignored;
      },
      child: SizedBox(
        width: 64,
        height: 64,
        child: TextField(
          controller: controller,
          focusNode: focusNode,
          textAlign: TextAlign.center,
          keyboardType: TextInputType.number,
          cursorColor: AppColors.primary,
          style: AppTextStyles.text24Bold.copyWith(
            color: Colors.white,
            letterSpacing: 1.0,
          ),
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(1),
          ],
          onChanged: (val) {
            onChanged(val);
          },
          decoration: InputDecoration(
            counterText: '',
            filled: true,
            fillColor: const Color(0xFF14141E),
            contentPadding: EdgeInsets.zero,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(
                color: Colors.white.withValues(alpha: 0.1),
                width: 1,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(
                color: Colors.white.withValues(alpha: 0.1),
                width: 1,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(
                color: AppColors.primary,
                width: 1.6,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
