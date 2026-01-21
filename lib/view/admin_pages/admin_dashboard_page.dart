import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../presentation/controllers/auth_controller.dart';
import '../../presentation/controllers/project_controller.dart';
import '../../presentation/controllers/task_controller.dart';
import 'widgets/dashboard_header.dart';
import 'widgets/stats_cards.dart';
import 'widgets/projects_section.dart';
import 'widgets/meetings_section.dart';
import 'widgets/notifications_section.dart';

class AdminDashboardPage extends StatefulWidget {
  const AdminDashboardPage({super.key});

  @override
  State<AdminDashboardPage> createState() => _AdminDashboardPageState();
}

class _AdminDashboardPageState extends State<AdminDashboardPage> {
  final AuthController authController = Get.find<AuthController>();
  final ProjectController projectController = Get.find<ProjectController>();
  final TaskController taskController = Get.find<TaskController>();
  
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadDashboardData();
  }

  Future<void> _loadDashboardData() async {
    await Future.wait([
      projectController.loadProjects(),
      taskController.loadUserTasks(),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        body: IndexedStack(
          index: _selectedIndex,
          children: [
            DashboardHome(onRefresh: _loadDashboardData),
            ProjectsPage(projectController: projectController),
            const MeetingsPage(),
            TasksPage(taskController: taskController),
            const NotificationsPage(),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: (index) {
            setState(() => _selectedIndex = index);
            // Show which tab was selected
            final tabNames = ['الرئيسية', 'المشاريع', 'الاجتماعات', 'المهام', 'الإشعارات'];
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('تم الانتقال إلى: ${tabNames[index]}'),
                duration: const Duration(milliseconds: 800),
              ),
            );
          },
          type: BottomNavigationBarType.fixed,
          selectedItemColor: const Color(0xFF6366F1), // Purple-blue from image
          unselectedItemColor: Colors.grey[600],
          backgroundColor: Colors.white,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.dashboard),
              label: 'الرئيسية',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.folder_outlined),
              label: 'المشاريع',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.calendar_today),
              label: 'الاجتماعات',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.task_alt),
              label: 'المهام',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.notifications),
              label: 'الإشعارات',
            ),
          ],
        ),
      ),
    );
  }
}

class DashboardHome extends StatelessWidget {
  final VoidCallback onRefresh;
  
  const DashboardHome({super.key, required this.onRefresh});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async => onRefresh(),
        child: CustomScrollView(
          slivers: [
            // Header as a sliver
            const SliverToBoxAdapter(
              child: DashboardHeader(),
            ),
            // Content with proper spacing
            SliverPadding(
              padding: const EdgeInsets.only(top: 12, bottom: 20),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  const StatsCards(),
                  const SizedBox(height: 16),
                  const ProjectsSection(),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Real Projects page with data
class ProjectsPage extends StatelessWidget {
  final ProjectController projectController;
  
  const ProjectsPage({super.key, required this.projectController});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('المشاريع'),
        backgroundColor: const Color(0xFF6366F1),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => projectController.loadProjects(),
          ),
        ],
      ),
      body: Obx(() {
        final projects = projectController.projects;
        final isLoading = projectController.isLoading.value;

        if (isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (projects.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.folder_open, size: 80, color: Colors.grey),
                SizedBox(height: 16),
                Text(
                  'لا توجد مشاريع حالياً',
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () => projectController.loadProjects(),
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: projects.length,
            itemBuilder: (context, index) {
              final project = projects[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
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
                      const SizedBox(height: 8),
                      LinearProgressIndicator(
                        value: project.progress / 100,
                        backgroundColor: Colors.grey[300],
                        valueColor: AlwaysStoppedAnimation<Color>(
                          _getStatusColor(project.status),
                        ),
                      ),
                    ],
                  ),
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '${project.progress.toInt()}%',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: _getStatusColor(project.status),
                        ),
                      ),
                      Text(
                        _getStatusText(project.status),
                        style: const TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      }),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'active':
        return Colors.blue;
      case 'completed':
        return Colors.green;
      case 'paused':
        return Colors.orange;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.grey;
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
}

class MeetingsPage extends StatelessWidget {
  const MeetingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const MeetingsSection();
  }
}

class TasksPage extends StatelessWidget {
  final TaskController taskController;
  
  const TasksPage({super.key, required this.taskController});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('المهام'),
        backgroundColor: const Color(0xFF6366F1),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => taskController.loadUserTasks(),
          ),
        ],
      ),
      body: Obx(() {
        final tasks = taskController.userTasks;
        final isLoading = taskController.isLoading.value;

        if (isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (tasks.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.task_alt, size: 80, color: Colors.grey),
                SizedBox(height: 16),
                Text(
                  'لا توجد مهام حالياً',
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () => taskController.loadUserTasks(),
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: tasks.length,
            itemBuilder: (context, index) {
              final task = tasks[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: _getTaskStatusColor(task.status),
                    child: Icon(
                      _getTaskStatusIcon(task.status),
                      color: Colors.white,
                    ),
                  ),
                  title: Text(
                    task.title,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(task.description ?? 'لا يوجد وصف'),
                      const SizedBox(height: 4),
                      if (task.dueDate != null)
                        Text(
                          'موعد التسليم: ${_formatDate(task.dueDate!)}',
                          style: TextStyle(
                            color: task.dueDate!.isBefore(DateTime.now()) 
                              ? Colors.red 
                              : Colors.grey[600],
                            fontSize: 12,
                          ),
                        ),
                    ],
                  ),
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '${task.progress.toInt()}%',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: _getTaskStatusColor(task.status),
                        ),
                      ),
                      Text(
                        _getTaskStatusText(task.status),
                        style: const TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      }),
    );
  }

  Color _getTaskStatusColor(String status) {
    switch (status) {
      case 'todo':
        return Colors.grey;
      case 'in_progress':
        return Colors.orange;
      case 'completed':
        return Colors.green;
      case 'blocked':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  IconData _getTaskStatusIcon(String status) {
    switch (status) {
      case 'todo':
        return Icons.radio_button_unchecked;
      case 'in_progress':
        return Icons.pending;
      case 'completed':
        return Icons.check_circle;
      case 'blocked':
        return Icons.block;
      default:
        return Icons.help;
    }
  }

  String _getTaskStatusText(String status) {
    switch (status) {
      case 'todo':
        return 'قيد الانتظار';
      case 'in_progress':
        return 'قيد التنفيذ';
      case 'completed':
        return 'مكتملة';
      case 'blocked':
        return 'محجوبة';
      default:
        return 'غير محدد';
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const NotificationsSection();
  }
}