class NotificationSettingsResponse {
  final bool success;
  final int statusCode;
  final String message;
  final NotificationSettingsData data;

  NotificationSettingsResponse({
    required this.success,
    required this.statusCode,
    required this.message,
    required this.data,
  });

  factory NotificationSettingsResponse.fromJson(Map<String, dynamic> json) {
    return NotificationSettingsResponse(
      success: json['success'] ?? false,
      statusCode: json['statusCode'] ?? 0,
      message: json['message'] ?? '',
      data: NotificationSettingsData.fromJson(json['data'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'statusCode': statusCode,
      'message': message,
      'data': data.toJson(),
    };
  }
}

class NotificationSettingsData {
  final NotificationSettings settings;

  NotificationSettingsData({required this.settings});

  factory NotificationSettingsData.fromJson(Map<String, dynamic> json) {
    return NotificationSettingsData(
      settings: NotificationSettings.fromJson(json['settings'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {'settings': settings.toJson()};
  }
}

class NotificationSettings {
  final bool newEpisodes;
  final bool newReleases;
  final bool recommendations;

  NotificationSettings({
    required this.newEpisodes,
    required this.newReleases,
    required this.recommendations,
  });

  factory NotificationSettings.fromJson(Map<String, dynamic> json) {
    return NotificationSettings(
      newEpisodes: json['newEpisodes'] ?? false,
      newReleases: json['newReleases'] ?? false,
      recommendations: json['recommendations'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'newEpisodes': newEpisodes,
      'newReleases': newReleases,
      'recommendations': recommendations,
    };
  }
}
