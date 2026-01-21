import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../presentation/controllers/auth_controller.dart';
import '../../presentation/controllers/project_controller.dart';
import '../../presentation/controllers/task_controller.dart';
import '../../data/repositories/auth_repository.dart';
import '../../core/services/database_service.dart';
import '../../core/services/sample_data_service.dart';
import 'project_view.dart';
import 'manager_view.dart';

class SuperAdminPage extends StatefulWidget {
  const SuperAdminPage({super.key});

  @override
  State<SuperAdminPage> createState() => _SuperAdminPageState();
}

class _SuperAdminPageState extends State<SuperAdminPage> {
  final AuthController authController = Get.find<AuthController>();
  final ProjectController projectController = Get.find<ProjectController>();
  final TaskController taskController = Get.find<TaskController>();
  final AuthRepository authRepository = Get.find<AuthRepository>();
  final DatabaseService databaseService = Get.find<DatabaseService>();

  // App Theme Colors - Consistent with the rest of the app
  static const Color primaryBlue = Color(0xFF6366F1);
  static const Color successGreen = Color(0xFF10B981);
  static const Color warningOrange = Color(0xFFF59E0B);
  static const Color errorRed = Color(0xFFEF4444);
  static const Color lightBlue = Color(0xFF3B82F6);
  static const Color purple = Color(0xFF8B5CF6);
  static const Color lightGray = Color(0xFFF8F9FA);

  final RxList<Map<String, dynamic>> allUsers = <Map<String, dynamic>>[].obs;
  final RxMap<String, int> projectStats = <String, int>{}.obs;

  @override
  void initState() {
    super.initState();
    _loadDashboardData();
  }

  Future<void> _loadDashboardData() async {
    await Future.wait([
      projectController.loadProjects(),
      _loadAllUsers(),
      _calculateProjectStats(),
    ]);
  }

  Future<void> _loadAllUsers() async {
    try {
      // Get all users from database
      final users = await databaseService.query('users');
      allUsers.value = users;
    } catch (e) {
      print('Error loading users: $e');
    }
  }

  Future<void> _calculateProjectStats() async {
    final projects = projectController.projects;
    
    projectStats.value = {
      'total': projects.length,
      'active': projects.where((p) => p.status == 'active').length,
      'completed': projects.where((p) => p.status == 'completed').length,
      'paused': projects.where((p) => p.status == 'paused').length,
      'cancelled': projects.where((p) => p.status == 'cancelled').length,
    };
  }

  Future<void> _resetDatabase() async {
    // Show confirmation dialog
    final confirmed = await Get.dialog<bool>(
      AlertDialog(
        title: const Text('إعادة تعيين قاعدة البيانات'),
        content: const Text(
          'هل أنت متأكد من إعادة تعيين قاعدة البيانات؟\n'
          'سيتم حذف جميع البيانات الحالية وإنشاء بيانات تجريبية جديدة.\n\n'
          'المستخدمون الجدد:\n'
          '• مدير النظام: superadmin@enjaz.com\n'
          '• المدير: admin@enjaz.com\n'
          '• المستخدم 1: user1@enjaz.com\n'
          '• المستخدم 2: user2@enjaz.com\n\n'
          'كلمة المرور لجميع الحسابات: 123456'
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () => Get.back(result: true),
            style: ElevatedButton.styleFrom(
              backgroundColor: errorRed,
              foregroundColor: Colors.white,
            ),
            child: const Text('إعادة تعيين'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        // Show loading
        Get.dialog(
          const Center(
            child: CircularProgressIndicator(),
          ),
          barrierDismissible: false,
        );

        // Reset database
        await SampleDataService.resetAndInitializeData();
        
        // Debug: Check what users are in the database
        final users = await databaseService.query('users');
        print('DEBUG: Users in database after reset:');
        for (final user in users) {
          print('  - ${user['email']}: ${user['role']} (${user['name']})');
        }
        
        // Close loading dialog
        Get.back();
        
        // Show success message
        Get.snackbar(
          'نجح',
          'تم إعادة تعيين قاعدة البيانات بنجاح',
          backgroundColor: successGreen,
          colorText: Colors.white,
        );

        // Reload data
        await _loadDashboardData();
        
      } catch (e) {
        // Close loading dialog
        Get.back();
        
        Get.snackbar(
          'خطأ',
          'فشل في إعادة تعيين قاعدة البيانات: $e',
          backgroundColor: errorRed,
          colorText: Colors.white,
        );
      }
    }
  }

  Future<void> _updateProjectStatus(String projectId, String newStatus) async {
    try {
      await databaseService.update(
        'projects',
        {
          'status': newStatus,
          'updated_at': DateTime.now().toIso8601String(),
        },
        where: 'id = ?',
        whereArgs: [projectId],
      );
      
      // Reload data
      await _loadDashboardData();
      
      Get.snackbar(
        'نجح',
        'تم تحديث حالة المشروع بنجاح',
        backgroundColor: successGreen,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        'خطأ',
        'فشل في تحديث حالة المشروع',
        backgroundColor: errorRed,
        colorText: Colors.white,
      );
    }
  }

  Widget _buildFilterButton(String label, bool isActive) {
    return Container(
      margin: const EdgeInsets.only(left: 8),
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: isActive ? primaryBlue : lightGray,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: isActive ? Colors.white : Colors.black87,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Expanded(
      child: Container(
        height: 140,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: Colors.white),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text("لوحة التحكم المسؤول", style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: primaryBlue,
        foregroundColor: Colors.white,
        centerTitle: true,
        leading: IconButton(
          onPressed: () {},
          icon: const Icon(Icons.person, color: Colors.white, size: 30),
        ),
        actions: [
          IconButton(
            onPressed: _resetDatabase,
            icon: const Icon(Icons.refresh, color: Colors.white),
            tooltip: 'إعادة تعيين قاعدة البيانات',
          ),
          Container(
            margin: const EdgeInsets.only(right: 8),
            decoration: BoxDecoration(
              color: warningOrange,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  onPressed: () => authController.logout(),
                  icon: const Icon(Icons.exit_to_app, color: Colors.white),
                ),
                const Padding(
                  padding: EdgeInsets.only(right: 8),
                  child: Text("تسجيل خروج", style: TextStyle(fontSize: 10, color: Colors.white)),
                ),
              ],
            ),
          )
        ],
      ),
      body: Obx(() {
        final currentUser = authController.currentUser.value;
        final projects = projectController.projects;
        final stats = projectStats;

        return RefreshIndicator(
          onRefresh: _loadDashboardData,
          child: ListView(
            children: [
              // Welcome Section
              if (currentUser != null)
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 30,
                            backgroundColor: primaryBlue,
                            child: Text(
                              currentUser.name.substring(0, 1).toUpperCase(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'مرحباً ${currentUser.name}',
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  currentUser.role == 'super_admin' ? 'مدير النظام' : currentUser.position ?? 'مدير',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[600],
                                  ),
                                ),
                                Text(
                                  currentUser.email,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[500],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

              // Stats Cards Section
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        _buildStatCard(
                          "قيد المراجعة",
                          "${stats['paused'] ?? 0}",
                          Icons.timelapse,
                          warningOrange,
                        ),
                        const SizedBox(width: 10),
                        _buildStatCard(
                          "نشطة",
                          "${stats['active'] ?? 0}",
                          Icons.check_circle,
                          successGreen,
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        _buildStatCard(
                          "قيد التنفيذ",
                          "${stats['active'] ?? 0}",
                          Icons.settings_outlined,
                          lightBlue,
                        ),
                        const SizedBox(width: 10),
                        _buildStatCard(
                          "مكتملة",
                          "${stats['completed'] ?? 0}",
                          Icons.emoji_events,
                          purple,
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Projects Section
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          children: [
                            Icon(Icons.sticky_note_2_outlined, size: 24, color: primaryBlue),
                            const SizedBox(width: 10),
                            const Text(
                              "المشاريع الحديثة",
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            const Spacer(),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(builder: (context) => ProjectListScreen()),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: primaryBlue,
                                foregroundColor: Colors.white,
                              ),
                              child: const Text('عرض الكل'),
                            ),
                          ],
                        ),
                      ),
                      if (projects.isEmpty)
                        const Padding(
                          padding: EdgeInsets.all(32.0),
                          child: Text(
                            'لا توجد مشاريع حالياً',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                            ),
                          ),
                        )
                      else
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: projects.length > 5 ? 5 : projects.length,
                          itemBuilder: (context, index) {
                            final project = projects[index];
                            return Card(
                              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              child: ListTile(
                                leading: CircleAvatar(
                                  backgroundColor: _getStatusColor(project.status),
                                  child: Icon(
                                    _getStatusIcon(project.status),
                                    color: Colors.white,
                                  ),
                                ),
                                title: Text(
                                  project.name,
                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(project.description ?? 'لا يوجد وصف'),
                                    const SizedBox(height: 5),
                                    Text(
                                      "التاريخ: ${_formatDate(project.createdAt)}",
                                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                                    ),
                                    const SizedBox(height: 8),
                                    LinearProgressIndicator(
                                      value: project.progress / 100,
                                      backgroundColor: Colors.grey[300],
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        _getStatusColor(project.status),
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    Row(
                                      children: [
                                        ElevatedButton(
                                          onPressed: () => _updateProjectStatus(project.id, 'active'),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: successGreen,
                                            foregroundColor: Colors.white,
                                            minimumSize: const Size(60, 30),
                                          ),
                                          child: const Text("قبول", style: TextStyle(fontSize: 12)),
                                        ),
                                        const SizedBox(width: 8),
                                        ElevatedButton(
                                          onPressed: () => _updateProjectStatus(project.id, 'cancelled'),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: errorRed,
                                            foregroundColor: Colors.white,
                                            minimumSize: const Size(60, 30),
                                          ),
                                          child: const Text("رفض", style: TextStyle(fontSize: 12)),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                                trailing: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: _getStatusColor(project.status).withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    _getStatusText(project.status),
                                    style: TextStyle(
                                      color: _getStatusColor(project.status),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                    ],
                  ),
                ),
              ),

              // Users Management Section
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          children: [
                            Icon(Icons.group, color: purple, size: 24),
                            const SizedBox(width: 10),
                            const Text(
                              "إدارة المستخدمين",
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            const Spacer(),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(builder: (context) => SupervisorScreen()),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: primaryBlue,
                                foregroundColor: Colors.white,
                              ),
                              child: const Text("عرض الكل"),
                            ),
                          ],
                        ),
                      ),
                      if (allUsers.isEmpty)
                        const Padding(
                          padding: EdgeInsets.all(32.0),
                          child: Text(
                            'لا توجد مستخدمين حالياً',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                            ),
                          ),
                        )
                      else
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: allUsers.length > 3 ? 3 : allUsers.length,
                          itemBuilder: (context, index) {
                            final user = allUsers[index];
                            return Card(
                              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                              child: ListTile(
                                leading: CircleAvatar(
                                  backgroundColor: _getRoleColor(user['role']).withOpacity(0.1),
                                  child: Icon(
                                    _getRoleIcon(user['role']),
                                    color: _getRoleColor(user['role']),
                                  ),
                                ),
                                title: Text(
                                  user['name'] ?? 'غير محدد',
                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(user['email'] ?? ''),
                                    Text(
                                      user['department'] ?? 'لا يوجد قسم',
                                      style: const TextStyle(fontSize: 12),
                                    ),
                                  ],
                                ),
                                trailing: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: _getRoleColor(user['role']).withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    _getRoleText(user['role']),
                                    style: TextStyle(
                                      color: _getRoleColor(user['role']),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        );
      }),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'active':
        return successGreen;
      case 'completed':
        return purple;
      case 'paused':
        return warningOrange;
      case 'cancelled':
        return errorRed;
      default:
        return lightBlue;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status) {
      case 'active':
        return Icons.play_arrow;
      case 'completed':
        return Icons.check_circle;
      case 'paused':
        return Icons.pause;
      case 'cancelled':
        return Icons.cancel;
      default:
        return Icons.folder;
    }
  }

  String _getStatusText(String status) {
    switch (status) {
      case 'active':
        return 'نشط';
      case 'completed':
        return 'مكتمل';
      case 'paused':
        return 'متوقف';
      case 'cancelled':
        return 'ملغي';
      default:
        return 'غير محدد';
    }
  }

  Color _getRoleColor(String role) {
    switch (role) {
      case 'super_admin':
        return errorRed;
      case 'admin':
        return warningOrange;
      case 'user':
        return lightBlue;
      default:
        return Colors.grey;
    }
  }

  IconData _getRoleIcon(String role) {
    switch (role) {
      case 'super_admin':
        return Icons.admin_panel_settings;
      case 'admin':
        return Icons.manage_accounts;
      case 'user':
        return Icons.person;
      default:
        return Icons.help;
    }
  }

  String _getRoleText(String role) {
    switch (role) {
      case 'super_admin':
        return 'مدير النظام';
      case 'admin':
        return 'مدير';
      case 'user':
        return 'مستخدم';
      default:
        return 'غير محدد';
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}