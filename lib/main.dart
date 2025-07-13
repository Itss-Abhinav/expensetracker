import 'package:flutter/material.dart';
import 'package:expense_splitter/screens/dashboard_screen.dart';
import 'package:provider/provider.dart';
import 'package:expense_splitter/services/database_service.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => DatabaseService(),
      child: const ExpenseSplitterApp(),
    ),
  );
}

class ExpenseSplitterApp extends StatelessWidget {
  const ExpenseSplitterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Expense Splitter',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.red[900]!),
        useMaterial3: true,
      ),
      home: const DashboardScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
