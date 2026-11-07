import 'package:flutter/foundation.dart';
import '../../models/crop_model.dart';
import '../services/storage_service.dart';

class CropProvider extends ChangeNotifier {
  final List<CropModel> _crops = [];

  static final List<CropModel> _defaultSeedCrops = [
    CropModel(
      id: '1',
      name: 'Padi Inpari 32',
      category: 'Fase bunting & malai',
      imagePath: 'https://images.unsplash.com/photo-1536657464919-892534f60d6e?w=400',
      currentDay: 65,
      totalDays: 115,
      progressPercent: 57,
      healthStatus: 'Sehat',
      tasks: [
        TaskModel(
          title: 'Pantau pengairan sawah macak-macak',
          subtitle: 'Selesai',
          isCompleted: true,
        ),
        TaskModel(
          title: 'Cek potensi serangan sundep & wereng batang coklat',
          subtitle: 'Belum selesai',
          isCompleted: false,
        ),
      ],
    ),
    CropModel(
      id: '2',
      name: 'Cabai Rawit Merah',
      category: 'Fase pembentukan buah',
      imagePath: 'https://images.unsplash.com/photo-1588252303782-cb80119abd6d?w=400',
      currentDay: 48,
      totalDays: 100,
      progressPercent: 48,
      healthStatus: 'Sehat',
      tasks: [
        TaskModel(
          title: 'Semprot pupuk kalsium-boron cegah patek',
          subtitle: 'Selesai',
          isCompleted: true,
        ),
        TaskModel(
          title: 'Pemupukan susulan NPK cair di lubang kocor',
          subtitle: 'Belum selesai',
          isCompleted: false,
        ),
      ],
    ),
    CropModel(
      id: '3',
      name: 'Jagung Hibrida',
      category: 'Fase vegetatif V8',
      imagePath: 'https://images.unsplash.com/photo-1551754655-cd27e38d2076?w=400',
      currentDay: 28,
      totalDays: 90,
      progressPercent: 31,
      healthStatus: 'Sehat',
      tasks: [
        TaskModel(
          title: 'Pembumbunan tanah akar tanaman',
          subtitle: 'Selesai',
          isCompleted: true,
        ),
        TaskModel(
          title: 'Waspadai ulat grayak pucuk (FAW)',
          subtitle: 'Belum selesai',
          isCompleted: false,
        ),
      ],
    ),
    CropModel(
      id: '4',
      name: 'Bawang Merah Brebes',
      category: 'Fase pembesaran umbi',
      imagePath: 'https://images.unsplash.com/photo-1618512496248-a07fe83aa8cb?w=400',
      currentDay: 35,
      totalDays: 65,
      progressPercent: 54,
      healthStatus: 'Sehat',
      tasks: [
        TaskModel(
          title: 'Penyiraman pagi hari bilas embun',
          subtitle: 'Selesai',
          isCompleted: true,
        ),
        TaskModel(
          title: 'Pasang lampu perangkap ulat malam',
          subtitle: 'Belum selesai',
          isCompleted: false,
        ),
      ],
    ),
    CropModel(
      id: '5',
      name: 'Pakcoy Hidroponik',
      category: 'Fase pembesaran daun',
      imagePath: 'https://images.unsplash.com/photo-1594282484620-df6495d46101?w=300',
      currentDay: 18,
      totalDays: 35,
      progressPercent: 51,
      healthStatus: 'Sehat',
      tasks: [
        TaskModel(
          title: 'Periksa kadar air nutrisi EC 1.200 uS/cm',
          subtitle: 'Selesai',
          isCompleted: true,
        ),
        TaskModel(
          title: 'Pastikan daun bawah tidak terendam air',
          subtitle: 'Belum selesai',
          isCompleted: false,
        ),
      ],
    ),
    CropModel(
      id: '6',
      name: 'Tomat Cherry',
      category: 'Fase berbunga',
      imagePath: 'https://images.unsplash.com/photo-1592924357228-91a4daadcfea?w=300',
      currentDay: 35,
      totalDays: 80,
      progressPercent: 44,
      healthStatus: 'Sehat',
      tasks: [
        TaskModel(
          title: 'Wiwil tunas air liar pada ketiak daun',
          subtitle: 'Selesai',
          isCompleted: true,
        ),
      ],
    ),
  ];

  CropProvider() {
    _loadCrops();
  }

  Future<void> _loadCrops() async {
    final saved = await StorageService.getCrops();
    if (saved != null && saved.isNotEmpty) {
      _crops.clear();
      _crops.addAll(saved);
    } else {
      _crops.clear();
      _crops.addAll(_defaultSeedCrops);
      await StorageService.saveCrops(_crops);
    }
    notifyListeners();
  }

  List<CropModel> get crops => List.unmodifiable(_crops);

  int get totalActiveCrops => _crops.length;

  List<CropModel> filterByType(String type) {
    if (type == 'Semua') return _crops;
    return _crops.where((crop) {
      final name = crop.name.toLowerCase();
      if (type == 'Pangan & Sawah') {
        return name.contains('padi') || name.contains('jagung') || name.contains('singkong');
      } else if (type == 'Hortikultura') {
        return name.contains('cabai') || name.contains('bawang') || name.contains('tomat');
      } else if (type == 'Sayuran & Kebun') {
        return name.contains('pakcoy') || name.contains('selada') || name.contains('kangkung');
      }
      return true;
    }).toList();
  }

  CropModel? getCropById(String id) {
    try {
      return _crops.firstWhere((crop) => crop.id == id);
    } catch (_) {
      return null;
    }
  }

  void addCrop(CropModel crop) {
    _crops.insert(0, crop);
    notifyListeners();
    StorageService.saveCrops(_crops);
  }

  void updateCrop(CropModel updated) {
    final index = _crops.indexWhere((c) => c.id == updated.id);
    if (index != -1) {
      _crops[index] = updated;
      notifyListeners();
      StorageService.saveCrops(_crops);
    }
  }

  void removeCrop(String id) {
    _crops.removeWhere((crop) => crop.id == id);
    notifyListeners();
    StorageService.saveCrops(_crops);
  }

  void toggleTask(String cropId, int taskIndex) {
    final crop = getCropById(cropId);
    if (crop != null && taskIndex >= 0 && taskIndex < crop.tasks.length) {
      final task = crop.tasks[taskIndex];
      task.isCompleted = !task.isCompleted;
      task.subtitle = task.isCompleted ? 'Selesai' : 'Belum selesai';
      notifyListeners();
      StorageService.saveCrops(_crops);
    }
  }
}
