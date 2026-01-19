
import 'view/login_pages/login_page.dart';
import 'view/admin_pages/admin_dashboard_page.dart';

//super admin home pages
import 'view/Super_Admin/home_Super_Admin.dart';


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
  static const initial = login;

  // Super Admin route
  static const superAdmin = '/super-admin';


  // Main routes

  static const login = '/login';
  static const admin = '/admin';

  // User routes
  static const userDashboard = '/user/dashboard';
  static const myProjects = '/user/my-projects';
  static const newProject = '/user/new-project';
  static const notifications = '/user/notifications';
  static const profile = '/user/profile';
  static const projectDetails = '/user/project-details';
  static const planning = '/user/planning';
  static const pertChart = '/user/pert-chart';
  static const stoppedProjects = '/user/stopped-projects';

  static final routes = {
    // Main routes
    login: (_) => const LoginPage(),
    admin: (_) => const AdminDashboardPage(),
    //super admin routes
    superAdmin: (_) => const Super_Admin(),


    // User routes
    userDashboard: (_) => const DashboardScreen(),
    myProjects: (_) => const MyProjectsScreen(),
    newProject: (_) => const NewProjectScreen(),
    notifications: (_) => const NotificationsScreen(),
    profile: (_) => const ProfileScreen(),
    projectDetails: (_) => const ProjectDetailsScreen(
      projectTitle: 'مشروع',
      status: 'مقبول',
      progress: 0,
      commitment: '-',
    ),
    planning: (_) => const PlanningScreen(),
    pertChart: (_) => const PertChartScreen(),
    stoppedProjects: (_) => const StoppedProjectsScreen(),
  };
}