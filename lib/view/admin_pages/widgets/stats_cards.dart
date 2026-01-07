import 'package:flutter/material.dart';

class StatsCards extends StatelessWidget {
  const StatsCards({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _StatCard(
                  title: 'قيد التنفيذ',
                  count: '3',
                  icon: Icons.checklist,
                  color: Colors.green, // Green from image
                ),
              ),
              const SizedBox(width: 10), // Reduced from 12
              Expanded(
                child: _StatCard(
                  title: 'مشاريع مستحدثة',
                  count: '5',
                  icon: Icons.trending_up,
                  color: const Color(0xFF3B82F6), // Blue from image
                ),
              ),
            ],
          ),
          const SizedBox(height: 10), // Reduced from 12
          Row(
            children: [
              Expanded(
                child: _StatCard(
                  title: 'مشاريع منتهية',
                  count: '12',
                  icon: Icons.emoji_events,
                  color: const Color(0xFFF59E0B), // Orange/Yellow from image
                ),
              ),
              const SizedBox(width: 10), // Reduced from 12
              Expanded(
                child: _StatCard(
                  title: 'اجتماعات قادمة',
                  count: '8',
                  icon: Icons.event_available,
                  color: const Color(0xFF8B5CF6), // Purple from image
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String count;
  final IconData icon;
  final Color color;

  const _StatCard({
    required this.title,
    required this.count,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Show details for this stat
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('$title: $count'),
            duration: const Duration(seconds: 1),
          ),
        );
      },
      child: Container(
        height: 100, // Reduced from 120
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(12), // Reduced from 16
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.3),
              blurRadius: 6, // Reduced from 8
              offset: const Offset(0, 3), // Reduced from 4
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(12), // Reduced from 16
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                icon,
                color: Colors.white,
                size: 24, // Reduced from 32
              ),
              const Spacer(),
              Text(
                count,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 22, // Reduced from 28
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 2), // Reduced from 4
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12, // Reduced from 14
                  fontWeight: FontWeight.w500,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}