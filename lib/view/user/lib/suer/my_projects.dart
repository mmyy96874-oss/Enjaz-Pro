import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../theme/app_theme.dart';
import '../widgets/project_card.dart';
import '../../../../presentation/controllers/project_controller.dart';
import '../../../../presentation/controllers/auth_controller.dart';
import 'project_details.dart';
import 'stopped_projects.dart';

class MyProjectsScreen extends StatefulWidget {
  const MyProjectsScreen({super.key});

  @override
  State<MyProjectsScreen> createState() => _MyProjectsScreenState();
}

class _MyProjectsScreenState extends State<MyProjectsScreen> {
  final ProjectController projectController = Get.find<ProjectController>();
  final AuthController authController = Get.find<AuthController>();

  @override
  void initState() {
    super.initState();
    _loadProjects();
  }

  Future<void> _loadProjects() async {
    await projectController.loadUserProjects();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('مشاريعي'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadProjects,
            tooltip: 'تحديث',
          ),
        ],
      ),
      body: Obx(() {
        final userProjects = projectController.userProjects;
        final isLoading = projectController.isLoading.value;

        if (isLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        return RefreshIndicator(
          onRefresh: _loadProjects,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              const Text(
                'مشاريعي',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textPrimary,
                ),
              ),
              const SizedBox(height: 24),
              
              if (userProjects.isEmpty) ...[
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 100),
                      Icon(
                        Icons.folder_open,
                        size: 80,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'لا توجد مشاريع حالياً',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'ابدأ بإنشاء مشروعك الأول',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[500],
                        ),
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton.icon(
                        onPressed: () {
                          Navigator.pushNamed(context, '/user/new-project');
                        },
                        icon: const Icon(Icons.add),
                        label: const Text('إنشاء مشروع جديد'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primaryBlue,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ] else ...[
                // Active Projects
                ...userProjects.where((project) => project.status != 'paused').map((project) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: ProjectCard(
                      title: project.name,
                      status: _getStatusText(project.status),
                      statusColor: _getStatusColor(project.status),
                      statusGradient: _getStatusGradient(project.status),
                      description: project.description ?? 'لا يوجد وصف',
                      currentPhase: 'التقدم: ${project.progress.toInt()}%',
                      progress: project.progress / 100,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProjectDetailsScreen(
                              projectTitle: project.name,
                              status: _getStatusText(project.status),
                              progress: project.progress.toInt(),
                              commitment: _getCommitmentLevel(project.progress),
                              project: project,
                            ),
                          ),
                        );
                      },
                    ),
                  );
                }),
                
                const SizedBox(height: 24),
                
                // Paused Projects Link
                Card(
                  color: AppTheme.stoppedStart.withOpacity(0.1),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const StoppedProjectsScreen(),
                        ),
                      );
                    },
                    borderRadius: BorderRadius.circular(12),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Row(
                            children: [
                              Icon(
                                Icons.pause_circle_outline,
                                color: AppTheme.stoppedStart,
                                size: 24,
                              ),
                              SizedBox(width: 12),
                              Text(
                                'المشاريع المتوقفة',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: AppTheme.textPrimary,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: AppTheme.stoppedStart,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  userProjects.where((p) => p.status == 'paused').length.toString(),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              const Icon(
                                Icons.arrow_back_ios,
                                size: 16,
                                color: AppTheme.stoppedStart,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        );
      }),
    );
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

  Color _getStatusColor(String status) {
    switch (status) {
      case 'active':
        return AppTheme.primaryBlue;
      case 'completed':
        return AppTheme.successGreen;
      case 'paused':
        return AppTheme.alertOrange;
      case 'cancelled':
        return AppTheme.warningRed;
      default:
        return Colors.grey;
    }
  }

  List<Color> _getStatusGradient(String status) {
    switch (status) {
      case 'active':
        return [AppTheme.primaryBlue, AppTheme.lightBlue];
      case 'completed':
        return [AppTheme.acceptedStart, AppTheme.acceptedEnd];
      case 'paused':
        return [AppTheme.stoppedStart, AppTheme.stoppedEnd];
      case 'cancelled':
        return [AppTheme.rejectedStart, AppTheme.rejectedEnd];
      default:
        return [Colors.grey, Colors.grey[400]!];
    }
  }

  String _getCommitmentLevel(double progress) {
    if (progress >= 90) return 'ممتاز';
    if (progress >= 70) return 'جيد جداً';
    if (progress >= 50) return 'جيد';
    if (progress >= 30) return 'مقبول';
    return 'ضعيف';
  }
}
