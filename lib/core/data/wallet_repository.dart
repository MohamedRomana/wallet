import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import 'models/account_model.dart';
import 'models/budget_model.dart';
import 'models/goal_model.dart';
import 'models/transaction_model.dart';

/// Local-first persistence for all wallet data. Everything is stored as JSON in
/// SharedPreferences and kept in memory for fast synchronous reads.
class WalletRepository {
  WalletRepository._();
  static final WalletRepository instance = WalletRepository._();

  static const _kAccounts = 'wallet_accounts';
  static const _kTransactions = 'wallet_transactions';
  static const _kBudgets = 'wallet_budgets';
  static const _kGoals = 'wallet_goals';
  static const _kSeeded = 'wallet_seeded';

  late SharedPreferences _prefs;

  final List<AccountModel> accounts = [];
  final List<TransactionModel> transactions = [];
  final List<BudgetModel> budgets = [];
  final List<GoalModel> goals = [];

  int _idCounter = 0;

  String newId() {
    _idCounter++;
    return '${DateTime.now().microsecondsSinceEpoch}_$_idCounter';
  }

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    _load(_kAccounts, accounts, (j) => AccountModel.fromJson(j));
    _load(_kTransactions, transactions, (j) => TransactionModel.fromJson(j));
    _load(_kBudgets, budgets, (j) => BudgetModel.fromJson(j));
    _load(_kGoals, goals, (j) => GoalModel.fromJson(j));

    if (_prefs.getBool(_kSeeded) != true) {
      _seedSampleData();
      await _prefs.setBool(_kSeeded, true);
    }
  }

  void _load<T>(
    String key,
    List<T> target,
    T Function(Map<String, dynamic>) fromJson,
  ) {
    target.clear();
    final raw = _prefs.getString(key);
    if (raw == null || raw.isEmpty) return;
    try {
      final list = jsonDecode(raw) as List;
      for (final e in list) {
        target.add(fromJson(e as Map<String, dynamic>));
      }
    } catch (_) {
      // corrupted data — start clean for this collection
    }
  }

  Future<void> _save(String key, List<dynamic> items) async {
    await _prefs.setString(
      key,
      jsonEncode(items.map((e) => e.toJson()).toList()),
    );
  }

  // ---------------------------------------------------------------------------
  // Accounts
  // ---------------------------------------------------------------------------
  Future<AccountModel> addAccount({
    required String name,
    required AccountType type,
    required double openingBalance,
    required int colorValue,
  }) async {
    final account = AccountModel(
      id: newId(),
      name: name,
      type: type,
      openingBalance: openingBalance,
      colorValue: colorValue,
    );
    accounts.add(account);
    await _save(_kAccounts, accounts);
    return account;
  }

  Future<void> updateAccount(AccountModel account) async {
    final i = accounts.indexWhere((a) => a.id == account.id);
    if (i != -1) {
      accounts[i] = account;
      await _save(_kAccounts, accounts);
    }
  }

  /// Deletes an account and any transaction that references it.
  Future<void> deleteAccount(String id) async {
    accounts.removeWhere((a) => a.id == id);
    transactions.removeWhere(
      (t) =>
          t.accountId == id ||
          t.fromAccountId == id ||
          t.toAccountId == id,
    );
    await _save(_kAccounts, accounts);
    await _save(_kTransactions, transactions);
  }

  // ---------------------------------------------------------------------------
  // Transactions
  // ---------------------------------------------------------------------------
  Future<TransactionModel> addTransaction(TransactionModel tx) async {
    final stored = tx.id.isEmpty
        ? TransactionModel(
            id: newId(),
            type: tx.type,
            amount: tx.amount,
            categoryId: tx.categoryId,
            accountId: tx.accountId,
            fromAccountId: tx.fromAccountId,
            toAccountId: tx.toAccountId,
            date: tx.date,
            note: tx.note,
          )
        : tx;
    transactions.add(stored);
    await _save(_kTransactions, transactions);
    return stored;
  }

  Future<void> updateTransaction(TransactionModel tx) async {
    final i = transactions.indexWhere((t) => t.id == tx.id);
    if (i != -1) {
      transactions[i] = tx;
      await _save(_kTransactions, transactions);
    }
  }

  Future<void> deleteTransaction(String id) async {
    transactions.removeWhere((t) => t.id == id);
    await _save(_kTransactions, transactions);
  }

  // ---------------------------------------------------------------------------
  // Budgets
  // ---------------------------------------------------------------------------
  Future<void> upsertBudget(BudgetModel budget) async {
    final i = budgets.indexWhere((b) => b.id == budget.id);
    if (i != -1) {
      budgets[i] = budget;
    } else {
      budgets.add(budget);
    }
    await _save(_kBudgets, budgets);
  }

  Future<void> deleteBudget(String id) async {
    budgets.removeWhere((b) => b.id == id);
    await _save(_kBudgets, budgets);
  }

  // ---------------------------------------------------------------------------
  // Goals
  // ---------------------------------------------------------------------------
  Future<void> upsertGoal(GoalModel goal) async {
    final i = goals.indexWhere((g) => g.id == goal.id);
    if (i != -1) {
      goals[i] = goal;
    } else {
      goals.add(goal);
    }
    await _save(_kGoals, goals);
  }

  Future<void> deleteGoal(String id) async {
    goals.removeWhere((g) => g.id == id);
    await _save(_kGoals, goals);
  }

  Future<void> clearAll() async {
    accounts.clear();
    transactions.clear();
    budgets.clear();
    goals.clear();
    await _save(_kAccounts, accounts);
    await _save(_kTransactions, transactions);
    await _save(_kBudgets, budgets);
    await _save(_kGoals, goals);
  }

  // ---------------------------------------------------------------------------
  // Seed sample data on first launch so the app never looks empty.
  // ---------------------------------------------------------------------------
  void _seedSampleData() {
    final now = DateTime.now();
    final cash = AccountModel(
      id: newId(),
      name: 'Cash',
      type: AccountType.cash,
      openingBalance: 500,
      colorValue: 0xFF10B981,
    );
    final bank = AccountModel(
      id: newId(),
      name: 'Bank',
      type: AccountType.bank,
      openingBalance: 4200,
      colorValue: 0xFF2563EB,
    );
    final card = AccountModel(
      id: newId(),
      name: 'Card',
      type: AccountType.card,
      openingBalance: 1500,
      colorValue: 0xFF8B5CF6,
    );
    accounts.addAll([cash, bank, card]);

    transactions.addAll([
      TransactionModel(
        id: newId(),
        type: TxType.income,
        amount: 3200,
        categoryId: 'salary',
        accountId: bank.id,
        date: DateTime(now.year, now.month, 1),
        note: 'Monthly salary',
      ),
      TransactionModel(
        id: newId(),
        type: TxType.expense,
        amount: 850,
        categoryId: 'bills',
        accountId: bank.id,
        date: DateTime(now.year, now.month, 3),
        note: 'Rent',
      ),
      TransactionModel(
        id: newId(),
        type: TxType.expense,
        amount: 120,
        categoryId: 'food',
        accountId: cash.id,
        date: DateTime(now.year, now.month, 5),
        note: 'Groceries',
      ),
      TransactionModel(
        id: newId(),
        type: TxType.expense,
        amount: 60,
        categoryId: 'transport',
        accountId: card.id,
        date: DateTime(now.year, now.month, 7),
        note: 'Fuel',
      ),
      TransactionModel(
        id: newId(),
        type: TxType.expense,
        amount: 200,
        categoryId: 'shopping',
        accountId: card.id,
        date: DateTime(now.year, now.month, 9),
        note: 'Clothes',
      ),
      TransactionModel(
        id: newId(),
        type: TxType.income,
        amount: 450,
        categoryId: 'freelance',
        accountId: bank.id,
        date: DateTime(now.year, now.month, 12),
        note: 'Side project',
      ),
    ]);

    budgets.addAll([
      BudgetModel(id: newId(), categoryId: 'food', limit: 600),
      BudgetModel(id: newId(), categoryId: 'bills', limit: 1000),
      BudgetModel(id: newId(), categoryId: 'entertainment', limit: 300),
    ]);

    goals.addAll([
      GoalModel(
        id: newId(),
        title: 'Emergency Fund',
        targetAmount: 5000,
        savedAmount: 1250,
        deadline: DateTime(now.year, now.month + 6, now.day),
        icon: 'assets/svg/emerg.svg',
        colorValue: 0xFFEF4444,
      ),
      GoalModel(
        id: newId(),
        title: 'Vacation Trip',
        targetAmount: 3500,
        savedAmount: 1400,
        deadline: DateTime(now.year, now.month + 4, now.day),
        icon: 'assets/svg/vact.svg',
        colorValue: 0xFF06B6D4,
      ),
      GoalModel(
        id: newId(),
        title: 'New Laptop',
        targetAmount: 1800,
        savedAmount: 1080,
        deadline: DateTime(now.year, now.month + 2, now.day),
        icon: 'assets/svg/lap.svg',
        colorValue: 0xFF6366F1,
      ),
    ]);

    _save(_kAccounts, accounts);
    _save(_kTransactions, transactions);
    _save(_kBudgets, budgets);
    _save(_kGoals, goals);
  }
}
