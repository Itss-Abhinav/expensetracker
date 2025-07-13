class Participant {
  final String id;
  final String name;
  double balance;

  Participant({
    required this.name,
    String? id,
    this.balance = 0.0,
  }) : id = id ?? DateTime.now().millisecondsSinceEpoch.toString();

  Participant copyWith({
    String? name,
    double? balance,
  }) {
    return Participant(
      id: id,
      name: name ?? this.name,
      balance: balance ?? this.balance,
    );
  }

  @override
  String toString() {
    return 'Participant(id: $id, name: $name, balance: $balance)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Participant && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
