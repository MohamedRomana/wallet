import 'package:flutter/material.dart';

/// A savings goal the user contributes towards over time.
class GoalModel {
  final String id;
  final String title;
  final double targetAmount;
  final double savedAmount;
  final DateTime? deadline;
  final String icon; // svg asset path
  final int colorValue;

  const GoalModel({
    required this.id,
    required this.title,
    required this.targetAmount,
    required this.savedAmount,
    required this.deadline,
    required this.icon,
    required this.colorValue,
  });

  Color get color => Color(colorValue);

  double get progress =>
      targetAmount <= 0 ? 0 : (savedAmount / targetAmount).clamp(0.0, 1.0);

  double get remaining =>
      (targetAmount - savedAmount).clamp(0, double.infinity).toDouble();

  bool get isCompleted => savedAmount >= targetAmount && targetAmount > 0;

  GoalModel copyWith({
    String? title,
    double? targetAmount,
    double? savedAmount,
    DateTime? deadline,
    bool clearDeadline = false,
    String? icon,
    int? colorValue,
  }) {
    return GoalModel(
      id: id,
      title: title ?? this.title,
      targetAmount: targetAmount ?? this.targetAmount,
      savedAmount: savedAmount ?? this.savedAmount,
      deadline: clearDeadline ? null : (deadline ?? this.deadline),
      icon: icon ?? this.icon,
      colorValue: colorValue ?? this.colorValue,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'targetAmount': targetAmount,
    'savedAmount': savedAmount,
    'deadline': deadline?.toIso8601String(),
    'icon': icon,
    'colorValue': colorValue,
  };

  factory GoalModel.fromJson(Map<String, dynamic> json) => GoalModel(
    id: json['id'] as String,
    title: json['title'] as String? ?? '',
    targetAmount: (json['targetAmount'] as num?)?.toDouble() ?? 0,
    savedAmount: (json['savedAmount'] as num?)?.toDouble() ?? 0,
    deadline: json['deadline'] == null
        ? null
        : DateTime.tryParse(json['deadline'] as String),
    icon: json['icon'] as String? ?? 'assets/svg/goal.svg',
    colorValue: (json['colorValue'] as num?)?.toInt() ?? 0xFF2563EB,
  );
}
