import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import '../../../constants/app_colors.dart';
import '../../../constants/app_images.dart';
import '../../../constants/app_sizes.dart';
import '../../../constants/app_text_styles.dart';
import '../../../shared/widgets/custom_buttons.dart';
import '../controller/auth_controller.dart';

class LoginScreen extends GetView<AuthController> {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Rebuilds automatically when keyboard opens/closes (MediaQuery changes)
    final keyboardOpen = MediaQuery.of(context).viewInsets.bottom > 50;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: const Color(0xFF010101),
        resizeToAvoidBottomInset: true,
        body: GestureDetector(
          onTap: () {
            controller.phoneFocusNode.unfocus();
            controller.closeDropdown();
          },
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

              // ── Main content
              // SafeArea + Column with Expanded gives SingleChildScrollView
              // a bounded height — the ONLY correct way to fix scroll in a Column.
              SafeArea(
                child: Obx(() {
                  // Compact mode: keyboard is open OR country dropdown is open
                  final isCompact =
                      keyboardOpen || controller.showDropdown.value;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ── Logo: animates to top-right corner when compact
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 350),
                        curve: Curves.easeInOut,
                        // Full height with top-padding when normal; slim bar when compact
                        height: isCompact ? 68 : 256,
                        child: Padding(
                          padding: EdgeInsets.only(
                            top: isCompact ? 12 : 100,
                            right: isCompact ? 16 : 0,
                          ),
                          child: AnimatedAlign(
                            duration: const Duration(milliseconds: 350),
                            curve: Curves.easeInOut,
                            alignment: isCompact
                                ? Alignment
                                      .topRight // ← top-right corner
                                : Alignment.topCenter, // ← centered
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 350),
                              curve: Curves.easeInOut,
                              width: isCompact ? 44 : 120,
                              height: isCompact ? 44 : 120,
                              child: Image.asset(
                                AppImages.appLogo,
                                fit: BoxFit.contain,
                                errorBuilder: (_, e, s) =>
                                    _buildLogoFallback(isCompact),
                              ),
                            ),
                          ),
                        ),
                      ),

                      // ── Scrollable content area
                      // Expanded bounds the height → SingleChildScrollView scrolls
                      // when keyboard + dropdown cause overflow
                      Expanded(
                        child: SingleChildScrollView(
                          physics: const ClampingScrollPhysics(),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppSizes.p24,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Heading
                                Text(
                                  'Stories that stay\nwith you.',
                                  style: AppTextStyles.text28Bold.copyWith(
                                    letterSpacing: -0.5,
                                    height: 1.2,
                                  ),
                                ),
                                AppSizes.vGap8,

                                // Subtitle
                                Text(
                                  'Discover captivating stories, originals and\nentertainment all in one place.',
                                  style: AppTextStyles.text13.copyWith(
                                    color: const Color(0xFF8A8A8A),
                                    height: 1.5,
                                  ),
                                ),
                                AppSizes.vGap32,

                                // Phone input
                                _PhoneInputField(controller: controller),
                                AppSizes.vGap12,

                                // Country dropdown (already inside Obx scope)
                                if (controller.showDropdown.value)
                                  _CountryDropdown(controller: controller)
                                else
                                  AppSizes.vGap4,

                                // Continue button
                                AppButton(
                                  label: 'Continue',
                                  onPressed: controller.canProceed.value
                                      ? controller.sendOtp
                                      : null,
                                  isLoading: controller.isLoading.value,
                                  isEnabled: controller.canProceed.value,
                                  height: AppSizes.buttonHeight,
                                ),
                                AppSizes.vGap20,

                                // Terms text
                                Center(
                                  child: Text(
                                    'By continuing, you agree to our Terms of Service\nand Privacy Policy.',
                                    textAlign: TextAlign.center,
                                    style: AppTextStyles.text11.copyWith(
                                      color: const Color(0xFF5A5A5A),
                                      height: 1.6,
                                    ),
                                  ),
                                ),
                                AppSizes.vGap32,
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLogoFallback(bool isCompact) {
    if (isCompact) {
      // Compact: just the "E²" box
      return Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white, width: 1.5),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Text(
              'E',
              style: TextStyle(
                fontFamily: AppTextStyles.fontFamily,
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: Colors.white,
              ),
            ),
            Positioned(
              top: 2,
              right: 2,
              child: Text(
                '2',
                style: TextStyle(
                  fontFamily: AppTextStyles.fontFamily,
                  fontSize: 8,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 90,
          height: 90,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.white, width: 2),
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Text(
                'E',
                style: TextStyle(
                  fontFamily: AppTextStyles.fontFamily,
                  fontSize: 52,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                  letterSpacing: -2,
                ),
              ),
              Positioned(
                top: 6,
                right: 6,
                child: Text(
                  '2',
                  style: TextStyle(
                    fontFamily: AppTextStyles.fontFamily,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
              Positioned(
                bottom: 12,
                right: 10,
                child: FaIcon(
                  FontAwesomeIcons.play,
                  color: AppColors.primary,
                  size: 14,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: 'ENTERTAINMENT. ',
                style: TextStyle(
                  fontFamily: AppTextStyles.fontFamily,
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                  letterSpacing: 1.5,
                ),
              ),
              TextSpan(
                text: 'SQUARED.',
                style: TextStyle(
                  fontFamily: AppTextStyles.fontFamily,
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                  letterSpacing: 1.5,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Private sub-widgets
// ─────────────────────────────────────────────────────────────────────────────

class _PhoneInputField extends StatelessWidget {
  const _PhoneInputField({required this.controller});

  final AuthController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Container(
        height: 52,
        decoration: BoxDecoration(
          color: const Color(0xFF14141E),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: controller.phoneFocusNode.hasFocus
                ? AppColors.primary
                : Colors.white.withValues(alpha: 0.1),
            width: controller.phoneFocusNode.hasFocus ? 1.4 : 1.0,
          ),
          boxShadow: controller.phoneFocusNode.hasFocus
              ? [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.25),
                    blurRadius: 14,
                    spreadRadius: 1,
                  ),
                ]
              : null,
        ),
        child: Row(
          children: [
            // Country code selector
            GestureDetector(
              onTap: controller.toggleDropdown,
              behavior: HitTestBehavior.opaque,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                height: double.infinity,
                decoration: BoxDecoration(
                  border: Border(
                    right: BorderSide(
                      color: Colors.white.withValues(alpha: 0.08),
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    Text(
                      controller.selectedCountryCode.value,
                      style: AppTextStyles.text14SemiBold.copyWith(
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 4),
                    AnimatedRotation(
                      turns: controller.showDropdown.value ? 0.5 : 0.0,
                      duration: const Duration(milliseconds: 200),
                      child: const FaIcon(
                        FontAwesomeIcons.chevronDown,
                        color: Color(0xFF8E8E9E),
                        size: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Phone number field
            Expanded(
              child: TextField(
                controller: controller.phoneController,
                focusNode: controller.phoneFocusNode,
                keyboardType: TextInputType.phone,
                cursorColor: AppColors.primary,
                style: AppTextStyles.text14Medium.copyWith(
                  color: Colors.white,
                  letterSpacing: 0.4,
                ),
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(12),
                ],
                decoration: InputDecoration(
                  hintText: 'Enter phone number',
                  hintStyle: AppTextStyles.text14.copyWith(
                    color: const Color(0xFF5A5A6E),
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 14),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CountryDropdown extends StatelessWidget {
  const _CountryDropdown({required this.controller});

  final AuthController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF14141E),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.5),
            blurRadius: 20,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: controller.countryCodes.map((country) {
          final isSelected =
              controller.selectedCountryCode.value == country['code'];

          return InkWell(
            onTap: () => controller.selectCountryCode(country['code']!),
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
              child: Row(
                children: [
                  // Country ISO short badge pill (replacing emojis)
                  Container(
                    width: 32,
                    height: 24,
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.primary.withValues(alpha: 0.2)
                          : const Color(0xFF222230),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(
                        color: isSelected
                            ? AppColors.primary.withValues(alpha: 0.4)
                            : Colors.white.withValues(alpha: 0.08),
                        width: 1,
                      ),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      country['short'] ?? '',
                      style: TextStyle(
                        fontFamily: AppTextStyles.fontFamily,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: isSelected ? AppColors.primary : Colors.white70,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      country['name']!,
                      style: AppTextStyles.text14Medium.copyWith(
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Text(
                    country['code']!,
                    style: AppTextStyles.text14.copyWith(
                      color: const Color(0xFF8A8A9E),
                    ),
                  ),
                  if (isSelected)
                    const Padding(
                      padding: EdgeInsets.only(left: 8),
                      child: FaIcon(
                        FontAwesomeIcons.check,
                        color: AppColors.primary,
                        size: 13,
                      ),
                    ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
