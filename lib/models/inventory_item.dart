class InventoryItem {
  InventoryItem({
    required this.id,
    required this.name,
    required this.count,
    required this.type,
    required this.updatedAt,
  });

  final String id;
  final String name;
  final int count;
  final String type;
  final DateTime updatedAt;

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'count': count,
        'type': type,
        'updatedAt': updatedAt.toIso8601String(),
      };

  factory InventoryItem.fromJson(Map<String, dynamic> json) {
    return InventoryItem(
      id: json['id'] ?? DateTime.now().microsecondsSinceEpoch.toString(),
      name: json['name'] ?? '',
      count: json['count'] is num ? (json['count'] as num).toInt() : 0,
      type: json['type'] ?? 'manual',
      updatedAt: DateTime.parse(json['updatedAt'] ?? DateTime.now().toIso8601String()),
    );
  }
}
