import 'package:intl/intl.dart';

class LocationRecord {
  LocationRecord({
    required this.id,
    required this.date,
    required this.captainName,
    required this.account,
    required this.customerName,
    required this.location,
    required this.amount,
    required this.createdAt,
  });

  final String id;
  final DateTime date;
  final String captainName;
  final String account;
  final String customerName;
  final String location;
  final double amount;
  final DateTime createdAt;

  String get formattedDate => DateFormat('yyyy-MM-dd').format(date);
  String get formattedAmount => NumberFormat.currency(symbol: '').format(amount);

  Map<String, dynamic> toJson() => {
        'id': id,
        'date': date.toIso8601String(),
        'captainName': captainName,
        'account': account,
        'customerName': customerName,
        'location': location,
        'amount': amount,
        'createdAt': createdAt.toIso8601String(),
      };

  factory LocationRecord.fromJson(Map<String, dynamic> json) {
    return LocationRecord(
      id: json['id'] ?? DateTime.now().microsecondsSinceEpoch.toString(),
      date: DateTime.parse(json['date'] ?? DateTime.now().toIso8601String()),
      captainName: json['captainName'] ?? '',
      account: json['account'] ?? '',
      customerName: json['customerName'] ?? '',
      location: json['location'] ?? '',
      amount: (json['amount'] is num) ? (json['amount'] as num).toDouble() : 0.0,
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
    );
  }
}
