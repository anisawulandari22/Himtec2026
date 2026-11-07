class LivestockModel {
  final String id;
  final String tagNumber; // e.g. "AGL-SP-021"
  final String name;
  final String category; // 'Sapi Potong', 'Sapi Perah', 'Kambing / Domba', 'Ayam Broiler', 'Ayam Layer'
  final String breed; // e.g. 'Simental Cross', 'Kambing Boer', 'Etawa', 'Cobb 500'
  final String gender; // 'Jantan', 'Betina'
  final int ageMonths; // usia dalam bulan
  final double currentWeightKg; // bobot saat ini
  final double targetWeightKg; // target bobot panen
  final String healthStatus; // 'Sehat', 'Masa Pemulihan', 'Karantina'
  final String imagePath;
  final FeedRequirement feedRequirement;
  List<LivestockTaskModel> tasks;

  LivestockModel({
    required this.id,
    required this.tagNumber,
    required this.name,
    required this.category,
    required this.breed,
    required this.gender,
    required this.ageMonths,
    required this.currentWeightKg,
    required this.targetWeightKg,
    required this.healthStatus,
    required this.imagePath,
    required this.feedRequirement,
    required this.tasks,
  });

  double get weightProgressPercent {
    if (targetWeightKg <= 0) return 0;
    final pct = (currentWeightKg / targetWeightKg) * 100;
    return pct > 100 ? 100 : pct;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'tagNumber': tagNumber,
      'name': name,
      'category': category,
      'breed': breed,
      'gender': gender,
      'ageMonths': ageMonths,
      'currentWeightKg': currentWeightKg,
      'targetWeightKg': targetWeightKg,
      'healthStatus': healthStatus,
      'imagePath': imagePath,
      'feedRequirement': feedRequirement.toJson(),
      'tasks': tasks.map((t) => t.toJson()).toList(),
    };
  }

  factory LivestockModel.fromJson(Map<String, dynamic> json) {
    return LivestockModel(
      id: json['id'] as String? ?? '',
      tagNumber: json['tagNumber'] as String? ?? '',
      name: json['name'] as String? ?? '',
      category: json['category'] as String? ?? '',
      breed: json['breed'] as String? ?? '',
      gender: json['gender'] as String? ?? 'Jantan',
      ageMonths: json['ageMonths'] as int? ?? 1,
      currentWeightKg: (json['currentWeightKg'] as num?)?.toDouble() ?? 0.0,
      targetWeightKg: (json['targetWeightKg'] as num?)?.toDouble() ?? 0.0,
      healthStatus: json['healthStatus'] as String? ?? 'Sehat',
      imagePath: json['imagePath'] as String? ?? '',
      feedRequirement: json['feedRequirement'] != null
          ? FeedRequirement.fromJson(json['feedRequirement'] as Map<String, dynamic>)
          : FeedRequirement.defaultRequirement(json['category'] as String? ?? 'Sapi Potong'),
      tasks: (json['tasks'] as List<dynamic>?)
              ?.map((t) => LivestockTaskModel.fromJson(t as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}

class FeedRequirement {
  final double forageKgDaily; // Hijauan segar (rumput odot, gajah, lamtoro) per hari (kg)
  final double concentrateKgDaily; // Konsentrat / ampas tahu / dedak per hari (kg)
  final double waterLitersDaily; // Kebutuhan air minum bersih (liter/hari)
  final List<String> vitaminsAndMinerals; // Suplemen vitamin & mineral esensial
  final String feedingSchedule; // Jadwal pemberian pakan

  FeedRequirement({
    required this.forageKgDaily,
    required this.concentrateKgDaily,
    required this.waterLitersDaily,
    required this.vitaminsAndMinerals,
    required this.feedingSchedule,
  });

  Map<String, dynamic> toJson() {
    return {
      'forageKgDaily': forageKgDaily,
      'concentrateKgDaily': concentrateKgDaily,
      'waterLitersDaily': waterLitersDaily,
      'vitaminsAndMinerals': vitaminsAndMinerals,
      'feedingSchedule': feedingSchedule,
    };
  }

  factory FeedRequirement.fromJson(Map<String, dynamic> json) {
    return FeedRequirement(
      forageKgDaily: (json['forageKgDaily'] as num?)?.toDouble() ?? 0.0,
      concentrateKgDaily: (json['concentrateKgDaily'] as num?)?.toDouble() ?? 0.0,
      waterLitersDaily: (json['waterLitersDaily'] as num?)?.toDouble() ?? 0.0,
      vitaminsAndMinerals: (json['vitaminsAndMinerals'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      feedingSchedule: json['feedingSchedule'] as String? ?? '',
    );
  }

  static FeedRequirement defaultRequirement(String category) {
    if (category.contains('Sapi')) {
      return FeedRequirement(
        forageKgDaily: 45.0,
        concentrateKgDaily: 6.5,
        waterLitersDaily: 55.0,
        vitaminsAndMinerals: [
          'Premix Mineral Sapi Potong (50 gr/hari)',
          'Vitamin A, D3, E injeksi berkala',
        ],
        feedingSchedule: 'Pagi: Konsentrat & Hijauan | Sore: Konsentrat & Hijauan',
      );
    } else if (category.contains('Kambing') || category.contains('Domba')) {
      return FeedRequirement(
        forageKgDaily: 4.5,
        concentrateKgDaily: 0.9,
        waterLitersDaily: 7.0,
        vitaminsAndMinerals: [
          'B-Kompleks oral & kalsium laktat',
        ],
        feedingSchedule: 'Pagi: Konsentrat | Sore: Hijauan',
      );
    } else {
      return FeedRequirement(
        forageKgDaily: 0.0,
        concentrateKgDaily: 0.16,
        waterLitersDaily: 0.35,
        vitaminsAndMinerals: [
          'Vitamin C & Elektrolit antistres air minum',
        ],
        feedingSchedule: 'Pemberian ransum ad-libitum',
      );
    }
  }
}

class LivestockTaskModel {
  String title;
  String subtitle;
  bool isCompleted;

  LivestockTaskModel({
    required this.title,
    required this.subtitle,
    required this.isCompleted,
  });

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'subtitle': subtitle,
      'isCompleted': isCompleted,
    };
  }

  factory LivestockTaskModel.fromJson(Map<String, dynamic> json) {
    return LivestockTaskModel(
      title: json['title'] as String? ?? '',
      subtitle: json['subtitle'] as String? ?? '',
      isCompleted: json['isCompleted'] as bool? ?? false,
    );
  }
}

class LivestockDiseaseItem {
  final String name;
  final String latinName;
  final String category; // 'Ruminansia (Sapi/Kambing)', 'Unggas (Ayam/Bebek)'
  final String affected;
  final String severity; // 'Kritis', 'Tinggi', 'Sedang'
  final bool isZoonosis; // Menular ke manusia atau tidak
  final String symptoms;
  final String treatment;
  final String prevention;

  const LivestockDiseaseItem({
    required this.name,
    required this.latinName,
    required this.category,
    required this.affected,
    required this.severity,
    required this.isZoonosis,
    required this.symptoms,
    required this.treatment,
    required this.prevention,
  });
}
