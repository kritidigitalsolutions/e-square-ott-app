class ProfileResponseModel {
  final bool success;
  final int statusCode;
  final String message;
  final ProfileData? data;

  ProfileResponseModel({
    required this.success,
    required this.statusCode,
    required this.message,
    this.data,
  });

  factory ProfileResponseModel.fromJson(Map<String, dynamic> json) {
    return ProfileResponseModel(
      success: json['success'] ?? false,
      statusCode: json['statusCode'] ?? 0,
      message: json['message'] ?? '',
      data: json['data'] != null ? ProfileData.fromJson(json['data']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'statusCode': statusCode,
      'message': message,
      'data': data?.toJson(),
    };
  }
}

class ProfileData {
  final ProfileUser? user;

  ProfileData({this.user});

  factory ProfileData.fromJson(Map<String, dynamic> json) {
    return ProfileData(
      user: json['user'] != null ? ProfileUser.fromJson(json['user']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {'user': user?.toJson()};
  }
}

class ProfileUser {
  final String id;
  final String phoneNumber;
  final String countryCode;
  final String firstName;
  final String lastName;
  final String fullName;
  final String? email;
  final bool isVip;
  final String? vipExpiresAt;
  final String avatarUrl;
  final List<String> interests;
  final List<String> preferredContentLanguages;
  final UserSettings? settings;
  final String status;
  final bool isProfileCompleted;
  final String createdAt;

  ProfileUser({
    required this.id,
    required this.phoneNumber,
    required this.countryCode,
    required this.firstName,
    required this.lastName,
    required this.fullName,
    this.email,
    required this.isVip,
    this.vipExpiresAt,
    required this.avatarUrl,
    required this.interests,
    required this.preferredContentLanguages,
    this.settings,
    required this.status,
    required this.isProfileCompleted,
    required this.createdAt,
  });

  factory ProfileUser.fromJson(Map<String, dynamic> json) {
    return ProfileUser(
      id: json['id']?.toString() ?? '',
      phoneNumber: json['phoneNumber']?.toString() ?? '',
      countryCode: json['countryCode']?.toString() ?? '',
      firstName: json['firstName']?.toString() ?? '',
      lastName: json['lastName']?.toString() ?? '',
      fullName: json['fullName']?.toString() ?? '',
      email: json['email']?.toString(),
      isVip: json['isVip'] ?? false,
      vipExpiresAt: json['vipExpiresAt']?.toString(),
      avatarUrl: json['avatarUrl']?.toString() ?? '',
      interests: json['interests'] != null
          ? List<String>.from(json['interests'].map((x) => x.toString()))
          : [],
      preferredContentLanguages: json['preferredContentLanguages'] != null
          ? List<String>.from(
              json['preferredContentLanguages'].map((x) => x.toString()),
            )
          : [],
      settings: json['settings'] != null
          ? UserSettings.fromJson(json['settings'])
          : null,
      status: json['status']?.toString() ?? '',
      isProfileCompleted: json['isProfileCompleted'] ?? false,
      createdAt: json['createdAt']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'phoneNumber': phoneNumber,
      'countryCode': countryCode,
      'firstName': firstName,
      'lastName': lastName,
      'fullName': fullName,
      'email': email,
      'isVip': isVip,
      'vipExpiresAt': vipExpiresAt,
      'avatarUrl': avatarUrl,
      'interests': interests,
      'preferredContentLanguages': preferredContentLanguages,
      'settings': settings?.toJson(),
      'status': status,
      'isProfileCompleted': isProfileCompleted,
      'createdAt': createdAt,
    };
  }

  ProfileUser copyWith({
    String? id,
    String? phoneNumber,
    String? countryCode,
    String? firstName,
    String? lastName,
    String? fullName,
    String? email,
    bool? isVip,
    String? vipExpiresAt,
    String? avatarUrl,
    List<String>? interests,
    List<String>? preferredContentLanguages,
    UserSettings? settings,
    String? status,
    bool? isProfileCompleted,
    String? createdAt,
  }) {
    return ProfileUser(
      id: id ?? this.id,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      countryCode: countryCode ?? this.countryCode,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      isVip: isVip ?? this.isVip,
      vipExpiresAt: vipExpiresAt ?? this.vipExpiresAt,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      interests: interests ?? this.interests,
      preferredContentLanguages:
          preferredContentLanguages ?? this.preferredContentLanguages,
      settings: settings ?? this.settings,
      status: status ?? this.status,
      isProfileCompleted: isProfileCompleted ?? this.isProfileCompleted,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

class UserSettings {
  final NotificationSettings? notifications;
  final bool autoplayNext;
  final String videoQuality;
  final String appLanguage;

  UserSettings({
    this.notifications,
    required this.autoplayNext,
    required this.videoQuality,
    required this.appLanguage,
  });

  factory UserSettings.fromJson(Map<String, dynamic> json) {
    return UserSettings(
      notifications: json['notifications'] != null
          ? NotificationSettings.fromJson(json['notifications'])
          : null,
      autoplayNext: json['autoplayNext'] ?? false,
      videoQuality: json['videoQuality']?.toString() ?? 'Auto',
      appLanguage: json['appLanguage']?.toString() ?? 'English',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'notifications': notifications?.toJson(),
      'autoplayNext': autoplayNext,
      'videoQuality': videoQuality,
      'appLanguage': appLanguage,
    };
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
