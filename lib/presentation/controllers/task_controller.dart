import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/utils/app_utils.dart';
import '../../data/models/task_model.dart';
import '../../data/repositories/task_repository.dart';
import 'auth_controller.dart';

class TaskController extends GetxController {
  final TaskRepository _taskRepository = Get.find<TaskRepository>();
  final AuthController _authController = Get.find<AuthController>();
  
  // Observable variables
  final RxList<TaskModel> tasks = <TaskModel>[].obs;
  final RxList<TaskModel> userTasks = <TaskModel>[].obs;
  final Rx<TaskModel?> selectedTask = Rx<TaskModel?>(null);
  final RxBool isLoading = false.obs;
  final RxBool isCreating = false.obs;
  final RxMap<String, dynamic> taskStats = <String, dynamic>{}.obs;
  
  // Form controllers
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final estimatedHoursController = TextEditingController();
  
  // Form variables
  final Rx<String> selectedStatus = 'todo'.obs;
  final Rx<String> selectedPriority = 'medium'.obs;
  final Rx<DateTime?> startDate = Rx<DateTime?>(null);
  final Rx<DateTime?> dueDate = Rx<DateTime?>(null);
  final Rx<String?> selectedAssignee = Rx<String?>(null);
  final Rx<String?> selectedProjectId = Rx<String?>(null);
  
  // Form key
  final taskFormKey = GlobalKey<FormState>();
  
  // Filter variables
  final Rx<String> filterStatus = 'all'.obs;
  final Rx<String> filterPriority = 'all'.obs;
  final RxString searchQuery = ''.obs;
  
  @override
  void onInit() {
    super.onInit();
    loadUserTasks();
  }
  
  @override
  void onClose() {
    titleController.dispose();
    descriptionController.dispose();
    estimatedHoursController.dispose();
    super.onClose();
  }
  
  // Load tasks for current user
  Future<void> loadUserTasks() async {
    final currentUser = _authController.currentUser.value;
    if (currentUser == null) return;
    
    try {
      isLoading.value = true;
      
      final loadedTasks = await _taskRepository.getTasksByUser(currentUser.id);
      userTasks.value = loadedTasks;
      
    } catch (e) {
      AppUtils.showErrorMessage('Failed to load tasks: $e');
    } finally {
      isLoading.value = false;
    }
  }
  
  // Load tasks by project
  Future<void> loadTasksByProject(String projectId) async {
    try {
      isLoading.value = true;
      
      final loadedTasks = await _taskRepository.getTasksByProject(projectId);
      tasks.value = loadedTasks;
      
      // Load task statistics
      await loadTaskStats(projectId);
      
    } catch (e) {
      AppUtils.showErrorMessage('Failed to load project tasks: $e');
    } finally {
      isLoading.value = false;
    }
  }
  
  // Create new task
  Future<void> createTask() async {
    if (!taskFormKey.currentState!.validate()) return;
    
    final currentUser = _authController.currentUser.value;
    if (currentUser == null || selectedProjectId.value == null) return;
    
    try {
      isCreating.value = true;
      
      final task = await _taskRepository.createTask(
        title: titleController.text.trim(),
        description: descriptionController.text.trim().isEmpty 
            ? null 
            : descriptionController.text.trim(),
        status: selectedStatus.value,
        priority: selectedPriority.value,
        projectId: selectedProjectId.value!,
        assignedTo: selectedAssignee.value,
        createdBy: currentUser.id,
        startDate: startDate.value,
        dueDate: dueDate.value,
        estimatedHours: estimatedHoursController.text.trim().isEmpty 
            ? null 
            : double.tryParse(estimatedHoursController.text.trim()),
      );
      
      // Add to appropriate lists
      tasks.add(task);
      if (task.assignedTo == currentUser.id) {
        userTasks.add(task);
      }
      
      AppUtils.showSuccessMessage('Task created successfully');
      Get.back();
      clearForm();
      
    } catch (e) {
      AppUtils.showErrorMessage('Failed to create task: $e');
    } finally {
      isCreating.value = false;
    }
  }
  
  // Update task
  Future<void> updateTask(TaskModel task) async {
    try {
      isLoading.value = true;
      
      final updatedTask = await _taskRepository.updateTask(task);
      
      // Update in lists
      final taskIndex = tasks.indexWhere((t) => t.id == task.id);
      if (taskIndex != -1) {
        tasks[taskIndex] = updatedTask;
      }
      
      final userTaskIndex = userTasks.indexWhere((t) => t.id == task.id);
      if (userTaskIndex != -1) {
        userTasks[userTaskIndex] = updatedTask;
      }
      
      if (selectedTask.value?.id == task.id) {
        selectedTask.value = updatedTask;
      }
      
      AppUtils.showSuccessMessage('Task updated successfully');
      
    } catch (e) {
      AppUtils.showErrorMessage('Failed to update task: $e');
    } finally {
      isLoading.value = false;
    }
  }
  
  // Update task status
  Future<void> updateTaskStatus(String taskId, String status) async {
    try {
      final updatedTask = await _taskRepository.updateTaskStatus(taskId, status);
      
      // Update in lists
      final taskIndex = tasks.indexWhere((t) => t.id == taskId);
      if (taskIndex != -1) {
        tasks[taskIndex] = updatedTask;
      }
      
      final userTaskIndex = userTasks.indexWhere((t) => t.id == taskId);
      if (userTaskIndex != -1) {
        userTasks[userTaskIndex] = updatedTask;
      }
      
      if (selectedTask.value?.id == taskId) {
        selectedTask.value = updatedTask;
      }
      
      AppUtils.showSuccessMessage('Task status updated');
      
    } catch (e) {
      AppUtils.showErrorMessage('Failed to update task status: $e');
    }
  }
  
  // Update task progress
  Future<void> updateTaskProgress(String taskId, double progress) async {
    try {
      final updatedTask = await _taskRepository.updateTaskProgress(taskId, progress);
      
      // Update in lists
      final taskIndex = tasks.indexWhere((t) => t.id == taskId);
      if (taskIndex != -1) {
        tasks[taskIndex] = updatedTask;
      }
      
      final userTaskIndex = userTasks.indexWhere((t) => t.id == taskId);
      if (userTaskIndex != -1) {
        userTasks[userTaskIndex] = updatedTask;
      }
      
      if (selectedTask.value?.id == taskId) {
        selectedTask.value = updatedTask;
      }
      
      AppUtils.showSuccessMessage('Task progress updated');
      
    } catch (e) {
      AppUtils.showErrorMessage('Failed to update task progress: $e');
    }
  }
  
  // Delete task
  Future<void> deleteTask(String taskId) async {
    try {
      isLoading.value = true;
      
      await _taskRepository.deleteTask(taskId);
      
      // Remove from lists
      tasks.removeWhere((t) => t.id == taskId);
      userTasks.removeWhere((t) => t.id == taskId);
      
      if (selectedTask.value?.id == taskId) {
        selectedTask.value = null;
      }
      
      AppUtils.showSuccessMessage('Task deleted successfully');
      
    } catch (e) {
      AppUtils.showErrorMessage('Failed to delete task: $e');
    } finally {
      isLoading.value = false;
    }
  }
  
  // Select task
  void selectTask(TaskModel task) {
    selectedTask.value = task;
  }
  
  // Load task statistics
  Future<void> loadTaskStats(String projectId) async {
    try {
      final stats = await _taskRepository.getTaskStats(projectId);
      taskStats.value = stats;
    } catch (e) {
      print('Failed to load task stats: $e');
    }
  }
  
  // Filtered tasks
  List<TaskModel> get filteredTasks {
    var filtered = userTasks.where((task) {
      // Status filter
      if (filterStatus.value != 'all' && task.status != filterStatus.value) {
        return false;
      }
      
      // Priority filter
      if (filterPriority.value != 'all' && task.priority != filterPriority.value) {
        return false;
      }
      
      // Search query
      if (searchQuery.value.isNotEmpty) {
        final query = searchQuery.value.toLowerCase();
        return task.title.toLowerCase().contains(query) ||
               (task.description?.toLowerCase().contains(query) ?? false);
      }
      
      return true;
    }).toList();
    
    // Sort by priority and due date
    filtered.sort((a, b) {
      // First by priority
      const priorityOrder = {'critical': 0, 'high': 1, 'medium': 2, 'low': 3};
      final aPriority = priorityOrder[a.priority] ?? 4;
      final bPriority = priorityOrder[b.priority] ?? 4;
      
      if (aPriority != bPriority) {
        return aPriority.compareTo(bPriority);
      }
      
      // Then by due date (earliest first)
      if (a.dueDate != null && b.dueDate != null) {
        return a.dueDate!.compareTo(b.dueDate!);
      } else if (a.dueDate != null) {
        return -1;
      } else if (b.dueDate != null) {
        return 1;
      }
      
      // Finally by creation date (newest first)
      return b.createdAt.compareTo(a.createdAt);
    });
    
    return filtered;
  }
  
  // Get tasks by status
  List<TaskModel> getTasksByStatus(String status) {
    return userTasks.where((task) => task.status == status).toList();
  }
  
  // Get overdue tasks
  List<TaskModel> get overdueTasks {
    return userTasks.where((task) => task.isOverdue).toList();
  }
  
  // Get high priority tasks
  List<TaskModel> get highPriorityTasks {
    return userTasks.where((task) => task.isHighPriority).toList();
  }
  
  // Form validation
  String? validateTitle(String? value) {
    if (value == null || value.isEmpty) {
      return 'Task title is required';
    }
    if (value.length < 3) {
      return 'Task title must be at least 3 characters';
    }
    return null;
  }
  
  String? validateEstimatedHours(String? value) {
    if (value != null && value.isNotEmpty) {
      final hours = double.tryParse(value);
      if (hours == null || hours < 0) {
        return 'Please enter a valid number of hours';
      }
    }
    return null;
  }
  
  // Clear form
  void clearForm() {
    titleController.clear();
    descriptionController.clear();
    estimatedHoursController.clear();
    selectedStatus.value = 'todo';
    selectedPriority.value = 'medium';
    startDate.value = null;
    dueDate.value = null;
    selectedAssignee.value = null;
    selectedProjectId.value = null;
  }
  
  // Fill form with task data (for editing)
  void fillForm(TaskModel task) {
    titleController.text = task.title;
    descriptionController.text = task.description ?? '';
    estimatedHoursController.text = task.estimatedHours?.toString() ?? '';
    selectedStatus.value = task.status;
    selectedPriority.value = task.priority;
    startDate.value = task.startDate;
    dueDate.value = task.dueDate;
    selectedAssignee.value = task.assignedTo;
    selectedProjectId.value = task.projectId;
  }
  
  // Update filters
  void updateStatusFilter(String status) {
    filterStatus.value = status;
  }
  
  void updatePriorityFilter(String priority) {
    filterPriority.value = priority;
  }
  
  void updateSearchQuery(String query) {
    searchQuery.value = query;
  }
  
  // Clear filters
  void clearFilters() {
    filterStatus.value = 'all';
    filterPriority.value = 'all';
    searchQuery.value = '';
  }
}