import 'view/home_pages/home.dart';
import 'view/login_pages/login_page.dart';
import 'view/admin_pages/admin_dashboard_page.dart';

class AppRoutes {
  static const initial = login;

  static const home = '/home';
  static const login = '/login';
  static const admin = '/admin';

  static final routes = {
    home: (_) => const HomePage(),
    login: (_) => const LoginPage(),
    admin: (_) => const AdminDashboardPage(),
  }; 
}
