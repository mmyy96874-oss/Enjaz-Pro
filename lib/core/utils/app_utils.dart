import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class AppUtils {
  // Date Formatting
  static String formatDate(DateTime date, {String? pattern}) {
    pattern ??= 'dd/MM/yyyy';
    return DateFormat(pattern).format(date);
  }
  
  static String formatDateTime(DateTime dateTime, {String? pattern}) {
    pattern ??= 'dd/MM/yyyy HH:mm';
    return DateFormat(pattern).format(dateTime);
  }
  
  static String formatTime(DateTime time, {String? pattern}) {
    pattern ??= 'HH:mm';
    return DateFormat(pattern).format(time);
  }
  
  // Validation
  static bool isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }
  
  static bool isValidPhone(String phone) {
    return RegExp(r'^\+?[1-9]\d{1,14}$').hasMatch(phone);
  }
  
  static bool isValidPassword(String password) {
    // At least 8 characters, 1 uppercase, 1 lowercase, 1 number
    return RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[a-zA-Z\d@$!%*?&]{8,}$').hasMatch(password);
  }
  
  // Snackbar Messages
  static void showSuccessMessage(String message) {
    Get.snackbar(
      'Success',
      message,
      backgroundColor: Colors.green,
      colorText: Colors.white,
      snackPosition: SnackPosition.TOP,
      duration: const Duration(seconds: 3),
    );
  }
  
  static void showErrorMessage(String message) {
    Get.snackbar(
      'Error',
      message,
      backgroundColor: Colors.red,
      colorText: Colors.white,
      snackPosition: SnackPosition.TOP,
      duration: const Duration(seconds: 3),
    );
  }
  
  static void showInfoMessage(String message) {
    Get.snackbar(
      'Info',
      message,
      backgroundColor: Colors.blue,
      colorText: Colors.white,
      snackPosition: SnackPosition.TOP,
      duration: const Duration(seconds: 3),
    );
  }
  
  // Loading Dialog
  static void showLoading({String? message}) {
    Get.dialog(
      Dialog(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(),
              const SizedBox(height: 16),
              Text(message ?? 'Loading...'),
            ],
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }
  
  static void hideLoading() {
    if (Get.isDialogOpen ?? false) {
      Get.back();
    }
  }
  
  // File Size Formatting
  static String formatFileSize(int bytes) {
    if (bytes <= 0) return '0 B';
    const suffixes = ['B', 'KB', 'MB', 'GB', 'TB'];
    var i = (bytes.bitLength - 1) ~/ 10;
    return '${(bytes / (1 << (i * 10))).toStringAsFixed(1)} ${suffixes[i]}';
  }
  
  // Color from String
  static Color getColorFromString(String text) {
    var hash = 0;
    for (var i = 0; i < text.length; i++) {
      hash = text.codeUnitAt(i) + ((hash << 5) - hash);
    }
    var color = (hash & 0x00FFFFFF) | 0xFF000000;
    return Color(color);
  }
  
  // Generate Initials
  static String getInitials(String name) {
    List<String> names = name.split(' ');
    String initials = '';
    for (var name in names) {
      if (name.isNotEmpty) {
        initials += name[0].toUpperCase();
      }
    }
    return initials.length > 2 ? initials.substring(0, 2) : initials;
  }
}