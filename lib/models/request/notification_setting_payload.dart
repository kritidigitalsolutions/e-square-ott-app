class NotificationSettingsPayload {
  final bool newEpisodes;
  final bool newReleases;
  final bool recommendations;

  NotificationSettingsPayload({
    required this.newEpisodes,
    required this.newReleases,
    required this.recommendations,
  });

  Map<String, dynamic> toJson() {
    return {
      'newEpisodes': newEpisodes,
      'newReleases': newReleases,
      'recommendations': recommendations,
    };
  }
}
