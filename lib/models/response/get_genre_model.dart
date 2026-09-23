class GenreResponseModel {
  final bool success;
  final int statusCode;
  final String message;
  final GenreData data;

  GenreResponseModel({
    required this.success,
    required this.statusCode,
    required this.message,
    required this.data,
  });

  factory GenreResponseModel.fromJson(Map<String, dynamic> json) {
    return GenreResponseModel(
      success: json['success'] ?? false,
      statusCode: json['statusCode'] ?? 0,
      message: json['message'] ?? '',
      data: GenreData.fromJson(json['data'] ?? {}),
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

class GenreData {
  final List<GenreModel> genres;

  GenreData({
    required this.genres,
  });

  factory GenreData.fromJson(Map<String, dynamic> json) {
    return GenreData(
      genres: (json['genres'] as List<dynamic>?)
          ?.map(
            (item) => GenreModel.fromJson(
          item as Map<String, dynamic>,
        ),
      )
          .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'genres': genres.map((genre) => genre.toJson()).toList(),
    };
  }
}

class GenreModel {
  final String id;
  final String slug;
  final int displayOrder;
  final String icon;
  final String iconUrl;
  final String imageUrl;
  final String name;

  GenreModel({
    required this.id,
    required this.slug,
    required this.displayOrder,
    required this.icon,
    required this.iconUrl,
    required this.imageUrl,
    required this.name,
  });

  factory GenreModel.fromJson(Map<String, dynamic> json) {
    return GenreModel(
      id: json['_id'] ?? '',
      slug: json['slug'] ?? '',
      displayOrder: json['displayOrder'] ?? 0,
      icon: json['icon'] ?? '',
      iconUrl: json['iconUrl'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      name: json['name'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'slug': slug,
      'displayOrder': displayOrder,
      'icon': icon,
      'iconUrl': iconUrl,
      'imageUrl': imageUrl,
      'name': name,
    };
  }
}