import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class PertChartScreen extends StatefulWidget {
  const PertChartScreen({super.key});

  @override
  State<PertChartScreen> createState() => _PertChartScreenState();
}

class _PertChartScreenState extends State<PertChartScreen> {
  final _meetingTitleController = TextEditingController();
  final _meetingPlaceController = TextEditingController();
  DateTime? _meetingDate;
  TimeOfDay? _meetingTime;

  @override
  void dispose() {
    _meetingTitleController.dispose();
    _meetingPlaceController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
      locale: const Locale('ar', 'SA'),
    );
    if (picked != null) {
      setState(() {
        _meetingDate = picked;
      });
    }
  }

  Future<void> _pickTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        _meetingTime = picked;
      });
    }
  }

  void _addMeeting() {
    if (_meetingTitleController.text.isNotEmpty &&
        _meetingDate != null &&
        _meetingTime != null &&
        _meetingPlaceController.text.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('تم إضافة الاجتماع بنجاح'),
        ),
      );
      _meetingTitleController.clear();
      _meetingPlaceController.clear();
      setState(() {
        _meetingDate = null;
        _meetingTime = null;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('يرجى ملء جميع الحقول'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('مخطط PERT'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'مخطط PERT',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppTheme.textPrimary,
              ),
            ),
            const SizedBox(height: 24),
            
            // المراحل
            const Text(
              'المراحل:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppTheme.textPrimary,
              ),
            ),
            const SizedBox(height: 16),
            
            _buildPhaseCard(
              '1. تحليل المتطلبات',
              '15 يناير - 30 يناير',
            ),
            const SizedBox(height: 12),
            
            _buildPhaseCard(
              '2. التصميم والنمذجة',
              '1 فبراير - 20 فبراير',
              showExtensionButton: true,
            ),
            const SizedBox(height: 12),
            
            _buildPhaseCard(
              '3. البرمجة والتطوير',
              '21 فبراير - 30 مارس',
            ),
            const SizedBox(height: 32),
            
            // مواعيد الاجتماعات
            const Text(
              'مواعيد الاجتماعات:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppTheme.textPrimary,
              ),
            ),
            const SizedBox(height: 16),
            
            _buildMeetingCard(
              'مراجعة التصميم',
              'مع د. خالد العمري',
              '15 فبراير 2024 - الساعة 10:00 صباحاً',
              'القاعة الثالثة',
            ),
            const SizedBox(height: 12),
            
            _buildMeetingCard(
              'متابعة التقدم',
              'مع د. خالد العمري',
              '22 فبراير 2024 - الساعة 10:00 صباحاً',
              'القاعة الثالثة',
            ),
            const SizedBox(height: 32),
            
            // إضافة اجتماع جديد
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'إضافة اجتماع جديد:',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _meetingTitleController,
                      decoration: const InputDecoration(
                        labelText: 'عنوان الاجتماع',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: InkWell(
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
                                    _meetingDate != null
                                        ? '${_meetingDate!.day}/${_meetingDate!.month}/${_meetingDate!.year}'
                                        : 'التاريخ',
                                    style: TextStyle(
                                      color: _meetingDate != null
                                          ? AppTheme.textPrimary
                                          : AppTheme.textSecondary,
                                    ),
                                  ),
                                  const Icon(Icons.calendar_today),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: InkWell(
                            onTap: _pickTime,
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
                                    _meetingTime != null
                                        ? '${_meetingTime!.hour}:${_meetingTime!.minute.toString().padLeft(2, '0')}'
                                        : 'الوقت',
                                    style: TextStyle(
                                      color: _meetingTime != null
                                          ? AppTheme.textPrimary
                                          : AppTheme.textSecondary,
                                    ),
                                  ),
                                  const Icon(Icons.access_time),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _meetingPlaceController,
                      decoration: const InputDecoration(
                        labelText: 'المكان',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _addMeeting,
                        child: const Text('إضافة الاجتماع'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),
            
            // إدارة المشروع
            const Text(
              'إدارة المشروع:',
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
                  child: ElevatedButton.icon(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('إنهاء المشروع'),
                          content: const Text('هل أنت متأكد من إنهاء المشروع؟'),
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
                                    content: Text('تم إنهاء المشروع'),
                                  ),
                                );
                              },
                              child: const Text('تأكيد'),
                            ),
                          ],
                        ),
                      );
                    },
                    icon: const Icon(Icons.check_circle),
                    label: const Text('إنهاء المشروع'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.successGreen,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('إيقاف المشروع'),
                          content: const Text('هل أنت متأكد من إيقاف المشروع؟'),
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
                                    content: Text('تم إيقاف المشروع'),
                                  ),
                                );
                              },
                              child: const Text('تأكيد'),
                            ),
                          ],
                        ),
                      );
                    },
                    icon: const Icon(Icons.stop_circle),
                    label: const Text('إيقاف المشروع'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.warningRed,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPhaseCard(String title, String dateRange, {bool showExtensionButton = false}) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
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
                    dateRange,
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            if (showExtensionButton)
              TextButton.icon(
                onPressed: () {
                  // يمكن إضافة منطق طلب التمديد
                },
                icon: const Icon(Icons.schedule),
                label: const Text('طلب تمديد'),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildMeetingCard(
    String title,
    String withPerson,
    String dateTime,
    String place,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
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
            const SizedBox(height: 8),
            Text(
              withPerson,
              style: const TextStyle(
                fontSize: 14,
                color: AppTheme.textSecondary,
              ),
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.calendar_today, size: 16, color: AppTheme.textSecondary),
                const SizedBox(width: 4),
                Text(
                  dateTime,
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppTheme.textSecondary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.location_on, size: 16, color: AppTheme.textSecondary),
                const SizedBox(width: 4),
                Text(
                  'مكان الاجتماع: $place',
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppTheme.textSecondary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
