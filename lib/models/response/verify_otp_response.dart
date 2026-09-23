class VerifyOtpResponseModel {
  final bool success;
  final int statusCode;
  final String message;
  final VerifyOtpData data;

  VerifyOtpResponseModel({
    required this.success,
    required this.statusCode,
    required this.message,
    required this.data,
  });

  factory VerifyOtpResponseModel.fromJson(Map<String, dynamic> json) {
    return VerifyOtpResponseModel(
      success: json['success'] ?? false,
      statusCode: json['statusCode'] ?? 0,
      message: json['message'] ?? '',
      data: VerifyOtpData.fromJson(json['data'] ?? {}),
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

class VerifyOtpData {
  final bool isNewUser;
  final bool isProfileCompleted;
  final String token;
  final VerifyUser user;

  VerifyOtpData({
    required this.isNewUser,
    required this.isProfileCompleted,
    required this.token,
    required this.user,
  });

  factory VerifyOtpData.fromJson(Map<String, dynamic> json) {
    return VerifyOtpData(
      isNewUser: json['isNewUser'] ?? false,
      isProfileCompleted: json['isProfileCompleted'] ?? false,
      token: json['token'] ?? '',
      user: VerifyUser.fromJson(json['user'] ?? {}),
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

class VerifyUser {
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

  VerifyUser({
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

  factory VerifyUser.fromJson(Map<String, dynamic> json) {
    return VerifyUser(
      id: json['id'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
      countryCode: json['countryCode'] ?? '',
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      fullName: json['fullName'] ?? '',
      email: json['email'],
      isVip: json['isVip'] ?? false,
      vipExpiresAt: json['vipExpiresAt'],
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
