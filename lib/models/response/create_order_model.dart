class CreateOrderResponse {
  final bool success;
  final int statusCode;
  final String message;
  final CreateOrderData data;

  CreateOrderResponse({
    required this.success,
    required this.statusCode,
    required this.message,
    required this.data,
  });

  factory CreateOrderResponse.fromJson(Map<String, dynamic> json) {
    return CreateOrderResponse(
      success: json['success'] ?? false,
      statusCode: json['statusCode'] ?? 0,
      message: json['message'] ?? '',
      data: CreateOrderData.fromJson(json['data'] ?? {}),
    );
  }
}

class CreateOrderData {
  final String orderId;
  final double amount;
  final int amountInPaise;
  final String currency;
  final String keyId;
  final OrderPlan plan;
  final bool isTrial;

  CreateOrderData({
    required this.orderId,
    required this.amount,
    required this.amountInPaise,
    required this.currency,
    required this.keyId,
    required this.plan,
    required this.isTrial,
  });

  factory CreateOrderData.fromJson(Map<String, dynamic> json) {
    return CreateOrderData(
      orderId: json['orderId'] ?? '',
      amount: (json['amount'] ?? 0).toDouble(),
      amountInPaise: json['amountInPaise'] ?? 0,
      currency: json['currency'] ?? 'INR',
      keyId: json['keyId'] ?? '',
      plan: OrderPlan.fromJson(json['plan'] ?? {}),
      isTrial: json['isTrial'] ?? false,
    );
  }
}

class OrderPlan {
  final String id;
  final String name;
  final String code;
  final double price;
  final int durationDays;

  OrderPlan({
    required this.id,
    required this.name,
    required this.code,
    required this.price,
    required this.durationDays,
  });

  factory OrderPlan.fromJson(Map<String, dynamic> json) {
    return OrderPlan(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      code: json['code'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      durationDays: json['durationDays'] ?? 0,
    );
  }
}
