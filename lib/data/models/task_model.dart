import 'package:json_annotation/json_annotation.dart';

part 'task_model.g.dart';

@JsonSerializable()
class TaskModel {
  final String id;
  final String title;
  final String? description;
  final String status;
  final String priority;
  final String projectId;
  final String? assignedTo;
  final String createdBy;
  final DateTime? startDate;
  final DateTime? dueDate;
  final DateTime? completedAt;
  final double? estimatedHours;
  final double? actualHours;
  final double progress;
  final DateTime createdAt;
  final DateTime updatedAt;

  TaskModel({
    required this.id,
    required this.title,
    this.description,
    required this.status,
    required this.priority,
    required this.projectId,
    this.assignedTo,
    required this.createdBy,
    this.startDate,
    this.dueDate,
    this.completedAt,
    this.estimatedHours,
    this.actualHours,
    this.progress = 0.0,
    required this.createdAt,
    required this.updatedAt,
  });

  factory TaskModel.fromJson(Map<String, dynamic> json) => _$TaskModelFromJson(json);
  Map<String, dynamic> toJson() => _$TaskModelToJson(this);

  // Database conversion
  Map<String, dynamic> toDatabase() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'status': status,
      'priority': priority,
      'project_id': projectId,
      'assigned_to': assignedTo,
      'created_by': createdBy,
      'start_date': startDate?.toIso8601String(),
      'due_date': dueDate?.toIso8601String(),
      'completed_at': completedAt?.toIso8601String(),
      'estimated_hours': estimatedHours,
      'actual_hours': actualHours,
      'progress': progress,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  factory TaskModel.fromDatabase(Map<String, dynamic> map) {
    return TaskModel(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      status: map['status'],
      priority: map['priority'],
      projectId: map['project_id'],
      assignedTo: map['assigned_to'],
      createdBy: map['created_by'],
      startDate: map['start_date'] != null ? DateTime.parse(map['start_date']) : null,
      dueDate: map['due_date'] != null ? DateTime.parse(map['due_date']) : null,
      completedAt: map['completed_at'] != null ? DateTime.parse(map['completed_at']) : null,
      estimatedHours: map['estimated_hours']?.toDouble(),
      actualHours: map['actual_hours']?.toDouble(),
      progress: map['progress']?.toDouble() ?? 0.0,
      createdAt: DateTime.parse(map['created_at']),
      updatedAt: DateTime.parse(map['updated_at']),
    );
  }

  TaskModel copyWith({
    String? id,
    String? title,
    String? description,
    String? status,
    String? priority,
    String? projectId,
    String? assignedTo,
    String? createdBy,
    DateTime? startDate,
    DateTime? dueDate,
    DateTime? completedAt,
    double? estimatedHours,
    double? actualHours,
    double? progress,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return TaskModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      status: status ?? this.status,
      priority: priority ?? this.priority,
      projectId: projectId ?? this.projectId,
      assignedTo: assignedTo ?? this.assignedTo,
      createdBy: createdBy ?? this.createdBy,
      startDate: startDate ?? this.startDate,
      dueDate: dueDate ?? this.dueDate,
      completedAt: completedAt ?? this.completedAt,
      estimatedHours: estimatedHours ?? this.estimatedHours,
      actualHours: actualHours ?? this.actualHours,
      progress: progress ?? this.progress,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  bool get isTodo => status == 'todo';
  bool get isInProgress => status == 'in_progress';
  bool get isCompleted => status == 'completed';
  bool get isBlocked => status == 'blocked';

  bool get isHighPriority => priority == 'high' || priority == 'critical';
  bool get isOverdue => dueDate != null && DateTime.now().isAfter(dueDate!) && !isCompleted;

  Duration? get remainingTime {
    if (dueDate == null || isCompleted) return null;
    final now = DateTime.now();
    if (now.isAfter(dueDate!)) return Duration.zero;
    return dueDate!.difference(now);
  }

  double get efficiencyRatio {
    if (estimatedHours == null || actualHours == null || actualHours == 0) return 1.0;
    return estimatedHours! / actualHours!;
  }
}