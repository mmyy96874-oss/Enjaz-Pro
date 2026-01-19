import 'package:flutter/material.dart';

import 'Project_DataSurs.dart';


// استيراد صفحة البيانات

class ProjectListScreen extends StatefulWidget {
  @override
  State<ProjectListScreen> createState() => _ProjectListScreenState();
}

class _ProjectListScreenState extends State<ProjectListScreen> {
  @override
  Widget build(BuildContext context) {
    // الحصول على القائمة من كلاس البيانات
    final projectList = ProjectRepository.projects;

    return Scaffold(
      appBar: AppBar(
        title: Text("مشاريعي"),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
      ),
      body: ListView.builder(
        itemCount: projectList.length,
        itemBuilder: (context, index) {
          final project = projectList[index];

          return Card(
            margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            elevation: 3,
            child: ListTile(
              leading: Icon(Icons.work_outline, color: Colors.blue),
              title: Text(
                project.title,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 5),
                  Text(project.description),
                  SizedBox(height: 5),
                  Text(
                    "التاريخ: ${project.date}",
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  Container(height: 10,),

                  Row(
                    children: [
                      MaterialButton(

                        onPressed: () {

                        },
                        child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: Colors.green,



                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text("قبول"),
                            )
                        ),
                      ),
                      MaterialButton(onPressed: () {

                      },
                        child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: Colors.deepOrange,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text("رفض"),
                            )),
                      ),
                    ],
                  )
                ],
              ),
              isThreeLine: true, // للسماح بمساحة أكبر للوصف والتاريخ
              onTap: () {
                // يمكنك إضافة وظيفة عند الضغط على المشروع هنا
                print("تم اختيار: ${project.title}");
              },
            ),
          );
        },
      ),
    );
  }
}