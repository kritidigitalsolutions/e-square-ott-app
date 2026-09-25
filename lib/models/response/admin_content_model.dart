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

class AdminPriorityDramasResponse {
  final bool success;
  final int statusCode;
  final String message;
  final AdminPriorityDramasData data;

  AdminPriorityDramasResponse({
    required this.success,
    required this.statusCode,
    required this.message,
    required this.data,
  });

  factory AdminPriorityDramasResponse.fromJson(Map<String, dynamic> json) {
    return AdminPriorityDramasResponse(
      success: json['success'] ?? false,
      statusCode: json['statusCode'] is int
          ? json['statusCode']
          : int.tryParse(json['statusCode']?.toString() ?? '0') ?? 0,
      message: (json['message'] ?? '').toString(),
      data: AdminPriorityDramasData.fromJson(
        json['data'] is Map<String, dynamic> ? json['data'] : {},
      ),
    );
  }
}

class AdminPriorityDramasData {
  final List<PriorityDrama> dramas;
  final PriorityPagination pagination;

  AdminPriorityDramasData({required this.dramas, required this.pagination});

  factory AdminPriorityDramasData.fromJson(Map<String, dynamic> json) {
    return AdminPriorityDramasData(
      dramas: (json['dramas'] as List<dynamic>? ?? [])
          .whereType<Map<String, dynamic>>()
          .map((e) => PriorityDrama.fromJson(e))
          .toList(),
      pagination: PriorityPagination.fromJson(
        json['pagination'] is Map<String, dynamic> ? json['pagination'] : {},
      ),
    );
  }
}

class PriorityDrama {
  final String id;
  final String title;
  final String slug;
  final String synopsis;
  final String posterUrl;
  final String bannerUrl;
  final String trailerUrl;
  final List<String> genres;
  final String genreDisplay;
  final int totalEpisodes;
  final int viewsCount;
  final String viewsFormatted;
  final double rating;
  final int priority;
  final bool isTrending;
  final bool isNewRelease;
  final int? trendingRank;
  final DateTime? releaseDate;

  PriorityDrama({
    required this.id,
    required this.title,
    required this.slug,
    required this.synopsis,
    required this.posterUrl,
    required this.bannerUrl,
    required this.trailerUrl,
    required this.genres,
    required this.genreDisplay,
    required this.totalEpisodes,
    required this.viewsCount,
    required this.viewsFormatted,
    required this.rating,
    required this.priority,
    required this.isTrending,
    this.isNewRelease = false,
    required this.trendingRank,
    required this.releaseDate,
  });

  factory PriorityDrama.fromJson(Map<String, dynamic> json) {
    return PriorityDrama(
      id: (json['id'] ?? json['_id'] ?? '').toString(),
      title: (json['title'] ?? json['name'] ?? '').toString(),
      slug: (json['slug'] ?? '').toString(),
      synopsis: (json['synopsis'] ?? json['description'] ?? '').toString(),
      posterUrl: (json['posterUrl'] ?? json['poster'] ?? json['image'] ?? '')
          .toString(),
      bannerUrl: (json['bannerUrl'] ?? json['banner'] ?? '').toString(),
      trailerUrl: (json['trailerUrl'] ?? json['trailer'] ?? '').toString(),
      genres: _parseStringList(json['genres']),
      genreDisplay: (json['genreDisplay'] ?? '').toString(),
      totalEpisodes: json['totalEpisodes'] is int
          ? json['totalEpisodes']
          : int.tryParse(json['totalEpisodes']?.toString() ?? '0') ?? 0,
      viewsCount: json['viewsCount'] is int
          ? json['viewsCount']
          : int.tryParse(json['viewsCount']?.toString() ?? '0') ?? 0,
      viewsFormatted: (json['viewsFormatted'] ?? '').toString(),
      rating: json['rating'] is num
          ? (json['rating'] as num).toDouble()
          : double.tryParse(json['rating']?.toString() ?? '0.0') ?? 0.0,
      priority: json['priority'] is int
          ? json['priority']
          : int.tryParse(json['priority']?.toString() ?? '0') ?? 0,
      isTrending: json['isTrending'] ?? false,
      isNewRelease: json['isNewRelease'] ?? false,
      trendingRank: json['trendingRank'] is int
          ? json['trendingRank']
          : int.tryParse(json['trendingRank']?.toString() ?? ''),
      releaseDate: json['releaseDate'] != null
          ? DateTime.tryParse(json['releaseDate'].toString())
          : null,
    );
  }
}

class PriorityPagination {
  final int page;
  final int limit;
  final int total;
  final int totalPages;
  final bool hasNextPage;
  final bool hasPrevPage;

  PriorityPagination({
    required this.page,
    required this.limit,
    required this.total,
    required this.totalPages,
    required this.hasNextPage,
    required this.hasPrevPage,
  });

  factory PriorityPagination.fromJson(Map<String, dynamic> json) {
    return PriorityPagination(
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
