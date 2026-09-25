class SearchSuggestionsResponse {
  final bool success;
  final int statusCode;
  final String message;
  final SearchSuggestionsData data;

  SearchSuggestionsResponse({
    required this.success,
    required this.statusCode,
    required this.message,
    required this.data,
  });

  factory SearchSuggestionsResponse.fromJson(Map<String, dynamic> json) {
    return SearchSuggestionsResponse(
      success: json['success'] ?? false,
      statusCode: json['statusCode'] is int
          ? json['statusCode']
          : int.tryParse(json['statusCode']?.toString() ?? '0') ?? 0,
      message: (json['message'] ?? '').toString(),
      data: SearchSuggestionsData.fromJson(
        json['data'] is Map<String, dynamic> ? json['data'] : {},
      ),
    );
  }
}

class SearchSuggestionsData {
  final String query;
  final List<SearchSuggestion> suggestions;
  final List<SearchDrama> dramas;
  final List<SearchGenre> genres;

  SearchSuggestionsData({
    required this.query,
    required this.suggestions,
    required this.dramas,
    required this.genres,
  });

  factory SearchSuggestionsData.fromJson(Map<String, dynamic> json) {
    return SearchSuggestionsData(
      query: (json['query'] ?? '').toString(),
      suggestions: (json['suggestions'] as List<dynamic>? ?? [])
          .whereType<Map<String, dynamic>>()
          .map((e) => SearchSuggestion.fromJson(e))
          .toList(),
      dramas: (json['dramas'] as List<dynamic>? ?? [])
          .whereType<Map<String, dynamic>>()
          .map((e) => SearchDrama.fromJson(e))
          .toList(),
      genres: (json['genres'] as List<dynamic>? ?? [])
          .whereType<Map<String, dynamic>>()
          .map((e) => SearchGenre.fromJson(e))
          .toList(),
    );
  }
}

class SearchSuggestion {
  final String type;
  final String id;
  final String title;
  final String slug;
  final String posterUrl;
  final double rating;
  final String viewsFormatted;

  SearchSuggestion({
    required this.type,
    required this.id,
    required this.title,
    required this.slug,
    required this.posterUrl,
    required this.rating,
    required this.viewsFormatted,
  });

  factory SearchSuggestion.fromJson(Map<String, dynamic> json) {
    return SearchSuggestion(
      type: (json['type'] ?? '').toString(),
      id: (json['id'] ?? json['_id'] ?? '').toString(),
      title: (json['title'] ?? json['name'] ?? '').toString(),
      slug: (json['slug'] ?? '').toString(),
      posterUrl: (json['posterUrl'] ?? json['poster'] ?? json['image'] ?? '').toString(),
      rating: json['rating'] is num
          ? (json['rating'] as num).toDouble()
          : double.tryParse(json['rating']?.toString() ?? '0.0') ?? 0.0,
      viewsFormatted: (json['viewsFormatted'] ?? '').toString(),
    );
  }
}

class SearchDrama {
  final String id;
  final String title;
  final String slug;
  final String posterUrl;

  SearchDrama({
    required this.id,
    required this.title,
    required this.slug,
    required this.posterUrl,
  });

  factory SearchDrama.fromJson(Map<String, dynamic> json) {
    return SearchDrama(
      id: (json['id'] ?? json['_id'] ?? '').toString(),
      title: (json['title'] ?? json['name'] ?? '').toString(),
      slug: (json['slug'] ?? '').toString(),
      posterUrl: (json['posterUrl'] ?? json['poster'] ?? json['image'] ?? '').toString(),
    );
  }
}

class SearchGenre {
  final String id;
  final String name;
  final String slug;

  SearchGenre({
    this.id = '',
    this.name = '',
    this.slug = '',
  });

  factory SearchGenre.fromJson(Map<String, dynamic> json) {
    return SearchGenre(
      id: (json['id'] ?? json['_id'] ?? '').toString(),
      name: (json['name'] ?? json['title'] ?? '').toString(),
      slug: (json['slug'] ?? '').toString(),
    );
  }
}
