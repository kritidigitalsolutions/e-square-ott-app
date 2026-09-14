import 'package:e_square_ott_app/constants/app_colors.dart';
import 'package:e_square_ott_app/constants/app_text_styles.dart';
import 'package:e_square_ott_app/routes/app_pages.dart';
import 'package:e_square_ott_app/shared/widgets/custom_buttons.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/route_manager.dart';

class NotificationItem {
  final String id;
  final String title;
  final String message;
  final String time;
  final String dateGroup; // e.g. "Today", "2 Days Ago"
  final String thumbnail; // asset path or network url
  bool isRead;

  NotificationItem({
    required this.id,
    required this.title,
    required this.message,
    required this.time,
    required this.dateGroup,
    required this.thumbnail,
    this.isRead = false,
  });
}

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  // Replace with real data from your controller/provider.
  final List<NotificationItem> notifications = [
    NotificationItem(
      id: "1",
      title: "New Episode Available",
      message: "Episode 09 of The Last Promise is now available.",
      time: "12 min ago",
      dateGroup: "Today",
      thumbnail: "assets/images/tu_issaq_mera.jpg",
    ),
    NotificationItem(
      id: "2",
      title: "New Release",
      message: "A new drama has arrived. Discover Dangerous Love.",
      time: "12 min ago",
      dateGroup: "Today",
      thumbnail: "assets/images/tu_issaq_mera_2.jpg",
    ),
    NotificationItem(
      id: "3",
      title: "New Episode Available",
      message: "Episode 09 of The Last Promise is now available.",
      time: "2 days ago",
      dateGroup: "2 Days Ago",
      thumbnail: "assets/images/tu_issaq_mera.jpg",
      isRead: true,
    ),
    NotificationItem(
      id: "4",
      title: "New Release",
      message: "A new drama has arrived. Discover Dangerous Love.",
      time: "2 days ago",
      dateGroup: "2 Days Ago",
      thumbnail: "assets/images/tu_issaq_mera_2.jpg",
      isRead: true,
    ),
  ];

  void _dismissNotification(String id) {
    setState(() {
      notifications.removeWhere((n) => n.id == id);
    });
  }

  /// Groups notifications while preserving their original order,
  /// so "Today" always appears before "2 Days Ago" etc.
  Map<String, List<NotificationItem>> get _groupedNotifications {
    final Map<String, List<NotificationItem>> grouped = {};
    for (final item in notifications) {
      grouped.putIfAbsent(item.dateGroup, () => []).add(item);
    }
    return grouped;
  }

  @override
  Widget build(BuildContext context) {
    final grouped = _groupedNotifications;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: AppColors.loginBgGradient,
              ),
            ),
          ),
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomBackButton(onTap: () => Get.back()),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Notifications",
                              style: AppTextStyles.text24Bold.copyWith(
                                color: AppColors.white,
                                height: 1.18,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              "Your latest updates",
                              style: AppTextStyles.text14.copyWith(
                                color: AppColors.white.withOpacity(0.5),
                              ),
                            ),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () => Get.toNamed(Routes.notificationSetting),
                        child: Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: const Color(0xFF16161E),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.08),
                              width: 1,
                            ),
                          ),
                          child: const Center(
                            child: Icon(
                              Icons.tune_rounded,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 8),

                // Body
                Expanded(
                  child: notifications.isEmpty
                      ? _buildEmptyState()
                      : ListView(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          children: grouped.entries.expand((entry) {
                            final groupLabel = entry.key;
                            final items = entry.value;

                            return [
                              Padding(
                                padding: const EdgeInsets.only(
                                  top: 12,
                                  bottom: 10,
                                ),
                                child: Text(
                                  groupLabel,
                                  style: AppTextStyles.text14.copyWith(
                                    color: AppColors.white.withOpacity(0.5),
                                  ),
                                ),
                              ),
                              ...items.map(
                                (item) => Padding(
                                  padding: const EdgeInsets.only(bottom: 12),
                                  child: Dismissible(
                                    key: ValueKey(item.id),
                                    direction: DismissDirection.endToStart,
                                    onDismissed: (_) =>
                                        _dismissNotification(item.id),
                                    background: Container(
                                      alignment: Alignment.centerRight,
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 20,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.redAccent.withOpacity(
                                          0.8,
                                        ),
                                        borderRadius: BorderRadius.circular(14),
                                      ),
                                      child: const Icon(
                                        Icons.delete_outline,
                                        color: Colors.white,
                                      ),
                                    ),
                                    child: _NotificationCard(item: item),
                                  ),
                                ),
                              ),
                            ];
                          }).toList(),
                        ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.notifications_none_rounded,
            size: 64,
            color: AppColors.white.withOpacity(0.5),
          ),
          const SizedBox(height: 12),
          Text(
            "No notifications yet",
            style: AppTextStyles.text16Bold.copyWith(
              color: AppColors.white.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }
}

class _NotificationCard extends StatelessWidget {
  final NotificationItem item;

  const _NotificationCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.white.withOpacity(item.isRead ? 0.04 : 0.07),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.white.withOpacity(0.1)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: AppTextStyles.text18Bold.copyWith(
                    color: AppColors.white,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  item.message,
                  style: AppTextStyles.text14.copyWith(
                    color: AppColors.white.withOpacity(0.8),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  item.time,
                  style: AppTextStyles.text12.copyWith(
                    color: AppColors.white.withOpacity(0.45),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset(
              item.thumbnail,
              width: 64,
              height: 88,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                width: 64,
                height: 88,
                color: AppColors.white.withOpacity(0.1),
                child: Icon(
                  Icons.image_not_supported_outlined,
                  color: AppColors.white.withOpacity(0.4),
                  size: 20,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
