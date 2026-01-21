class AppConstants {
  // App Info
  static const String appName = 'Enjaz Pro';
  static const String appVersion = '1.0.0';
  
  // API Configuration
  static const String baseUrl = 'https://api.enjazpro.com'; // Replace with actual API URL
  static const String apiVersion = 'v1';
  static const Duration requestTimeout = Duration(seconds: 30);
  
  // Database
  static const String databaseName = 'enjaz_pro.db';
  static const int databaseVersion = 1;
  
  // Storage Keys
  static const String tokenKey = 'auth_token';
  static const String userKey = 'user_data';
  static const String languageKey = 'app_language';
  static const String themeKey = 'app_theme';
  
  // User Roles
  static const String superAdminRole = 'super_admin';
  static const String adminRole = 'admin';
  static const String userRole = 'user';
  
  // Project Status
  static const String projectStatusActive = 'active';
  static const String projectStatusCompleted = 'completed';
  static const String projectStatusPaused = 'paused';
  static const String projectStatusCancelled = 'cancelled';
  
  // Task Status
  static const String taskStatusTodo = 'todo';
  static const String taskStatusInProgress = 'in_progress';
  static const String taskStatusCompleted = 'completed';
  static const String taskStatusBlocked = 'blocked';
  
  // Task Priority
  static const String priorityLow = 'low';
  static const String priorityMedium = 'medium';
  static const String priorityHigh = 'high';
  static const String priorityCritical = 'critical';
  
  // File Types
  static const List<String> allowedImageTypes = ['jpg', 'jpeg', 'png', 'gif'];
  static const List<String> allowedDocumentTypes = ['pdf', 'doc', 'docx', 'xls', 'xlsx', 'ppt', 'pptx'];
  
  // Pagination
  static const int defaultPageSize = 20;
  static const int maxPageSize = 100;
}