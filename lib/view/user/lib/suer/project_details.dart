import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../theme/app_theme.dart';
import '../../../../data/models/project_model.dart';
import '../../../../presentation/controllers/task_controller.dart';
import 'planning.dart';
import 'pert_chart.dart';

class ProjectDetailsScreen extends StatefulWidget {
  final String projectTitle;
  final String status;
  final int progress;
  final String commitment;
  final ProjectModel? project;

  const ProjectDetailsScreen({
    super.key,
    required this.projectTitle,
    required this.status,
    required this.progress,
    required this.commitment,
    this.project,
  });

  @override
  State<ProjectDetailsScreen> createState() => _ProjectDetailsScreenState();
}

class _ProjectDetailsScreenState extends State<ProjectDetailsScreen> {
  final TaskController taskController = Get.find<TaskController>();

  @override
  void initState() {
    super.initState();
    if (widget.project != null) {
      _loadProjectTasks();
    }
  }

  Future<void> _loadProjectTasks() async {
    await taskController.loadTasksByProject(widget.project!.id);
  }

  @override
  Widget build(BuildContext context) {
    final bool isRejected = widget.status == 'مرفوض' || widget.status == 'ملغي';
    final bool isAccepted = widget.status == 'مقبول' || widget.status == 'نشط' || widget.status == 'مكتمل';
    final project = widget.project;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.projectTitle),
        actions: [
          if (project != null)
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: _loadProjectTasks,
              tooltip: 'تحديث',
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (isRejected) ...[
              // صفحة المشروع المرفوض
              Card(
                color: AppTheme.rejectedEnd.withOpacity(0.1),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'سبب الرفض:',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.warningRed,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        project?.description ?? 'المشروع المقدم لا يتوافق مع معايير القبول المطلوبة. يرجى الانتباه إلى أن المشروع يجب أن يحتوي على فكرة جديدة ومبتكرة، وأن الوصف المقدم شامل ويسهل فهم أهداف المشروع.',
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ] else if (isAccepted) ...[
              // صفحة المشروع المقبول
              Text(
                widget.projectTitle,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              if (project?.description != null) ...[
                Text(
                  project!.description!,
                  style: const TextStyle(
                    fontSize: 16,
                    color: AppTheme.textSecondary,
                  ),
                ),
                const SizedBox(height: 24),
              ],
              
              // نسبة الإنجاز ومستوى الالتزام
              Row(
                children: [
                  Expanded(
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'نسبة الإنجاز',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: AppTheme.textSecondary,
                                  ),
                                ),
                                Text(
                                  '${widget.progress}%',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: AppTheme.successGreen,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: LinearProgressIndicator(
                                value: widget.progress / 100,
                                minHeight: 8,
                                backgroundColor: AppTheme.lightGray,
                                valueColor: const AlwaysStoppedAnimation<Color>(
                                  AppTheme.successGreen,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          children: [
                            const Text(
                              'مستوى الالتزام',
                              style: TextStyle(
                                fontSize: 14,
                                color: AppTheme.textSecondary,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: AppTheme.successGreen.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: AppTheme.successGreen,
                                  width: 2,
                                ),
                              ),
                              child: Text(
                                widget.commitment,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: AppTheme.successGreen,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              
              // Project Tasks Section
              if (project != null) ...[
                Obx(() {
                  final projectTasks = taskController.tasks
                      .where((task) => task.projectId == project.id)
                      .toList();
                  
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'مهام المشروع:',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.textPrimary,
                            ),
                          ),
                          Text(
                            '${projectTasks.length} مهمة',
                            style: const TextStyle(
                              fontSize: 14,
                              color: AppTheme.textSecondary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      if (projectTasks.isEmpty)
                        Card(
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Center(
                              child: Column(
                                children: [
                                  Icon(
                                    Icons.task_alt,
                                    size: 48,
                                    color: Colors.grey[400],
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'لا توجد مهام حالياً',
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )
                      else
                        ...projectTasks.map((task) => Card(
                          margin: const EdgeInsets.only(bottom: 8),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: _getTaskStatusColor(task.status),
                              child: Icon(
                                _getTaskStatusIcon(task.status),
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                            title: Text(
                              task.title,
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (task.description != null)
                                  Text(task.description!),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    Text(
                                      _getTaskStatusText(task.status),
                                      style: TextStyle(
                                        color: _getTaskStatusColor(task.status),
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    const SizedBox(width: 16),
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
                              ],
                            ),
                            trailing: Text(
                              '${task.progress.toInt()}%',
                              style: TextStyle(
                                color: _getTaskStatusColor(task.status),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        )),
                    ],
                  );
                }),
                const SizedBox(height: 24),
              ],
              
              // معلومات المشروع
              const Text(
                'معلومات المشروع:',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textPrimary,
                ),
              ),
              const SizedBox(height: 12),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      if (project != null) ...[
                        _buildInfoRow('تاريخ البدء', _formatDate(project.startDate)),
                        const Divider(),
                        if (project.endDate != null) ...[
                          _buildInfoRow('تاريخ الانتهاء', _formatDate(project.endDate!)),
                          const Divider(),
                        ],
                        if (project.budget != null) ...[
                          _buildInfoRow('الميزانية المقدرة', '${project.budget!.toStringAsFixed(0)} ريال'),
                          const Divider(),
                        ],
                        _buildInfoRow('الحالة', widget.status),
                        const Divider(),
                        _buildInfoRow('الأولوية', _getPriorityText(project.priority)),
                      ] else ...[
                        _buildInfoRow('تاريخ البدء', '15 يناير 2024'),
                        const Divider(),
                        _buildInfoRow('تاريخ الانتهاء', '30 مارس 2024'),
                        const Divider(),
                        _buildInfoRow('الميزانية المقدرة', '7500 ريال'),
                        const Divider(),
                        _buildInfoRow('المشرف', 'د. خالد العمري'),
                      ],
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              
              // الأزرار
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const PlanningScreen(),
                          ),
                        );
                      },
                      icon: const Icon(Icons.assignment),
                      label: const Text('مرحلة التخطيط'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const PertChartScreen(),
                          ),
                        );
                      },
                      icon: const Icon(Icons.timeline),
                      label: const Text('مخطط PERT'),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Color _getTaskStatusColor(String status) {
    switch (status) {
      case 'todo':
        return Colors.grey;
      case 'in_progress':
        return AppTheme.alertOrange;
      case 'completed':
        return AppTheme.successGreen;
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

  String _getPriorityText(String priority) {
    switch (priority) {
      case 'critical':
        return 'حرجة';
      case 'high':
        return 'عالية';
      case 'medium':
        return 'متوسطة';
      case 'low':
        return 'منخفضة';
      default:
        return 'غير محدد';
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              color: AppTheme.textSecondary,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppTheme.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
