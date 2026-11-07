import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/providers/livestock_provider.dart';
import '../../../models/livestock_model.dart';

class PestScreen extends StatefulWidget {
  const PestScreen({super.key});

  @override
  State<PestScreen> createState() => _PestScreenState();
}

class _PestScreenState extends State<PestScreen> {
  // 0: Penyakit Tanaman (Agriculture), 1: Penyakit Hewan Ternak (Livestock)
  int _diseaseSectorIndex = 0;

  // Filter Kategori Tanaman
  int _selectedCategoryIndex = 0;
  final List<String> _categories = [
    'Semua',
    'Hama Padi & Pangan',
    'Hama Hortikultura',
    'Penyakit Jamur & Bakteri',
    'Defisiensi Nutrisi',
  ];

  // Filter Kategori Ternak
  int _selectedLivestockCategoryIndex = 0;
  final List<String> _livestockCategories = [
    'Semua',
    'Ruminansia (Sapi/Kambing)',
    'Unggas (Ayam/Bebek)',
  ];

  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  final List<Map<String, dynamic>> _pestData = [
    {
      'title': 'Wereng Batang Coklat (WBC)',
      'category': 'Hama Padi & Pangan',
      'severity': 'Kritis',
      'affected': 'Padi Sawah (Oryza sativa)',
      'symptoms': 'Rumpun padi menguning kecokelatan cepat seperti terbakar (hopperburn) dan mengering melingkar di tengah sawah.',
      'organicSolution': 'Keringkan sawah berkala (irigasi macak-macak), tanam refugia bunga kertas di pematang, dan semprot agens hayati jamur Beauveria bassiana.',
      'icon': Icons.bug_report_rounded,
    },
    {
      'title': 'Penggerek Batang Padi (Sundep / Beluk)',
      'category': 'Hama Padi & Pangan',
      'severity': 'Tinggi',
      'affected': 'Padi Sawah',
      'symptoms': 'Pucuk mati mengering pada fase vegetatif (sundep) atau malai tegak hampa putih pucat pada fase generatif (beluk).',
      'organicSolution': 'Pasang lampu perangkap malam hari (light trap), pelepasan parasitoid telur Trichogramma, dan semprot Bacillus thuringiensis.',
      'icon': Icons.grass_rounded,
    },
    {
      'title': 'Hawar Daun Bakteri (Kresek)',
      'category': 'Penyakit Jamur & Bakteri',
      'severity': 'Tinggi',
      'affected': 'Padi Sawah',
      'symptoms': 'Garis basah keabuan dari tepi daun meluas menjadi kuning kecokelatan berombak, daun menggulung dan mati.',
      'organicSolution': 'Kurangi pupuk urea berlebih, tingkatkan pupuk Kalium (KCl), dan semprot bakterisida nabati rebusan daun sirih & kunyit.',
      'icon': Icons.coronavirus_outlined,
    },
    {
      'title': 'Antraknosa / Patek (Colletotrichum)',
      'category': 'Hama Hortikultura',
      'severity': 'Kritis',
      'affected': 'Cabai Rawit, Cabai Merah Keriting',
      'symptoms': 'Bercak hitam cekung melingkar pada buah cabai, daging buah membusuk, layu mengering, dan rontok massal.',
      'organicSolution': 'Pangkas dan bakar buah terinfeksi, jaga jarak tanam agar aerasi lancar, kocor agen hayati Trichoderma harzianum di pangkal batang.',
      'icon': Icons.warning_rounded,
    },
    {
      'title': 'Ulat Grayak Jagung (Fall Armyworm)',
      'category': 'Hama Padi & Pangan',
      'severity': 'Tinggi',
      'affected': 'Jagung Hibrida, Jagung Manis',
      'symptoms': 'Pucuk daun jagung tercabik berlubang parah dengan kotoran tebal mirip serbuk gergaji pada corong daun muda.',
      'organicSolution': 'Semprotkan larutan daun tembakau dan biji nimba langsung ke corong pucuk tanaman jagung di sore hari.',
      'icon': Icons.pest_control_rounded,
    },
    {
      'title': 'Ulat Bawang (Spodoptera exigua)',
      'category': 'Hama Hortikultura',
      'severity': 'Tinggi',
      'affected': 'Bawang Merah, Daun Bawang',
      'symptoms': 'Daun bawang terlihat transparan menerawang akibat ulat memakan daging daun dari dalam rongga daun silindris.',
      'organicSolution': 'Pasang feromon seks (Exi Pheromone) dan lampu perangkap kuning (yellow trap) di sekitar pematang bedengan.',
      'icon': Icons.pest_control_outlined,
    },
    {
      'title': 'Kutu Kebul & Thrips',
      'category': 'Hama Hortikultura',
      'severity': 'Tinggi',
      'affected': 'Cabai, Tomat, Sayuran Hijau',
      'symptoms': 'Daun melengkung keriting ke atas, bercak klorosis kekuningan, dan timbul lapisan embun jelaga hitam.',
      'organicSolution': 'Semprot larutan Minyak Neem (5 ml/L air) + 2 tetes sabun cair lembut pada sore hari saat hama aktif.',
      'icon': Icons.pest_control_rounded,
    },
    {
      'title': 'Busuk Akar (Pythium)',
      'category': 'Penyakit Jamur & Bakteri',
      'severity': 'Kritis',
      'affected': 'Selada, Pakcoy Hidroponik',
      'symptoms': 'Akar berubah warna kecokelatan gelap, berlendir rapuh, dan tanaman layu mendadak saat siang terik.',
      'organicSolution': 'Kuras tandon nutrisi, sterilisasi instalasi dengan H2O2 3% (2 ml/L), lalu tingkatkan aerasi pompa oksigen tandon.',
      'icon': Icons.water_drop_outlined,
    },
    {
      'title': 'Defisiensi Kalsium (Tip Burn)',
      'category': 'Defisiensi Nutrisi',
      'severity': 'Sedang',
      'affected': 'Selada Romaine, Kubis, Sawi',
      'symptoms': 'Ujung dan tepi daun muda mengering terbakar kecokelatan serta pertumbuhan tunas baru terhenti.',
      'organicSolution': 'Jaga sirkulasi udara dengan kipas, turunkan suhu kebun (<28°C), dan semprot kalsium nitrat (Ca(NO3)2) foliar.',
      'icon': Icons.warning_amber_rounded,
    },
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Filter Tanaman
    final filteredPlantList = _pestData.where((item) {
      final matchesCategory = _selectedCategoryIndex == 0 ||
          item['category'] == _categories[_selectedCategoryIndex];
      final matchesSearch = _searchQuery.isEmpty ||
          item['title'].toLowerCase().contains(_searchQuery.toLowerCase()) ||
          item['affected'].toLowerCase().contains(_searchQuery.toLowerCase()) ||
          item['symptoms'].toLowerCase().contains(_searchQuery.toLowerCase());
      return matchesCategory && matchesSearch;
    }).toList();

    // Filter Ternak
    final filteredLivestockList = LivestockProvider.diseases.where((item) {
      final matchesCategory = _selectedLivestockCategoryIndex == 0 ||
          item.category == _livestockCategories[_selectedLivestockCategoryIndex];
      final matchesSearch = _searchQuery.isEmpty ||
          item.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          item.latinName.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          item.affected.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          item.symptoms.toLowerCase().contains(_searchQuery.toLowerCase());
      return matchesCategory && matchesSearch;
    }).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFFAFBF7),
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Judul Halaman
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: const Color(0xFF196B4A),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(Icons.pest_control_rounded, color: Colors.white, size: 24),
                      ),
                      const SizedBox(width: 12),
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'KATALOG & DIAGNOSA AGL',
                            style: TextStyle(
                              color: Color(0xFF196B4A),
                              fontSize: 9.5,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 1.0,
                            ),
                          ),
                          SizedBox(height: 2),
                          Text(
                            'Hama & Penyakit',
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
                  IconButton(
                    icon: const Icon(Icons.document_scanner_outlined, color: Color(0xFF196B4A), size: 24),
                    tooltip: 'Pindai AI',
                    onPressed: () => context.push('/scan'),
                  ),
                ],
              ),
              const SizedBox(height: 16),
            // 1. Selector Sektor: Tanaman vs Ternak
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
                      onTap: () => setState(() => _diseaseSectorIndex = 0),
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          color: _diseaseSectorIndex == 0 ? Colors.white : Colors.transparent,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: _diseaseSectorIndex == 0
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
                              color: _diseaseSectorIndex == 0 ? const Color(0xFF196B4A) : const Color(0xFF72827C),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              'Penyakit Tanaman',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: _diseaseSectorIndex == 0 ? FontWeight.w800 : FontWeight.w600,
                                color: _diseaseSectorIndex == 0 ? const Color(0xFF196B4A) : const Color(0xFF72827C),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: InkWell(
                      onTap: () => setState(() => _diseaseSectorIndex = 1),
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          color: _diseaseSectorIndex == 1 ? Colors.white : Colors.transparent,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: _diseaseSectorIndex == 1
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
                              color: _diseaseSectorIndex == 1 ? const Color(0xFF196B4A) : const Color(0xFF72827C),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              'Penyakit Hewan Ternak',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: _diseaseSectorIndex == 1 ? FontWeight.w800 : FontWeight.w600,
                                color: _diseaseSectorIndex == 1 ? const Color(0xFF196B4A) : const Color(0xFF72827C),
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
            const SizedBox(height: 14),

            // 2. Search Input
            TextField(
              controller: _searchController,
              onChanged: (val) {
                setState(() => _searchQuery = val);
              },
              decoration: InputDecoration(
                hintText: _diseaseSectorIndex == 0
                    ? 'Cari hama padi, cabai, bawang, jamur...'
                    : 'Cari penyakit sapi, kambing, PMK, mastitis, antraks, ayam...',
                prefixIcon: const Icon(Icons.search_rounded, size: 20, color: Color(0xFF72827C)),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, size: 18),
                        onPressed: () {
                          _searchController.clear();
                          setState(() => _searchQuery = '');
                        },
                      )
                    : null,
                contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              ),
            ),
            const SizedBox(height: 14),

            // 3. Category Filter Chips
            if (_diseaseSectorIndex == 0)
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: List.generate(_categories.length, (index) {
                    final isSelected = _selectedCategoryIndex == index;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: FilterChip(
                        label: Text(_categories[index]),
                        selected: isSelected,
                        onSelected: (selected) {
                          setState(() => _selectedCategoryIndex = index);
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
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                    );
                  }),
                ),
              )
            else
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: List.generate(_livestockCategories.length, (index) {
                    final isSelected = _selectedLivestockCategoryIndex == index;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: FilterChip(
                        label: Text(_livestockCategories[index]),
                        selected: isSelected,
                        onSelected: (selected) {
                          setState(() => _selectedLivestockCategoryIndex = index);
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
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                    );
                  }),
                ),
              ),
            const SizedBox(height: 18),

            // 4. Live AI Camera Diagnostic Card
            InkWell(
              onTap: () => context.push('/scan'),
              borderRadius: BorderRadius.circular(16),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  color: const Color(0xFFEAF3E7),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFF196B4A)),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: const Color(0xFF196B4A),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.document_scanner_rounded, color: Colors.white, size: 22),
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                'Deteksi Penyakit dengan AI Scanner',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w800,
                                  color: Color(0xFF17352B),
                                ),
                              ),
                              SizedBox(width: 6),
                              Icon(Icons.auto_awesome, color: Color(0xFF196B4A), size: 14),
                            ],
                          ),
                          SizedBox(height: 2),
                          Text(
                            'Arahkan kamera ke daun atau luka ternak untuk diagnosa AI',
                            style: TextStyle(fontSize: 11, color: Color(0xFF72827C)),
                          ),
                        ],
                      ),
                    ),
                    const Icon(Icons.chevron_right_rounded, color: Color(0xFF196B4A), size: 20),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 18),

            // 5. Emergency Diagnostic Advice
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF104B36),
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF104B36).withValues(alpha: 0.15),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      _diseaseSectorIndex == 0 ? Icons.health_and_safety_outlined : Icons.medical_services_outlined,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _diseaseSectorIndex == 0
                              ? 'Prinsip Pencegahan Organik'
                              : 'Biosekuriti & Karantina Ternak',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _diseaseSectorIndex == 0
                              ? 'Pencegahan selalu lebih murah dibanding pengobatan. Jaga kebersihan sirkulasi media tanam.'
                              : 'Segera pisahkan ternak yang bergejala ke kandang isolasi dan lakukan disinfeksi menyeluruh.',
                          style: const TextStyle(fontSize: 11, color: Color(0xFFD3E4DB), height: 1.3),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 22),

            // 6. Section List Header
            Text(
              _diseaseSectorIndex == 0
                  ? 'KATALOG GANGGUAN & SOLUSI TANAMAN'
                  : 'KATALOG PENYAKIT & PENGOBATAN HEWAN TERNAK',
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.0,
                color: Color(0xFF72827C),
              ),
            ),
            const SizedBox(height: 12),

            // 7. Daftar Penyakit
            if (_diseaseSectorIndex == 0)
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: filteredPlantList.length,
                separatorBuilder: (context, index) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  return _buildPestCard(context, filteredPlantList[index]);
                },
              )
            else
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: filteredLivestockList.length,
                separatorBuilder: (context, index) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  return _buildLivestockDiseaseCard(context, filteredLivestockList[index]);
                },
              ),
          ],
        ),
      ),
    ),
  );
  }

  Widget _buildPestCard(BuildContext context, Map<String, dynamic> item) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8E3)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1E3B2E).withValues(alpha: 0.03),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFEAF3E7),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  item['category'].toUpperCase(),
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.5,
                    color: Color(0xFF196B4A),
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: item['severity'] == 'Kritis'
                      ? const Color(0xFFFFEAEA)
                      : const Color(0xFFFFF4EA),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  'Risiko ${item['severity']}',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: item['severity'] == 'Kritis'
                        ? const Color(0xFFBA1A1A)
                        : const Color(0xFFED7148),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            item['title'],
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: Color(0xFF17352B),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Tanaman Rentan: ${item['affected']}',
            style: const TextStyle(fontSize: 11, color: Color(0xFF72827C), fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFF7FAF8),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: const Color(0xFFE9EFEA)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.remove_red_eye_outlined, size: 14, color: Color(0xFF72827C)),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        'Gejala: ${item['symptoms']}',
                        style: const TextStyle(fontSize: 12, color: Color(0xFF4A554E), height: 1.35),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.eco_rounded, size: 14, color: Color(0xFF196B4A)),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        'Solusi Alami: ${item['organicSolution']}',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF17352B),
                          height: 1.35,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLivestockDiseaseCard(BuildContext context, LivestockDiseaseItem disease) {
    Color severityColor = const Color(0xFF196B4A);
    Color severityBg = const Color(0xFFEAF3E7);

    if (disease.severity == 'Kritis') {
      severityColor = const Color(0xFFBA1A1A);
      severityBg = const Color(0xFFFFDAD6);
    } else if (disease.severity == 'Tinggi') {
      severityColor = const Color(0xFFC26D00);
      severityBg = const Color(0xFFFFE0B2);
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8E3)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1E3B2E).withValues(alpha: 0.03),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFF3F6F1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  disease.category.toUpperCase(),
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.5,
                    color: Color(0xFF196B4A),
                  ),
                ),
              ),
              Row(
                children: [
                  if (disease.isZoonosis) ...[
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFEBEE),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Text(
                        'Zoonosis (Menular Manusia)',
                        style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Color(0xFFC62828)),
                      ),
                    ),
                    const SizedBox(width: 6),
                  ],
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: severityBg,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      'Risiko ${disease.severity}',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        color: severityColor,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Text(
                disease.name,
                style: const TextStyle(
                  fontSize: 15.5,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF17352B),
                ),
              ),
              const SizedBox(width: 6),
              Text(
                '(${disease.latinName})',
                style: const TextStyle(fontSize: 11, fontStyle: FontStyle.italic, color: Color(0xFF72827C)),
              ),
            ],
          ),
          const SizedBox(height: 3),
          Text(
            'Ternak Rentan: ${disease.affected}',
            style: const TextStyle(fontSize: 11, color: Color(0xFF196B4A), fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 10),

          // Symptoms
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFFBFBF8),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: const Color(0xFFECEFE8)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.warning_amber_rounded, size: 14, color: Color(0xFFC26D00)),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        'Gejala Klinis: ${disease.symptoms}',
                        style: const TextStyle(fontSize: 11.5, color: Color(0xFF4A554E), height: 1.35),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.medical_services_rounded, size: 14, color: Color(0xFF196B4A)),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        'Pengobatan & Penanganan: ${disease.treatment}',
                        style: const TextStyle(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF17352B),
                          height: 1.35,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.shield_outlined, size: 14, color: Color(0xFF72827C)),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        'Pencegahan: ${disease.prevention}',
                        style: const TextStyle(fontSize: 11, color: Color(0xFF72827C), height: 1.3),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
