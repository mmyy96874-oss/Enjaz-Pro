import 'package:flutter/material.dart';
import 'manager_data_source.dart';
import 'manager_model.dart';

class SupervisorScreen extends StatefulWidget {
  @override
  _SupervisorScreenState createState() => _SupervisorScreenState();
}

class _SupervisorScreenState extends State<SupervisorScreen> {
  // Consistent colors with the app theme
  static const Color primaryBlue = Color(0xFF6366F1);
  static const Color purple = Color(0xFF8B5CF6);
  static const Color lightGray = Color(0xFFF8F9FA);

  List<Supervisor> list = SupervisorProvider.supervisors;
  final nameController = TextEditingController();
  final specController = TextEditingController();
  final countController = TextEditingController();

  void _addNewSupervisor() {
    setState(() {
      list.add(Supervisor(
        name: nameController.text,
        specialty: specController.text,
        projectCount: int.tryParse(countController.text) ?? 0,
      ));
    });
    nameController.clear();
    specController.clear();
    countController.clear();
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightGray,
      appBar: AppBar(
        backgroundColor: primaryBlue,
        foregroundColor: Colors.white,
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ElevatedButton.icon(
              onPressed: () => _showAddDialog(),
              icon: const Icon(Icons.add, size: 18),
              label: const Text("إضافة"),
              style: ElevatedButton.styleFrom(
                backgroundColor: purple,
                foregroundColor: Colors.white,
              ),
            ),
            const Text("إدارة المشرفين", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: ListView.builder(
          itemCount: list.length,
          itemBuilder: (context, index) {
            final supervisor = list[index];
            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: ListTile(
                contentPadding: const EdgeInsets.all(12),
                leading: CircleAvatar(
                  radius: 30,
                  backgroundColor: purple.withOpacity(0.1),
                  child: Icon(Icons.person, color: purple),
                ),
                title: Text(supervisor.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text(supervisor.specialty, style: const TextStyle(color: Colors.grey)),
                trailing: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: primaryBlue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text("${supervisor.projectCount} مشاريع", style: TextStyle(color: primaryBlue, fontWeight: FontWeight.bold)),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void _showAddDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("إضافة مشرف جديد", textAlign: TextAlign.right),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: nameController, decoration: const InputDecoration(labelText: "اسم المشرف"), textAlign: TextAlign.right),
            TextField(controller: specController, decoration: const InputDecoration(labelText: "التخصص"), textAlign: TextAlign.right),
            TextField(controller: countController, decoration: const InputDecoration(labelText: "عدد المشاريع"), keyboardType: TextInputType.number, textAlign: TextAlign.right),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("إلغاء")),
          ElevatedButton(
            onPressed: _addNewSupervisor, 
            style: ElevatedButton.styleFrom(backgroundColor: primaryBlue),
            child: const Text("حفظ", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}