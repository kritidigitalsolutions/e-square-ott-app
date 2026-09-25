import 'package:e_square_ott_app/constants/app_colors.dart';
import 'package:e_square_ott_app/constants/app_text_styles.dart';
import 'package:e_square_ott_app/constants/enum.dart';
import 'package:e_square_ott_app/feature/notification/controller/all_notification_controller.dart';
import 'package:e_square_ott_app/models/response/all_notification_model.dart';
import 'package:e_square_ott_app/routes/app_pages.dart';
import 'package:e_square_ott_app/shared/widgets/custom_animation.dart';
import 'package:e_square_ott_app/shared/widgets/custom_buttons.dart';
import 'package:e_square_ott_app/shared/widgets/shimmer_loader.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  late final AllNotificationController controller;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    controller = Get.put(AllNotificationController());
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      controller.getMoreNotification();
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      showAppBar: false,
      safeArea: false,
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
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CustomBackButton(onTap: () => Get.back()),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              "Notifications".tr,
                              style: AppTextStyles.text20Bold.copyWith(
                                color: AppColors.white,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              "Your latest updates".tr,
                              style: AppTextStyles.text12.copyWith(
                                color: AppColors.white.withOpacity(0.5),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Theme(
                        data: Theme.of(context).copyWith(
                          highlightColor: Colors.transparent,
                          splashColor: Colors.transparent,
                        ),
                        child: PopupMenuButton<String>(
                          padding: EdgeInsets.zero,
                          elevation: 8,
                          color: const Color(0xFF181824),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: BorderSide(
                              color: Colors.white.withValues(alpha: 0.1),
                            ),
                          ),
                          icon: Container(
                            width: 42,
                            height: 42,
                            decoration: BoxDecoration(
                              color: const Color(0xFF14141E)
                                  .withValues(alpha: 0.85),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: Colors.white.withValues(alpha: 0.12),
                                width: 1,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.35),
                                  blurRadius: 10,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: const Center(
                              child: FaIcon(
                                FontAwesomeIcons.ellipsisVertical,
                                color: Colors.white,
                                size: 15,
                              ),
                            ),
                          ),
                          onSelected: (value) {
                            if (value == 'mark_all') {
                              controller.markAllAsRead();
                            } else if (value == 'clear_all') {
                              _confirmClearAll(context, controller);
                            }
                          },
                          itemBuilder: (context) => [
                            PopupMenuItem(
                              value: 'mark_all',
                              child: Row(
                                children: [
                                  const FaIcon(
                                    FontAwesomeIcons.checkDouble,
                                    size: 14,
                                    color: AppColors.primary,
                                  ),
                                  const SizedBox(width: 10),
                                  Text(
                                    "Mark all as read".tr,
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                ],
                              ),
                            ),
                            PopupMenuItem(
                              value: 'clear_all',
                              child: Row(
                                children: [
                                  const FaIcon(
                                    FontAwesomeIcons.trashCan,
                                    size: 14,
                                    color: Colors.redAccent,
                                  ),
                                  const SizedBox(width: 10),
                                  Text(
                                    "Clear all".tr,
                                    style:
                                        const TextStyle(color: Colors.redAccent),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      GestureDetector(
                        onTap: () => Get.toNamed(Routes.notificationSetting),
                        child: Container(
                          width: 42,
                          height: 42,
                          decoration: BoxDecoration(
                            color:
                                const Color(0xFF14141E).withValues(alpha: 0.85),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.12),
                              width: 1,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.35),
                                blurRadius: 10,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: const Center(
                            child: FaIcon(
                              FontAwesomeIcons.sliders,
                              color: Colors.white,
                              size: 15,
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
                  child: Obx(() {
                    final status = controller.allNotificationStatus.value;
                    final groups = controller.groups;

                    if (status == Status.loading && groups.isEmpty) {
                      return _buildShimmerLoading();
                    }

                    if (status == Status.error && groups.isEmpty) {
                      return _buildErrorState();
                    }

                    if (groups.isEmpty) {
                      return RefreshIndicator(
                        color: AppColors.primary,
                        backgroundColor: const Color(0xFF161622),
                        onRefresh: controller.allNotification,
                        child: ListView(
                          physics: const AlwaysScrollableScrollPhysics(
                            parent: BouncingScrollPhysics(),
                          ),
                          children: [
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.6,
                              child: _buildEmptyState(),
                            ),
                          ],
                        ),
                      );
                    }

                    return RefreshIndicator(
                      color: AppColors.primary,
                      backgroundColor: const Color(0xFF161622),
                      onRefresh: controller.allNotification,
                      child: ListView.builder(
                        controller: _scrollController,
                        physics: const AlwaysScrollableScrollPhysics(
                          parent: BouncingScrollPhysics(),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        itemCount: groups.length + 1,
                        itemBuilder: (context, index) {
                          if (index == groups.length) {
                            return Obx(() {
                              if (controller.moreNotificationStatus.value ==
                                  Status.loading) {
                                return const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 20),
                                  child: Center(
                                    child: CircularProgressIndicator(
                                      color: AppColors.primary,
                                      strokeWidth: 2.5,
                                    ),
                                  ),
                                );
                              }
                              return const SizedBox(height: 16);
                            });
                          }

                          final group = groups[index];
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                  top: 12,
                                  bottom: 10,
                                ),
                                child: Text(
                                  group.label,
                                  style: AppTextStyles.text14.copyWith(
                                    color: AppColors.white.withOpacity(0.5),
                                  ),
                                ),
                              ),
                              ...group.notifications.map(
                                (item) => Padding(
                                  padding: const EdgeInsets.only(bottom: 12),
                                  child: Dismissible(
                                    key: ValueKey(item.id),
                                    direction: DismissDirection.endToStart,
                                    onDismissed: (_) => controller
                                        .setDeleteNotification(id: item.id),
                                    background: Container(
                                      alignment: Alignment.centerRight,
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 20,
                                      ),
                                      decoration: BoxDecoration(
                                        gradient: const LinearGradient(
                                          colors: [
                                            Colors.transparent,
                                            Color(0xFFE53935),
                                          ],
                                          stops: [0.0, 0.4],
                                        ),
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          Text(
                                            "Delete".tr,
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w700,
                                              fontSize: 13,
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          const FaIcon(
                                            FontAwesomeIcons.trashCan,
                                            color: Colors.white,
                                            size: 16,
                                          ),
                                        ],
                                      ),
                                    ),
                                    child: InkWell(
                                      onTap: () {
                                        if (!item.isRead) {
                                          controller.markSingleAsRead(item.id);
                                        }
                                      },
                                      borderRadius: BorderRadius.circular(16),
                                      child: _NotificationCard(item: item),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    );
                  }),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _confirmClearAll(
    BuildContext context,
    AllNotificationController controller,
  ) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF161622),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
          side: BorderSide(
            color: Colors.white.withValues(alpha: 0.1),
            width: 1,
          ),
        ),
        title: Text(
          'Clear All Notifications?'.tr,
          style: const TextStyle(
            fontFamily: AppTextStyles.fontFamily,
            color: Colors.white,
            fontWeight: FontWeight.w800,
            fontSize: 18,
          ),
        ),
        content: Text(
          'Are you sure you want to delete all notifications? This cannot be undone.'
              .tr,
          style: TextStyle(
            fontFamily: AppTextStyles.fontFamily,
            color: Colors.white.withValues(alpha: 0.7),
            fontSize: 14,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(
              'Cancel'.tr,
              style: TextStyle(
                fontFamily: AppTextStyles.fontFamily,
                color: Colors.white.withValues(alpha: 0.6),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              controller.clearAllNotifications();
            },
            child: Text(
              'Clear All'.tr,
              style: const TextStyle(
                fontFamily: AppTextStyles.fontFamily,
                color: Colors.redAccent,
                fontWeight: FontWeight.w700,
              ),
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
          FaIcon(
            FontAwesomeIcons.bell,
            size: 54,
            color: AppColors.white.withOpacity(0.4),
          ),
          const SizedBox(height: 12),
          Text(
            "No notifications yet".tr,
            style: AppTextStyles.text16Bold.copyWith(
              color: AppColors.white.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FaIcon(
            FontAwesomeIcons.circleExclamation,
            size: 48,
            color: AppColors.white.withOpacity(0.4),
          ),
          const SizedBox(height: 12),
          Text(
            "Failed to load notifications".tr,
            style: AppTextStyles.text16SemiBold.copyWith(
              color: AppColors.white.withOpacity(0.8),
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: controller.allNotification,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text("Retry".tr),
          ),
        ],
      ),
    );
  }

  Widget _buildShimmerLoading() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 4,
      itemBuilder: (_, __) {
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: const Color(0xFF14141E).withValues(alpha: 0.85),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.08),
              width: 1,
            ),
          ),
          child: CustomShimmer(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      ShimmerBox(
                        width: 160,
                        height: 16,
                        borderRadius: 4,
                      ),
                      SizedBox(height: 8),
                      ShimmerBox(
                        width: double.infinity,
                        height: 12,
                        borderRadius: 4,
                      ),
                      SizedBox(height: 6),
                      ShimmerBox(
                        width: 120,
                        height: 12,
                        borderRadius: 4,
                      ),
                      SizedBox(height: 10),
                      ShimmerBox(
                        width: 70,
                        height: 10,
                        borderRadius: 4,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                const ShimmerBox(
                  width: 60,
                  height: 82,
                  borderRadius: 10,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _NotificationCard extends StatelessWidget {
  final AppNotification item;

  const _NotificationCard({required this.item});

  @override
  Widget build(BuildContext context) {
    final hasImage = item.imageUrl.isNotEmpty;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: item.isRead
            ? const Color(0xFF12121A).withValues(alpha: 0.7)
            : const Color(0xFF18141C).withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: item.isRead
              ? Colors.white.withValues(alpha: 0.06)
              : AppColors.primary.withValues(alpha: 0.35),
          width: item.isRead ? 0.8 : 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.35),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
          if (!item.isRead)
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.12),
              blurRadius: 16,
              spreadRadius: 1,
            ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    if (!item.isRead) ...[
                      Container(
                        width: 7,
                        height: 7,
                        margin: const EdgeInsets.only(right: 7),
                        decoration: const BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ],
                    Expanded(
                      child: Text(
                        item.title,
                        style: AppTextStyles.text16SemiBold.copyWith(
                          color: Colors.white,
                          letterSpacing: 0.1,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                Text(
                  item.body,
                  style: AppTextStyles.text13Medium.copyWith(
                    color: const Color(0xFFB0B0C0),
                    height: 1.35,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  item.timeAgo.isNotEmpty ? item.timeAgo : item.createdAt,
                  style: AppTextStyles.text11Medium.copyWith(
                    color: const Color(0xFF6E6E82),
                  ),
                ),
              ],
            ),
          ),
          if (hasImage) ...[
            const SizedBox(width: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                item.imageUrl,
                width: 60,
                height: 82,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  width: 60,
                  height: 82,
                  color: const Color(0xFF22222E),
                  child: const Center(
                    child: FaIcon(
                      FontAwesomeIcons.film,
                      color: Color(0xFF5A5A6E),
                      size: 18,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
