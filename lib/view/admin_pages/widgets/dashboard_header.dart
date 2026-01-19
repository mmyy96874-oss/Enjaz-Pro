import 'package:flutter/material.dart';

class DashboardHeader extends StatelessWidget {
  const DashboardHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFF6366F1), // Purple-blue color from the image
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16), // Reduced from 20
          child: Row(
            children: [
              // Profile Avatar
              Container(
                width: 40, // Reduced from 50
                height: 40, // Reduced from 50
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20), // Reduced from 25
                ),
                child: const Icon(
                  Icons.person,
                  color: Colors.white,
                  size: 24, // Reduced from 28
                ),
              ),
              const SizedBox(width: 12), // Reduced from 16
              
              // User Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'د خالد العمري',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16, // Reduced from 18
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Text(
                      'مشرف - قسم علوم الحاسب',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 12, // Reduced from 14
                      ),
                    ),
                  ],
                ),
              ),
              
              // Notification Badge
              Stack(
                children: [
                  IconButton(
                    onPressed: () {
                      // Navigate to notifications or show notification panel
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('عرض الإشعارات'),
                          duration: Duration(seconds: 1),
                        ),
                      );
                    },
                    icon: const Icon(
                      Icons.notifications_outlined,
                      color: Colors.white,
                      size: 24, // Reduced from 28
                    ),
                  ),
                  Positioned(
                    right: 6,
                    top: 6,
                    child: Container(
                      width: 18,
                      height: 18,
                      decoration: BoxDecoration(
                        color: Colors.red[600],
                        borderRadius: BorderRadius.circular(9),
                      ),
                      child: const Center(
                        child: Text(
                          '5',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}