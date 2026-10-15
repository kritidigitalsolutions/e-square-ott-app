import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../constants/app_colors.dart';
import '../../../../models/response/custom_ad_model.dart';
import '../../../../routes/app_pages.dart';
import '../../../../shared/service/custom_ads_service.dart';

class HomeCustomAdBannerWidget extends StatelessWidget {
  final CustomAdModel ad;

  const HomeCustomAdBannerWidget({super.key, required this.ad});

  Future<void> _handleAdTap() async {
    // 1. Fire click tracking
    if (ad.id != null && ad.id!.isNotEmpty) {
      CustomAdsService().trackClick(ad.id!);
    }

    // 2. Perform CTA action
    final action = ad.ctaAction;
    if (action == 'EXTERNAL_URL' && ad.targetUrl != null) {
      final uri = Uri.tryParse(ad.targetUrl!);
      if (uri != null) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      }
    } else if (action == 'DEEP_LINK_DRAMA' && ad.targetDramaId != null) {
      Get.toNamed(Routes.dramaPlayer, arguments: {'id': ad.targetDramaId});
    } else if (action == 'DEEP_LINK_SUBSCRIPTION') {
      Get.toNamed(Routes.subscriptionPage);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bannerImageUrl = (ad.companionBannerUrl != null &&
            ad.companionBannerUrl!.isNotEmpty)
        ? ad.companionBannerUrl
        : (ad.thumbnailUrl != null && ad.thumbnailUrl!.isNotEmpty
            ? ad.thumbnailUrl
            : ad.mediaUrl);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: GestureDetector(
        onTap: _handleAdTap,
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xFF14141E),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.1),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.4),
                blurRadius: 16,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Banner Image with Sponsor Pill Badge
              if (bannerImageUrl != null && bannerImageUrl.isNotEmpty)
                Stack(
                  children: [
                    AspectRatio(
                      aspectRatio: 16 / 9,
                      child: CachedNetworkImage(
                        imageUrl: bannerImageUrl,
                        fit: BoxFit.cover,
                        placeholder: (_, __) => Container(
                          color: const Color(0xFF1A1A28),
                          child: const Center(
                            child: CircularProgressIndicator(
                              color: AppColors.primary,
                              strokeWidth: 2,
                            ),
                          ),
                        ),
                        errorWidget: (_, __, ___) => Container(
                          color: const Color(0xFF1A1A28),
                          child: const Icon(
                            Icons.broken_image,
                            color: Colors.white38,
                          ),
                        ),
                      ),
                    ),
                    // "Sponsored / Ad" Badge
                    Positioned(
                      top: 10,
                      left: 10,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.75),
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.15),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 4,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.primary,
                                borderRadius: BorderRadius.circular(3),
                              ),
                              child: const Text(
                                'Ad',
                                style: TextStyle(
                                  fontFamily: 'sans-serif',
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            if (ad.advertiser != null &&
                                ad.advertiser!.isNotEmpty) ...[
                              const SizedBox(width: 6),
                              Text(
                                ad.advertiser!,
                                style: const TextStyle(
                                  fontFamily: 'sans-serif',
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ],
                ),

              // ── Title + CTA Bar
              Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (ad.title != null && ad.title!.isNotEmpty)
                            Text(
                              ad.title!,
                              style: const TextStyle(
                                fontFamily: 'sans-serif',
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          if (ad.advertiser != null &&
                              ad.advertiser!.isNotEmpty)
                            Text(
                              'Sponsored by ${ad.advertiser}',
                              style: TextStyle(
                                fontFamily: 'sans-serif',
                                fontSize: 11,
                                color: Colors.white.withValues(alpha: 0.6),
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    // CTA Button
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            ad.ctaText?.isNotEmpty == true
                                ? ad.ctaText!
                                : 'Learn More',
                            style: const TextStyle(
                              fontFamily: 'sans-serif',
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(width: 4),
                          const FaIcon(
                            FontAwesomeIcons.arrowRight,
                            size: 10,
                            color: Colors.white,
                          ),
                        ],
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
}
