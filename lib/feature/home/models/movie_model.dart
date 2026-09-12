class MovieModel {
  final String id;
  final String title;
  final String image;
  final String? subtitle;
  final String views;
  final String plays;
  final double? progress;
  final int? ranking;
  final String? genre;

  final String? episodeInfo;
  final String? remainingTime;

  const MovieModel({
    required this.id,
    required this.title,
    required this.image,
    this.subtitle,
    this.views = '2.5k',
    this.plays = '3.5k',
    this.progress,
    this.ranking,
    this.genre,
    this.episodeInfo,
    this.remainingTime,
  });
}
