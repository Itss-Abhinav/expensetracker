import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:expense_splitter/models/participant.dart';
import 'package:expense_splitter/services/database_service.dart';

class AddExpenseScreen extends StatefulWidget {
  const AddExpenseScreen({super.key});

  @override
  State<AddExpenseScreen> createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  final _descriptionController = TextEditingController();

  Participant? _selectedPayer;
  DateTime _selectedDate = DateTime.now();
  final List<Participant> _selectedParticipants = [];

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final db = Provider.of<DatabaseService>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Expense'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Title Field
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Title',
                  hintText: 'e.g. Dinner, Movie tickets',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 20),

              // Amount Field
              TextFormField(
                controller: _amountController,
                decoration: const InputDecoration(
                  labelText: 'Amount',
                  hintText: 'e.g. 1000',
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an amount';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 20),

              // Paid By Dropdown
              DropdownButtonFormField<Participant>(
                value: _selectedPayer,
                decoration: const InputDecoration(
                  labelText: 'Paid By',
                ),
                items: db.participants.map((participant) {
                  return DropdownMenuItem(
                    value: participant,
                    child: Text(participant.name),
                  );
                }).toList(),
                onChanged: (participant) {
                  setState(() {
                    _selectedPayer = participant;
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return 'Please select who paid';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 20),

              // Date Picker
              ListTile(
                leading: const Icon(Icons.calendar_today),
                title: const Text('Date'),
                subtitle: Text(
                  '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () async {
                    final pickedDate = await showDatePicker(
                      context: context,
                      initialDate: _selectedDate,
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                    );
                    if (pickedDate != null) {
                      setState(() {
                        _selectedDate = pickedDate;
                      });
                    }
                  },
                ),
              ),

              const SizedBox(height: 20),

              // Participants Selection
              const Text(
                'Shared With:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              ...db.participants.map((participant) {
                return CheckboxListTile(
                  title: Text(participant.name),
                  value: _selectedParticipants.contains(participant),
                  onChanged: (bool? value) {
                    setState(() {
                      if (value == true) {
                        _selectedParticipants.add(participant);
                      } else {
                        _selectedParticipants.remove(participant);
                      }
                    });
                  },
                );
              }).toList(),

              const SizedBox(height: 20),

              // Description Field
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description (Optional)',
                  hintText: 'Any additional notes',
                ),
                maxLines: 2,
              ),

              const SizedBox(height: 30),

              // Submit Button
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    if (_selectedParticipants.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content:
                              Text('Please select at least one participant'),
                        ),
                      );
                      return;
                    }

                    db.addExpense(
                      title: _titleController.text,
                      amount: double.parse(_amountController.text),
                      paidBy: _selectedPayer!,
                      participants: _selectedParticipants,
                      description: _descriptionController.text.isEmpty
                          ? null
                          : _descriptionController.text,
                      date: _selectedDate,
                    );

                    Navigator.pop(context);
                  }
                },
                child: const Text('Add Expense'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
