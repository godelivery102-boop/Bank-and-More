import 'package:bank_and_more/app.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/location_record.dart';
import '../models/order_express_record.dart';

class InventoryScreen extends StatefulWidget {
  const InventoryScreen({super.key});

  @override
  State<InventoryScreen> createState() => _InventoryScreenState();
}

class _InventoryScreenState extends State<InventoryScreen> {
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

  @override
  Widget build(BuildContext context) {
    final totalLocation = _locationRecords.length;
    final totalOrders = _orderRecords.length;
    final totalAmountLocation = _locationRecords.fold<double>(0, (sum, item) => sum + item.amount);
    final totalAmountOrders = _orderRecords.fold<double>(0, (sum, item) => sum + item.total);

    return Scaffold(
      appBar: AppBar(
        title: const Text('الجرد'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Card(
              child: ListTile(
                title: const Text('عدد Location'),
                trailing: Text('$totalLocation', style: const TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
            Card(
              child: ListTile(
                title: const Text('عدد Order Express'),
                trailing: Text('$totalOrders', style: const TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
            Card(
              child: ListTile(
                title: const Text('إجمالي Location'),
                trailing: Text(
                  NumberFormat.currency(symbol: 'SAR ', decimalDigits: 2).format(totalAmountLocation),
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Card(
              child: ListTile(
                title: const Text('إجمالي Order Express'),
                trailing: Text(
                  NumberFormat.currency(symbol: 'SAR ', decimalDigits: 2).format(totalAmountOrders),
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'مجموع السجلات الحالية',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 12),
            Card(
              child: ListTile(
                title: const Text('إجمالي جميع الطلبات'),
                trailing: Text(
                  NumberFormat.currency(symbol: 'SAR ', decimalDigits: 2)
                      .format(totalAmountLocation + totalAmountOrders),
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
