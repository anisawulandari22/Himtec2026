class LivestockModel {
  final String id;
  final String tagNumber; // e.g. "AGL-SP-021"
  final String name;
  final String category; // 'Sapi Potong', 'Sapi Perah', 'Kambing / Domba', 'Ayam Broiler', 'Ayam Petelur'
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
