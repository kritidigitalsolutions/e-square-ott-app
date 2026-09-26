class HomeSectionsResponse {
  final bool success;
  final int statusCode;
  final String message;
  final HomeSectionsData data;

  HomeSectionsResponse({
    required this.success,
    required this.statusCode,
    required this.message,
    required this.data,
  });

  factory HomeSectionsResponse.fromJson(Map<String, dynamic> json) {
    return HomeSectionsResponse(
      success: json['success'] ?? false,
      statusCode: json['statusCode'] ?? 0,
      message: json['message'] ?? '',
      data: HomeSectionsData.fromJson(json['data'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'statusCode': statusCode,
      'message': message,
      'data': data.toJson(),
    };
  }
}

class HomeSectionsData {
  final List<HomeSection> sections;
  final Pagination pagination;

  HomeSectionsData({required this.sections, required this.pagination});

  factory HomeSectionsData.fromJson(Map<String, dynamic> json) {
    return HomeSectionsData(
      sections: (json['sections'] as List? ?? [])
          .map((e) => HomeSection.fromJson(e))
          .toList(),
      pagination: Pagination.fromJson(json['pagination'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'sections': sections.map((e) => e.toJson()).toList(),
      'pagination': pagination.toJson(),
    };
  }
}

class HomeSection {
  final String id;
  final String title;
  final String slug;
  final String subtitle;
  final String sectionType;
  final SectionGenre? genre;
  final String layout;
  final int displayOrder;
  final bool viewAllEnabled;
  final int totalItems;
  final List<Drama> dramas;

  HomeSection({
    required this.id,
    required this.title,
    required this.slug,
    required this.subtitle,
    required this.sectionType,
    this.genre,
    required this.layout,
    required this.displayOrder,
    required this.viewAllEnabled,
    required this.totalItems,
    required this.dramas,
  });

  factory HomeSection.fromJson(Map<String, dynamic> json) {
    return HomeSection(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      slug: json['slug'] ?? '',
      subtitle: json['subtitle'] ?? '',
      sectionType: json['sectionType'] ?? '',
      genre: json['genre'] != null
          ? SectionGenre.fromJson(json['genre'])
          : null,
      layout: json['layout'] ?? '',
      displayOrder: json['displayOrder'] ?? 0,
      viewAllEnabled: json['viewAllEnabled'] ?? false,
      totalItems: json['totalItems'] ?? 0,
      dramas: (json['dramas'] as List? ?? [])
          .map((e) => Drama.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'slug': slug,
      'subtitle': subtitle,
      'sectionType': sectionType,
      'genre': genre?.toJson(),
      'layout': layout,
      'displayOrder': displayOrder,
      'viewAllEnabled': viewAllEnabled,
      'totalItems': totalItems,
      'dramas': dramas.map((e) => e.toJson()).toList(),
    };
  }
}

class SectionGenre {
  final String id;
  final String name;
  final String slug;

  SectionGenre({required this.id, required this.name, required this.slug});

  factory SectionGenre.fromJson(Map<String, dynamic> json) {
    return SectionGenre(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      slug: json['slug'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'slug': slug};
  }
}

class Drama {
  final String id;
  final String mongoId;
  final String title;
  final String name;
  final String slug;
  final String synopsis;
  final String description;
  final String overview;

  final String posterUrl;
  final String poster;
  final String thumbnailUrl;
  final String thumbnail;
  final String coverImage;
  final String image;

  final String bannerUrl;
  final String banner;
  final String cover;

  final String trailerUrl;
  final String trailer;
  final String videoUrl;

  final List<String> genres;
  final List<DramaGenre> genreList;

  final String genre;
  final String genreDisplay;

  final int totalEpisodes;
  final int episodesCount;
  final int episodesCountSnakeCase;
  final int freeEpisodes;

  final bool isPaid;
  final String plan;

  final int viewsCount;
  final String viewsFormatted;
  final String views;

  final double rating;
  final int priority;

  final bool isTrending;
  final int? trendingRank;
  final bool isFeatured;
  final bool isNewRelease;
  final String status;
  final bool isActive;

  final DateTime? releaseDate;
  final DateTime? createdAt;

  Drama({
    required this.id,
    required this.mongoId,
    required this.title,
    required this.name,
    required this.slug,
    required this.synopsis,
    required this.description,
    required this.overview,
    required this.posterUrl,
    required this.poster,
    required this.thumbnailUrl,
    required this.thumbnail,
    required this.coverImage,
    required this.image,
    required this.bannerUrl,
    required this.banner,
    required this.cover,
    required this.trailerUrl,
    required this.trailer,
    required this.videoUrl,
    required this.genres,
    required this.genreList,
    required this.genre,
    required this.genreDisplay,
    required this.totalEpisodes,
    required this.episodesCount,
    required this.episodesCountSnakeCase,
    required this.freeEpisodes,
    required this.isPaid,
    required this.plan,
    required this.viewsCount,
    required this.viewsFormatted,
    required this.views,
    required this.rating,
    required this.priority,
    required this.isTrending,
    required this.trendingRank,
    required this.isFeatured,
    required this.isNewRelease,
    required this.status,
    required this.isActive,
    this.releaseDate,
    this.createdAt,
  });

  factory Drama.fromJson(Map<String, dynamic> json) {
    return Drama(
      id: json['id'] ?? '',
      mongoId: json['_id'] ?? '',
      title: json['title'] ?? '',
      name: json['name'] ?? '',
      slug: json['slug'] ?? '',
      synopsis: json['synopsis'] ?? '',
      description: json['description'] ?? '',
      overview: json['overview'] ?? '',

      posterUrl: json['posterUrl'] ?? '',
      poster: json['poster'] ?? '',
      thumbnailUrl: json['thumbnailUrl'] ?? '',
      thumbnail: json['thumbnail'] ?? '',
      coverImage: json['coverImage'] ?? '',
      image: json['image'] ?? '',

      bannerUrl: json['bannerUrl'] ?? '',
      banner: json['banner'] ?? '',
      cover: json['cover'] ?? '',

      trailerUrl: json['trailerUrl'] ?? '',
      trailer: json['trailer'] ?? '',
      videoUrl: json['videoUrl'] ?? '',

      genres: List<String>.from(json['genres'] ?? []),

      genreList: (json['genreList'] as List? ?? [])
          .map((e) => DramaGenre.fromJson(e))
          .toList(),

      genre: json['genre'] ?? '',
      genreDisplay: json['genreDisplay'] ?? '',

      totalEpisodes: json['totalEpisodes'] ?? 0,
      episodesCount: json['episodesCount'] ?? 0,
      episodesCountSnakeCase: json['episodes_count'] ?? 0,
      freeEpisodes: json['freeEpisodes'] ?? 0,

      isPaid: json['isPaid'] ?? false,
      plan: json['plan'] ?? '',

      viewsCount: json['viewsCount'] ?? 0,
      viewsFormatted: json['viewsFormatted'] ?? '',
      views: json['views'] ?? '',

      rating: (json['rating'] ?? 0).toDouble(),
      priority: json['priority'] ?? 0,

      isTrending: json['isTrending'] ?? false,
      trendingRank: json['trendingRank'],
      isFeatured: json['isFeatured'] ?? false,
      isNewRelease: json['isNewRelease'] ?? false,

      status: json['status'] ?? '',
      isActive: json['isActive'] ?? false,

      releaseDate: json['releaseDate'] != null
          ? DateTime.tryParse(json['releaseDate'])
          : null,

      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      '_id': mongoId,
      'title': title,
      'name': name,
      'slug': slug,
      'synopsis': synopsis,
      'description': description,
      'overview': overview,

      'posterUrl': posterUrl,
      'poster': poster,
      'thumbnailUrl': thumbnailUrl,
      'thumbnail': thumbnail,
      'coverImage': coverImage,
      'image': image,

      'bannerUrl': bannerUrl,
      'banner': banner,
      'cover': cover,

      'trailerUrl': trailerUrl,
      'trailer': trailer,
      'videoUrl': videoUrl,

      'genres': genres,
      'genreList': genreList.map((e) => e.toJson()).toList(),

      'genre': genre,
      'genreDisplay': genreDisplay,

      'totalEpisodes': totalEpisodes,
      'episodesCount': episodesCount,
      'episodes_count': episodesCountSnakeCase,
      'freeEpisodes': freeEpisodes,

      'isPaid': isPaid,
      'plan': plan,

      'viewsCount': viewsCount,
      'viewsFormatted': viewsFormatted,
      'views': views,

      'rating': rating,
      'priority': priority,

      'isTrending': isTrending,
      'trendingRank': trendingRank,
      'isFeatured': isFeatured,
      'isNewRelease': isNewRelease,

      'status': status,
      'isActive': isActive,

      'releaseDate': releaseDate?.toIso8601String(),
      'createdAt': createdAt?.toIso8601String(),
    };
  }
}

class DramaGenre {
  final String id;
  final String name;
  final String slug;

  DramaGenre({required this.id, required this.name, required this.slug});

  factory DramaGenre.fromJson(Map<String, dynamic> json) {
    return DramaGenre(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      slug: json['slug'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'slug': slug};
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

  Map<String, dynamic> toJson() {
    return {
      'page': page,
      'limit': limit,
      'total': total,
      'totalPages': totalPages,
      'hasNextPage': hasNextPage,
      'hasPrevPage': hasPrevPage,
    };
  }
}
