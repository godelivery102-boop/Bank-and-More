import 'package:intl/intl.dart';

class OrderExpressRecord {
  OrderExpressRecord({
    required this.id,
    required this.date,
    required this.company,
    required this.customerName,
    required this.driverName,
    required this.qty,
    required this.orderValue,
    required this.co,
    required this.driverValue,
    required this.location,
    required this.note,
    required this.total,
    required this.createdAt,
  });

  final String id;
  final DateTime date;
  final String company;
  final String customerName;
  final String driverName;
  final int qty;
  final double orderValue;
  final double co;
  final double driverValue;
  final String location;
  final String note;
  final double total;
  final DateTime createdAt;

  String get formattedDate => DateFormat('yyyy-MM-dd').format(date);
  String get formattedTotal => NumberFormat.currency(symbol: '').format(total);

  Map<String, dynamic> toJson() => {
        'id': id,
        'date': date.toIso8601String(),
        'company': company,
        'customerName': customerName,
        'driverName': driverName,
        'qty': qty,
        'orderValue': orderValue,
        'co': co,
        'driverValue': driverValue,
        'location': location,
        'note': note,
        'total': total,
        'createdAt': createdAt.toIso8601String(),
      };

  factory OrderExpressRecord.fromJson(Map<String, dynamic> json) {
    return OrderExpressRecord(
      id: json['id'] ?? DateTime.now().microsecondsSinceEpoch.toString(),
      date: DateTime.parse(json['date'] ?? DateTime.now().toIso8601String()),
      company: json['company'] ?? '',
      customerName: json['customerName'] ?? '',
      driverName: json['driverName'] ?? '',
      qty: json['qty'] is num ? (json['qty'] as num).toInt() : 0,
      orderValue: (json['orderValue'] is num) ? (json['orderValue'] as num).toDouble() : 0.0,
      co: (json['co'] is num) ? (json['co'] as num).toDouble() : 0.0,
      driverValue: (json['driverValue'] is num) ? (json['driverValue'] as num).toDouble() : 0.0,
      location: json['location'] ?? '',
      note: json['note'] ?? '',
      total: (json['total'] is num) ? (json['total'] as num).toDouble() : 0.0,
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
    );
  }
}
