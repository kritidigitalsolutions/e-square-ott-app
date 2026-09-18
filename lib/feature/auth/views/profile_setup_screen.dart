import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../../constants/app_images.dart';
import '../../../constants/app_sizes.dart';
import '../../../constants/app_text_styles.dart';
import '../../../shared/widgets/custom_animation.dart';
import '../../../shared/widgets/custom_buttons.dart';
import '../../../shared/widgets/custom_loading.dart';
import '../../../shared/widgets/custom_text_field.dart';
import '../controller/auth_controller.dart';

class ProfileSetupScreen extends GetView<AuthController> {
  const ProfileSetupScreen({super.key});

  @override
  Widget build(BuildContext context) {
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

              // ── Content Area
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
                              vertical: 20,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Top space below back button
                                const SizedBox(height: 60),

                                // Heading
                                Text(
                                  'Welcome to\nEntertainment Square',
                                  style: AppTextStyles.text28Bold.copyWith(
                                    letterSpacing: -0.5,
                                    height: 1.25,
                                  ),
                                ),
                                AppSizes.vGap8,

                                // Subtitle
                                Text(
                                  'Tell us a little about yourself so we can\nmake your experience feel more personal.',
                                  style: AppTextStyles.text13.copyWith(
                                    color: const Color(0xFF8A8A8A),
                                    height: 1.4,
                                  ),
                                ),
                                const SizedBox(height: 28),

                                // ── First Name Field
                                CustomTextField(
                                  label: 'First name',
                                  hintText: 'Enter First name',
                                  controller: controller.firstNameController,
                                  focusNode: controller.firstNameFocusNode,
                                  textInputAction: TextInputAction.next,
                                ),
                                const SizedBox(height: 18),

                                // ── Last Name Field
                                CustomTextField(
                                  label: 'Last name',
                                  hintText: 'Enter Last name',
                                  controller: controller.lastNameController,
                                  focusNode: controller.lastNameFocusNode,
                                  textInputAction: TextInputAction.next,
                                ),
                                const SizedBox(height: 18),

                                // ── Email Address Field
                                CustomTextField(
                                  label: 'Email address',
                                  hintText: 'yourname@gmail.com',
                                  controller: controller.emailController,
                                  focusNode: controller.emailFocusNode,
                                  keyboardType: TextInputType.emailAddress,
                                  textInputAction: TextInputAction.done,
                                  onFieldSubmitted: (_) =>
                                      controller.saveProfile(),
                                ),

                                const Spacer(),
                                const SizedBox(height: 32),

                                // ── Continue Button
                                Obx(
                                  () => AppButton(
                                    label: 'Continue',
                                    onPressed: controller.saveProfile,
                                    isLoading: controller.isLoading.value,
                                    isEnabled: true,
                                    height: AppSizes.buttonHeight,
                                  ),
                                ),
                                const SizedBox(height: 16),
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
