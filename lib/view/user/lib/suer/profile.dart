import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('الملف الشخصي'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // صورة الملف الشخصي
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [
                    AppTheme.primaryBlue,
                    AppTheme.lightBlue,
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.primaryBlue.withOpacity(0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: const Center(
                child: Icon(
                  Icons.person,
                  size: 60,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 16),
            
            // الاسم
            const Text(
              'محمد أحمد العسري',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppTheme.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            
            // الرقم الأكاديمي
            const Text(
              'الرقم الأكاديمي: 2021001234',
              style: TextStyle(
                fontSize: 16,
                color: AppTheme.textSecondary,
              ),
            ),
            const SizedBox(height: 32),
            
            // بطاقة المعلومات الشخصية
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'المعلومات الشخصية',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildInfoRow(
                      Icons.email,
                      'البريد الإلكتروني',
                      'mohammed.alsari@university.edu.sa',
                    ),
                    const Divider(height: 24),
                    _buildInfoRow(
                      Icons.phone,
                      'رقم الجوال',
                      '+966 50 123 4567',
                    ),
                    const Divider(height: 24),
                    _buildInfoRow(
                      Icons.school,
                      'القسم',
                      'قسم علوم الحاسب',
                    ),
                    const Divider(height: 24),
                    _buildInfoRow(
                      Icons.calendar_today,
                      'تاريخ التسجيل',
                      '2021/09/01',
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            
            // بطاقة الإحصائيات
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'إحصائيات المشاريع',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: _buildStatCard(
                            'المشاريع المقبولة',
                            '3',
                            AppTheme.successGreen,
                            Icons.check_circle,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildStatCard(
                            'قيد المراجعة',
                            '1',
                            AppTheme.alertOrange,
                            Icons.hourglass_empty,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: _buildStatCard(
                            'المشاريع المرفوضة',
                            '1',
                            AppTheme.warningRed,
                            Icons.cancel,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildStatCard(
                            'المشاريع المتوقفة',
                            '2',
                            AppTheme.stoppedStart,
                            Icons.pause_circle,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            
            // الإعدادات
            Card(
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.edit, color: AppTheme.primaryBlue),
                    title: const Text('تعديل الملف الشخصي'),
                    trailing: const Icon(Icons.arrow_back_ios, size: 16),
                    onTap: () {
                      // يمكن إضافة صفحة تعديل الملف الشخصي
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('ميزة تعديل الملف الشخصي قريباً'),
                        ),
                      );
                    },
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.notifications, color: AppTheme.primaryBlue),
                    title: const Text('إعدادات الإشعارات'),
                    trailing: const Icon(Icons.arrow_back_ios, size: 16),
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('ميزة إعدادات الإشعارات قريباً'),
                        ),
                      );
                    },
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.lock, color: AppTheme.primaryBlue),
                    title: const Text('تغيير كلمة المرور'),
                    trailing: const Icon(Icons.arrow_back_ios, size: 16),
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('ميزة تغيير كلمة المرور قريباً'),
                        ),
                      );
                    },
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.logout, color: AppTheme.warningRed),
                    title: const Text(
                      'تسجيل الخروج',
                      style: TextStyle(color: AppTheme.warningRed),
                    ),
                    trailing: const Icon(Icons.arrow_back_ios, size: 16),
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('تسجيل الخروج'),
                          content: const Text('هل أنت متأكد من تسجيل الخروج؟'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(),
                              child: const Text('إلغاء'),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('تم تسجيل الخروج'),
                                  ),
                                );
                              },
                              child: const Text(
                                'تسجيل الخروج',
                                style: TextStyle(color: AppTheme.warningRed),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, color: AppTheme.primaryBlue, size: 20),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 12,
                  color: AppTheme.textSecondary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textPrimary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    Color color,
    IconData icon,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 32),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              color: AppTheme.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
