class ToggleSavedSeriesResponse {
  final bool success;
  final int statusCode;
  final String message;
  final ToggleSavedSeriesData data;

  ToggleSavedSeriesResponse({
    required this.success,
    required this.statusCode,
    required this.message,
    required this.data,
  });

  factory ToggleSavedSeriesResponse.fromJson(Map<String, dynamic> json) {
    return ToggleSavedSeriesResponse(
      success: json['success'] ?? false,
      statusCode: json['statusCode'] ?? 0,
      message: json['message'] ?? '',
      data: ToggleSavedSeriesData.fromJson(json['data'] ?? {}),
    );
  }
}

class ToggleSavedSeriesData {
  final String? savedId;
  final String dramaId;
  final String dramaTitle;
  final bool isSaved;
  final String action;
  final String? addedAt;
  final int totalSaved;

  ToggleSavedSeriesData({
    this.savedId,
    required this.dramaId,
    required this.dramaTitle,
    required this.isSaved,
    required this.action,
    this.addedAt,
    required this.totalSaved,
  });

  factory ToggleSavedSeriesData.fromJson(Map<String, dynamic> json) {
    return ToggleSavedSeriesData(
      savedId: json['savedId'],
      dramaId: json['dramaId'] ?? '',
      dramaTitle: json['dramaTitle'] ?? '',
      isSaved: json['isSaved'] ?? false,
      action: json['action'] ?? '',
      addedAt: json['addedAt'],
      totalSaved: json['totalSaved'] ?? 0,
    );
  }
}
