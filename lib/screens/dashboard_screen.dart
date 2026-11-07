import 'package:flutter/material.dart';
import '../models/crop_model.dart';
import 'detail_crop_screen.dart';
import 'add_crop_bottom_sheet.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _currentIndex = 0;

  // Data Dummy Sesuai Desain Figma
  final List<CropModel> activeCrops = [
    CropModel(
      id: '1',
      name: 'Pakcoy',
      category: 'Fase pindah tanam',
      imagePath: 'https://images.unsplash.com/photo-1594282484620-df6495d46101?w=300',
      currentDay: 12,
      totalDays: 35,
      progressPercent: 40,
      healthStatus: 'Sehat',
      tasks: [
        TaskModel(title: 'Periksa kadar air nutrisi / kelembapan', subtitle: 'Selesai', isCompleted: true),
        TaskModel(title: 'Pastikan daun bawah tidak menyentuh genangan air', subtitle: 'Belum selesai', isCompleted: false),
      ],
    ),
    CropModel(
      id: '2',
      name: 'Tomat',
      category: 'Fase berbunga',
      imagePath: 'https://images.unsplash.com/photo-1592924357228-91a4daadcfea?w=300',
      currentDay: 35,
      totalDays: 80,
      progressPercent: 50,
      healthStatus: 'Sehat',
      tasks: [
        TaskModel(title: 'Pengecekan pH air', subtitle: 'Selesai', isCompleted: true),
      ],
    ),
    CropModel(
      id: '3',
      name: 'Selada',
      category: 'Fase pembibitan',
      imagePath: 'https://images.unsplash.com/photo-1622206151226-18ca2c4ab4a1?w=300',
      currentDay: 5,
      totalDays: 35,
      progressPercent: 15,
      healthStatus: 'Sehat',
      tasks: [
        TaskModel(title: 'Siram bibit secara berkala', subtitle: 'Belum selesai', isCompleted: false),
      ],
    ),
  ];

  void _openAddCropModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const AddCropBottomSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFBF7),
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header Greeting & Avatar
                  Row(
                    mainAxisAlignment: MainAxisAlignment.between,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 42,
                            height: 42,
                            decoration: BoxDecoration(
                              color: const Color(0xFF196B4A),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(Icons.eco, color: Colors.white, size: 22),
                          ),
                          const SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text(
                                "SELAMAT PAGI",
                                style: TextStyle(
                                  color: Color(0xFF72827C),
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 1.2,
                                ),
                              ),
                              SizedBox(height: 2),
                              Text(
                                "Halo, Petani Urban!",
                                style: TextStyle(
                                  fontFamily: 'Manrope',
                                  fontSize: 20,
                                  fontWeight: FontWeight.w800,
                                  color: Color(0xFF17352B),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                          border: Border.all(color: const Color(0xFFDFE6DA)),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF2C4C36).withOpacity(0.08),
                              blurRadius: 14,
                              offset: const Offset(0, 5),
                            )
                          ],
                        ),
                        child: const Icon(Icons.person_outline, color: Color(0xFF196B4A)),
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
                      borderRadius: BorderRadius.circular(26),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF104B36).withOpacity(0.2),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.between,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 54,
                              height: 54,
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(17),
                              ),
                              child: const Icon(Icons.wb_sunny_rounded, color: Color(0xFFFFE77E), size: 30),
                            ),
                            const SizedBox(width: 14),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                Text(
                                  "31°",
                                  style: TextStyle(
                                    fontFamily: 'Manrope',
                                    fontSize: 36,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                    height: 1,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  "Cerah berawan",
                                  style: TextStyle(fontSize: 12, color: Color(0xFFC7D7CE)),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: const [
                            Row(
                              children: [
                                Icon(Icons.location_on, color: Colors.white, size: 14),
                                SizedBox(width: 4),
                                Text(
                                  "Bandung",
                                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                                ),
                              ],
                            ),
                            SizedBox(height: 4),
                            Text(
                              "Terasa seperti 33°",
                              style: TextStyle(color: Color(0xFFB7C9C0), fontSize: 10),
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
                          width: 34,
                          height: 34,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(Icons.wb_sunny, color: Color(0xFFED7148), size: 18),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text(
                                "Peringatan cuaca panas",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                  color: Color(0xFF883C27),
                                ),
                              ),
                              SizedBox(height: 3),
                              Text(
                                "Risiko tinggi hari ini. Lindungi tomat dan selada dari sinar matahari langsung.",
                                style: TextStyle(fontSize: 11.5, color: Color(0xFFA26250), height: 1.4),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Section Heading: Tanaman Aktif
                  Row(
                    mainAxisAlignment: MainAxisAlignment.between,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            "KEBUN ANDA",
                            style: TextStyle(
                              color: Color(0xFF72827C),
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 1.2,
                            ),
                          ),
                          SizedBox(height: 2),
                          Text(
                            "Tanaman Aktif",
                            style: TextStyle(
                              fontFamily: 'Manrope',
                              fontSize: 21,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF17352B),
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
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        icon: const Icon(Icons.add, size: 16),
                        label: const Text("Tambah", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),

                  // List Kartu Tanaman Aktif
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: activeCrops.length,
                    separatorBuilder: (context, index) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final crop = activeCrops[index];
                      return InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DetailCropScreen(crop: crop),
                            ),
                          );
                        },
                        borderRadius: BorderRadius.circular(19),
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(19),
                            border: Border.all(color: const Color(0xFFE2E8E3)),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF1E3B2E).withOpacity(0.04),
                                blurRadius: 18,
                                offset: const Offset(0, 6),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(14),
                                child: Image.network(
                                  crop.imagePath,
                                  width: 77,
                                  height: 81,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              const SizedBox(width: 13),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.between,
                                      children: [
                                        Text(
                                          crop.name,
                                          style: const TextStyle(
                                            fontFamily: 'Manrope',
                                            fontSize: 16,
                                            fontWeight: FontWeight.w800,
                                            color: Color(0xFF17352B),
                                          ),
                                        ),
                                        Text(
                                          "Hari ${crop.currentDay} dari ${crop.totalDays}",
                                          style: const TextStyle(fontSize: 10.5, color: Color(0xFF72827C)),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 3),
                                    Text(
                                      crop.category,
                                      style: const TextStyle(color: Color(0xFF196B4A), fontSize: 11),
                                    ),
                                    const SizedBox(height: 10),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(10),
                                            child: LinearProgressIndicator(
                                              value: crop.progressPercent / 100,
                                              backgroundColor: const Color(0xFFE8EDE8),
                                              valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF196B4A)),
                                              minHeight: 5,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          "${crop.progressPercent}%",
                                          style: const TextStyle(fontSize: 9, color: Color(0xFF72827C), fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 8),
                              const Icon(Icons.chevron_right, color: Color(0xFF72827C)),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),

            // Bottom Navigation Bar
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 83,
                padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.94),
                  border: const Border(top: BorderSide(color: Color(0xFFE6EBE7))),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildNavItem(0, Icons.home_rounded, "Beranda"),
                    _buildNavItem(1, Icons.pest_control_rounded, "Hama & Rawat"),
                    _buildNavItem(2, Icons.bar_chart_rounded, "Pasar & Hitung"),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label) {
    bool isActive = _currentIndex == index;
    return InkWell(
      onTap: () => setState(() => _currentIndex = index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 34,
            width: 48,
            decoration: BoxDecoration(
              color: isActive ? const Color(0xFFE9F3DF) : Colors.transparent,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icon, color: isActive ? const Color(0xFF196B4A) : const Color(0xFF89948F), size: 20),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              fontWeight: isActive ? FontWeight.w700 : FontWeight.w600,
              color: isActive ? const Color(0xFF196B4A) : const Color(0xFF89948F),
            ),
          ),
        ],
      ),
    );
  }
}
