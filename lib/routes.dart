
import 'package:get/get.dart';
import 'view/login_pages/login_page.dart';
import 'view/login_pages/register_page.dart';
import 'view/login_pages/forgot_password_page.dart';
import 'view/admin_pages/admin_dashboard_page.dart';
import 'view/super_admin/super_admin_page.dart';

// User pages imports
import 'view/user/lib/suer/dashboard.dart';
import 'view/user/lib/suer/my_projects.dart';
import 'view/user/lib/suer/new_project.dart';
import 'view/user/lib/suer/notifications.dart';
import 'view/user/lib/suer/profile.dart';
import 'view/user/lib/suer/project_details.dart';
import 'view/user/lib/suer/planning.dart';
import 'view/user/lib/suer/pert_chart.dart';
import 'view/user/lib/suer/stopped_projects.dart';

class AppRoutes {
  static const String initial = '/login';
  
  // Auth routes
  static const String login = '/login';
  static const String register = '/register';
  static const String forgotPassword = '/forgot-password';
  
  // Role-based routes
  static const String superAdmin = '/super-admin';
  static const String admin = '/admin';
  static const String user = '/user';

  // User sub-routes
  static const String userDashboard = '/user/dashboard';
  static const String myProjects = '/user/my-projects';
  static const String newProject = '/user/new-project';
  static const String notifications = '/user/notifications';
  static const String profile = '/user/profile';
  static const String projectDetails = '/user/project-details';
  static const String planning = '/user/planning';
  static const String pertChart = '/user/pert-chart';
  static const String stoppedProjects = '/user/stopped-projects';

  static List<GetPage> pages = [
    // Auth pages
    GetPage(
      name: login,
      page: () => const LoginPage(),
    ),
    GetPage(
      name: register,
      page: () => const RegisterPage(),
    ),
    GetPage(
      name: forgotPassword,
      page: () => const ForgotPasswordPage(),
    ),
    
    // Role-based pages
    GetPage(
      name: superAdmin,
      page: () => const SuperAdminPage(),
    ),
    GetPage(
      name: admin,
      page: () => const AdminDashboardPage(),
    ),
    GetPage(
      name: user,
      page: () => const DashboardScreen(),
    ),
    
    // User sub-pages
    GetPage(
      name: userDashboard,
      page: () => const DashboardScreen(),
    ),
    GetPage(
      name: myProjects,
      page: () => const MyProjectsScreen(),
    ),
    GetPage(
      name: newProject,
      page: () => const NewProjectScreen(),
    ),
    GetPage(
      name: notifications,
      page: () => const NotificationsScreen(),
    ),
    GetPage(
      name: profile,
      page: () => const ProfileScreen(),
    ),
    GetPage(
      name: projectDetails,
      page: () => const ProjectDetailsScreen(
        projectTitle: 'مشروع',
        status: 'مقبول',
        progress: 0,
        commitment: '-',
      ),
    ),
    GetPage(
      name: planning,
      page: () => const PlanningScreen(),
    ),
    GetPage(
      name: pertChart,
      page: () => const PertChartScreen(),
    ),
    GetPage(
      name: stoppedProjects,
      page: () => const StoppedProjectsScreen(),
    ),
  ];
}