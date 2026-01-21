import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class PlanningScreen extends StatefulWidget {
  const PlanningScreen({super.key});

  @override
  State<PlanningScreen> createState() => _PlanningScreenState();
}

class _PlanningScreenState extends State<PlanningScreen> {
  final _extensionRequestController = TextEditingController();
  DateTime? _projectStartDate;

  @override
  void dispose() {
    _extensionRequestController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      locale: const Locale('ar', 'SA'),
    );
    if (picked != null && picked != _projectStartDate) {
      setState(() {
        _projectStartDate = picked;
      });
    }
  }

  Future<void> _pickFile(String fileType) async {
    // TODO: إضافة منطق رفع الملفات عند تثبيت حزمة file_picker
    // يمكن استخدام showDialog أو Navigator لصفحة رفع الملفات
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('رفع الملف'),
        content: const Text('سيتم إضافة وظيفة رفع الملفات قريباً'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('حسناً'),
          ),
        ],
      ),
    );
  }

  void _submitExtensionRequest() {
    if (_extensionRequestController.text.isNotEmpty) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('تم إرسال طلب التمديد'),
          content: const Text('سيتم مراجعة طلب التمديد وإشعارك بالنتيجة قريباً.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('حسناً'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('مرحلة التخطيط - نظام إدارة المكتبة'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // تاريخ بدء المشروع
            const Text(
              'تاريخ بدء المشروع',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppTheme.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            InkWell(
              onTap: _pickDate,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(color: AppTheme.mediumGray),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _projectStartDate != null
                          ? '${_projectStartDate!.day}/${_projectStartDate!.month}/${_projectStartDate!.year}'
                          : 'mm/dd/yyyy',
                      style: TextStyle(
                        color: _projectStartDate != null
                            ? AppTheme.textPrimary
                            : AppTheme.textSecondary,
                      ),
                    ),
                    const Icon(Icons.calendar_today),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            
            // رفع البحث أو الدراسة الأولية
            _buildFileUploadSection(
              'رفع البحث أو الدراسة الأولية',
              'قم بتحميل الملف أو اسحبه هنا',
              'يسمح بصيغ: PDF, DOC, DOCX',
              () => _pickFile('research'),
            ),
            const SizedBox(height: 24),
            
            // رفع دراسة الجدوى
            _buildFileUploadSection(
              'رفع دراسة الجدوى',
              'قم بتحميل الملف أو اسحبه هنا',
              'يسمح بصيغ: PDF, DOC, DOCX',
              () => _pickFile('research'),
            ),
            const SizedBox(height: 24),
            
            // رفع مخططات المرحلة الأولى
            _buildFileUploadSection(
              'رفع مخططات المرحلة الأولى',
              'قم بتحميل الملف أو اسحبه هنا',
              'يسمح بصيغ: PDF, PNG, JPG, Excel',
              () => _pickFile('plans'),
            ),
            const SizedBox(height: 24),
            
            // طلب تمديد
            const Text(
              'طلب تمديد',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppTheme.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _extensionRequestController,
              maxLines: 4,
              decoration: const InputDecoration(
                hintText: 'اكتب سبب طلب التمديد',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _submitExtensionRequest,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.alertOrange,
                ),
                child: const Text('إرسال طلب التمديد'),
              ),
            ),
            const SizedBox(height: 24),
            
            // زر الانتقال لمرحلة التنفيذ
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/user/pert-chart');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.successGreen,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text(
                  'الانتقال لمرحلة التنفيذ',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
            const SizedBox(height: 32),
            
            // معلومات المشرف
            Card(
              color: AppTheme.lightGray,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'معلومات المشرف:',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildSupervisorInfo('المشرف المعين', 'د. خالد العمري'),
                    const SizedBox(height: 8),
                    _buildSupervisorInfo('القسم', 'قسم علوم الحاسب'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFileUploadSection(
    String title,
    String hint,
    String allowedFormats,
    VoidCallback onTap,
  ) {
    return Column(
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
        const SizedBox(height: 8),
        InkWell(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              border: Border.all(
                color: AppTheme.mediumGray,
                style: BorderStyle.solid,
                width: 2,
              ),
              borderRadius: BorderRadius.circular(8),
              color: AppTheme.lightGray,
            ),
            child: Column(
              children: [
                const Icon(
                  Icons.cloud_upload,
                  size: 48,
                  color: AppTheme.lightBlue,
                ),
                const SizedBox(height: 12),
                Text(
                  hint,
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppTheme.textSecondary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  allowedFormats,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppTheme.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSupervisorInfo(String label, String value) {
    return Row(
      children: [
        Text(
          '$label: ',
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
}
