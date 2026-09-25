class CreateOrderPayload {
  final String planId;
  final bool isTrial;

  CreateOrderPayload({required this.planId, required this.isTrial});

  Map<String, dynamic> toJson() {
    return {'planId': planId, 'isTrial': isTrial};
  }
}
