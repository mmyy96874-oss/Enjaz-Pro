import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('الإشعارات'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'الإشعارات',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 24),
          
          _buildNotificationItem(
            icon: Icons.check_circle,
            iconColor: AppTheme.successGreen,
            title: 'تم قبول مشروعك',
            description: 'تم قبول مشروع "نظام إدارة المكتبة الذكي" وتعين المشرف',
            time: 'منذ ساعتين',
          ),
          const SizedBox(height: 12),
          
          _buildNotificationItem(
            icon: Icons.event,
            iconColor: AppTheme.alertOrange,
            title: 'اجتماع قادم',
            description: 'لديك اجتماع غداً الساعة 10:00 صباحاً مع المشرف',
            time: 'منذ 5 ساعات',
          ),
          const SizedBox(height: 12),
          
          _buildNotificationItem(
            icon: Icons.schedule,
            iconColor: AppTheme.lightBlue,
            title: 'موعد تسليم قريب',
            description: 'تذكر: موعد تسليم المرحلة الثانية بعد 3 أيام',
            time: 'منذ يوم واحد',
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationItem({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String description,
    required String time,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: iconColor, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    time,
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
    );
  }
}
