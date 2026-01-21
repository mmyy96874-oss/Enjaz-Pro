import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/utils/app_utils.dart';
import '../../core/services/storage_service.dart';
import '../../data/models/user_model.dart';
import '../../data/repositories/auth_repository.dart';

class AuthController extends GetxController {
  final AuthRepository _authRepository = Get.find<AuthRepository>();
  
  // Observable variables
  final Rx<UserModel?> currentUser = Rx<UserModel?>(null);
  final RxBool isLoading = false.obs;
  final RxBool isLoggedIn = false.obs;
  
  // Form controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final departmentController = TextEditingController();
  final positionController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  
  // Form keys
  final loginFormKey = GlobalKey<FormState>();
  final registerFormKey = GlobalKey<FormState>();
  final forgotPasswordFormKey = GlobalKey<FormState>();
  
  @override
  void onInit() {
    super.onInit();
    _checkAuthStatus();
  }
  
  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    nameController.dispose();
    phoneController.dispose();
    departmentController.dispose();
    positionController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
  
  // Check if user is already logged in
  Future<void> _checkAuthStatus() async {
    try {
      // Wait for StorageService to be initialized
      await Get.find<StorageService>();
      
      if (_authRepository.isLoggedIn()) {
        final user = await _authRepository.getCurrentUser();
        if (user != null) {
          currentUser.value = user;
          isLoggedIn.value = true;
          _navigateToHome();
        }
      }
    } catch (e) {
      print('Error checking auth status: $e');
    }
  }
  
  // Login
  Future<void> login() async {
    if (!loginFormKey.currentState!.validate()) return;
    
    try {
      isLoading.value = true;
      
      print('DEBUG: Attempting login with email: ${emailController.text.trim()}');
      
      final user = await _authRepository.login(
        emailController.text.trim(),
        passwordController.text,
      );
      
      print('DEBUG: Login successful, user data: ${user.toJson()}');
      
      currentUser.value = user;
      isLoggedIn.value = true;
      
      AppUtils.showSuccessMessage('Login successful');
      _navigateToHome();
      _clearLoginForm();
      
    } catch (e) {
      print('DEBUG: Login failed: $e');
      AppUtils.showErrorMessage(e.toString());
    } finally {
      isLoading.value = false;
    }
  }
  
  // Register
  Future<void> register(String role) async {
    if (!registerFormKey.currentState!.validate()) return;
    
    if (passwordController.text != confirmPasswordController.text) {
      AppUtils.showErrorMessage('Passwords do not match');
      return;
    }
    
    try {
      isLoading.value = true;
      
      final user = await _authRepository.register(
        email: emailController.text.trim(),
        password: passwordController.text,
        name: nameController.text.trim(),
        role: role,
        phone: phoneController.text.trim().isEmpty ? null : phoneController.text.trim(),
        department: departmentController.text.trim().isEmpty ? null : departmentController.text.trim(),
        position: positionController.text.trim().isEmpty ? null : positionController.text.trim(),
      );
      
      currentUser.value = user;
      isLoggedIn.value = true;
      
      AppUtils.showSuccessMessage('Registration successful');
      _navigateToHome();
      _clearRegisterForm();
      
    } catch (e) {
      AppUtils.showErrorMessage(e.toString());
    } finally {
      isLoading.value = false;
    }
  }
  
  // Logout
  Future<void> logout() async {
    try {
      isLoading.value = true;
      
      await _authRepository.logout();
      
      currentUser.value = null;
      isLoggedIn.value = false;
      
      AppUtils.showSuccessMessage('Logged out successfully');
      Get.offAllNamed('/login');
      
    } catch (e) {
      AppUtils.showErrorMessage('Logout failed');
    } finally {
      isLoading.value = false;
    }
  }
  
  // Forgot Password
  Future<void> forgotPassword() async {
    if (!forgotPasswordFormKey.currentState!.validate()) return;
    
    try {
      isLoading.value = true;
      
      await _authRepository.forgotPassword(emailController.text.trim());
      
      AppUtils.showSuccessMessage('Reset email sent successfully');
      Get.back();
      
    } catch (e) {
      AppUtils.showErrorMessage(e.toString());
    } finally {
      isLoading.value = false;
    }
  }
  
  // Update Profile
  Future<void> updateProfile() async {
    if (currentUser.value == null) return;
    
    try {
      isLoading.value = true;
      
      final updatedUser = currentUser.value!.copyWith(
        name: nameController.text.trim(),
        phone: phoneController.text.trim().isEmpty ? null : phoneController.text.trim(),
        department: departmentController.text.trim().isEmpty ? null : departmentController.text.trim(),
        position: positionController.text.trim().isEmpty ? null : positionController.text.trim(),
      );
      
      final user = await _authRepository.updateProfile(updatedUser);
      currentUser.value = user;
      
      AppUtils.showSuccessMessage('Profile updated successfully');
      
    } catch (e) {
      AppUtils.showErrorMessage(e.toString());
    } finally {
      isLoading.value = false;
    }
  }
  
  // Navigation based on user role
  void _navigateToHome() {
    if (currentUser.value == null) return;
    
    final userRole = currentUser.value!.role;
    print('DEBUG: User role detected: $userRole');
    print('DEBUG: User data: ${currentUser.value!.toJson()}');
    
    switch (userRole) {
      case 'super_admin':
        print('DEBUG: Navigating to super admin page');
        Get.offAllNamed('/super-admin');
        break;
      case 'admin':
        print('DEBUG: Navigating to admin page');
        Get.offAllNamed('/admin');
        break;
      case 'user':
        print('DEBUG: Navigating to user page');
        Get.offAllNamed('/user');
        break;
      default:
        print('DEBUG: Unknown role, navigating to login');
        Get.offAllNamed('/login');
    }
  }
  
  // Form validation
  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    if (!AppUtils.isValidEmail(value)) {
      return 'Please enter a valid email';
    }
    return null;
  }
  
  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }
  
  String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Name is required';
    }
    if (value.length < 2) {
      return 'Name must be at least 2 characters';
    }
    return null;
  }
  
  String? validatePhone(String? value) {
    if (value != null && value.isNotEmpty && !AppUtils.isValidPhone(value)) {
      return 'Please enter a valid phone number';
    }
    return null;
  }
  
  // Clear forms
  void _clearLoginForm() {
    emailController.clear();
    passwordController.clear();
  }
  
  void _clearRegisterForm() {
    emailController.clear();
    passwordController.clear();
    nameController.clear();
    phoneController.clear();
    departmentController.clear();
    positionController.clear();
    confirmPasswordController.clear();
  }
  
  // Fill profile form with current user data
  void fillProfileForm() {
    if (currentUser.value != null) {
      nameController.text = currentUser.value!.name;
      emailController.text = currentUser.value!.email;
      phoneController.text = currentUser.value!.phone ?? '';
      departmentController.text = currentUser.value!.department ?? '';
      positionController.text = currentUser.value!.position ?? '';
    }
  }
}