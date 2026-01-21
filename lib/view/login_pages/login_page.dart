import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'auth_widgets.dart';
import '../../presentation/controllers/auth_controller.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthController authController = Get.find<AuthController>();

    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(colors: [Color(0xFF3B67F3), Color(0xFF2342B0)]),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                buildLogoHeader(),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 25),
                  padding: const EdgeInsets.all(25),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Form(
                    key: authController.loginFormKey,
                    child: Column(
                      children: [
                        const Text(
                          "تسجيل الدخول",
                          style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF2342B0)),
                        ),
                        const SizedBox(height: 25),

                        // Email Field
                        CustomAuthField(
                          label: "البريد الإلكتروني",
                          hint: "أدخل البريد الإلكتروني",
                          icon: Icons.email_outlined,
                          keyboardType: TextInputType.emailAddress,
                          controller: authController.emailController,
                          validator: authController.validateEmail,
                        ),
                        const SizedBox(height: 20),

                        // Password Field
                        CustomAuthField(
                          label: "كلمة المرور",
                          hint: "أدخل كلمة المرور",
                          icon: Icons.lock_outline,
                          isPassword: true,
                          controller: authController.passwordController,
                          textInputAction: TextInputAction.done,
                          validator: authController.validatePassword,
                        ),
                        
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          textDirection: TextDirection.rtl,
                          children: [
                            TextButton(
                              onPressed: () => Get.toNamed('/forgot-password'),
                              child: const Text("نسيت كلمة المرور؟"),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),

                        // Login Button
                        SizedBox(
                          width: double.infinity,
                          height: 55,
                          child: Obx(() => ElevatedButton(
                            onPressed: authController.isLoading.value 
                                ? null 
                                : authController.login,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF3B67F3),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12)),
                            ),
                            child: authController.isLoading.value
                                ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                                : const Text(
                              "تسجيل الدخول",
                              style: TextStyle(
                                  color: Colors.white, fontSize: 18),
                            ),
                          )),
                        ),
                        const SizedBox(height: 20),

                        // Register Link
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TextButton(
                              onPressed: () => Get.toNamed('/register'),
                              child: const Text(
                                "إنشاء حساب جديد",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            const Text("ليس لديك حساب؟"),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
