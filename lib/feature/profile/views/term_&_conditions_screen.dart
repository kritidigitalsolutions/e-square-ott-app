import 'package:e_square_ott_app/constants/app_colors.dart';
import 'package:e_square_ott_app/constants/app_text_styles.dart';
import 'package:e_square_ott_app/constants/enum.dart';
import 'package:e_square_ott_app/feature/profile/controller/legal_controller.dart';
import 'package:e_square_ott_app/models/response/legal_document_model.dart';
import 'package:e_square_ott_app/shared/widgets/custom_animation.dart';
import 'package:e_square_ott_app/shared/widgets/custom_buttons.dart';
import 'package:e_square_ott_app/shared/widgets/shimmer_loader.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

/// =======================================================================
/// TERMS & CONDITIONS
/// =======================================================================
class TermsConditionsScreen extends StatefulWidget {
  const TermsConditionsScreen({super.key});

  @override
  State<TermsConditionsScreen> createState() => _TermsConditionsScreenState();
}

class _TermsConditionsScreenState extends State<TermsConditionsScreen> {
  late final LegalController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.isRegistered<LegalController>()
        ? Get.find<LegalController>()
        : Get.put(LegalController());
    controller.getTermAndCondition();
  }

  String _formatDate(String? dateStr) {
    if (dateStr == null || dateStr.trim().isEmpty) {
      return DateFormat('MMMM yyyy').format(DateTime.now());
    }
    try {
      final parsed = DateTime.parse(dateStr.trim());
      return DateFormat('MMMM d, yyyy').format(parsed);
    } catch (_) {
      return dateStr;
    }
  }

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
                  // Header
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CustomBackButton(onTap: () => Get.back()),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Text(
                          'Terms & Conditions'.tr,
                          style: AppTextStyles.text18Bold.copyWith(
                            color: Colors.white,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Content Body
                  Expanded(
                    child: Obx(() {
                      final status = controller.termAndCondtionStatus.value;
                      final doc =
                          controller.termAndCondtionResponse.value?.data;

                      if (status == Status.loading && doc == null) {
                        return _buildShimmerLoading();
                      }

                      if (status == Status.error && doc == null) {
                        return _buildErrorState();
                      }

                      return RefreshIndicator(
                        color: AppColors.primary,
                        backgroundColor: const Color(0xFF161622),
                        onRefresh: controller.getTermAndCondition,
                        child: SingleChildScrollView(
                          physics: const AlwaysScrollableScrollPhysics(
                            parent: BouncingScrollPhysics(),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Badges row: Last Updated & Version
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 6,
                                    ),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF14141E)
                                          .withValues(alpha: 0.85),
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(
                                        color: Colors.white.withValues(alpha: 0.1),
                                        width: 0.8,
                                      ),
                                    ),
                                    child: Text(
                                      doc != null && doc.lastUpdated.isNotEmpty
                                          ? 'Last Updated: ${_formatDate(doc.lastUpdated)}'
                                          : doc != null &&
                                                  doc.effectiveDate.isNotEmpty
                                              ? 'Effective: ${_formatDate(doc.effectiveDate)}'
                                              : 'Last Updated: ${_formatDate(null)}',
                                      style: AppTextStyles.text12Medium.copyWith(
                                        color: AppColors.textSecondary,
                                      ),
                                    ),
                                  ),
                                  if (doc != null && doc.version.isNotEmpty) ...[
                                    const SizedBox(width: 8),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 10,
                                        vertical: 6,
                                      ),
                                      decoration: BoxDecoration(
                                        color: AppColors.primary
                                            .withValues(alpha: 0.15),
                                        borderRadius: BorderRadius.circular(20),
                                        border: Border.all(
                                          color: AppColors.primary
                                              .withValues(alpha: 0.3),
                                          width: 0.8,
                                        ),
                                      ),
                                      child: Text(
                                        'v${doc.version}',
                                        style: const TextStyle(
                                          fontFamily: AppTextStyles.fontFamily,
                                          color: AppColors.primary,
                                          fontSize: 11,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                              const SizedBox(height: 18),

                              // Summary if available
                              if (doc != null && doc.summary.isNotEmpty) ...[
                                Container(
                                  padding: const EdgeInsets.all(14),
                                  margin: const EdgeInsets.only(bottom: 16),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF161622)
                                        .withValues(alpha: 0.9),
                                    borderRadius: BorderRadius.circular(14),
                                    border: Border.all(
                                      color: AppColors.primary
                                          .withValues(alpha: 0.25),
                                      width: 1,
                                    ),
                                  ),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Padding(
                                        padding: EdgeInsets.only(top: 2),
                                        child: FaIcon(
                                          FontAwesomeIcons.circleInfo,
                                          size: 15,
                                          color: AppColors.primary,
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: Text(
                                          doc.summary,
                                          style: const TextStyle(
                                            fontFamily:
                                                AppTextStyles.fontFamily,
                                            color: Colors.white,
                                            fontSize: 13,
                                            height: 1.45,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],

                              // Dynamic Document Content
                              if (doc != null && doc.content.isNotEmpty)
                                _DynamicContentRenderer(content: doc.content)
                              else
                                _buildFallbackContent(),

                              // Metadata Info (Contact / Support / Jurisdiction)
                              if (doc?.metadata != null)
                                _MetadataSection(metadata: doc!.metadata!),

                              const SizedBox(height: 30),
                            ],
                          ),
                        ),
                      );
                    }),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFallbackContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
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
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FaIcon(
            FontAwesomeIcons.circleExclamation,
            size: 46,
            color: Colors.white.withValues(alpha: 0.4),
          ),
          const SizedBox(height: 14),
          Text(
            "Failed to load Terms & Conditions".tr,
            style: AppTextStyles.text16SemiBold.copyWith(
              color: Colors.white.withValues(alpha: 0.8),
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: controller.getTermAndCondition,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text("Retry".tr),
          ),
        ],
      ),
    );
  }

  Widget _buildShimmerLoading() {
    return CustomShimmer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          ShimmerBox(width: 180, height: 28, borderRadius: 14),
          SizedBox(height: 20),
          ShimmerBox(width: double.infinity, height: 16, borderRadius: 4),
          SizedBox(height: 10),
          ShimmerBox(width: double.infinity, height: 16, borderRadius: 4),
          SizedBox(height: 10),
          ShimmerBox(width: 240, height: 16, borderRadius: 4),
          SizedBox(height: 24),
          ShimmerBox(width: 140, height: 20, borderRadius: 4),
          SizedBox(height: 12),
          ShimmerBox(width: double.infinity, height: 14, borderRadius: 4),
          SizedBox(height: 8),
          ShimmerBox(width: double.infinity, height: 14, borderRadius: 4),
          SizedBox(height: 8),
          ShimmerBox(width: 200, height: 14, borderRadius: 4),
        ],
      ),
    );
  }
}

/// Dynamic Content Renderer for API text
class _DynamicContentRenderer extends StatelessWidget {
  final String content;
  const _DynamicContentRenderer({required this.content});

  @override
  Widget build(BuildContext context) {
    final lines = content.split('\n');
    final List<Widget> widgets = [];

    for (int i = 0; i < lines.length; i++) {
      final line = lines[i].trim();
      if (line.isEmpty) {
        widgets.add(const SizedBox(height: 8));
        continue;
      }

      // Check if Heading (# Heading or ## Heading or Heading:)
      if (line.startsWith('#') ||
          (line.endsWith(':') && line.length < 60 && !line.startsWith('http'))) {
        final cleanText = line.replaceAll(RegExp(r'^#+\s*'), '');
        widgets.add(_SectionHeading(cleanText));
      }
      // Check if Bullet point (- item, * item, • item, or 1. item)
      else if (line.startsWith('- ') ||
          line.startsWith('* ') ||
          line.startsWith('• ') ||
          RegExp(r'^\d+\.\s').hasMatch(line)) {
        final cleanText = line
            .replaceFirst(RegExp(r'^[-*•]\s*'), '')
            .replaceFirst(RegExp(r'^\d+\.\s*'), '');
        widgets.add(_BulletItem(cleanText));
      }
      // Regular Paragraph
      else {
        widgets.add(_Paragraph(line));
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: widgets,
    );
  }
}

/// Metadata information section at the bottom of the document
class _MetadataSection extends StatelessWidget {
  final LegalMetadata metadata;
  const _MetadataSection({required this.metadata});

  @override
  Widget build(BuildContext context) {
    final hasEmail = metadata.contactEmail != null &&
        metadata.contactEmail!.isNotEmpty;
    final hasSupport = metadata.supportEmail != null &&
        metadata.supportEmail!.isNotEmpty;
    final hasOfficer = metadata.dpoOfficer != null &&
        metadata.dpoOfficer!.isNotEmpty;
    final hasJurisdiction = metadata.legalJurisdiction != null &&
        metadata.legalJurisdiction!.isNotEmpty;

    if (!hasEmail && !hasSupport && !hasOfficer && !hasJurisdiction) {
      return const SizedBox.shrink();
    }

    return Container(
      margin: const EdgeInsets.only(top: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF141420).withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.08),
          width: 0.8,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Contact & Legal Information".tr,
            style: const TextStyle(
              fontFamily: AppTextStyles.fontFamily,
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 12),
          if (hasEmail)
            _InfoRow(
              icon: FontAwesomeIcons.envelope,
              label: "Email".tr,
              value: metadata.contactEmail!,
            ),
          if (hasSupport)
            _InfoRow(
              icon: FontAwesomeIcons.headset,
              label: "Support".tr,
              value: metadata.supportEmail!,
            ),
          if (hasOfficer)
            _InfoRow(
              icon: FontAwesomeIcons.userTie,
              label: "DPO Officer".tr,
              value: metadata.dpoOfficer!,
            ),
          if (hasJurisdiction)
            _InfoRow(
              icon: FontAwesomeIcons.scaleBalanced,
              label: "Jurisdiction".tr,
              value: metadata.legalJurisdiction!,
            ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final FaIconData icon;
  final String label;
  final String value;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          FaIcon(
            icon,
            size: 12,
            color: AppColors.primary,
          ),
          const SizedBox(width: 8),
          Text(
            '$label: ',
            style: TextStyle(
              fontFamily: AppTextStyles.fontFamily,
              color: Colors.white.withValues(alpha: 0.6),
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontFamily: AppTextStyles.fontFamily,
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Bold section heading used inside the page body
class _SectionHeading extends StatelessWidget {
  final String text;
  const _SectionHeading(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 8),
      child: Text(
        text,
        style: const TextStyle(
          fontFamily: AppTextStyles.fontFamily,
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
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 7, right: 10),
            child: Container(
              width: 4.5,
              height: 4.5,
              decoration: const BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
              ),
            ),
          ),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontFamily: AppTextStyles.fontFamily,
                color: AppColors.textSecondary,
                fontSize: 13,
                height: 1.45,
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
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        text,
        style: const TextStyle(
          fontFamily: AppTextStyles.fontFamily,
          color: AppColors.textSecondary,
          fontSize: 13,
          height: 1.5,
        ),
      ),
    );
  }
}
