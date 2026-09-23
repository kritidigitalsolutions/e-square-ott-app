class CompleteProfileResponseModel {
  final bool success;
  final int statusCode;
  final String message;
  final CompleteProfileData data;

  CompleteProfileResponseModel({
    required this.success,
    required this.statusCode,
    required this.message,
    required this.data,
  });

  factory CompleteProfileResponseModel.fromJson(
      Map<String, dynamic> json,
      ) {
    return CompleteProfileResponseModel(
      success: json['success'] ?? false,
      statusCode: json['statusCode'] ?? 0,
      message: json['message'] ?? '',
      data: CompleteProfileData.fromJson(json['data'] ?? {}),
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

class CompleteProfileData {
  final bool isNewUser;
  final bool isProfileCompleted;
  final String token;
  final CompleteProfileUser user;

  CompleteProfileData({
    required this.isNewUser,
    required this.isProfileCompleted,
    required this.token,
    required this.user,
  });

  factory CompleteProfileData.fromJson(Map<String, dynamic> json) {
    return CompleteProfileData(
      isNewUser: json['isNewUser'] ?? false,
      isProfileCompleted: json['isProfileCompleted'] ?? false,
      token: json['token'] ?? '',
      user: CompleteProfileUser.fromJson(json['user'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'isNewUser': isNewUser,
      'isProfileCompleted': isProfileCompleted,
      'token': token,
      'user': user.toJson(),
    };
  }
}

class CompleteProfileUser {
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
  final String status;

  CompleteProfileUser({
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
    required this.status,
  });

  factory CompleteProfileUser.fromJson(Map<String, dynamic> json) {
    return CompleteProfileUser(
      id: json['id'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
      countryCode: json['countryCode'] ?? '',
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      fullName: json['fullName'] ?? '',
      email: json['email']?.toString(),
      isVip: json['isVip'] ?? false,
      vipExpiresAt: json['vipExpiresAt']?.toString(),
      avatarUrl: json['avatarUrl'] ?? '',
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
      'isVip': isVip,
      'vipExpiresAt': vipExpiresAt,
      'avatarUrl': avatarUrl,
      'status': status,
    };
  }
}