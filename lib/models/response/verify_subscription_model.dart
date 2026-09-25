class VerifySubscriptionResponse {
  final bool success;
  final int statusCode;
  final String message;
  final VerifySubscriptionData data;

  VerifySubscriptionResponse({
    required this.success,
    required this.statusCode,
    required this.message,
    required this.data,
  });

  factory VerifySubscriptionResponse.fromJson(Map<String, dynamic> json) {
    return VerifySubscriptionResponse(
      success: json['success'] ?? false,
      statusCode: json['statusCode'] ?? 0,
      message: json['message'] ?? '',
      data: VerifySubscriptionData.fromJson(json['data'] ?? {}),
    );
  }
}

class VerifySubscriptionData {
  final bool isVip;
  final String planName;
  final String planCode;
  final String status;
  final bool isTrial;
  final DateTime? expiresAt;
  final String subscriptionId;

  VerifySubscriptionData({
    required this.isVip,
    required this.planName,
    required this.planCode,
    required this.status,
    required this.isTrial,
    required this.expiresAt,
    required this.subscriptionId,
  });

  factory VerifySubscriptionData.fromJson(Map<String, dynamic> json) {
    return VerifySubscriptionData(
      isVip: json['isVip'] ?? false,
      planName: json['planName'] ?? '',
      planCode: json['planCode'] ?? '',
      status: json['status'] ?? '',
      isTrial: json['isTrial'] ?? false,
      expiresAt: json['expiresAt'] != null
          ? DateTime.tryParse(json['expiresAt'])
          : null,
      subscriptionId: json['subscriptionId'] ?? '',
    );
  }
}
