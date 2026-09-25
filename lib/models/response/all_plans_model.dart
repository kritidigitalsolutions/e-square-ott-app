class SubscriptionPlansResponse {
  final bool success;
  final int statusCode;
  final String message;
  final SubscriptionPlanData data;

  SubscriptionPlansResponse({
    required this.success,
    required this.statusCode,
    required this.message,
    required this.data,
  });

  factory SubscriptionPlansResponse.fromJson(Map<String, dynamic> json) {
    return SubscriptionPlansResponse(
      success: json['success'] ?? false,
      statusCode: json['statusCode'] ?? 0,
      message: json['message'] ?? '',
      data: SubscriptionPlanData.fromJson(json['data'] ?? {}),
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

class SubscriptionPlanData {
  final List<SubscriptionPlan> plans;
  final TrialConfig trialConfig;

  SubscriptionPlanData({required this.plans, required this.trialConfig});

  factory SubscriptionPlanData.fromJson(Map<String, dynamic> json) {
    return SubscriptionPlanData(
      plans: (json['plans'] as List<dynamic>? ?? [])
          .map((e) => SubscriptionPlan.fromJson(e))
          .toList(),
      trialConfig: TrialConfig.fromJson(json['trialConfig'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'plans': plans.map((e) => e.toJson()).toList(),
      'trialConfig': trialConfig.toJson(),
    };
  }
}

class SubscriptionPlan {
  final String name;
  final String code;
  final double price;
  final double originalPrice;
  final int durationDays;
  final int durationMonths;
  final String badge;
  final String savingsText;
  final List<String> features;
  final bool trialEligible;
  final double trialFee;
  final int trialDays;
  final String? razorpayPlanId;
  final String status;
  final int sortOrder;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String id;

  SubscriptionPlan({
    required this.name,
    required this.code,
    required this.price,
    required this.originalPrice,
    required this.durationDays,
    required this.durationMonths,
    required this.badge,
    required this.savingsText,
    required this.features,
    required this.trialEligible,
    required this.trialFee,
    required this.trialDays,
    this.razorpayPlanId,
    required this.status,
    required this.sortOrder,
    this.createdAt,
    this.updatedAt,
    required this.id,
  });

  factory SubscriptionPlan.fromJson(Map<String, dynamic> json) {
    return SubscriptionPlan(
      name: json['name'] ?? '',
      code: json['code'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      originalPrice: (json['originalPrice'] ?? 0).toDouble(),
      durationDays: json['durationDays'] ?? 0,
      durationMonths: json['durationMonths'] ?? 0,
      badge: json['badge'] ?? '',
      savingsText: json['savingsText'] ?? '',
      features: List<String>.from(json['features'] ?? []),
      trialEligible: json['trialEligible'] ?? false,
      trialFee: (json['trialFee'] ?? 0).toDouble(),
      trialDays: json['trialDays'] ?? 0,
      razorpayPlanId: json['razorpayPlanId'],
      status: json['status'] ?? '',
      sortOrder: json['sortOrder'] ?? 0,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'])
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt'])
          : null,
      id: json['id'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'code': code,
      'price': price,
      'originalPrice': originalPrice,
      'durationDays': durationDays,
      'durationMonths': durationMonths,
      'badge': badge,
      'savingsText': savingsText,
      'features': features,
      'trialEligible': trialEligible,
      'trialFee': trialFee,
      'trialDays': trialDays,
      'razorpayPlanId': razorpayPlanId,
      'status': status,
      'sortOrder': sortOrder,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'id': id,
    };
  }
}

class TrialConfig {
  final bool enabled;
  final double trialFee;
  final int trialDurationDays;
  final String termsText;

  TrialConfig({
    required this.enabled,
    required this.trialFee,
    required this.trialDurationDays,
    required this.termsText,
  });

  factory TrialConfig.fromJson(Map<String, dynamic> json) {
    return TrialConfig(
      enabled: json['enabled'] ?? false,
      trialFee: (json['trialFee'] ?? 0).toDouble(),
      trialDurationDays: json['trialDurationDays'] ?? 0,
      termsText: json['termsText'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'enabled': enabled,
      'trialFee': trialFee,
      'trialDurationDays': trialDurationDays,
      'termsText': termsText,
    };
  }
}
