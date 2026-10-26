import 'package:flutter/foundation.dart';

import '../models/transaction_model.dart';
import '../services/database_service.dart';

class TransactionProvider extends ChangeNotifier {
  final DatabaseService _db = DatabaseService();

  List<TransactionModel> _transactions = [];
  String _search = '';
  String _typeFilter = 'All';
  String _categoryFilter = 'All';

  double budget = 10000;
  bool loading = false;
  String? error;

  List<TransactionModel> get transactions => _transactions;

  List<TransactionModel> get filteredTransactions {
    return _transactions.where((t) {
      final matchesSearch =
          t.title.toLowerCase().contains(_search.toLowerCase()) ||
          t.category.toLowerCase().contains(_search.toLowerCase());

      final matchesType =
          _typeFilter == 'All' || t.type == _typeFilter;

      final matchesCategory =
          _categoryFilter == 'All' || t.category == _categoryFilter;

      return matchesSearch && matchesType && matchesCategory;
    }).toList();
  }

  double get totalIncome => _transactions
      .where((t) => t.type == 'Income')
      .fold(0.0, (sum, t) => sum + t.amount);

  double get totalExpense => _transactions
      .where((t) => t.type == 'Expense')
      .fold(0.0, (sum, t) => sum + t.amount);

  double get balance => totalIncome - totalExpense;

  double get remainingBudget => budget - totalExpense;

  Future<void> load(String userId) async {
    loading = true;
    error = null;
    notifyListeners();

    try {
      _transactions = await _db.getTransactions(userId);
      budget = await _db.getBudget(userId);
    } catch (e) {
      error = 'Could not load local data: $e';
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  Future<void> add(TransactionModel transaction) async {
    try {
      final id = await _db.addTransaction(transaction);

      _transactions.insert(
        0,
        TransactionModel(
          id: id,
          userId: transaction.userId,
          title: transaction.title,
          amount: transaction.amount,
          type: transaction.type,
          category: transaction.category,
          date: transaction.date,
          description: transaction.description,
        ),
      );

      notifyListeners();
    } catch (e) {
      error = 'Unable to save transaction: $e';
      notifyListeners();
      rethrow;
    }
  }

  Future<void> update(TransactionModel transaction) async {
    await _db.updateTransaction(transaction);

    final index = _transactions.indexWhere(
      (t) => t.id == transaction.id,
    );

    if (index != -1) {
      _transactions[index] = transaction;
    }

    notifyListeners();
  }

  Future<void> delete(int id, String userId) async {
    await _db.deleteTransaction(id, userId);

    _transactions.removeWhere((t) => t.id == id);
    notifyListeners();
  }

  void setSearch(String value) {
    _search = value;
    notifyListeners();
  }

  void setTypeFilter(String value) {
    _typeFilter = value;
    notifyListeners();
  }

  void setCategoryFilter(String value) {
    _categoryFilter = value;
    notifyListeners();
  }

  Future<void> updateBudget(String userId, double value) async {
    await _db.saveBudget(userId, value);
    budget = value;
    notifyListeners();
  }
}