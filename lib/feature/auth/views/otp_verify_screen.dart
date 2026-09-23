import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../../constants/app_colors.dart';
import '../../../constants/app_images.dart';
import '../../../constants/app_sizes.dart';
import '../../../constants/app_text_styles.dart';
import '../../../constants/enum.dart';
import '../../../shared/widgets/custom_animation.dart';
import '../../../shared/widgets/custom_buttons.dart';
import '../controller/auth_controller.dart';

class OtpVerifyScreen extends GetView<AuthController> {
  const OtpVerifyScreen({super.key});

  String _getMaskedPhoneSubtitle(Map<String, dynamic>? args, AuthController controller) {
    final masked = (args?['maskedPhone'] as String?) ??
        controller.sendOtpResponse.value?.data.maskedNumber ??
        '';
    if (masked.isNotEmpty) {
      return "We've sent a 4-digit OTP to $masked";
    }

    final rawPhone = (args?['phone'] as String?) ??
        '${controller.countryCode.value} ${controller.phoneNumber.value}'.trim();

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
    final args = Get.arguments as Map<String, dynamic>?;

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
                                  'Verify your\nmobile number'.tr,
                                  style: AppTextStyles.text28Bold.copyWith(
                                    letterSpacing: -0.5,
                                    height: 1.25,
                                  ),
                                ),
                                AppSizes.vGap8,

                                // Subtitle with masked phone
                                Text(
                                  _getMaskedPhoneSubtitle(args, controller),
                                  style: AppTextStyles.text13.copyWith(
                                    color: const Color(0xFF8A8A8A),
                                    height: 1.4,
                                  ),
                                ),
                                const SizedBox(height: 28),

                                // OTP Pin input boxes row
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: List.generate(
                                    4,
                                    (i) => Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 6,
                                      ),
                                      child: _LuxuryOtpBox(
                                        controller:
                                            controller.otpControllers[i],
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
                                ),
                                const SizedBox(height: 32),

                                // Verify & Continue button
                                Obx(
                                  () => AppButton(
                                    label: 'Verify & Continue'.tr,
                                    onPressed: controller.isOtpComplete.value &&
                                            controller.verifyOtpStatus.value !=
                                                Status.loading
                                        ? controller.verifyOtp
                                        : null,
                                    isLoading:
                                        controller.verifyOtpStatus.value ==
                                            Status.loading,
                                    isEnabled: controller.isOtpComplete.value &&
                                        controller.verifyOtpStatus.value !=
                                            Status.loading,
                                    height: AppSizes.buttonHeight,
                                  ),
                                ),
                                AppSizes.vGap24,

                                // Resend text with countdown
                                Center(
                                  child: Obx(() {
                                    final seconds =
                                        controller.otpCountdown.value;
                                    final isResending =
                                        controller.resendOtpStatus.value ==
                                            Status.loading;

                                    if (isResending) {
                                      return Text(
                                        'Sending OTP...'.tr,
                                        style:
                                            AppTextStyles.text13Medium.copyWith(
                                          color: AppColors.primary,
                                        ),
                                      );
                                    }

                                    if (seconds > 0) {
                                      return Text.rich(
                                        TextSpan(
                                          children: [
                                            TextSpan(
                                              text: "Didn't receive it? ".tr,
                                              style: AppTextStyles.text13
                                                  .copyWith(
                                                    color: const Color(
                                                      0xFF8A8A8A,
                                                    ),
                                                  ),
                                            ),
                                            TextSpan(
                                              text:
                                                  '${"Resend again".tr} (${seconds}s)',
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
                                      onTap:
                                          controller.verifyOtpStatus.value ==
                                                      Status.loading ||
                                                  isResending
                                              ? null
                                              : controller.resendOtp,
                                      child: Text.rich(
                                        TextSpan(
                                          children: [
                                            TextSpan(
                                              text: "Didn't receive it? ".tr,
                                              style: AppTextStyles.text13
                                                  .copyWith(
                                                    color: const Color(
                                                      0xFF8A8A8A,
                                                    ),
                                                  ),
                                            ),
                                            TextSpan(
                                              text: 'Resend again'.tr,
                                              style: AppTextStyles
                                                  .text13SemiBold
                                                  .copyWith(
                                                    color: AppColors.primary,
                                                    fontWeight: FontWeight.w700,
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
            ],
          ),
        ),
      ),
    );
  }
}

/// Luxury OTP digit box with animated focus, gold glow, and haptic feedback
class _LuxuryOtpBox extends StatefulWidget {
  const _LuxuryOtpBox({
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
  State<_LuxuryOtpBox> createState() => _LuxuryOtpBoxState();
}

class _LuxuryOtpBoxState extends State<_LuxuryOtpBox> {
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    widget.focusNode.addListener(_handleFocusChange);
    widget.controller.addListener(_handleTextChange);
  }

  @override
  void dispose() {
    widget.focusNode.removeListener(_handleFocusChange);
    widget.controller.removeListener(_handleTextChange);
    super.dispose();
  }

  void _handleFocusChange() {
    if (mounted) {
      setState(() {
        _isFocused = widget.focusNode.hasFocus;
      });
    }
  }

  void _handleTextChange() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final hasText = widget.controller.text.isNotEmpty;

    return Focus(
      onKeyEvent: (node, event) {
        if (event is KeyDownEvent &&
            event.logicalKey == LogicalKeyboardKey.backspace &&
            widget.controller.text.isEmpty) {
          widget.onBackspaceOnEmpty?.call();
          return KeyEventResult.handled;
        }
        return KeyEventResult.ignored;
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOutCubic,
        width: 66,
        height: 66,
        decoration: BoxDecoration(
          color: _isFocused
              ? const Color(0xFF191724)
              : (hasText ? const Color(0xFF151420) : const Color(0xFF101018)),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: _isFocused
                ? AppColors.primary
                : (hasText
                      ? AppColors.primary.withValues(alpha: 0.6)
                      : Colors.white.withValues(alpha: 0.12)),
            width: _isFocused ? 1.8 : 1.2,
          ),
          boxShadow: [
            if (_isFocused)
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.35),
                blurRadius: 18,
                spreadRadius: 1,
                offset: const Offset(0, 2),
              )
            else if (hasText)
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.12),
                blurRadius: 10,
                offset: const Offset(0, 2),
              )
            else
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.4),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
          ],
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            TextField(
              controller: widget.controller,
              focusNode: widget.focusNode,
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
              cursorColor: AppColors.primary,
              cursorWidth: 2,
              cursorHeight: 24,
              cursorRadius: const Radius.circular(2),
              style: const TextStyle(
                fontFamily: AppTextStyles.fontFamily,
                fontSize: 26,
                fontWeight: FontWeight.w800,
                color: Colors.white,
                letterSpacing: 0,
              ),
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(1),
              ],
              onChanged: (val) {
                if (val.isNotEmpty) {
                  HapticFeedback.selectionClick();
                }
                widget.onChanged(val);
              },
              decoration: const InputDecoration(
                counterText: '',
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                contentPadding: EdgeInsets.zero,
              ),
            ),

            // Active bottom indicator bar when focused or filled
            Positioned(
              bottom: 8,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: _isFocused ? 20 : (hasText ? 14 : 0),
                height: 2.5,
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  borderRadius: BorderRadius.circular(2),
                  boxShadow: _isFocused
                      ? [
                          BoxShadow(
                            color: AppColors.primary.withValues(alpha: 0.8),
                            blurRadius: 4,
                          ),
                        ]
                      : null,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
