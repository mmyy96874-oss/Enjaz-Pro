import 'package:flutter/material.dart';
import 'widgets/dashboard_header.dart';
import 'widgets/stats_cards.dart';
import 'widgets/projects_section.dart';
import 'widgets/meetings_section.dart';
import 'widgets/tasks_section.dart';
import 'widgets/notifications_section.dart';

class AdminDashboardPage extends StatefulWidget {
  const AdminDashboardPage({super.key});

  @override
  State<AdminDashboardPage> createState() => _AdminDashboardPageState();
}

class _AdminDashboardPageState extends State<AdminDashboardPage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const DashboardHome(),
    const ProjectsPage(),
    const MeetingsPage(),
    const TasksPage(),
    const NotificationsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        body: _pages[_selectedIndex],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: (index) {
            setState(() => _selectedIndex = index);
            // Show which tab was selected
            final tabNames = ['الرئيسية', 'المشاريع', 'الاجتماعات', 'المهام', 'الإشعارات'];
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('تم الانتقال إلى: ${tabNames[index]}'),
                duration: const Duration(milliseconds: 800),
              ),
            );
          },
          type: BottomNavigationBarType.fixed,
          selectedItemColor: const Color(0xFF6366F1), // Purple-blue from image
          unselectedItemColor: Colors.grey[600],
          backgroundColor: Colors.white,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.dashboard),
              label: 'الرئيسية',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.folder_outlined),
              label: 'المشاريع',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.calendar_today),
              label: 'الاجتماعات',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.task_alt),
              label: 'المهام',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.notifications),
              label: 'الإشعارات',
            ),
          ],
        ),
      ),
    );
  }
}

class DashboardHome extends StatelessWidget {
  const DashboardHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Header as a sliver
          SliverToBoxAdapter(
            child: const DashboardHeader(),
          ),
          // Content with proper spacing
          SliverPadding(
            padding: const EdgeInsets.only(top: 12, bottom: 20),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                const StatsCards(),
                const SizedBox(height: 16),
                const ProjectsSection(),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}

// Placeholder pages for other tabs
class ProjectsPage extends StatelessWidget {
  const ProjectsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('صفحة المشاريع'),
      ),
    );
  }
}

class MeetingsPage extends StatelessWidget {
  const MeetingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const MeetingsSection();
  }
}

class TasksPage extends StatelessWidget {
  const TasksPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const TasksSection();
  }
}

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const NotificationsSection();
  }
}