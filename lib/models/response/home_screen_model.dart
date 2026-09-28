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
      statusCode: json['statusCode'] is int
          ? json['statusCode']
          : int.tryParse(json['statusCode']?.toString() ?? '0') ?? 0,
      message: (json['message'] ?? '').toString(),
      data: HomeBannersData.fromJson(json['data']),
    );
  }
}

class HomeBannersData {
  final List<HomeBanner> banners;
  final int total;

  HomeBannersData({required this.banners, required this.total});

  factory HomeBannersData.fromJson(dynamic json) {
    if (json == null) {
      return HomeBannersData(banners: [], total: 0);
    }
    if (json is List) {
      return HomeBannersData(
        banners: json
            .whereType<Map<String, dynamic>>()
            .map((e) => HomeBanner.fromJson(e))
            .toList(),
        total: json.length,
      );
    }
    if (json is Map<String, dynamic>) {
      final list = json['banners'] ?? json['items'] ?? json['data'] ?? [];
      if (list is List) {
        return HomeBannersData(
          banners: list
              .whereType<Map<String, dynamic>>()
              .map((e) => HomeBanner.fromJson(e))
              .toList(),
          total: json['total'] is int
              ? json['total']
              : int.tryParse(json['total']?.toString() ?? '0') ?? list.length,
        );
      }
    }
    return HomeBannersData(banners: [], total: 0);
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
    final dramaMap = json['drama'] is Map<String, dynamic>
        ? json['drama'] as Map<String, dynamic>
        : <String, dynamic>{};

    final id = (json['id'] ??
            json['_id'] ??
            json['bannerId'] ??
            dramaMap['_id'] ??
            dramaMap['id'] ??
            '')
        .toString();

    final bannerId = (json['bannerId'] ?? json['_id'] ?? json['id'] ?? '')
        .toString();

    final dramaId = (json['dramaId'] ??
            dramaMap['_id'] ??
            dramaMap['id'] ??
            json['id'] ??
            json['_id'] ??
            '')
        .toString();

    final title = (json['title'] ??
            json['name'] ??
            dramaMap['title'] ??
            dramaMap['name'] ??
            '')
        .toString();

    final slug = (json['slug'] ?? dramaMap['slug'] ?? '').toString();

    final tagline = (json['tagline'] ??
            json['subtitle'] ??
            dramaMap['tagline'] ??
            dramaMap['subtitle'] ??
            '')
        .toString();

    final synopsis = (json['synopsis'] ??
            json['description'] ??
            dramaMap['synopsis'] ??
            dramaMap['description'] ??
            '')
        .toString();

    // ── Robust Banner URL resolution (Banner Image is prioritized) ──
    final bannerUrl = (json['bannerUrl'] ??
            json['banner'] ??
            json['bannerImage'] ??
            json['imageUrl'] ??
            json['image'] ??
            json['backdropUrl'] ??
            json['backdrop'] ??
            json['url'] ??
            dramaMap['bannerUrl'] ??
            dramaMap['banner'] ??
            dramaMap['bannerImage'] ??
            dramaMap['image'] ??
            dramaMap['imageUrl'] ??
            '')
        .toString();

    // ── Robust Poster URL resolution ──
    final posterUrl = (json['posterUrl'] ??
            json['poster'] ??
            json['posterImage'] ??
            json['thumbnailUrl'] ??
            json['thumbnail'] ??
            dramaMap['posterUrl'] ??
            dramaMap['poster'] ??
            dramaMap['posterImage'] ??
            dramaMap['thumbnailUrl'] ??
            dramaMap['image'] ??
            '')
        .toString();

    final trailerUrl = (json['trailerUrl'] ??
            json['trailer'] ??
            dramaMap['trailerUrl'] ??
            dramaMap['trailer'] ??
            '')
        .toString();

    final badge = (json['badge'] ?? json['tag'] ?? dramaMap['badge'] ?? '')
        .toString();

    final rawGenres = json['genres'] ?? dramaMap['genres'];
    final genres = _parseStringList(rawGenres);

    final genreDisplay = (json['genreDisplay'] ??
            (genres.isNotEmpty ? genres.join(' • ') : '') ??
            dramaMap['genreDisplay'] ??
            '')
        .toString();

    final ratingVal = json['rating'] ?? dramaMap['rating'];
    final rating = ratingVal is num
        ? ratingVal.toDouble()
        : double.tryParse(ratingVal?.toString() ?? '0') ?? 0.0;

    final views = (json['views'] ?? dramaMap['views'] ?? '').toString();

    final viewsCountVal = json['viewsCount'] ?? dramaMap['viewsCount'];
    final viewsCount = viewsCountVal is int
        ? viewsCountVal
        : int.tryParse(viewsCountVal?.toString() ?? '0') ?? 0;

    final totalEpisodesVal =
        json['totalEpisodes'] ?? dramaMap['totalEpisodes'];
    final totalEpisodes = totalEpisodesVal is int
        ? totalEpisodesVal
        : int.tryParse(totalEpisodesVal?.toString() ?? '0') ?? 0;

    final freeEpisodesVal =
        json['freeEpisodes'] ?? dramaMap['freeEpisodes'];
    final freeEpisodes = freeEpisodesVal is int
        ? freeEpisodesVal
        : int.tryParse(freeEpisodesVal?.toString() ?? '0') ?? 0;

    final isPaid = (json['isPaid'] ?? dramaMap['isPaid'] ?? false) == true;
    final plan = (json['plan'] ?? dramaMap['plan'] ?? '').toString();
    final isSaved = (json['isSaved'] ?? dramaMap['isSaved'] ?? false) == true;
    final isInWatchlist =
        (json['isInWatchlist'] ?? dramaMap['isInWatchlist'] ?? false) == true;

    return HomeBanner(
      id: id,
      bannerId: bannerId,
      dramaId: dramaId,
      title: title,
      slug: slug,
      tagline: tagline,
      synopsis: synopsis,
      bannerUrl: bannerUrl,
      posterUrl: posterUrl,
      trailerUrl: trailerUrl,
      badge: badge,
      genres: genres,
      genreDisplay: genreDisplay,
      rating: rating,
      views: views,
      viewsCount: viewsCount,
      totalEpisodes: totalEpisodes,
      freeEpisodes: freeEpisodes,
      isPaid: isPaid,
      plan: plan,
      isSaved: isSaved,
      isInWatchlist: isInWatchlist,
      cta: BannerCta.fromJson(json['cta'] is Map<String, dynamic> ? json['cta'] : {}),
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
      primaryLabel: (json['primaryLabel'] ?? '').toString(),
      primaryAction: (json['primaryAction'] ?? '').toString(),
      episodeNumber: json['episodeNumber'] is int
          ? json['episodeNumber']
          : int.tryParse(json['episodeNumber']?.toString() ?? '0') ?? 0,
      secondaryLabel: (json['secondaryLabel'] ?? '').toString(),
      secondaryAction: (json['secondaryAction'] ?? '').toString(),
    );
  }
}
