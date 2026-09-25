class UpgradeOrderResponse {
  final bool success;
  final int statusCode;
  final String message;
  final UpgradeOrderData data;

  UpgradeOrderResponse({
    required this.success,
    required this.statusCode,
    required this.message,
    required this.data,
  });

  factory UpgradeOrderResponse.fromJson(Map<String, dynamic> json) {
    return UpgradeOrderResponse(
      success: json['success'] ?? false,
      statusCode: json['statusCode'] ?? 0,
      message: json['message'] ?? '',
      data: UpgradeOrderData.fromJson(json['data'] ?? {}),
    );
  }
}

class UpgradeOrderData {
  final String orderId;
  final double amount;
  final int amountInPaise;
  final String currency;
  final String keyId;
  final UpgradePlan newPlan;
  final TimeStacking timeStacking;

  UpgradeOrderData({
    required this.orderId,
    required this.amount,
    required this.amountInPaise,
    required this.currency,
    required this.keyId,
    required this.newPlan,
    required this.timeStacking,
  });

  factory UpgradeOrderData.fromJson(Map<String, dynamic> json) {
    return UpgradeOrderData(
      orderId: json['orderId'] ?? '',
      amount: (json['amount'] ?? 0).toDouble(),
      amountInPaise: json['amountInPaise'] ?? 0,
      currency: json['currency'] ?? 'INR',
      keyId: json['keyId'] ?? '',
      newPlan: UpgradePlan.fromJson(json['newPlan'] ?? {}),
      timeStacking: TimeStacking.fromJson(json['timeStacking'] ?? {}),
    );
  }
}

class UpgradePlan {
  final String id;
  final String name;
  final String code;
  final double price;
  final int durationDays;

  UpgradePlan({
    required this.id,
    required this.name,
    required this.code,
    required this.price,
    required this.durationDays,
  });

  factory UpgradePlan.fromJson(Map<String, dynamic> json) {
    return UpgradePlan(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      code: json['code'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      durationDays: json['durationDays'] ?? 0,
    );
  }
}

class TimeStacking {
  final int currentRemainingDays;
  final int newPlanDays;
  final int totalNewDays;

  TimeStacking({
    required this.currentRemainingDays,
    required this.newPlanDays,
    required this.totalNewDays,
  });

  factory TimeStacking.fromJson(Map<String, dynamic> json) {
    return TimeStacking(
      currentRemainingDays: json['currentRemainingDays'] ?? 0,
      newPlanDays: json['newPlanDays'] ?? 0,
      totalNewDays: json['totalNewDays'] ?? 0,
    );
  }
}
