import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../presentation/controllers/auth_controller.dart';

class ForgotPasswordPage extends StatelessWidget {
  const ForgotPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthController authController = Get.find<AuthController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Forgot Password'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: authController.forgotPasswordFormKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 40),
              
              // Icon
              const Icon(
                Icons.lock_reset,
                size: 80,
                color: Colors.blue,
              ),
              
              const SizedBox(height: 20),
              
              // Title
              const Text(
                'Reset Password',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              
              const SizedBox(height: 10),
              
              // Description
              const Text(
                'Enter your email address and we\'ll send you a link to reset your password.',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
                textAlign: TextAlign.center,
              ),
              
              const SizedBox(height: 40),
              
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
              
              const SizedBox(height: 32),
              
              // Send Reset Link Button
              Obx(() => ElevatedButton(
                onPressed: authController.isLoading.value
                    ? null
                    : authController.forgotPassword,
                child: authController.isLoading.value
                    ? const CircularProgressIndicator()
                    : const Text('Send Reset Link'),
              )),
              
              const SizedBox(height: 16),
              
              // Back to Login
              TextButton(
                onPressed: () => Get.back(),
                child: const Text('Back to Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}