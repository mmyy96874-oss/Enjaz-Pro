import 'package:get/get.dart';
import '../../core/services/api_service.dart';
import '../../core/services/database_service.dart';
import '../../core/services/storage_service.dart';
import '../models/user_model.dart';
import 'package:uuid/uuid.dart';

class AuthRepository extends GetxService {
  final ApiService _apiService = ApiService();
  final DatabaseService _databaseService = DatabaseService();
  final StorageService _storageService = StorageService();
  final Uuid _uuid = const Uuid();

  // Login with email and password
  Future<UserModel> login(String email, String password) async {
    try {
      // Try API login first
      final response = await _apiService.post('/auth/login', data: {
        'email': email,
        'password': password,
      });

      if (response.statusCode == 200) {
        final userData = response.data['user'];
        final token = response.data['token'];
        
        // Save token and user data
        await _storageService.saveToken(token);
        await _storageService.saveUserData(userData);
        
        // Save user to local database
        final user = UserModel.fromJson(userData);
        await _saveUserToDatabase(user);
        
        return user;
      } else {
        throw Exception('Login failed');
      }
    } catch (e) {
      // Fallback to local database for offline login
      return await _loginOffline(email, password);
    }
  }

  // Offline login
  Future<UserModel> _loginOffline(String email, String password) async {
    print('DEBUG: Attempting offline login for email: $email');
    
    final users = await _databaseService.query(
      'users',
      where: 'email = ? AND password = ?',
      whereArgs: [email, password],
    );

    print('DEBUG: Found ${users.length} users matching credentials');
    if (users.isNotEmpty) {
      print('DEBUG: User data from database: ${users.first}');
    }

    if (users.isEmpty) {
      throw Exception('Invalid credentials');
    }

    final user = UserModel.fromDatabase(users.first);
    print('DEBUG: Created UserModel: ${user.toJson()}');
    
    await _storageService.saveUserData(user.toJson());
    return user;
  }

  // Register new user
  Future<UserModel> register({
    required String email,
    required String password,
    required String name,
    required String role,
    String? phone,
    String? department,
    String? position,
  }) async {
    try {
      // Try API registration first
      final response = await _apiService.post('/auth/register', data: {
        'email': email,
        'password': password,
        'name': name,
        'role': role,
        'phone': phone,
        'department': department,
        'position': position,
      });

      if (response.statusCode == 201) {
        final userData = response.data['user'];
        final token = response.data['token'];
        
        // Save token and user data
        await _storageService.saveToken(token);
        await _storageService.saveUserData(userData);
        
        // Save user to local database
        final user = UserModel.fromJson(userData);
        await _saveUserToDatabase(user);
        
        return user;
      } else {
        throw Exception('Registration failed');
      }
    } catch (e) {
      // Fallback to local registration
      return await _registerOffline(
        email: email,
        password: password,
        name: name,
        role: role,
        phone: phone,
        department: department,
        position: position,
      );
    }
  }

  // Offline registration
  Future<UserModel> _registerOffline({
    required String email,
    required String password,
    required String name,
    required String role,
    String? phone,
    String? department,
    String? position,
  }) async {
    // Check if user already exists
    final existingUsers = await _databaseService.query(
      'users',
      where: 'email = ?',
      whereArgs: [email],
    );

    if (existingUsers.isNotEmpty) {
      throw Exception('User already exists');
    }

    final now = DateTime.now();
    final user = UserModel(
      id: _uuid.v4(),
      email: email,
      name: name,
      role: role,
      phone: phone,
      department: department,
      position: position,
      createdAt: now,
      updatedAt: now,
    );

    // Save user with password to database
    final userData = user.toDatabase();
    userData['password'] = password; // Add password for local storage
    
    await _databaseService.insert('users', userData);
    await _storageService.saveUserData(user.toJson());
    
    return user;
  }

  // Logout
  Future<void> logout() async {
    try {
      // Try API logout
      await _apiService.post('/auth/logout');
    } catch (e) {
      // Continue with local logout even if API fails
    }
    
    // Clear local data
    await _storageService.removeToken();
    await _storageService.removeUserData();
  }

  // Get current user
  Future<UserModel?> getCurrentUser() async {
    final userData = _storageService.getUserData();
    if (userData != null) {
      return UserModel.fromJson(userData);
    }
    return null;
  }

  // Check if user is logged in
  bool isLoggedIn() {
    return _storageService.hasToken() || _storageService.getUserData() != null;
  }

  // Forgot password
  Future<void> forgotPassword(String email) async {
    try {
      await _apiService.post('/auth/forgot-password', data: {
        'email': email,
      });
    } catch (e) {
      throw Exception('Failed to send reset email');
    }
  }

  // Reset password
  Future<void> resetPassword(String token, String newPassword) async {
    try {
      await _apiService.post('/auth/reset-password', data: {
        'token': token,
        'password': newPassword,
      });
    } catch (e) {
      throw Exception('Failed to reset password');
    }
  }

  // Change password
  Future<void> changePassword(String currentPassword, String newPassword) async {
    try {
      await _apiService.post('/auth/change-password', data: {
        'current_password': currentPassword,
        'new_password': newPassword,
      });
    } catch (e) {
      throw Exception('Failed to change password');
    }
  }

  // Update profile
  Future<UserModel> updateProfile(UserModel user) async {
    try {
      final response = await _apiService.put('/auth/profile', data: user.toJson());
      
      if (response.statusCode == 200) {
        final updatedUser = UserModel.fromJson(response.data['user']);
        await _storageService.saveUserData(updatedUser.toJson());
        await _updateUserInDatabase(updatedUser);
        return updatedUser;
      } else {
        throw Exception('Failed to update profile');
      }
    } catch (e) {
      // Fallback to local update
      final updatedUser = user.copyWith(updatedAt: DateTime.now());
      await _updateUserInDatabase(updatedUser);
      await _storageService.saveUserData(updatedUser.toJson());
      return updatedUser;
    }
  }

  // Helper methods
  Future<void> _saveUserToDatabase(UserModel user) async {
    await _databaseService.insert('users', user.toDatabase());
  }

  Future<void> _updateUserInDatabase(UserModel user) async {
    await _databaseService.update(
      'users',
      user.toDatabase(),
      where: 'id = ?',
      whereArgs: [user.id],
    );
  }
}