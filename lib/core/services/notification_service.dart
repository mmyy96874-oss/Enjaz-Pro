import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'database_service.dart';
import 'package:uuid/uuid.dart';

class NotificationService extends GetxService {
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  final DatabaseService _databaseService = DatabaseService();
  final Uuid _uuid = const Uuid();

  @override
  Future<void> onInit() async {
    super.onInit();
    tz.initializeTimeZones();
    await _initializeNotifications();
  }

  Future<void> _initializeNotifications() async {
    // Android initialization
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    // iOS initialization
    const DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    await _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );

    // Request permissions for iOS
    await _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
  }

  void _onNotificationTapped(NotificationResponse notificationResponse) {
    final payload = notificationResponse.payload;
    if (payload != null) {
      // Handle notification tap
      // You can navigate to specific screens based on payload
      print('Notification tapped with payload: $payload');
    }
  }

  // Show local notification
  Future<void> showNotification({
    required String title,
    required String body,
    String? payload,
    int? id,
  }) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'enjaz_pro_channel',
      'Enjaz Pro Notifications',
      channelDescription: 'Notifications for Enjaz Pro app',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: false,
    );

    const DarwinNotificationDetails iOSPlatformChannelSpecifics =
        DarwinNotificationDetails();

    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics,
    );

    await _flutterLocalNotificationsPlugin.show(
      id ?? DateTime.now().millisecondsSinceEpoch.remainder(100000),
      title,
      body,
      platformChannelSpecifics,
      payload: payload,
    );
  }

  // Schedule notification
  Future<void> scheduleNotification({
    required String title,
    required String body,
    required DateTime scheduledDate,
    String? payload,
    int? id,
  }) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'enjaz_pro_scheduled',
      'Enjaz Pro Scheduled',
      channelDescription: 'Scheduled notifications for Enjaz Pro app',
      importance: Importance.max,
      priority: Priority.high,
    );

    const DarwinNotificationDetails iOSPlatformChannelSpecifics =
        DarwinNotificationDetails();

    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics,
    );

    await _flutterLocalNotificationsPlugin.zonedSchedule(
      id ?? DateTime.now().millisecondsSinceEpoch.remainder(100000),
      title,
      body,
      tz.TZDateTime.from(scheduledDate, tz.local),
      platformChannelSpecifics,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      payload: payload,
    );
  }

  // Save notification to database
  Future<void> saveNotification({
    required String title,
    required String message,
    required String type,
    required String userId,
    Map<String, dynamic>? data,
  }) async {
    final notificationData = {
      'id': _uuid.v4(),
      'title': title,
      'message': message,
      'type': type,
      'user_id': userId,
      'is_read': 0,
      'data': data != null ? data.toString() : null,
      'created_at': DateTime.now().toIso8601String(),
    };

    await _databaseService.insert('notifications', notificationData);
  }

  // Get user notifications
  Future<List<Map<String, dynamic>>> getUserNotifications(String userId) async {
    return await _databaseService.query(
      'notifications',
      where: 'user_id = ?',
      whereArgs: [userId],
      orderBy: 'created_at DESC',
    );
  }

  // Mark notification as read
  Future<void> markAsRead(String notificationId) async {
    await _databaseService.update(
      'notifications',
      {'is_read': 1},
      where: 'id = ?',
      whereArgs: [notificationId],
    );
  }

  // Mark all notifications as read for user
  Future<void> markAllAsRead(String userId) async {
    await _databaseService.update(
      'notifications',
      {'is_read': 1},
      where: 'user_id = ? AND is_read = 0',
      whereArgs: [userId],
    );
  }

  // Get unread notification count
  Future<int> getUnreadCount(String userId) async {
    final result = await _databaseService.query(
      'notifications',
      where: 'user_id = ? AND is_read = 0',
      whereArgs: [userId],
    );
    return result.length;
  }

  // Delete notification
  Future<void> deleteNotification(String notificationId) async {
    await _databaseService.delete(
      'notifications',
      where: 'id = ?',
      whereArgs: [notificationId],
    );
  }

  // Clear all notifications for user
  Future<void> clearAllNotifications(String userId) async {
    await _databaseService.delete(
      'notifications',
      where: 'user_id = ?',
      whereArgs: [userId],
    );
  }

  // Notification types
  static const String taskAssigned = 'task_assigned';
  static const String taskDue = 'task_due';
  static const String taskCompleted = 'task_completed';
  static const String projectUpdate = 'project_update';
  static const String meetingReminder = 'meeting_reminder';
  static const String systemUpdate = 'system_update';

  // Send task assignment notification
  Future<void> notifyTaskAssigned({
    required String userId,
    required String taskTitle,
    required String projectName,
    required String assignedBy,
  }) async {
    const title = 'New Task Assigned';
    final message = 'You have been assigned to "$taskTitle" in $projectName by $assignedBy';
    
    await saveNotification(
      title: title,
      message: message,
      type: taskAssigned,
      userId: userId,
      data: {
        'task_title': taskTitle,
        'project_name': projectName,
        'assigned_by': assignedBy,
      },
    );

    await showNotification(
      title: title,
      body: message,
      payload: 'task_assigned',
    );
  }

  // Send task due notification
  Future<void> notifyTaskDue({
    required String userId,
    required String taskTitle,
    required DateTime dueDate,
  }) async {
    const title = 'Task Due Soon';
    final message = 'Task "$taskTitle" is due soon';
    
    await saveNotification(
      title: title,
      message: message,
      type: taskDue,
      userId: userId,
      data: {
        'task_title': taskTitle,
        'due_date': dueDate.toIso8601String(),
      },
    );

    await showNotification(
      title: title,
      body: message,
      payload: 'task_due',
    );
  }

  // Send project update notification
  Future<void> notifyProjectUpdate({
    required String userId,
    required String projectName,
    required String updateType,
    required String message,
  }) async {
    final title = 'Project Update: $projectName';
    
    await saveNotification(
      title: title,
      message: message,
      type: projectUpdate,
      userId: userId,
      data: {
        'project_name': projectName,
        'update_type': updateType,
      },
    );

    await showNotification(
      title: title,
      body: message,
      payload: 'project_update',
    );
  }

  // Cancel all notifications
  Future<void> cancelAllNotifications() async {
    await _flutterLocalNotificationsPlugin.cancelAll();
  }

  // Cancel specific notification
  Future<void> cancelNotification(int id) async {
    await _flutterLocalNotificationsPlugin.cancel(id);
  }
}