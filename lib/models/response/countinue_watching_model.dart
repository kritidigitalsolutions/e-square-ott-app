List<String> _parseStringList(dynamic list) {
  if (list == null || list is! List) return [];
  return list
      .map((e) {
        if (e is String) return e;
        if (e is Map) {
          final val =
              e['name'] ??
              e['title'] ??
              e['genre'] ??
              e['slug'] ??
              e['_id'] ??
              e['id'];
          return val?.toString() ?? '';
        }
        return e.toString();
      })
      .where((s) => s.isNotEmpty)
      .toList();
}

class ContinueWatchingResponse {
  final bool success;
  final int statusCode;
  final String message;
  final ContinueWatchingData data;

  ContinueWatchingResponse({
    required this.success,
    required this.statusCode,
    required this.message,
    required this.data,
  });

  factory ContinueWatchingResponse.fromJson(Map<String, dynamic> json) {
    return ContinueWatchingResponse(
      success: json['success'] ?? false,
      statusCode: json['statusCode'] is int
          ? json['statusCode']
          : int.tryParse(json['statusCode']?.toString() ?? '0') ?? 0,
      message: (json['message'] ?? '').toString(),
      data: ContinueWatchingData.fromJson(
        json['data'] is Map<String, dynamic> ? json['data'] : {},
      ),
    );
  }
}

class ContinueWatchingData {
  final List<ContinueWatchingItem> items;
  final ContinueWatchingPagination pagination;

  ContinueWatchingData({required this.items, required this.pagination});

  factory ContinueWatchingData.fromJson(Map<String, dynamic> json) {
    return ContinueWatchingData(
      items: (json['items'] as List<dynamic>? ?? [])
          .whereType<Map<String, dynamic>>()
          .map((e) => ContinueWatchingItem.fromJson(e))
          .toList(),
      pagination: ContinueWatchingPagination.fromJson(
        json['pagination'] is Map<String, dynamic> ? json['pagination'] : {},
      ),
    );
  }
}

class ContinueWatchingItem {
  final String historyId;
  final ContinueWatchingDrama drama;
  final ContinueWatchingEpisode episode;
  final PlaybackHistory playback;

  ContinueWatchingItem({
    required this.historyId,
    required this.drama,
    required this.episode,
    required this.playback,
  });

  factory ContinueWatchingItem.fromJson(Map<String, dynamic> json) {
    return ContinueWatchingItem(
      historyId: (json['historyId'] ?? json['_id'] ?? '').toString(),
      drama: ContinueWatchingDrama.fromJson(
        json['drama'] is Map<String, dynamic> ? json['drama'] : {},
      ),
      episode: ContinueWatchingEpisode.fromJson(
        json['episode'] is Map<String, dynamic> ? json['episode'] : {},
      ),
      playback: PlaybackHistory.fromJson(
        json['playback'] is Map<String, dynamic> ? json['playback'] : {},
      ),
    );
  }
}

class ContinueWatchingDrama {
  final String id;
  final String title;
  final String slug;
  final String posterUrl;
  final String bannerUrl;
  final String trailerUrl;
  final double rating;
  final int totalEpisodes;
  final List<String> genres;
  final String genreDisplay;

  ContinueWatchingDrama({
    required this.id,
    required this.title,
    required this.slug,
    required this.posterUrl,
    required this.bannerUrl,
    this.trailerUrl = '',
    required this.rating,
    required this.totalEpisodes,
    required this.genres,
    required this.genreDisplay,
  });

  factory ContinueWatchingDrama.fromJson(Map<String, dynamic> json) {
    return ContinueWatchingDrama(
      id: (json['id'] ?? json['_id'] ?? '').toString(),
      title: (json['title'] ?? json['name'] ?? '').toString(),
      slug: (json['slug'] ?? '').toString(),
      posterUrl: (json['posterUrl'] ?? json['poster'] ?? json['image'] ?? '')
          .toString(),
      bannerUrl: (json['bannerUrl'] ?? json['banner'] ?? '').toString(),
      trailerUrl:
          (json['trailerUrl'] ?? json['trailer'] ?? json['videoUrl'] ?? '')
              .toString(),
      rating: json['rating'] is num
          ? (json['rating'] as num).toDouble()
          : double.tryParse(json['rating']?.toString() ?? '0.0') ?? 0.0,
      totalEpisodes: json['totalEpisodes'] is int
          ? json['totalEpisodes']
          : int.tryParse(json['totalEpisodes']?.toString() ?? '0') ?? 0,
      genres: _parseStringList(json['genres']),
      genreDisplay: (json['genreDisplay'] ?? '').toString(),
    );
  }
}

class ContinueWatchingEpisode {
  final String id;
  final int episodeNumber;
  final int seasonNumber;
  final String seasonEpisodeTag;
  final String title;
  final int durationSeconds;
  final String formattedDuration;

  ContinueWatchingEpisode({
    required this.id,
    required this.episodeNumber,
    required this.seasonNumber,
    required this.seasonEpisodeTag,
    required this.title,
    required this.durationSeconds,
    required this.formattedDuration,
  });

  factory ContinueWatchingEpisode.fromJson(Map<String, dynamic> json) {
    return ContinueWatchingEpisode(
      id: (json['id'] ?? json['_id'] ?? '').toString(),
      episodeNumber: json['episodeNumber'] is int
          ? json['episodeNumber']
          : int.tryParse(json['episodeNumber']?.toString() ?? '0') ?? 0,
      seasonNumber: json['seasonNumber'] is int
          ? json['seasonNumber']
          : int.tryParse(json['seasonNumber']?.toString() ?? '0') ?? 0,
      seasonEpisodeTag: (json['seasonEpisodeTag'] ?? '').toString(),
      title: (json['title'] ?? '').toString(),
      durationSeconds: json['durationSeconds'] is int
          ? json['durationSeconds']
          : int.tryParse(json['durationSeconds']?.toString() ?? '0') ?? 0,
      formattedDuration: (json['formattedDuration'] ?? '').toString(),
    );
  }
}

class PlaybackHistory {
  final int watchedSeconds;
  final String formattedWatched;
  final int durationSeconds;
  final String formattedDuration;
  final int remainingSeconds;
  final String formattedRemaining;
  final double progressPercentage;
  final bool isCompleted;
  final DateTime? lastWatchedAt;

  PlaybackHistory({
    required this.watchedSeconds,
    required this.formattedWatched,
    required this.durationSeconds,
    required this.formattedDuration,
    required this.remainingSeconds,
    required this.formattedRemaining,
    required this.progressPercentage,
    required this.isCompleted,
    required this.lastWatchedAt,
  });

  factory PlaybackHistory.fromJson(Map<String, dynamic> json) {
    return PlaybackHistory(
      watchedSeconds: json['watchedSeconds'] is int
          ? json['watchedSeconds']
          : int.tryParse(json['watchedSeconds']?.toString() ?? '0') ?? 0,
      formattedWatched: (json['formattedWatched'] ?? '').toString(),
      durationSeconds: json['durationSeconds'] is int
          ? json['durationSeconds']
          : int.tryParse(json['durationSeconds']?.toString() ?? '0') ?? 0,
      formattedDuration: (json['formattedDuration'] ?? '').toString(),
      remainingSeconds: json['remainingSeconds'] is int
          ? json['remainingSeconds']
          : int.tryParse(json['remainingSeconds']?.toString() ?? '0') ?? 0,
      formattedRemaining: (json['formattedRemaining'] ?? '').toString(),
      progressPercentage: json['progressPercentage'] is num
          ? (json['progressPercentage'] as num).toDouble()
          : double.tryParse(json['progressPercentage']?.toString() ?? '0.0') ??
                0.0,
      isCompleted: json['isCompleted'] ?? false,
      lastWatchedAt: json['lastWatchedAt'] != null
          ? DateTime.tryParse(json['lastWatchedAt'].toString())
          : null,
    );
  }
}

class ContinueWatchingPagination {
  final int page;
  final int limit;
  final int total;
  final int totalPages;
  final bool hasNextPage;
  final bool hasPrevPage;

  ContinueWatchingPagination({
    required this.page,
    required this.limit,
    required this.total,
    required this.totalPages,
    required this.hasNextPage,
    required this.hasPrevPage,
  });

  factory ContinueWatchingPagination.fromJson(Map<String, dynamic> json) {
    return ContinueWatchingPagination(
      page: json['page'] is int
          ? json['page']
          : int.tryParse(json['page']?.toString() ?? '1') ?? 1,
      limit: json['limit'] is int
          ? json['limit']
          : int.tryParse(json['limit']?.toString() ?? '10') ?? 10,
      total: json['total'] is int
          ? json['total']
          : int.tryParse(json['total']?.toString() ?? '0') ?? 0,
      totalPages: json['totalPages'] is int
          ? json['totalPages']
          : int.tryParse(json['totalPages']?.toString() ?? '0') ?? 0,
      hasNextPage: json['hasNextPage'] ?? false,
      hasPrevPage: json['hasPrevPage'] ?? false,
    );
  }
}
