import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../../constants/app_colors.dart';
import '../../../constants/app_images.dart';
import '../../../constants/app_sizes.dart';
import '../../../constants/app_text_styles.dart';
import '../../../constants/enum.dart';
import '../../../shared/widgets/custom_animation.dart';
import '../../../shared/widgets/custom_buttons.dart';
import '../../../shared/widgets/custom_text_field.dart';
import '../../home/controller/file_controller.dart';
import '../controller/profile_controller.dart';

class EditProfileScreen extends GetView<ProfileController> {
  const EditProfileScreen({super.key});

  FileController get _fileController {
    if (Get.isRegistered<FileController>()) {
      return Get.find<FileController>();
    }
    return Get.put(FileController());
  }

  void _showImageSourceDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF14141E),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 36,
                  height: 4,
                  decoration: BoxDecoration(
                    color: const Color(0xFF383844),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Change Profile Photo'.tr,
                  style: const TextStyle(
                    fontFamily: AppTextStyles.fontFamily,
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 18),
                ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E1E2C),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const FaIcon(
                      FontAwesomeIcons.camera,
                      color: AppColors.primary,
                      size: 16,
                    ),
                  ),
                  title: Text(
                    'Take a Photo'.tr,
                    style: const TextStyle(
                      fontFamily: AppTextStyles.fontFamily,
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  onTap: () async {
                    Navigator.pop(ctx);
                    final url = await _fileController.pickAndUploadImage(
                      source: ImageSource.camera,
                    );
                    if (url != null && url.isNotEmpty) {
                      controller.userAvatar.value = url;
                    }
                  },
                ),
                const SizedBox(height: 6),
                ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E1E2C),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const FaIcon(
                      FontAwesomeIcons.images,
                      color: AppColors.primary,
                      size: 16,
                    ),
                  ),
                  title: Text(
                    'Choose from Gallery'.tr,
                    style: const TextStyle(
                      fontFamily: AppTextStyles.fontFamily,
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  onTap: () async {
                    Navigator.pop(ctx);
                    final url = await _fileController.pickAndUploadImage(
                      source: ImageSource.gallery,
                    );
                    if (url != null && url.isNotEmpty) {
                      controller.userAvatar.value = url;
                    }
                  },
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final fileCtrl = _fileController;

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
              // ── Background Gradient
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
                    // ── Header Bar
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () => Get.back(),
                            child: Container(
                              width: 44,
                              height: 44,
                              decoration: BoxDecoration(
                                color: const Color(0xFF16161E),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: Colors.white.withValues(alpha: 0.08),
                                  width: 1,
                                ),
                              ),
                              child: const Center(
                                child: FaIcon(
                                  FontAwesomeIcons.chevronLeft,
                                  color: Colors.white,
                                  size: 15,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Text(
                              'Edit Profile'.tr,
                              style: AppTextStyles.text20Bold.copyWith(
                                color: Colors.white,
                                letterSpacing: -0.2,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // ── Scrollable Form
                    Expanded(
                      child: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSizes.p24,
                          vertical: 12,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const SizedBox(height: 12),

                            // ── User Avatar with Edit Badge & Image Picker
                            Center(
                              child: GestureDetector(
                                onTap: () => _showImageSourceDialog(context),
                                child: Stack(
                                  children: [
                                    Container(
                                      width: 104,
                                      height: 104,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: AppColors.primary.withValues(
                                            alpha: 0.8,
                                          ),
                                          width: 2.2,
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: AppColors.primary.withValues(
                                              alpha: 0.3,
                                            ),
                                            blurRadius: 20,
                                            spreadRadius: 2,
                                          ),
                                        ],
                                      ),
                                      child: ClipOval(
                                        child: Obx(() {
                                          final isUploading =
                                              fileCtrl.isFileUpload.value ==
                                              Status.loading;
                                          final avatar =
                                              controller.userAvatar.value;

                                          return Stack(
                                            fit: StackFit.expand,
                                            children: [
                                              if (avatar.startsWith('http'))
                                                Image.network(
                                                  avatar,
                                                  fit: BoxFit.cover,
                                                  errorBuilder: (_, __, ___) =>
                                                      _buildAvatarFallback(),
                                                )
                                              else
                                                Image.asset(
                                                  AppImages.banner1,
                                                  fit: BoxFit.cover,
                                                  errorBuilder: (_, __, ___) =>
                                                      _buildAvatarFallback(),
                                                ),
                                              if (isUploading)
                                                Container(
                                                  color: Colors.black54,
                                                  child: const Center(
                                                    child: SpinKitThreeBounce(
                                                      color: AppColors.primary,
                                                      size: 20,
                                                    ),
                                                  ),
                                                ),
                                            ],
                                          );
                                        }),
                                      ),
                                    ),
                                    Positioned(
                                      bottom: 0,
                                      right: 0,
                                      child: Container(
                                        width: 34,
                                        height: 34,
                                        decoration: BoxDecoration(
                                          gradient: AppColors.primaryGradient,
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color: const Color(0xFF010101),
                                            width: 2.5,
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black.withValues(
                                                alpha: 0.5,
                                              ),
                                              blurRadius: 6,
                                            ),
                                          ],
                                        ),
                                        child: const Center(
                                          child: FaIcon(
                                            FontAwesomeIcons.camera,
                                            color: Colors.white,
                                            size: 13,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),

                            // Phone subtitle under avatar
                            Obx(
                              () => Text(
                                controller.userPhone.value.isNotEmpty
                                    ? controller.userPhone.value
                                    : controller.userEmail.value,
                                style: AppTextStyles.text13Medium.copyWith(
                                  color: const Color(0xFF8E8E9E),
                                ),
                              ),
                            ),
                            const SizedBox(height: 32),

                            // ── Input Card Group
                            Container(
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: const Color(
                                  0xFF14141E,
                                ).withValues(alpha: 0.85),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: Colors.white.withValues(alpha: 0.08),
                                  width: 1,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.3),
                                    blurRadius: 16,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // First Name
                                  CustomTextField(
                                    label: 'First Name'.tr,
                                    hintText: 'Enter your first name'.tr,
                                    controller:
                                        controller.firstNameEditController,
                                    textInputAction: TextInputAction.next,
                                    prefixIcon: const Padding(
                                      padding: EdgeInsets.all(12),
                                      child: FaIcon(
                                        FontAwesomeIcons.user,
                                        size: 14,
                                        color: Color(0xFF8E8E9E),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 18),

                                  // Last Name
                                  CustomTextField(
                                    label: 'Last Name'.tr,
                                    hintText: 'Enter your last name'.tr,
                                    controller:
                                        controller.lastNameEditController,
                                    textInputAction: TextInputAction.next,
                                    prefixIcon: const Padding(
                                      padding: EdgeInsets.all(12),
                                      child: FaIcon(
                                        FontAwesomeIcons.userGroup,
                                        size: 14,
                                        color: Color(0xFF8E8E9E),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 18),

                                  // Email Address
                                  CustomTextField(
                                    label: 'Email Address'.tr,
                                    hintText: 'Enter your email address'.tr,
                                    controller: controller.emailEditController,
                                    keyboardType: TextInputType.emailAddress,
                                    textInputAction: TextInputAction.done,
                                    prefixIcon: const Padding(
                                      padding: EdgeInsets.all(12),
                                      child: FaIcon(
                                        FontAwesomeIcons.envelope,
                                        size: 14,
                                        color: Color(0xFF8E8E9E),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 18),

                                  // Phone Number (Read-only reference)
                                  CustomTextField(
                                    label: 'Phone Number'.tr,
                                    hintText: 'Phone number'.tr,
                                    controller: controller.phoneEditController,
                                    enabled: false,
                                    prefixIcon: const Padding(
                                      padding: EdgeInsets.all(12),
                                      child: FaIcon(
                                        FontAwesomeIcons.phone,
                                        size: 14,
                                        color: Color(0xFF5A5A6E),
                                      ),
                                    ),
                                    suffixIcon: const Padding(
                                      padding: EdgeInsets.all(12),
                                      child: FaIcon(
                                        FontAwesomeIcons.lock,
                                        size: 12,
                                        color: Color(0xFF5A5A6E),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 36),

                            // ── Save Changes Button
                            Obx(
                              () => AppButton(
                                label: 'Save Changes'.tr,
                                onPressed:
                                    controller.updateProfileStatus.value ==
                                        Status.loading
                                    ? null
                                    : controller.updateProfile,
                                isLoading:
                                    controller.updateProfileStatus.value ==
                                    Status.loading,
                                isEnabled:
                                    controller.updateProfileStatus.value !=
                                    Status.loading,
                                height: AppSizes.buttonHeight,
                                borderRadius: 14,
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
        ),
      ),
    );
  }

  Widget _buildAvatarFallback() {
    return Container(
      color: const Color(0xFF2A2A38),
      child: const Center(
        child: FaIcon(
          FontAwesomeIcons.solidUser,
          color: Colors.white70,
          size: 40,
        ),
      ),
    );
  }
}
