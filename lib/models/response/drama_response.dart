class DramasResponse {
  final bool success;
  final int statusCode;
  final String message;
  final DramasData data;

  DramasResponse({
    required this.success,
    required this.statusCode,
    required this.message,
    required this.data,
  });

  factory DramasResponse.fromJson(Map<String, dynamic> json) {
    return DramasResponse(
      success: json['success'] ?? false,
      statusCode: json['statusCode'] ?? 0,
      message: json['message'] ?? '',
      data: DramasData.fromJson(json['data'] ?? {}),
    );
  }
}

class DramasData {
  final List<Drama> dramas;
  final Pagination pagination;

  DramasData({required this.dramas, required this.pagination});

  factory DramasData.fromJson(Map<String, dynamic> json) {
    return DramasData(
      dramas: (json['dramas'] as List<dynamic>? ?? [])
          .map((e) => Drama.fromJson(e))
          .toList(),
      pagination: Pagination.fromJson(json['pagination'] ?? {}),
    );
  }
}

List<String> _parseStringList(dynamic list) {
  if (list == null || list is! List) return [];
  return list
      .map((e) {
        if (e is String) return e;
        if (e is Map) {
          final val = e['name'] ?? e['title'] ?? e['genre'] ?? e['slug'] ?? e['_id'] ?? e['id'];
          return val?.toString() ?? '';
        }
        return e.toString();
      })
      .where((s) => s.isNotEmpty)
      .toList();
}

class Drama {
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
  final double rating;
  final bool isTrending;
  final bool isNewRelease;

  Drama({
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
    required this.rating,
    required this.isTrending,
    required this.isNewRelease,
  });

  factory Drama.fromJson(Map<String, dynamic> json) {
    return Drama(
      id: (json['id'] ?? json['_id'] ?? '').toString(),
      title: (json['title'] ?? json['name'] ?? '').toString(),
      slug: (json['slug'] ?? '').toString(),
      synopsis: (json['synopsis'] ?? json['description'] ?? '').toString(),
      posterUrl: (json['posterUrl'] ?? json['poster'] ?? json['image'] ?? '').toString(),
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
      rating: json['rating'] is num
          ? (json['rating'] as num).toDouble()
          : double.tryParse(json['rating']?.toString() ?? '0.0') ?? 0.0,
      isTrending: json['isTrending'] ?? false,
      isNewRelease: json['isNewRelease'] ?? false,
    );
  }
}

class Pagination {
  final int page;
  final int limit;
  final int total;
  final int totalPages;
  final bool hasNextPage;
  final bool hasPrevPage;

  Pagination({
    required this.page,
    required this.limit,
    required this.total,
    required this.totalPages,
    required this.hasNextPage,
    required this.hasPrevPage,
  });

  factory Pagination.fromJson(Map<String, dynamic> json) {
    return Pagination(
      page: json['page'] ?? 1,
      limit: json['limit'] ?? 10,
      total: json['total'] ?? 0,
      totalPages: json['totalPages'] ?? 0,
      hasNextPage: json['hasNextPage'] ?? false,
      hasPrevPage: json['hasPrevPage'] ?? false,
    );
  }
}
