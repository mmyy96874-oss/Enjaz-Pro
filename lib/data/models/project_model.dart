import 'package:json_annotation/json_annotation.dart';

part 'project_model.g.dart';

@JsonSerializable()
class ProjectModel {
  final String id;
  final String name;
  final String? description;
  final String status;
  final String priority;
  final DateTime startDate;
  final DateTime? endDate;
  final double? budget;
  final double progress;
  final String managerId;
  final String createdBy;
  final DateTime createdAt;
  final DateTime updatedAt;

  ProjectModel({
    required this.id,
    required this.name,
    this.description,
    required this.status,
    required this.priority,
    required this.startDate,
    this.endDate,
    this.budget,
    this.progress = 0.0,
    required this.managerId,
    required this.createdBy,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ProjectModel.fromJson(Map<String, dynamic> json) => _$ProjectModelFromJson(json);
  Map<String, dynamic> toJson() => _$ProjectModelToJson(this);

  // Database conversion
  Map<String, dynamic> toDatabase() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'status': status,
      'priority': priority,
      'start_date': startDate.toIso8601String(),
      'end_date': endDate?.toIso8601String(),
      'budget': budget,
      'progress': progress,
      'manager_id': managerId,
      'created_by': createdBy,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  factory ProjectModel.fromDatabase(Map<String, dynamic> map) {
    return ProjectModel(
      id: map['id'],
      name: map['name'],
      description: map['description'],
      status: map['status'],
      priority: map['priority'],
      startDate: DateTime.parse(map['start_date']),
      endDate: map['end_date'] != null ? DateTime.parse(map['end_date']) : null,
      budget: map['budget']?.toDouble(),
      progress: map['progress']?.toDouble() ?? 0.0,
      managerId: map['manager_id'],
      createdBy: map['created_by'],
      createdAt: DateTime.parse(map['created_at']),
      updatedAt: DateTime.parse(map['updated_at']),
    );
  }

  ProjectModel copyWith({
    String? id,
    String? name,
    String? description,
    String? status,
    String? priority,
    DateTime? startDate,
    DateTime? endDate,
    double? budget,
    double? progress,
    String? managerId,
    String? createdBy,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ProjectModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      status: status ?? this.status,
      priority: priority ?? this.priority,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      budget: budget ?? this.budget,
      progress: progress ?? this.progress,
      managerId: managerId ?? this.managerId,
      createdBy: createdBy ?? this.createdBy,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  bool get isActive => status == 'active';
  bool get isCompleted => status == 'completed';
  bool get isPaused => status == 'paused';
  bool get isCancelled => status == 'cancelled';

  bool get isHighPriority => priority == 'high' || priority == 'critical';
  bool get isOverdue => endDate != null && DateTime.now().isAfter(endDate!) && !isCompleted;

  Duration? get remainingTime {
    if (endDate == null || isCompleted) return null;
    final now = DateTime.now();
    if (now.isAfter(endDate!)) return Duration.zero;
    return endDate!.difference(now);
  }
}