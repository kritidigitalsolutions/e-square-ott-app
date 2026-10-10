class RedeemVoucherResponse {
  final bool success;
  final int statusCode;
  final String message;
  final RedeemedVoucherData? data;

  RedeemVoucherResponse({
    required this.success,
    required this.statusCode,
    required this.message,
    this.data,
  });

  factory RedeemVoucherResponse.fromJson(Map<String, dynamic> json) {
    return RedeemVoucherResponse(
      success: json['success'] ?? false,
      statusCode: json['statusCode'] ?? 200,
      message: json['message'] ?? '',
      data: json['data'] != null
          ? RedeemedVoucherData.fromJson(json['data'])
          : null,
    );
  }
}

class RedeemedVoucherData {
  final String code;
  final String planName;
  final int durationDays;
  final bool userActivated;
  final int currentUses;
  final int maxUses;

  RedeemedVoucherData({
    required this.code,
    required this.planName,
    required this.durationDays,
    required this.userActivated,
    required this.currentUses,
    required this.maxUses,
  });

  factory RedeemedVoucherData.fromJson(Map<String, dynamic> json) {
    return RedeemedVoucherData(
      code: json['code'] ?? '',
      planName: json['planName'] ?? '',
      durationDays: json['durationDays'] ?? 0,
      userActivated: json['userActivated'] ?? false,
      currentUses: json['currentUses'] ?? 0,
      maxUses: json['maxUses'] ?? 1,
    );
  }
}
