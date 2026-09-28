import 'package:e_square_ott_app/constants/enum.dart';
import 'package:e_square_ott_app/feature/notification/datasource/notification_datasource.dart';
import 'package:e_square_ott_app/models/response/all_notification_model.dart';
import 'package:e_square_ott_app/shared/service/notification_service.dart';
import 'package:e_square_ott_app/shared/utils/log_util.dart';
import 'package:e_square_ott_app/shared/widgets/custom_sncakbar.dart';
import 'package:get/get.dart';

class AllNotificationController extends GetxController {
  final NotificationDatasource datasource = NotificationDatasource();

  final allNotificationStatus = Status.init.obs;
  final moreNotificationStatus = Status.init.obs;
  final markReadStatus = Status.init.obs;
  final markAllReadStatus = Status.init.obs;
  final clearAllStatus = Status.init.obs;
  final allNotificationResponse = Rxn<NotificationsResponse?>();
  final deleteNotificationStatus = Status.init.obs;

  final groups = <NotificationGroup>[].obs;
  final unreadCount = 0.obs;
  final pageNo = 0.obs;
  final size = 20.obs;
  final hasNextPage = false.obs;
  final selectedType = Rxn<String>(); // null means all types

  final Set<String> _shownLocalNotificationIds = {};

  @override
  void onInit() {
    super.onInit();
    allNotification(showLocalForUnread: true);
    fetchUnreadCount();
  }

  // ── 1. Fetch First Page of Notifications ──
  Future<void> allNotification({bool showLocalForUnread = false}) async {
    allNotificationStatus.value = Status.loading;
    pageNo.value = 0;

    try {
      var result = await datasource.allNotification(
        pageNo: pageNo.value,
        size: size.value,
        type: selectedType.value,
      );

      // If page 0 returned empty but has pagination data or vice-versa, handle gracefully
      if (result != null &&
          result.success &&
          result.data.groups.isEmpty &&
          result.data.pagination.page == 1 &&
          result.data.pagination.hasPrevPage) {
        result = await datasource.allNotification(
          pageNo: 0,
          size: size.value,
          type: selectedType.value,
        );
      }

      if (result != null && result.success) {
        allNotificationResponse.value = result;
        pageNo.value = result.data.pagination.page;
        hasNextPage.value = result.data.pagination.hasNextPage;
        unreadCount.value = result.data.unreadCount;

        groups.assignAll(result.data.groups);
        allNotificationStatus.value = Status.success;

        if (showLocalForUnread) {
          _showUnreadNotificationsLocally(result.data.groups);
        }
      } else {
        allNotificationStatus.value = Status.error;
      }
    } catch (e, stack) {
      allNotificationStatus.value = Status.error;
      LogUtil.error(
        "allNotification error: $e",
        name: "AllNotificationController",
        error: e,
        stackTrace: stack,
      );
    }
  }

  void _showUnreadNotificationsLocally(List<NotificationGroup> groups) {
    try {
      for (final group in groups) {
        for (final item in group.notifications) {
          if (!item.isRead && !_shownLocalNotificationIds.contains(item.id)) {
            _shownLocalNotificationIds.add(item.id);
            NotificationService.instance.showLocalNotification(
              title: item.title.isNotEmpty ? item.title : 'E-Square OTT',
              body: item.body,
              data: {
                'id': item.id,
                'type': item.type,
                'contentId': item.contentId,
              },
            );
          }
        }
      }
    } catch (e, stack) {
      LogUtil.error(
        "Error showing local notification for API notifications: $e",
        name: "AllNotificationController",
        error: e,
        stackTrace: stack,
      );
    }
  }

  Future<void> showLocalNotificationForItem(AppNotification item) async {
    await NotificationService.instance.showLocalNotification(
      title: item.title.isNotEmpty ? item.title : 'E-Square OTT',
      body: item.body,
      data: {'id': item.id, 'type': item.type, 'contentId': item.contentId},
    );
  }

  // ── Pagination: Load More Notifications ──
  Future<void> getMoreNotification() async {
    if (!hasNextPage.value || moreNotificationStatus.value == Status.loading) {
      return;
    }
    moreNotificationStatus.value = Status.loading;
    try {
      final nextPage = pageNo.value + 1;
      final result = await datasource.allNotification(
        pageNo: nextPage,
        size: size.value,
        type: selectedType.value,
      );
      if (result != null && result.success) {
        pageNo.value = nextPage;
        hasNextPage.value = result.data.pagination.hasNextPage;

        for (final newGroup in result.data.groups) {
          final existingGroupIndex = groups.indexWhere(
            (g) => g.label == newGroup.label,
          );
          if (existingGroupIndex != -1) {
            groups[existingGroupIndex].notifications.addAll(
              newGroup.notifications,
            );
          } else {
            groups.add(newGroup);
          }
        }
        groups.refresh();
        moreNotificationStatus.value = Status.success;
      } else {
        moreNotificationStatus.value = Status.error;
      }
    } catch (e, stack) {
      moreNotificationStatus.value = Status.error;
      LogUtil.error(
        "getMoreNotification error: $e",
        name: "AllNotificationController",
        error: e,
        stackTrace: stack,
      );
    }
  }

  // ── Fetch Unread Count ──
  Future<void> fetchUnreadCount() async {
    try {
      final result = await datasource.getUnreadCount();
      if (result != null && result.success) {
        unreadCount.value = result.unreadCount;
      }
    } catch (e, stack) {
      LogUtil.error(
        "fetchUnreadCount error: $e",
        name: "AllNotificationController",
        error: e,
        stackTrace: stack,
      );
    }
  }

  // ── Mark Single Notification as Read ──
  Future<void> markSingleAsRead(String id) async {
    try {
      // Optimistically update locally
      _setNotificationReadState(id, true);
      final result = await datasource.markSingleAsRead(id: id);
      if (result != null && result.success) {
        if (unreadCount.value > 0) {
          unreadCount.value--;
        }
      }
    } catch (e, stack) {
      LogUtil.error(
        "markSingleAsRead error: $e",
        name: "AllNotificationController",
        error: e,
        stackTrace: stack,
      );
    }
  }

  // ── Mark All Notifications as Read ──
  Future<void> markAllAsRead() async {
    markAllReadStatus.value = Status.loading;
    try {
      // Optimistically mark all read locally
      for (final group in groups) {
        for (final notification in group.notifications) {
          notification.isRead = true;
        }
      }
      unreadCount.value = 0;
      groups.refresh();

      final result = await datasource.markAllAsRead();
      if (result != null && result.success) {
        markAllReadStatus.value = Status.success;
        AppSnackbar.success("All notifications marked as read");
      } else {
        markAllReadStatus.value = Status.error;
      }
    } catch (e, stack) {
      markAllReadStatus.value = Status.error;
      LogUtil.error(
        "markAllAsRead error: $e",
        name: "AllNotificationController",
        error: e,
        stackTrace: stack,
      );
    }
  }

  // ── Delete Single Notification ──
  Future<void> deleteSingleNotification(String id) async {
    await setDeleteNotification(id: id);
  }

  // ── Clear All Notifications ──
  Future<void> clearAllNotifications() async {
    clearAllStatus.value = Status.loading;
    try {
      final result = await datasource.clearAllNotifications();
      if (result != null && result.success) {
        groups.clear();
        unreadCount.value = 0;
        clearAllStatus.value = Status.success;
        AppSnackbar.success("All notifications cleared");
      } else {
        clearAllStatus.value = Status.error;
      }
    } catch (e, stack) {
      clearAllStatus.value = Status.error;
      LogUtil.error(
        "clearAllNotifications error: $e",
        name: "AllNotificationController",
        error: e,
        stackTrace: stack,
      );
    }
  }

  // ── Seed Sample Notifications ──
  Future<void> seedSampleNotifications({bool reset = true}) async {
    try {
      final success = await datasource.seedNotifications(reset: reset);
      if (success) {
        await allNotification();
      }
    } catch (e, stack) {
      LogUtil.error(
        "seedSampleNotifications error: $e",
        name: "AllNotificationController",
        error: e,
        stackTrace: stack,
      );
    }
  }

  // ── Filter by Type ──
  void filterByType(String? type) {
    selectedType.value = type;
    allNotification();
  }

  void dismissNotification(String id) {
    for (final group in groups) {
      for (final item in group.notifications) {
        if (item.id == id && !item.isRead && unreadCount.value > 0) {
          unreadCount.value--;
          break;
        }
      }
      group.notifications.removeWhere((item) => item.id == id);
    }
    groups.removeWhere((group) => group.notifications.isEmpty);
    groups.refresh();
  }

  void _setNotificationReadState(String id, bool isRead) {
    for (final group in groups) {
      for (final notification in group.notifications) {
        if (notification.id == id) {
          notification.isRead = isRead;
          break;
        }
      }
    }
    groups.refresh();
  }

  Future<void> setDeleteNotification({required String id}) async {
    deleteNotificationStatus.value = Status.loading;
    try {
      dismissNotification(id);
      final result = await datasource.deleteSingleNotification(id: id);
      if (result) {
        deleteNotificationStatus.value = Status.success;
      } else {
        deleteNotificationStatus.value = Status.error;
        await allNotification();
      }
    } catch (e, stack) {
      deleteNotificationStatus.value = Status.error;
      LogUtil.error(
        "setDeleteNotification error: $e",
        name: "AllNotificationController",
        error: e,
        stackTrace: stack,
      );
      await allNotification();
    } finally {
      deleteNotificationStatus.value = Status.init;
    }
  }
}
