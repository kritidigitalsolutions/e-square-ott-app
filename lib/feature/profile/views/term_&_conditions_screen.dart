import 'package:e_square_ott_app/constants/app_colors.dart';
import 'package:e_square_ott_app/constants/app_text_styles.dart';
import 'package:e_square_ott_app/shared/widgets/custom_animation.dart';
import 'package:e_square_ott_app/shared/widgets/custom_buttons.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// =======================================================================
/// TERMS & CONDITIONS
/// =======================================================================
class TermsConditionsScreen extends StatelessWidget {
  const TermsConditionsScreen({super.key});

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
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CustomBackButton(onTap: () => Get.back()),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Text(
                          'Terms & Conditions',
                          style: AppTextStyles.text18Bold,
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
                            style: AppTextStyles.text12Medium.copyWith(
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
                                  'By using Entertainment², you agree to these terms.',
                                ),
                                _BulletItem(
                                  'Use the app only for personal and lawful purposes.',
                                ),
                                _BulletItem(
                                  'Keep your account information secure.',
                                ),
                                _BulletItem(
                                  'Content is for personal viewing only and may not be copied or redistributed.',
                                ),
                                _BulletItem(
                                  'Paid subscriptions are subject to the applicable payment and renewal terms.',
                                ),
                                _BulletItem(
                                  'We may update, modify, or remove content and features at any time.',
                                ),
                                _BulletItem(
                                  'Accounts that violate these terms may be suspended or terminated.',
                                ),
                                _BulletItem(
                                  'These terms may be updated from time to time.',
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
