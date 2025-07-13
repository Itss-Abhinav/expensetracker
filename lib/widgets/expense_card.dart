import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:expense_splitter/models/expense.dart';

class ExpenseCard extends StatelessWidget {
  final Expense expense;
  final VoidCallback? onDelete;

  const ExpenseCard({
    super.key,
    required this.expense,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('MMM dd, yyyy');

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Expense Title and Amount
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  expense.title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '₹${expense.amount.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 8),

            // Paid by and Date
            Row(
              children: [
                const Icon(Icons.person, size: 16),
                const SizedBox(width: 4),
                Text(
                  'Paid by ${expense.paidBy.name}',
                  style: TextStyle(
                    color: Colors.grey[700],
                  ),
                ),
                const Spacer(),
                const Icon(Icons.calendar_today, size: 16),
                const SizedBox(width: 4),
                Text(
                  dateFormat.format(expense.date),
                  style: TextStyle(
                    color: Colors.grey[700],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 8),

            // Shared by participants
            Wrap(
              spacing: 4,
              children: [
                const Icon(Icons.people, size: 16),
                const SizedBox(width: 4),
                Text(
                  'Shared by: ${_getParticipantsText(expense)}',
                  style: TextStyle(
                    color: Colors.grey[700],
                  ),
                ),
              ],
            ),

            if (expense.description?.isNotEmpty ?? false) ...[
              const SizedBox(height: 8),
              Text(
                'Note: ${expense.description!}',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],

            const SizedBox(height: 8),

            // Per person amount and delete button
            Row(
              children: [
                Chip(
                  label: Text(
                    '₹${expense.amountPerPerson.toStringAsFixed(2)} per person',
                  ),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: onDelete,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _getParticipantsText(Expense expense) {
    if (expense.participants.length <= 2) {
      return expense.participants.map((p) => p.name).join(' & ');
    }
    return '${expense.participants.take(2).map((p) => p.name).join(', ')} +${expense.participants.length - 2} more';
  }
}
