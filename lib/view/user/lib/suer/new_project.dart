import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../theme/app_theme.dart';
import '../../../../presentation/controllers/project_controller.dart';
import '../../../../presentation/controllers/auth_controller.dart';

class NewProjectScreen extends StatefulWidget {
  const NewProjectScreen({super.key});

  @override
  State<NewProjectScreen> createState() => _NewProjectScreenState();
}

class _NewProjectScreenState extends State<NewProjectScreen> {
  final ProjectController projectController = Get.find<ProjectController>();
  final AuthController authController = Get.find<AuthController>();
  
  final _formKey = GlobalKey<FormState>();
  final _projectNameController = TextEditingController();
  final _teamMembersController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _budgetController = TextEditingController();
  
  String? _selectedProjectType;
  String _selectedPriority = 'medium';
  DateTime _startDate = DateTime.now();
  DateTime? _endDate;
  final List<String> _teamMembers = [];

  final List<String> _projectTypes = [
    'نظام إدارة',
    'تطبيق ويب',
    'تطبيق موبايل',
    'نظام ذكاء اصطناعي',
    'مشروع بحثي',
    'أخرى',
  ];

  final List<Map<String, String>> _priorities = [
    {'value': 'low', 'label': 'منخفضة'},
    {'value': 'medium', 'label': 'متوسطة'},
    {'value': 'high', 'label': 'عالية'},
    {'value': 'critical', 'label': 'حرجة'},
  ];

  @override
  void dispose() {
    _projectNameController.dispose();
    _teamMembersController.dispose();
    _descriptionController.dispose();
    _budgetController.dispose();
    super.dispose();
  }

  void _addTeamMember() {
    if (_teamMembersController.text.isNotEmpty) {
      setState(() {
        _teamMembers.add(_teamMembersController.text);
        _teamMembersController.clear();
      });
    }
  }

  Future<void> _selectStartDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _startDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null && picked != _startDate) {
      setState(() {
        _startDate = picked;
        // Reset end date if it's before start date
        if (_endDate != null && _endDate!.isBefore(_startDate)) {
          _endDate = null;
        }
      });
    }
  }

  Future<void> _selectEndDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _endDate ?? _startDate.add(const Duration(days: 30)),
      firstDate: _startDate,
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null && picked != _endDate) {
      setState(() {
        _endDate = picked;
      });
    }
  }

  Future<void> _submitProject() async {
    if (!_formKey.currentState!.validate()) return;

    final currentUser = authController.currentUser.value;
    if (currentUser == null) {
      Get.snackbar('خطأ', 'يجب تسجيل الدخول أولاً');
      return;
    }

    // Set form data to controller
    projectController.nameController.text = _projectNameController.text;
    projectController.descriptionController.text = _descriptionController.text;
    projectController.budgetController.text = _budgetController.text;
    projectController.selectedPriority.value = _selectedPriority;
    projectController.startDate.value = _startDate;
    projectController.endDate.value = _endDate;

    try {
      await projectController.createProject();
      
      // Show success dialog
      if (mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('تم إنشاء المشروع بنجاح'),
            content: const Text(
              'تم إنشاء المشروع بنجاح. يمكنك الآن متابعة تقدم المشروع من صفحة مشاريعي.',
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                  // Navigate to my projects
                  Get.toNamed('/user/my-projects');
                },
                child: const Text('عرض مشاريعي'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                },
                child: const Text('حسناً'),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      Get.snackbar('خطأ', 'فشل في إنشاء المشروع: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('تقديم مشروع جديد'),
      ),
      body: Obx(() {
        final isCreating = projectController.isCreating.value;
        
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'تقديم مشروع جديد',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textPrimary,
                  ),
                ),
                const SizedBox(height: 32),
                
                // اسم المشروع
                TextFormField(
                  controller: _projectNameController,
                  decoration: const InputDecoration(
                    labelText: 'اسم المشروع',
                    hintText: 'أدخل اسم المشروع',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.title),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'يرجى إدخال اسم المشروع';
                    }
                    if (value.length < 3) {
                      return 'يجب أن يكون اسم المشروع 3 أحرف على الأقل';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                
                // نوع المشروع
                DropdownButtonFormField<String>(
                  value: _selectedProjectType,
                  decoration: const InputDecoration(
                    labelText: 'نوع المشروع',
                    hintText: 'اختر نوع المشروع',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.category),
                  ),
                  items: _projectTypes.map((String type) {
                    return DropdownMenuItem<String>(
                      value: type,
                      child: Text(type),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedProjectType = newValue;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'يرجى اختيار نوع المشروع';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),

                // الأولوية
                DropdownButtonFormField<String>(
                  value: _selectedPriority,
                  decoration: const InputDecoration(
                    labelText: 'أولوية المشروع',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.priority_high),
                  ),
                  items: _priorities.map((priority) {
                    return DropdownMenuItem<String>(
                      value: priority['value'],
                      child: Text(priority['label']!),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      setState(() {
                        _selectedPriority = newValue;
                      });
                    }
                  },
                ),
                const SizedBox(height: 24),

                // التواريخ
                Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: _selectStartDate,
                        child: InputDecorator(
                          decoration: const InputDecoration(
                            labelText: 'تاريخ البدء',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.calendar_today),
                          ),
                          child: Text(
                            '${_startDate.day}/${_startDate.month}/${_startDate.year}',
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: InkWell(
                        onTap: _selectEndDate,
                        child: InputDecorator(
                          decoration: const InputDecoration(
                            labelText: 'تاريخ الانتهاء (اختياري)',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.event),
                          ),
                          child: Text(
                            _endDate != null
                                ? '${_endDate!.day}/${_endDate!.month}/${_endDate!.year}'
                                : 'اختر التاريخ',
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // الميزانية
                TextFormField(
                  controller: _budgetController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'الميزانية المقدرة (ريال)',
                    hintText: 'أدخل الميزانية المقدرة',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.attach_money),
                  ),
                  validator: (value) {
                    if (value != null && value.isNotEmpty) {
                      final budget = double.tryParse(value);
                      if (budget == null || budget <= 0) {
                        return 'يرجى إدخال ميزانية صحيحة';
                      }
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                
                // أعضاء الفريق
                const Text(
                  'أعضاء الفريق',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _teamMembersController,
                        decoration: const InputDecoration(
                          hintText: 'أسماء الأعضاء',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.person),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      onPressed: _addTeamMember,
                      icon: const Icon(Icons.add),
                      style: IconButton.styleFrom(
                        backgroundColor: AppTheme.lightBlue,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ],
                ),
                if (_teamMembers.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _teamMembers.map((member) {
                      return Chip(
                        label: Text(member),
                        onDeleted: () {
                          setState(() {
                            _teamMembers.remove(member);
                          });
                        },
                      );
                    }).toList(),
                  ),
                ],
                const SizedBox(height: 24),
                
                // وصف المشروع
                TextFormField(
                  controller: _descriptionController,
                  maxLines: 5,
                  decoration: const InputDecoration(
                    labelText: 'وصف المشروع',
                    hintText: 'اكتب وصفاً مختصراً للمشروع وأهدافه',
                    border: OutlineInputBorder(),
                    alignLabelWithHint: true,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'يرجى إدخال وصف المشروع';
                    }
                    if (value.length < 10) {
                      return 'يجب أن يكون الوصف 10 أحرف على الأقل';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 32),
                
                // زر الإرسال
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: isCreating ? null : _submitProject,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.lightBlue,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: isCreating
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : const Text(
                            'إنشاء المشروع',
                            style: TextStyle(fontSize: 18),
                          ),
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
