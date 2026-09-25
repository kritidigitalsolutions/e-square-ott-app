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

class SearchDiscoveryResponse {
  final bool success;
  final int statusCode;
  final String message;
  final SearchDiscoveryData data;

  SearchDiscoveryResponse({
    required this.success,
    required this.statusCode,
    required this.message,
    required this.data,
  });

  factory SearchDiscoveryResponse.fromJson(Map<String, dynamic> json) {
    return SearchDiscoveryResponse(
      success: json['success'] ?? false,
      statusCode: json['statusCode'] is int
          ? json['statusCode']
          : int.tryParse(json['statusCode']?.toString() ?? '0') ?? 0,
      message: (json['message'] ?? '').toString(),
      data: SearchDiscoveryData.fromJson(
        json['data'] is Map<String, dynamic> ? json['data'] : {},
      ),
    );
  }
}

class SearchDiscoveryData {
  final String title;
  final String subtitle;
  final List<PopularSearch> popularSearches;
  final List<RecommendedDrama> recommendedForYou;
  final bool isPersonalized;
  final List<String> userGenres;

  SearchDiscoveryData({
    required this.title,
    required this.subtitle,
    required this.popularSearches,
    required this.recommendedForYou,
    required this.isPersonalized,
    required this.userGenres,
  });

  factory SearchDiscoveryData.fromJson(Map<String, dynamic> json) {
    return SearchDiscoveryData(
      title: (json['title'] ?? '').toString(),
      subtitle: (json['subtitle'] ?? '').toString(),
      popularSearches: (json['popularSearches'] as List<dynamic>? ?? [])
          .whereType<Map<String, dynamic>>()
          .map((e) => PopularSearch.fromJson(e))
          .toList(),
      recommendedForYou: (json['recommendedForYou'] as List<dynamic>? ?? [])
          .whereType<Map<String, dynamic>>()
          .map((e) => RecommendedDrama.fromJson(e))
          .toList(),
      isPersonalized: json['isPersonalized'] ?? false,
      userGenres: _parseStringList(json['userGenres']),
    );
  }
}

class PopularSearch {
  final String rank;
  final int displayRank;
  final String id;
  final String title;
  final String slug;
  final String posterUrl;
  final int viewsCount;
  final String viewsFormatted;
  final double rating;
  final int totalEpisodes;
  final List<String> genres;
  final String genreDisplay;

  PopularSearch({
    required this.rank,
    required this.displayRank,
    required this.id,
    required this.title,
    required this.slug,
    required this.posterUrl,
    required this.viewsCount,
    required this.viewsFormatted,
    required this.rating,
    required this.totalEpisodes,
    required this.genres,
    required this.genreDisplay,
  });

  factory PopularSearch.fromJson(Map<String, dynamic> json) {
    return PopularSearch(
      rank: (json['rank'] ?? '').toString(),
      displayRank: json['displayRank'] is int
          ? json['displayRank']
          : int.tryParse(json['displayRank']?.toString() ?? '0') ?? 0,
      id: (json['id'] ?? json['_id'] ?? '').toString(),
      title: (json['title'] ?? json['name'] ?? '').toString(),
      slug: (json['slug'] ?? '').toString(),
      posterUrl: (json['posterUrl'] ?? json['poster'] ?? json['image'] ?? '')
          .toString(),
      viewsCount: json['viewsCount'] is int
          ? json['viewsCount']
          : int.tryParse(json['viewsCount']?.toString() ?? '0') ?? 0,
      viewsFormatted: (json['viewsFormatted'] ?? '').toString(),
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

class RecommendedDrama {
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
  final bool isTrending;
  final bool isNewRelease;

  RecommendedDrama({
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
    required this.isTrending,
    required this.isNewRelease,
  });

  factory RecommendedDrama.fromJson(Map<String, dynamic> json) {
    return RecommendedDrama(
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
      isTrending: json['isTrending'] ?? false,
      isNewRelease: json['isNewRelease'] ?? false,
    );
  }
}
