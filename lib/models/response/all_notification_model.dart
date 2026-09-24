class NotificationsResponse {
  final bool success;
  final int statusCode;
  final String message;
  final NotificationsData data;

  NotificationsResponse({
    required this.success,
    required this.statusCode,
    required this.message,
    required this.data,
  });

  factory NotificationsResponse.fromJson(Map<String, dynamic> json) {
    return NotificationsResponse(
      success: json['success'] ?? false,
      statusCode: json['statusCode'] ?? 0,
      message: json['message'] ?? '',
      data: NotificationsData.fromJson(json['data'] ?? {}),
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

class NotificationsData {
  final int unreadCount;
  final NotificationPagination pagination;
  final List<NotificationGroup> groups;

  NotificationsData({
    required this.unreadCount,
    required this.pagination,
    required this.groups,
  });

  factory NotificationsData.fromJson(Map<String, dynamic> json) {
    return NotificationsData(
      unreadCount: json['unreadCount'] ?? 0,
      pagination: NotificationPagination.fromJson(json['pagination'] ?? {}),
      groups: (json['groups'] as List<dynamic>? ?? [])
          .map((e) => NotificationGroup.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'unreadCount': unreadCount,
      'pagination': pagination.toJson(),
      'groups': groups.map((e) => e.toJson()).toList(),
    };
  }
}

class NotificationPagination {
  final int page;
  final int limit;
  final int total;
  final int totalPages;
  final bool hasNextPage;
  final bool hasPrevPage;

  NotificationPagination({
    required this.page,
    required this.limit,
    required this.total,
    required this.totalPages,
    required this.hasNextPage,
    required this.hasPrevPage,
  });

  factory NotificationPagination.fromJson(Map<String, dynamic> json) {
    return NotificationPagination(
      page: json['page'] ?? 0,
      limit: json['limit'] ?? 20,
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

class NotificationGroup {
  final String label;
  final List<AppNotification> notifications;

  NotificationGroup({required this.label, required this.notifications});

  factory NotificationGroup.fromJson(Map<String, dynamic> json) {
    return NotificationGroup(
      label: json['label'] ?? '',
      notifications: (json['notifications'] as List<dynamic>? ?? [])
          .map((e) => AppNotification.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'label': label,
      'notifications': notifications.map((e) => e.toJson()).toList(),
    };
  }
}

class AppNotification {
  final String userId;
  final String type;
  final String title;
  final String body;
  final String imageUrl;
  final String deepLink;
  final String? contentId;
  bool isRead;
  final String? sentBy;
  final String createdAt;
  final String updatedAt;
  final String id;
  final String timeAgo;

  AppNotification({
    required this.userId,
    required this.type,
    required this.title,
    required this.body,
    required this.imageUrl,
    required this.deepLink,
    this.contentId,
    required this.isRead,
    this.sentBy,
    required this.createdAt,
    required this.updatedAt,
    required this.id,
    required this.timeAgo,
  });

  factory AppNotification.fromJson(Map<String, dynamic> json) {
    return AppNotification(
      userId: json['userId'] ?? '',
      type: json['type'] ?? '',
      title: json['title'] ?? '',
      body: json['body'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      deepLink: json['deepLink'] ?? '',
      contentId: json['contentId'],
      isRead: json['isRead'] ?? false,
      sentBy: json['sentBy'],
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
      id: (json['id'] ?? json['_id'] ?? '').toString(),
      timeAgo: json['timeAgo'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'type': type,
      'title': title,
      'body': body,
      'imageUrl': imageUrl,
      'deepLink': deepLink,
      'contentId': contentId,
      'isRead': isRead,
      'sentBy': sentBy,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'id': id,
      '_id': id,
      'timeAgo': timeAgo,
    };
  }
}

class UnreadCountResponse {
  final bool success;
  final int statusCode;
  final String message;
  final int unreadCount;

  UnreadCountResponse({
    required this.success,
    required this.statusCode,
    required this.message,
    required this.unreadCount,
  });

  factory UnreadCountResponse.fromJson(Map<String, dynamic> json) {
    return UnreadCountResponse(
      success: json['success'] ?? false,
      statusCode: json['statusCode'] ?? 0,
      message: json['message'] ?? '',
      unreadCount: json['data']?['unreadCount'] ?? 0,
    );
  }
}

class MarkSingleNotificationResponse {
  final bool success;
  final int statusCode;
  final String message;
  final AppNotification? notification;

  MarkSingleNotificationResponse({
    required this.success,
    required this.statusCode,
    required this.message,
    this.notification,
  });

  factory MarkSingleNotificationResponse.fromJson(Map<String, dynamic> json) {
    return MarkSingleNotificationResponse(
      success: json['success'] ?? false,
      statusCode: json['statusCode'] ?? 0,
      message: json['message'] ?? '',
      notification: json['data']?['notification'] != null
          ? AppNotification.fromJson(json['data']['notification'])
          : null,
    );
  }
}

class MarkAllNotificationResponse {
  final bool success;
  final int statusCode;
  final String message;
  final int updatedCount;

  MarkAllNotificationResponse({
    required this.success,
    required this.statusCode,
    required this.message,
    required this.updatedCount,
  });

  factory MarkAllNotificationResponse.fromJson(Map<String, dynamic> json) {
    return MarkAllNotificationResponse(
      success: json['success'] ?? false,
      statusCode: json['statusCode'] ?? 0,
      message: json['message'] ?? '',
      updatedCount: json['data']?['updatedCount'] ?? 0,
    );
  }
}

class ClearAllNotificationResponse {
  final bool success;
  final int statusCode;
  final String message;
  final int deletedCount;

  ClearAllNotificationResponse({
    required this.success,
    required this.statusCode,
    required this.message,
    required this.deletedCount,
  });

  factory ClearAllNotificationResponse.fromJson(Map<String, dynamic> json) {
    return ClearAllNotificationResponse(
      success: json['success'] ?? false,
      statusCode: json['statusCode'] ?? 0,
      message: json['message'] ?? '',
      deletedCount: json['data']?['deletedCount'] ?? 0,
    );
  }
}

class CommonNotificationResponse {
  final bool success;
  final int statusCode;
  final String message;

  CommonNotificationResponse({
    required this.success,
    required this.statusCode,
    required this.message,
  });

  factory CommonNotificationResponse.fromJson(Map<String, dynamic> json) {
    return CommonNotificationResponse(
      success: json['success'] ?? false,
      statusCode: json['statusCode'] ?? 0,
      message: json['message'] ?? '',
    );
  }
}
