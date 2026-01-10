



import 'Project_model.dart';

class ProjectRepository {
  // قائمة المشاريع
  static List<Project> projects = [
    Project(
      title: "تطبيق المتجر الإلكتروني",
      description: "تطبيق متكامل لبيع المنتجات عبر الإنترنت مع سلة تسوق.",
      date: "2023-10-15",
    ),
    Project(
      title: "نظام إدارة المدارس",
      description: "منصة لتنظيم جداول الطلاب والدرجات والمعلمين.",
      date: "2023-12-01",
    ),
    Project(
      title: "تطبيق توصيل طلبات",
      description: "تطبيق لربط المطاعم بالعملاء مع تتبع الخريطة.",
      date: "2024-01-20",
    ),
  ];
}