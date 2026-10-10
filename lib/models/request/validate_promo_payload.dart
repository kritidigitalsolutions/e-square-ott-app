class ValidatePromoPayload {
  final String code;
  final String planId;

  ValidatePromoPayload({
    required this.code,
    required this.planId,
  });

  Map<String, dynamic> toJson() => {
        "code": code,
        "planId": planId,
      };
}
