/// A monthly spending limit for a single expense category.
class BudgetModel {
  final String id;
  final String categoryId;
  final double limit;

  const BudgetModel({
    required this.id,
    required this.categoryId,
    required this.limit,
  });

  BudgetModel copyWith({String? categoryId, double? limit}) => BudgetModel(
    id: id,
    categoryId: categoryId ?? this.categoryId,
    limit: limit ?? this.limit,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'categoryId': categoryId,
    'limit': limit,
  };

  factory BudgetModel.fromJson(Map<String, dynamic> json) => BudgetModel(
    id: json['id'] as String,
    categoryId: json['categoryId'] as String,
    limit: (json['limit'] as num?)?.toDouble() ?? 0,
  );
}
