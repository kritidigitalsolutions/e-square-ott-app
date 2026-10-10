class ValidateVoucherPayload {
  final String code;

  ValidateVoucherPayload({
    required this.code,
  });

  Map<String, dynamic> toJson() => {
        "code": code,
      };
}
