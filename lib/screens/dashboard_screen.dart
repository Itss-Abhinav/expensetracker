import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:expense_splitter/services/database_service.dart';
import 'package:expense_splitter/widgets/expense_card.dart';
import 'package:expense_splitter/screens/add_expense_screen.dart';
import 'package:expense_splitter/screens/balance_screen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final db = Provider.of<DatabaseService>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Expense Splitter'),
        actions: [
          IconButton(
            icon: const Icon(Icons.balance),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const BalanceScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Summary Cards
          _buildSummarySection(context, db),

          // Recent Expenses Header
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Recent Expenses',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(
                  'Total: ₹${db.totalSpent.toStringAsFixed(2)}',
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),

          // Expenses List
          _buildExpensesList(db),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const AddExpenseScreen(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildSummarySection(BuildContext context, DatabaseService db) {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Total Participants
            ListTile(
              leading: const Icon(Icons.people),
              title: const Text('Total Participants'),
              trailing: Text(db.participants.length.toString()),
            ),

            // Total Expenses
            ListTile(
              leading: const Icon(Icons.receipt),
              title: const Text('Total Expenses'),
              trailing: Text(db.expenses.length.toString()),
            ),

            // Quick Actions
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  icon: const Icon(Icons.person_add),
                  label: const Text('Add Person'),
                  onPressed: () => _showAddParticipantDialog(context, db),
                ),
                ElevatedButton.icon(
                  icon: const Icon(Icons.currency_rupee),
                  label: const Text('Settle Up'),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const BalanceScreen(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExpensesList(DatabaseService db) {
    if (db.expenses.isEmpty) {
      return const Expanded(
        child: Center(
          child: Text('No expenses yet. Add your first expense!'),
        ),
      );
    }

    return Expanded(
      child: ListView.builder(
        itemCount: db.expenses.length,
        itemBuilder: (context, index) {
          final expense = db.expenses.reversed.toList()[index];
          return ExpenseCard(expense: expense);
        },
      ),
    );
  }

  void _showAddParticipantDialog(BuildContext context, DatabaseService db) {
    final nameController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add New Participant'),
          content: TextField(
            controller: nameController,
            decoration: const InputDecoration(
              labelText: 'Name',
              hintText: 'Enter participant name',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (nameController.text.trim().isNotEmpty) {
                  db.addParticipant(nameController.text.trim());
                  Navigator.pop(context);
                }
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }
}
