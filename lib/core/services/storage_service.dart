import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/app_constants.dart';

class StorageService {
  static SharedPreferences? _prefs;
  static final StorageService _instance = StorageService._internal();
  
  factory StorageService() => _instance;
  StorageService._internal();
  
  Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
  }
  
  SharedPreferences get prefs {
    if (_prefs == null) {
      throw Exception('StorageService not initialized. Call init() first.');
    }
    return _prefs!;
  }
  
  // Token management
  Future<void> saveToken(String token) async {
    await prefs.setString(AppConstants.tokenKey, token);
  }
  
  String? getToken() {
    return prefs.getString(AppConstants.tokenKey);
  }
  
  Future<void> removeToken() async {
    await prefs.remove(AppConstants.tokenKey);
  }
  
  bool hasToken() {
    return prefs.containsKey(AppConstants.tokenKey);
  }
  
  // User data management
  Future<void> saveUserData(Map<String, dynamic> userData) async {
    await prefs.setString(AppConstants.userKey, jsonEncode(userData));
  }
  
  Map<String, dynamic>? getUserData() {
    final userDataString = prefs.getString(AppConstants.userKey);
    if (userDataString != null) {
      return jsonDecode(userDataString);
    }
    return null;
  }
  
  Future<void> removeUserData() async {
    await prefs.remove(AppConstants.userKey);
  }
  
  // Language management
  Future<void> saveLanguage(String languageCode) async {
    await prefs.setString(AppConstants.languageKey, languageCode);
  }
  
  String getLanguage() {
    return prefs.getString(AppConstants.languageKey) ?? 'en';
  }
  
  // Theme management
  Future<void> saveTheme(String theme) async {
    await prefs.setString(AppConstants.themeKey, theme);
  }
  
  String getTheme() {
    return prefs.getString(AppConstants.themeKey) ?? 'light';
  }
  
  // Generic methods
  Future<void> saveString(String key, String value) async {
    await prefs.setString(key, value);
  }
  
  String? getString(String key) {
    return prefs.getString(key);
  }
  
  Future<void> saveInt(String key, int value) async {
    await prefs.setInt(key, value);
  }
  
  int? getInt(String key) {
    return prefs.getInt(key);
  }
  
  Future<void> saveBool(String key, bool value) async {
    await prefs.setBool(key, value);
  }
  
  bool? getBool(String key) {
    return prefs.getBool(key);
  }
  
  Future<void> saveDouble(String key, double value) async {
    await prefs.setDouble(key, value);
  }
  
  double? getDouble(String key) {
    return prefs.getDouble(key);
  }
  
  Future<void> saveStringList(String key, List<String> value) async {
    await prefs.setStringList(key, value);
  }
  
  List<String>? getStringList(String key) {
    return prefs.getStringList(key);
  }
  
  Future<void> remove(String key) async {
    await prefs.remove(key);
  }
  
  Future<void> clear() async {
    await prefs.clear();
  }
  
  bool containsKey(String key) {
    return prefs.containsKey(key);
  }
}