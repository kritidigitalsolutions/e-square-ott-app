class VoucherHistoryResponse {
  final bool success;
  final int statusCode;
  final String message;
  final VoucherHistoryData? data;

  VoucherHistoryResponse({
    required this.success,
    required this.statusCode,
    required this.message,
    this.data,
  });

  factory VoucherHistoryResponse.fromJson(Map<String, dynamic> json) {
    return VoucherHistoryResponse(
      success: json['success'] ?? false,
      statusCode: json['statusCode'] ?? 200,
      message: json['message'] ?? '',
      data: json['data'] != null
          ? VoucherHistoryData.fromJson(json['data'])
          : null,
    );
  }
}

class VoucherHistoryData {
  final int totalRedeemed;
  final List<VoucherHistoryItem> history;

  VoucherHistoryData({
    required this.totalRedeemed,
    required this.history,
  });

  factory VoucherHistoryData.fromJson(Map<String, dynamic> json) {
    var historyList = <VoucherHistoryItem>[];
    if (json['history'] != null) {
      json['history'].forEach((v) {
        historyList.add(VoucherHistoryItem.fromJson(v));
      });
    }
    return VoucherHistoryData(
      totalRedeemed: json['totalRedeemed'] ?? 0,
      history: historyList,
    );
  }
}

class VoucherHistoryItem {
  final String code;
  final String planName;
  final int durationDays;
  final String campaignName;
  final DateTime? redeemedAt;

  VoucherHistoryItem({
    required this.code,
    required this.planName,
    required this.durationDays,
    required this.campaignName,
    this.redeemedAt,
  });

  factory VoucherHistoryItem.fromJson(Map<String, dynamic> json) {
    return VoucherHistoryItem(
      code: json['code'] ?? '',
      planName: json['planName'] ?? '',
      durationDays: json['durationDays'] ?? 0,
      campaignName: json['campaignName'] ?? '',
      redeemedAt: json['redeemedAt'] != null
          ? DateTime.tryParse(json['redeemedAt'])
          : null,
    );
  }
}
