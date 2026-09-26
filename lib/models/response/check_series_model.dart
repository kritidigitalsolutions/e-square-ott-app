class CheckSavedSeriesResponse {
  final bool success;
  final int statusCode;
  final String message;
  final CheckSavedSeriesData data;

  CheckSavedSeriesResponse({
    required this.success,
    required this.statusCode,
    required this.message,
    required this.data,
  });

  factory CheckSavedSeriesResponse.fromJson(Map<String, dynamic> json) {
    return CheckSavedSeriesResponse(
      success: json['success'] ?? false,
      statusCode: json['statusCode'] ?? 0,
      message: json['message'] ?? '',
      data: CheckSavedSeriesData.fromJson(json['data'] ?? {}),
    );
  }
}

class CheckSavedSeriesData {
  final String dramaId;
  final String dramaTitle;
  final bool isSaved;
  final String? addedAt;
  final String? savedId;

  CheckSavedSeriesData({
    required this.dramaId,
    required this.dramaTitle,
    required this.isSaved,
    this.addedAt,
    this.savedId,
  });

  factory CheckSavedSeriesData.fromJson(Map<String, dynamic> json) {
    return CheckSavedSeriesData(
      dramaId: json['dramaId'] ?? '',
      dramaTitle: json['dramaTitle'] ?? '',
      isSaved: json['isSaved'] ?? false,
      addedAt: json['addedAt'],
      savedId: json['savedId'],
    );
  }
}
