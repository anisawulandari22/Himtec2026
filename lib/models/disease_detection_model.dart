class DiseaseDetectionResult {
  final String cropName;
  final String condition;
  final String diseaseName;
  final String severity; // Normal, Rendah, Sedang, Kritis
  final int confidence; // e.g. 95%
  final List<String> symptoms;
  final List<String> organicSolutions;
  final List<String> preventionTips;
  final String summary;
  final DateTime scannedAt;
  final String? imagePath;

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
  });

  factory DiseaseDetectionResult.fromJson(Map<String, dynamic> json, {String? imagePath}) {
    return DiseaseDetectionResult(
      cropName: json['cropName']?.toString() ?? 'Tanaman Tidak Dikenal',
      condition: json['condition']?.toString() ?? 'Perlu Pemeriksaan Lanjut',
      diseaseName: json['diseaseName']?.toString() ?? 'Tidak terdeteksi penyakit spesifik',
      severity: json['severity']?.toString() ?? 'Sedang',
      confidence: (json['confidence'] is num) ? (json['confidence'] as num).toInt() : 88,
      symptoms: (json['symptoms'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      organicSolutions: (json['organicSolutions'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      preventionTips: (json['preventionTips'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      summary: json['summary']?.toString() ?? 'Hasil analisis kecerdasan buatan Gemini.',
      scannedAt: DateTime.now(),
      imagePath: imagePath,
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
    };
  }
}

