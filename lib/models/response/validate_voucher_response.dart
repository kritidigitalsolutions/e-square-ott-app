class ValidateVoucherResponse {
  final bool success;
  final int statusCode;
  final String message;
  final ValidatedVoucherData? data;

  ValidateVoucherResponse({
    required this.success,
    required this.statusCode,
    required this.message,
    this.data,
  });

  factory ValidateVoucherResponse.fromJson(Map<String, dynamic> json) {
    return ValidateVoucherResponse(
      success: json['success'] ?? false,
      statusCode: json['statusCode'] ?? 200,
      message: json['message'] ?? '',
      data: json['data'] != null
          ? ValidatedVoucherData.fromJson(json['data'])
          : null,
    );
  }
}

class ValidatedVoucherData {
  final String code;
  final String planCode;
  final String planName;
  final int durationDays;
  final DateTime? expiryDate;
  final String voucherType;
  final String campaignName;

  ValidatedVoucherData({
    required this.code,
    required this.planCode,
    required this.planName,
    required this.durationDays,
    this.expiryDate,
    required this.voucherType,
    required this.campaignName,
  });

  factory ValidatedVoucherData.fromJson(Map<String, dynamic> json) {
    return ValidatedVoucherData(
      code: json['code'] ?? '',
      planCode: json['planCode'] ?? '',
      planName: json['planName'] ?? '',
      durationDays: json['durationDays'] ?? 0,
      expiryDate: json['expiryDate'] != null
          ? DateTime.tryParse(json['expiryDate'])
          : null,
      voucherType: json['voucherType'] ?? 'PLAN_GRANT',
      campaignName: json['campaignName'] ?? '',
    );
  }
}
