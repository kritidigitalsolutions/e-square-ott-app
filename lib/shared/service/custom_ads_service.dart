import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:e_square_ott_app/constants/app_url.dart';
import 'package:e_square_ott_app/models/response/custom_ad_model.dart';
import 'package:e_square_ott_app/shared/service/storage_service.dart';
import 'package:e_square_ott_app/shared/utils/log_util.dart';

class CustomAdsService {
  static final CustomAdsService _instance = CustomAdsService._internal();
  factory CustomAdsService() => _instance;
  CustomAdsService._internal();

  /// Headers helper with optional auth token
  Future<Map<String, String>> _getHeaders() async {
    final token = await StorageService.getToken();
    final headers = <String, String>{
      'Content-Type': 'application/json',
    };
    if (token != null && token.isNotEmpty) {
      headers['Authorization'] = 'Bearer $token';
    }
    return headers;
  }

  /// Request ad from server
  /// [placement]: PLAYER_PREROLL | HOME_BANNER | EPISODE_TRANSITION | DRAWER_CARD | GLOBAL_POPUP
  /// [format]: VIDEO_PREROLL | BANNER | INTERSTITIAL | NATIVE_CARD
  /// [page]: WATCH_ONLY | HOME_ONLY | ALL_PAGES
  Future<ServeAdResponse?> serveAd({
    required String placement,
    required String format,
    required bool isVip,
    required String page,
    String platform = 'android',
  }) async {
    try {
      final url = Uri.parse(
        AppUrl.serveAd(
          placement: placement,
          format: format,
          platform: platform,
          isVip: isVip,
          page: page,
        ),
      );

      LogUtil.log('[CustomAdsService] serveAd request: $url', name: 'ADS');

      final headers = await _getHeaders();
      final response = await http.get(url, headers: headers);

      LogUtil.log(
        '[CustomAdsService] serveAd [${response.statusCode}]: ${response.body}',
        name: 'ADS',
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final decoded = jsonDecode(response.body);
        return ServeAdResponse.fromJson(decoded);
      }
      return null;
    } catch (e, stack) {
      LogUtil.error(
        '[CustomAdsService] serveAd error: $e',
        name: 'ADS',
        error: e,
        stackTrace: stack,
      );
      return null;
    }
  }

  /// Track impression when ad starts or is displayed
  Future<void> trackImpression(String adId) async {
    try {
      final url = Uri.parse(AppUrl.trackAdImpression(adId: adId));
      LogUtil.log('[CustomAdsService] trackImpression: $adId', name: 'ADS');
      final response = await http.post(url);
      LogUtil.log(
        '[CustomAdsService] trackImpression [${response.statusCode}]',
        name: 'ADS',
      );
    } catch (e) {
      LogUtil.error('[CustomAdsService] trackImpression error: $e', name: 'ADS');
    }
  }

  /// Track click when user taps CTA or Banner
  Future<void> trackClick(String adId) async {
    try {
      final url = Uri.parse(AppUrl.trackAdClick(adId: adId));
      LogUtil.log('[CustomAdsService] trackClick: $adId', name: 'ADS');
      final response = await http.post(url);
      LogUtil.log(
        '[CustomAdsService] trackClick [${response.statusCode}]',
        name: 'ADS',
      );
    } catch (e) {
      LogUtil.error('[CustomAdsService] trackClick error: $e', name: 'ADS');
    }
  }

  /// Track video quartiles and events
  /// [eventType]: start | firstQuartile | midpoint | thirdQuartile | complete | skip
  Future<void> trackVideoEvent({
    required String adId,
    required String eventType,
  }) async {
    try {
      final url = Uri.parse(AppUrl.trackAdVideoEvent(adId: adId));
      LogUtil.log(
        '[CustomAdsService] trackVideoEvent: $adId -> $eventType',
        name: 'ADS',
      );
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'eventType': eventType}),
      );
      LogUtil.log(
        '[CustomAdsService] trackVideoEvent [${response.statusCode}]',
        name: 'ADS',
      );
    } catch (e) {
      LogUtil.error(
        '[CustomAdsService] trackVideoEvent error: $e',
        name: 'ADS',
      );
    }
  }
}
