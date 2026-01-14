import 'package:flutter/material.dart';
import 'auth_widgets.dart';
import 'register_page.dart';
import 'forgot_password_page.dart';
import '../../routes.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _rememberMe = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  bool _isValidEmail(String input) {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(input);
  }

  bool _isValidPhone(String input) {
    final phoneRegex = RegExp(r'^\d{6,15}$');
    return phoneRegex.hasMatch(input);
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return; // التحقق فقط عند الضغط

    setState(() => _isLoading = true);

    // محاكاة عملية تسجيل الدخول
    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      setState(() => _isLoading = false);
      Navigator.pushReplacementNamed(context, AppRoutes.userDashboard);
    }
  }

  String? _validateEmailOrPhone(String? value) {
    if (value == null || value.isEmpty) return 'هذا الحقل مطلوب';
    if (!_isValidEmail(value) && !_isValidPhone(value)) {
      return 'أدخل بريد إلكتروني صحيح أو رقم هاتف صالح';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) return 'يرجى إدخال كلمة المرور';
    if (value.length < 6) return 'يجب أن تكون كلمة المرور 6 أحرف على الأقل';
    return null;
  }

  @override
  Widget build(BuildContext context) {
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
                    key: _formKey,
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

                        // حقل البريد أو الهاتف مع validator
                        CustomAuthField(
                          label: "رقم الهاتف أو البريد الإلكتروني",
                          hint: "أدخل رقم الهاتف أو البريد",
                          icon: Icons.person_outline,
                          keyboardType: TextInputType.emailAddress,
                          controller: _emailController,
                          validator: _validateEmailOrPhone,
                        ),
                        const SizedBox(height: 20),

                        // حقل كلمة المرور مع validator
                        CustomAuthField(
                          label: "كلمة المرور",
                          hint: "أدخل كلمة المرور",
                          icon: Icons.lock_outline,
                          isPassword: true,
                          controller: _passwordController,
                          textInputAction: TextInputAction.done,
                          validator: _validatePassword,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          textDirection: TextDirection.rtl,
                          children: [
                            TextButton(
                              onPressed: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (c) => const ForgotPasswordPage()),
                              ),
                              child: const Text("نسيت كلمة المرور؟"),
                            ),
                            Row(
                              children: [
                                const Text("تذكرني",
                                    style: TextStyle(color: Colors.grey)),
                                Checkbox(
                                  value: _rememberMe,
                                  onChanged: (v) =>
                                      setState(() => _rememberMe = v!),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),

                        // زر تسجيل الدخول
                        SizedBox(
                          width: double.infinity,
                          height: 55,
                          child: ElevatedButton(
                            onPressed: _isLoading ? null : _login,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF3B67F3),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12)),
                            ),
                            child: _isLoading
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
                          ),
                        ),
                        const SizedBox(height: 20),

                        // رابط إنشاء حساب / تواصل مع الإدارة
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TextButton(
                              onPressed: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (c) => const RegisterPage()),
                              ),
                              child: const Text(
                                "تواصل مع الإدارة",
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
