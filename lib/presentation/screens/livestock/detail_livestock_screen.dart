import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/providers/livestock_provider.dart';
import '../../../models/livestock_model.dart';

class DetailLivestockScreen extends StatefulWidget {
  final LivestockModel livestock;

  const DetailLivestockScreen({super.key, required this.livestock});

  @override
  State<DetailLivestockScreen> createState() => _DetailLivestockScreenState();
}

class _DetailLivestockScreenState extends State<DetailLivestockScreen> {
  // Simulasi Harga Jual: Hidup vs Sembelih
  late final TextEditingController _livePriceController;
  late final TextEditingController _carcassPercentController;
  late final TextEditingController _meatPriceController;
  late final TextEditingController _byproductPriceController;
  late final TextEditingController _slaughterCostController;

  @override
  void initState() {
    super.initState();
    final isGoat = widget.livestock.category.contains('Kambing') || widget.livestock.category.contains('Domba');
    final isPoultry = widget.livestock.category.contains('Ayam');

    int livePrice = 54000; // Rp/kg hidup sapi
    double carcassPercent = 52.0; // 52%
    int meatPrice = 135000; // Rp/kg daging/karkas
    int byproductPrice = 1800000; // Kulit, jeroan, kepala
    int slaughterCost = 250000; // Biaya RPH

    if (isGoat) {
      livePrice = 85000; // Rp/kg kambing hidup
      carcassPercent = 48.0;
      meatPrice = 145000;
      byproductPrice = 250000;
      slaughterCost = 75000;
    } else if (isPoultry) {
      livePrice = 22000;
      carcassPercent = 72.0;
      meatPrice = 36000;
      byproductPrice = 3000;
      slaughterCost = 2000;
    }

    _livePriceController = TextEditingController(text: livePrice.toString());
    _carcassPercentController = TextEditingController(text: carcassPercent.toString());
    _meatPriceController = TextEditingController(text: meatPrice.toString());
    _byproductPriceController = TextEditingController(text: byproductPrice.toString());
    _slaughterCostController = TextEditingController(text: slaughterCost.toString());
  }

  @override
  void dispose() {
    _livePriceController.dispose();
    _carcassPercentController.dispose();
    _meatPriceController.dispose();
    _byproductPriceController.dispose();
    _slaughterCostController.dispose();
    super.dispose();
  }

  String _formatRupiah(double value) {
    final intVal = value.round();
    return 'Rp ${intVal.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.')}';
  }

  void _showUpdateWeightModal(BuildContext context, LivestockModel item) {
    final weightController = TextEditingController(text: item.currentWeightKg.toString());

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Catat Bobot Ternak'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Penimbangan rutin untuk ${item.name} (${item.tagNumber}):', style: const TextStyle(fontSize: 12)),
            const SizedBox(height: 12),
            TextField(
              controller: weightController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Bobot Baru (kg)',
                suffixText: 'kg',
                isDense: true,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Batal')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF196B4A), foregroundColor: Colors.white),
            onPressed: () {
              final newWeight = double.tryParse(weightController.text);
              if (newWeight != null && newWeight > 0) {
                context.read<LivestockProvider>().updateWeight(item.id, newWeight);
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Bobot ${item.name} berhasil diperbarui menjadi $newWeight kg!'),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              }
            },
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
  }

  ImageProvider _getImageProvider(String path) {
    if (path.startsWith('http://') || path.startsWith('https://')) {
      return NetworkImage(path);
    }
    final file = File(path);
    if (file.existsSync()) {
      return FileImage(file);
    }
    return const NetworkImage('https://images.unsplash.com/photo-1546445317-29f4545e9d53?w=400');
  }

  @override
  Widget build(BuildContext context) {
    final livestockProvider = context.watch<LivestockProvider>();
    final item = livestockProvider.getLivestockById(widget.livestock.id) ?? widget.livestock;

    // Perhitungan Simulasi Jual Hidup vs Sembelih
    final double weight = item.currentWeightKg;
    final double livePricePerKg = double.tryParse(_livePriceController.text) ?? 0;
    final double carcassPercent = double.tryParse(_carcassPercentController.text) ?? 50.0;
    final double meatPricePerKg = double.tryParse(_meatPriceController.text) ?? 0;
    final double byproductRevenue = double.tryParse(_byproductPriceController.text) ?? 0;
    final double slaughterCost = double.tryParse(_slaughterCostController.text) ?? 0;

    // 1. Nilai Jual Langsung (Timbang Hidup)
    final double totalLiveRevenue = weight * livePricePerKg;

    // 2. Nilai Jual Setelah Disembelih
    final double carcassWeightKg = weight * (carcassPercent / 100.0);
    final double meatGrossRevenue = carcassWeightKg * meatPricePerKg;
    final double totalSlaughterRevenue = (meatGrossRevenue + byproductRevenue) - slaughterCost;

    // Selisih Margin
    final double profitDifference = totalSlaughterRevenue - totalLiveRevenue;
    final bool isSlaughterMoreProfitable = profitDifference > 0;

    return Scaffold(
      backgroundColor: const Color(0xFFFAFBF7),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Nav
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
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
                    Text(
                      'Ternak ${item.name}',
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    IconButton(
                      onPressed: () => _showUpdateWeightModal(context, item),
                      icon: const Icon(Icons.scale_rounded, size: 20, color: Color(0xFF196B4A)),
                      tooltip: 'Timbang Bobot',
                      style: IconButton.styleFrom(
                        backgroundColor: Colors.white,
                        side: const BorderSide(color: Color(0xFFE2E8E3)),
                      ),
                    ),
                  ],
                ),
              ),

              // Banner Hero Foto & Tag ID
              Container(
                height: 250,
                margin: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  image: DecorationImage(
                    image: _getImageProvider(item.imagePath),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    gradient: const LinearGradient(
                      colors: [Colors.transparent, Colors.black87],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                  padding: const EdgeInsets.all(20),
                  alignment: Alignment.bottomLeft,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFF196B4A),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          'EARTAG: ${item.tagNumber}',
                          style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w800, letterSpacing: 1.0),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item.name,
                        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: Colors.white),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          _buildHeroBadge('${item.breed} • ${item.gender}', Colors.white24, Colors.white),
                          const SizedBox(width: 8),
                          _buildHeroBadge('${item.ageMonths} Bulan', Colors.white24, Colors.white),
                          const SizedBox(width: 8),
                          _buildHeroBadge(item.healthStatus, const Color(0xFFE9F6CC), const Color(0xFF21583E)),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Metrik Bobot & Target
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: const Color(0xFFE2E8E3)),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('BOBOT SAAT INI', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF72827C))),
                              Text(
                                '${item.currentWeightKg.toStringAsFixed(1)} kg',
                                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: Color(0xFF17352B)),
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              const Text('TARGET BOBOT', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF72827C))),
                              Text(
                                '${item.targetWeightKg.toStringAsFixed(1)} kg',
                                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: Color(0xFF196B4A)),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: LinearProgressIndicator(
                          value: item.weightProgressPercent / 100,
                          backgroundColor: const Color(0xFFE8EDE8),
                          valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF196B4A)),
                          minHeight: 8,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          'Tercapai ${item.weightProgressPercent.toStringAsFixed(0)}% dari target panen',
                          style: const TextStyle(fontSize: 11, color: Color(0xFF72827C), fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 18),

              // Section 1: KEBUTUHAN MAKAN & VITAMIN
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF4F8F1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: const Color(0xFFD6E5D1)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.restaurant_menu_rounded, color: Color(0xFF196B4A), size: 20),
                          SizedBox(width: 8),
                          Text(
                            'KEBUTUHAN PAKAN, AIR & VITAMIN HARIAN',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 0.8,
                              color: Color(0xFF196B4A),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),

                      // Grid Pakan & Air
                      Row(
                        children: [
                          Expanded(
                            child: _buildFeedCard(
                              icon: Icons.grass_rounded,
                              label: 'Hijauan / Rumput',
                              value: '${item.feedRequirement.forageKgDaily} kg/hari',
                              subtext: 'Odot / Gajah / Legum',
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: _buildFeedCard(
                              icon: Icons.grain_rounded,
                              label: 'Konsentrat',
                              value: '${item.feedRequirement.concentrateKgDaily} kg/hari',
                              subtext: 'Protein 14-16% / Dedak',
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: _buildFeedCard(
                              icon: Icons.water_drop_rounded,
                              label: 'Air Bersih',
                              value: '${item.feedRequirement.waterLitersDaily} L/hari',
                              subtext: 'Ad-libitum (bebas)',
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),

                      // Vitamin & Mineral
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFFDFE6DA)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Row(
                              children: [
                                Icon(Icons.medication_liquid_rounded, size: 16, color: Color(0xFFC26D00)),
                                SizedBox(width: 6),
                                Text(
                                  'Vitamin & Mineral Tambahan:',
                                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: Color(0xFF17352B)),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            ...item.feedRequirement.vitaminsAndMinerals.map((vit) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(vertical: 2),
                                child: Row(
                                  children: [
                                    const Icon(Icons.check_circle_outline, size: 14, color: Color(0xFF196B4A)),
                                    const SizedBox(width: 6),
                                    Expanded(
                                      child: Text(vit, style: const TextStyle(fontSize: 11.5, color: Color(0xFF4A554E))),
                                    ),
                                  ],
                                ),
                              );
                            }),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),

                      // Jadwal Pemberian
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.schedule_rounded, size: 14, color: Color(0xFF72827C)),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              'Jadwal: ${item.feedRequirement.feedingSchedule}',
                              style: const TextStyle(fontSize: 11, color: Color(0xFF56625D), fontStyle: FontStyle.italic),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Section 2: KALKULATOR HARGA TERNAK: TIMBANG HIDUP VS DISEMBLIH JADI DAGING
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: const Color(0xFFE2E8E3)),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF196B4A).withValues(alpha: 0.04),
                        blurRadius: 14,
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
                          const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'SIMULASI NILAI JUAL TERNAK',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 1.0,
                                  color: Color(0xFF72827C),
                                ),
                              ),
                              SizedBox(height: 2),
                              Text(
                                'Timbang Hidup vs Sembelih Daging',
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: Color(0xFF17352B)),
                              ),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: isSlaughterMoreProfitable ? const Color(0xFFEAF3E7) : const Color(0xFFFFF3E0),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              isSlaughterMoreProfitable ? 'Sembelih Lebih Untung' : 'Jual Hidup Lebih Untung',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: isSlaughterMoreProfitable ? const Color(0xFF196B4A) : const Color(0xFFC26D00),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),

                      // Input Parameter Simulasi
                      Row(
                        children: [
                          Expanded(
                            child: _buildSimField(
                              label: 'Harga Timbang Hidup/kg',
                              controller: _livePriceController,
                              suffix: 'Rp',
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildSimField(
                              label: 'Rendemen Karkas',
                              controller: _carcassPercentController,
                              suffix: '%',
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: _buildSimField(
                              label: 'Harga Daging Karkas/kg',
                              controller: _meatPriceController,
                              suffix: 'Rp',
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildSimField(
                              label: 'Hasil Sampingan (Kulit/Jeroan)',
                              controller: _byproductPriceController,
                              suffix: 'Rp',
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Hasil Perbandingan Dua Jalur Jual
                      Row(
                        children: [
                          // Jalur A: Jual Timbang Hidup
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF9FAF8),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: const Color(0xFFDFE6DA)),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('A. Jual Timbang Hidup', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF72827C))),
                                  const SizedBox(height: 4),
                                  Text(
                                    _formatRupiah(totalLiveRevenue),
                                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: Color(0xFF17352B)),
                                  ),
                                  const SizedBox(height: 2),
                                  Text('${item.currentWeightKg.toStringAsFixed(0)} kg x ${_formatRupiah(livePricePerKg)}', style: const TextStyle(fontSize: 10, color: Color(0xFF72827C))),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),

                          // Jalur B: Jual Sesudah Sembelih (Karkas & Daging)
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: const Color(0xFFEAF3E7),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: const Color(0xFF196B4A), width: 1.5),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('B. Sembelih Karkas Daging', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF196B4A))),
                                  const SizedBox(height: 4),
                                  Text(
                                    _formatRupiah(totalSlaughterRevenue),
                                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: Color(0xFF104B36)),
                                  ),
                                  const SizedBox(height: 2),
                                  Text('Karkas ${carcassWeightKg.toStringAsFixed(1)} kg + Sampingan', style: const TextStyle(fontSize: 10, color: Color(0xFF196B4A))),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      // Selisih Keuntungan
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                        decoration: BoxDecoration(
                          color: isSlaughterMoreProfitable ? const Color(0xFF104B36) : const Color(0xFFC26D00),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              isSlaughterMoreProfitable ? 'Selisih Tambahan Laba Sembelih:' : 'Selisih Lebih Untung Jual Hidup:',
                              style: const TextStyle(fontSize: 11, color: Colors.white, fontWeight: FontWeight.w600),
                            ),
                            Text(
                              _formatRupiah(profitDifference.abs()),
                              style: const TextStyle(fontSize: 14, color: Colors.white, fontWeight: FontWeight.w800),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Checklist Tugas Harian Ternak
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'TUGAS RUTIN KANDANG HARI INI',
                      style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: Color(0xFF72827C), letterSpacing: 0.8),
                    ),
                    const SizedBox(height: 8),
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: item.tasks.length,
                      separatorBuilder: (context, index) => const SizedBox(height: 8),
                      itemBuilder: (context, index) {
                        final task = item.tasks[index];
                        return InkWell(
                          onTap: () {
                            context.read<LivestockProvider>().toggleTask(item.id, index);
                          },
                          borderRadius: BorderRadius.circular(14),
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(color: const Color(0xFFE2E8E3)),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  task.isCompleted ? Icons.check_circle_rounded : Icons.radio_button_unchecked_rounded,
                                  color: task.isCompleted ? const Color(0xFF196B4A) : const Color(0xFFCBD3CE),
                                  size: 22,
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        task.title,
                                        style: TextStyle(
                                          fontSize: 12.5,
                                          fontWeight: FontWeight.bold,
                                          decoration: task.isCompleted ? TextDecoration.lineThrough : null,
                                          color: task.isCompleted ? const Color(0xFF72827C) : const Color(0xFF17352B),
                                        ),
                                      ),
                                      Text(task.subtitle, style: const TextStyle(fontSize: 11, color: Color(0xFF72827C))),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeroBadge(String label, Color bg, Color text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(color: text, fontSize: 10, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildFeedCard({
    required IconData icon,
    required String label,
    required String value,
    required String subtext,
  }) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFDFE6DA)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: const Color(0xFF196B4A)),
          const SizedBox(height: 6),
          Text(label, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF72827C))),
          const SizedBox(height: 2),
          Text(value, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: Color(0xFF17352B))),
          Text(subtext, style: const TextStyle(fontSize: 9, color: Color(0xFF72827C))),
        ],
      ),
    );
  }

  Widget _buildSimField({
    required String label,
    required TextEditingController controller,
    required String suffix,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 10.5, fontWeight: FontWeight.w600, color: Color(0xFF72827C))),
        const SizedBox(height: 4),
        TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          onChanged: (val) => setState(() {}),
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF17352B)),
          decoration: InputDecoration(
            suffixText: suffix,
            suffixStyle: const TextStyle(fontSize: 11, color: Color(0xFF72827C)),
            contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            isDense: true,
          ),
        ),
      ],
    );
  }
}

