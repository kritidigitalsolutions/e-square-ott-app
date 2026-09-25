class PlaybackProgressResponse {
  final bool success;
  final int statusCode;
  final String message;
  final PlaybackProgressData data;

  PlaybackProgressResponse({
    required this.success,
    required this.statusCode,
    required this.message,
    required this.data,
  });

  factory PlaybackProgressResponse.fromJson(Map<String, dynamic> json) {
    return PlaybackProgressResponse(
      success: json['success'] ?? false,
      statusCode: json['statusCode'] ?? 0,
      message: json['message'] ?? '',
      data: PlaybackProgressData.fromJson(json['data'] ?? {}),
    );
  }
}

class PlaybackProgressData {
  final String dramaId;
  final int episodeNumber;
  final int watchedSeconds;
  final String formattedWatched;
  final int durationSeconds;
  final String formattedDuration;
  final double progressPercentage;
  final bool isCompleted;

  PlaybackProgressData({
    required this.dramaId,
    required this.episodeNumber,
    required this.watchedSeconds,
    required this.formattedWatched,
    required this.durationSeconds,
    required this.formattedDuration,
    required this.progressPercentage,
    required this.isCompleted,
  });

  factory PlaybackProgressData.fromJson(Map<String, dynamic> json) {
    return PlaybackProgressData(
      dramaId: json['dramaId'] ?? '',
      episodeNumber: json['episodeNumber'] ?? 0,
      watchedSeconds: json['watchedSeconds'] ?? 0,
      formattedWatched: json['formattedWatched'] ?? '',
      durationSeconds: json['durationSeconds'] ?? 0,
      formattedDuration: json['formattedDuration'] ?? '',
      progressPercentage: (json['progressPercentage'] ?? 0).toDouble(),
      isCompleted: json['isCompleted'] ?? false,
    );
  }
}
