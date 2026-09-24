import 'package:e_square_ott_app/constants/enum.dart';
import 'package:e_square_ott_app/feature/auth/datasource/auth_datasource.dart';
import 'package:e_square_ott_app/models/request/edit_profile_payload.dart';
import 'package:e_square_ott_app/models/response/edit_profile_model.dart';
import 'package:e_square_ott_app/models/response/get_genre_model.dart';
import 'package:e_square_ott_app/models/response/otp_response.dart';
import 'package:e_square_ott_app/models/response/profile_model.dart';
import 'package:e_square_ott_app/models/response/resend_otp_response.dart';
import 'package:e_square_ott_app/models/response/saved_interest_model.dart';
import 'package:e_square_ott_app/models/response/user_model.dart';
import 'package:e_square_ott_app/models/response/verify_otp_response.dart';
import 'package:e_square_ott_app/shared/service/notification_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../routes/app_pages.dart';
import '../../../shared/widgets/custom_sncakbar.dart';

class AuthController extends GetxController {
  final AuthDatasource datasource = AuthDatasource();
  final phoneNumber = "".obs;
  final otp = "".obs;
  final countryCode = "+91".obs;
  final sendOtpStatus = Status.init.obs;
  final verifyOtpStatus = Status.init.obs;
  final resendOtpStatus = Status.init.obs;
  final sendOtpResponse = Rxn<OtpResponseModel?>();
  final verifyOtpResponse = Rxn<VerifyOtpResponseModel?>();
  final resendOtpResponse = Rxn<ResendOtpResponseModel?>();
  final name = "".obs;
  final lastname = "".obs;
  final email = "".obs;
  final completeProfileStatus = Status.init.obs;
  final completeProfileResponse = Rxn<CompleteProfileResponseModel?>();
  final getProfileStatus = Status.init.obs;
  final getProfileResponse = Rxn<ProfileResponseModel?>();
  final logoutStatus = Status.init.obs;
  final selectInterestStatus = Status.init.obs;
  final allGenre = Status.init.obs;
  final allGenreResponse = Rxn<GenreResponseModel?>();
  final selectGenreResponse = Rxn<SaveInterestResponseModel?>();
  final selectedGenres = <String>[].obs;
  final refreshTokenStatus = Status.init.obs;
  final deleteAccountStatus = Status.init.obs;
  final editProfileStatus = Status.init.obs;
  final editProfileResponse = Rxn<EditProfileResponse?>();
  final editName = "".obs;
  final editEmail = "".obs;
  final editLastName = "".obs;
  final profileUrl = "".obs;

  void setPhone(String value) {
    phoneNumber.value = value;
  }

  void setOtp(String value) {
    otp.value = value;
  }

  void setCountryCode(String value) {
    countryCode.value = value;
  }

  void setEditEmail(String value) {
    editEmail.value = value;
  }

  void setEditName(String value) {
    editName.value = value;
  }

  void setEditLastName(String value) {
    editLastName.value = value;
  }

  void setProfileUrl(String value) {
    profileUrl.value = value;
  }

  void setName(String value) {
    name.value = value;
  }

  void setLastName(String value) {
    lastname.value = value;
  }

  void setEmail(String value) {
    email.value = value;
  }

  void _ensurePhoneAndCode() {
    if ((phoneNumber.value.isEmpty || countryCode.value.isEmpty) &&
        Get.arguments is Map) {
      final args = Get.arguments as Map<String, dynamic>;
      final raw = (args['phone'] as String? ?? '').trim();
      final parts = raw.split(' ');
      if (parts.length >= 2) {
        countryCode.value = parts[0];
        phoneNumber.value = parts.sublist(1).join();
      }
    }
  }

  Future<void> sendOtp() async {
    phoneNumber.value = phoneController.text.trim();
    countryCode.value = selectedCountryCode.value;
    phoneFocusNode.unfocus();
    closeDropdown();

    sendOtpStatus.value = Status.loading;
    try {
      final result = await datasource.requestOtp(
        phone: phoneNumber.value,
        code: countryCode.value,
      );
      if (result != null) {
        sendOtpResponse.value = result;
        sendOtpStatus.value = Status.success;
        AppSnackbar.success(
          result.message.isNotEmpty ? result.message : 'OTP sent successfully',
        );
        _startOtpCountdown();
        Get.toNamed(
          '/otp-verify',
          arguments: {
            'phone': '${countryCode.value} ${phoneNumber.value}',
            'maskedPhone': result.data.maskedNumber,
          },
        );
      } else {
        sendOtpStatus.value = Status.error;
        AppSnackbar.error(
          'Failed to send OTP. Please check server connection.',
        );
      }
    } catch (e) {
      sendOtpStatus.value = Status.error;
      AppSnackbar.error('Failed to send OTP: $e');
    } finally {
      sendOtpStatus.value = Status.init;
    }
  }

  Future<void> verifyOtp() async {
    _ensurePhoneAndCode();
    otp.value = otpControllers.map((c) => c.text.trim()).join();
    for (final f in otpFocusNodes) {
      f.unfocus();
    }

    verifyOtpStatus.value = Status.loading;
    try {
      final result = await datasource.verifyOtp(
        phone: phoneNumber.value,
        code: countryCode.value,
        otp: otp.value,
      );
      if (result != null) {
        verifyOtpResponse.value = result;
        verifyOtpStatus.value = Status.success;
        NotificationService.instance.registerAfterLogin();
        AppSnackbar.success(
          result.message.isNotEmpty
              ? result.message
              : 'OTP verified successfully',
        );
        if (result.data.isProfileCompleted) {
          Get.offAllNamed('/home');
        } else {
          Get.offNamed('/profile-setup');
        }
      } else {
        verifyOtpStatus.value = Status.error;
        AppSnackbar.error('Invalid OTP or verification failed.');
      }
    } catch (e) {
      verifyOtpStatus.value = Status.error;
      AppSnackbar.error('Error verifying OTP: $e');
    } finally {
      verifyOtpStatus.value = Status.init;
    }
  }

  Future<void> resendOtp() async {
    _ensurePhoneAndCode();
    resendOtpStatus.value = Status.loading;
    try {
      final result = await datasource.resendOtp(
        phone: phoneNumber.value,
        code: countryCode.value,
      );
      if (result != null) {
        resendOtpResponse.value = result;
        resendOtpStatus.value = Status.success;
        AppSnackbar.success(
          result.message.isNotEmpty
              ? result.message
              : 'OTP resent successfully',
        );
        _startOtpCountdown();
        for (final c in otpControllers) {
          c.clear();
        }
        otp.value = '';
        isOtpComplete.value = false;
        if (otpFocusNodes.isNotEmpty) {
          otpFocusNodes[0].requestFocus();
        }
      } else {
        resendOtpStatus.value = Status.error;
        AppSnackbar.error('Failed to resend OTP. Please try again.');
      }
    } catch (e) {
      resendOtpStatus.value = Status.error;
      AppSnackbar.error('Error resending OTP: $e');
    } finally {
      resendOtpStatus.value = Status.init;
    }
  }

  Future<void> completeProfile() async {
    name.value = firstNameController.text.trim();
    lastname.value = lastNameController.text.trim();
    email.value = emailController.text.trim();

    if (name.value.isEmpty) {
      AppSnackbar.error('Please enter your first name');
      return;
    }

    firstNameFocusNode.unfocus();
    lastNameFocusNode.unfocus();
    emailFocusNode.unfocus();

    completeProfileStatus.value = Status.loading;
    try {
      final result = await datasource.completeProfile(
        name: name.value,
        email: email.value,
        lastname: lastname.value,
      );
      if (result != null) {
        completeProfileResponse.value = result;
        completeProfileStatus.value = Status.success;
        AppSnackbar.success(
          result.message.isNotEmpty
              ? result.message
              : 'Profile updated successfully',
        );
        Get.toNamed('/choose-interest');
      } else {
        completeProfileStatus.value = Status.error;
        AppSnackbar.error('Failed to complete profile. Please try again.');
      }
    } catch (e) {
      completeProfileStatus.value = Status.error;
      AppSnackbar.error('Error completing profile: $e');
    } finally {
      completeProfileStatus.value = Status.init;
    }
  }

  Future<void> getProfile() async {
    getProfileStatus.value = Status.loading;
    try {
      final result = await datasource.getProfile();
      if (result != null) {
        getProfileResponse.value = result;
        getProfileStatus.value = Status.success;
        final user = result.data!.user;
        name.value = user!.firstName;
        lastname.value = user.lastName;
        email.value = user.email ?? '';
        firstNameController.text = user.firstName;
        lastNameController.text = user.lastName;
        emailController.text = user.email ?? '';
      } else {
        getProfileStatus.value = Status.error;
      }
    } catch (e) {
      getProfileStatus.value = Status.error;
      print("getProfile error: $e");
    }
  }

  Future<void> logoutProfile() async {
    logoutStatus.value = Status.loading;
    try {
      await NotificationService.instance.unregisterTokenFromBackend();
    } catch (_) {}
    final result = await datasource.logout();
    if (result) {
      logoutStatus.value = Status.success;
      logoutStatus.value = Status.init;
    } else {
      logoutStatus.value = Status.error;
      logoutStatus.value = Status.init;
    }
  }

  // ── Get All Genres API
  Future<void> getAllGenres() async {
    allGenre.value = Status.loading;
    try {
      final result = await datasource.allGenre();
      if (result != null) {
        allGenreResponse.value = result;
        allGenre.value = Status.success;
      } else {
        allGenre.value = Status.error;
      }
    } catch (e) {
      allGenre.value = Status.error;
      print("getAllGenres error: $e");
    }
  }

  // ── Save Selected Interests / Genres API
  Future<void> saveSelectedInterests() async {
    selectInterestStatus.value = Status.loading;
    try {
      final List<String> interestsList = List<String>.from(selectedGenres);

      final result = await datasource.saveInterests(interests: interestsList);
      if (result != null) {
        selectGenreResponse.value = result;
        selectInterestStatus.value = Status.success;
        AppSnackbar.success(
          result.message.isNotEmpty
              ? result.message
              : 'Interests saved successfully',
        );
        Get.offAllNamed(Routes.home);
      } else {
        selectInterestStatus.value = Status.error;
        AppSnackbar.error('Failed to save interests. Please try again.');
      }
    } catch (e) {
      selectInterestStatus.value = Status.error;
      print("saveSelectedInterests error: $e");
      AppSnackbar.error('Error saving interests: $e');
    } finally {
      selectInterestStatus.value = Status.init;
    }
  }

  Future<bool> refreshToken() async {
    refreshTokenStatus.value = Status.loading;
    try {
      final result = await datasource.refreshToken();
      if (result) {
        refreshTokenStatus.value = Status.success;
        return true;
      } else {
        refreshTokenStatus.value = Status.error;
        return false;
      }
    } catch (e) {
      refreshTokenStatus.value = Status.error;
      print("refreshToken error: $e");
      return false;
    } finally {
      refreshTokenStatus.value = Status.init;
    }
  }

  Future<bool> editProfile() async {
    editProfileStatus.value = Status.loading;
    final user = EditProfilePayload(
      firstName: editName.value,
      lastName: editLastName.value,
      email: editEmail.value,
      avatarUrl: profileUrl.value,
    );
    try {
      final result = await datasource.editProfile(payload: user);
      if (result != null && result.success) {
        editProfileResponse.value = result;
        editProfileStatus.value = Status.success;
        AppSnackbar.success(
          result.message.isNotEmpty
              ? result.message
              : "Profile updated successfully",
        );
        return true;
      } else {
        editProfileStatus.value = Status.error;
        AppSnackbar.error(
          result?.message.isNotEmpty == true
              ? result!.message
              : "Failed to update profile",
        );
        return false;
      }
    } catch (e) {
      editProfileStatus.value = Status.error;
      AppSnackbar.error("Error updating profile");
      return false;
    } finally {
      editProfileStatus.value = Status.init;
    }
  }

  Future<bool> deleteAccount() async {
    deleteAccountStatus.value = Status.loading;
    try {
      final result = await datasource.deleteAccount();
      if (result) {
        deleteAccountStatus.value = Status.success;
        return true;
      } else {
        deleteAccountStatus.value = Status.error;
        return false;
      }
    } catch (e) {
      deleteAccountStatus.value = Status.error;
      print("deleteAccount error: $e");
      return false;
    } finally {
      deleteAccountStatus.value = Status.init;
    }
  }

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
    getAllGenres();
    countryCode.value = selectedCountryCode.value;
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
    canProceed.value = phoneController.text.trim().length >= 7;
  }

  void selectCountryCode(String code) {
    selectedCountryCode.value = code;
    countryCode.value = code;
    showDropdown.value = false;
  }

  void toggleDropdown() => showDropdown.value = !showDropdown.value;

  void closeDropdown() {
    if (showDropdown.value) showDropdown.value = false;
  }

  // ─────────────────────────────────────────────
  // OTP helpers & countdown
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
    otp.value = otpControllers.map((c) => c.text.trim()).join();
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

  // ─────────────────────────────────────────────
  // Profile Setup → save profile
  // ─────────────────────────────────────────────

  void _checkProfileValid() {
    isProfileValid.value = firstNameController.text.trim().isNotEmpty;
  }

  Future<void> saveProfile() async {
    await completeProfile();
  }

  // ─────────────────────────────────────────────
  // Choose Interest state & actions
  // ─────────────────────────────────────────────

  void toggleGenre(String genre) {
    if (selectedGenres.contains(genre)) {
      selectedGenres.remove(genre);
    } else {
      selectedGenres.add(genre);
    }
  }

  bool get hasSelectedGenres => selectedGenres.isNotEmpty;

  Future<void> completeOnboarding() async {
    if (hasSelectedGenres) {
      await saveSelectedInterests();
    } else {
      Get.offAllNamed(Routes.home);
    }
  }
}
