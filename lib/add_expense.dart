import 'package:expense_tracker/model/expense.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AddExpense extends StatefulWidget {
  final void Function(Expense expense) onAddExpense;

  const AddExpense({super.key, required this.onAddExpense});

  @override
  State<StatefulWidget> createState() {
    return _AddExpenseState();
  }
}

class _AddExpenseState extends State<AddExpense> {
  final _titleController = TextEditingController();
  final _costController = TextEditingController();
  DateTime? selectedDate;
  Category _selectedCategory = Category.food; // default category

  @override
  void dispose() {
    _titleController.dispose();
    _costController.dispose();
    super.dispose();
  }

  void _showDatePickerMondal() async {
    final lastDate = DateTime.now();
    final firstDate = DateTime(lastDate.year - 1, lastDate.month, lastDate.day);
    var userSelectedDate = await showDatePicker(
      context: context,
      firstDate: firstDate,
      lastDate: lastDate,
    );
    setState(() {
      selectedDate = userSelectedDate;
    });
  }

  final formatter = DateFormat.yMd();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Title Input
          TextField(
            controller: _titleController,
            maxLength: 50,
            decoration: const InputDecoration(label: Text("Title")),
          ),

          // Amount + Date Row
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _costController,
                  keyboardType: TextInputType.number,
                  maxLength: 6,
                  decoration: const InputDecoration(label: Text("Cost")),
                ),
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      selectedDate == null
                          ? "Select Date"
                          : formatter.format(selectedDate!),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      onPressed: _showDatePickerMondal,
                      icon: const Icon(Icons.calendar_month),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Category Dropdown
          Row(
            children: [
              const Text("Category: "),
              const SizedBox(width: 12),
              DropdownButton<Category>(
                value: _selectedCategory,
                items: Category.values.map((cat) {
                  return DropdownMenuItem(
                    value: cat,
                    child: Text(cat.name.toLowerCase()),
                  );
                }).toList(),
                onChanged: (newCat) {
                  if (newCat == null) return;
                  setState(() {
                    _selectedCategory = newCat;
                  });
                },
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Buttons Row
          Row(
            children: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("Clear"),
              ),
              const Spacer(),
              OutlinedButton(
                onPressed: () {
                  final enteredTitle = _titleController.text.trim();
                  final enteredCost = double.tryParse(_costController.text);
                  if (enteredTitle.isEmpty ||
                      enteredCost == null ||
                      selectedDate == null) {
                    // show error message if invalid
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Please fill all fields correctly!"),
                      ),
                    );
                    return;
                  }

                  final newExpense = Expense(
                    title: enteredTitle,
                    amount: enteredCost,
                    category: _selectedCategory,
                    dateTime: selectedDate!,
                  );

                  widget.onAddExpense(newExpense); // ✅ send back to parent
                  Navigator.pop(context); // close modal
                },
                child: const Text("Save Expense"),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
