class EpisodeAccessResponse {
  final bool success;
  final int statusCode;
  final String message;
  final EpisodeAccessData data;

  EpisodeAccessResponse({
    required this.success,
    required this.statusCode,
    required this.message,
    required this.data,
  });

  factory EpisodeAccessResponse.fromJson(Map<String, dynamic> json) {
    return EpisodeAccessResponse(
      success: json['success'] ?? false,
      statusCode: json['statusCode'] ?? 0,
      message: json['message'] ?? '',
      data: EpisodeAccessData.fromJson(json['data'] ?? {}),
    );
  }
}

class EpisodeAccessData {
  final bool hasAccess;
  final String reason;
  final bool isFree;
  final bool isLocked;
  final UserPlanStatus userPlanStatus;
  final AccessDrama drama;
  final AccessEpisode episode;
  final List<UpgradePlan> upgradePlans;

  EpisodeAccessData({
    required this.hasAccess,
    required this.reason,
    required this.isFree,
    required this.isLocked,
    required this.userPlanStatus,
    required this.drama,
    required this.episode,
    required this.upgradePlans,
  });

  factory EpisodeAccessData.fromJson(Map<String, dynamic> json) {
    return EpisodeAccessData(
      hasAccess: json['hasAccess'] ?? false,
      reason: json['reason'] ?? '',
      isFree: json['isFree'] ?? false,
      isLocked: json['isLocked'] ?? false,
      userPlanStatus: UserPlanStatus.fromJson(json['userPlanStatus'] ?? {}),
      drama: AccessDrama.fromJson(json['drama'] ?? {}),
      episode: AccessEpisode.fromJson(json['episode'] ?? {}),
      upgradePlans: (json['upgradePlans'] as List<dynamic>? ?? [])
          .map((e) => UpgradePlan.fromJson(e))
          .toList(),
    );
  }
}

class UserPlanStatus {
  final bool isLoggedIn;
  final bool isVip;
  final String plan;
  final DateTime? vipExpiresAt;

  UserPlanStatus({
    required this.isLoggedIn,
    required this.isVip,
    required this.plan,
    required this.vipExpiresAt,
  });

  factory UserPlanStatus.fromJson(Map<String, dynamic> json) {
    return UserPlanStatus(
      isLoggedIn: json['isLoggedIn'] ?? false,
      isVip: json['isVip'] ?? false,
      plan: json['plan'] ?? '',
      vipExpiresAt: json['vipExpiresAt'] != null
          ? DateTime.tryParse(json['vipExpiresAt'])
          : null,
    );
  }
}

class AccessDrama {
  final String id;
  final String title;
  final String slug;

  AccessDrama({required this.id, required this.title, required this.slug});

  factory AccessDrama.fromJson(Map<String, dynamic> json) {
    return AccessDrama(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      slug: json['slug'] ?? '',
    );
  }
}

class AccessEpisode {
  final String id;
  final int seasonNumber;
  final int episodeNumber;
  final String seasonEpisodeTag;
  final String title;
  final int durationSeconds;
  final String videoUrl;

  AccessEpisode({
    required this.id,
    required this.seasonNumber,
    required this.episodeNumber,
    required this.seasonEpisodeTag,
    required this.title,
    required this.durationSeconds,
    this.videoUrl = '',
  });

  factory AccessEpisode.fromJson(Map<String, dynamic> json) {
    return AccessEpisode(
      id: json['id'] ?? '',
      seasonNumber: json['seasonNumber'] ?? 0,
      episodeNumber: json['episodeNumber'] ?? 0,
      seasonEpisodeTag: json['seasonEpisodeTag'] ?? '',
      title: json['title'] ?? '',
      durationSeconds: json['durationSeconds'] ?? 0,
      videoUrl: (json['videoUrl'] ??
              json['streamUrl'] ??
              json['hlsUrl'] ??
              json['playbackUrl'] ??
              json['video'] ??
              json['url'] ??
              '')
          .toString(),
    );
  }
}

class UpgradePlan {
  final String code;
  final String name;
  final double price;
  final double originalPrice;
  final int durationDays;
  final List<String> features;

  UpgradePlan({
    required this.code,
    required this.name,
    required this.price,
    required this.originalPrice,
    required this.durationDays,
    required this.features,
  });

  factory UpgradePlan.fromJson(Map<String, dynamic> json) {
    return UpgradePlan(
      code: json['code'] ?? '',
      name: json['name'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      originalPrice: (json['originalPrice'] ?? 0).toDouble(),
      durationDays: json['durationDays'] ?? 0,
      features: List<String>.from(json['features'] ?? []),
    );
  }
}
