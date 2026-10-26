import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';

import '../providers/transaction_provider.dart';

class ReportsScreen extends StatelessWidget {
  const ReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<TransactionProvider>();

    final expenses = provider.transactions
        .where((t) => t.type == 'Expense')
        .toList();

    final categoryTotals = <String, double>{};

    for (final transaction in expenses) {
      categoryTotals.update(
        transaction.category,
        (value) => value + transaction.amount,
        ifAbsent: () => transaction.amount,
      );
    }

    final entries = categoryTotals.entries.toList();

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text(
          'Financial Reports',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        Card(
          child: ListTile(
            leading: const Icon(Icons.trending_up, color: Colors.green),
            title: const Text('Total Income'),
            trailing: Text(
              '₹${provider.totalIncome.toStringAsFixed(2)}',
            ),
          ),
        ),
        Card(
          child: ListTile(
            leading: const Icon(Icons.trending_down, color: Colors.red),
            title: const Text('Total Expenses'),
            trailing: Text(
              '₹${provider.totalExpense.toStringAsFixed(2)}',
            ),
          ),
        ),
        Card(
          child: ListTile(
            leading: const Icon(Icons.account_balance_wallet),
            title: const Text('Net Balance'),
            trailing: Text(
              '₹${provider.balance.toStringAsFixed(2)}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ),
        const SizedBox(height: 24),
        const Text(
          'Expense by Category',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        if (entries.isEmpty)
          const Padding(
            padding: EdgeInsets.all(30),
            child: Center(child: Text('No expense data available yet')),
          )
        else ...[
          SizedBox(
            height: 240,
            child: PieChart(
              PieChartData(
                sectionsSpace: 3,
                centerSpaceRadius: 38,
                sections: List.generate(entries.length, (index) {
                  final entry = entries[index];

                  return PieChartSectionData(
                    value: entry.value,
                    title:
                        '${(entry.value / provider.totalExpense * 100).toStringAsFixed(0)}%',
                    radius: 85,
                    titleStyle: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  );
                }),
              ),
            ),
          ),
          const SizedBox(height: 16),
          ...entries.map(
            (entry) => ListTile(
              leading: const Icon(Icons.circle, size: 14),
              title: Text(entry.key),
              trailing: Text('₹${entry.value.toStringAsFixed(2)}'),
            ),
          ),
        ],
      ],
    );
  }
}