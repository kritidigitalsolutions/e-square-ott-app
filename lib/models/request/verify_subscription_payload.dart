class VerifySubscriptionPayload {
  final String orderId;
  final String paymentId;
  final String signature;
  final String planId;
  final bool isTrial;

  VerifySubscriptionPayload({
    required this.orderId,
    required this.paymentId,
    required this.signature,
    required this.planId,
    required this.isTrial,
  });

  Map<String, dynamic> toJson() {
    return {
      'orderId': orderId,
      'paymentId': paymentId,
      'signature': signature,
      'planId': planId,
      'isTrial': isTrial,
    };
  }
}
