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
            child: ListTile(
              title: const Text('إجمالي Location'),
              trailing: Text(currency.format(totalLocation), style: const TextStyle(fontWeight: FontWeight.bold)),
            ),
          ),
          const SizedBox(height: 10),
          Card(
            child: ListTile(
              title: const Text('إجمالي Order Express'),
              trailing: Text(currency.format(totalOrder), style: const TextStyle(fontWeight: FontWeight.bold)),
            ),
          ),
          const SizedBox(height: 10),
          Card(
            child: ListTile(
              title: const Text('المجموع النهائي'),
              trailing: Text(currency.format(grandTotal), style: const TextStyle(fontWeight: FontWeight.bold)),
            ),
          ),
          const SizedBox(height: 20),
          const Text('Location', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          const SizedBox(height: 10),
          ..._locationRecords.map(
            (record) => Card(
              child: ListTile(
                title: Text(record.customerName),
                subtitle: Text('${record.formattedDate} • ${record.location} • ${record.captainName}'),
                trailing: Text(currency.format(record.amount)),
              ),
            ),
          ),
          const SizedBox(height: 22),
          const Text('Order Express', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          const SizedBox(height: 10),
          ..._orderRecords.map(
            (record) => Card(
              child: ListTile(
                title: Text(record.customerName),
                subtitle: Text('${record.formattedDate} • ${record.company} • ${record.driverName}'),
                trailing: Text(currency.format(record.total)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
