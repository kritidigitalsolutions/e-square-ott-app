import 'package:e_square_ott_app/constants/app_colors.dart';
import 'package:e_square_ott_app/constants/app_text_styles.dart';
import 'package:e_square_ott_app/shared/widgets/custom_animation.dart';
import 'package:e_square_ott_app/shared/widgets/custom_buttons.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// =======================================================================
/// PRIVACY POLICY
/// =======================================================================
class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      showAppBar: false,
      safeArea: false,
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: AppColors.loginBgGradient,
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CustomBackButton(
                        onTap: () {
                          Get.back();
                        },
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Text(
                          "Privacy Policy".tr,
                          style: AppTextStyles.text18Bold,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.background,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            'Last Updated: September 2026',
                            style: AppTextStyles.text12.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ),
                        const SizedBox(height: 18),
                        Expanded(
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _Paragraph(
                                  'Entertainment² respects your privacy and protects your personal information.',
                                ),
                                _SectionHeading('We may collect:'),
                                _BulletItem('Name, email, and mobile number'),
                                _BulletItem('Watch history and saved series'),
                                _BulletItem('Search activity and preferences'),
                                _BulletItem(
                                  'Basic device and usage information',
                                ),
                                const SizedBox(height: 8),
                                _SectionHeading('We use this information to:'),
                                _BulletItem('Provide and improve our services'),
                                _BulletItem('Personalize recommendations'),
                                _BulletItem(
                                  'Manage your account and subscription',
                                ),
                                _BulletItem('Send important notifications'),
                                _BulletItem('Maintain security'),
                                const SizedBox(height: 8),
                                _Paragraph(
                                  'We do not sell your personal information. You may request access or deletion of your information through Settings.',
                                ),
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
        ],
      ),
    );
  }
}

/// Bold section heading used inside the page body (e.g. "We may collect:")
class _SectionHeading extends StatelessWidget {
  final String text;
  const _SectionHeading(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(
        text,
        style: const TextStyle(
          color: AppColors.textPrimary,
          fontSize: 14.5,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

/// Single bullet row used inside the page body
class _BulletItem extends StatelessWidget {
  final String text;
  const _BulletItem(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 6, right: 10),
            child: Container(
              width: 4,
              height: 4,
              decoration: const BoxDecoration(
                color: AppColors.textSecondary,
                shape: BoxShape.circle,
              ),
            ),
          ),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 13,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Plain paragraph used for intro/footer text
class _Paragraph extends StatelessWidget {
  final String text;
  const _Paragraph(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Text(
        text,
        style: const TextStyle(
          color: AppColors.textSecondary,
          fontSize: 13,
          height: 1.5,
        ),
      ),
    );
  }
}
