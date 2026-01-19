import 'package:flutter/material.dart';
import 'auth_widgets.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();

  // وحدات التحكم لإدارة البيانات والتحقق من التطابق
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF3B67F3), Color(0xFF2342B0)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Form(
          key: _formKey,
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
                        borderRadius: BorderRadius.circular(25)
                    ),
                    child: Column(
                      children: [
                        const Text("إنشاء حساب جديد",
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF2342B0))),
                        const SizedBox(height: 25),

                        // 1. حقل الاسم الكامل
                        CustomAuthField(
                          controller: _nameController,
                          label: "الاسم الكامل",
                          hint: "أدخل اسمك الكامل",
                          icon: Icons.person_outline,
                          validator: (value) => (value == null || value.isEmpty) ? 'يرجى إدخال الاسم' : null,
                        ),
                        const SizedBox(height: 15),

                        // 2. حقل البريد الإلكتروني
                        CustomAuthField(
                          controller: _emailController,
                          label: "البريد الإلكتروني",
                          hint: "example@mail.com",
                          icon: Icons.email_outlined,
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value == null || value.isEmpty) return 'البريد مطلوب';
                            if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) return 'بريد غير صالح';
                            return null;
                          },
                        ),
                        const SizedBox(height: 15),

                        // 3. حقل كلمة السر
                        CustomAuthField(
                          controller: _passwordController,
                          label: "كلمة السر",
                          hint: "أدخل كلمة السر",
                          icon: Icons.lock_outline,
                          isPassword: true,
                          validator: (value) {
                            if (value == null || value.isEmpty) return 'كلمة السر مطلوبة';
                            if (value.length < 6) return 'يجب أن تكون 6 أحرف على الأقل';
                            return null;
                          },
                        ),
                        const SizedBox(height: 15),

                        // 4. حقل تأكيد كلمة السر (المطلوب)
                        CustomAuthField(
                          controller: _confirmPasswordController,
                          label: "تأكيد كلمة السر",
                          hint: "أعد كتابة كلمة السر",
                          icon: Icons.lock_reset,
                          isPassword: true,
                          textInputAction: TextInputAction.done, // إنهاء الإدخال
                          validator: (value) {
                            if (value == null || value.isEmpty) return 'يرجى تأكيد كلمة السر';
                            if (value != _passwordController.text) return 'كلمات السر غير متطابقة'; // شرط التطابق
                            return null;
                          },
                        ),

                        const SizedBox(height: 25),

                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF3B67F3),
                            minimumSize: const Size(double.infinity, 55),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              // إذا كانت كل البيانات صحيحة ومتطابقة
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text("جاري معالجة البيانات...")),
                              );
                            }
                          },
                          child: const Text("تسجيل", style: TextStyle(color: Colors.white, fontSize: 18)),
                        ),
                        TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text("لديك حساب؟ سجل دخولك")
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}