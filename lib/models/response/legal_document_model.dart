class LegalDocumentResponse {
  final bool success;
  final int statusCode;
  final String message;
  final LegalDocument data;

  LegalDocumentResponse({
    required this.success,
    required this.statusCode,
    required this.message,
    required this.data,
  });

  factory LegalDocumentResponse.fromJson(Map<String, dynamic> json) {
    return LegalDocumentResponse(
      success: json['success'] ?? false,
      statusCode: json['statusCode'] ?? 0,
      message: json['message'] ?? '',
      data: LegalDocument.fromJson(json['data'] ?? {}),
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

class LegalDocument {
  final String id;
  final String slug;
  final String title;
  final String summary;
  final String version;
  final String effectiveDate;
  final String lastUpdated;
  final bool isActive;
  final LegalMetadata? metadata;
  final String content;

  LegalDocument({
    required this.id,
    required this.slug,
    required this.title,
    required this.summary,
    required this.version,
    required this.effectiveDate,
    required this.lastUpdated,
    required this.isActive,
    this.metadata,
    required this.content,
  });

  factory LegalDocument.fromJson(Map<String, dynamic> json) {
    return LegalDocument(
      id: json['_id'] ?? '',
      slug: json['slug'] ?? '',
      title: json['title'] ?? '',
      summary: json['summary'] ?? '',
      version: json['version'] ?? '',
      effectiveDate: json['effectiveDate'] ?? '',
      lastUpdated: json['lastUpdated'] ?? '',
      isActive: json['isActive'] ?? false,
      metadata: json['metadata'] != null
          ? LegalMetadata.fromJson(json['metadata'])
          : null,
      content: json['content'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'slug': slug,
      'title': title,
      'summary': summary,
      'version': version,
      'effectiveDate': effectiveDate,
      'lastUpdated': lastUpdated,
      'isActive': isActive,
      'metadata': metadata?.toJson(),
      'content': content,
    };
  }
}

class LegalMetadata {
  final String? category;
  final String? contactEmail;
  final String? dpoOfficer;
  final String? supportEmail;
  final String? legalJurisdiction;

  LegalMetadata({
    this.category,
    this.contactEmail,
    this.dpoOfficer,
    this.supportEmail,
    this.legalJurisdiction,
  });

  factory LegalMetadata.fromJson(Map<String, dynamic> json) {
    return LegalMetadata(
      category: json['category'],
      contactEmail: json['contactEmail'],
      dpoOfficer: json['dpoOfficer'],
      supportEmail: json['supportEmail'],
      legalJurisdiction: json['legalJurisdiction'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'category': category,
      'contactEmail': contactEmail,
      'dpoOfficer': dpoOfficer,
      'supportEmail': supportEmail,
      'legalJurisdiction': legalJurisdiction,
    };
  }
}
