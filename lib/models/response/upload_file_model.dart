class UploadFileResponseModel {
  final bool success;
  final int statusCode;
  final String message;
  final UploadFileData? data;

  UploadFileResponseModel({
    required this.success,
    required this.statusCode,
    required this.message,
    this.data,
  });

  factory UploadFileResponseModel.fromJson(Map<String, dynamic> json) {
    return UploadFileResponseModel(
      success: json['success'] ?? false,
      statusCode: json['statusCode'] ?? 0,
      message: json['message'] ?? '',
      data: json['data'] != null ? UploadFileData.fromJson(json['data']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'statusCode': statusCode,
      'message': message,
      'data': data?.toJson(),
    };
  }
}

class UploadFileData {
  final String filename;
  final String originalName;
  final String mimetype;
  final int size;
  final String folder;
  final String url;
  final String path;

  UploadFileData({
    required this.filename,
    required this.originalName,
    required this.mimetype,
    required this.size,
    required this.folder,
    required this.url,
    required this.path,
  });

  factory UploadFileData.fromJson(Map<String, dynamic> json) {
    return UploadFileData(
      filename: json['filename'] ?? '',
      originalName: json['originalName'] ?? '',
      mimetype: json['mimetype'] ?? '',
      size: json['size'] ?? 0,
      folder: json['folder'] ?? '',
      url: json['url'] ?? '',
      path: json['path'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'filename': filename,
      'originalName': originalName,
      'mimetype': mimetype,
      'size': size,
      'folder': folder,
      'url': url,
      'path': path,
    };
  }
}
