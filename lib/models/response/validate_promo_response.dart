class ValidatePromoResponse {
  final bool success;
  final int statusCode;
  final String message;
  final PromoData? data;

  ValidatePromoResponse({
    required this.success,
    required this.statusCode,
    required this.message,
    this.data,
  });

  factory ValidatePromoResponse.fromJson(Map<String, dynamic> json) {
    return ValidatePromoResponse(
      success: json['success'] ?? false,
      statusCode: json['statusCode'] ?? 200,
      message: json['message'] ?? '',
      data: json['data'] != null ? PromoData.fromJson(json['data']) : null,
    );
  }
}

class PromoData {
  final String code;
  final String discountType; // e.g. "PERCENTAGE", "FIXED"
  final num discountValue;
  final String applicablePlan;
  final DateTime? expiryDate;
  final String description;
  final PromoPricing? pricing;

  PromoData({
    required this.code,
    required this.discountType,
    required this.discountValue,
    required this.applicablePlan,
    this.expiryDate,
    required this.description,
    this.pricing,
  });

  factory PromoData.fromJson(Map<String, dynamic> json) {
    return PromoData(
      code: json['code'] ?? '',
      discountType: json['discountType'] ?? '',
      discountValue: json['discountValue'] ?? 0,
      applicablePlan: json['applicablePlan'] ?? 'ALL',
      expiryDate: json['expiryDate'] != null
          ? DateTime.tryParse(json['expiryDate'])
          : null,
      description: json['description'] ?? '',
      pricing: json['pricing'] != null
          ? PromoPricing.fromJson(json['pricing'])
          : null,
    );
  }
}

class PromoPricing {
  final String planId;
  final String planName;
  final String planCode;
  final num originalPrice;
  final num discountAmount;
  final num finalPrice;
  final int extraDays;

  PromoPricing({
    required this.planId,
    required this.planName,
    required this.planCode,
    required this.originalPrice,
    required this.discountAmount,
    required this.finalPrice,
    required this.extraDays,
  });

  factory PromoPricing.fromJson(Map<String, dynamic> json) {
    return PromoPricing(
      planId: json['planId'] ?? '',
      planName: json['planName'] ?? '',
      planCode: json['planCode'] ?? '',
      originalPrice: json['originalPrice'] ?? 0,
      discountAmount: json['discountAmount'] ?? 0,
      finalPrice: json['finalPrice'] ?? 0,
      extraDays: json['extraDays'] ?? 0,
    );
  }
}
