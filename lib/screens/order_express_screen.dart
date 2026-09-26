import 'package:bank_and_more/app.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/order_express_record.dart';

class OrderExpressScreen extends StatefulWidget {
  const OrderExpressScreen({super.key});

  @override
  State<OrderExpressScreen> createState() => _OrderExpressScreenState();
}

class _OrderExpressScreenState extends State<OrderExpressScreen> {
  final _formKey = GlobalKey<FormState>();
  final _companyController = TextEditingController();
  final _customerController = TextEditingController();
  final _driverController = TextEditingController();
  final _qtyController = TextEditingController(text: '1');
  final _orderValueController = TextEditingController();
  final _coController = TextEditingController();
  final _driverValueController = TextEditingController();
  final _locationController = TextEditingController();
  final _noteController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  List<OrderExpressRecord> _records = [];
  String _searchQuery = '';
  String? _editingId;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final records = LocalStorage.loadOrderRecords();
    setState(() => _records = records);
  }

  List<OrderExpressRecord> get filteredRecords {
    final query = _searchQuery.trim().toLowerCase();
    if (query.isEmpty) return _records;

    return _records.where((record) {
      final haystack = [
        record.company,
        record.customerName,
        record.driverName,
        record.location,
        record.note,
        record.formattedDate,
      ].join(' ').toLowerCase();
      return haystack.contains(query);
    }).toList();
  }

  double get totalAmount => _records.fold(0.0, (sum, item) => sum + item.total);

  void _resetForm() {
    _editingId = null;
    _selectedDate = DateTime.now();
    _companyController.clear();
    _customerController.clear();
    _driverController.clear();
    _qtyController.text = '1';
    _orderValueController.clear();
    _coController.clear();
    _driverValueController.clear();
    _locationController.clear();
    _noteController.clear();
  }

  Future<void> _saveRecord() async {
    if (!_formKey.currentState!.validate()) return;

    final qty = int.tryParse(_qtyController.text.trim()) ?? 1;
    final orderValue = double.tryParse(_orderValueController.text.trim()) ?? 0;
    final co = double.tryParse(_coController.text.trim()) ?? 0;
    final driverValue = double.tryParse(_driverValueController.text.trim()) ?? 0;
    final calculatedTotal = orderValue + co + driverValue;

    final record = OrderExpressRecord(
      id: _editingId ?? DateTime.now().millisecondsSinceEpoch.toString(),
      date: _selectedDate,
      company: _companyController.text.trim(),
      customerName: _customerController.text.trim(),
      driverName: _driverController.text.trim(),
      qty: qty,
      orderValue: orderValue,
      co: co,
      driverValue: driverValue,
      location: _locationController.text.trim(),
      note: _noteController.text.trim(),
      total: calculatedTotal,
      createdAt: DateTime.now(),
    );

    final list = List<OrderExpressRecord>.from(_records);
    if (_editingId != null) {
      final index = list.indexWhere((item) => item.id == _editingId);
      if (index >= 0) {
        list[index] = record;
      }
    } else {
      list.add(record);
    }

    await LocalStorage.saveOrderRecords(list);
    setState(() {
      _records = list;
      _resetForm();
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(_editingId == null
            ? 'تم حفظ Order Express بنجاح'
            : 'تم تحديث Order Express بنجاح'),
      ),
    );
  }

  void _editRecord(OrderExpressRecord record) {
    setState(() {
      _editingId = record.id;
      _selectedDate = record.date;
      _companyController.text = record.company;
      _customerController.text = record.customerName;
      _driverController.text = record.driverName;
      _qtyController.text = record.qty.toString();
      _orderValueController.text = record.orderValue.toString();
      _coController.text = record.co.toString();
      _driverValueController.text = record.driverValue.toString();
      _locationController.text = record.location;
      _noteController.text = record.note;
    });
  }

  Future<void> _deleteRecord(String id) async {
    final updated = _records.where((item) => item.id != id).toList();
    await LocalStorage.saveOrderRecords(updated);
    setState(() {
      _records = updated;
      if (_editingId == id) _resetForm();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Order Express'),
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
                            controller: _companyController,
                            decoration: const InputDecoration(labelText: 'Company'),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _customerController,
                            decoration: const InputDecoration(labelText: 'Customer Name'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextFormField(
                            controller: _driverController,
                            decoration: const InputDecoration(labelText: 'Driver Name'),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _qtyController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(labelText: 'Qty'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextFormField(
                            controller: _orderValueController,
                            keyboardType: const TextInputType.numberWithOptions(decimal: true),
                            decoration: const InputDecoration(labelText: 'Order Value'),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _coController,
                            keyboardType: const TextInputType.numberWithOptions(decimal: true),
                            decoration: const InputDecoration(labelText: 'C.O'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextFormField(
                            controller: _driverValueController,
                            keyboardType: const TextInputType.numberWithOptions(decimal: true),
                            decoration: const InputDecoration(labelText: 'Driver Value'),
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
                      ],
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _noteController,
                      maxLines: 3,
                      decoration: const InputDecoration(labelText: 'Note'),
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
              title: const Text('إجمالي Total'),
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
                  subtitle: Text('${record.formattedDate} • ${record.company} • ${record.driverName}'),
                  trailing: SizedBox(
                    width: 120,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(NumberFormat.currency(symbol: 'SAR ', decimalDigits: 2).format(record.total)),
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
