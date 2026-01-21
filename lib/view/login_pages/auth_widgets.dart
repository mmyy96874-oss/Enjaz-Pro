import 'package:flutter/material.dart';

// ويدجت الشعار المتكرر في جميع الصفحات
Widget buildLogoHeader() {
  return Column(
    children: [
      const SizedBox(height: 50),
      const CircleAvatar(
        radius: 45,
        backgroundColor: Colors.white,
        child: Icon(Icons.school, size: 55, color: Color(0xFF3B67F3)),
      ),
      const SizedBox(height: 15),
      const Text("إنجاز", style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold)),
      const Text("نظام إدارة المشاريع التعليمية", style: TextStyle(color: Colors.white70, fontSize: 14)),
      const SizedBox(height: 30),
    ],
  );
}

// ويدجت حقل الإدخال الذكي (يدعم كافة شروطك من 4 إلى 8)
class CustomAuthField extends StatefulWidget {
  final String label;
  final String hint;
  final IconData icon;
  final bool isPassword;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final String? Function(String?)? validator;
  final TextEditingController? controller;

  const CustomAuthField({
    super.key,
    required this.label,
    required this.hint,
    required this.icon,
    this.isPassword = false,
    this.keyboardType = TextInputType.text,
    this.textInputAction = TextInputAction.next,
    this.validator,
    this.controller,
  });

  @override
  State<CustomAuthField> createState() => _CustomAuthFieldState();
}

class _CustomAuthFieldState extends State<CustomAuthField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(widget.label, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black54)),
        const SizedBox(height: 8),
        Directionality(
          textDirection: TextDirection.rtl,
          child: TextFormField(
            controller: widget.controller,
            obscureText: widget.isPassword ? _obscureText : false,
            keyboardType: widget.keyboardType, // (شرط 6)
            textInputAction: widget.textInputAction, // (شرط 5)
            autovalidateMode: AutovalidateMode.onUserInteraction, // (شرط 8)
            validator: widget.validator, // (شرط 7)
            decoration: InputDecoration(
              hintText: widget.hint,
              prefixIcon: widget.isPassword
                  ? IconButton( // (شرط 4)
                icon: Icon(_obscureText ? Icons.visibility_off : Icons.visibility),
                onPressed: () => setState(() => _obscureText = !_obscureText),
              )
                  : Icon(widget.icon, color: Colors.grey),
              filled: true,
              fillColor: const Color(0xFFF8F9FA),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
              ),
            ),
          ),
        ),
      ],
    );
  }
}