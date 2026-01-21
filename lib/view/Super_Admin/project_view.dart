import 'package:flutter/material.dart';
import 'project_data_source.dart';

class ProjectListScreen extends StatefulWidget {
  @override
  State<ProjectListScreen> createState() => _ProjectListScreenState();
}

class _ProjectListScreenState extends State<ProjectListScreen> {
  // Consistent colors with the app theme
  static const Color primaryBlue = Color(0xFF6366F1);
  static const Color successGreen = Color(0xFF10B981);
  static const Color errorRed = Color(0xFFEF4444);
  static const Color lightGray = Color(0xFFF8F9FA);

  @override
  Widget build(BuildContext context) {
    final projectList = ProjectRepository.projects;

    return Scaffold(
      backgroundColor: lightGray,
      appBar: AppBar(
        title: const Text("مشاريعي"),
        centerTitle: true,
        backgroundColor: primaryBlue,
        foregroundColor: Colors.white,
      ),
      body: ListView.builder(
        itemCount: projectList.length,
        itemBuilder: (context, index) {
          final project = projectList[index];

          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: primaryBlue,
                child: const Icon(Icons.work_outline, color: Colors.white),
              ),
              title: Text(
                project.title,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 5),
                  Text(project.description),
                  const SizedBox(height: 5),
                  Text(
                    "التاريخ: ${project.date}",
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: successGreen,
                          foregroundColor: Colors.white,
                          minimumSize: const Size(60, 30),
                        ),
                        child: const Text("قبول", style: TextStyle(fontSize: 12)),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: errorRed,
                          foregroundColor: Colors.white,
                          minimumSize: const Size(60, 30),
                        ),
                        child: const Text("رفض", style: TextStyle(fontSize: 12)),
                      ),
                    ],
                  )
                ],
              ),
              isThreeLine: true,
              onTap: () {
                print("تم اختيار: ${project.title}");
              },
            ),
          );
        },
      ),
    );
  }
}