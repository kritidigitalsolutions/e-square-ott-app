class SavedSeriesResponse {
  final bool success;
  final int statusCode;
  final String message;
  final SavedSeriesData data;

  SavedSeriesResponse({
    required this.success,
    required this.statusCode,
    required this.message,
    required this.data,
  });

  factory SavedSeriesResponse.fromJson(Map<String, dynamic> json) {
    return SavedSeriesResponse(
      success: json['success'] ?? false,
      statusCode: json['statusCode'] ?? 0,
      message: json['message'] ?? '',
      data: SavedSeriesData.fromJson(json['data'] ?? {}),
    );
  }
}

class SavedSeriesData {
  final List<SavedSeries> savedSeries;
  final SavedSeriesPagination pagination;
  final SavedSeriesStats stats;

  SavedSeriesData({
    required this.savedSeries,
    required this.pagination,
    required this.stats,
  });

  factory SavedSeriesData.fromJson(Map<String, dynamic> json) {
    return SavedSeriesData(
      savedSeries: (json['savedSeries'] as List? ?? [])
          .map((e) => SavedSeries.fromJson(e))
          .toList(),
      pagination: SavedSeriesPagination.fromJson(json['pagination'] ?? {}),
      stats: SavedSeriesStats.fromJson(json['stats'] ?? {}),
    );
  }
}

class SavedSeries {
  final String id;
  final String savedId;
  final String addedAt;
  final String savedAt;
  final bool isSaved;
  final SavedDrama drama;
  final WatchProgress? watchProgress;

  SavedSeries({
    required this.id,
    required this.savedId,
    required this.addedAt,
    required this.savedAt,
    required this.isSaved,
    required this.drama,
    this.watchProgress,
  });

  factory SavedSeries.fromJson(Map<String, dynamic> json) {
    return SavedSeries(
      id: json['id'] ?? '',
      savedId: json['savedId'] ?? '',
      addedAt: json['addedAt'] ?? '',
      savedAt: json['savedAt'] ?? '',
      isSaved: json['isSaved'] ?? false,
      drama: SavedDrama.fromJson(json['drama'] ?? {}),
      watchProgress: json['watchProgress'] != null
          ? WatchProgress.fromJson(json['watchProgress'])
          : null,
    );
  }
}

class SavedDrama {
  final String id;
  final String title;
  final String slug;
  final String synopsis;
  final String poster;
  final String posterUrl;
  final String banner;
  final String bannerUrl;
  final String trailerUrl;
  final List<String> genres;
  final String genreDisplay;
  final double rating;
  final String views;
  final int viewsCount;
  final int totalEpisodes;
  final int freeEpisodes;
  final bool isPaid;
  final String plan;
  final String status;
  final bool isActive;
  final bool isTrending;

  SavedDrama({
    required this.id,
    required this.title,
    required this.slug,
    required this.synopsis,
    required this.poster,
    required this.posterUrl,
    required this.banner,
    required this.bannerUrl,
    required this.trailerUrl,
    required this.genres,
    required this.genreDisplay,
    required this.rating,
    required this.views,
    required this.viewsCount,
    required this.totalEpisodes,
    required this.freeEpisodes,
    required this.isPaid,
    required this.plan,
    required this.status,
    required this.isActive,
    required this.isTrending,
  });

  factory SavedDrama.fromJson(Map<String, dynamic> json) {
    return SavedDrama(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      slug: json['slug'] ?? '',
      synopsis: json['synopsis'] ?? '',
      poster: json['poster'] ?? '',
      posterUrl: json['posterUrl'] ?? '',
      banner: json['banner'] ?? '',
      bannerUrl: json['bannerUrl'] ?? '',
      trailerUrl: json['trailerUrl'] ?? '',
      genres: List<String>.from(json['genres'] ?? []),
      genreDisplay: json['genreDisplay'] ?? '',
      rating: (json['rating'] ?? 0).toDouble(),
      views: json['views'] ?? '',
      viewsCount: json['viewsCount'] ?? 0,
      totalEpisodes: json['totalEpisodes'] ?? 0,
      freeEpisodes: json['freeEpisodes'] ?? 0,
      isPaid: json['isPaid'] ?? false,
      plan: json['plan'] ?? '',
      status: json['status'] ?? '',
      isActive: json['isActive'] ?? false,
      isTrending: json['isTrending'] ?? false,
    );
  }
}

class WatchProgress {
  final bool hasStarted;
  final int resumeEpisodeNumber;
  final String resumeEpisodeId;
  final int watchedSeconds;
  final String formattedWatched;
  final int durationSeconds;
  final String formattedDuration;
  final int progressPercentage;
  final bool isCompleted;
  final String lastWatchedAt;
  final String actionLabel;

  WatchProgress({
    required this.hasStarted,
    required this.resumeEpisodeNumber,
    required this.resumeEpisodeId,
    required this.watchedSeconds,
    required this.formattedWatched,
    required this.durationSeconds,
    required this.formattedDuration,
    required this.progressPercentage,
    required this.isCompleted,
    required this.lastWatchedAt,
    required this.actionLabel,
  });

  factory WatchProgress.fromJson(Map<String, dynamic> json) {
    return WatchProgress(
      hasStarted: json['hasStarted'] ?? false,
      resumeEpisodeNumber: json['resumeEpisodeNumber'] ?? 0,
      resumeEpisodeId: json['resumeEpisodeId'] ?? '',
      watchedSeconds: json['watchedSeconds'] ?? 0,
      formattedWatched: json['formattedWatched'] ?? '',
      durationSeconds: json['durationSeconds'] ?? 0,
      formattedDuration: json['formattedDuration'] ?? '',
      progressPercentage: json['progressPercentage'] ?? 0,
      isCompleted: json['isCompleted'] ?? false,
      lastWatchedAt: json['lastWatchedAt'] ?? '',
      actionLabel: json['actionLabel'] ?? '',
    );
  }
}

class SavedSeriesPagination {
  final int page;
  final int limit;
  final int total;
  final int totalPages;
  final bool hasNextPage;
  final bool hasPrevPage;

  SavedSeriesPagination({
    required this.page,
    required this.limit,
    required this.total,
    required this.totalPages,
    required this.hasNextPage,
    required this.hasPrevPage,
  });

  factory SavedSeriesPagination.fromJson(Map<String, dynamic> json) {
    return SavedSeriesPagination(
      page: json['page'] ?? 1,
      limit: json['limit'] ?? 20,
      total: json['total'] ?? 0,
      totalPages: json['totalPages'] ?? 0,
      hasNextPage: json['hasNextPage'] ?? false,
      hasPrevPage: json['hasPrevPage'] ?? false,
    );
  }
}

class SavedSeriesStats {
  final int totalSaved;
  final int currentFilteredCount;

  SavedSeriesStats({
    required this.totalSaved,
    required this.currentFilteredCount,
  });

  factory SavedSeriesStats.fromJson(Map<String, dynamic> json) {
    return SavedSeriesStats(
      totalSaved: json['totalSaved'] ?? 0,
      currentFilteredCount: json['currentFilteredCount'] ?? 0,
    );
  }
}
