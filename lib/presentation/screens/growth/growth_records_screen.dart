import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../../core/providers/crop_provider.dart';
import '../../../core/providers/growth_record_provider.dart';
import '../../../core/providers/livestock_provider.dart';
import '../../../models/growth_record_model.dart';

class GrowthRecordsScreen extends StatefulWidget {
  const GrowthRecordsScreen({super.key});

  @override
  State<GrowthRecordsScreen> createState() => _GrowthRecordsScreenState();
}

class _GrowthRecordsScreenState extends State<GrowthRecordsScreen> {
  int _selectedFilterIndex = 0;
  final List<String> _filterTabs = ['Semua', 'Tanaman', 'Ternak'];

  ImageProvider _getImageProvider(String path) {
    if (path.startsWith('http://') || path.startsWith('https://')) {
      return NetworkImage(path);
    }
    final file = File(path);
    if (file.existsSync()) {
      return FileImage(file);
    }
    return const NetworkImage('https://images.unsplash.com/photo-1594282484620-df6495d46101?w=400');
  }

  String _formatDate(DateTime dt) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun',
      'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des'
    ];
    final day = dt.day.toString().padLeft(2, '0');
    final month = months[dt.month - 1];
    final year = dt.year;
    final hour = dt.hour.toString().padLeft(2, '0');
    final minute = dt.minute.toString().padLeft(2, '0');
    return '$day $month $year, $hour:$minute';
  }

  void _confirmDelete(BuildContext context, GrowthRecordModel record) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Hapus Catatan Perkembangan'),
        content: Text('Apakah Anda yakin ingin menghapus catatan "${record.entityName}" tertanggal ${_formatDate(record.date)}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Batal'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.red[700]),
            onPressed: () {
              context.read<GrowthRecordProvider>().removeRecord(record.id);
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Catatan perkembangan berhasil dihapus.'),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
  }

  void _openQuickAddModal(BuildContext context) {
    final cropProvider = context.read<CropProvider>();
    final livestockProvider = context.read<LivestockProvider>();

    String selectedType = 'Tanaman';
    String? selectedEntityId;
    String? selectedEntityName;
    String? selectedCategory;
    String? pickedImagePath;
    final noteController = TextEditingController();
    final metricController = TextEditingController();
    final ImagePicker picker = ImagePicker();

    if (cropProvider.crops.isNotEmpty) {
      selectedEntityId = cropProvider.crops.first.id;
      selectedEntityName = cropProvider.crops.first.name;
      selectedCategory = cropProvider.crops.first.category;
      metricController.text = 'Hari ke-${cropProvider.crops.first.currentDay}';
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => StatefulBuilder(
        builder: (modalCtx, setModalState) {
          Future<void> pickImage(ImageSource source) async {
            try {
              final XFile? file = await picker.pickImage(
                source: source,
                maxWidth: 1200,
                maxHeight: 1200,
                imageQuality: 85,
              );
              if (file != null) {
                setModalState(() {
                  pickedImagePath = file.path;
                });
              }
            } catch (e) {
              if (modalCtx.mounted) {
                ScaffoldMessenger.of(modalCtx).showSnackBar(
                  SnackBar(
                    content: Text('Gagal memilih gambar: ${e.toString()}'),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              }
            }
          }

          return Padding(
            padding: EdgeInsets.only(bottom: MediaQuery.of(modalCtx).viewInsets.bottom),
            child: Container(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
              decoration: const BoxDecoration(
                color: Color(0xFFFAFBF7),
                borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          color: const Color(0xFFCCD6D0),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'CATAT PERKEMBANGAN BARU',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF196B4A),
                        letterSpacing: 1.2,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Dokumentasikan Foto & Catatan Harian',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF17352B),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Selector Tipe: Tanaman vs Ternak
                    Row(
                      children: [
                        Expanded(
                          child: ChoiceChip(
                            label: const Center(child: Text('Tanaman')),
                            selected: selectedType == 'Tanaman',
                            onSelected: (val) {
                              if (val) {
                                setModalState(() {
                                  selectedType = 'Tanaman';
                                  if (cropProvider.crops.isNotEmpty) {
                                    final first = cropProvider.crops.first;
                                    selectedEntityId = first.id;
                                    selectedEntityName = first.name;
                                    selectedCategory = first.category;
                                    metricController.text = 'Hari ke-${first.currentDay}';
                                  } else {
                                    selectedEntityId = null;
                                    selectedEntityName = null;
                                    selectedCategory = null;
                                    metricController.clear();
                                  }
                                });
                              }
                            },
                            selectedColor: const Color(0xFFEAF3E7),
                            side: BorderSide(
                              color: selectedType == 'Tanaman' ? const Color(0xFF196B4A) : const Color(0xFFE2E8E3),
                            ),
                            labelStyle: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: selectedType == 'Tanaman' ? const Color(0xFF196B4A) : const Color(0xFF72827C),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: ChoiceChip(
                            label: const Center(child: Text('Ternak')),
                            selected: selectedType == 'Ternak',
                            onSelected: (val) {
                              if (val) {
                                setModalState(() {
                                  selectedType = 'Ternak';
                                  if (livestockProvider.livestock.isNotEmpty) {
                                    final first = livestockProvider.livestock.first;
                                    selectedEntityId = first.id;
                                    selectedEntityName = first.name;
                                    selectedCategory = first.category;
                                    metricController.text = 'Bobot: ${first.currentWeightKg} kg';
                                  } else {
                                    selectedEntityId = null;
                                    selectedEntityName = null;
                                    selectedCategory = null;
                                    metricController.clear();
                                  }
                                });
                              }
                            },
                            selectedColor: const Color(0xFFEAF3E7),
                            side: BorderSide(
                              color: selectedType == 'Ternak' ? const Color(0xFF196B4A) : const Color(0xFFE2E8E3),
                            ),
                            labelStyle: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: selectedType == 'Ternak' ? const Color(0xFF196B4A) : const Color(0xFF72827C),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),

                    // Pilih Entitas Spesifik
                    if (selectedType == 'Tanaman') ...[
                      DropdownButtonFormField<String>(
                        value: selectedEntityId,
                        decoration: InputDecoration(
                          labelText: 'Pilih Tanaman',
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        items: cropProvider.crops.map((c) {
                          return DropdownMenuItem(
                            value: c.id,
                            child: Text(c.name),
                          );
                        }).toList(),
                        onChanged: (val) {
                          if (val != null) {
                            final crop = cropProvider.getCropById(val);
                            if (crop != null) {
                              setModalState(() {
                                selectedEntityId = crop.id;
                                selectedEntityName = crop.name;
                                selectedCategory = crop.category;
                                metricController.text = 'Hari ke-${crop.currentDay}';
                              });
                            }
                          }
                        },
                      ),
                    ] else ...[
                      DropdownButtonFormField<String>(
                        value: selectedEntityId,
                        decoration: InputDecoration(
                          labelText: 'Pilih Hewan Ternak',
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        items: livestockProvider.livestock.map((l) {
                          return DropdownMenuItem(
                            value: l.id,
                            child: Text('${l.name} (${l.tagNumber})'),
                          );
                        }).toList(),
                        onChanged: (val) {
                          if (val != null) {
                            final animal = livestockProvider.getLivestockById(val);
                            if (animal != null) {
                              setModalState(() {
                                selectedEntityId = animal.id;
                                selectedEntityName = animal.name;
                                selectedCategory = animal.category;
                                metricController.text = 'Bobot: ${animal.currentWeightKg} kg';
                              });
                            }
                          }
                        },
                      ),
                    ],
                    const SizedBox(height: 14),

                    // Input Foto Perkembangan
                    if (pickedImagePath != null)
                      Stack(
                        children: [
                          Container(
                            height: 160,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(14),
                              image: DecorationImage(
                                image: FileImage(File(pickedImagePath!)),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Positioned(
                            top: 8,
                            right: 8,
                            child: CircleAvatar(
                              backgroundColor: Colors.black.withValues(alpha: 0.6),
                              radius: 18,
                              child: IconButton(
                                icon: const Icon(Icons.refresh_rounded, color: Colors.white, size: 16),
                                onPressed: () => pickImage(ImageSource.camera),
                              ),
                            ),
                          ),
                        ],
                      )
                    else
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: const Color(0xFFE2E8E3)),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 44,
                              height: 44,
                              decoration: BoxDecoration(
                                color: const Color(0xFFEAF3E7),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(Icons.camera_alt_outlined, color: Color(0xFF196B4A), size: 22),
                            ),
                            const SizedBox(width: 14),
                            const Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Foto Kondisi Terkini',
                                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                                  ),
                                  Text(
                                    'Ambil dokumentasi visual pertumbuhan',
                                    style: TextStyle(fontSize: 11, color: Color(0xFF72827C)),
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.camera_alt, color: Color(0xFF196B4A)),
                              tooltip: 'Buka Kamera',
                              onPressed: () => pickImage(ImageSource.camera),
                            ),
                            IconButton(
                              icon: const Icon(Icons.photo_library, color: Color(0xFF196B4A)),
                              tooltip: 'Pilih dari Galeri',
                              onPressed: () => pickImage(ImageSource.gallery),
                            ),
                          ],
                        ),
                      ),
                    const SizedBox(height: 14),

                    // Metrik Tambahan (Bobot / Hari)
                    TextField(
                      controller: metricController,
                      decoration: InputDecoration(
                        labelText: selectedType == 'Tanaman' ? 'Fase / Umur Hari' : 'Bobot Terkini',
                        hintText: selectedType == 'Tanaman' ? 'Hari ke-35' : 'Bobot: 370 kg',
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Catatan Perkembangan
                    TextField(
                      controller: noteController,
                      maxLines: 3,
                      decoration: InputDecoration(
                        labelText: 'Catatan Perkembangan & Perawatan',
                        hintText: 'Tuliskan kondisi fisik, pertumbuhan daun/akar, nafsu makan ternak, vitamin, atau perlakuan harian...',
                        hintStyle: const TextStyle(fontSize: 12, color: Color(0xFF89948F)),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Tombol Simpan
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          if (selectedEntityName == null || selectedEntityName!.isEmpty) {
                            ScaffoldMessenger.of(modalCtx).showSnackBar(
                              const SnackBar(
                                content: Text('Pilih tanaman atau hewan ternak terlebih dahulu.'),
                                behavior: SnackBarBehavior.floating,
                              ),
                            );
                            return;
                          }

                          final newRecord = GrowthRecordModel(
                            id: DateTime.now().millisecondsSinceEpoch.toString(),
                            entityId: selectedEntityId ?? 'unknown',
                            entityName: selectedEntityName!,
                            entityType: selectedType,
                            category: selectedCategory ?? selectedType,
                            note: noteController.text.trim().isEmpty
                                ? 'Pencatatan perkembangan dan kondisi rutin harian.'
                                : noteController.text.trim(),
                            imagePath: pickedImagePath,
                            date: DateTime.now(),
                            extraMetric: metricController.text.trim().isNotEmpty
                                ? metricController.text.trim()
                                : null,
                          );

                          context.read<GrowthRecordProvider>().addRecord(newRecord);
                          Navigator.pop(modalCtx);

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Catatan perkembangan ${newRecord.entityName} berhasil disimpan!'),
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF196B4A),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          elevation: 2,
                        ),
                        child: const Text(
                          'Simpan Catatan Perkembangan',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final recordProvider = context.watch<GrowthRecordProvider>();
    final currentFilter = _filterTabs[_selectedFilterIndex];
    final filteredRecords = recordProvider.filterByType(currentFilter);

    return Scaffold(
      backgroundColor: const Color(0xFFFAFBF7),
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Navigasi
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back_ios_new, size: 18),
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.white,
                      side: const BorderSide(color: Color(0xFFE2E8E3)),
                    ),
                  ),
                  const Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      child: Text(
                        'Catatan Perkembangan',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => _openQuickAddModal(context),
                    icon: const Icon(Icons.add_a_photo_outlined, size: 20, color: Color(0xFF196B4A)),
                    tooltip: 'Catat Perkembangan Baru',
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.white,
                      side: const BorderSide(color: Color(0xFFE2E8E3)),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),

              // Kartu Ringkasan Statistik Log
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF104B36),
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF104B36).withValues(alpha: 0.15),
                      blurRadius: 14,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'JURNAL PERKEMBANGAN AGL',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFFD3E4DB),
                            letterSpacing: 1.1,
                          ),
                        ),
                        Icon(Icons.auto_stories_rounded, color: Colors.white, size: 18),
                      ],
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Riwayat Harian Kebun & Kandang',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 14),
                    Row(
                      children: [
                        _buildStatChip('Total Log', recordProvider.totalRecords.toString()),
                        const SizedBox(width: 8),
                        _buildStatChip('Tanaman', recordProvider.totalCropRecords.toString()),
                        const SizedBox(width: 8),
                        _buildStatChip('Ternak', recordProvider.totalLivestockRecords.toString()),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Filter Tabs (Semua, Tanaman, Ternak)
              Row(
                children: List.generate(_filterTabs.length, (index) {
                  final isSelected = _selectedFilterIndex == index;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: FilterChip(
                      label: Text(_filterTabs[index]),
                      selected: isSelected,
                      onSelected: (selected) {
                        setState(() => _selectedFilterIndex = index);
                      },
                      showCheckmark: false,
                      backgroundColor: Colors.white,
                      selectedColor: const Color(0xFFEAF3E7),
                      side: BorderSide(
                        color: isSelected ? const Color(0xFF196B4A) : const Color(0xFFE2E8E3),
                      ),
                      labelStyle: TextStyle(
                        fontSize: 12,
                        fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                        color: isSelected ? const Color(0xFF196B4A) : const Color(0xFF72827C),
                      ),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 14),

              // Daftar Catatan Perkembangan
              if (filteredRecords.isEmpty)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: const Color(0xFFE2E8E3)),
                  ),
                  child: Column(
                    children: [
                      const Icon(Icons.photo_library_outlined, size: 48, color: Color(0xFF72827C)),
                      const SizedBox(height: 12),
                      const Text(
                        'Belum ada catatan perkembangan',
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF17352B)),
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        'Ketuk tombol "+ Tambah Catatan" atau tombol kamera di halaman detail tanaman/ternak untuk mulai mencatat.',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 12, color: Color(0xFF72827C)),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton.icon(
                        onPressed: () => _openQuickAddModal(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF196B4A),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        icon: const Icon(Icons.add, size: 16),
                        label: const Text('Buat Catatan Sekarang', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                )
              else
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: filteredRecords.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 14),
                  itemBuilder: (context, index) {
                    final item = filteredRecords[index];
                    final isTanaman = item.entityType == 'Tanaman';

                    return Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color: const Color(0xFFE2E8E3)),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF1E3B2E).withValues(alpha: 0.04),
                            blurRadius: 14,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Header Kartu Catatan
                          Padding(
                            padding: const EdgeInsets.fromLTRB(14, 12, 10, 8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                      decoration: BoxDecoration(
                                        color: isTanaman ? const Color(0xFFEAF3E7) : const Color(0xFFEFF5E9),
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: Row(
                                        children: [
                                          Icon(
                                            isTanaman ? Icons.eco_rounded : Icons.pets_rounded,
                                            size: 13,
                                            color: const Color(0xFF196B4A),
                                          ),
                                          const SizedBox(width: 4),
                                          Text(
                                            item.entityType,
                                            style: const TextStyle(
                                              fontSize: 10.5,
                                              fontWeight: FontWeight.w800,
                                              color: Color(0xFF196B4A),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      _formatDate(item.date),
                                      style: const TextStyle(fontSize: 11, color: Color(0xFF72827C)),
                                    ),
                                  ],
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete_outline_rounded, size: 18, color: Color(0xFFD32F2F)),
                                  tooltip: 'Hapus Catatan',
                                  onPressed: () => _confirmDelete(context, item),
                                ),
                              ],
                            ),
                          ),

                          // Identitas Entitas & Metrik
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 14),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item.entityName,
                                        style: const TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w800,
                                          color: Color(0xFF17352B),
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        item.category,
                                        style: const TextStyle(fontSize: 11, color: Color(0xFF72827C)),
                                      ),
                                    ],
                                  ),
                                ),
                                if (item.extraMetric != null && item.extraMetric!.isNotEmpty)
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF196B4A).withValues(alpha: 0.08),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Text(
                                      item.extraMetric!,
                                      style: const TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF196B4A),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 10),

                          // Gambar Foto Perkembangan (Jika ada)
                          if (item.imagePath != null && item.imagePath!.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 14),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Container(
                                  height: 200,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFEAF3E7),
                                    image: DecorationImage(
                                      image: _getImageProvider(item.imagePath!),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                            ),

                          // Kotak Teks Catatan
                          Padding(
                            padding: const EdgeInsets.all(14),
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF7FAF4),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: const Color(0xFFE4ECE2)),
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Icon(Icons.format_quote_rounded, size: 18, color: Color(0xFF196B4A)),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      item.note,
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Color(0xFF2C3E35),
                                        height: 1.45,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openQuickAddModal(context),
        backgroundColor: const Color(0xFF196B4A),
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add_a_photo_rounded, size: 18),
        label: const Text('Catat Perkembangan', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12.5)),
      ),
    );
  }

  Widget _buildStatChip(String title, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '$title: ',
            style: const TextStyle(fontSize: 10, color: Color(0xFFD3E4DB)),
          ),
          Text(
            value,
            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ],
      ),
    );
  }
}

