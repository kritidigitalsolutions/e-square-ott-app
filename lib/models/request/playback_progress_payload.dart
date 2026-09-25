class PlaybackProgressPayload {
  final String dramaId;
  final int episodeNumber;
  final int watchedSeconds;
  final int durationSeconds;

  PlaybackProgressPayload({
    required this.dramaId,
    required this.episodeNumber,
    required this.watchedSeconds,
    required this.durationSeconds,
  });

  Map<String, dynamic> toJson() {
    return {
      'dramaId': dramaId,
      'episodeNumber': episodeNumber,
      'watchedSeconds': watchedSeconds,
      'durationSeconds': durationSeconds,
    };
  }
}
