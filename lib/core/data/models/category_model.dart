import 'package:flutter/material.dart';

/// A spending / income category. The catalog is fixed (offline-first), but
/// each category is referenced by [id] everywhere so the UI can resolve its
/// localized name, icon and color without storing them on every transaction.
class TxCategory {
  final String id;
  final String nameKey; // localization key
  final String icon; // svg asset path
  final int colorValue;
  final bool isIncome;

  const TxCategory({
    required this.id,
    required this.nameKey,
    required this.icon,
    required this.colorValue,
    required this.isIncome,
  });

  Color get color => Color(colorValue);
}

/// Fixed catalog of categories. Icons are taken from the existing `assets/svg`.
class Categories {
  Categories._();

  static const List<TxCategory> expense = [
    TxCategory(
      id: 'food',
      nameKey: 'cat_food',
      icon: 'assets/svg/burger.svg',
      colorValue: 0xFFF59E0B,
      isIncome: false,
    ),
    TxCategory(
      id: 'transport',
      nameKey: 'cat_transport',
      icon: 'assets/svg/bus.svg',
      colorValue: 0xFF3B82F6,
      isIncome: false,
    ),
    TxCategory(
      id: 'shopping',
      nameKey: 'cat_shopping',
      icon: 'assets/svg/bag.svg',
      colorValue: 0xFFEC4899,
      isIncome: false,
    ),
    TxCategory(
      id: 'bills',
      nameKey: 'cat_bills',
      icon: 'assets/svg/house.svg',
      colorValue: 0xFF8B5CF6,
      isIncome: false,
    ),
    TxCategory(
      id: 'entertainment',
      nameKey: 'cat_entertainment',
      icon: 'assets/svg/game.svg',
      colorValue: 0xFF06B6D4,
      isIncome: false,
    ),
    TxCategory(
      id: 'health',
      nameKey: 'cat_health',
      icon: 'assets/svg/heart.svg',
      colorValue: 0xFFEF4444,
      isIncome: false,
    ),
    TxCategory(
      id: 'other_expense',
      nameKey: 'cat_other',
      icon: 'assets/svg/more.svg',
      colorValue: 0xFF64748B,
      isIncome: false,
    ),
  ];

  static const List<TxCategory> income = [
    TxCategory(
      id: 'salary',
      nameKey: 'cat_salary',
      icon: 'assets/svg/cash.svg',
      colorValue: 0xFF10B981,
      isIncome: true,
    ),
    TxCategory(
      id: 'freelance',
      nameKey: 'cat_freelance',
      icon: 'assets/svg/lap.svg',
      colorValue: 0xFF6366F1,
      isIncome: true,
    ),
    TxCategory(
      id: 'investment',
      nameKey: 'cat_investment',
      icon: 'assets/svg/bank.svg',
      colorValue: 0xFF0EA5E9,
      isIncome: true,
    ),
    TxCategory(
      id: 'gift',
      nameKey: 'cat_gift',
      icon: 'assets/svg/heart.svg',
      colorValue: 0xFFF43F5E,
      isIncome: true,
    ),
    TxCategory(
      id: 'other_income',
      nameKey: 'cat_other',
      icon: 'assets/svg/more.svg',
      colorValue: 0xFF64748B,
      isIncome: true,
    ),
  ];

  static List<TxCategory> get all => [...income, ...expense];

  static TxCategory? byId(String? id) {
    if (id == null) return null;
    for (final c in all) {
      if (c.id == id) return c;
    }
    return null;
  }

  /// Safe lookup that always returns a category (falls back to "other").
  static TxCategory resolve(String? id, {bool isIncome = false}) {
    return byId(id) ??
        (isIncome ? income.last : expense.last);
  }
}
