class GrowthRecordModel {
  final String id;
  final String entityId;
  final String entityName;
  final String entityType; // 'Tanaman' atau 'Ternak'
  final String category;
  final String note;
  final String? imagePath;
  final DateTime date;
  final String? extraMetric;

  const GrowthRecordModel({
    required this.id,
    required this.entityId,
    required this.entityName,
    required this.entityType,
    required this.category,
    required this.note,
    this.imagePath,
    required this.date,
    this.extraMetric,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'entityId': entityId,
    'entityName': entityName,
    'entityType': entityType,
    'category': category,
    'note': note,
    'imagePath': imagePath,
    'date': date.toIso8601String(),
    'extraMetric': extraMetric,
  };

  factory GrowthRecordModel.fromJson(Map<String, dynamic> json) => GrowthRecordModel(
    id: json['id'] as String? ?? '',
    entityId: json['entityId'] as String? ?? '',
    entityName: json['entityName'] as String? ?? '',
    entityType: json['entityType'] as String? ?? 'Tanaman',
    category: json['category'] as String? ?? '',
    note: json['note'] as String? ?? '',
    imagePath: json['imagePath'] as String?,
    date: json['date'] != null
        ? DateTime.tryParse(json['date'] as String) ?? DateTime.now()
        : DateTime.now(),
    extraMetric: json['extraMetric'] as String?,
  );
}
