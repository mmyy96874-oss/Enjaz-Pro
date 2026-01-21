import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/utils/app_utils.dart';
import '../../data/models/project_model.dart';
import '../../data/repositories/project_repository.dart';
import 'auth_controller.dart';

class ProjectController extends GetxController {
  final ProjectRepository _projectRepository = Get.find<ProjectRepository>();
  final AuthController _authController = Get.find<AuthController>();
  
  // Observable variables
  final RxList<ProjectModel> projects = <ProjectModel>[].obs;
  final RxList<ProjectModel> userProjects = <ProjectModel>[].obs;
  final Rx<ProjectModel?> selectedProject = Rx<ProjectModel?>(null);
  final RxBool isLoading = false.obs;
  final RxBool isCreating = false.obs;
  final RxMap<String, dynamic> projectStats = <String, dynamic>{}.obs;
  
  // Form controllers
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  final budgetController = TextEditingController();
  
  // Form variables
  final Rx<String> selectedStatus = 'active'.obs;
  final Rx<String> selectedPriority = 'medium'.obs;
  final Rx<DateTime> startDate = DateTime.now().obs;
  final Rx<DateTime?> endDate = Rx<DateTime?>(null);
  final Rx<String?> selectedManagerId = Rx<String?>(null);
  
  // Form key
  final projectFormKey = GlobalKey<FormState>();
  
  // Filter variables
  final Rx<String> filterStatus = 'all'.obs;
  final Rx<String> filterPriority = 'all'.obs;
  final RxString searchQuery = ''.obs;
  
  @override
  void onInit() {
    super.onInit();
    loadProjects();
    loadUserProjects();
  }
  
  @override
  void onClose() {
    nameController.dispose();
    descriptionController.dispose();
    budgetController.dispose();
    super.onClose();
  }
  
  // Load all projects (for admin/super admin)
  Future<void> loadProjects() async {
    try {
      isLoading.value = true;
      
      final loadedProjects = await _projectRepository.getAllProjects();
      projects.value = loadedProjects;
      
    } catch (e) {
      AppUtils.showErrorMessage('Failed to load projects: $e');
    } finally {
      isLoading.value = false;
    }
  }
  
  // Load user's projects
  Future<void> loadUserProjects() async {
    final currentUser = _authController.currentUser.value;
    if (currentUser == null) return;
    
    try {
      isLoading.value = true;
      
      List<ProjectModel> loadedProjects;
      
      if (currentUser.isSuperAdmin || currentUser.isAdmin) {
        // Load projects managed by this user
        loadedProjects = await _projectRepository.getProjectsByManager(currentUser.id);
      } else {
        // Load projects where user is a member
        loadedProjects = await _projectRepository.getUserProjects(currentUser.id);
      }
      
      userProjects.value = loadedProjects;
      
    } catch (e) {
      AppUtils.showErrorMessage('Failed to load user projects: $e');
    } finally {
      isLoading.value = false;
    }
  }
  
  // Create new project
  Future<void> createProject() async {
    if (!projectFormKey.currentState!.validate()) return;
    
    final currentUser = _authController.currentUser.value;
    if (currentUser == null) return;
    
    try {
      isCreating.value = true;
      
      final project = await _projectRepository.createProject(
        name: nameController.text.trim(),
        description: descriptionController.text.trim().isEmpty 
            ? null 
            : descriptionController.text.trim(),
        status: selectedStatus.value,
        priority: selectedPriority.value,
        startDate: startDate.value,
        endDate: endDate.value,
        budget: budgetController.text.trim().isEmpty 
            ? null 
            : double.tryParse(budgetController.text.trim()),
        managerId: selectedManagerId.value ?? currentUser.id,
        createdBy: currentUser.id,
      );
      
      // Add to appropriate lists
      projects.add(project);
      if (currentUser.isSuperAdmin || currentUser.isAdmin || 
          project.managerId == currentUser.id) {
        userProjects.add(project);
      }
      
      AppUtils.showSuccessMessage('Project created successfully');
      Get.back();
      clearForm();
      
    } catch (e) {
      AppUtils.showErrorMessage('Failed to create project: $e');
    } finally {
      isCreating.value = false;
    }
  }
  
  // Update project
  Future<void> updateProject(ProjectModel project) async {
    try {
      isLoading.value = true;
      
      final updatedProject = await _projectRepository.updateProject(project);
      
      // Update in lists
      final projectIndex = projects.indexWhere((p) => p.id == project.id);
      if (projectIndex != -1) {
        projects[projectIndex] = updatedProject;
      }
      
      final userProjectIndex = userProjects.indexWhere((p) => p.id == project.id);
      if (userProjectIndex != -1) {
        userProjects[userProjectIndex] = updatedProject;
      }
      
      if (selectedProject.value?.id == project.id) {
        selectedProject.value = updatedProject;
      }
      
      AppUtils.showSuccessMessage('Project updated successfully');
      
    } catch (e) {
      AppUtils.showErrorMessage('Failed to update project: $e');
    } finally {
      isLoading.value = false;
    }
  }
  
  // Delete project
  Future<void> deleteProject(String projectId) async {
    try {
      isLoading.value = true;
      
      await _projectRepository.deleteProject(projectId);
      
      // Remove from lists
      projects.removeWhere((p) => p.id == projectId);
      userProjects.removeWhere((p) => p.id == projectId);
      
      if (selectedProject.value?.id == projectId) {
        selectedProject.value = null;
      }
      
      AppUtils.showSuccessMessage('Project deleted successfully');
      
    } catch (e) {
      AppUtils.showErrorMessage('Failed to delete project: $e');
    } finally {
      isLoading.value = false;
    }
  }
  
  // Select project
  void selectProject(ProjectModel project) {
    selectedProject.value = project;
    loadProjectStats(project.id);
  }
  
  // Load project statistics
  Future<void> loadProjectStats(String projectId) async {
    try {
      final stats = await _projectRepository.getProjectStats(projectId);
      projectStats.value = stats;
    } catch (e) {
      print('Failed to load project stats: $e');
    }
  }
  
  // Add member to project
  Future<void> addProjectMember({
    required String projectId,
    required String userId,
    required String role,
  }) async {
    try {
      await _projectRepository.addProjectMember(
        projectId: projectId,
        userId: userId,
        role: role,
      );
      
      AppUtils.showSuccessMessage('Member added successfully');
      
    } catch (e) {
      AppUtils.showErrorMessage('Failed to add member: $e');
    }
  }
  
  // Remove member from project
  Future<void> removeProjectMember({
    required String projectId,
    required String userId,
  }) async {
    try {
      await _projectRepository.removeProjectMember(
        projectId: projectId,
        userId: userId,
      );
      
      AppUtils.showSuccessMessage('Member removed successfully');
      
    } catch (e) {
      AppUtils.showErrorMessage('Failed to remove member: $e');
    }
  }
  
  // Filtered projects
  List<ProjectModel> get filteredProjects {
    var filtered = userProjects.where((project) {
      // Status filter
      if (filterStatus.value != 'all' && project.status != filterStatus.value) {
        return false;
      }
      
      // Priority filter
      if (filterPriority.value != 'all' && project.priority != filterPriority.value) {
        return false;
      }
      
      // Search query
      if (searchQuery.value.isNotEmpty) {
        final query = searchQuery.value.toLowerCase();
        return project.name.toLowerCase().contains(query) ||
               (project.description?.toLowerCase().contains(query) ?? false);
      }
      
      return true;
    }).toList();
    
    // Sort by priority and date
    filtered.sort((a, b) {
      // First by priority
      const priorityOrder = {'critical': 0, 'high': 1, 'medium': 2, 'low': 3};
      final aPriority = priorityOrder[a.priority] ?? 4;
      final bPriority = priorityOrder[b.priority] ?? 4;
      
      if (aPriority != bPriority) {
        return aPriority.compareTo(bPriority);
      }
      
      // Then by creation date (newest first)
      return b.createdAt.compareTo(a.createdAt);
    });
    
    return filtered;
  }
  
  // Form validation
  String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Project name is required';
    }
    if (value.length < 3) {
      return 'Project name must be at least 3 characters';
    }
    return null;
  }
  
  String? validateBudget(String? value) {
    if (value != null && value.isNotEmpty) {
      final budget = double.tryParse(value);
      if (budget == null || budget < 0) {
        return 'Please enter a valid budget amount';
      }
    }
    return null;
  }
  
  // Clear form
  void clearForm() {
    nameController.clear();
    descriptionController.clear();
    budgetController.clear();
    selectedStatus.value = 'active';
    selectedPriority.value = 'medium';
    startDate.value = DateTime.now();
    endDate.value = null;
    selectedManagerId.value = null;
  }
  
  // Fill form with project data (for editing)
  void fillForm(ProjectModel project) {
    nameController.text = project.name;
    descriptionController.text = project.description ?? '';
    budgetController.text = project.budget?.toString() ?? '';
    selectedStatus.value = project.status;
    selectedPriority.value = project.priority;
    startDate.value = project.startDate;
    endDate.value = project.endDate;
    selectedManagerId.value = project.managerId;
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