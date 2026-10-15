import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:e_square_ott_app/constants/app_colors.dart';
import 'package:e_square_ott_app/shared/controller/custom_ad_controller.dart';

class CustomAdOverlayWidget extends StatelessWidget {
  final CustomAdController controller;

  const CustomAdOverlayWidget({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (!controller.isAdPlaying.value || controller.currentAd.value == null) {
        return const SizedBox.shrink();
      }

      final ad = controller.currentAd.value!;
      final isVideo = ad.mediaType == 'VIDEO';

      return Positioned.fill(
        child: Container(
          color: Colors.black,
          child: Stack(
            fit: StackFit.expand,
            children: [
              // ── Media Content (Video or Image)
              if (isVideo)
                controller.isVideoInitialized.value &&
                        controller.videoPlayerController != null
                    ? Center(
                        child: AspectRatio(
                          aspectRatio: controller
                              .videoPlayerController!
                              .value
                              .aspectRatio,
                          child: VideoPlayer(controller.videoPlayerController!),
                        ),
                      )
                    : const Center(
                        child: CircularProgressIndicator(
                          color: AppColors.primary,
                        ),
                      )
              else if (ad.mediaUrl != null && ad.mediaUrl!.isNotEmpty)
                Center(
                  child: CachedNetworkImage(
                    imageUrl: ad.mediaUrl!,
                    fit: BoxFit.contain,
                    placeholder: (_, __) => const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primary,
                      ),
                    ),
                    errorWidget: (_, __, ___) => const Icon(
                      Icons.broken_image,
                      color: Colors.white54,
                      size: 48,
                    ),
                  ),
                ),

              // ── Top Gradient Overlay for Info & Skip Button
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.fromLTRB(16, 44, 16, 20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.black.withValues(alpha: 0.85),
                        Colors.transparent,
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                  child: Row(
                    children: [
                      // "Sponsored" Pill Badge
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Text(
                          'Ad',
                          style: TextStyle(
                            fontFamily: 'sans-serif',
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      // Advertiser / Ad Title
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (ad.advertiser != null &&
                                ad.advertiser!.isNotEmpty)
                              Text(
                                ad.advertiser!,
                                style: const TextStyle(
                                  fontFamily: 'sans-serif',
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white70,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            if (ad.title != null && ad.title!.isNotEmpty)
                              Text(
                                ad.title!,
                                style: const TextStyle(
                                  fontFamily: 'sans-serif',
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                          ],
                        ),
                      ),

                      // Skip Button / Countdown Badge
                      if (ad.skipAfterSeconds > 0)
                        controller.canSkip.value
                            ? GestureDetector(
                                onTap: controller.onSkipAd,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 14,
                                    vertical: 8,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.black.withValues(alpha: 0.75),
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                      color: Colors.white.withValues(
                                        alpha: 0.4,
                                      ),
                                    ),
                                  ),
                                  child: const Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        'Skip Ad',
                                        style: TextStyle(
                                          fontFamily: 'sans-serif',
                                          fontSize: 12,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.white,
                                        ),
                                      ),
                                      SizedBox(width: 6),
                                      FaIcon(
                                        FontAwesomeIcons.forward,
                                        size: 11,
                                        color: Colors.white,
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            : Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.black.withValues(alpha: 0.6),
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color: Colors.white.withValues(alpha: 0.2),
                                  ),
                                ),
                                child: Text(
                                  'Skip in ${controller.remainingSkipSeconds.value}s',
                                  style: const TextStyle(
                                    fontFamily: 'sans-serif',
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white70,
                                  ),
                                ),
                              ),
                    ],
                  ),
                ),
              ),

              // ── Bottom Action CTA Button
              Positioned(
                bottom: 24,
                left: 20,
                right: 20,
                child: GestureDetector(
                  onTap: controller.onCtaTapped,
                  child: Container(
                    height: 48,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withValues(alpha: 0.4),
                          blurRadius: 16,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          ad.ctaText?.isNotEmpty == true
                              ? ad.ctaText!
                              : 'Learn More',
                          style: const TextStyle(
                            fontFamily: 'sans-serif',
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Icon(
                          Icons.arrow_forward_rounded,
                          color: Colors.white,
                          size: 18,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
