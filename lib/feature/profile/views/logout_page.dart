import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import '../../../constants/app_colors.dart';
import '../../../constants/app_text_styles.dart';
import '../../../routes/app_pages.dart';
import '../../../shared/widgets/custom_bottomsheet.dart';

class LogoutPage extends StatelessWidget {
  const LogoutPage({super.key});

  /// Helper to show this logout confirmation as a bottom sheet
  static Future<T?> showBottomSheet<T>(BuildContext context) {
    return CustomBottomSheet.show<T>(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.75),
      child: const LogoutBottomSheetContent(),
    );
  }

  /// Helper to show this logout confirmation as a dialog
  static Future<T?> showLogoutDialog<T>(BuildContext context) {
    return showDialog<T>(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.8),
      builder: (context) => const Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: EdgeInsets.symmetric(horizontal: 20),
        child: LogoutContentCard(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Background Gradient
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFF0A0A0E),
                    Color(0xFF000000),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                // Top App Bar / Header
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () => Get.back(),
                        behavior: HitTestBehavior.opaque,
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: const Color(0xFF16161C),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: const Color(0xFF2A2A36),
                              width: 1,
                            ),
                          ),
                          child: const Center(
                            child: FaIcon(
                              FontAwesomeIcons.chevronLeft,
                              color: Colors.white,
                              size: 14,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Text(
                        'Entertainment Squared',
                        style: AppTextStyles.text14Medium.copyWith(
                          color: AppColors.textSecondary,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ),

                // Center Logout Card
                const Expanded(
                  child: Center(
                    child: SingleChildScrollView(
                      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                      child: LogoutContentCard(),
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

/// Logout Confirmation Card (Matches the exact design)
class LogoutContentCard extends StatelessWidget {
  const LogoutContentCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(maxWidth: 400),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 36),
      decoration: BoxDecoration(
        color: const Color(0xFF0B0B0F),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(
          color: const Color(0xFF1E1E28),
          width: 1.2,
        ),
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

          // ── Red Outlined Circle Icon
          Container(
            width: 86,
            height: 86,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFF160E12),
              border: Border.all(
                color: const Color(0xFFE42429),
                width: 1.8,
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFE42429).withValues(alpha: 0.22),
                  blurRadius: 24,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: const Center(
              child: FaIcon(
                FontAwesomeIcons.arrowRightFromBracket,
                color: Color(0xFFE42429),
                size: 32,
              ),
            ),
          ),
          const SizedBox(height: 28),

          // ── Title
          const Text(
            'Log out?',
            style: TextStyle(
              fontFamily: AppTextStyles.fontFamily,
              color: Colors.white,
              fontSize: 26,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.3,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),

          // ── Subtitle / Description
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                style: TextStyle(
                  fontFamily: AppTextStyles.fontFamily,
                  color: const Color(0xFF9E9EA8),
                  fontSize: 14.5,
                  fontWeight: FontWeight.w400,
                  height: 1.45,
                ),
                children: const [
                  TextSpan(text: "You'll need to log in again to access your\n"),
                  TextSpan(
                    text: 'Entertainment\u00B2',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Color(0xFFC0C0D0),
                    ),
                  ),
                  TextSpan(text: ' account and saved stories.'),
                ],
              ),
            ),
          ),
          const SizedBox(height: 36),

          // ── Primary Action: Log Out Button
          _buildActionButton(
            label: 'Log Out',
            backgroundColor: const Color(0xFFE42429),
            textColor: Colors.white,
            hasShadow: true,
            onTap: () {
              // Navigate to login screen and clear stack
              Get.offAllNamed(Routes.login);
            },
          ),
          const SizedBox(height: 14),

          // ── Secondary Action: Cancel Button
          _buildActionButton(
            label: 'Cancel',
            backgroundColor: const Color(0xFF1E1E22),
            textColor: Colors.white,
            hasBorder: true,
            borderColor: const Color(0xFF2E2E36),
            onTap: () {
              Get.back();
            },
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required String label,
    required Color backgroundColor,
    required Color textColor,
    required VoidCallback onTap,
    bool hasShadow = false,
    bool hasBorder = false,
    Color? borderColor,
  }) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        height: 52,
        width: double.infinity,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(14),
          border: hasBorder && borderColor != null
              ? Border.all(color: borderColor, width: 1)
              : null,
          boxShadow: hasShadow
              ? [
                  BoxShadow(
                    color: backgroundColor.withValues(alpha: 0.35),
                    blurRadius: 16,
                    offset: const Offset(0, 5),
                  ),
                ]
              : null,
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontFamily: AppTextStyles.fontFamily,
              color: textColor,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }
}

/// Logout Bottom Sheet Layout (for modal presentation)
class LogoutBottomSheetContent extends StatelessWidget {
  const LogoutBottomSheetContent({super.key});

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
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Drag Handle bar
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 24),
              decoration: BoxDecoration(
                color: const Color(0xFF383844),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const LogoutContentCard(),
          ],
        ),
      ),
    );
  }
}
