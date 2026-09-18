import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import '../../../constants/app_colors.dart';
import '../../../constants/app_text_styles.dart';
import '../../../routes/app_pages.dart';
import '../../../shared/widgets/custom_animation.dart';
import '../../../shared/widgets/custom_bottomsheet.dart';
import '../../../shared/widgets/custom_loading.dart';
import '../../../shared/widgets/custom_sncakbar.dart';

class DeleteAccount2 extends StatefulWidget {
  const DeleteAccount2({super.key});

  /// Helper to show this delete confirmation as a bottom sheet
  static Future<T?> showBottomSheet<T>(BuildContext context) {
    return CustomBottomSheet.show<T>(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.8),
      child: const DeleteAccount2BottomSheetContent(),
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
        child: DeleteAccount2ContentCard(),
      ),
    );
  }

  @override
  State<DeleteAccount2> createState() => _DeleteAccount2State();
}

class _DeleteAccount2State extends State<DeleteAccount2> {
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
                        'Entertainment Square',
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
                      child: DeleteAccount2ContentCard(),
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

/// Delete Account Step 2 Content Card
class DeleteAccount2ContentCard extends StatefulWidget {
  const DeleteAccount2ContentCard({super.key});

  @override
  State<DeleteAccount2ContentCard> createState() =>
      _DeleteAccount2ContentCardState();
}

class _DeleteAccount2ContentCardState extends State<DeleteAccount2ContentCard> {
  final TextEditingController _textController = TextEditingController();
  bool _isLoading = false;
  bool _isValid = false;

  @override
  void initState() {
    super.initState();
    _textController.addListener(_onTextChanged);
  }

  void _onTextChanged() {
    final text = _textController.text.trim();
    final isValid = text.toUpperCase() == 'DELETE';
    if (isValid != _isValid) {
      setState(() {
        _isValid = isValid;
      });
    }
  }

  @override
  void dispose() {
    _textController.removeListener(_onTextChanged);
    _textController.dispose();
    super.dispose();
  }

  void _handleDelete() async {
    final text = _textController.text.trim();
    if (text.toUpperCase() != 'DELETE') {
      AppSnackbar.warning(
        'Please type "DELETE" in the input field to proceed.'.tr,
        title: 'Confirmation Required'.tr,
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    // Simulate account deletion request
    await Future.delayed(const Duration(milliseconds: 1000));

    if (mounted) {
      AppSnackbar.info(
        'Your account and all associated data have been permanently removed.'.tr,
        title: 'Account Deleted'.tr,
      );

      // Navigate back to login
      Get.offAllNamed(Routes.login);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(maxWidth: 420),
      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 32),
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
          const SizedBox(height: 6),

          // ── Red Outlined Exclamation Icon Badge
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
                FontAwesomeIcons.triangleExclamation,
                color: Color(0xFFE42429),
                size: 34,
              ),
            ),
          ),
          const SizedBox(height: 24),

          // ── Title
          Text(
            'Confirm your decision'.tr,
            style: const TextStyle(
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
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Text(
              'To permanently delete your account, type DELETE below.'.tr,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontFamily: AppTextStyles.fontFamily,
                color: Color(0xFF9E9EA8),
                fontSize: 14.0,
                fontWeight: FontWeight.w400,
                height: 1.45,
              ),
            ),
          ),
          const SizedBox(height: 28),

          // ── Text Input Field: Type Delete
          Container(
            height: 54,
            decoration: BoxDecoration(
              color: const Color(0xFF14141A),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: _isValid
                    ? const Color(0xFFE42429)
                    : const Color(0xFF2A2A34),
                width: 1.2,
              ),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Center(
              child: TextField(
                controller: _textController,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontFamily: AppTextStyles.fontFamily,
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5,
                ),
                cursorColor: const Color(0xFFE42429),
                decoration: InputDecoration(
                  hintText: 'Type Delete'.tr,
                  hintStyle: const TextStyle(
                    fontFamily: AppTextStyles.fontFamily,
                    color: Color(0xFF5A5A66),
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                  border: InputBorder.none,
                  isDense: true,
                  contentPadding: EdgeInsets.zero,
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),

          // ── Helper Text
          Text(
            'This helps prevent accidental deletion.'.tr,
            style: const TextStyle(
              fontFamily: AppTextStyles.fontFamily,
              color: Color(0xFF6E6E7E),
              fontSize: 12,
              fontWeight: FontWeight.w400,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 28),

          // ── Primary Action: Delete My Account Button
          GestureDetector(
            onTap: _isLoading ? null : _handleDelete,
            behavior: HitTestBehavior.opaque,
            child: Container(
              height: 52,
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color(0xFFE42429),
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFE42429).withValues(alpha: 0.35),
                    blurRadius: 16,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Center(
                child: _isLoading
                    ? const SizedBox(
                        width: 30,
                        height: 30,
                        child: LoadingWidget(size: 30),
                      )
                    : Text(
                        'Delete My Account'.tr,
                        style: const TextStyle(
                          fontFamily: AppTextStyles.fontFamily,
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
              ),
            ),
          ),
          const SizedBox(height: 6),
        ],
      ),
    );
  }
}

/// Delete Account Step 2 Bottom Sheet Layout
class DeleteAccount2BottomSheetContent extends StatelessWidget {
  const DeleteAccount2BottomSheetContent({super.key});

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
              const DeleteAccount2ContentCard(),
            ],
          ),
        ),
      ),
    );
  }
}
