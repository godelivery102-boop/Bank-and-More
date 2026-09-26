import 'dart:convert';
import 'package:flutter/material.dart';

import '../models/location_record.dart';
import '../models/order_express_record.dart';

class GoogleSheetsService {
  Future<bool> syncLocationRecords(List<LocationRecord> records) async {
    final payload = jsonEncode({
      'sheet': 'location',
      'count': records.length,
      'records': records.map((record) => record.toJson()).toList(),
    });

    debugPrint('Google Sheets sync request prepared: $payload');
    return true;
  }

  Future<bool> syncOrderRecords(List<OrderExpressRecord> records) async {
    final payload = jsonEncode({
      'sheet': 'order_express',
      'count': records.length,
      'records': records.map((record) => record.toJson()).toList(),
    });

    debugPrint('Google Sheets sync request prepared: $payload');
    return true;
  }
}
