import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'planning.dart';
import 'pert_chart.dart';

class ProjectDetailsScreen extends StatelessWidget {
  final String projectTitle;
  final String status;
  final int progress;
  final String commitment;

  const ProjectDetailsScreen({
    super.key,
    required this.projectTitle,
    required this.status,
    required this.progress,
    required this.commitment,
  });

  @override
  Widget build(BuildContext context) {
    final bool isRejected = status == 'مرفوض';
    final bool isAccepted = status == 'مقبول';

    return Scaffold(
      appBar: AppBar(
        title: Text(projectTitle),
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
                      const Text(
                        'المشروع المقدم لا يتوافق مع معايير القبول المطلوبة. يرجى الانتباه إلى أن المشروع يجب أن يحتوي على فكرة جديدة ومبتكرة، وأن الوصف المقدم شامل ويسهل فهم أهداف المشروع.',
                        style: TextStyle(
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
                projectTitle,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textPrimary,
                ),
              ),
              const SizedBox(height: 24),
              
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
                                  '$progress%',
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
                                value: progress / 100,
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
                                commitment,
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
              
              // ملخص المخرجات
              const Text(
                'ملخص المخرجات:',
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildOutputItem('نظام متكامل لإدارة المكتبة مع واجهة مستخدم حديثة'),
                      _buildOutputItem('قاعدة بيانات متكاملة لإدارة الكتب والمستخدمين'),
                      _buildOutputItem('نظام استعارة وإرجاع آلي مع إشعارات'),
                      _buildOutputItem('تقارير وإحصائيات شاملة'),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              
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
                      _buildInfoRow('تاريخ البدء', '15 يناير 2024'),
                      const Divider(),
                      _buildInfoRow('تاريخ الانتهاء', '30 مارس 2024'),
                      const Divider(),
                      _buildInfoRow('الميزانية المقدرة', '7500 ريال'),
                      const Divider(),
                      _buildInfoRow('المشرف', 'د. خالد العمري'),
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

  Widget _buildOutputItem(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.check_circle,
            color: AppTheme.successGreen,
            size: 20,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 14,
                color: AppTheme.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
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
