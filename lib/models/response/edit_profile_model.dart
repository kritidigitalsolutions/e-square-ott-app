class EditProfileResponse {
  final bool success;
  final int statusCode;
  final String message;
  final EditProfileData data;

  EditProfileResponse({
    required this.success,
    required this.statusCode,
    required this.message,
    required this.data,
  });

  factory EditProfileResponse.fromJson(Map<String, dynamic> json) {
    return EditProfileResponse(
      success: json['success'] ?? false,
      statusCode: json['statusCode'] ?? 0,
      message: json['message'] ?? '',
      data: EditProfileData.fromJson(json['data'] ?? {}),
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

class EditProfileData {
  final String token;
  final String refreshToken;
  final EditProfileUser user;

  EditProfileData({
    required this.token,
    required this.refreshToken,
    required this.user,
  });

  factory EditProfileData.fromJson(Map<String, dynamic> json) {
    return EditProfileData(
      token: json['token'] ?? '',
      refreshToken: json['refreshToken'] ?? '',
      user: EditProfileUser.fromJson(json['user'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'token': token,
      'refreshToken': refreshToken,
      'user': user.toJson(),
    };
  }
}

class EditProfileUser {
  final String id;
  final String phoneNumber;
  final String countryCode;
  final String firstName;
  final String lastName;
  final String fullName;
  final String email;
  final String avatarUrl;
  final List<InterestModel> interests;
  final bool isProfileCompleted;
  final bool isVip;
  final String? vipExpiresAt;
  final String status;

  EditProfileUser({
    required this.id,
    required this.phoneNumber,
    required this.countryCode,
    required this.firstName,
    required this.lastName,
    required this.fullName,
    required this.email,
    required this.avatarUrl,
    required this.interests,
    required this.isProfileCompleted,
    required this.isVip,
    this.vipExpiresAt,
    required this.status,
  });

  factory EditProfileUser.fromJson(Map<String, dynamic> json) {
    return EditProfileUser(
      id: json['id'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
      countryCode: json['countryCode'] ?? '',
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      fullName: json['fullName'] ?? '',
      email: json['email'] ?? '',
      avatarUrl: json['avatarUrl'] ?? '',
      interests: (json['interests'] as List<dynamic>? ?? [])
          .map((e) => InterestModel.fromJson(e))
          .toList(),
      isProfileCompleted: json['isProfileCompleted'] ?? false,
      isVip: json['isVip'] ?? false,
      vipExpiresAt: json['vipExpiresAt'],
      status: json['status'] ?? '',
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
      'avatarUrl': avatarUrl,
      'interests': interests.map((e) => e.toJson()).toList(),
      'isProfileCompleted': isProfileCompleted,
      'isVip': isVip,
      'vipExpiresAt': vipExpiresAt,
      'status': status,
    };
  }
}

class InterestModel {
  final String slug;
  final String icon;
  final String iconUrl;
  final String imageUrl;
  final String name;
  final String id;

  InterestModel({
    required this.slug,
    required this.icon,
    required this.iconUrl,
    required this.imageUrl,
    required this.name,
    required this.id,
  });

  factory InterestModel.fromJson(Map<String, dynamic> json) {
    return InterestModel(
      slug: json['slug'] ?? '',
      icon: json['icon'] ?? '',
      iconUrl: json['iconUrl'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      name: json['name'] ?? '',
      id: json['id'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'slug': slug,
      'icon': icon,
      'iconUrl': iconUrl,
      'imageUrl': imageUrl,
      'name': name,
      'id': id,
    };
  }
}
