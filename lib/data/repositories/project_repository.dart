import 'package:get/get.dart';
import 'package:uuid/uuid.dart';
import '../../core/services/api_service.dart';
import '../../core/services/database_service.dart';
import '../models/project_model.dart';

class ProjectRepository extends GetxService {
  final ApiService _apiService = ApiService();
  final DatabaseService _databaseService = DatabaseService();
  final Uuid _uuid = const Uuid();

  // Get all projects
  Future<List<ProjectModel>> getAllProjects({
    int? limit,
    int? offset,
    String? status,
    String? managerId,
  }) async {
    try {
      // Try API first
      final response = await _apiService.get('/projects', queryParameters: {
        if (limit != null) 'limit': limit,
        if (offset != null) 'offset': offset,
        if (status != null) 'status': status,
        if (managerId != null) 'manager_id': managerId,
      });

      if (response.statusCode == 200) {
        final List<dynamic> projectsData = response.data['projects'];
        final projects = projectsData.map((data) => ProjectModel.fromJson(data)).toList();
        
        // Save to local database
        for (final project in projects) {
          await _saveProjectToDatabase(project);
        }
        
        return projects;
      }
    } catch (e) {
      print('API error, falling back to local database: $e');
    }

    // Fallback to local database
    return await _getProjectsFromDatabase(
      limit: limit,
      offset: offset,
      status: status,
      managerId: managerId,
    );
  }

  // Get project by ID
  Future<ProjectModel?> getProjectById(String id) async {
    try {
      // Try API first
      final response = await _apiService.get('/projects/$id');
      
      if (response.statusCode == 200) {
        final project = ProjectModel.fromJson(response.data['project']);
        await _saveProjectToDatabase(project);
        return project;
      }
    } catch (e) {
      print('API error, falling back to local database: $e');
    }

    // Fallback to local database
    final projects = await _databaseService.query(
      'projects',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (projects.isNotEmpty) {
      return ProjectModel.fromDatabase(projects.first);
    }

    return null;
  }

  // Create new project
  Future<ProjectModel> createProject({
    required String name,
    String? description,
    required String status,
    required String priority,
    required DateTime startDate,
    DateTime? endDate,
    double? budget,
    required String managerId,
    required String createdBy,
  }) async {
    final now = DateTime.now();
    final project = ProjectModel(
      id: _uuid.v4(),
      name: name,
      description: description,
      status: status,
      priority: priority,
      startDate: startDate,
      endDate: endDate,
      budget: budget,
      managerId: managerId,
      createdBy: createdBy,
      createdAt: now,
      updatedAt: now,
    );

    try {
      // Try API first
      final response = await _apiService.post('/projects', data: project.toJson());
      
      if (response.statusCode == 201) {
        final createdProject = ProjectModel.fromJson(response.data['project']);
        await _saveProjectToDatabase(createdProject);
        return createdProject;
      }
    } catch (e) {
      print('API error, saving locally: $e');
    }

    // Fallback to local database
    await _saveProjectToDatabase(project);
    return project;
  }

  // Update project
  Future<ProjectModel> updateProject(ProjectModel project) async {
    final updatedProject = project.copyWith(updatedAt: DateTime.now());

    try {
      // Try API first
      final response = await _apiService.put('/projects/${project.id}', data: updatedProject.toJson());
      
      if (response.statusCode == 200) {
        final apiProject = ProjectModel.fromJson(response.data['project']);
        await _updateProjectInDatabase(apiProject);
        return apiProject;
      }
    } catch (e) {
      print('API error, updating locally: $e');
    }

    // Fallback to local database
    await _updateProjectInDatabase(updatedProject);
    return updatedProject;
  }

  // Delete project
  Future<void> deleteProject(String id) async {
    try {
      // Try API first
      await _apiService.delete('/projects/$id');
    } catch (e) {
      print('API error, deleting locally: $e');
    }

    // Delete from local database
    await _databaseService.delete('projects', where: 'id = ?', whereArgs: [id]);
    
    // Also delete related tasks
    await _databaseService.delete('tasks', where: 'project_id = ?', whereArgs: [id]);
    
    // Delete project members
    await _databaseService.delete('project_members', where: 'project_id = ?', whereArgs: [id]);
  }

  // Get projects by manager
  Future<List<ProjectModel>> getProjectsByManager(String managerId) async {
    return await getAllProjects(managerId: managerId);
  }

  // Get user's projects (as member)
  Future<List<ProjectModel>> getUserProjects(String userId) async {
    try {
      // Try API first
      final response = await _apiService.get('/users/$userId/projects');
      
      if (response.statusCode == 200) {
        final List<dynamic> projectsData = response.data['projects'];
        final projects = projectsData.map((data) => ProjectModel.fromJson(data)).toList();
        
        // Save to local database
        for (final project in projects) {
          await _saveProjectToDatabase(project);
        }
        
        return projects;
      }
    } catch (e) {
      print('API error, falling back to local database: $e');
    }

    // Fallback to local database - get projects where user is a member
    final projectMembers = await _databaseService.query(
      'project_members',
      where: 'user_id = ?',
      whereArgs: [userId],
    );

    final projectIds = projectMembers.map((pm) => pm['project_id']).toList();
    
    if (projectIds.isEmpty) return [];

    final projects = await _databaseService.query(
      'projects',
      where: 'id IN (${projectIds.map((_) => '?').join(',')})',
      whereArgs: projectIds,
    );

    return projects.map((data) => ProjectModel.fromDatabase(data)).toList();
  }

  // Add member to project
  Future<void> addProjectMember({
    required String projectId,
    required String userId,
    required String role,
  }) async {
    final memberData = {
      'id': _uuid.v4(),
      'project_id': projectId,
      'user_id': userId,
      'role': role,
      'joined_at': DateTime.now().toIso8601String(),
    };

    try {
      // Try API first
      await _apiService.post('/projects/$projectId/members', data: memberData);
    } catch (e) {
      print('API error, saving locally: $e');
    }

    // Save to local database
    await _databaseService.insert('project_members', memberData);
  }

  // Remove member from project
  Future<void> removeProjectMember({
    required String projectId,
    required String userId,
  }) async {
    try {
      // Try API first
      await _apiService.delete('/projects/$projectId/members/$userId');
    } catch (e) {
      print('API error, deleting locally: $e');
    }

    // Delete from local database
    await _databaseService.delete(
      'project_members',
      where: 'project_id = ? AND user_id = ?',
      whereArgs: [projectId, userId],
    );
  }

  // Get project statistics
  Future<Map<String, dynamic>> getProjectStats(String projectId) async {
    try {
      // Try API first
      final response = await _apiService.get('/projects/$projectId/stats');
      
      if (response.statusCode == 200) {
        return response.data['stats'];
      }
    } catch (e) {
      print('API error, calculating locally: $e');
    }

    // Calculate from local database
    final tasks = await _databaseService.query(
      'tasks',
      where: 'project_id = ?',
      whereArgs: [projectId],
    );

    final totalTasks = tasks.length;
    final completedTasks = tasks.where((t) => t['status'] == 'completed').length;
    final inProgressTasks = tasks.where((t) => t['status'] == 'in_progress').length;
    final todoTasks = tasks.where((t) => t['status'] == 'todo').length;
    final blockedTasks = tasks.where((t) => t['status'] == 'blocked').length;

    final totalEstimatedHours = tasks
        .where((t) => t['estimated_hours'] != null)
        .fold<double>(0, (sum, t) => sum + (t['estimated_hours'] as double));

    final totalActualHours = tasks
        .where((t) => t['actual_hours'] != null)
        .fold<double>(0, (sum, t) => sum + (t['actual_hours'] as double));

    return {
      'total_tasks': totalTasks,
      'completed_tasks': completedTasks,
      'in_progress_tasks': inProgressTasks,
      'todo_tasks': todoTasks,
      'blocked_tasks': blockedTasks,
      'completion_percentage': totalTasks > 0 ? (completedTasks / totalTasks * 100) : 0,
      'total_estimated_hours': totalEstimatedHours,
      'total_actual_hours': totalActualHours,
    };
  }

  // Helper methods
  Future<List<ProjectModel>> _getProjectsFromDatabase({
    int? limit,
    int? offset,
    String? status,
    String? managerId,
  }) async {
    String? where;
    List<dynamic>? whereArgs;

    if (status != null || managerId != null) {
      final conditions = <String>[];
      whereArgs = <dynamic>[];

      if (status != null) {
        conditions.add('status = ?');
        whereArgs.add(status);
      }

      if (managerId != null) {
        conditions.add('manager_id = ?');
        whereArgs.add(managerId);
      }

      where = conditions.join(' AND ');
    }

    final projects = await _databaseService.query(
      'projects',
      where: where,
      whereArgs: whereArgs,
      orderBy: 'created_at DESC',
      limit: limit,
      offset: offset,
    );

    return projects.map((data) => ProjectModel.fromDatabase(data)).toList();
  }

  Future<void> _saveProjectToDatabase(ProjectModel project) async {
    await _databaseService.insert('projects', project.toDatabase());
  }

  Future<void> _updateProjectInDatabase(ProjectModel project) async {
    await _databaseService.update(
      'projects',
      project.toDatabase(),
      where: 'id = ?',
      whereArgs: [project.id],
    );
  }
}