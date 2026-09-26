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

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final records = LocalStorage.loadOrderRecords();
    setState(() => _records = records);
  }

  double get totalAmount => _records.fold(0.0, (sum, item) => sum + item.total);

  Future<void> _saveRecord() async {
    if (!_formKey.currentState!.validate()) return;

    final qty = int.tryParse(_qtyController.text.trim()) ?? 1;
    final orderValue = double.tryParse(_orderValueController.text.trim()) ?? 0;
    final co = double.tryParse(_coController.text.trim()) ?? 0;
    final driverValue = double.tryParse(_driverValueController.text.trim()) ?? 0;
    final calculatedTotal = (orderValue + co + driverValue);

    final record = OrderExpressRecord(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
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

    final list = List<OrderExpressRecord>.from(_records)..add(record);
    await LocalStorage.saveOrderRecords(list);
    setState(() {
      _records = list;
      _companyController.clear();
      _customerController.clear();
      _driverController.clear();
      _qtyController.text = '1';
      _orderValueController.clear();
      _coController.clear();
      _driverValueController.clear();
      _locationController.clear();
      _noteController.clear();
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('تم حفظ Order Express بنجاح')),
    );
  }

  Future<void> _deleteRecord(String id) async {
    final updated = _records.where((item) => item.id != id).toList();
    await LocalStorage.saveOrderRecords(updated);
    setState(() => _records = updated);
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
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton.icon(
                        onPressed: _saveRecord,
                        icon: const Icon(Icons.save_alt),
                        label: const Text('حفظ'),
                      ),
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
          ..._records.map((record) => Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  title: Text(record.customerName),
                  subtitle: Text(
                    '${record.formattedDate} • ${record.company} • ${record.driverName}',
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(NumberFormat.currency(symbol: 'SAR ', decimalDigits: 2).format(record.total)),
                      IconButton(
                        icon: const Icon(Icons.delete_outline, color: Colors.red),
                        onPressed: () => _deleteRecord(record.id),
                      ),
                    ],
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
        if (date != null) {
          onChanged(date);
        }
      },
      child: InputDecorator(
        decoration: InputDecoration(labelText: label),
        child: Text(DateFormat('yyyy-MM-dd').format(selectedDate)),
      ),
    );
  }
}
