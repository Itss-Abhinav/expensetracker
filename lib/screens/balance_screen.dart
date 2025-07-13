import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:expense_splitter/models/participant.dart';
import 'package:expense_splitter/services/database_service.dart';

class BalanceScreen extends StatelessWidget {
  const BalanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final db = Provider.of<DatabaseService>(context);
    final balances = db.balancesForSettlement;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settle Up'),
      ),
      body: Column(
        children: [
          // Summary Card
          Card(
            margin: const EdgeInsets.all(16),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  const Text(
                    'Total Balances',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Total to settle: ₹${_getTotalToSettle(balances.values)}',
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
          ),

          // Balances List
          Expanded(
            child: ListView.builder(
              itemCount: balances.length,
              itemBuilder: (context, index) {
                final participant = balances.keys.elementAt(index);
                final amount = balances.values.elementAt(index);
                return _buildBalanceTile(participant, amount);
              },
            ),
          ),

          // Settlement Button
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton.icon(
              icon: const Icon(Icons.check_circle),
              label: const Text('Mark as Settled'),
              onPressed: () => _showSettlementDialog(context, balances),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBalanceTile(Participant participant, double amount) {
    final isOwed = amount < 0;
    final color = isOwed ? Colors.green : Colors.red;

    return ListTile(
      leading: CircleAvatar(
        child: Text(participant.name[0]),
      ),
      title: Text(participant.name),
      subtitle: Text(
        isOwed ? 'Gets back' : 'Owes',
        style: TextStyle(color: color),
      ),
      trailing: Text(
        '₹${amount.abs().toStringAsFixed(2)}',
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  void _showSettlementDialog(
    BuildContext context,
    Map<Participant, double> balances,
  ) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Confirm Settlement'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('This will reset all balances to zero.'),
              const SizedBox(height: 16),
              ...balances.entries.map((entry) {
                final participant = entry.key;
                final amount = entry.value;
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: Text(
                    '${participant.name}: ${amount > 0 ? 'Pays' : 'Receives'} ₹${amount.abs().toStringAsFixed(2)}',
                  ),
                );
              }),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                _settleBalances(context);
                Navigator.pop(context);
              },
              child: const Text('Confirm'),
            ),
          ],
        );
      },
    );
  }

  void _settleBalances(BuildContext context) {
    final db = Provider.of<DatabaseService>(context, listen: false);

    // Create settlement transactions
    final balances = db.balancesForSettlement;
    final payers = balances.entries.where((e) => e.value > 0);
    final receivers = balances.entries.where((e) => e.value < 0);

    // In real app, you might want to save these transactions
    for (final payer in payers) {
      for (final receiver in receivers) {
        if (payer.value > 0 && receiver.value < 0) {
          // Save transaction here if needed
        }
      }
    }

    // Reset all balances
    for (final participant in db.participants) {
      participant.balance = 0;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Balances settled successfully!')),
    );
    Navigator.pop(context);
  }

  _getTotalToSettle(Iterable<double> values) {}
}
