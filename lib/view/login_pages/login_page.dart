import 'package:flutter/material.dart';
import 'auth_widgets.dart';
import 'register_page.dart';
import 'forgot_password_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  bool _rememberMe = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(colors: [Color(0xFF3B67F3), Color(0xFF2342B0)]),
        ),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              buildLogoHeader(),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(25),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(35), topRight: Radius.circular(35)),
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        const Text("تسجيل الدخول", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF2342B0))),
                        const SizedBox(height: 25),
                        CustomAuthField(
                          label: "رقم الهاتف أو البريد الإلكتروني",
                          hint: "أدخل رقم الهاتف أو البريد",
                          icon: Icons.person_outline,
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value == null || value.isEmpty) return 'هذا الحقل مطلوب (شرط 1)';
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        CustomAuthField(
                          label: "كلمة المرور",
                          hint: "أدخل كلمة المرور",
                          icon: Icons.lock_outline,
                          isPassword: true,
                          textInputAction: TextInputAction.done,
                          validator: (value) {
                            if (value == null || value.isEmpty) return 'كلمة المرور مطلوبة';
                            if (value.length < 6) return 'يجب أن تكون 6 أحرف على الأقل (شرط 3)';
                            return null;
                          },
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          textDirection: TextDirection.rtl,
                          children: [
                            TextButton(
                              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (c) => const ForgotPasswordPage())),
                              child: const Text("نسيت كلمة المرور؟"),
                            ),
                            Row(
                              children: [
                                const Text("تذكرني", style: TextStyle(color: Colors.grey)),
                                Checkbox(value: _rememberMe, onChanged: (v) => setState(() => _rememberMe = v!)),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF3B67F3),
                            minimumSize: const Size(double.infinity, 55),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          onPressed: () {
                            if (_formKey.currentState!.validate()) { /* تسجيل دخول */ }
                          },
                          child: const Text("تسجيل الدخول", style: TextStyle(color: Colors.white, fontSize: 18)),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TextButton(
                              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (c) => const RegisterPage())),
                              child: const Text("تواصل مع الإدارة", style: TextStyle(fontWeight: FontWeight.bold)),
                            ),
                            const Text("ليس لديك حساب؟"),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}