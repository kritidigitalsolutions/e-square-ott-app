import 'package:flutter/foundation.dart';

class WatchHistoryResponseModel {
  final bool success;
  final String message;
  final WatchHistoryData data;

  WatchHistoryResponseModel({
    required this.success,
    required this.message,
    required this.data,
  });

  factory WatchHistoryResponseModel.fromJson(Map<String, dynamic> json) {
    return WatchHistoryResponseModel(
      success: json['success'] ?? false,
      message: (json['message'] ?? '').toString(),
      data: WatchHistoryData.fromJson(
        json['data'] is Map<String, dynamic> ? json['data'] : {},
      ),
    );
  }
}

class WatchHistoryData {
  final WatchHistorySummary summary;
  final List<WatchHistoryItem> history;
  final WatchHistoryPagination pagination;

  WatchHistoryData({
    required this.summary,
    required this.history,
    required this.pagination,
  });

  factory WatchHistoryData.fromJson(Map<String, dynamic> json) {
    return WatchHistoryData(
      summary: WatchHistorySummary.fromJson(
        json['summary'] is Map<String, dynamic> ? json['summary'] : {},
      ),
      history: (json['history'] as List<dynamic>? ?? [])
          .whereType<Map<String, dynamic>>()
          .map((e) => WatchHistoryItem.fromJson(e))
          .toList(),
      pagination: WatchHistoryPagination.fromJson(
        json['pagination'] is Map<String, dynamic> ? json['pagination'] : {},
      ),
    );
  }
}

class WatchHistorySummary {
  final int totalDramasWatched;
  final int totalEpisodesWatched;
  final int completedCount;
  final int inProgressCount;
  final int totalWatchTimeSeconds;
  final String formattedTotalWatchTime;

  WatchHistorySummary({
    required this.totalDramasWatched,
    required this.totalEpisodesWatched,
    required this.completedCount,
    required this.inProgressCount,
    required this.totalWatchTimeSeconds,
    required this.formattedTotalWatchTime,
  });

  factory WatchHistorySummary.fromJson(Map<String, dynamic> json) {
    return WatchHistorySummary(
      totalDramasWatched: json['totalDramasWatched'] is int
          ? json['totalDramasWatched']
          : int.tryParse(json['totalDramasWatched']?.toString() ?? '0') ?? 0,
      totalEpisodesWatched: json['totalEpisodesWatched'] is int
          ? json['totalEpisodesWatched']
          : int.tryParse(json['totalEpisodesWatched']?.toString() ?? '0') ?? 0,
      completedCount: json['completedCount'] is int
          ? json['completedCount']
          : int.tryParse(json['completedCount']?.toString() ?? '0') ?? 0,
      inProgressCount: json['inProgressCount'] is int
          ? json['inProgressCount']
          : int.tryParse(json['inProgressCount']?.toString() ?? '0') ?? 0,
      totalWatchTimeSeconds: json['totalWatchTimeSeconds'] is int
          ? json['totalWatchTimeSeconds']
          : int.tryParse(json['totalWatchTimeSeconds']?.toString() ?? '0') ?? 0,
      formattedTotalWatchTime:
          (json['formattedTotalWatchTime'] ?? '0m 00s').toString(),
    );
  }
}

class WatchHistoryItem {
  final String id;
  final String historyId;
  final WatchHistoryDrama drama;
  final WatchHistoryEpisode episode;
  final WatchHistoryPlayback playback;
  final WatchHistoryTimeline timeline;
  final WatchHistorySeriesProgress? seriesProgress;

  WatchHistoryItem({
    required this.id,
    required this.historyId,
    required this.drama,
    required this.episode,
    required this.playback,
    required this.timeline,
    this.seriesProgress,
  });

  factory WatchHistoryItem.fromJson(Map<String, dynamic> json) {
    return WatchHistoryItem(
      id: (json['id'] ?? json['historyId'] ?? json['_id'] ?? '').toString(),
      historyId:
          (json['historyId'] ?? json['id'] ?? json['_id'] ?? '').toString(),
      drama: WatchHistoryDrama.fromJson(
        json['drama'] is Map<String, dynamic> ? json['drama'] : {},
      ),
      episode: WatchHistoryEpisode.fromJson(
        json['episode'] is Map<String, dynamic> ? json['episode'] : {},
      ),
      playback: WatchHistoryPlayback.fromJson(
        json['playback'] is Map<String, dynamic> ? json['playback'] : {},
      ),
      timeline: WatchHistoryTimeline.fromJson(
        json['timeline'] is Map<String, dynamic> ? json['timeline'] : {},
      ),
      seriesProgress: json['seriesProgress'] is Map<String, dynamic>
          ? WatchHistorySeriesProgress.fromJson(json['seriesProgress'])
          : null,
    );
  }
}

class WatchHistoryDrama {
  final String id;
  final String title;
  final String slug;
  final String posterUrl;
  final double rating;
  final int totalEpisodes;
  final List<String> genres;
  final String genreDisplay;

  WatchHistoryDrama({
    required this.id,
    required this.title,
    required this.slug,
    required this.posterUrl,
    required this.rating,
    required this.totalEpisodes,
    required this.genres,
    required this.genreDisplay,
  });

  factory WatchHistoryDrama.fromJson(Map<String, dynamic> json) {
    return WatchHistoryDrama(
      id: (json['id'] ?? json['_id'] ?? '').toString(),
      title: (json['title'] ?? json['name'] ?? '').toString(),
      slug: (json['slug'] ?? '').toString(),
      posterUrl: (json['posterUrl'] ??
              json['poster'] ??
              json['bannerUrl'] ??
              json['image'] ??
              '')
          .toString(),
      rating: json['rating'] is num
          ? (json['rating'] as num).toDouble()
          : double.tryParse(json['rating']?.toString() ?? '0.0') ?? 0.0,
      totalEpisodes: json['totalEpisodes'] is int
          ? json['totalEpisodes']
          : int.tryParse(json['totalEpisodes']?.toString() ?? '0') ?? 0,
      genres: (json['genres'] as List<dynamic>? ?? [])
          .map((e) => e.toString())
          .toList(),
      genreDisplay: (json['genreDisplay'] ?? '').toString(),
    );
  }
}

class WatchHistoryEpisode {
  final String id;
  final int episodeNumber;
  final int seasonNumber;
  final String seasonEpisodeTag;
  final String title;
  final int durationSeconds;
  final String formattedDuration;
  final bool isFree;

  WatchHistoryEpisode({
    required this.id,
    required this.episodeNumber,
    required this.seasonNumber,
    required this.seasonEpisodeTag,
    required this.title,
    required this.durationSeconds,
    required this.formattedDuration,
    required this.isFree,
  });

  factory WatchHistoryEpisode.fromJson(Map<String, dynamic> json) {
    return WatchHistoryEpisode(
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
      isFree: json['isFree'] ?? false,
    );
  }
}

class WatchHistoryPlayback {
  final int watchedSeconds;
  final String formattedWatched;
  final int durationSeconds;
  final String formattedDuration;
  final int remainingSeconds;
  final String formattedRemaining;
  final double progressPercentage;
  final bool isCompleted;
  final String status;

  WatchHistoryPlayback({
    required this.watchedSeconds,
    required this.formattedWatched,
    required this.durationSeconds,
    required this.formattedDuration,
    required this.remainingSeconds,
    required this.formattedRemaining,
    required this.progressPercentage,
    required this.isCompleted,
    required this.status,
  });

  factory WatchHistoryPlayback.fromJson(Map<String, dynamic> json) {
    return WatchHistoryPlayback(
      watchedSeconds: json['watchedSeconds'] is int
          ? json['watchedSeconds']
          : int.tryParse(json['watchedSeconds']?.toString() ?? '0') ?? 0,
      formattedWatched: (json['formattedWatched'] ?? '0:00').toString(),
      durationSeconds: json['durationSeconds'] is int
          ? json['durationSeconds']
          : int.tryParse(json['durationSeconds']?.toString() ?? '0') ?? 0,
      formattedDuration: (json['formattedDuration'] ?? '0:00').toString(),
      remainingSeconds: json['remainingSeconds'] is int
          ? json['remainingSeconds']
          : int.tryParse(json['remainingSeconds']?.toString() ?? '0') ?? 0,
      formattedRemaining: (json['formattedRemaining'] ?? '').toString(),
      progressPercentage: json['progressPercentage'] is num
          ? (json['progressPercentage'] as num).toDouble()
          : double.tryParse(json['progressPercentage']?.toString() ?? '0.0') ??
              0.0,
      isCompleted: json['isCompleted'] ?? false,
      status: (json['status'] ?? 'IN_PROGRESS').toString(),
    );
  }
}

class WatchHistoryTimeline {
  final DateTime? lastWatchedAt;
  final String relativeTime;
  final String dateGroup;
  final String formattedDate;

  WatchHistoryTimeline({
    required this.lastWatchedAt,
    required this.relativeTime,
    required this.dateGroup,
    required this.formattedDate,
  });

  factory WatchHistoryTimeline.fromJson(Map<String, dynamic> json) {
    return WatchHistoryTimeline(
      lastWatchedAt: json['lastWatchedAt'] != null
          ? DateTime.tryParse(json['lastWatchedAt'].toString())
          : null,
      relativeTime: (json['relativeTime'] ?? '').toString(),
      dateGroup: (json['dateGroup'] ?? 'Today').toString(),
      formattedDate: (json['formattedDate'] ?? '').toString(),
    );
  }
}

class WatchHistorySeriesProgress {
  final int watchedEpisodesCount;
  final int totalEpisodes;
  final double percentSeriesCompleted;

  WatchHistorySeriesProgress({
    required this.watchedEpisodesCount,
    required this.totalEpisodes,
    required this.percentSeriesCompleted,
  });

  factory WatchHistorySeriesProgress.fromJson(Map<String, dynamic> json) {
    return WatchHistorySeriesProgress(
      watchedEpisodesCount: json['watchedEpisodesCount'] is int
          ? json['watchedEpisodesCount']
          : int.tryParse(json['watchedEpisodesCount']?.toString() ?? '0') ?? 0,
      totalEpisodes: json['totalEpisodes'] is int
          ? json['totalEpisodes']
          : int.tryParse(json['totalEpisodes']?.toString() ?? '0') ?? 0,
      percentSeriesCompleted: json['percentSeriesCompleted'] is num
          ? (json['percentSeriesCompleted'] as num).toDouble()
          : double.tryParse(
                  json['percentSeriesCompleted']?.toString() ?? '0.0') ??
              0.0,
    );
  }
}

class WatchHistoryPagination {
  final int page;
  final int limit;
  final int total;
  final int totalPages;
  final bool hasNextPage;
  final bool hasPrevPage;

  WatchHistoryPagination({
    required this.page,
    required this.limit,
    required this.total,
    required this.totalPages,
    required this.hasNextPage,
    required this.hasPrevPage,
  });

  factory WatchHistoryPagination.fromJson(Map<String, dynamic> json) {
    return WatchHistoryPagination(
      page: json['page'] is int
          ? json['page']
          : int.tryParse(json['page']?.toString() ?? '1') ?? 1,
      limit: json['limit'] is int
          ? json['limit']
          : int.tryParse(json['limit']?.toString() ?? '20') ?? 20,
      total: json['total'] is int
          ? json['total']
          : int.tryParse(json['total']?.toString() ?? '0') ?? 0,
      totalPages: json['totalPages'] is int
          ? json['totalPages']
          : int.tryParse(json['totalPages']?.toString() ?? '1') ?? 1,
      hasNextPage: json['hasNextPage'] ?? false,
      hasPrevPage: json['hasPrevPage'] ?? false,
    );
  }
}
