
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/transaction_model.dart';
import 'database_initializer.dart';

class DatabaseService {
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;

    // Initialize the correct database factory first.
    await initializeDatabaseFactory();

    final dbPath = join(
      await getDatabasesPath(),
      'expense_manager.db',
    );

    _database = await openDatabase(
      dbPath,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE transactions(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            userId TEXT NOT NULL,
            title TEXT NOT NULL,
            amount REAL NOT NULL,
            type TEXT NOT NULL,
            category TEXT NOT NULL,
            date TEXT NOT NULL,
            description TEXT NOT NULL
          )
        ''');

        await db.execute('''
          CREATE TABLE settings(
            userId TEXT PRIMARY KEY,
            budget REAL NOT NULL
          )
        ''');
      },
    );

    return _database!;
  }

  Future<List<TransactionModel>> getTransactions(
    String userId,
  ) async {
    final db = await database;

    final rows = await db.query(
      'transactions',
      where: 'userId = ?',
      whereArgs: [userId],
      orderBy: 'date DESC',
    );

    return rows.map(TransactionModel.fromMap).toList();
  }

  Future<int> addTransaction(
    TransactionModel transaction,
  ) async {
    final db = await database;

    final id = await db.insert(
      'transactions',
      transaction.toMap()..remove('id'),
    );

    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(transaction.userId)
          .collection('transactions')
          .doc(id.toString())
          .set({
        ...transaction.toMap(),
        'id': id,
        'date': transaction.date.toIso8601String(),
      });
    } catch (_) {
      // The local transaction remains saved if cloud sync fails.
    }

    return id;
  }

  Future<int> updateTransaction(
    TransactionModel transaction,
  ) async {
    final db = await database;

    final id = transaction.id;

    if (id == null) {
      throw ArgumentError(
        'Transaction ID is required for updating.',
      );
    }

    final result = await db.update(
      'transactions',
      transaction.toMap()..remove('id'),
      where: 'id = ? AND userId = ?',
      whereArgs: [id, transaction.userId],
    );

    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(transaction.userId)
          .collection('transactions')
          .doc(id.toString())
          .set({
        ...transaction.toMap(),
        'id': id,
        'date': transaction.date.toIso8601String(),
      });
    } catch (_) {
      // The local update remains saved if cloud sync fails.
    }

    return result;
  }

  Future<void> deleteTransaction(
    int id,
    String userId,
  ) async {
    final db = await database;

    await db.delete(
      'transactions',
      where: 'id = ? AND userId = ?',
      whereArgs: [id, userId],
    );

    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('transactions')
          .doc(id.toString())
          .delete();
    } catch (_) {
      // The local deletion remains complete if cloud sync fails.
    }
  }

  Future<double> getBudget(String userId) async {
    final db = await database;

    final rows = await db.query(
      'settings',
      where: 'userId = ?',
      whereArgs: [userId],
    );

    if (rows.isEmpty) return 10000;

    return (rows.first['budget'] as num).toDouble();
  }

  Future<void> saveBudget(
    String userId,
    double budget,
  ) async {
    final db = await database;

    await db.insert(
      'settings',
      {
        'userId': userId,
        'budget': budget,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
}