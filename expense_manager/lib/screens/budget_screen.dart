import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

import '../providers/transaction_provider.dart';

class BudgetScreen extends StatefulWidget {
  const BudgetScreen({super.key});

  @override
  State<BudgetScreen> createState() => _BudgetScreenState();
}

class _BudgetScreenState extends State<BudgetScreen> {
  final budgetController = TextEditingController();
  bool saving = false;

  @override
  void dispose() {
    budgetController.dispose();
    super.dispose();
  }

  Future<void> saveBudget() async {
    final value = double.tryParse(budgetController.text.trim());

    if (value == null || !value.isFinite || value <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Enter a valid budget amount')),
      );
      return;
    }

    setState(() => saving = true);

    try {
      final userId = FirebaseAuth.instance.currentUser!.uid;

      await context.read<TransactionProvider>().updateBudget(
            userId,
            value,
          );

      budgetController.clear();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Budget updated successfully')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not update budget: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<TransactionProvider>();

    final progress = provider.budget <= 0
        ? 0.0
        : (provider.totalExpense / provider.budget).clamp(0.0, 1.0);

    final exceeded = provider.totalExpense > provider.budget;

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        const Text(
          'Monthly Budget',
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 20),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(22),
            child: Column(
              children: [
                const Icon(
                  Icons.savings,
                  size: 55,
                  color: Color(0xFF6750A4),
                ),
                const SizedBox(height: 12),
                const Text('Your Budget'),
                Text(
                  '₹${provider.budget.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 27,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 24),
                LinearProgressIndicator(
                  value: progress,
                  minHeight: 12,
                  borderRadius: BorderRadius.circular(10),
                  color: exceeded ? Colors.red : Colors.green,
                ),
                const SizedBox(height: 12),
                Text(
                  '${(progress * 100).toStringAsFixed(1)}% of budget used',
                ),
                const SizedBox(height: 20),
                Text(
                  exceeded
                      ? 'You have exceeded your budget!'
                      : 'Remaining: ₹${provider.remainingBudget.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: exceeded ? Colors.red : Colors.green,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),
        TextField(
          controller: budgetController,
          keyboardType:
              const TextInputType.numberWithOptions(decimal: true),
          decoration: const InputDecoration(
            labelText: 'New Budget Amount',
            prefixIcon: Icon(Icons.currency_rupee),
          ),
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: saving ? null : saveBudget,
          child: Text(saving ? 'Saving...' : 'Update Budget'),
        ),
      ],
    );
  }
}