import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/notification_card.dart';
import 'new_project.dart';
import 'my_projects.dart';
import 'profile.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('نظام إدارة المشاريع التعليمية'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ProfileScreen(),
                ),
              );
            },
            tooltip: 'الملف الشخصي',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // العنوان الرئيسي
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppTheme.primaryBlue,
                    AppTheme.primaryBlue.withOpacity(0.8),
                  ],
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'مرحباً بك في نظام إدارة المشاريع التعليمية',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'نظام متكامل لإدارة المشاريع التعليمية يساعدك على تقديم مشاركات ومتابعة تقدمها بكل سهولة ويسر',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            
            // الأزرار الرئيسية
            Row(
              children: [
                Expanded(
                  child: Card(
                    elevation: 4,
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const NewProjectScreen(),
                          ),
                        );
                      },
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              AppTheme.lightBlue,
                              AppTheme.lightBlue.withOpacity(0.8),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.add_circle, color: Colors.white, size: 28),
                            SizedBox(width: 8),
                            Text(
                              'ابدأ الآن بتقديم مشروعك الجديد',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Card(
                    elevation: 2,
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const MyProjectsScreen(),
                          ),
                        );
                      },
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: AppTheme.primaryBlue,
                            width: 2,
                          ),
                        ),
                        child: const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.folder_open, color: AppTheme.primaryBlue, size: 28),
                            SizedBox(width: 8),
                            Text(
                              'تصفح مشاريعي',
                              style: TextStyle(
                                color: AppTheme.primaryBlue,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            
            // الإشعارات السريعة
            const Text(
              'الإشعارات السريعة',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppTheme.textPrimary,
              ),
            ),
            const SizedBox(height: 16),
            
            NotificationCard(
              icon: Icons.check_circle,
              iconColor: AppTheme.successGreen,
              title: 'تم قبول مشروعك',
              subtitle: '"مشروع نظام إدارة المكتبة"',
              time: 'منذ ساعتين',
            ),
            const SizedBox(height: 12),
            
            NotificationCard(
              icon: Icons.person,
              iconColor: AppTheme.lightBlue,
              title: 'تم تعيين مشرف',
              subtitle: 'د. ذاكر العسري',
              time: 'منذ 3 ساعات',
            ),
            const SizedBox(height: 12),
            
            NotificationCard(
              icon: Icons.event,
              iconColor: AppTheme.alertOrange,
              title: 'اجتماع قادم',
              subtitle: 'غداً الساعة 10:00 صباحاً',
              time: 'قريباً',
            ),
          ],
        ),
      ),
    );
  }
}
