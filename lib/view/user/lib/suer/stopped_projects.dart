import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/project_card.dart';

class StoppedProjectsScreen extends StatelessWidget {
  const StoppedProjectsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('المشاريع المتوقفة'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'المشاريع المتوقفة (11)',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textPrimary,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: AppTheme.stoppedStart.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  '11',
                  style: TextStyle(
                    color: AppTheme.stoppedStart,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          
          // مشروع متوقف
          ProjectCard(
            title: 'تطبيق إدارة المهام',
            status: 'متوقف',
            statusColor: AppTheme.stoppedStart,
            statusGradient: [AppTheme.stoppedStart, AppTheme.stoppedEnd],
            description: 'تم إيقاف المشروع بسبب عدم الالتزام بالجدول الزمني',
            onTap: () {
              _showStoppedProjectDetails(context);
            },
          ),
          const SizedBox(height: 16),
          
          // تفاصيل سبب الإيقاف
          Card(
            color: AppTheme.warningRed.withOpacity(0.05),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.info_outline,
                        color: AppTheme.warningRed,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'سبب الإيقاف:',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.warningRed,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'تم إيقاف المشروع بسبب عدم التزام الطالب بالجدول الزمني المحدد وعدم تقديم التحديثات المطلوبة في المواعيد المحددة. تم عقد عدة اجتماعات لمحاولة حل المشكلة ولكن دون جدوى.',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppTheme.textPrimary,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Divider(),
                  const SizedBox(height: 12),
                  const Text(
                    'معلومات المشروع:',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildInfoRow('تاريخ البدء', '1 فبراير 2024'),
                  const SizedBox(height: 8),
                  _buildInfoRow('تاريخ الإيقاف', '15 مارس 2024'),
                  const SizedBox(height: 8),
                  _buildInfoRow('نسبة الإنجاز', '35%'),
                  const SizedBox(height: 8),
                  _buildInfoRow('المشرف', 'د. سارة أحمد'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
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
    );
  }

  void _showStoppedProjectDetails(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.9,
        expand: false,
        builder: (context, scrollController) => SingleChildScrollView(
          controller: scrollController,
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppTheme.mediumGray,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'تطبيق إدارة المهام',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textPrimary,
                ),
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppTheme.stoppedStart, AppTheme.stoppedEnd],
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  'متوقف',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'سبب الإيقاف:',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textPrimary,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'تم إيقاف المشروع بسبب عدم التزام الطالب بالجدول الزمني المحدد وعدم تقديم التحديثات المطلوبة في المواعيد المحددة. تم عقد عدة اجتماعات لمحاولة حل المشكلة ولكن دون جدوى.',
                style: TextStyle(
                  fontSize: 14,
                  color: AppTheme.textPrimary,
                  height: 1.6,
                ),
              ),
              const SizedBox(height: 24),
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
                      _buildInfoRow('تاريخ البدء', '1 فبراير 2024'),
                      const Divider(),
                      _buildInfoRow('تاريخ الإيقاف', '15 مارس 2024'),
                      const Divider(),
                      _buildInfoRow('نسبة الإنجاز', '35%'),
                      const Divider(),
                      _buildInfoRow('المشرف', 'د. سارة أحمد'),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
