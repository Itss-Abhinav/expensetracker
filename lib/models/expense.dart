import 'package:expense_splitter/models/participant.dart';

class Expense {
  final String id;
  final String title;
  final double amount;
  final DateTime date;
  final Participant paidBy;
  final List<Participant> participants;
  final String? description;

  Expense({
    required this.title,
    required this.amount,
    required this.paidBy,
    required this.participants,
    this.description,
    DateTime? date,
    String? id,
  })  : date = date ?? DateTime.now(),
        id = id ?? DateTime.now().millisecondsSinceEpoch.toString();

  double get amountPerPerson {
    if (participants.isEmpty) return 0;
    return amount / participants.length;
  }

  Expense copyWith({
    String? title,
    double? amount,
    Participant? paidBy,
    List<Participant>? participants,
    String? description,
    DateTime? date,
  }) {
    return Expense(
      id: id,
      title: title ?? this.title,
      amount: amount ?? this.amount,
      paidBy: paidBy ?? this.paidBy,
      participants: participants ?? this.participants,
      description: description ?? this.description,
      date: date ?? this.date,
    );
  }

  @override
  String toString() {
    return 'Expense(id: $id, title: $title, amount: $amount, date: $date, paidBy: $paidBy, participants: $participants, description: $description)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Expense && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
