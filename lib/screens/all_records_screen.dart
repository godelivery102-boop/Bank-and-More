import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../app.dart';
import '../models/location_record.dart';
import '../models/order_express_record.dart';

class AllRecordsScreen extends StatefulWidget {
  const AllRecordsScreen({super.key});

  @override
  State<AllRecordsScreen> createState() => _AllRecordsScreenState();
}

class _AllRecordsScreenState extends State<AllRecordsScreen> {
  List<LocationRecord> _locationRecords = [];
  List<OrderExpressRecord> _orderRecords = [];
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final location = LocalStorage.loadLocationRecords();
    final orders = LocalStorage.loadOrderRecords();
    setState(() {
      _locationRecords = location;
      _orderRecords = orders;
    });
  }

  List<LocationRecord> get filteredLocationRecords {
    final query = _searchQuery.trim().toLowerCase();
    if (query.isEmpty) return _locationRecords;
    return _locationRecords.where((record) {
      final text = [record.customerName, record.captainName, record.location, record.account].join(' ').toLowerCase();
      return text.contains(query);
    }).toList();
  }

  List<OrderExpressRecord> get filteredOrderRecords {
    final query = _searchQuery.trim().toLowerCase();
    if (query.isEmpty) return _orderRecords;
    return _orderRecords.where((record) {
      final text = [record.customerName, record.company, record.driverName, record.location, record.note].join(' ').toLowerCase();
      return text.contains(query);
    }).toList();
  }

  double get totalLocation => _locationRecords.fold(0.0, (sum, item) => sum + item.amount);
  double get totalOrder => _orderRecords.fold(0.0, (sum, item) => sum + item.total);
  double get grandTotal => totalLocation + totalOrder;

  @override
  Widget build(BuildContext context) {
    final currency = NumberFormat.currency(symbol: 'SAR ', decimalDigits: 2);

    return Scaffold(
      appBar: AppBar(
        title: const Text('جميع السجلات'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  TextField(
                    decoration: const InputDecoration(
                      labelText: 'بحث سريع',
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) => setState(() => _searchQuery = value),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: _MetricCard(title: 'Location', value: currency.format(totalLocation), color: Colors.indigo),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _MetricCard(title: 'Order Express', value: currency.format(totalOrder), color: Colors.green),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _MetricCard(title: 'المجموع النهائي', value: currency.format(grandTotal), color: Colors.orange, isLarge: true),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Text('Location', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          const SizedBox(height: 10),
          ...filteredLocationRecords.map(
            (record) => Card(
              child: ListTile(
                title: Text(record.customerName),
                subtitle: Text('${record.formattedDate} • ${record.location} • ${record.captainName}'),
                trailing: Text(currency.format(record.amount), style: const TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
          ),
          const SizedBox(height: 22),
          const Text('Order Express', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          const SizedBox(height: 10),
          ...filteredOrderRecords.map(
            (record) => Card(
              child: ListTile(
                title: Text(record.customerName),
                subtitle: Text('${record.formattedDate} • ${record.company} • ${record.driverName}'),
                trailing: Text(currency.format(record.total), style: const TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MetricCard extends StatelessWidget {
  const _MetricCard({
    required this.title,
    required this.value,
    required this.color,
    this.isLarge = false,
  });

  final String title;
  final String value;
  final Color color;
  final bool isLarge;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: isLarge ? 18 : 16,
            ),
          ),
        ],
      ),
    );
  }
}
