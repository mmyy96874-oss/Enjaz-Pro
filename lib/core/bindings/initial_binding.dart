import 'package:get/get.dart';
import '../../core/services/storage_service.dart';
import '../../core/services/database_service.dart';
import '../../core/services/notification_service.dart';
import '../../data/repositories/auth_repository.dart';
import '../../data/repositories/project_repository.dart';
import '../../data/repositories/task_repository.dart';
import '../../presentation/controllers/auth_controller.dart';
import '../../presentation/controllers/project_controller.dart';
import '../../presentation/controllers/task_controller.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    // Initialize core services
    Get.putAsync<StorageService>(() async {
      final service = StorageService();
      await service.init();
      return service;
    }, permanent: true);
    
    Get.putAsync<DatabaseService>(() async {
      final service = DatabaseService();
      await service.initDatabase(); // Initialize database
      return service;
    }, permanent: true);
    
    Get.putAsync<NotificationService>(() async {
      final service = NotificationService();
      await service.onInit(); // Initialize notifications
      return service;
    }, permanent: true);
    
    // Initialize repositories
    Get.lazyPut<AuthRepository>(() => AuthRepository(), fenix: true);
    Get.lazyPut<ProjectRepository>(() => ProjectRepository(), fenix: true);
    Get.lazyPut<TaskRepository>(() => TaskRepository(), fenix: true);
    
    // Initialize controllers
    Get.lazyPut<AuthController>(() => AuthController(), fenix: true);
    Get.lazyPut<ProjectController>(() => ProjectController(), fenix: true);
    Get.lazyPut<TaskController>(() => TaskController(), fenix: true);
  }
}