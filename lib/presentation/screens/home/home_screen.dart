import 'dart:io';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../core/providers/crop_provider.dart';
import '../../../core/providers/livestock_provider.dart';
import '../crop/add_crop_bottom_sheet.dart';
import '../crop/detail_crop_screen.dart';
import '../livestock/add_livestock_bottom_sheet.dart';
import '../livestock/detail_livestock_screen.dart';
import '../profile/profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // 0: Pertanian (Agriculture), 1: Peternakan (Livestock)
  int _mainSectorIndex = 0;

  // Filter Tanaman
  int _selectedTypeIndex = 0;
  final List<String> _cropTypes = [
    'Semua',
    'Pangan & Sawah',
    'Hortikultura',
    'Sayuran & Kebun',
  ];

  // Filter Ternak
  int _selectedLivestockTypeIndex = 0;
  final List<String> _livestockTypes = [
    'Semua',
    'Sapi Potong',
    'Sapi Perah',
    'Kambing / Domba',
    'Ayam Broiler',
  ];

  void _openAddCropModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const AddCropBottomSheet(),
    );
  }

  void _openAddLivestockModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const AddLivestockBottomSheet(),
    );
  }

  Widget _buildEntityImage(
    String imagePath, {
    required double width,
    required double height,
    required IconData fallbackIcon,
  }) {
    if (imagePath.startsWith('http://') || imagePath.startsWith('https://')) {
      return Image.network(
        imagePath,
        width: width,
        height: height,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => Container(
          width: width,
          height: height,
          color: const Color(0xFFEAF3E7),
          child: Icon(fallbackIcon, color: const Color(0xFF196B4A)),
        ),
      );
    }
    final file = File(imagePath);
    if (file.existsSync()) {
      return Image.file(
        file,
        width: width,
        height: height,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => Container(
          width: width,
          height: height,
          color: const Color(0xFFEAF3E7),
          child: Icon(fallbackIcon, color: const Color(0xFF196B4A)),
        ),
      );
    }
    return Container(
      width: width,
      height: height,
      color: const Color(0xFFEAF3E7),
      child: Icon(fallbackIcon, color: const Color(0xFF196B4A)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cropProvider = context.watch<CropProvider>();
    final livestockProvider = context.watch<LivestockProvider>();
    final filteredCrops = cropProvider.filterByType(_cropTypes[_selectedTypeIndex]);
    final filteredLivestock = livestockProvider.filterByCategory(_livestockTypes[_selectedLivestockTypeIndex]);
    return SafeArea(
      bottom: false,
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Greeting & Quick Actions
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Builder(
                      builder: (scaffoldContext) => InkWell(
                        borderRadius: BorderRadius.circular(12),
                        onTap: () => Scaffold.of(scaffoldContext).openDrawer(),
                        child: Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: const Color(0xFF196B4A),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(Icons.menu_rounded, color: Colors.white, size: 24),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'AGL • AGRICULTURE & LIVESTOCK',
                          style: TextStyle(
                            color: Color(0xFF196B4A),
                            fontSize: 9.5,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 1.0,
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          'Halo, Praktisi AGL!',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF17352B),
                            letterSpacing: -0.3,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.document_scanner_outlined, color: Color(0xFF196B4A), size: 22),
                      tooltip: 'Pindai Penyakit (AI)',
                      onPressed: () => context.push('/scan'),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ProfileScreen(),
                          ),
                        );
                      },
                      borderRadius: BorderRadius.circular(22),
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                          border: Border.all(color: const Color(0xFFDFE6DA)),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF2C4C36).withValues(alpha: 0.08),
                              blurRadius: 14,
                              offset: const Offset(0, 5),
                            )
                          ],
                        ),
                        child: const Icon(Icons.person_outline_rounded, color: Color(0xFF196B4A), size: 20),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          const SizedBox(height: 20),

          // Weather Card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              color: const Color(0xFF104B36),
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF104B36).withValues(alpha: 0.2),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      width: 54,
                      height: 54,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Icon(Icons.wb_sunny_rounded, color: Color(0xFFFFE77E), size: 30),
                    ),
                    const SizedBox(width: 14),
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '31°',
                          style: TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                            height: 1,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Cerah berawan',
                          style: TextStyle(fontSize: 12, color: Color(0xFFC7D7CE), fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ],
                ),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.location_on_rounded, color: Colors.white, size: 14),
                        SizedBox(width: 4),
                        Text(
                          'Bandung',
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 13),
                        ),
                      ],
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Terasa seperti 33°',
                      style: TextStyle(color: Color(0xFFB7C9C0), fontSize: 11),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),

          // Alert Card (Peringatan Cuaca Panas)
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF0EA),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFF7D8CB)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.warning_amber_rounded, color: Color(0xFFED7148), size: 20),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Peringatan Suhu Panas & Evaporasi',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 13,
                          color: Color(0xFF883C27),
                        ),
                      ),
                      SizedBox(height: 3),
                      Text(
                        'Indeks suhu tinggi terdeteksi di wilayah Anda. Pastikan kecukupan irigasi dan lindungi bibit muda dari terik matahari langsung.',
                        style: TextStyle(fontSize: 12, color: Color(0xFFA26250), height: 1.4),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),

          // Live AI Disease Detection Banner Card
          InkWell(
            onTap: () => context.push('/scan'),
            borderRadius: BorderRadius.circular(18),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF104B36), Color(0xFF196B4A)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF104B36).withValues(alpha: 0.18),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.18),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Icon(Icons.document_scanner_rounded, color: Colors.white, size: 26),
                  ),
                  const SizedBox(width: 14),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              'Pindai Penyakit Daun',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(width: 6),
                            Icon(Icons.auto_awesome, color: Color(0xFFFFD54F), size: 14),
                          ],
                        ),
                        SizedBox(height: 3),
                        Text(
                          'Buka kamera langsung untuk deteksi hama dan penyakit secara real-time',
                          style: TextStyle(fontSize: 11.5, color: Color(0xFFD6E8DE)),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.camera_alt, color: Color(0xFF104B36), size: 18),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 18),

          // Sektor AGL: Pertanian & Peternakan Switcher
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: const Color(0xFFE8EDE8),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () => setState(() => _mainSectorIndex = 0),
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        color: _mainSectorIndex == 0 ? Colors.white : Colors.transparent,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: _mainSectorIndex == 0
                            ? [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.05),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ]
                            : null,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.eco_rounded,
                            size: 16,
                            color: _mainSectorIndex == 0 ? const Color(0xFF196B4A) : const Color(0xFF72827C),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'Pertanian (Kebun)',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: _mainSectorIndex == 0 ? FontWeight.w800 : FontWeight.w600,
                              color: _mainSectorIndex == 0 ? const Color(0xFF196B4A) : const Color(0xFF72827C),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: InkWell(
                    onTap: () => setState(() => _mainSectorIndex = 1),
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        color: _mainSectorIndex == 1 ? Colors.white : Colors.transparent,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: _mainSectorIndex == 1
                            ? [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.05),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ]
                            : null,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.pets_rounded,
                            size: 16,
                            color: _mainSectorIndex == 1 ? const Color(0xFF196B4A) : const Color(0xFF72827C),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'Peternakan (Kandang)',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: _mainSectorIndex == 1 ? FontWeight.w800 : FontWeight.w600,
                              color: _mainSectorIndex == 1 ? const Color(0xFF196B4A) : const Color(0xFF72827C),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),

          // TAMPILAN SEKTOR PERTANIAN
          if (_mainSectorIndex == 0) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'KEBUN ANDA',
                      style: TextStyle(
                        color: Color(0xFF72827C),
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.2,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'Tanaman Aktif',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF17352B),
                        letterSpacing: -0.3,
                      ),
                    ),
                  ],
                ),
                ElevatedButton.icon(
                  onPressed: _openAddCropModal,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFEAF3E7),
                    foregroundColor: const Color(0xFF196B4A),
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  icon: const Icon(Icons.add_rounded, size: 16),
                  label: const Text('Tambah Tanaman', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Filter Chips Tipe Tanaman
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(_cropTypes.length, (index) {
                  final isSelected = _selectedTypeIndex == index;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: FilterChip(
                      label: Text(_cropTypes[index]),
                      selected: isSelected,
                      onSelected: (selected) {
                        setState(() => _selectedTypeIndex = index);
                      },
                      showCheckmark: false,
                      backgroundColor: Colors.white,
                      selectedColor: const Color(0xFFEAF3E7),
                      side: BorderSide(
                        color: isSelected ? const Color(0xFF196B4A) : const Color(0xFFE2E8E3),
                      ),
                      labelStyle: TextStyle(
                        fontSize: 11.5,
                        fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                        color: isSelected ? const Color(0xFF196B4A) : const Color(0xFF72827C),
                      ),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                  );
                }),
              ),
            ),
            const SizedBox(height: 14),

            // List Tanaman
            if (filteredCrops.isEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: const Color(0xFFE2E8E3)),
                ),
                child: const Column(
                  children: [
                    Icon(Icons.eco_outlined, size: 48, color: Color(0xFF72827C)),
                    SizedBox(height: 12),
                    Text(
                      'Belum ada tanaman di kategori ini',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF17352B)),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Ketuk tombol "+ Tambah" untuk menanam bibit baru.',
                      style: TextStyle(fontSize: 12, color: Color(0xFF72827C)),
                    ),
                  ],
                ),
              )
            else
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: filteredCrops.length,
                separatorBuilder: (context, index) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final crop = filteredCrops[index];
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetailCropScreen(crop: crop),
                        ),
                      );
                    },
                    borderRadius: BorderRadius.circular(18),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color: const Color(0xFFE2E8E3)),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF1E3B2E).withValues(alpha: 0.04),
                            blurRadius: 16,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: _buildEntityImage(
                              crop.imagePath,
                              width: 76,
                              height: 76,
                              fallbackIcon: Icons.eco_outlined,
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      crop.name,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w800,
                                        color: Color(0xFF17352B),
                                      ),
                                    ),
                                    Text(
                                      'Hari ${crop.currentDay} dari ${crop.totalDays}',
                                      style: const TextStyle(fontSize: 11, color: Color(0xFF72827C)),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  crop.category,
                                  style: const TextStyle(color: Color(0xFF196B4A), fontSize: 12, fontWeight: FontWeight.w600),
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  children: [
                                    Expanded(
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(6),
                                        child: LinearProgressIndicator(
                                          value: crop.progressPercent / 100,
                                          backgroundColor: const Color(0xFFE8EDE8),
                                          valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF196B4A)),
                                          minHeight: 6,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      '${crop.progressPercent}%',
                                      style: const TextStyle(
                                        fontSize: 10,
                                        color: Color(0xFF72827C),
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 6),
                          const Icon(Icons.chevron_right_rounded, color: Color(0xFF72827C), size: 20),
                        ],
                      ),
                    ),
                  );
                },
              ),
          ]

          // TAMPILAN SEKTOR PETERNAKAN
          else ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'KANDANG ANDA',
                      style: TextStyle(
                        color: Color(0xFF72827C),
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.2,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'Hewan Ternak Aktif',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF17352B),
                        letterSpacing: -0.3,
                      ),
                    ),
                  ],
                ),
                ElevatedButton.icon(
                  onPressed: _openAddLivestockModal,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFEAF3E7),
                    foregroundColor: const Color(0xFF196B4A),
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  icon: const Icon(Icons.add_rounded, size: 16),
                  label: const Text('Tambah Ternak', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Filter Chips Kategori Ternak
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(_livestockTypes.length, (index) {
                  final isSelected = _selectedLivestockTypeIndex == index;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: FilterChip(
                      label: Text(_livestockTypes[index]),
                      selected: isSelected,
                      onSelected: (selected) {
                        setState(() => _selectedLivestockTypeIndex = index);
                      },
                      showCheckmark: false,
                      backgroundColor: Colors.white,
                      selectedColor: const Color(0xFFEAF3E7),
                      side: BorderSide(
                        color: isSelected ? const Color(0xFF196B4A) : const Color(0xFFE2E8E3),
                      ),
                      labelStyle: TextStyle(
                        fontSize: 11.5,
                        fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                        color: isSelected ? const Color(0xFF196B4A) : const Color(0xFF72827C),
                      ),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                  );
                }),
              ),
            ),
            const SizedBox(height: 14),

            // List Kartu Hewan Ternak Aktif
            if (filteredLivestock.isEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: const Color(0xFFE2E8E3)),
                ),
                child: const Column(
                  children: [
                    Icon(Icons.pets_outlined, size: 48, color: Color(0xFF72827C)),
                    SizedBox(height: 12),
                    Text(
                      'Belum ada hewan ternak di kategori ini',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF17352B)),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Ketuk tombol "+ Tambah Ternak" untuk mencatat populasi kandang.',
                      style: TextStyle(fontSize: 12, color: Color(0xFF72827C)),
                    ),
                  ],
                ),
              )
            else
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: filteredLivestock.length,
                separatorBuilder: (context, index) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final animal = filteredLivestock[index];
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetailLivestockScreen(livestock: animal),
                        ),
                      );
                    },
                    borderRadius: BorderRadius.circular(18),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color: const Color(0xFFE2E8E3)),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF1E3B2E).withValues(alpha: 0.04),
                            blurRadius: 16,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: _buildEntityImage(
                              animal.imagePath,
                              width: 82,
                              height: 82,
                              fallbackIcon: Icons.pets_rounded,
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        animal.name,
                                        style: const TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w800,
                                          color: Color(0xFF17352B),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFEAF3E7),
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Text(
                                        animal.tagNumber,
                                        style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: Color(0xFF196B4A)),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  '${animal.category} • ${animal.breed} (${animal.gender})',
                                  style: const TextStyle(color: Color(0xFF72827C), fontSize: 11),
                                ),
                                const SizedBox(height: 6),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Bobot: ${animal.currentWeightKg.toStringAsFixed(1)} / ${animal.targetWeightKg.toStringAsFixed(0)} kg',
                                      style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Color(0xFF196B4A)),
                                    ),
                                    Text(
                                      'Pakan: ${animal.feedRequirement.concentrateKgDaily} kg',
                                      style: const TextStyle(fontSize: 10.5, color: Color(0xFF56625D)),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 6),
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(6),
                                  child: LinearProgressIndicator(
                                    value: animal.weightProgressPercent / 100,
                                    backgroundColor: const Color(0xFFE8EDE8),
                                    valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF196B4A)),
                                    minHeight: 5,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 6),
                          const Icon(Icons.chevron_right_rounded, color: Color(0xFF72827C), size: 20),
                        ],
                      ),
                    ),
                  );
                },
              ),
          ],
        ],
      ),
    ),
  );
  }
}

