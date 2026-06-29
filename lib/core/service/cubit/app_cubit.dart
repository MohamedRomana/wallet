import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../screens/features/home_layout/accounts/accounts.dart';
import '../../../screens/features/home_layout/add/add.dart';
import '../../../screens/features/home_layout/budget/budget.dart';
import '../../../screens/features/home_layout/goals/goals.dart';
import '../../../screens/features/home_layout/home/home.dart';
import '../../cache/cache_helper.dart';
import '../../constants/contsants.dart';
import '../../data/models/account_model.dart';
import '../../data/models/budget_model.dart';
import '../../data/models/category_model.dart';
import '../../data/models/goal_model.dart';
import '../../data/models/transaction_model.dart';
import '../../data/wallet_repository.dart';

part 'app_state.dart';

/// Single cubit driving the whole wallet. All reads are synchronous off the
/// in-memory repository; every mutation persists and emits [WalletUpdated].
class AppCubit extends Cubit<AppState> {
  AppCubit() : super(AppInitial());

  static AppCubit get(BuildContext context) =>
      BlocProvider.of<AppCubit>(context);

  final WalletRepository repo = WalletRepository.instance;

  // ---------------------------------------------------------------------------
  // Navigation
  // ---------------------------------------------------------------------------
  int bottomNavIndex = 0;
  final List<Widget> bottomNavScreens = const [
    Home(),
    Accounts(),
    Add(),
    Budget(),
    Goals(),
  ];

  /// Which sub-tab (income/expense/transfer) the Add screen should open on.
  int addInitialTab = 0;

  void changebottomNavIndex(int index) {
    bottomNavIndex = index;
    emit(BottomNavChanged());
  }

  /// Open the Add screen on a specific sub-tab (0=income, 1=expense, 2=transfer).
  void openAdd(int tab) {
    addInitialTab = tab;
    bottomNavIndex = 2;
    emit(BottomNavChanged());
  }

  // ---------------------------------------------------------------------------
  // Theme
  // ---------------------------------------------------------------------------
  bool isDark = CacheHelper.getDarkMode();
  Future<void> toggleTheme(bool value) async {
    isDark = value;
    await CacheHelper.setDarkMode(value);
    ThemeController.isDark.value = value;
    emit(ThemeChanged());
  }

  // ---------------------------------------------------------------------------
  // Language
  // ---------------------------------------------------------------------------
  Future<void> changeLanguage(BuildContext context, String code) async {
    await context.setLocale(Locale(code));
    await CacheHelper.setLang(code);
    emit(LocaleChanged());
  }

  // ---------------------------------------------------------------------------
  // Convenience getters
  // ---------------------------------------------------------------------------
  List<AccountModel> get accounts => repo.accounts;
  List<TransactionModel> get transactions => repo.transactions;
  List<BudgetModel> get budgets => repo.budgets;
  List<GoalModel> get goals => repo.goals;

  /// Transactions newest-first.
  List<TransactionModel> get sortedTransactions {
    final list = [...repo.transactions];
    list.sort((a, b) => b.date.compareTo(a.date));
    return list;
  }

  List<TransactionModel> recentTransactions([int limit = 5]) =>
      sortedTransactions.take(limit).toList();

  // ---------------------------------------------------------------------------
  // Balance math
  // ---------------------------------------------------------------------------
  double accountBalance(String accountId) {
    final account = accounts.firstWhere(
      (a) => a.id == accountId,
      orElse: () => const AccountModel(
        id: '',
        name: '',
        type: AccountType.cash,
        openingBalance: 0,
        colorValue: 0,
      ),
    );
    double balance = account.openingBalance;
    for (final t in transactions) {
      switch (t.type) {
        case TxType.income:
          if (t.accountId == accountId) balance += t.amount;
          break;
        case TxType.expense:
          if (t.accountId == accountId) balance -= t.amount;
          break;
        case TxType.transfer:
          if (t.fromAccountId == accountId) balance -= t.amount;
          if (t.toAccountId == accountId) balance += t.amount;
          break;
      }
    }
    return balance;
  }

  double get totalBalance {
    double sum = 0;
    for (final a in accounts) {
      sum += accountBalance(a.id);
    }
    return sum;
  }

  bool _inMonth(DateTime d, DateTime month) =>
      d.year == month.year && d.month == month.month;

  double incomeForMonth([DateTime? month]) {
    final m = month ?? DateTime.now();
    return transactions
        .where((t) => t.type == TxType.income && _inMonth(t.date, m))
        .fold(0.0, (s, t) => s + t.amount);
  }

  double expenseForMonth([DateTime? month]) {
    final m = month ?? DateTime.now();
    return transactions
        .where((t) => t.type == TxType.expense && _inMonth(t.date, m))
        .fold(0.0, (s, t) => s + t.amount);
  }

  double spentForCategory(String categoryId, [DateTime? month]) {
    final m = month ?? DateTime.now();
    return transactions
        .where(
          (t) =>
              t.type == TxType.expense &&
              t.categoryId == categoryId &&
              _inMonth(t.date, m),
        )
        .fold(0.0, (s, t) => s + t.amount);
  }

  /// Expense totals grouped by category for [month], largest first.
  List<MapEntry<TxCategory, double>> categoryBreakdown([DateTime? month]) {
    final m = month ?? DateTime.now();
    final map = <String, double>{};
    for (final t in transactions) {
      if (t.type == TxType.expense && _inMonth(t.date, m)) {
        map[t.categoryId ?? 'other_expense'] =
            (map[t.categoryId ?? 'other_expense'] ?? 0) + t.amount;
      }
    }
    final entries = map.entries
        .map((e) => MapEntry(Categories.resolve(e.key), e.value))
        .toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    return entries;
  }

  /// Net (income - expense) for the last [count] months, oldest-first.
  List<MonthlyPoint> monthlyCashFlow([int count = 6]) {
    final now = DateTime.now();
    final points = <MonthlyPoint>[];
    for (int i = count - 1; i >= 0; i--) {
      final m = DateTime(now.year, now.month - i, 1);
      points.add(
        MonthlyPoint(
          month: m,
          income: incomeForMonth(m),
          expense: expenseForMonth(m),
        ),
      );
    }
    return points;
  }

  // ---------------------------------------------------------------------------
  // Mutations
  // ---------------------------------------------------------------------------
  Future<void> addAccount({
    required String name,
    required AccountType type,
    required double openingBalance,
    required int colorValue,
  }) async {
    await repo.addAccount(
      name: name,
      type: type,
      openingBalance: openingBalance,
      colorValue: colorValue,
    );
    emit(WalletUpdated());
  }

  Future<void> updateAccount(AccountModel account) async {
    await repo.updateAccount(account);
    emit(WalletUpdated());
  }

  Future<void> deleteAccount(String id) async {
    await repo.deleteAccount(id);
    emit(WalletUpdated());
  }

  Future<void> addTransaction(TransactionModel tx) async {
    await repo.addTransaction(tx);
    emit(WalletUpdated());
  }

  Future<void> updateTransaction(TransactionModel tx) async {
    await repo.updateTransaction(tx);
    emit(WalletUpdated());
  }

  Future<void> deleteTransaction(String id) async {
    await repo.deleteTransaction(id);
    emit(WalletUpdated());
  }

  Future<void> saveBudget(BudgetModel budget) async {
    await repo.upsertBudget(budget);
    emit(WalletUpdated());
  }

  Future<void> deleteBudget(String id) async {
    await repo.deleteBudget(id);
    emit(WalletUpdated());
  }

  Future<void> saveGoal(GoalModel goal) async {
    await repo.upsertGoal(goal);
    emit(WalletUpdated());
  }

  Future<void> contributeToGoal(GoalModel goal, double amount) async {
    await repo.upsertGoal(
      goal.copyWith(savedAmount: goal.savedAmount + amount),
    );
    emit(WalletUpdated());
  }

  Future<void> deleteGoal(String id) async {
    await repo.deleteGoal(id);
    emit(WalletUpdated());
  }

  Future<void> resetAllData() async {
    await repo.clearAll();
    emit(WalletUpdated());
  }

  String newId() => repo.newId();
}

/// A single month's income/expense aggregate for the cash-flow chart.
class MonthlyPoint {
  final DateTime month;
  final double income;
  final double expense;
  const MonthlyPoint({
    required this.month,
    required this.income,
    required this.expense,
  });

  double get net => income - expense;
}
