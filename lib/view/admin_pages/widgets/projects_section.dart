import 'package:flutter/material.dart';

class ProjectsSection extends StatelessWidget {
  const ProjectsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              const Icon(
                Icons.folder_outlined,
                color: Colors.blue,
                size: 20, // Reduced from 24
              ),
              const SizedBox(width: 6), // Reduced from 8
              const Text(
                'المشاريع المكلف بالإشراف عليها',
                style: TextStyle(
                  fontSize: 16, // Reduced from 18
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              TextButton(
                onPressed: () {
                  // Show all projects
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('عرض جميع المشاريع'),
                      duration: Duration(seconds: 1),
                    ),
                  );
                },
                child: const Text(
                  'عرض الكل',
                  style: TextStyle(fontSize: 12), // Reduced font size
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12), // Reduced from 16
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: const [
              ProjectCard(
                title: 'نظام إدارة المكتبة',
                supervisor: 'أحمد محمد سارة خالد محمد علي',
                type: 'المشروع ومتطلبات',
                progress: 0.6,
                progressText: '60%',
                status: 'جاري التنفيذ',
                statusColor: Color(0xFF3B82F6), // Blue color from image
              ),
              SizedBox(height: 12), // Reduced spacing
              ProjectCard(
                title: 'تطبيق التجارة الإلكترونية',
                supervisor: 'فاطمة علي نورا محمد',
                type: 'المشروع ومتطلبات',
                progress: 0.25,
                progressText: '25%',
                status: 'مرحلة التخطيط',
                statusColor: Color(0xFF10B981), // Green color from image
              ),
              SizedBox(height: 12), // Reduced spacing
              ProjectCard(
                title: 'نظام إدارة الموارد البشرية',
                supervisor: 'عبدالله حسن ريم أحمد',
                type: 'المشروع صحيح',
                progress: 0.45,
                progressText: '45%',
                status: 'جاري التنفيذ',
                statusColor: Color(0xFF8B5CF6), // Purple color from image
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class ProjectCard extends StatelessWidget {
  final String title;
  final String supervisor;
  final String type;
  final double progress;
  final String progressText;
  final String status;
  final Color statusColor;

  const ProjectCard({
    super.key,
    required this.title,
    required this.supervisor,
    required this.type,
    required this.progress,
    required this.progressText,
    required this.status,
    required this.statusColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10), // Further reduced from 12
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10), // Reduced from 12
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.08), // Lighter shadow
            blurRadius: 4, // Reduced from 6
            offset: const Offset(0, 1), // Reduced from 2
          ),
        ],
      ),
      child: IntrinsicHeight(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header row with status and menu
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2), // Further reduced
                  decoration: BoxDecoration(
                    color: statusColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    status,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 9, // Further reduced from 10
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () {},
                  child: Icon(
                    Icons.more_vert,
                    size: 16, // Reduced from 18
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4), // Reduced from 6
            
            // Title
            Text(
              title,
              style: const TextStyle(
                fontSize: 13, // Reduced from 14
                fontWeight: FontWeight.bold,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 3), // Reduced from 4
            
            // Team info
            Text(
              'الفريق: $supervisor',
              style: TextStyle(
                fontSize: 10, // Reduced from 11
                color: Colors.grey[600],
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 2), // Reduced
            
            // Type info
            Text(
              'نوع $type',
              style: TextStyle(
                fontSize: 10, // Reduced from 11
                color: Colors.grey[600],
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 6), // Reduced from 8
            
            // Progress section
            Row(
              children: [
                Text(
                  'نسبة الإنجاز',
                  style: TextStyle(
                    fontSize: 10, // Reduced from 11
                    color: Colors.grey[600],
                  ),
                ),
                const Spacer(),
                Text(
                  progressText,
                  style: const TextStyle(
                    fontSize: 10, // Reduced from 11
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 3), // Reduced from 4
            LinearProgressIndicator(
              value: progress,
              backgroundColor: Colors.grey[200],
              valueColor: AlwaysStoppedAnimation<Color>(statusColor),
              minHeight: 2, // Reduced from 3
            ),
            const SizedBox(height: 6), // Reduced from 8
            
            // Action buttons
            Row(
              children: [
                _ActionButton(
                  icon: Icons.play_circle_outline,
                  color: Colors.green[600]!,
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('بدء المشروع'),
                        duration: Duration(seconds: 1),
                      ),
                    );
                  },
                ),
                const SizedBox(width: 4), // Reduced from 6
                _ActionButton(
                  icon: Icons.calendar_today,
                  color: Colors.purple[600]!,
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('جدولة اجتماع'),
                        duration: Duration(seconds: 1),
                      ),
                    );
                  },
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('عرض تفاصيل: $title'),
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3), // Further reduced
                    decoration: BoxDecoration(
                      color: const Color(0xFF6366F1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.visibility,
                          color: Colors.white,
                          size: 11, // Reduced from 12
                        ),
                        SizedBox(width: 2), // Reduced from 3
                        Text(
                          'متابعة التفاصيل',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 9, // Reduced from 10
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onPressed;

  const _ActionButton({
    required this.icon,
    required this.color,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 24, // Further reduced from 28
      height: 24, // Further reduced from 28
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(4), // Reduced from 6
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(4),
          child: Icon(
            icon,
            color: Colors.white,
            size: 12, // Reduced from 14
          ),
        ),
      ),
    );
  }
}