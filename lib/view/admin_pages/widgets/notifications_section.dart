import 'package:flutter/material.dart';

class NotificationsSection extends StatelessWidget {
  const NotificationsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        appBar: AppBar(
          title: const Text('الإشعارات'),
          backgroundColor: Colors.white,
          elevation: 0,
          foregroundColor: Colors.black,
          actions: [
            TextButton(
              onPressed: () {},
              child: Text(
                'قراءة الكل',
                style: TextStyle(
                  color: Colors.blue[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                // Header Button
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [const Color(0xFF6366F1), const Color(0xFF8B5CF6)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Row(
                    children: [
                      Icon(
                        Icons.notifications_active,
                        color: Colors.white,
                        size: 20,
                      ),
                      SizedBox(width: 12),
                      Text(
                        'الإشعارات',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Spacer(),
                      Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.white,
                        size: 14,
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 20),
                
                // Notifications List
                _NotificationItem(
                  icon: Icons.check_circle,
                  iconColor: Colors.green[600]!,
                  iconBgColor: Colors.green[50]!,
                  title: 'تم قبول مشروعك',
                  subtitle: 'تم قبول مشروع "نظام إدارة المكتبة الذكي" وتعيين المشرف',
                  time: 'منذ ساعتين',
                  isRead: false,
                ),
                
                const SizedBox(height: 12),
                
                _NotificationItem(
                  icon: Icons.event,
                  iconColor: Colors.blue[600]!,
                  iconBgColor: Colors.blue[50]!,
                  title: 'اجتماع قادم',
                  subtitle: 'لديك اجتماع غداً الساعة 10:00 صباحاً مع المشرف',
                  time: 'منذ 5 ساعات',
                  isRead: false,
                ),
                
                const SizedBox(height: 12),
                
                _NotificationItem(
                  icon: Icons.warning,
                  iconColor: Colors.orange[600]!,
                  iconBgColor: Colors.orange[50]!,
                  title: 'موعد تسليم قريب',
                  subtitle: 'تذكير: موعد تسليم المرحلة الثانية بعد 3 أيام',
                  time: 'منذ يوم واحد',
                  isRead: true,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _NotificationItem extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final Color iconBgColor;
  final String title;
  final String subtitle;
  final String time;
  final bool isRead;

  const _NotificationItem({
    required this.icon,
    required this.iconColor,
    required this.iconBgColor,
    required this.title,
    required this.subtitle,
    required this.time,
    required this.isRead,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isRead ? Colors.white : Colors.blue[50],
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: isRead ? Colors.grey[200]! : Colors.blue[200]!,
          width: 1,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: iconBgColor,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Icon(
              icon,
              color: iconColor,
              size: 16,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: isRead ? FontWeight.w500 : FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  time,
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey[500],
                  ),
                ),
              ],
            ),
          ),
          if (!isRead)
            Container(
              width: 6,
              height: 6,
              decoration: BoxDecoration(
                color: Colors.blue[600],
                borderRadius: BorderRadius.circular(3),
              ),
            ),
        ],
      ),
    );
  }
}