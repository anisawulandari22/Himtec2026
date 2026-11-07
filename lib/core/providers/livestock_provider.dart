import 'package:flutter/foundation.dart';
import '../../models/livestock_model.dart';
import '../services/storage_service.dart';

class LivestockProvider extends ChangeNotifier {
  final List<LivestockModel> _livestock = [];

  static final List<LivestockModel> _defaultSeedLivestock = [
    LivestockModel(
      id: '1',
      tagNumber: 'AGL-SP-042',
      name: 'Sapi Simental Cross (Bima)',
      category: 'Sapi Potong',
      breed: 'Simental Cross Madura',
      gender: 'Jantan',
      ageMonths: 18,
      currentWeightKg: 465.0,
      targetWeightKg: 620.0,
      healthStatus: 'Sehat',
      imagePath: 'https://images.unsplash.com/photo-1546445317-29f4545e9d53?w=400',
      feedRequirement: FeedRequirement(
        forageKgDaily: 45.0, // Rumput Gajah / Odot 10% BB
        concentrateKgDaily: 6.5, // Konsentrat protein 14-16%
        waterLitersDaily: 55.0,
        vitaminsAndMinerals: [
          'Premix Mineral Sapi Potong (50 gr/hari)',
          'Vitamin A, D3, E injeksi berkala',
          'Garam jilat (mineral block) ad-libitum',
        ],
        feedingSchedule: 'Pagi: Konsentrat 3 kg & Hijauan 20 kg | Sore: Konsentrat 3.5 kg & Hijauan 25 kg',
      ),
      tasks: [
        LivestockTaskModel(
          title: 'Beri pakan pagi konsentrat + rumput odot fermentasi',
          subtitle: 'Selesai',
          isCompleted: true,
        ),
        LivestockTaskModel(
          title: 'Pemeriksaan sanitasi lantai kandang & palungan',
          subtitle: 'Selesai',
          isCompleted: true,
        ),
        LivestockTaskModel(
          title: 'Pemberian premix vitamin larut air minum sore',
          subtitle: 'Belum selesai',
          isCompleted: false,
        ),
      ],
    ),
    LivestockModel(
      id: '2',
      tagNumber: 'AGL-KB-118',
      name: 'Kambing Boer Cross (Ranger)',
      category: 'Kambing / Domba',
      breed: 'Boer Cross F2',
      gender: 'Jantan',
      ageMonths: 10,
      currentWeightKg: 38.5,
      targetWeightKg: 52.0,
      healthStatus: 'Sehat',
      imagePath: 'https://images.unsplash.com/photo-1524024973431-2ad916746881?w=400',
      feedRequirement: FeedRequirement(
        forageKgDaily: 4.5,
        concentrateKgDaily: 0.9,
        waterLitersDaily: 7.0,
        vitaminsAndMinerals: [
          'B-Kompleks oral & kalsium laktat',
          'Suplemen probiotik tetes tebu fermentasi pakan',
        ],
        feedingSchedule: 'Pagi 07:30 (Konsentrat 400g) | Siang 12:00 (Rambanan lamtoro) | Sore 16:30 (Hijauan 3 kg)',
      ),
      tasks: [
        LivestockTaskModel(
          title: 'Pemberian pakan daun indigofera & lamtoro kering',
          subtitle: 'Selesai',
          isCompleted: true,
        ),
        LivestockTaskModel(
          title: 'Cek kondisi kuku & penyemprotan obat lalat kandang',
          subtitle: 'Belum selesai',
          isCompleted: false,
        ),
      ],
    ),
    LivestockModel(
      id: '3',
      tagNumber: 'AGL-BR-500',
      name: 'Ayam Broiler Kandang 2 (500 Ekor)',
      category: 'Ayam Broiler',
      breed: 'Cobb 500',
      gender: 'Campur',
      ageMonths: 1, // 28 hari
      currentWeightKg: 1.75, // Rata-rata per ekor
      targetWeightKg: 2.20,
      healthStatus: 'Sehat',
      imagePath: 'https://images.unsplash.com/photo-1548550023-2bdb3c5beed7?w=400',
      feedRequirement: FeedRequirement(
        forageKgDaily: 0.0,
        concentrateKgDaily: 0.16, // 160 gram per ekor/hari ransum finisher
        waterLitersDaily: 0.35, // 350 ml per ekor/hari
        vitaminsAndMinerals: [
          'Vitamin C & Elektrolit antistres air minum (siang hari)',
          'Asam amino metionin & lisin pendukung bobot dada',
        ],
        feedingSchedule: 'Pemberian pakan ad-libitum (selalu tersedia) dengan pengontrolan suhu blower kandang',
      ),
      tasks: [
        LivestockTaskModel(
          title: 'Kontrol tirai & exhaust fan sirkulasi udara amonia',
          subtitle: 'Selesai',
          isCompleted: true,
        ),
        LivestockTaskModel(
          title: 'Cek nipple drinker & tambahkan vitamin antistres siang',
          subtitle: 'Belum selesai',
          isCompleted: false,
        ),
      ],
    ),
    LivestockModel(
      id: '4',
      tagNumber: 'AGL-FH-008',
      name: 'Sapi Perah FH (Bella)',
      category: 'Sapi Perah',
      breed: 'Friesian Holstein Murni',
      gender: 'Betina',
      ageMonths: 32,
      currentWeightKg: 525.0,
      targetWeightKg: 560.0,
      healthStatus: 'Sehat',
      imagePath: 'https://images.unsplash.com/photo-1570042225831-d98fa7577f1e?w=400',
      feedRequirement: FeedRequirement(
        forageKgDaily: 52.0,
        concentrateKgDaily: 8.5,
        waterLitersDaily: 75.0, // Sapi perah butuh air sangat banyak
        vitaminsAndMinerals: [
          'Mineral bolus kalsium pencegah milk fever (demam susu)',
          'Biotin pembentuk kuku & vitamin E perangsang laktasi',
        ],
        feedingSchedule: 'Pagi 05:00 (Perah & konsentrat) | Pagi 08:00 (Hijauan) | Sore 15:00 (Perah sore & konsentrat)',
      ),
      tasks: [
        LivestockTaskModel(
          title: 'Pemerataan dipping antiseptik puting usai perah pagi',
          subtitle: 'Selesai',
          isCompleted: true,
        ),
        LivestockTaskModel(
          title: 'Pemberian konsentrat protein 18% + bungkil kedelai',
          subtitle: 'Belum selesai',
          isCompleted: false,
        ),
      ],
    ),
    LivestockModel(
      id: '5',
      tagNumber: 'AGL-DG-067',
      name: 'Domba Garut Pejantan (Tanduk)',
      category: 'Kambing / Domba',
      breed: 'Domba Garut Ras Murni',
      gender: 'Jantan',
      ageMonths: 15,
      currentWeightKg: 52.0,
      targetWeightKg: 68.0,
      healthStatus: 'Sehat',
      imagePath: 'https://images.unsplash.com/photo-1484557052118-f32bd25b45b5?w=400',
      feedRequirement: FeedRequirement(
        forageKgDaily: 5.5,
        concentrateKgDaily: 1.2,
        waterLitersDaily: 8.0,
        vitaminsAndMinerals: [
          'Mineral blok jilat penguat tanduk & tulang',
          'Obat cacing Albendazole rutin tiap 3 bulan',
        ],
        feedingSchedule: 'Pagi 07:00 (Ampas tahu + dedak) | Siang (Rumput segar) | Sore (Konsentrat + garam)',
      ),
      tasks: [
        LivestockTaskModel(
          title: 'Jemur pagi 30 menit & pembersihan bulu domba',
          subtitle: 'Selesai',
          isCompleted: true,
        ),
        LivestockTaskModel(
          title: 'Pemberian pakan konsentrat penguat otot',
          subtitle: 'Belum selesai',
          isCompleted: false,
        ),
      ],
    ),
  ];

  LivestockProvider() {
    _loadLivestock();
  }

  Future<void> _loadLivestock() async {
    final saved = await StorageService.getLivestock();
    if (saved != null && saved.isNotEmpty) {
      _livestock.clear();
      _livestock.addAll(saved);
    } else {
      _livestock.clear();
      _livestock.addAll(_defaultSeedLivestock);
      await StorageService.saveLivestock(_livestock);
    }
    notifyListeners();
  }

  List<LivestockModel> get livestockList => List.unmodifiable(_livestock);

  int get totalLivestock => _livestock.length;

  List<LivestockModel> filterByCategory(String category) {
    if (category == 'Semua') return _livestock;
    return _livestock.where((item) => item.category == category).toList();
  }

  LivestockModel? getLivestockById(String id) {
    try {
      return _livestock.firstWhere((item) => item.id == id);
    } catch (_) {
      return null;
    }
  }

  void addLivestock(LivestockModel item) {
    _livestock.insert(0, item);
    notifyListeners();
    StorageService.saveLivestock(_livestock);
  }

  void removeLivestock(String id) {
    _livestock.removeWhere((item) => item.id == id);
    notifyListeners();
    StorageService.saveLivestock(_livestock);
  }

  void updateWeight(String id, double newWeight) {
    final index = _livestock.indexWhere((item) => item.id == id);
    if (index != -1) {
      final current = _livestock[index];
      _livestock[index] = LivestockModel(
        id: current.id,
        tagNumber: current.tagNumber,
        name: current.name,
        category: current.category,
        breed: current.breed,
        gender: current.gender,
        ageMonths: current.ageMonths,
        currentWeightKg: newWeight,
        targetWeightKg: current.targetWeightKg,
        healthStatus: current.healthStatus,
        imagePath: current.imagePath,
        feedRequirement: current.feedRequirement,
        tasks: current.tasks,
      );
      notifyListeners();
      StorageService.saveLivestock(_livestock);
    }
  }

  void toggleTask(String livestockId, int taskIndex) {
    final item = getLivestockById(livestockId);
    if (item != null && taskIndex >= 0 && taskIndex < item.tasks.length) {
      final task = item.tasks[taskIndex];
      task.isCompleted = !task.isCompleted;
      task.subtitle = task.isCompleted ? 'Selesai' : 'Belum selesai';
      notifyListeners();
      StorageService.saveLivestock(_livestock);
    }
  }

  // Database Penyakit Ternak Terintegrasi
  static const List<LivestockDiseaseItem> diseases = [
    LivestockDiseaseItem(
      name: 'Penyakit Mulut & Kuku (PMK)',
      latinName: 'Aphthovirus',
      category: 'Ruminansia (Sapi/Kambing)',
      affected: 'Sapi Potong, Sapi Perah, Kerbau, Kambing, Domba',
      severity: 'Kritis',
      isZoonosis: false,
      symptoms: 'Lepuh/erosi di lidah, gusi, dan celah kuku; air liur berbusa berlebihan (hipersalivasi); demam tinggi; pincang enggan berdiri.',
      treatment: 'Semprot antiseptik luka pada kuku & mulut (larutan tembaga sulfat/iodin), injeksi analgesik penurun demam, dan antibiotik cegah infeksi sekunder.',
      prevention: 'Vaksinasi PMK berkala, karantina ternak baru minimal 14 hari, dan semprot disinfektan kandang rutin.',
    ),
    LivestockDiseaseItem(
      name: 'Antraks / Radang Limpa',
      latinName: 'Bacillus anthracis',
      category: 'Ruminansia (Sapi/Kambing)',
      affected: 'Sapi, Kerbau, Kambing, Domba (Menular ke Manusia)',
      severity: 'Kritis',
      isZoonosis: true,
      symptoms: 'Kematian mendadak ternak, demam tinggi, keluar darah hitam pekat tidak membeku dari lubang alami (hidung, mulut, anus).',
      treatment: 'Ternak sakit parah diobati penisilin dosis tinggi atas pengawasan dokter hewan. DILARANG membedah bangkai karena spora antraks tahan puluhan tahun.',
      prevention: 'Vaksinasi spora antraks tahunan di daerah endemis, bangkai wajib dikubur minimal sedalam 2 meter dilapisi kapur tohor.',
    ),
    LivestockDiseaseItem(
      name: 'Mastitis (Radang Ambing Susu)',
      latinName: 'Streptococcus / Staphylococcus',
      category: 'Ruminansia (Sapi/Kambing)',
      affected: 'Sapi Perah & Kambing Perah',
      severity: 'Tinggi',
      isZoonosis: false,
      symptoms: 'Kelenjar susu membengkak panas keras, susu menggumpal pecah berlendir atau bercampur nanah/darah, produksi susu anjlok drastis.',
      treatment: 'Kuras tuntas susu yang terinfeksi (stripping), infus antibiotik intramamari ke dalam puting, dan kompres air hangat.',
      prevention: 'Dipping puting (celup antiseptik iodin) sebelum dan sesudah pemerahan, jaga kebersihan sanitasi karpet pemerah.',
    ),
    LivestockDiseaseItem(
      name: 'Bloat / Kembung Rumen Akut (Timpani)',
      latinName: 'Acute Ruminal Tympany',
      category: 'Ruminansia (Sapi/Kambing)',
      affected: 'Sapi, Kambing, Domba',
      severity: 'Kritis',
      isZoonosis: false,
      symptoms: 'Perut sisi kiri atas membesar kembung tegang seperti drum, ternak gelisah megap-megap menjulurkan lidah, sulit bernapas.',
      treatment: 'Beri minum minyak nabati / kelapa (100-300 ml) atau larutan anti-bloat (dimethicone). Pada kondisi darurat, tusuk fosa paralumbar kiri dengan trocar.',
      prevention: 'Jangan berikan hijauan legum basah embun pagi langsung tanpa dilayukan, hindari konsentrat pati berlebih tanpa serat kasar.',
    ),
    LivestockDiseaseItem(
      name: 'Cacing Hati & Saluran Cerna',
      latinName: 'Fasciola gigantica & Haemonchus',
      category: 'Ruminansia (Sapi/Kambing)',
      affected: 'Sapi, Kerbau, Kambing, Domba',
      severity: 'Sedang',
      isZoonosis: false,
      symptoms: 'Ternak kurus pucat (anemia), bulu kusam rontok, timbul pembengkakan di bawah rahang (bottle jaw), diare kronis.',
      treatment: 'Beri obat cacing berspektrum luas (Albendazole atau Closantel) sesuai takaran bobot badan.',
      prevention: 'Berikan obat cacing rutin tiap 3-4 bulan sekali, hindari merumput di rawa basah tempat siput inang perantara cacing.',
    ),
    LivestockDiseaseItem(
      name: 'Tetelo / Newcastle Disease (ND)',
      latinName: 'Avian Paramyxovirus Type 1',
      category: 'Unggas (Ayam/Bebek)',
      affected: 'Ayam Broiler, Ayam Petelur, Ayam Kampung, Bebek',
      severity: 'Kritis',
      isZoonosis: false,
      symptoms: 'Leher terpelintir (tortikolis), ngorok batuk bersin, kotoran hijau keputihan encer, penurunan drastis produksi telur.',
      treatment: 'Tidak ada obat kuratif untuk virus ND; berikan multivitamin dan antibiotik untuk mencegah infeksi sekunder pada unggas lain.',
      prevention: 'Wajib vaksinasi ND rutin (ND LaSota / Clone) lewat tetes mata dan air minum, terapkan biosekuriti kandang ketat.',
    ),
    LivestockDiseaseItem(
      name: 'Gumboro / IBD',
      latinName: 'Infectious Bursal Disease',
      category: 'Unggas (Ayam/Bebek)',
      affected: 'Ayam Broiler & Ayam Petelur Muda (Usia 3-6 minggu)',
      severity: 'Tinggi',
      isZoonosis: false,
      symptoms: 'Ayam gemetar lesu mengantuk, bulu sekitar kloaka basah kotoran putih berkapur, ayam mematuki duburnya sendiri.',
      treatment: 'Berikan larutan gula merah + elektrolit dan vitamin hati untuk meningkatkan stamina; isolasi unggas yang sakit.',
      prevention: 'Vaksinasi Gumboro pada umur 10-14 hari dan revaksinasi umur 21 hari.',
    ),
    LivestockDiseaseItem(
      name: 'Kudis / Budug / Scabies',
      latinName: 'Sarcoptes scabiei',
      category: 'Ruminansia (Sapi/Kambing)',
      affected: 'Kambing, Domba, Kelinci',
      severity: 'Sedang',
      isZoonosis: true,
      symptoms: 'Kulit telinga, moncong, dan kaki berkerak tebal abu-abu pecah-pecah; ternak sering menggesekkan badan ke dinding kandang karena gatal parah.',
      treatment: 'Injeksi Ivermectin subkutan (0.2 mg/kg BB) atau olesi salep belerang dan oli bersih/minyak nimba pada kerak kulit.',
      prevention: 'Jaga ventilasi kandang tidak lembap, jemur ternak pagi hari, isolasi ternak yang mulai berkerak.',
    ),
  ];
}

