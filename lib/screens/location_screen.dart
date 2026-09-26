import 'package:bank_and_more/app.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/location_record.dart';

class LocationScreen extends StatefulWidget {
  const LocationScreen({super.key});

  @override
  State<LocationScreen> createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _captainController = TextEditingController();
  final _accountController = TextEditingController();
  final _customerController = TextEditingController();
  final _locationController = TextEditingController();
  final _amountController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  List<LocationRecord> _records = [];
  String _searchQuery = '';
  String? _editingId;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final records = LocalStorage.loadLocationRecords();
    setState(() => _records = records);
  }

  List<LocationRecord> get filteredRecords {
    final query = _searchQuery.trim().toLowerCase();
    if (query.isEmpty) return _records;

    return _records.where((record) {
      final haystack = [
        record.captainName,
        record.account,
        record.customerName,
        record.location,
        record.formattedDate,
      ].join(' ').toLowerCase();
      return haystack.contains(query);
    }).toList();
  }

  double get totalAmount => _records.fold(0.0, (sum, item) => sum + item.amount);

  void _resetForm() {
    _editingId = null;
    _selectedDate = DateTime.now();
    _captainController.clear();
    _accountController.clear();
    _customerController.clear();
    _locationController.clear();
    _amountController.clear();
  }

  Future<void> _saveRecord() async {
    if (!_formKey.currentState!.validate()) return;

    final record = LocationRecord(
      id: _editingId ?? DateTime.now().millisecondsSinceEpoch.toString(),
      date: _selectedDate,
      captainName: _captainController.text.trim(),
      account: _accountController.text.trim(),
      customerName: _customerController.text.trim(),
      location: _locationController.text.trim(),
      amount: double.tryParse(_amountController.text.trim()) ?? 0,
      createdAt: DateTime.now(),
    );

    final list = List<LocationRecord>.from(_records);
    if (_editingId != null) {
      final index = list.indexWhere((item) => item.id == _editingId);
      if (index >= 0) {
        list[index] = record;
      }
    } else {
      list.add(record);
    }

    await LocalStorage.saveLocationRecords(list);
    setState(() {
      _records = list;
      _resetForm();
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(_editingId == null
            ? 'تم حفظ بيانات Location بنجاح'
            : 'تم تحديث بيانات Location بنجاح'),
      ),
    );
  }

  void _editRecord(LocationRecord record) {
    setState(() {
      _editingId = record.id;
      _selectedDate = record.date;
      _captainController.text = record.captainName;
      _accountController.text = record.account;
      _customerController.text = record.customerName;
      _locationController.text = record.location;
      _amountController.text = record.amount.toString();
    });
  }

  Future<void> _deleteRecord(String id) async {
    final updated = _records.where((item) => item.id != id).toList();
    await LocalStorage.saveLocationRecords(updated);
    setState(() {
      _records = updated;
      if (_editingId == id) _resetForm();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Location'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: _DateField(
                            label: 'Date',
                            selectedDate: _selectedDate,
                            onChanged: (date) => setState(() => _selectedDate = date),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextFormField(
                            controller: _captainController,
                            decoration: const InputDecoration(labelText: 'Captain Name'),
                            validator: (value) => value == null || value.trim().isEmpty ? 'مطلوب' : null,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _accountController,
                            decoration: const InputDecoration(labelText: 'Account'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextFormField(
                            controller: _customerController,
                            decoration: const InputDecoration(labelText: 'Customer Name'),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _locationController,
                            decoration: const InputDecoration(labelText: 'Location'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextFormField(
                            controller: _amountController,
                            keyboardType: const TextInputType.numberWithOptions(decimal: true),
                            decoration: const InputDecoration(labelText: 'Amount'),
                            validator: (value) => value == null || value.trim().isEmpty ? 'مطلوب' : null,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),
                    Row(
                      children: [
                        Expanded(
                          child: FilledButton.icon(
                            onPressed: _saveRecord,
                            icon: Icon(_editingId == null ? Icons.save_alt : Icons.edit),
                            label: Text(_editingId == null ? 'حفظ' : 'تحديث'),
                          ),
                        ),
                        if (_editingId != null) ...[
                          const SizedBox(width: 12),
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: _resetForm,
                              icon: const Icon(Icons.close),
                              label: const Text('إلغاء'),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Card(
            child: ListTile(
              title: const Text('مجموع Amount'),
              trailing: Text(
                NumberFormat.currency(symbol: 'SAR ', decimalDigits: 2).format(totalAmount),
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            decoration: const InputDecoration(
              labelText: 'بحث',
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(),
            ),
            onChanged: (value) => setState(() => _searchQuery = value),
          ),
          const SizedBox(height: 12),
          ...filteredRecords.map((record) => Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  title: Text(record.customerName),
                  subtitle: Text(
                    '${record.formattedDate} • ${record.captainName} • ${record.location}',
                  ),
                  trailing: SizedBox(
                    width: 120,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(NumberFormat.currency(symbol: 'SAR ', decimalDigits: 2).format(record.amount)),
                        IconButton(
                          icon: const Icon(Icons.edit_outlined, color: Colors.blue),
                          onPressed: () => _editRecord(record),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete_outline, color: Colors.red),
                          onPressed: () => _deleteRecord(record.id),
                        ),
                      ],
                    ),
                  ),
                ),
              )),
        ],
      ),
    );
  }
}

class _DateField extends StatelessWidget {
  const _DateField({
    required this.label,
    required this.selectedDate,
    required this.onChanged,
  });

  final String label;
  final DateTime selectedDate;
  final ValueChanged<DateTime> onChanged;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        final date = await showDatePicker(
          context: context,
          initialDate: selectedDate,
          firstDate: DateTime(2020),
          lastDate: DateTime(2100),
        );
        if (date != null) onChanged(date);
      },
      child: InputDecorator(
        decoration: InputDecoration(labelText: label),
        child: Text(DateFormat('yyyy-MM-dd').format(selectedDate)),
      ),
    );
  }
}
