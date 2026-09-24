import 'package:e_square_ott_app/constants/enum.dart';
import 'package:e_square_ott_app/feature/home/controller/home_controller.dart';
import 'package:e_square_ott_app/feature/notification/datasource/notification_datasource.dart';
import 'package:e_square_ott_app/models/response/all_notification_model.dart';
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

  final groups = <NotificationGroup>[].obs;
  final unreadCount = 0.obs;
  final pageNo = 0.obs;
  final size = 20.obs;
  final hasNextPage = false.obs;
  final selectedType = Rxn<String>(); // NEW_EPISODE, NEW_RELEASE, RECOMMENDATION, SYSTEM

  @override
  void onInit() {
    super.onInit();
    allNotification();
    ever<int>(unreadCount, (count) {
      if (Get.isRegistered<HomeController>()) {
        Get.find<HomeController>().unreadNotifications.value = count;
      }
    });
  }

  // ── Fetch Notifications List ──
  Future<void> allNotification() async {
    allNotificationStatus.value = Status.loading;
    pageNo.value = 0;
    try {
      final result = await datasource.allNotification(
        pageNo: 0,
        size: size.value,
        type: selectedType.value,
      );
      if (result != null && result.success) {
        allNotificationResponse.value = result;
        unreadCount.value = result.data.unreadCount;
        hasNextPage.value = result.data.pagination.hasNextPage;
        groups.assignAll(result.data.groups);
        allNotificationStatus.value = Status.success;
      } else {
        allNotificationStatus.value = Status.error;
      }
    } catch (e) {
      allNotificationStatus.value = Status.error;
      print("allNotification error: $e");
    }
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
    } catch (e) {
      moreNotificationStatus.value = Status.error;
      print("getMoreNotification error: $e");
    }
  }

  // ── Fetch Unread Count ──
  Future<void> fetchUnreadCount() async {
    try {
      final result = await datasource.getUnreadCount();
      if (result != null && result.success) {
        unreadCount.value = result.unreadCount;
      }
    } catch (e) {
      print("fetchUnreadCount error: $e");
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
    } catch (e) {
      print("markSingleAsRead error: $e");
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
    } catch (e) {
      markAllReadStatus.value = Status.error;
      print("markAllAsRead error: $e");
    }
  }

  // ── Delete Single Notification (Swipe to Dismiss) ──
  Future<void> deleteSingleNotification(String id) async {
    try {
      // Remove locally
      dismissNotification(id);
      await datasource.deleteSingleNotification(id: id);
    } catch (e) {
      print("deleteSingleNotification error: $e");
    }
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
    } catch (e) {
      clearAllStatus.value = Status.error;
      print("clearAllNotifications error: $e");
    }
  }

  // ── Seed Sample Notifications ──
  Future<void> seedSampleNotifications({bool reset = true}) async {
    try {
      final success = await datasource.seedNotifications(reset: reset);
      if (success) {
        await allNotification();
      }
    } catch (e) {
      print("seedSampleNotifications error: $e");
    }
  }

  // ── Filter by Type ──
  void filterByType(String? type) {
    selectedType.value = type;
    allNotification();
  }

  void dismissNotification(String id) {
    for (final group in groups) {
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
}
