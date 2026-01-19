import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/project_card.dart';
import 'project_details.dart';
import 'stopped_projects.dart';

class MyProjectsScreen extends StatelessWidget {
  const MyProjectsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('مشاريعي'),
      ),
      body: ListView(
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
          
          // مشروع مقبول
          ProjectCard(
            title: 'نظام إدارة المكتبة',
            status: 'مقبول',
            statusColor: AppTheme.successGreen,
            statusGradient: [AppTheme.acceptedStart, AppTheme.acceptedEnd],
            description: 'تم قبول المشروع وتعين المشرف: د. ذاكر العسري',
            currentPhase: 'المرحلة الحالية: مرحلة التخطيط',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ProjectDetailsScreen(
                    projectTitle: 'نظام إدارة المكتبة',
                    status: 'مقبول',
                    progress: 100,
                    commitment: 'ممتاز',
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 16),
          
          // مشروع قيد المراجعة
          ProjectCard(
            title: 'تطبيق إدارة المهام',
            status: 'قيد المراجعة',
            statusColor: AppTheme.alertOrange,
            statusGradient: [AppTheme.reviewStart, AppTheme.reviewEnd],
            description: 'المشروع قيد المراجعة من قبل الإدارة، سيتم إشعارك بالنتيجة قريباً',
            onTap: () {
              // يمكن إضافة صفحة تفاصيل للمشاريع قيد المراجعة
            },
          ),
          const SizedBox(height: 16),
          
          // مشروع مرفوض
          ProjectCard(
            title: 'نظام المبيعات',
            status: 'مرفوض',
            statusColor: AppTheme.warningRed,
            statusGradient: [AppTheme.rejectedStart, AppTheme.rejectedEnd],
            description: 'عرض سبب الرفض',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ProjectDetailsScreen(
                    projectTitle: 'نظام المبيعات',
                    status: 'مرفوض',
                    progress: 0,
                    commitment: '-',
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 24),
          
          // رابط المشاريع المتوقفة
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
                    Row(
                      children: [
                        const Icon(
                          Icons.pause_circle_outline,
                          color: AppTheme.stoppedStart,
                          size: 24,
                        ),
                        const SizedBox(width: 12),
                        const Text(
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
                          child: const Text(
                            '11',
                            style: TextStyle(
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
      ),
    );
  }
}
