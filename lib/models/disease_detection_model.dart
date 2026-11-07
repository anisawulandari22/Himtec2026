class DiseaseDetectionResult {
  final String cropName; // Menyimpan nama tanaman atau nama jenis hewan ternak
  final String condition;
  final String diseaseName;
  final String severity; // Normal, Rendah, Sedang, Kritis, Tinggi
  final int confidence; // e.g. 95%
  final List<String> symptoms;
  final List<String> organicSolutions; // Solusi hayati/organik atau protokol darurat veteriner
  final List<String> preventionTips;
  final String summary;
  final DateTime scannedAt;
  final String? imagePath;
  final String aiEngine;
  final String sector; // 'Pertanian' atau 'Peternakan'

  DiseaseDetectionResult({
    required this.cropName,
    required this.condition,
    required this.diseaseName,
    required this.severity,
    required this.confidence,
    required this.symptoms,
    required this.organicSolutions,
    required this.preventionTips,
    required this.summary,
    required this.scannedAt,
    this.imagePath,
    this.aiEngine = 'AGL Agro-Veterinary AI Engine',
    this.sector = 'Pertanian',
  });

  bool get isLivestock => sector == 'Peternakan';

  factory DiseaseDetectionResult.fromJson(
    Map<String, dynamic> json, {
    String? imagePath,
    String aiEngine = 'AGL Agro-Veterinary AI Engine',
    String defaultSector = 'Pertanian',
  }) {
    final name = json['cropName']?.toString() ??
        json['subjectName']?.toString() ??
        (defaultSector == 'Peternakan' ? 'Hewan Ternak' : 'Tanaman Agrikultur');

    // Deteksi otomatis sektor jika tidak eksplisit dalam JSON
    final explicitSector = json['sector']?.toString();
    final inferredSector = explicitSector ??
        ((name.toLowerCase().contains('sapi') ||
                name.toLowerCase().contains('kambing') ||
                name.toLowerCase().contains('domba') ||
                name.toLowerCase().contains('ayam') ||
                name.toLowerCase().contains('bebek') ||
                name.toLowerCase().contains('unggas') ||
                name.toLowerCase().contains('ternak'))
            ? 'Peternakan'
            : defaultSector);

    return DiseaseDetectionResult(
      cropName: name,
      condition: json['condition']?.toString() ?? 'Pemeriksaan Kesehatan',
      diseaseName: json['diseaseName']?.toString() ?? 'Analisis Visual AI',
      severity: json['severity']?.toString() ?? 'Sedang',
      confidence: (json['confidence'] is num) ? (json['confidence'] as num).toInt() : 94,
      symptoms: (json['symptoms'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      organicSolutions: (json['organicSolutions'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          (json['treatments'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      preventionTips: (json['preventionTips'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      summary: json['summary']?.toString() ?? 'Diagnosa terkalibrasi sistem kecerdasan buatan.',
      scannedAt: DateTime.now(),
      imagePath: imagePath,
      aiEngine: json['aiEngine']?.toString() ?? aiEngine,
      sector: inferredSector,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'cropName': cropName,
      'condition': condition,
      'diseaseName': diseaseName,
      'severity': severity,
      'confidence': confidence,
      'symptoms': symptoms,
      'organicSolutions': organicSolutions,
      'preventionTips': preventionTips,
      'summary': summary,
      'scannedAt': scannedAt.toIso8601String(),
      'imagePath': imagePath,
      'aiEngine': aiEngine,
      'sector': sector,
    };
  }
}
