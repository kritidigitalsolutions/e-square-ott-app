class CustomAdModel {
  final String? id;
  final String? title;
  final String? advertiser;
  final String? type;
  final String? placement;
  final String? mediaType;
  final String? mediaUrl;
  final String? thumbnailUrl;
  final String? companionBannerUrl;
  final int videoDuration;
  final int skipAfterSeconds;
  final String? ctaText;
  final String? ctaAction;
  final String? targetUrl;
  final String? targetDramaId;

  CustomAdModel({
    this.id,
    this.title,
    this.advertiser,
    this.type,
    this.placement,
    this.mediaType,
    this.mediaUrl,
    this.thumbnailUrl,
    this.companionBannerUrl,
    this.videoDuration = 0,
    this.skipAfterSeconds = 0,
    this.ctaText,
    this.ctaAction,
    this.targetUrl,
    this.targetDramaId,
  });

  factory CustomAdModel.fromJson(Map<String, dynamic> json) {
    return CustomAdModel(
      id: json['id'] ?? json['_id'],
      title: json['title'],
      advertiser: json['advertiser'],
      type: json['type'],
      placement: json['placement'],
      mediaType: json['mediaType'],
      mediaUrl: json['mediaUrl'],
      thumbnailUrl: json['thumbnailUrl'],
      companionBannerUrl: json['companionBannerUrl'],
      videoDuration: json['videoDuration'] is int
          ? json['videoDuration']
          : int.tryParse(json['videoDuration']?.toString() ?? '0') ?? 0,
      skipAfterSeconds: json['skipAfterSeconds'] is int
          ? json['skipAfterSeconds']
          : int.tryParse(json['skipAfterSeconds']?.toString() ?? '0') ?? 0,
      ctaText: json['ctaText'],
      ctaAction: json['ctaAction'],
      targetUrl: json['targetUrl'],
      targetDramaId: json['targetDramaId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'advertiser': advertiser,
      'type': type,
      'placement': placement,
      'mediaType': mediaType,
      'mediaUrl': mediaUrl,
      'thumbnailUrl': thumbnailUrl,
      'companionBannerUrl': companionBannerUrl,
      'videoDuration': videoDuration,
      'skipAfterSeconds': skipAfterSeconds,
      'ctaText': ctaText,
      'ctaAction': ctaAction,
      'targetUrl': targetUrl,
      'targetDramaId': targetDramaId,
    };
  }
}

class ServeAdResponse {
  final bool success;
  final bool showAd;
  final String? adSource;
  final String? reason;
  final CustomAdModel? ad;
  final String? format;

  ServeAdResponse({
    this.success = false,
    this.showAd = false,
    this.adSource,
    this.reason,
    this.ad,
    this.format,
  });

  factory ServeAdResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>?;
    return ServeAdResponse(
      success: json['success'] ?? false,
      showAd: data?['showAd'] ?? false,
      adSource: data?['adSource'],
      reason: data?['reason'],
      ad: data?['ad'] != null ? CustomAdModel.fromJson(data!['ad']) : null,
      format: data?['format'],
    );
  }
}
