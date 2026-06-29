import 'package:flutter/material.dart';

enum AccountType { cash, bank, card }

extension AccountTypeX on AccountType {
  String get nameKey {
    switch (this) {
      case AccountType.cash:
        return 'acc_type_cash';
      case AccountType.bank:
        return 'acc_type_bank';
      case AccountType.card:
        return 'acc_type_card';
    }
  }

  String get icon {
    switch (this) {
      case AccountType.cash:
        return 'assets/svg/cash.svg';
      case AccountType.bank:
        return 'assets/svg/bank.svg';
      case AccountType.card:
        return 'assets/svg/pay.svg';
    }
  }
}

class AccountModel {
  final String id;
  final String name;
  final AccountType type;

  /// Starting balance of the account. The *current* balance is computed by the
  /// repository from this value plus all related transactions.
  final double openingBalance;
  final int colorValue;

  const AccountModel({
    required this.id,
    required this.name,
    required this.type,
    required this.openingBalance,
    required this.colorValue,
  });

  Color get color => Color(colorValue);

  AccountModel copyWith({
    String? name,
    AccountType? type,
    double? openingBalance,
    int? colorValue,
  }) {
    return AccountModel(
      id: id,
      name: name ?? this.name,
      type: type ?? this.type,
      openingBalance: openingBalance ?? this.openingBalance,
      colorValue: colorValue ?? this.colorValue,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'type': type.index,
    'openingBalance': openingBalance,
    'colorValue': colorValue,
  };

  factory AccountModel.fromJson(Map<String, dynamic> json) => AccountModel(
    id: json['id'] as String,
    name: json['name'] as String,
    type: AccountType.values[(json['type'] as num?)?.toInt() ?? 0],
    openingBalance: (json['openingBalance'] as num?)?.toDouble() ?? 0,
    colorValue: (json['colorValue'] as num?)?.toInt() ?? 0xFF2563EB,
  );
}
