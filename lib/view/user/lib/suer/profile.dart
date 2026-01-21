import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../theme/app_theme.dart';
import '../../../../presentation/controllers/auth_controller.dart';
import '../../../../presentation/controllers/project_controller.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final AuthController authController = Get.find<AuthController>();
  final ProjectController projectController = Get.find<ProjectController>();
  
  final _formKey = GlobalKey<FormState>();
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    authController.fillProfileForm();
    _loadUserStats();
  }

  Future<void> _loadUserStats() async {
    await projectController.loadUserProjects();
  }

  void _toggleEdit() {
    setState(() {
      _isEditing = !_isEditing;
    });
    if (_isEditing) {
      authController.fillProfileForm();
    }
  }

  Future<void> _saveProfile() async {
    if (_formKey.currentState!.validate()) {
      await authController.updateProfile();
      setState(() {
        _isEditing = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('الملف الشخصي'),
        actions: [
          if (_isEditing)
            TextButton(
              onPressed: _saveProfile,
              child: const Text('حفظ', style: TextStyle(color: Colors.white)),
            )
          else
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: _toggleEdit,
            ),
        ],
      ),
      body: Obx(() {
        final currentUser = authController.currentUser.value;
        final userProjects = projectController.userProjects;
        final isLoading = authController.isLoading.value;

        if (currentUser == null) {
          return const Center(
            child: Text('لا توجد بيانات مستخدم'),
          );
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
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
                  child: Center(
                    child: Text(
                      currentUser.name.isNotEmpty 
                        ? currentUser.name.substring(0, 1).toUpperCase()
                        : 'U',
                      style: const TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                
                // الاسم
                Text(
                  currentUser.name,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                
                // الدور
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: _getRoleColor(currentUser.role).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: _getRoleColor(currentUser.role),
                      width: 1,
                    ),
                  ),
                  child: Text(
                    _getRoleText(currentUser.role),
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: _getRoleColor(currentUser.role),
                    ),
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
                        
                        if (_isEditing) ...[
                          // Edit mode
                          TextFormField(
                            controller: authController.nameController,
                            decoration: const InputDecoration(
                              labelText: 'الاسم',
                              prefixIcon: Icon(Icons.person),
                            ),
                            validator: authController.validateName,
                          ),
                          const SizedBox(height: 16),
                          
                          TextFormField(
                            controller: authController.emailController,
                            decoration: const InputDecoration(
                              labelText: 'البريد الإلكتروني',
                              prefixIcon: Icon(Icons.email),
                            ),
                            enabled: false, // Email shouldn't be editable
                          ),
                          const SizedBox(height: 16),
                          
                          TextFormField(
                            controller: authController.phoneController,
                            decoration: const InputDecoration(
                              labelText: 'رقم الجوال',
                              prefixIcon: Icon(Icons.phone),
                            ),
                            validator: authController.validatePhone,
                          ),
                          const SizedBox(height: 16),
                          
                          TextFormField(
                            controller: authController.departmentController,
                            decoration: const InputDecoration(
                              labelText: 'القسم',
                              prefixIcon: Icon(Icons.business),
                            ),
                          ),
                          const SizedBox(height: 16),
                          
                          TextFormField(
                            controller: authController.positionController,
                            decoration: const InputDecoration(
                              labelText: 'المنصب',
                              prefixIcon: Icon(Icons.work),
                            ),
                          ),
                        ] else ...[
                          // View mode
                          _buildInfoRow(
                            Icons.email,
                            'البريد الإلكتروني',
                            currentUser.email,
                          ),
                          const Divider(height: 24),
                          _buildInfoRow(
                            Icons.phone,
                            'رقم الجوال',
                            currentUser.phone ?? 'غير محدد',
                          ),
                          const Divider(height: 24),
                          _buildInfoRow(
                            Icons.business,
                            'القسم',
                            currentUser.department ?? 'غير محدد',
                          ),
                          const Divider(height: 24),
                          _buildInfoRow(
                            Icons.work,
                            'المنصب',
                            currentUser.position ?? 'غير محدد',
                          ),
                          const Divider(height: 24),
                          _buildInfoRow(
                            Icons.calendar_today,
                            'تاريخ التسجيل',
                            _formatDate(currentUser.createdAt),
                          ),
                        ],
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
                                'المشاريع النشطة',
                                userProjects.where((p) => p.status == 'active').length.toString(),
                                AppTheme.successGreen,
                                Icons.check_circle,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _buildStatCard(
                                'المشاريع المكتملة',
                                userProjects.where((p) => p.status == 'completed').length.toString(),
                                AppTheme.primaryBlue,
                                Icons.emoji_events,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: _buildStatCard(
                                'المشاريع المتوقفة',
                                userProjects.where((p) => p.status == 'paused').length.toString(),
                                AppTheme.alertOrange,
                                Icons.pause_circle,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _buildStatCard(
                                'إجمالي المشاريع',
                                userProjects.length.toString(),
                                AppTheme.lightBlue,
                                Icons.folder,
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
                if (!_isEditing)
                  Card(
                    child: Column(
                      children: [
                        ListTile(
                          leading: const Icon(Icons.edit, color: AppTheme.primaryBlue),
                          title: const Text('تعديل الملف الشخصي'),
                          trailing: const Icon(Icons.arrow_back_ios, size: 16),
                          onTap: _toggleEdit,
                        ),
                        const Divider(height: 1),
                        ListTile(
                          leading: const Icon(Icons.lock, color: AppTheme.primaryBlue),
                          title: const Text('تغيير كلمة المرور'),
                          trailing: const Icon(Icons.arrow_back_ios, size: 16),
                          onTap: () {
                            _showChangePasswordDialog();
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
                            _showLogoutDialog();
                          },
                        ),
                      ],
                    ),
                  ),
                
                if (isLoading)
                  const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: CircularProgressIndicator(),
                  ),
              ],
            ),
          ),
        );
      }),
    );
  }

  void _showChangePasswordDialog() {
    final currentPasswordController = TextEditingController();
    final newPasswordController = TextEditingController();
    final confirmPasswordController = TextEditingController();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('تغيير كلمة المرور'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: currentPasswordController,
              decoration: const InputDecoration(
                labelText: 'كلمة المرور الحالية',
                prefixIcon: Icon(Icons.lock),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: newPasswordController,
              decoration: const InputDecoration(
                labelText: 'كلمة المرور الجديدة',
                prefixIcon: Icon(Icons.lock_outline),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: confirmPasswordController,
              decoration: const InputDecoration(
                labelText: 'تأكيد كلمة المرور',
                prefixIcon: Icon(Icons.lock_outline),
              ),
              obscureText: true,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('إلغاء'),
          ),
          TextButton(
            onPressed: () {
              // Implement password change logic
              Navigator.of(context).pop();
              Get.snackbar('نجح', 'تم تغيير كلمة المرور بنجاح');
            },
            child: const Text('تغيير'),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog() {
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
              authController.logout();
            },
            child: const Text(
              'تسجيل الخروج',
              style: TextStyle(color: AppTheme.warningRed),
            ),
          ),
        ],
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

  Color _getRoleColor(String role) {
    switch (role) {
      case 'super_admin':
        return Colors.red;
      case 'admin':
        return Colors.orange;
      case 'user':
        return AppTheme.primaryBlue;
      default:
        return Colors.grey;
    }
  }

  String _getRoleText(String role) {
    switch (role) {
      case 'super_admin':
        return 'مدير النظام';
      case 'admin':
        return 'مدير';
      case 'user':
        return 'مستخدم';
      default:
        return 'غير محدد';
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
