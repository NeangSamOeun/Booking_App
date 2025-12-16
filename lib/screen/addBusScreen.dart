import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddBusScreen extends StatefulWidget {
  const AddBusScreen({super.key});

  @override
  State<AddBusScreen> createState() => _AddBusScreenState();
}

class _AddBusScreenState extends State<AddBusScreen> {
  final _formKey = GlobalKey<FormState>();
  final _operatorCtl = TextEditingController();
  final _busTypeCtl = TextEditingController();
  final _fromCtl = TextEditingController();
  final _toCtl = TextEditingController();
  final _durationCtl = TextEditingController();
  final _ratingCtl = TextEditingController();
  final _priceCtl = TextEditingController();
  DateTime? _startDate; // NEW

  final _db = FirebaseFirestore.instance;

  Future<void> _pickStartDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(), 
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null && mounted) {
      setState(() {
        _startDate = picked;
      });
    }
  }

  void _addBus() async {
    if (!_formKey.currentState!.validate() || _startDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields and pick a start date')),
      );
      return;
    }

    const flatSeatGrid = [
      0, 0, 1, 0,
      0, 0, 0, 0,
      1, 0, 0, 1,
      0, 0, 0, 0,
    ];

    final newBus = {
      'operator': _operatorCtl.text,
      'busType': _busTypeCtl.text,
      'from': _fromCtl.text,
      'to': _toCtl.text,
      'duration': _durationCtl.text,
      'rating': double.tryParse(_ratingCtl.text) ?? 0.0,
      'price': int.tryParse(_priceCtl.text) ?? 0,
      'seatGrid': flatSeatGrid,
      'rows': 4,
      'cols': 4,
      'startDate': Timestamp.fromDate(_startDate!), // NEW
    };

    await _db.collection('buses').add(newBus);

    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Bus added successfully!')));
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add New Bus'), backgroundColor: Colors.red),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _operatorCtl,
                decoration: const InputDecoration(labelText: 'Operator'),
                validator: (v) => v!.isEmpty ? 'Enter operator' : null,
              ),
              TextFormField(
                controller: _busTypeCtl,
                decoration: const InputDecoration(labelText: 'Bus Type'),
                validator: (v) => v!.isEmpty ? 'Enter bus type' : null,
              ),
              TextFormField(
                controller: _fromCtl,
                decoration: const InputDecoration(labelText: 'From (Departure City)'),
                validator: (v) => v!.isEmpty ? 'Enter departure city' : null,
              ),
              TextFormField(
                controller: _toCtl,
                decoration: const InputDecoration(labelText: 'To (Arrival City)'),
                validator: (v) => v!.isEmpty ? 'Enter arrival city' : null,
              ),
              TextFormField(
                controller: _durationCtl,
                decoration: const InputDecoration(labelText: 'Duration'),
                validator: (v) => v!.isEmpty ? 'Enter duration' : null,
              ),
              TextFormField(
                controller: _ratingCtl,
                decoration: const InputDecoration(labelText: 'Rating'),
                keyboardType: TextInputType.number,
                validator: (v) => v!.isEmpty ? 'Enter rating' : null,
              ),
              TextFormField(
                controller: _priceCtl,
                decoration: const InputDecoration(labelText: 'Price'),
                keyboardType: TextInputType.number,
                validator: (v) => v!.isEmpty ? 'Enter price' : null,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      _startDate == null
                          ? 'Pick Start Date'
                          : 'Start Date: ${_startDate!.toLocal().toString().split(' ')[0]}',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: _pickStartDate,
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                    child: const Text('Select Date'),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _addBus,
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                child: const Text('Add Bus'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
