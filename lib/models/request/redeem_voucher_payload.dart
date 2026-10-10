class RedeemVoucherPayload {
  final String code;
  final String? phoneNumber;

  RedeemVoucherPayload({
    required this.code,
    this.phoneNumber,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      "code": code,
    };
    if (phoneNumber != null && phoneNumber!.isNotEmpty) {
      data["phoneNumber"] = phoneNumber;
    }
    return data;
  }
}
