class ResendOtpResponseModel {
  final bool success;
  final int statusCode;
  final String message;
  final ResendOtpData data;

  ResendOtpResponseModel({
    required this.success,
    required this.statusCode,
    required this.message,
    required this.data,
  });

  factory ResendOtpResponseModel.fromJson(Map<String, dynamic> json) {
    return ResendOtpResponseModel(
      success: json['success'] ?? false,
      statusCode: json['statusCode'] ?? 0,
      message: json['message'] ?? '',
      data: ResendOtpData.fromJson(json['data'] ?? {}),
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

class ResendOtpData {
  final String phoneNumber;
  final String countryCode;
  final String maskedNumber;
  final int resendAfterSeconds;
  final int otpExpiresInSeconds;
  final String? devOtp;

  ResendOtpData({
    required this.phoneNumber,
    required this.countryCode,
    required this.maskedNumber,
    required this.resendAfterSeconds,
    required this.otpExpiresInSeconds,
    this.devOtp,
  });

  factory ResendOtpData.fromJson(Map<String, dynamic> json) {
    return ResendOtpData(
      phoneNumber: json['phoneNumber'] ?? '',
      countryCode: json['countryCode'] ?? '',
      maskedNumber: json['maskedNumber'] ?? '',
      resendAfterSeconds: json['resendAfterSeconds'] ?? 0,
      otpExpiresInSeconds: json['otpExpiresInSeconds'] ?? 0,
      devOtp: json['devOtp']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'phoneNumber': phoneNumber,
      'countryCode': countryCode,
      'maskedNumber': maskedNumber,
      'resendAfterSeconds': resendAfterSeconds,
      'otpExpiresInSeconds': otpExpiresInSeconds,
      'devOtp': devOtp,
    };
  }
}
