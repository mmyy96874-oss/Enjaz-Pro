import 'dart:async';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/app_constants.dart';
import 'sample_data_service.dart';

class DatabaseService {
  static SharedPreferences? _prefs;
  static final DatabaseService _instance = DatabaseService._internal();
  
  factory DatabaseService() => _instance;
  DatabaseService._internal();
  
  Future<SharedPreferences> get prefs async {
    _prefs ??= await SharedPreferences.getInstance();
    return _prefs!;
  }
  
  // Initialize database (for web, we'll use SharedPreferences)
  Future<void> initDatabase() async {
    final preferences = await prefs;
    
    // Force reset for testing - remove this line in production
    await preferences.setBool('database_initialized', false);
    
    // Initialize default data if needed
    if (!preferences.containsKey('database_initialized') || !preferences.getBool('database_initialized')!) {
      await _initializeDefaultData();
      await preferences.setBool('database_initialized', true);
      
      // Initialize sample data for testing
      await _initializeSampleData();
    }
  }
  
  Future<void> _initializeSampleData() async {
    await SampleDataService.initializeSampleData();
  }
  
  Future<void> _initializeDefaultData() async {
    // Initialize empty collections
    await _saveCollection('users', []);
    await _saveCollection('projects', []);
    await _saveCollection('tasks', []);
    await _saveCollection('project_members', []);
    await _saveCollection('comments', []);
    await _saveCollection('files', []);
    await _saveCollection('notifications', []);
    await _saveCollection('time_entries', []);
  }
  
  // Generic CRUD operations using SharedPreferences
  Future<String> insert(String table, Map<String, dynamic> data) async {
    final items = await _getCollection(table);
    final id = data['id'] ?? DateTime.now().millisecondsSinceEpoch.toString();
    data['id'] = id;
    items.add(data);
    await _saveCollection(table, items);
    return id;
  }
  
  Future<List<Map<String, dynamic>>> query(
    String table, {
    String? where,
    List<dynamic>? whereArgs,
    String? orderBy,
    int? limit,
    int? offset,
  }) async {
    List<Map<String, dynamic>> items = await _getCollection(table);
    
    // Simple where clause implementation
    if (where != null && whereArgs != null) {
      items = items.where((item) {
        // Handle multiple conditions with AND
        if (where.contains(' AND ')) {
          final conditions = where.split(' AND ');
          bool allMatch = true;
          
          for (int i = 0; i < conditions.length && i < whereArgs.length; i++) {
            final condition = conditions[i].trim();
            if (condition.contains(' = ?')) {
              final field = condition.split(' = ?')[0].trim();
              final value = whereArgs[i];
              if (item[field] != value) {
                allMatch = false;
                break;
              }
            }
          }
          return allMatch;
        }
        // Handle single condition
        else if (where.contains(' = ?')) {
          final parts = where.split(' = ?');
          if (parts.length == 2) {
            final field = parts[0].trim();
            final value = whereArgs.isNotEmpty ? whereArgs[0] : null;
            return item[field] == value;
          }
        }
        return true;
      }).toList();
    }
    
    // Simple ordering
    if (orderBy != null) {
      items.sort((a, b) {
        final field = orderBy.replaceAll(' DESC', '').replaceAll(' ASC', '').trim();
        final aValue = a[field];
        final bValue = b[field];
        
        if (aValue == null && bValue == null) return 0;
        if (aValue == null) return 1;
        if (bValue == null) return -1;
        
        final comparison = aValue.toString().compareTo(bValue.toString());
        return orderBy.contains('DESC') ? -comparison : comparison;
      });
    }
    
    // Apply limit and offset
    if (offset != null && offset > 0) {
      items = items.skip(offset).toList();
    }
    if (limit != null && limit > 0) {
      items = items.take(limit).toList();
    }
    
    return items;
  }
  
  Future<int> update(
    String table,
    Map<String, dynamic> data, {
    String? where,
    List<dynamic>? whereArgs,
  }) async {
    final items = await _getCollection(table);
    int updatedCount = 0;
    
    for (int i = 0; i < items.length; i++) {
      bool shouldUpdate = true;
      
      if (where != null && whereArgs != null) {
        // Simple where clause implementation
        if (where.contains('=')) {
          final parts = where.split('=');
          if (parts.length == 2) {
            final field = parts[0].trim();
            final value = whereArgs.isNotEmpty ? whereArgs[0] : null;
            shouldUpdate = items[i][field] == value;
          }
        }
      }
      
      if (shouldUpdate) {
        items[i] = {...items[i], ...data};
        updatedCount++;
      }
    }
    
    await _saveCollection(table, items);
    return updatedCount;
  }
  
  Future<int> delete(
    String table, {
    String? where,
    List<dynamic>? whereArgs,
  }) async {
    final items = await _getCollection(table);
    int deletedCount = 0;
    
    items.removeWhere((item) {
      bool shouldDelete = true;
      
      if (where != null && whereArgs != null) {
        // Simple where clause implementation
        if (where.contains('=')) {
          final parts = where.split('=');
          if (parts.length == 2) {
            final field = parts[0].trim();
            final value = whereArgs.isNotEmpty ? whereArgs[0] : null;
            shouldDelete = item[field] == value;
          }
        }
      }
      
      if (shouldDelete) {
        deletedCount++;
        return true;
      }
      return false;
    });
    
    await _saveCollection(table, items);
    return deletedCount;
  }
  
  Future<List<Map<String, dynamic>>> _getCollection(String table) async {
    final preferences = await prefs;
    final jsonString = preferences.getString(table) ?? '[]';
    final List<dynamic> jsonList = json.decode(jsonString);
    return jsonList.cast<Map<String, dynamic>>();
  }
  
  Future<void> _saveCollection(String table, List<Map<String, dynamic>> items) async {
    final preferences = await prefs;
    final jsonString = json.encode(items);
    await preferences.setString(table, jsonString);
  }
  
  Future<void> close() async {
    // Nothing to close for SharedPreferences
  }
}