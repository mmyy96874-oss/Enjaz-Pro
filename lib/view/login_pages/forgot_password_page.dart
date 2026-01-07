import 'package:flutter/material.dart';
import 'auth_widgets.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0, iconTheme: const IconThemeData(color: Colors.white)),
      extendBodyBehindAppBar: true,
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(gradient: LinearGradient(colors: [Color(0xFF3B67F3), Color(0xFF2342B0)])),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              buildLogoHeader(),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(30),
                  decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.only(topLeft: Radius.circular(35), topRight: Radius.circular(35))),
                  child: Column(
                    children: [
                      const Text("استعادة كلمة المرور", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF2342B0))),
                      const SizedBox(height: 30),
                      CustomAuthField(
                        label: "البريد الإلكتروني",
                        hint: "أدخل بريدك لإرسال الرمز",
                        icon: Icons.email_outlined,
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.done,
                        validator: (value) {
                          if (value == null || value.isEmpty) return 'الحقل مطلوب';
                          if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) return 'بريد غير صحيح';
                          return null;
                        },
                      ),
                      const SizedBox(height: 40),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF3B67F3), minimumSize: const Size(double.infinity, 55)),
                        onPressed: () { if (_formKey.currentState!.validate()) {} },
                        child: const Text("إرسال الرمز", style: TextStyle(color: Colors.white)),
                      ),
                    ],
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