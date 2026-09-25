class EpisodesDrawerResponse {
  final bool success;
  final int statusCode;
  final String message;
  final EpisodesDrawerData data;

  EpisodesDrawerResponse({
    required this.success,
    required this.statusCode,
    required this.message,
    required this.data,
  });

  factory EpisodesDrawerResponse.fromJson(Map<String, dynamic> json) {
    return EpisodesDrawerResponse(
      success: json['success'] ?? false,
      statusCode: json['statusCode'] ?? 0,
      message: json['message'] ?? '',
      data: EpisodesDrawerData.fromJson(json['data'] ?? {}),
    );
  }
}

class EpisodesDrawerData {
  final DrawerDrama drama;
  final List<DrawerEpisode> episodes;
  final EpisodesPagination pagination;
  final bool userHasVip;

  EpisodesDrawerData({
    required this.drama,
    required this.episodes,
    required this.pagination,
    required this.userHasVip,
  });

  factory EpisodesDrawerData.fromJson(Map<String, dynamic> json) {
    return EpisodesDrawerData(
      drama: DrawerDrama.fromJson(json['drama'] ?? {}),
      episodes: (json['episodes'] as List<dynamic>? ?? [])
          .map((e) => DrawerEpisode.fromJson(e))
          .toList(),
      pagination: EpisodesPagination.fromJson(json['pagination'] ?? {}),
      userHasVip: json['userHasVip'] ?? false,
    );
  }
}

class DrawerDrama {
  final String id;
  final String title;
  final String slug;
  final String posterUrl;
  final int totalEpisodes;
  final String genreDisplay;

  DrawerDrama({
    required this.id,
    required this.title,
    required this.slug,
    required this.posterUrl,
    required this.totalEpisodes,
    required this.genreDisplay,
  });

  factory DrawerDrama.fromJson(Map<String, dynamic> json) {
    return DrawerDrama(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      slug: json['slug'] ?? '',
      posterUrl: json['posterUrl'] ?? '',
      totalEpisodes: json['totalEpisodes'] ?? 0,
      genreDisplay: json['genreDisplay'] ?? '',
    );
  }
}

class DrawerEpisode {
  final String id;
  final int seasonNumber;
  final int episodeNumber;
  final String seasonEpisodeTag;
  final String title;
  final int durationSeconds;
  final String formattedDuration;
  final String thumbnailUrl;
  final bool isFree;
  final bool hasAccess;
  final bool isLocked;
  final bool isCurrent;
  final bool? watched;

  DrawerEpisode({
    required this.id,
    required this.seasonNumber,
    required this.episodeNumber,
    required this.seasonEpisodeTag,
    required this.title,
    required this.durationSeconds,
    required this.formattedDuration,
    required this.thumbnailUrl,
    required this.isFree,
    required this.hasAccess,
    required this.isLocked,
    required this.isCurrent,
    required this.watched,
  });

  String get durationFormatted => formattedDuration;
  bool get isVip => !isFree;
  String get accessType => isFree ? 'Free' : 'VIP';

  factory DrawerEpisode.fromJson(Map<String, dynamic> json) {
    return DrawerEpisode(
      id: json['id'] ?? '',
      seasonNumber: json['seasonNumber'] ?? 0,
      episodeNumber: json['episodeNumber'] ?? 0,
      seasonEpisodeTag: json['seasonEpisodeTag'] ?? '',
      title: json['title'] ?? '',
      durationSeconds: json['durationSeconds'] ?? 0,
      formattedDuration: json['formattedDuration'] ?? '',
      thumbnailUrl: json['thumbnailUrl'] ?? '',
      isFree: json['isFree'] ?? false,
      hasAccess: json['hasAccess'] ?? false,
      isLocked: json['isLocked'] ?? false,
      isCurrent: json['isCurrent'] ?? false,
      watched: json['watched'],
    );
  }
}

class EpisodesPagination {
  final int page;
  final int limit;
  final int total;
  final int totalPages;
  final bool hasNextPage;
  final bool hasPrevPage;

  EpisodesPagination({
    required this.page,
    required this.limit,
    required this.total,
    required this.totalPages,
    required this.hasNextPage,
    required this.hasPrevPage,
  });

  factory EpisodesPagination.fromJson(Map<String, dynamic> json) {
    return EpisodesPagination(
      page: json['page'] ?? 1,
      limit: json['limit'] ?? 10,
      total: json['total'] ?? 0,
      totalPages: json['totalPages'] ?? 0,
      hasNextPage: json['hasNextPage'] ?? false,
      hasPrevPage: json['hasPrevPage'] ?? false,
    );
  }
}
