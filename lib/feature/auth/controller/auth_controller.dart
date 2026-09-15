import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../shared/widgets/custom_sncakbar.dart';

class AuthController extends GetxController {
  // ── Phone input state
  final TextEditingController phoneController = TextEditingController();
  final FocusNode phoneFocusNode = FocusNode();

  /// Currently selected country code
  final RxString selectedCountryCode = '+91'.obs;

  /// Whether the country code dropdown is visible
  final RxBool showDropdown = false.obs;

  /// Loading state for the Continue / Verify button
  final RxBool isLoading = false.obs;

  /// Whether phone input has enough digits to enable the button
  final RxBool canProceed = false.obs;

  // ── OTP state
  final List<TextEditingController> otpControllers = List.generate(
    4,
    (_) => TextEditingController(),
  );
  final List<FocusNode> otpFocusNodes = List.generate(4, (_) => FocusNode());

  /// Seconds remaining for OTP resend countdown
  final RxInt otpCountdown = 60.obs;

  /// Whether all OTP digits are filled
  final RxBool isOtpComplete = false.obs;

  // ── Country codes list (No emojis, clean ISO shortcodes)
  final countryCodes = <Map<String, String>>[
    {'code': '+91', 'short': 'IN', 'name': 'India'},
    {'code': '+1', 'short': 'US', 'name': 'USA'},
    {'code': '+44', 'short': 'GB', 'name': 'UK'},
    {'code': '+971', 'short': 'AE', 'name': 'UAE'},
    {'code': '+61', 'short': 'AU', 'name': 'Australia'},
    {'code': '+65', 'short': 'SG', 'name': 'Singapore'},
  ];

  // ── Profile Setup state
  final TextEditingController firstNameController = TextEditingController();
  final FocusNode firstNameFocusNode = FocusNode();
  final TextEditingController lastNameController = TextEditingController();
  final FocusNode lastNameFocusNode = FocusNode();
  final TextEditingController emailController = TextEditingController();
  final FocusNode emailFocusNode = FocusNode();

  /// Whether profile setup form is valid
  final RxBool isProfileValid = false.obs;

  @override
  void onInit() {
    super.onInit();
    phoneController.addListener(_onPhoneChanged);
    for (final c in otpControllers) {
      c.addListener(_checkOtpComplete);
    }
    firstNameController.addListener(_checkProfileValid);
    emailController.addListener(_checkProfileValid);
  }

  @override
  void onClose() {
    phoneController
      ..removeListener(_onPhoneChanged)
      ..dispose();
    phoneFocusNode.dispose();
    for (final c in otpControllers) {
      c.removeListener(_checkOtpComplete);
      c.dispose();
    }
    for (final f in otpFocusNodes) {
      f.dispose();
    }
    firstNameController
      ..removeListener(_checkProfileValid)
      ..dispose();
    firstNameFocusNode.dispose();
    lastNameController.dispose();
    lastNameFocusNode.dispose();
    emailController
      ..removeListener(_checkProfileValid)
      ..dispose();
    emailFocusNode.dispose();
    super.onClose();
  }

  // ─────────────────────────────────────────────
  // Phone / country helpers
  // ─────────────────────────────────────────────

  void _onPhoneChanged() {
    canProceed.value = phoneController.text.length >= 7;
  }

  void selectCountryCode(String code) {
    selectedCountryCode.value = code;
    showDropdown.value = false;
  }

  void toggleDropdown() => showDropdown.value = !showDropdown.value;

  void closeDropdown() {
    if (showDropdown.value) showDropdown.value = false;
  }

  // ─────────────────────────────────────────────
  // Login → send OTP
  // ─────────────────────────────────────────────

  Future<void> sendOtp() async {
    if (!canProceed.value) return;
    phoneFocusNode.unfocus();
    isLoading.value = true;

    // TODO: replace with real API call
    await Future.delayed(const Duration(seconds: 1));

    isLoading.value = false;
    Get.toNamed(
      '/otp-verify',
      arguments: {
        'phone': '${selectedCountryCode.value} ${phoneController.text}',
      },
    );
    _startOtpCountdown();
  }

  // ─────────────────────────────────────────────
  // OTP → verify
  // ─────────────────────────────────────────────

  void _startOtpCountdown() {
    otpCountdown.value = 60;
    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 1));
      if (otpCountdown.value > 0) {
        otpCountdown.value--;
        return true;
      }
      return false;
    });
  }

  void _checkOtpComplete() {
    isOtpComplete.value = otpControllers.every((c) => c.text.trim().isNotEmpty);
  }

  void onOtpDigitChanged(int index, String value) {
    if (value.length > 1) {
      // Pasted full OTP string
      final digits = value.replaceAll(RegExp(r'\D'), '');
      for (
        int i = 0;
        i < digits.length && (index + i) < otpControllers.length;
        i++
      ) {
        otpControllers[index + i].text = digits[i];
      }
      final nextIndex = (index + digits.length).clamp(
        0,
        otpControllers.length - 1,
      );
      otpFocusNodes[nextIndex].requestFocus();
      _checkOtpComplete();
      return;
    }

    _checkOtpComplete();

    if (value.length == 1 && index < otpControllers.length - 1) {
      otpFocusNodes[index + 1].requestFocus();
    } else if (value.isEmpty && index > 0) {
      otpFocusNodes[index - 1].requestFocus();
    }
  }

  Future<void> verifyOtp() async {
    if (!isOtpComplete.value) return;
    for (final f in otpFocusNodes) {
      f.unfocus();
    }
    isLoading.value = true;

    // TODO: replace with real API call
    await Future.delayed(const Duration(seconds: 1));

    isLoading.value = false;
    Get.toNamed('/profile-setup');
  }

  Future<void> resendOtp() async {
    if (otpCountdown.value > 0) return;
    for (final c in otpControllers) {
      c.clear();
    }
    isOtpComplete.value = false;
    otpFocusNodes[0].requestFocus();
    _startOtpCountdown();
    // TODO: call resend OTP API
    AppSnackbar.success(
      'A new OTP has been sent to your number.',
      title: 'OTP Sent',
    );
  }

  // ─────────────────────────────────────────────
  // Profile Setup → save profile
  // ─────────────────────────────────────────────

  void _checkProfileValid() {
    isProfileValid.value = firstNameController.text.trim().isNotEmpty;
  }

  Future<void> saveProfile() async {
    firstNameFocusNode.unfocus();
    lastNameFocusNode.unfocus();
    emailFocusNode.unfocus();

    isLoading.value = true;

    // TODO: replace with real API call
    await Future.delayed(const Duration(seconds: 1));

    isLoading.value = false;
    Get.toNamed('/choose-interest');
  }

  // ─────────────────────────────────────────────
  // Choose Interest state & actions
  // ─────────────────────────────────────────────

  final RxSet<String> selectedGenres = <String>{}.obs;

  void toggleGenre(String genre) {
    if (selectedGenres.contains(genre)) {
      selectedGenres.remove(genre);
    } else {
      selectedGenres.add(genre);
    }
  }

  bool get hasSelectedGenres => selectedGenres.isNotEmpty;

  Future<void> completeOnboarding() async {
    // TODO: save selected interests API
    Get.offAllNamed('/home');
  }
}
