import 'dart:async';
import 'package:e_square_ott_app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:video_player/video_player.dart';
import 'package:e_square_ott_app/models/response/custom_ad_model.dart';
import 'package:e_square_ott_app/shared/service/custom_ads_service.dart';
import 'package:e_square_ott_app/shared/utils/log_util.dart';

class CustomAdController extends GetxController {
  final CustomAdsService adsService = CustomAdsService();

  // State Observables
  final RxBool isLoadingAd = false.obs;
  final RxBool isAdPlaying = false.obs;
  final Rx<CustomAdModel?> currentAd = Rx<CustomAdModel?>(null);

  // Video Controller for video ads
  VideoPlayerController? videoPlayerController;
  final RxBool isVideoInitialized = false.obs;

  // Countdown & Skip Logic
  final RxInt remainingSkipSeconds = 0.obs;
  final RxBool canSkip = false.obs;
  Timer? _countdownTimer;

  // Quartile tracking flags (to fire each quartile once per playback)
  bool _trackedStart = false;
  bool _trackedFirstQuartile = false;
  bool _trackedMidpoint = false;
  bool _trackedThirdQuartile = false;
  bool _trackedComplete = false;

  VoidCallback? onAdFinished;

  @override
  void onClose() {
    _cleanupAd();
    super.onClose();
  }

  /// Request and prepare an ad for a given placement/format
  Future<bool> loadAndShowAd({
    required String placement,
    required String format,
    required bool isVip,
    required String page,
    VoidCallback? onFinish,
  }) async {
    onAdFinished = onFinish;

    if (isVip) {
      LogUtil.log(
        '[CustomAdController] User is VIP, bypassing ad.',
        name: 'ADS',
      );
      onAdFinished?.call();
      return false;
    }

    try {
      isLoadingAd.value = true;
      final response = await adsService.serveAd(
        placement: placement,
        format: format,
        isVip: isVip,
        page: page,
      );

      isLoadingAd.value = false;

      if (response != null &&
          response.showAd &&
          response.adSource == 'CUSTOM' &&
          response.ad != null) {
        final ad = response.ad!;
        currentAd.value = ad;

        // Reset tracking flags
        _resetTrackingFlags();

        // Track Impression
        if (ad.id != null && ad.id!.isNotEmpty) {
          adsService.trackImpression(ad.id!);
        }

        // Initialize Ad Media
        if (ad.mediaType == 'VIDEO' && ad.mediaUrl != null) {
          await _setupVideoAd(ad);
        } else {
          _setupBannerOrImageAd(ad);
        }

        isAdPlaying.value = true;
        return true;
      } else {
        LogUtil.log(
          '[CustomAdController] No custom ad to show: ${response?.reason ?? 'Not applicable'}',
          name: 'ADS',
        );
        onAdFinished?.call();
        return false;
      }
    } catch (e, stack) {
      isLoadingAd.value = false;
      LogUtil.error(
        '[CustomAdController] Error loading ad: $e',
        name: 'ADS',
        error: e,
        stackTrace: stack,
      );
      onAdFinished?.call();
      return false;
    }
  }

  void _resetTrackingFlags() {
    _trackedStart = false;
    _trackedFirstQuartile = false;
    _trackedMidpoint = false;
    _trackedThirdQuartile = false;
    _trackedComplete = false;
  }

  Future<void> _setupVideoAd(CustomAdModel ad) async {
    try {
      videoPlayerController = VideoPlayerController.networkUrl(
        Uri.parse(ad.mediaUrl!),
      );

      await videoPlayerController!.initialize();
      isVideoInitialized.value = true;
      videoPlayerController!.play();

      _startSkipCountdown(ad.skipAfterSeconds);

      // Listen for quartile events & completion
      videoPlayerController!.addListener(_videoListener);
    } catch (e) {
      LogUtil.error('[CustomAdController] Video init error: $e', name: 'ADS');
      _finishAd();
    }
  }

  void _setupBannerOrImageAd(CustomAdModel ad) {
    _startSkipCountdown(ad.skipAfterSeconds > 0 ? ad.skipAfterSeconds : 5);
  }

  void _startSkipCountdown(int seconds) {
    _countdownTimer?.cancel();
    if (seconds <= 0) {
      // Unskippable during countdown or skippable immediately
      remainingSkipSeconds.value = 0;
      canSkip.value = false; // Must watch until completion
    } else {
      remainingSkipSeconds.value = seconds;
      canSkip.value = false;

      _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (remainingSkipSeconds.value > 1) {
          remainingSkipSeconds.value--;
        } else {
          remainingSkipSeconds.value = 0;
          canSkip.value = true;
          timer.cancel();
        }
      });
    }
  }

  void _videoListener() {
    if (videoPlayerController == null ||
        !videoPlayerController!.value.isInitialized) {
      return;
    }

    final duration = videoPlayerController!.value.duration.inMilliseconds;
    final position = videoPlayerController!.value.position.inMilliseconds;
    final adId = currentAd.value?.id;

    if (duration <= 0 || adId == null) return;

    final progress = position / duration;

    if (!_trackedStart && position > 200) {
      _trackedStart = true;
      adsService.trackVideoEvent(adId: adId, eventType: 'start');
    }
    if (!_trackedFirstQuartile && progress >= 0.25) {
      _trackedFirstQuartile = true;
      adsService.trackVideoEvent(adId: adId, eventType: 'firstQuartile');
    }
    if (!_trackedMidpoint && progress >= 0.50) {
      _trackedMidpoint = true;
      adsService.trackVideoEvent(adId: adId, eventType: 'midpoint');
    }
    if (!_trackedThirdQuartile && progress >= 0.75) {
      _trackedThirdQuartile = true;
      adsService.trackVideoEvent(adId: adId, eventType: 'thirdQuartile');
    }
    if (!_trackedComplete && progress >= 0.98) {
      _trackedComplete = true;
      adsService.trackVideoEvent(adId: adId, eventType: 'complete');
      _finishAd();
    }
  }

  /// User taps Skip Button
  void onSkipAd() {
    final adId = currentAd.value?.id;
    if (adId != null) {
      adsService.trackVideoEvent(adId: adId, eventType: 'skip');
    }
    _finishAd();
  }

  /// User taps CTA Button or Banner
  Future<void> onCtaTapped() async {
    final ad = currentAd.value;
    if (ad == null) return;

    if (ad.id != null && ad.id!.isNotEmpty) {
      adsService.trackClick(ad.id!);
    }

    final action = ad.ctaAction;
    if (action == 'EXTERNAL_URL' && ad.targetUrl != null) {
      final uri = Uri.tryParse(ad.targetUrl!);
      if (uri != null) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      }
    } else if (action == 'DEEP_LINK_DRAMA' && ad.targetDramaId != null) {
      _finishAd();
      Get.toNamed(Routes.dramaPlayer, arguments: {'id': ad.targetDramaId});
    } else if (action == 'DEEP_LINK_SUBSCRIPTION') {
      _finishAd();
      Get.toNamed(Routes.subscriptionPage);
    }
  }

  void _finishAd() {
    _cleanupAd();
    isAdPlaying.value = false;
    onAdFinished?.call();
  }

  void _cleanupAd() {
    _countdownTimer?.cancel();
    _countdownTimer = null;
    if (videoPlayerController != null) {
      videoPlayerController!.removeListener(_videoListener);
      videoPlayerController!.pause();
      videoPlayerController!.dispose();
      videoPlayerController = null;
    }
    isVideoInitialized.value = false;
  }
}
