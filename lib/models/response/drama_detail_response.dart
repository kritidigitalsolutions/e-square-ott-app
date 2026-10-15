class DramaDetailsResponse {
  final bool success;
  final int statusCode;
  final String message;
  final DramaDetailsData data;

  DramaDetailsResponse({
    required this.success,
    required this.statusCode,
    required this.message,
    required this.data,
  });

  factory DramaDetailsResponse.fromJson(Map<String, dynamic> json) {
    return DramaDetailsResponse(
      success: json['success'] ?? false,
      statusCode: json['statusCode'] ?? 0,
      message: json['message'] ?? '',
      data: DramaDetailsData.fromJson(json['data'] ?? {}),
    );
  }
}

class DramaDetailsData {
  final DramaDetails drama;

  DramaDetailsData({required this.drama});

  factory DramaDetailsData.fromJson(Map<String, dynamic> json) {
    return DramaDetailsData(drama: DramaDetails.fromJson(json['drama'] ?? {}));
  }
}

class DramaDetails {
  final String id;
  final String title;
  final String slug;
  final String synopsis;
  final String posterUrl;
  final String bannerUrl;
  final String trailerUrl;
  final List<String> genres;
  final String genreDisplay;
  final double rating;
  final int viewsCount;
  final int totalEpisodes;
  final FirstEpisode? firstEpisode;
  final ContinueWatching? continueWatching;
  final List<DramaEpisodeDetail> episodes;

  DramaDetails({
    required this.id,
    required this.title,
    required this.slug,
    required this.synopsis,
    required this.posterUrl,
    required this.bannerUrl,
    required this.trailerUrl,
    required this.genres,
    required this.genreDisplay,
    required this.rating,
    required this.viewsCount,
    required this.totalEpisodes,
    required this.firstEpisode,
    required this.continueWatching,
    this.episodes = const [],
  });

  factory DramaDetails.fromJson(Map<String, dynamic> json) {
    return DramaDetails(
      id: json['id'] ?? json['_id'] ?? '',
      title: json['title'] ?? json['name'] ?? '',
      slug: json['slug'] ?? '',
      synopsis: json['synopsis'] ?? json['description'] ?? json['overview'] ?? '',
      posterUrl: json['posterUrl'] ?? json['poster'] ?? json['thumbnailUrl'] ?? json['thumbnail'] ?? json['coverImage'] ?? '',
      bannerUrl: json['bannerUrl'] ?? json['banner'] ?? '',
      trailerUrl: json['trailerUrl'] ?? json['trailer'] ?? '',
      genres: List<String>.from(json['genres'] ?? []),
      genreDisplay: json['genreDisplay'] ?? '',
      rating: (json['rating'] ?? 0).toDouble(),
      viewsCount: json['viewsCount'] ?? 0,
      totalEpisodes: json['totalEpisodes'] ?? json['episodesCount'] ?? 0,
      firstEpisode: json['firstEpisode'] != null
          ? FirstEpisode.fromJson(json['firstEpisode'])
          : null,
      continueWatching: json['continueWatching'] != null
          ? ContinueWatching.fromJson(json['continueWatching'])
          : null,
      episodes: (json['episodes'] as List<dynamic>? ?? [])
          .map((e) => DramaEpisodeDetail.fromJson(e))
          .toList(),
    );
  }
}

class DramaEpisodeDetail {
  final String id;
  final String dramaId;
  final int episodeNumber;
  final String title;
  final String synopsis;
  final String thumbnailUrl;
  final String videoUrl;
  final String duration;
  final int durationSeconds;
  final bool isFree;
  final String views;

  DramaEpisodeDetail({
    required this.id,
    required this.dramaId,
    required this.episodeNumber,
    required this.title,
    required this.synopsis,
    required this.thumbnailUrl,
    required this.videoUrl,
    required this.duration,
    required this.durationSeconds,
    required this.isFree,
    required this.views,
  });

  factory DramaEpisodeDetail.fromJson(Map<String, dynamic> json) {
    return DramaEpisodeDetail(
      id: json['id'] ?? json['_id'] ?? '',
      dramaId: json['dramaId'] ?? '',
      episodeNumber: json['episodeNumber'] ?? 0,
      title: json['title'] ?? 'Episode ${json['episodeNumber'] ?? 1}',
      synopsis: json['synopsis'] ?? '',
      thumbnailUrl: json['thumbnailUrl'] ?? json['thumbnail'] ?? '',
      videoUrl: (json['videoStreamUrl'] ??
              json['videoUrl'] ??
              json['streamUrl'] ??
              json['video'] ??
              '')
          .toString(),
      duration: json['duration'] ?? '',
      durationSeconds: json['durationSeconds'] ?? 0,
      isFree: json['isFree'] ?? false,
      views: (json['views'] ?? '0').toString(),
    );
  }
}

class FirstEpisode {
  final String id;
  final int episodeNumber;
  final String seasonEpisodeTag;
  final String title;
  final int durationSeconds;
  final String formattedDuration;

  FirstEpisode({
    required this.id,
    required this.episodeNumber,
    required this.seasonEpisodeTag,
    required this.title,
    required this.durationSeconds,
    required this.formattedDuration,
  });

  factory FirstEpisode.fromJson(Map<String, dynamic> json) {
    return FirstEpisode(
      id: json['id'] ?? '',
      episodeNumber: json['episodeNumber'] ?? 0,
      seasonEpisodeTag: json['seasonEpisodeTag'] ?? '',
      title: json['title'] ?? '',
      durationSeconds: json['durationSeconds'] ?? 0,
      formattedDuration: json['formattedDuration'] ?? '',
    );
  }
}

class ContinueWatching {
  ContinueWatching();

  factory ContinueWatching.fromJson(Map<String, dynamic> json) {
    return ContinueWatching();
  }
}
