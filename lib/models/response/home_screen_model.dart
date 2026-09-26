class HomeBannersResponse {
  final bool success;
  final int statusCode;
  final String message;
  final HomeBannersData data;

  HomeBannersResponse({
    required this.success,
    required this.statusCode,
    required this.message,
    required this.data,
  });

  factory HomeBannersResponse.fromJson(Map<String, dynamic> json) {
    return HomeBannersResponse(
      success: json['success'] ?? false,
      statusCode: json['statusCode'] ?? 0,
      message: json['message'] ?? '',
      data: HomeBannersData.fromJson(json['data'] ?? {}),
    );
  }
}

class HomeBannersData {
  final List<HomeBanner> banners;
  final int total;

  HomeBannersData({required this.banners, required this.total});

  factory HomeBannersData.fromJson(Map<String, dynamic> json) {
    return HomeBannersData(
      banners: (json['banners'] as List? ?? [])
          .map((e) => HomeBanner.fromJson(e))
          .toList(),
      total: json['total'] ?? 0,
    );
  }
}

class HomeBanner {
  final String id;
  final String bannerId;
  final String dramaId;
  final String title;
  final String slug;
  final String tagline;
  final String synopsis;
  final String bannerUrl;
  final String posterUrl;
  final String trailerUrl;
  final String badge;
  final List<String> genres;
  final String genreDisplay;
  final double rating;
  final String views;
  final int viewsCount;
  final int totalEpisodes;
  final int freeEpisodes;
  final bool isPaid;
  final String plan;
  final bool isSaved;
  final bool isInWatchlist;
  final BannerCta cta;

  HomeBanner({
    required this.id,
    required this.bannerId,
    required this.dramaId,
    required this.title,
    required this.slug,
    required this.tagline,
    required this.synopsis,
    required this.bannerUrl,
    required this.posterUrl,
    required this.trailerUrl,
    required this.badge,
    required this.genres,
    required this.genreDisplay,
    required this.rating,
    required this.views,
    required this.viewsCount,
    required this.totalEpisodes,
    required this.freeEpisodes,
    required this.isPaid,
    required this.plan,
    required this.isSaved,
    required this.isInWatchlist,
    required this.cta,
  });

  factory HomeBanner.fromJson(Map<String, dynamic> json) {
    return HomeBanner(
      id: json['id'] ?? '',
      bannerId: json['bannerId'] ?? '',
      dramaId: json['dramaId'] ?? '',
      title: json['title'] ?? '',
      slug: json['slug'] ?? '',
      tagline: json['tagline'] ?? '',
      synopsis: json['synopsis'] ?? '',
      bannerUrl: json['bannerUrl'] ?? '',
      posterUrl: json['posterUrl'] ?? '',
      trailerUrl: json['trailerUrl'] ?? '',
      badge: json['badge'] ?? '',
      genres: List<String>.from(json['genres'] ?? []),
      genreDisplay: json['genreDisplay'] ?? '',
      rating: (json['rating'] ?? 0).toDouble(),
      views: json['views'] ?? '',
      viewsCount: json['viewsCount'] ?? 0,
      totalEpisodes: json['totalEpisodes'] ?? 0,
      freeEpisodes: json['freeEpisodes'] ?? 0,
      isPaid: json['isPaid'] ?? false,
      plan: json['plan'] ?? '',
      isSaved: json['isSaved'] ?? false,
      isInWatchlist: json['isInWatchlist'] ?? false,
      cta: BannerCta.fromJson(json['cta'] ?? {}),
    );
  }
}

class BannerCta {
  final String primaryLabel;
  final String primaryAction;
  final int episodeNumber;
  final String secondaryLabel;
  final String secondaryAction;

  BannerCta({
    required this.primaryLabel,
    required this.primaryAction,
    required this.episodeNumber,
    required this.secondaryLabel,
    required this.secondaryAction,
  });

  factory BannerCta.fromJson(Map<String, dynamic> json) {
    return BannerCta(
      primaryLabel: json['primaryLabel'] ?? '',
      primaryAction: json['primaryAction'] ?? '',
      episodeNumber: json['episodeNumber'] ?? 0,
      secondaryLabel: json['secondaryLabel'] ?? '',
      secondaryAction: json['secondaryAction'] ?? '',
    );
  }
}
