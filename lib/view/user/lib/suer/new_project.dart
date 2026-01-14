import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class NewProjectScreen extends StatefulWidget {
  const NewProjectScreen({super.key});

  @override
  State<NewProjectScreen> createState() => _NewProjectScreenState();
}

class _NewProjectScreenState extends State<NewProjectScreen> {
  final _formKey = GlobalKey<FormState>();
  final _projectNameController = TextEditingController();
  final _teamMembersController = TextEditingController();
  final _descriptionController = TextEditingController();
  String? _selectedProjectType;
  final List<String> _teamMembers = [];

  final List<String> _projectTypes = [
    'نظام إدارة',
    'تطبيق ويب',
    'تطبيق موبايل',
    'نظام ذكاء اصطناعي',
    'مشروع بحثي',
    'أخرى',
  ];

  @override
  void dispose() {
    _projectNameController.dispose();
    _teamMembersController.dispose();
    _descriptionController.dispose();
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

  void _submitProject() {
    if (_formKey.currentState!.validate()) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('تم استلام طلب المشروع'),
          content: const Text(
            'تم استلام طلب المشروع. سيتم مراجعة المشروع وإشعارك بالنتيجة قريباً.',
          ),
          actions: [
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('تقديم مشروع جديد'),
      ),
      body: SingleChildScrollView(
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
                  hintText: 'اكتب وصفاً مختصراً للمشروع',
                  border: OutlineInputBorder(),
                  alignLabelWithHint: true,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'يرجى إدخال وصف المشروع';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 32),
              
              // زر الإرسال
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _submitProject,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.lightBlue,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text(
                    'إرسال المشروع',
                    style: TextStyle(fontSize: 18),
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
