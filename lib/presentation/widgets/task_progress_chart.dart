import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class TaskProgressChart extends StatelessWidget {
  final Map<String, int> taskData;
  final double size;

  const TaskProgressChart({
    super.key,
    required this.taskData,
    this.size = 200,
  });

  @override
  Widget build(BuildContext context) {
    final total = taskData.values.fold<int>(0, (sum, value) => sum + value);
    
    if (total == 0) {
      return Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.grey[200],
        ),
        child: const Center(
          child: Text(
            'No Tasks',
            style: TextStyle(
              color: Colors.grey,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      );
    }

    return SizedBox(
      width: size,
      height: size,
      child: PieChart(
        PieChartData(
          sectionsSpace: 2,
          centerSpaceRadius: size * 0.3,
          sections: _buildSections(),
        ),
      ),
    );
  }

  List<PieChartSectionData> _buildSections() {
    final total = taskData.values.fold<int>(0, (sum, value) => sum + value);
    final colors = {
      'completed': Colors.green,
      'in_progress': Colors.blue,
      'todo': Colors.orange,
      'blocked': Colors.red,
    };

    return taskData.entries.map((entry) {
      final percentage = (entry.value / total) * 100;
      return PieChartSectionData(
        color: colors[entry.key] ?? Colors.grey,
        value: entry.value.toDouble(),
        title: '${percentage.toStringAsFixed(1)}%',
        radius: 50,
        titleStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      );
    }).toList();
  }
}