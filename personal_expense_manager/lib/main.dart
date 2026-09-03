import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const ExpenseManagerApp());
}
// EXPENSE MODEL
class Expense {
  String id;
  double amount;
  String category;
  String description;
  String date;

  Expense({
    required this.id,
    required this.amount,
    required this.category,
    required this.description,
    required this.date,
  });

  // Convert Expense object to Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'amount': amount,
      'category': category,
      'description': description,
      'date': date,
    };
  }

  // Create Expense object from Map
  factory Expense.fromMap(Map<String, dynamic> map) {
    return Expense(
      id: map['id'],
      amount: (map['amount'] as num).toDouble(),
      category: map['category'],
      description: map['description'],
      date: map['date'],
    );
  }
}
// MAIN APPLICATION
class ExpenseManagerApp extends StatelessWidget {
  const ExpenseManagerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      title: 'Personal Expense Manager',

      theme: ThemeData(
        useMaterial3: true,

        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
        ),

        scaffoldBackgroundColor:
            Colors.grey.shade100,

        inputDecorationTheme:
            const InputDecorationTheme(
          border: OutlineInputBorder(),
        ),
      ),

      home: const ExpenseHomePage(),
    );
  }
}
// HOME PAGE
class ExpenseHomePage extends StatefulWidget {
  const ExpenseHomePage({super.key});

  @override
  State<ExpenseHomePage> createState() =>
      _ExpenseHomePageState();
}

class _ExpenseHomePageState
    extends State<ExpenseHomePage> {

  // EXPENSE LIST

  List<Expense> expenses = [];

  // CONTROLLERS

  final TextEditingController amountController =
      TextEditingController();

  final TextEditingController descriptionController =
      TextEditingController();

  // FORM KEY

  final GlobalKey<FormState> formKey =
      GlobalKey<FormState>();

  // CATEGORY

  String selectedCategory = 'Food';

  final List<String> categories = [
    'Food',
    'Travel',
    'Shopping',
    'Bills',
    'Education',
    'Entertainment',
    'Health',
    'Other',
  ];

  // DATE

  DateTime selectedDate = DateTime.now();

  // LOADING STATE

  bool isLoading = true;

  // EDITING STATE

  Expense? editingExpense;

  // INITIALIZATION

  @override
  void initState() {
    super.initState();

    loadExpenses();
  }

  // LOAD EXPENSES FROM LOCAL STORAGE

  Future<void> loadExpenses() async {

    final SharedPreferences prefs =
        await SharedPreferences.getInstance();

    final String? savedData =
        prefs.getString('expenses');

    if (savedData != null) {

      final List<dynamic> decodedData =
          jsonDecode(savedData);

      setState(() {

        expenses = decodedData
            .map(
              (item) => Expense.fromMap(
                Map<String, dynamic>.from(item),
              ),
            )
            .toList();

        isLoading = false;
      });

    } else {

      setState(() {
        isLoading = false;
      });
    }
  }

  // SAVE EXPENSES TO LOCAL STORAGE

  Future<void> saveExpenses() async {

    final SharedPreferences prefs =
        await SharedPreferences.getInstance();

    final List<Map<String, dynamic>> data =
        expenses.map(
          (expense) => expense.toMap(),
        ).toList();

    await prefs.setString(
      'expenses',
      jsonEncode(data),
    );
  }

  // ADD EXPENSE

  Future<void> addExpense() async {

    if (!formKey.currentState!.validate()) {
      return;
    }

    final double? amount =
        double.tryParse(
      amountController.text.trim(),
    );

    if (amount == null || amount <= 0) {
      showMessage(
        'Please enter a valid amount.',
      );
      return;
    }

    final Expense newExpense = Expense(
      id: DateTime.now()
          .millisecondsSinceEpoch
          .toString(),

      amount: amount,

      category: selectedCategory,

      description:
          descriptionController.text.trim(),

      date: formatDate(selectedDate),
    );

    setState(() {
      expenses.add(newExpense);
    });

    await saveExpenses();

    clearForm();

    showMessage(
      'Expense added successfully.',
    );
  }

  // UPDATE EXPENSE

  Future<void> updateExpense() async {

    if (editingExpense == null) {
      return;
    }

    if (!formKey.currentState!.validate()) {
      return;
    }

    final double? amount =
        double.tryParse(
      amountController.text.trim(),
    );

    if (amount == null || amount <= 0) {
      showMessage(
        'Please enter a valid amount.',
      );
      return;
    }

    final int index = expenses.indexWhere(
      (expense) =>
          expense.id == editingExpense!.id,
    );

    if (index == -1) {
      return;
    }

    setState(() {

      expenses[index] = Expense(
        id: editingExpense!.id,

        amount: amount,

        category: selectedCategory,

        description:
            descriptionController.text.trim(),

        date: formatDate(selectedDate),
      );
    });

    await saveExpenses();

    clearForm();

    showMessage(
      'Expense updated successfully.',
    );
  }

  // DELETE EXPENSE

  Future<void> deleteExpense(
    String id,
  ) async {

    setState(() {

      expenses.removeWhere(
        (expense) => expense.id == id,
      );
    });

    await saveExpenses();

    showMessage(
      'Expense deleted successfully.',
    );
  }

  // EDIT EXPENSE

  void startEditing(Expense expense) {

    setState(() {

      editingExpense = expense;

      amountController.text =
          expense.amount.toString();

      descriptionController.text =
          expense.description;

      selectedCategory =
          expense.category;

      selectedDate =
          parseDate(expense.date);
    });

    showExpenseForm();
  }

  // DATE PICKER
  Future<void> selectDate() async {

    final DateTime? picked =
        await showDatePicker(

      context: context,

      initialDate: selectedDate,

      firstDate: DateTime(2020),

      lastDate: DateTime(2100),
    );

    if (picked != null) {

      setState(() {
        selectedDate = picked;
      });
    }
  }

  // FORMAT DATE
  String formatDate(DateTime date) {

    return '${date.day.toString().padLeft(2, '0')}/'
        '${date.month.toString().padLeft(2, '0')}/'
        '${date.year}';
  }

  // PARSE DATE
  DateTime parseDate(String date) {

    final List<String> parts =
        date.split('/');

    return DateTime(
      int.parse(parts[2]),
      int.parse(parts[1]),
      int.parse(parts[0]),
    );
  }

  // CLEAR FORM
  void clearForm() {
    amountController.clear();
    descriptionController.clear();
    setState(() {
      selectedCategory = 'Food';
      selectedDate = DateTime.now();
      editingExpense = null;
    });
  }

  // TOTAL EXPENDITURE
  double calculateTotal() {
    double total = 0;
    for (Expense expense in expenses) {
      total += expense.amount;
    }
    return total;
  }

  // SHOW MESSAGE
  void showMessage(String message) {

    ScaffoldMessenger.of(context)
        .showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  // SHOW ADD/EDIT FORM
  void showExpenseForm() {
    showModalBottomSheet(
      context: context,

      isScrollControlled: true,

      builder: (context) {

        return Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: 20,
            bottom:
                MediaQuery.of(context)
                        .viewInsets
                        .bottom +
                    20,
          ),

          child: Form(
            key: formKey,

            child: SingleChildScrollView(

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // TITLE
                  Text(
                    editingExpense == null
                        ? 'Add Expense'
                        : 'Edit Expense',

                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 20),

                  // AMOUNT

                  TextFormField(
                    controller: amountController,

                    keyboardType:
                        const TextInputType
                            .numberWithOptions(
                      decimal: true,
                    ),

                    decoration:
                        const InputDecoration(
                      labelText: 'Amount',
                      prefixIcon:
                          Icon(Icons.currency_rupee),
                    ),

                    validator: (value) {

                      if (value == null ||
                          value.trim().isEmpty) {

                        return 'Please enter amount.';
                      }

                      final double? amount =
                          double.tryParse(
                        value.trim(),
                      );

                      if (amount == null ||
                          amount <= 0) {

                        return 'Enter a valid amount.';
                      }

                      return null;
                    },
                  ),

                  const SizedBox(height: 15),
                  // CATEGORY
                  DropdownButtonFormField<String>(

                    value: selectedCategory,

                    decoration:
                        const InputDecoration(
                      labelText: 'Category',
                      prefixIcon:
                          Icon(Icons.category),
                    ),

                    items: categories.map(
                      (category) {

                        return DropdownMenuItem(
                          value: category,
                          child: Text(category),
                        );
                      },
                    ).toList(),

                    onChanged: (value) {

                      if (value != null) {

                        setState(() {
                          selectedCategory = value;
                        });
                      }
                    },
                  ),

                  const SizedBox(height: 15),

                  // DESCRIPTION

                  TextFormField(
                    controller:
                        descriptionController,

                    maxLines: 2,

                    decoration:
                        const InputDecoration(
                      labelText: 'Description',
                      hintText:
                          'Enter expense description',
                      prefixIcon:
                          Icon(Icons.description),
                    ),

                    validator: (value) {

                      if (value == null ||
                          value.trim().isEmpty) {

                        return 'Please enter description.';
                      }

                      return null;
                    },
                  ),

                  const SizedBox(height: 15),

                  // DATE

                  InkWell(
                    onTap: selectDate,

                    child: InputDecorator(
                      decoration:
                          const InputDecoration(
                        labelText: 'Date',
                        prefixIcon:
                            Icon(Icons.calendar_month),
                      ),

                      child: Text(
                        formatDate(selectedDate),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // SAVE BUTTON

                  SizedBox(
                    width: double.infinity,

                    height: 50,

                    child: ElevatedButton.icon(

                      onPressed: () async {

                        if (editingExpense == null) {

                          await addExpense();

                        } else {

                          await updateExpense();
                        }

                        if (context.mounted) {
                          Navigator.pop(context);
                        }
                      },

                      icon: Icon(
                        editingExpense == null
                            ? Icons.add
                            : Icons.save,
                      ),

                      label: Text(
                        editingExpense == null
                            ? 'Add Expense'
                            : 'Update Expense',
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // EXPENSE CARD

  Widget buildExpenseCard(
    Expense expense,
  ) {

    return Card(

      margin: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 6,
      ),

      child: Padding(
        padding: const EdgeInsets.all(12),

        child: Row(
          children: [
            // CATEGORY ICON
            CircleAvatar(

              radius: 25,

              child: Icon(
                getCategoryIcon(
                  expense.category,
                ),
              ),
            ),

            const SizedBox(width: 12),
            // EXPENSE DETAILS
            Expanded(

              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,

                children: [

                  Text(
                    expense.description,

                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 4),

                  Text(
                    expense.category,
                    style: TextStyle(
                      color: Colors.grey.shade600,
                    ),
                  ),

                  Text(
                    expense.date,
                    style: TextStyle(
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
            // AMOUNT + ACTIONS
            Column(
              crossAxisAlignment:
                  CrossAxisAlignment.end,

              children: [

                Text(
                  '₹${expense.amount.toStringAsFixed(2)}',

                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                Row(
                  children: [

                    IconButton(
                      tooltip: 'Edit',

                      onPressed: () {
                        startEditing(expense);
                      },

                      icon: const Icon(
                        Icons.edit,
                        size: 20,
                      ),
                    ),

                    IconButton(
                      tooltip: 'Delete',

                      onPressed: () {
                        confirmDelete(expense);
                      },

                      icon: const Icon(
                        Icons.delete,
                        size: 20,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // CONFIRM DELETE

  void confirmDelete(Expense expense) {

    showDialog(
      context: context,

      builder: (context) {

        return AlertDialog(

          title: const Text(
            'Delete Expense',
          ),

          content: const Text(
            'Are you sure you want to delete this expense?',
          ),

          actions: [

            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },

              child: const Text(
                'Cancel',
              ),
            ),

            ElevatedButton(
              onPressed: () async {

                Navigator.pop(context);

                await deleteExpense(
                  expense.id,
                );
              },

              child: const Text(
                'Delete',
              ),
            ),
          ],
        );
      },
    );
  }

  // CATEGORY ICON

  IconData getCategoryIcon(
    String category,
  ) {

    switch (category) {

      case 'Food':
        return Icons.restaurant;

      case 'Travel':
        return Icons.directions_car;

      case 'Shopping':
        return Icons.shopping_bag;

      case 'Bills':
        return Icons.receipt_long;

      case 'Education':
        return Icons.school;

      case 'Entertainment':
        return Icons.movie;

      case 'Health':
        return Icons.health_and_safety;

      default:
        return Icons.money;
    }
  }

  // BUILD UI
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // APP BAR
      appBar: AppBar(

        title: const Text(
          'Personal Expense Manager',
        ),

        centerTitle: true,
      ),
      // BODY
      body: isLoading

          ? const Center(
              child: CircularProgressIndicator(),
            )

          : Column(
              children: [
                // TOTAL EXPENSE CARD
                Card(
                  margin: const EdgeInsets.all(16),

                  child: Padding(
                    padding: const EdgeInsets.all(20),

                    child: Row(
                      children: [

                        CircleAvatar(
                          radius: 30,

                          child: const Icon(
                            Icons.account_balance_wallet,
                            size: 30,
                          ),
                        ),

                        const SizedBox(width: 15),

                        Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,

                          children: [

                            const Text(
                              'Total Expenditure',

                              style: TextStyle(
                                fontSize: 16,
                              ),
                            ),

                            const SizedBox(height: 5),

                            Text(
                              '₹${calculateTotal().toStringAsFixed(2)}',

                              style: const TextStyle(
                                fontSize: 26,
                                fontWeight:
                                    FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                // EXPENSE LIST

                Expanded(

                  child: expenses.isEmpty

                      ? const Center(
                          child: Column(
                            mainAxisAlignment:
                                MainAxisAlignment.center,

                            children: [

                              Icon(
                                Icons.receipt_long,
                                size: 70,
                                color: Colors.grey,
                              ),

                              SizedBox(height: 10),

                              Text(
                                'No expenses found.',

                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.grey,
                                ),
                              ),

                              SizedBox(height: 5),

                              Text(
                                'Tap + to add your first expense.',
                              ),
                            ],
                          ),
                        )
                        : ListView.builder(
                          itemCount:expenses.length,
                          itemBuilder:(context, index) {
                            return buildExpenseCard(expenses[index],
                            );
                          },
                        ),
                ),
              ],
            ),

      // ADD BUTTON
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          clearForm();
          showExpenseForm();
        },

        icon: const Icon(
          Icons.add,
        ),

        label: const Text(
          'Add Expense',
        ),
      ),
    );
  }

  // DISPOSE
  @override
  void dispose() {
    amountController.dispose();
    descriptionController.dispose();
    super.dispose();
  }
}