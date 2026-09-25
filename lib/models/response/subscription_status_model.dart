class SubscriptionStatusResponse {
  final bool success;
  final int statusCode;
  final String message;
  final SubscriptionStatusData data;

  SubscriptionStatusResponse({
    required this.success,
    required this.statusCode,
    required this.message,
    required this.data,
  });

  factory SubscriptionStatusResponse.fromJson(Map<String, dynamic> json) {
    return SubscriptionStatusResponse(
      success: json['success'] ?? false,
      statusCode: json['statusCode'] ?? 0,
      message: json['message'] ?? '',
      data: SubscriptionStatusData.fromJson(json['data'] ?? {}),
    );
  }
}

class SubscriptionStatusData {
  final bool isVip;
  final String planName;
  final String planCode;
  final String status;
  final bool isTrial;
  final int daysRemaining;
  final DateTime? expiresAt;
  final bool autoRenew;
  final bool canClaimTrial;
  final String? cancellationNotice;

  SubscriptionStatusData({
    required this.isVip,
    required this.planName,
    required this.planCode,
    required this.status,
    required this.isTrial,
    required this.daysRemaining,
    required this.expiresAt,
    required this.autoRenew,
    required this.canClaimTrial,
    required this.cancellationNotice,
  });

  factory SubscriptionStatusData.fromJson(Map<String, dynamic> json) {
    return SubscriptionStatusData(
      isVip: json['isVip'] ?? false,
      planName: json['planName'] ?? '',
      planCode: json['planCode'] ?? '',
      status: json['status'] ?? '',
      isTrial: json['isTrial'] ?? false,
      daysRemaining: json['daysRemaining'] ?? 0,
      expiresAt: json['expiresAt'] != null
          ? DateTime.tryParse(json['expiresAt'])
          : null,
      autoRenew: json['autoRenew'] ?? false,
      canClaimTrial: json['canClaimTrial'] ?? false,
      cancellationNotice: json['cancellationNotice'],
    );
  }
}
