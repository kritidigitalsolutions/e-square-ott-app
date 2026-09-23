class SaveInterestResponseModel {
  final bool success;
  final int statusCode;
  final String message;
  final SaveInterestData data;

  SaveInterestResponseModel({
    required this.success,
    required this.statusCode,
    required this.message,
    required this.data,
  });

  factory SaveInterestResponseModel.fromJson(Map<String, dynamic> json) {
    return SaveInterestResponseModel(
      success: json['success'] ?? false,
      statusCode: json['statusCode'] ?? 0,
      message: json['message'] ?? '',
      data: SaveInterestData.fromJson(json['data'] ?? {}),
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

class SaveInterestData {
  final List<InterestModel> interests;
  final InterestUser user;

  SaveInterestData({required this.interests, required this.user});

  factory SaveInterestData.fromJson(Map<String, dynamic> json) {
    return SaveInterestData(
      interests:
          (json['interests'] as List<dynamic>?)
              ?.map(
                (item) => InterestModel.fromJson(item as Map<String, dynamic>),
              )
              .toList() ??
          [],
      user: InterestUser.fromJson(json['user'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'interests': interests.map((interest) => interest.toJson()).toList(),
      'user': user.toJson(),
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

class InterestUser {
  final String id;
  final String phoneNumber;
  final String countryCode;
  final String fullName;
  final String? email;
  final List<InterestModel> interests;
  final bool isProfileCompleted;

  InterestUser({
    required this.id,
    required this.phoneNumber,
    required this.countryCode,
    required this.fullName,
    this.email,
    required this.interests,
    required this.isProfileCompleted,
  });

  factory InterestUser.fromJson(Map<String, dynamic> json) {
    return InterestUser(
      id: json['id'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
      countryCode: json['countryCode'] ?? '',
      fullName: json['fullName'] ?? '',
      email: json['email']?.toString(),
      interests:
          (json['interests'] as List<dynamic>?)
              ?.map(
                (item) => InterestModel.fromJson(item as Map<String, dynamic>),
              )
              .toList() ??
          [],
      isProfileCompleted: json['isProfileCompleted'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'phoneNumber': phoneNumber,
      'countryCode': countryCode,
      'fullName': fullName,
      'email': email,
      'interests': interests.map((interest) => interest.toJson()).toList(),
      'isProfileCompleted': isProfileCompleted,
    };
  }
}
