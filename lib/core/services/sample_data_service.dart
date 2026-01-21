import 'package:uuid/uuid.dart';
import 'database_service.dart';
import 'storage_service.dart';

class SampleDataService {
  static final DatabaseService _db = DatabaseService();
  static final Uuid _uuid = const Uuid();

  static Future<void> initializeSampleData() async {
    // Always clear and reinitialize for testing
    await _clearAllData();
    
    final now = DateTime.now();

    // Create sample users
    await _createSampleUsers(now);
    await _createSampleProjects(now);
    await _createSampleTasks(now);
    await _createSampleNotifications(now);
  }

  // Method to reset and reinitialize all data
  static Future<void> resetAndInitializeData() async {
    // Clear all existing data
    await _clearAllData();
    
    final now = DateTime.now();

    // Create fresh sample data
    await _createSampleUsers(now);
    await _createSampleProjects(now);
    await _createSampleTasks(now);
    await _createSampleNotifications(now);
  }

  static Future<void> _clearAllData() async {
    final tables = ['users', 'projects', 'tasks', 'project_members', 'comments', 'files', 'notifications', 'time_entries'];
    
    for (final table in tables) {
      // Delete all records from each table
      await _db.delete(table);
    }
    
    // Also clear any cached user data
    try {
      final storageService = StorageService();
      await storageService.removeUserData();
      await storageService.removeToken();
    } catch (e) {
      print('Error clearing cached data: $e');
    }
  }

  static Future<void> _createSampleUsers(DateTime now) async {
    final users = [
      // Super Admin Account
      {
        'id': 'super_admin_1',
        'email': 'superadmin@enjaz.com',
        'password': '123456',
        'name': 'مدير النظام الرئيسي',
        'role': 'super_admin',
        'phone': '+966501234567',
        'department': 'إدارة النظام',
        'position': 'مدير عام النظام',
        'is_active': 1,
        'created_at': now.toIso8601String(),
        'updated_at': now.toIso8601String(),
      },
      // Admin Account
      {
        'id': 'admin_1',
        'email': 'admin@enjaz.com',
        'password': '123456',
        'name': 'أحمد محمد الإداري',
        'role': 'admin',
        'phone': '+966501234568',
        'department': 'إدارة المشاريع',
        'position': 'مدير مشاريع',
        'is_active': 1,
        'created_at': now.toIso8601String(),
        'updated_at': now.toIso8601String(),
      },
      // Regular User 1
      {
        'id': 'user_1',
        'email': 'user1@enjaz.com',
        'password': '123456',
        'name': 'سارة أحمد',
        'role': 'user',
        'phone': '+966501234569',
        'department': 'التطوير',
        'position': 'مطور واجهات',
        'is_active': 1,
        'created_at': now.toIso8601String(),
        'updated_at': now.toIso8601String(),
      },
      // Regular User 2
      {
        'id': 'user_2',
        'email': 'user2@enjaz.com',
        'password': '123456',
        'name': 'محمد علي',
        'role': 'user',
        'phone': '+966501234570',
        'department': 'التطوير',
        'position': 'مطور تطبيقات',
        'is_active': 1,
        'created_at': now.toIso8601String(),
        'updated_at': now.toIso8601String(),
      },
    ];

    print('DEBUG: Creating ${users.length} sample users');
    for (final user in users) {
      print('DEBUG: Creating user: ${user['email']} with role: ${user['role']}');
      await _db.insert('users', user);
    }
    print('DEBUG: Sample users created successfully');
  }

  static Future<void> _createSampleProjects(DateTime now) async {
    final projects = [
      {
        'id': 'project_1',
        'name': 'تطبيق إنجاز برو',
        'description': 'تطبيق إدارة المشاريع التعليمية',
        'status': 'active',
        'priority': 'high',
        'start_date': now.subtract(const Duration(days: 30)).toIso8601String(),
        'end_date': now.add(const Duration(days: 60)).toIso8601String(),
        'budget': 50000.0,
        'progress': 65.0,
        'manager_id': 'admin_1',
        'created_by': 'super_admin_1',
        'created_at': now.toIso8601String(),
        'updated_at': now.toIso8601String(),
      },
      {
        'id': 'project_2',
        'name': 'نظام إدارة المحتوى',
        'description': 'نظام إدارة المحتوى التعليمي',
        'status': 'active',
        'priority': 'medium',
        'start_date': now.subtract(const Duration(days: 15)).toIso8601String(),
        'end_date': now.add(const Duration(days: 45)).toIso8601String(),
        'budget': 30000.0,
        'progress': 40.0,
        'manager_id': 'admin_1',
        'created_by': 'super_admin_1',
        'created_at': now.toIso8601String(),
        'updated_at': now.toIso8601String(),
      },
      {
        'id': 'project_3',
        'name': 'منصة التعلم الإلكتروني',
        'description': 'منصة تعليمية تفاعلية',
        'status': 'completed',
        'priority': 'high',
        'start_date': now.subtract(const Duration(days: 90)).toIso8601String(),
        'end_date': now.subtract(const Duration(days: 10)).toIso8601String(),
        'budget': 75000.0,
        'progress': 100.0,
        'manager_id': 'admin_1',
        'created_by': 'super_admin_1',
        'created_at': now.toIso8601String(),
        'updated_at': now.toIso8601String(),
      },
    ];

    for (final project in projects) {
      await _db.insert('projects', project);
    }

    // Add project members
    final members = [
      {
        'id': _uuid.v4(),
        'project_id': 'project_1',
        'user_id': 'user_1',
        'role': 'developer',
        'joined_at': now.toIso8601String(),
      },
      {
        'id': _uuid.v4(),
        'project_id': 'project_1',
        'user_id': 'user_2',
        'role': 'developer',
        'joined_at': now.toIso8601String(),
      },
      {
        'id': _uuid.v4(),
        'project_id': 'project_2',
        'user_id': 'user_1',
        'role': 'developer',
        'joined_at': now.toIso8601String(),
      },
    ];

    for (final member in members) {
      await _db.insert('project_members', member);
    }
  }

  static Future<void> _createSampleTasks(DateTime now) async {
    final tasks = [
      {
        'id': 'task_1',
        'title': 'تصميم واجهة المستخدم',
        'description': 'تصميم واجهات المستخدم الرئيسية للتطبيق',
        'status': 'completed',
        'priority': 'high',
        'project_id': 'project_1',
        'assigned_to': 'user_1',
        'created_by': 'admin_1',
        'start_date': now.subtract(const Duration(days: 25)).toIso8601String(),
        'due_date': now.subtract(const Duration(days: 15)).toIso8601String(),
        'completed_at': now.subtract(const Duration(days: 16)).toIso8601String(),
        'estimated_hours': 40.0,
        'actual_hours': 38.0,
        'progress': 100.0,
        'created_at': now.toIso8601String(),
        'updated_at': now.toIso8601String(),
      },
      {
        'id': 'task_2',
        'title': 'تطوير نظام المصادقة',
        'description': 'تطوير نظام تسجيل الدخول والمصادقة',
        'status': 'in_progress',
        'priority': 'high',
        'project_id': 'project_1',
        'assigned_to': 'user_2',
        'created_by': 'admin_1',
        'start_date': now.subtract(const Duration(days: 20)).toIso8601String(),
        'due_date': now.add(const Duration(days: 5)).toIso8601String(),
        'estimated_hours': 32.0,
        'actual_hours': 28.0,
        'progress': 85.0,
        'created_at': now.toIso8601String(),
        'updated_at': now.toIso8601String(),
      },
      {
        'id': 'task_3',
        'title': 'إعداد قاعدة البيانات',
        'description': 'تصميم وإعداد قاعدة البيانات',
        'status': 'todo',
        'priority': 'medium',
        'project_id': 'project_1',
        'assigned_to': 'user_1',
        'created_by': 'admin_1',
        'start_date': now.add(const Duration(days: 2)).toIso8601String(),
        'due_date': now.add(const Duration(days: 10)).toIso8601String(),
        'estimated_hours': 24.0,
        'progress': 0.0,
        'created_at': now.toIso8601String(),
        'updated_at': now.toIso8601String(),
      },
      {
        'id': 'task_4',
        'title': 'تطوير لوحة التحكم',
        'description': 'تطوير لوحة تحكم المدير',
        'status': 'in_progress',
        'priority': 'medium',
        'project_id': 'project_2',
        'assigned_to': 'user_1',
        'created_by': 'admin_1',
        'start_date': now.subtract(const Duration(days: 10)).toIso8601String(),
        'due_date': now.add(const Duration(days: 15)).toIso8601String(),
        'estimated_hours': 48.0,
        'actual_hours': 20.0,
        'progress': 45.0,
        'created_at': now.toIso8601String(),
        'updated_at': now.toIso8601String(),
      },
    ];

    for (final task in tasks) {
      await _db.insert('tasks', task);
    }
  }

  static Future<void> _createSampleNotifications(DateTime now) async {
    final notifications = [
      {
        'id': _uuid.v4(),
        'title': 'مهمة جديدة',
        'message': 'تم تعيين مهمة جديدة لك: تصميم واجهة المستخدم',
        'type': 'task_assigned',
        'user_id': 'user_1',
        'is_read': 0,
        'data': '{"task_id": "task_1", "project_id": "project_1"}',
        'created_at': now.subtract(const Duration(hours: 2)).toIso8601String(),
      },
      {
        'id': _uuid.v4(),
        'title': 'تحديث المشروع',
        'message': 'تم تحديث حالة المشروع: تطبيق إنجاز برو',
        'type': 'project_updated',
        'user_id': 'user_1',
        'is_read': 1,
        'data': '{"project_id": "project_1"}',
        'created_at': now.subtract(const Duration(hours: 5)).toIso8601String(),
      },
      {
        'id': _uuid.v4(),
        'title': 'موعد نهائي قريب',
        'message': 'موعد تسليم المهمة خلال 3 أيام',
        'type': 'deadline_reminder',
        'user_id': 'user_2',
        'is_read': 0,
        'data': '{"task_id": "task_2"}',
        'created_at': now.subtract(const Duration(minutes: 30)).toIso8601String(),
      },
    ];

    for (final notification in notifications) {
      await _db.insert('notifications', notification);
    }
  }
}