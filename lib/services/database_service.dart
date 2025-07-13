import 'package:flutter/foundation.dart';
import 'package:expense_splitter/models/expense.dart';
import 'package:expense_splitter/models/participant.dart';

class DatabaseService with ChangeNotifier {
  final List<Participant> _participants = [];
  final List<Expense> _expenses = [];

  // Get all participants
  List<Participant> get participants => List.unmodifiable(_participants);

  // Get all expenses
  List<Expense> get expenses => List.unmodifiable(_expenses);

  // Add a new participant
  void addParticipant(String name) {
    _participants.add(Participant(name: name));
    notifyListeners();
  }

  // Remove a participant
  void removeParticipant(Participant participant) {
    // First remove any expenses associated with this participant
    _expenses.removeWhere((expense) =>
        expense.paidBy == participant ||
        expense.participants.contains(participant));

    _participants.remove(participant);
    _recalculateBalances();
    notifyListeners();
  }

  // Add a new expense
  void addExpense({
    required String title,
    required double amount,
    required Participant paidBy,
    required List<Participant> participants,
    String? description,
    required DateTime date,
  }) {
    if (participants.isEmpty) return;

    _expenses.add(Expense(
      title: title,
      amount: amount,
      paidBy: paidBy,
      participants: participants,
      description: description,
    ));

    _recalculateBalances();
    notifyListeners();
  }

  // Remove an expense
  void removeExpense(Expense expense) {
    _expenses.remove(expense);
    _recalculateBalances();
    notifyListeners();
  }

  // Recalculate all participant balances
  void _recalculateBalances() {
    // Reset all balances to zero
    for (var participant in _participants) {
      participant.balance = 0;
    }

    // Calculate new balances based on expenses
    for (var expense in _expenses) {
      final amountPerPerson = expense.amount / expense.participants.length;

      // The payer gets credited (balance decreases)
      expense.paidBy.balance -= expense.amount;

      // Each participant owes their share (balance increases)
      for (var participant in expense.participants) {
        participant.balance += amountPerPerson;
      }
    }
  }

  // Get total amount spent in the group
  double get totalSpent {
    return _expenses.fold(0, (sum, expense) => sum + expense.amount);
  }

  // Get balances for settlement
  Map<Participant, double> get balancesForSettlement {
    final Map<Participant, double> balances = {};

    for (var participant in _participants) {
      if (participant.balance != 0) {
        balances[participant] = participant.balance;
      }
    }

    return balances;
  }
}
