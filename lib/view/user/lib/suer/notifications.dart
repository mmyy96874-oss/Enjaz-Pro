import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../theme/app_theme.dart';
import '../../../../presentation/controllers/auth_controller.dart';
import '../../../../core/services/database_service.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  final AuthController authController = Get.find<AuthController>();
  final DatabaseService databaseService = Get.find<DatabaseService>();
  
  final RxList<Map<String, dynamic>> notifications = <Map<String, dynamic>>[].obs;
  final RxBool isLoading = false.obs;

  @override
  void initState() {
    super.initState();
    _loadNotifications();
  }

  Future<void> _loadNotifications() async {
    final currentUser = authController.currentUser.value;
    if (currentUser == null) return;

    try {
      isLoading.value = true;
      
      final notificationsList = await databaseService.query(
        'notifications',
        where: 'user_id = ?',
        whereArgs: [currentUser.id],
        orderBy: 'created_at DESC',
      );
      
      notifications.value = notificationsList;
    } catch (e) {
      print('Error loading notifications: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _markAsRead(String notificationId) async {
    try {
      await databaseService.update(
        'notifications',
        {'is_read': 1},
        where: 'id = ?',
        whereArgs: [notificationId],
      );
      
      // Update local list
      final index = notifications.indexWhere((n) => n['id'] == notificationId);
      if (index != -1) {
        notifications[index]['is_read'] = 1;
        notifications.refresh();
      }
    } catch (e) {
      print('Error marking notification as read: $e');
    }
  }

  Future<void> _markAllAsRead() async {
    final currentUser = authController.currentUser.value;
    if (currentUser == null) return;

    try {
      await databaseService.update(
        'notifications',
        {'is_read': 1},
        where: 'user_id = ? AND is_read = ?',
        whereArgs: [currentUser.id, 0],
      );
      
      // Update local list
      for (var notification in notifications) {
        notification['is_read'] = 1;
      }
      notifications.refresh();
      
      Get.snackbar('نجح', 'تم تحديد جميع الإشعارات كمقروءة');
    } catch (e) {
      Get.snackbar('خطأ', 'فشل في تحديث الإشعارات');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('الإشعارات'),
        actions: [
          Obx(() {
            final unreadCount = notifications.where((n) => n['is_read'] == 0).length;
            if (unreadCount > 0) {
              return TextButton(
                onPressed: _markAllAsRead,
                child: const Text(
                  'تحديد الكل كمقروء',
                  style: TextStyle(color: Colors.white),
                ),
              );
            }
            return const SizedBox.shrink();
          }),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadNotifications,
          ),
        ],
      ),
      body: Obx(() {
        if (isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (notifications.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.notifications_none, size: 80, color: Colors.grey),
                SizedBox(height: 16),
                Text(
                  'لا توجد إشعارات',
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
                SizedBox(height: 8),
                Text(
                  'ستظهر الإشعارات هنا عند وصولها',
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: _loadNotifications,
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: notifications.length,
            itemBuilder: (context, index) {
              final notification = notifications[index];
              return _buildNotificationItem(notification);
            },
          ),
        );
      }),
    );
  }

  Widget _buildNotificationItem(Map<String, dynamic> notification) {
    final isRead = notification['is_read'] == 1;
    final type = notification['type'] ?? 'general';
    final createdAt = DateTime.parse(notification['created_at']);
    
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      color: isRead ? null : AppTheme.primaryBlue.withOpacity(0.05),
      child: InkWell(
        onTap: () => _markAsRead(notification['id']),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: _getNotificationColor(type).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  _getNotificationIcon(type),
                  color: _getNotificationColor(type),
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            notification['title'] ?? 'إشعار',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: isRead ? FontWeight.w500 : FontWeight.bold,
                              color: AppTheme.textPrimary,
                            ),
                          ),
                        ),
                        if (!isRead)
                          Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: AppTheme.primaryBlue,
                              shape: BoxShape.circle,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      notification['message'] ?? 'لا يوجد محتوى',
                      style: TextStyle(
                        fontSize: 14,
                        color: isRead ? AppTheme.textSecondary : AppTheme.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _formatTime(createdAt),
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getNotificationIcon(String type) {
    switch (type) {
      case 'task_assigned':
        return Icons.assignment;
      case 'project_updated':
        return Icons.update;
      case 'deadline_reminder':
        return Icons.schedule;
      case 'meeting_scheduled':
        return Icons.event;
      case 'project_approved':
        return Icons.check_circle;
      case 'project_rejected':
        return Icons.cancel;
      default:
        return Icons.notifications;
    }
  }

  Color _getNotificationColor(String type) {
    switch (type) {
      case 'task_assigned':
        return AppTheme.lightBlue;
      case 'project_updated':
        return AppTheme.primaryBlue;
      case 'deadline_reminder':
        return AppTheme.alertOrange;
      case 'meeting_scheduled':
        return Colors.purple;
      case 'project_approved':
        return AppTheme.successGreen;
      case 'project_rejected':
        return Colors.red;
      default:
        return AppTheme.primaryBlue;
    }
  }

  String _formatTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 1) {
      return 'الآن';
    } else if (difference.inMinutes < 60) {
      return 'منذ ${difference.inMinutes} دقيقة';
    } else if (difference.inHours < 24) {
      return 'منذ ${difference.inHours} ساعة';
    } else if (difference.inDays < 7) {
      return 'منذ ${difference.inDays} يوم';
    } else {
      return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
    }
  }
}
