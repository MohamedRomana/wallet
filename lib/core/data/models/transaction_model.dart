enum TxType { income, expense, transfer }

class TransactionModel {
  final String id;
  final TxType type;
  final double amount;

  /// Category id (income/expense only). Null for transfers.
  final String? categoryId;

  /// Account the money flows from/to. For income -> [accountId] receives money,
  /// for expense -> [accountId] is debited, for transfer -> [fromAccountId] to
  /// [toAccountId].
  final String? accountId;
  final String? fromAccountId;
  final String? toAccountId;

  final DateTime date;
  final String note;

  const TransactionModel({
    required this.id,
    required this.type,
    required this.amount,
    this.categoryId,
    this.accountId,
    this.fromAccountId,
    this.toAccountId,
    required this.date,
    this.note = '',
  });

  TransactionModel copyWith({
    TxType? type,
    double? amount,
    String? categoryId,
    String? accountId,
    String? fromAccountId,
    String? toAccountId,
    DateTime? date,
    String? note,
  }) {
    return TransactionModel(
      id: id,
      type: type ?? this.type,
      amount: amount ?? this.amount,
      categoryId: categoryId ?? this.categoryId,
      accountId: accountId ?? this.accountId,
      fromAccountId: fromAccountId ?? this.fromAccountId,
      toAccountId: toAccountId ?? this.toAccountId,
      date: date ?? this.date,
      note: note ?? this.note,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'type': type.index,
    'amount': amount,
    'categoryId': categoryId,
    'accountId': accountId,
    'fromAccountId': fromAccountId,
    'toAccountId': toAccountId,
    'date': date.toIso8601String(),
    'note': note,
  };

  factory TransactionModel.fromJson(Map<String, dynamic> json) =>
      TransactionModel(
        id: json['id'] as String,
        type: TxType.values[(json['type'] as num?)?.toInt() ?? 1],
        amount: (json['amount'] as num?)?.toDouble() ?? 0,
        categoryId: json['categoryId'] as String?,
        accountId: json['accountId'] as String?,
        fromAccountId: json['fromAccountId'] as String?,
        toAccountId: json['toAccountId'] as String?,
        date:
            DateTime.tryParse(json['date'] as String? ?? '') ?? DateTime.now(),
        note: json['note'] as String? ?? '',
      );
}
