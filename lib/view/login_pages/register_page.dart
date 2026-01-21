import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../presentation/controllers/auth_controller.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthController authController = Get.find<AuthController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: authController.registerFormKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 20),
                
                // App Logo/Title
                const Text(
                  'إنجاز برو',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                  textAlign: TextAlign.center,
                ),
                
                const SizedBox(height: 40),
                
                // Name Field
                TextFormField(
                  controller: authController.nameController,
                  decoration: const InputDecoration(
                    labelText: 'Full Name',
                    prefixIcon: Icon(Icons.person),
                  ),
                  validator: authController.validateName,
                ),
                
                const SizedBox(height: 16),
                
                // Email Field
                TextFormField(
                  controller: authController.emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    prefixIcon: Icon(Icons.email),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: authController.validateEmail,
                ),
                
                const SizedBox(height: 16),
                
                // Phone Field
                TextFormField(
                  controller: authController.phoneController,
                  decoration: const InputDecoration(
                    labelText: 'Phone (Optional)',
                    prefixIcon: Icon(Icons.phone),
                  ),
                  keyboardType: TextInputType.phone,
                  validator: authController.validatePhone,
                ),
                
                const SizedBox(height: 16),
                
                // Department Field
                TextFormField(
                  controller: authController.departmentController,
                  decoration: const InputDecoration(
                    labelText: 'Department (Optional)',
                    prefixIcon: Icon(Icons.business),
                  ),
                ),
                
                const SizedBox(height: 16),
                
                // Position Field
                TextFormField(
                  controller: authController.positionController,
                  decoration: const InputDecoration(
                    labelText: 'Position (Optional)',
                    prefixIcon: Icon(Icons.work),
                  ),
                ),
                
                const SizedBox(height: 16),
                
                // Password Field
                TextFormField(
                  controller: authController.passwordController,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                    prefixIcon: Icon(Icons.lock),
                  ),
                  obscureText: true,
                  validator: authController.validatePassword,
                ),
                
                const SizedBox(height: 16),
                
                // Confirm Password Field
                TextFormField(
                  controller: authController.confirmPasswordController,
                  decoration: const InputDecoration(
                    labelText: 'Confirm Password',
                    prefixIcon: Icon(Icons.lock_outline),
                  ),
                  obscureText: true,
                  validator: (value) {
                    if (value != authController.passwordController.text) {
                      return 'Passwords do not match';
                    }
                    return null;
                  },
                ),
                
                const SizedBox(height: 32),
                
                // Register Button
                Obx(() => ElevatedButton(
                  onPressed: authController.isLoading.value
                      ? null
                      : () => authController.register('user'),
                  child: authController.isLoading.value
                      ? const CircularProgressIndicator()
                      : const Text('Register'),
                )),
                
                const SizedBox(height: 16),
                
                // Login Link
                TextButton(
                  onPressed: () => Get.back(),
                  child: const Text('Already have an account? Login'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}