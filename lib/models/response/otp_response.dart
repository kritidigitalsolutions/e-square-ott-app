class OtpResponseModel {
  final bool success;
  final int statusCode;
  final String message;
  final OtpData data;

  OtpResponseModel({
    required this.success,
    required this.statusCode,
    required this.message,
    required this.data,
  });

  factory OtpResponseModel.fromJson(Map<String, dynamic> json) {
    return OtpResponseModel(
      success: json['success'] ?? false,
      statusCode: json['statusCode'] ?? 0,
      message: json['message'] ?? '',
      data: OtpData.fromJson(json['data'] ?? {}),
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

class OtpData {
  final String phoneNumber;
  final String countryCode;
  final String formattedNumber;
  final String maskedNumber;
  final bool isExistingUser;
  final int resendAfterSeconds;
  final int otpExpiresInSeconds;
  final String? devOtp;

  OtpData({
    required this.phoneNumber,
    required this.countryCode,
    required this.formattedNumber,
    required this.maskedNumber,
    required this.isExistingUser,
    required this.resendAfterSeconds,
    required this.otpExpiresInSeconds,
    this.devOtp,
  });

  factory OtpData.fromJson(Map<String, dynamic> json) {
    return OtpData(
      phoneNumber: json['phoneNumber'] ?? '',
      countryCode: json['countryCode'] ?? '',
      formattedNumber: json['formattedNumber'] ?? '',
      maskedNumber: json['maskedNumber'] ?? '',
      isExistingUser: json['isExistingUser'] ?? false,
      resendAfterSeconds: json['resendAfterSeconds'] ?? 0,
      otpExpiresInSeconds: json['otpExpiresInSeconds'] ?? 0,
      devOtp: json['devOtp']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'phoneNumber': phoneNumber,
      'countryCode': countryCode,
      'formattedNumber': formattedNumber,
      'maskedNumber': maskedNumber,
      'isExistingUser': isExistingUser,
      'resendAfterSeconds': resendAfterSeconds,
      'otpExpiresInSeconds': otpExpiresInSeconds,
      'devOtp': devOtp,
    };
  }
}
