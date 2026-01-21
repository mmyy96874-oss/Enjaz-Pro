import 'package:get/get.dart';
import 'package:uuid/uuid.dart';
import '../../core/services/api_service.dart';
import '../../core/services/database_service.dart';
import '../models/task_model.dart';

class TaskRepository extends GetxService {
  final ApiService _apiService = ApiService();
  final DatabaseService _databaseService = DatabaseService();
  final Uuid _uuid = const Uuid();

  // Get tasks by project
  Future<List<TaskModel>> getTasksByProject(String projectId) async {
    try {
      // Try API first
      final response = await _apiService.get('/projects/$projectId/tasks');
      
      if (response.statusCode == 200) {
        final List<dynamic> tasksData = response.data['tasks'];
        final tasks = tasksData.map((data) => TaskModel.fromJson(data)).toList();
        
        // Save to local database
        for (final task in tasks) {
          await _saveTaskToDatabase(task);
        }
        
        return tasks;
      }
    } catch (e) {
      print('API error, falling back to local database: $e');
    }

    // Fallback to local database
    final tasks = await _databaseService.query(
      'tasks',
      where: 'project_id = ?',
      whereArgs: [projectId],
      orderBy: 'created_at DESC',
    );

    return tasks.map((data) => TaskModel.fromDatabase(data)).toList();
  }

  // Get tasks assigned to user
  Future<List<TaskModel>> getTasksByUser(String userId) async {
    try {
      // Try API first
      final response = await _apiService.get('/users/$userId/tasks');
      
      if (response.statusCode == 200) {
        final List<dynamic> tasksData = response.data['tasks'];
        final tasks = tasksData.map((data) => TaskModel.fromJson(data)).toList();
        
        // Save to local database
        for (final task in tasks) {
          await _saveTaskToDatabase(task);
        }
        
        return tasks;
      }
    } catch (e) {
      print('API error, falling back to local database: $e');
    }

    // Fallback to local database
    final tasks = await _databaseService.query(
      'tasks',
      where: 'assigned_to = ?',
      whereArgs: [userId],
      orderBy: 'created_at DESC',
    );

    return tasks.map((data) => TaskModel.fromDatabase(data)).toList();
  }

  // Create new task
  Future<TaskModel> createTask({
    required String title,
    String? description,
    required String status,
    required String priority,
    required String projectId,
    String? assignedTo,
    required String createdBy,
    DateTime? startDate,
    DateTime? dueDate,
    double? estimatedHours,
  }) async {
    final now = DateTime.now();
    final task = TaskModel(
      id: _uuid.v4(),
      title: title,
      description: description,
      status: status,
      priority: priority,
      projectId: projectId,
      assignedTo: assignedTo,
      createdBy: createdBy,
      startDate: startDate,
      dueDate: dueDate,
      estimatedHours: estimatedHours,
      createdAt: now,
      updatedAt: now,
    );

    try {
      // Try API first
      final response = await _apiService.post('/tasks', data: task.toJson());
      
      if (response.statusCode == 201) {
        final createdTask = TaskModel.fromJson(response.data['task']);
        await _saveTaskToDatabase(createdTask);
        return createdTask;
      }
    } catch (e) {
      print('API error, saving locally: $e');
    }

    // Fallback to local database
    await _saveTaskToDatabase(task);
    return task;
  }

  // Update task
  Future<TaskModel> updateTask(TaskModel task) async {
    final updatedTask = task.copyWith(updatedAt: DateTime.now());

    try {
      // Try API first
      final response = await _apiService.put('/tasks/${task.id}', data: updatedTask.toJson());
      
      if (response.statusCode == 200) {
        final apiTask = TaskModel.fromJson(response.data['task']);
        await _updateTaskInDatabase(apiTask);
        return apiTask;
      }
    } catch (e) {
      print('API error, updating locally: $e');
    }

    // Fallback to local database
    await _updateTaskInDatabase(updatedTask);
    return updatedTask;
  }

  // Delete task
  Future<void> deleteTask(String id) async {
    try {
      // Try API first
      await _apiService.delete('/tasks/$id');
    } catch (e) {
      print('API error, deleting locally: $e');
    }

    // Delete from local database
    await _databaseService.delete('tasks', where: 'id = ?', whereArgs: [id]);
  }

  // Update task status
  Future<TaskModel> updateTaskStatus(String taskId, String status) async {
    final tasks = await _databaseService.query(
      'tasks',
      where: 'id = ?',
      whereArgs: [taskId],
    );

    if (tasks.isEmpty) {
      throw Exception('Task not found');
    }

    final task = TaskModel.fromDatabase(tasks.first);
    final updatedTask = task.copyWith(
      status: status,
      completedAt: status == 'completed' ? DateTime.now() : null,
      progress: status == 'completed' ? 100.0 : task.progress,
      updatedAt: DateTime.now(),
    );

    return await updateTask(updatedTask);
  }

  // Update task progress
  Future<TaskModel> updateTaskProgress(String taskId, double progress) async {
    final tasks = await _databaseService.query(
      'tasks',
      where: 'id = ?',
      whereArgs: [taskId],
    );

    if (tasks.isEmpty) {
      throw Exception('Task not found');
    }

    final task = TaskModel.fromDatabase(tasks.first);
    String newStatus = task.status;
    DateTime? completedAt = task.completedAt;

    // Auto-update status based on progress
    if (progress >= 100.0) {
      newStatus = 'completed';
      completedAt = DateTime.now();
    } else if (progress > 0.0 && task.status == 'todo') {
      newStatus = 'in_progress';
    }

    final updatedTask = task.copyWith(
      progress: progress,
      status: newStatus,
      completedAt: completedAt,
      updatedAt: DateTime.now(),
    );

    return await updateTask(updatedTask);
  }

  // Get task statistics for a project
  Future<Map<String, dynamic>> getTaskStats(String projectId) async {
    final tasks = await getTasksByProject(projectId);

    final totalTasks = tasks.length;
    final completedTasks = tasks.where((t) => t.isCompleted).length;
    final inProgressTasks = tasks.where((t) => t.isInProgress).length;
    final todoTasks = tasks.where((t) => t.isTodo).length;
    final blockedTasks = tasks.where((t) => t.isBlocked).length;
    final overdueTasks = tasks.where((t) => t.isOverdue).length;

    final totalEstimatedHours = tasks
        .where((t) => t.estimatedHours != null)
        .fold<double>(0, (sum, t) => sum + t.estimatedHours!);

    final totalActualHours = tasks
        .where((t) => t.actualHours != null)
        .fold<double>(0, (sum, t) => sum + t.actualHours!);

    final averageProgress = totalTasks > 0 
        ? tasks.fold<double>(0, (sum, t) => sum + t.progress) / totalTasks
        : 0.0;

    return {
      'total_tasks': totalTasks,
      'completed_tasks': completedTasks,
      'in_progress_tasks': inProgressTasks,
      'todo_tasks': todoTasks,
      'blocked_tasks': blockedTasks,
      'overdue_tasks': overdueTasks,
      'completion_percentage': totalTasks > 0 ? (completedTasks / totalTasks * 100) : 0,
      'average_progress': averageProgress,
      'total_estimated_hours': totalEstimatedHours,
      'total_actual_hours': totalActualHours,
      'efficiency_ratio': totalEstimatedHours > 0 ? totalEstimatedHours / totalActualHours : 1.0,
    };
  }

  // Helper methods
  Future<void> _saveTaskToDatabase(TaskModel task) async {
    await _databaseService.insert('tasks', task.toDatabase());
  }

  Future<void> _updateTaskInDatabase(TaskModel task) async {
    await _databaseService.update(
      'tasks',
      task.toDatabase(),
      where: 'id = ?',
      whereArgs: [task.id],
    );
  }
}