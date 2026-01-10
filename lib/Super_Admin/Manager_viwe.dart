import 'package:flutter/material.dart';

import 'Manager_DataSurs.dart';
import 'Manager_model.dart';




class SupervisorScreen extends StatefulWidget {
  @override
  _SupervisorScreenState createState() => _SupervisorScreenState();
}

class _SupervisorScreenState extends State<SupervisorScreen> {
  // مصفوفة محلية لتحديث الواجهة عند الإضافة
  List<Supervisor> list = SupervisorProvider.supervisors;

  // دوال التحكم بالنصوص
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
    // مسح الحقول بعد الإضافة
    nameController.clear();
    specController.clear();
    countController.clear();
    Navigator.of(context).pop(); // إغلاق النافذة
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ElevatedButton.icon(
              onPressed: () => _showAddDialog(),
              icon: Icon(Icons.add, size: 18),
              label: Text("إضافة"),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.purpleAccent),
            ),
            Text("إدارة المشرفين", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
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
              margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              child: ListTile(
                contentPadding: EdgeInsets.all(12),
                leading: CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.purple[50],
                  child: Icon(Icons.person, color: Colors.purple),
                ),
                title: Text(supervisor.name, style: TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text(supervisor.specialty, style: TextStyle(color: Colors.grey)),
                trailing: Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text("${supervisor.projectCount} مشاريع", style: TextStyle(color: Colors.blue[800])),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  // نافذة الإضافة
  void _showAddDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("إضافة مشرف جديد", textAlign: TextAlign.right),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: nameController, decoration: InputDecoration(labelText: "اسم المشرف"), textAlign: TextAlign.right),
            TextField(controller: specController, decoration: InputDecoration(labelText: "التخصص"), textAlign: TextAlign.right),
            TextField(controller: countController, decoration: InputDecoration(labelText: "عدد المشاريع"), keyboardType: TextInputType.number, textAlign: TextAlign.right),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text("إلغاء")),
          ElevatedButton(onPressed: _addNewSupervisor, child: Text("حفظ")),
        ],
      ),
    );
  }
}