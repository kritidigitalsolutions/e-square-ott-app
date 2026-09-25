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
  });

  factory DramaDetails.fromJson(Map<String, dynamic> json) {
    return DramaDetails(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      slug: json['slug'] ?? '',
      synopsis: json['synopsis'] ?? '',
      posterUrl: json['posterUrl'] ?? '',
      bannerUrl: json['bannerUrl'] ?? '',
      trailerUrl: json['trailerUrl'] ?? '',
      genres: List<String>.from(json['genres'] ?? []),
      genreDisplay: json['genreDisplay'] ?? '',
      rating: (json['rating'] ?? 0).toDouble(),
      viewsCount: json['viewsCount'] ?? 0,
      totalEpisodes: json['totalEpisodes'] ?? 0,
      firstEpisode: json['firstEpisode'] != null
          ? FirstEpisode.fromJson(json['firstEpisode'])
          : null,
      continueWatching: json['continueWatching'] != null
          ? ContinueWatching.fromJson(json['continueWatching'])
          : null,
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
