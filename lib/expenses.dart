import 'package:expense_tracker/add_expense.dart';
import 'package:expense_tracker/model/expense.dart';
import 'package:expense_tracker/widgets/expense_list/expense_list.dart';
import 'package:flutter/material.dart';

class Expenses extends StatefulWidget {
  const Expenses({super.key});

  @override
  State<StatefulWidget> createState() {
    return _ExpensesState();
  }
}

class _ExpensesState extends State<Expenses> {
  final List<Expense> expenses = [
    Expense(
      title: "Flutter Course",
      amount: 9.99,
      category: Category.work,
      dateTime: DateTime.now(),
    ),
    Expense(
      title: "Food",
      amount: 19.99,
      category: Category.food,
      dateTime: DateTime.now(),
    ),
    Expense(
      title: "Movie",
      amount: 9.99,
      category: Category.leisure,
      dateTime: DateTime.now(),
    ),
    Expense(
      title: "Traveling",
      amount: 99.99,
      category: Category.travel,
      dateTime: DateTime.now(),
    ),
  ];

  _showAddExpenseMondal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => AddExpense(
        onAddExpense: _addExpense, // ✅ pass function
      ),
    );
  }

  void _addExpense(Expense expense) {
    setState(() {
      expenses.add(expense);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Expense tracker App"),
        actions: [
          IconButton(onPressed: _showAddExpenseMondal, icon: Icon(Icons.add)),
        ],
      ),
      body: Column(
        children: [
          Text("data"),
          Expanded(child: ExpensesList(expenses)),
        ],
      ),
    );
  }
}
