import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import '../../../constants/app_colors.dart';
import '../../../constants/app_text_styles.dart';
import '../../../routes/app_pages.dart';
import '../../../shared/widgets/custom_animation.dart';
import '../../../shared/widgets/custom_bottomsheet.dart';

class DeleteAccount1 extends StatelessWidget {
  const DeleteAccount1({super.key});

  /// Helper to show this delete confirmation as a bottom sheet
  static Future<T?> showBottomSheet<T>(BuildContext context) {
    return CustomBottomSheet.show<T>(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.8),
      child: const DeleteAccount1BottomSheetContent(),
    );
  }

  /// Helper to show this delete confirmation as a dialog
  static Future<T?> showDeleteDialog<T>(BuildContext context) {
    return showDialog<T>(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.8),
      builder: (context) => const Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: EdgeInsets.symmetric(horizontal: 20),
        child: DeleteAccount1ContentCard(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      showAppBar: false,
      safeArea: false,
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Background Gradient
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF0A0A0E), Color(0xFF000000)],
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
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
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

                // Main Center Content
                const Expanded(
                  child: Center(
                    child: SingleChildScrollView(
                      physics: BouncingScrollPhysics(),
                      padding: EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 16,
                      ),
                      child: DeleteAccount1ContentCard(),
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

/// Delete Account Step 1 Content Card
class DeleteAccount1ContentCard extends StatelessWidget {
  const DeleteAccount1ContentCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(maxWidth: 420),
      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 30),
      decoration: BoxDecoration(
        color: const Color(0xFF0B0B0F),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: const Color(0xFF1E1E28), width: 1.2),
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
          const SizedBox(height: 4),

          // ── Red Outlined Trash Icon Badge
          Container(
            width: 86,
            height: 86,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFF160E12),
              border: Border.all(color: const Color(0xFFE42429), width: 1.8),
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
                FontAwesomeIcons.trashCan,
                color: Color(0xFFE42429),
                size: 32,
              ),
            ),
          ),
          const SizedBox(height: 22),

          // ── Title
          const Text(
            'Are you sure?',
            style: TextStyle(
              fontFamily: AppTextStyles.fontFamily,
              color: Colors.white,
              fontSize: 26,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.3,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),

          // ── Subtitle / Description
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                style: TextStyle(
                  fontFamily: AppTextStyles.fontFamily,
                  color: const Color(0xFF9E9EA8),
                  fontSize: 14.0,
                  fontWeight: FontWeight.w400,
                  height: 1.45,
                ),
                children: const [
                  TextSpan(text: 'Deleting your '),
                  TextSpan(
                    text: 'Entertainment\u00B2',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Color(0xFFC0C0D0),
                    ),
                  ),
                  TextSpan(
                    text:
                        ' account will\npermanently remove your profile and viewing data.',
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // ── Red Bordered Box: "Before you continue"
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: const Color(0xFF140D10),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xFF4A181C), width: 1),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Before you continue',
                  style: TextStyle(
                    fontFamily: AppTextStyles.fontFamily,
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  'Your subscription, saved stories, watch history and personalized preferences will no longer be available.',
                  style: TextStyle(
                    fontFamily: AppTextStyles.fontFamily,
                    color: const Color(0xFF8E8E9E),
                    fontSize: 12.5,
                    fontWeight: FontWeight.w400,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // ── Cyan/Blue Bordered Box: Warning Checklist
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: const Color(0xFF0C1017),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xFF0091EA), width: 1.2),
            ),
            child: Column(
              children: [
                _buildChecklistItem(
                  text: 'Saved Series will be removed',
                  isFirst: true,
                ),
                _buildDivider(),
                _buildChecklistItem(text: 'Watch History will be deleted'),
                _buildDivider(),
                _buildChecklistItem(
                  text: 'Profile & preferences will be deleted',
                ),
                _buildDivider(),
                _buildChecklistItem(
                  text: 'Account access will end',
                  isLast: true,
                ),
              ],
            ),
          ),
          const SizedBox(height: 28),

          // ── Primary Action: Continue to Delete Button
          _buildActionButton(
            label: 'Continue to Delete',
            backgroundColor: const Color(0xFFE42429),
            textColor: Colors.white,
            hasShadow: true,
            onTap: () {
              // Navigate to DeleteAccount2 screen
              Get.toNamed(Routes.deleteAccount2);
            },
          ),
          const SizedBox(height: 14),

          // ── Secondary Action: Keep My Account Button
          _buildActionButton(
            label: 'Keep My Account',
            backgroundColor: const Color(0xFF1E1E22),
            textColor: Colors.white,
            hasBorder: true,
            borderColor: const Color(0xFF2E2E36),
            onTap: () {
              Get.back();
            },
          ),
          const SizedBox(height: 4),
        ],
      ),
    );
  }

  Widget _buildChecklistItem({
    required String text,
    bool isFirst = false,
    bool isLast = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          const FaIcon(
            FontAwesomeIcons.xmark,
            color: Color(0xFFE42429),
            size: 14,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontFamily: AppTextStyles.fontFamily,
                color: Color(0xFFD6D6E2),
                fontSize: 13.5,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return const Divider(
      height: 1,
      thickness: 1,
      color: Color(0xFF1B2230),
      indent: 14,
      endIndent: 14,
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

/// Delete Account Step 1 Bottom Sheet Layout
class DeleteAccount1BottomSheetContent extends StatelessWidget {
  const DeleteAccount1BottomSheetContent({super.key});

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
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
      child: SafeArea(
        top: false,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Drag Handle bar
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: const Color(0xFF383844),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const DeleteAccount1ContentCard(),
            ],
          ),
        ),
      ),
    );
  }
}
