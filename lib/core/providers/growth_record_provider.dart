import 'package:flutter/foundation.dart';
import '../../models/growth_record_model.dart';
import '../services/storage_service.dart';

class GrowthRecordProvider extends ChangeNotifier {
  final List<GrowthRecordModel> _records = [];

  static final List<GrowthRecordModel> _defaultSeedRecords = [
    GrowthRecordModel(
      id: 'seed_ls_1',
      entityId: '1',
      entityName: 'Sapi Limosin Super',
      entityType: 'Ternak',
      category: 'Sapi Potong • Limosin Cross',
      note: 'Nafsu makan sangat tinggi, ransum konsentrat 5.5 kg dan rumput gajah habis tanpa sisa. Mata jernih, feses padat normal, pernapasan teratur. Pertambahan bobot stabil.',
      imagePath: 'https://images.unsplash.com/photo-1546445317-29f4545e9d53?w=400',
      date: DateTime.now().subtract(const Duration(hours: 6)),
      extraMetric: 'Bobot: 365.5 kg',
    ),
    GrowthRecordModel(
      id: 'seed_cr_1',
      entityId: '1',
      entityName: 'Padi Inpari 32',
      entityType: 'Tanaman',
      category: 'Pangan & Sawah',
      note: 'Irigasi macak-macak terjaga baik. Rumpun anakan bertambah lebat, warna daun hijau tua segar, dan tidak ditemukan tanda-tanda serangan wereng coklat atau sundep.',
      imagePath: 'https://images.unsplash.com/photo-1536657464919-892534f60d6e?w=400',
      date: DateTime.now().subtract(const Duration(days: 1, hours: 2)),
      extraMetric: 'Hari ke-35 dari 115',
    ),
    GrowthRecordModel(
      id: 'seed_cr_2',
      entityId: '2',
      entityName: 'Cabai Rawit Merah',
      entityType: 'Tanaman',
      category: 'Hortikultura',
      note: 'Penyemprotan pupuk kalsium-boron kocor berhasil mencegah kerontokan bunga. Muncul bakal buah cabai pertama yang serempak dan bebas bercak patek.',
      imagePath: 'https://images.unsplash.com/photo-1588252303782-cb80119abd6d?w=400',
      date: DateTime.now().subtract(const Duration(days: 2, hours: 5)),
      extraMetric: 'Hari ke-48 dari 100',
    ),
    GrowthRecordModel(
      id: 'seed_ls_2',
      entityId: '2',
      entityName: 'Kambing Boer Jantan',
      entityType: 'Ternak',
      category: 'Kambing / Domba • Boer Cross F1',
      note: 'Pemberian suplemen vitamin A-D-E dan mineral premix. Postur dada makin bidang, bulu mengkilap, dan aktivitas di kandang sangat lincah.',
      imagePath: 'https://images.unsplash.com/photo-1524024973431-2ad916746881?w=400',
      date: DateTime.now().subtract(const Duration(days: 3, hours: 8)),
      extraMetric: 'Bobot: 32.0 kg',
    ),
  ];

  GrowthRecordProvider() {
    _loadRecords();
  }

  Future<void> _loadRecords() async {
    final saved = await StorageService.getGrowthRecords();
    if (saved != null && saved.isNotEmpty) {
      _records.clear();
      _records.addAll(saved);
    } else {
      _records.clear();
      _records.addAll(_defaultSeedRecords);
      await StorageService.saveGrowthRecords(_records);
    }
    notifyListeners();
  }

  List<GrowthRecordModel> get records => List.unmodifiable(_records);

  int get totalRecords => _records.length;
  int get totalCropRecords => _records.where((r) => r.entityType == 'Tanaman').length;
  int get totalLivestockRecords => _records.where((r) => r.entityType == 'Ternak').length;

  List<GrowthRecordModel> filterByType(String type) {
    if (type == 'Tanaman') {
      return _records.where((r) => r.entityType == 'Tanaman').toList();
    } else if (type == 'Ternak') {
      return _records.where((r) => r.entityType == 'Ternak').toList();
    }
    return _records;
  }

  List<GrowthRecordModel> getRecordsByEntityId(String entityId) {
    return _records.where((r) => r.entityId == entityId).toList();
  }

  void addRecord(GrowthRecordModel record) {
    _records.insert(0, record);
    notifyListeners();
    StorageService.saveGrowthRecords(_records);
  }

  void removeRecord(String id) {
    _records.removeWhere((r) => r.id == id);
    notifyListeners();
    StorageService.saveGrowthRecords(_records);
  }
}

