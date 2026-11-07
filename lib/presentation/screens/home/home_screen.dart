import 'package:flutter/material.dart';
import '../../models/crop_model.dart';
import '../../screens/add_crop_bottom_sheet.dart';
import '../../screens/detail_crop_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Data Tanaman Aktif Urban Farming
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
        TaskModel(
          title: 'Periksa kadar air nutrisi / kelembapan',
          subtitle: 'Selesai',
          isCompleted: true,
        ),
        TaskModel(
          title: 'Pastikan daun bawah tidak menyentuh genangan air',
          subtitle: 'Belum selesai',
          isCompleted: false,
        ),
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
        TaskModel(
          title: 'Pengecekan pH air',
          subtitle: 'Selesai',
          isCompleted: true,
        ),
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
        TaskModel(
          title: 'Siram bibit secara berkala',
          subtitle: 'Belum selesai',
          isCompleted: false,
        ),
      ],
    ),
  ];

  void _openAddCropModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => AddCropBottomSheet(
        onCropAdded: (newCrop) {
          setState(() {
            activeCrops.add(newCrop);
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
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
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: const Color(0xFF196B4A),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.eco_rounded, color: Colors.white, size: 24),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'SELAMAT PAGI',
                        style: TextStyle(
                          color: Color(0xFF72827C),
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.2,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'Halo, Petani Urban!',
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
              Container(
                width: 44,
                height: 44,
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
                child: const Icon(Icons.person_outline_rounded, color: Color(0xFF196B4A), size: 22),
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
              mainAxisAlignment: MainAxisAlignment.between,
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
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
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
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: const [
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
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'Peringatan cuaca panas',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 13,
                          color: Color(0xFF883C27),
                        ),
                      ),
                      SizedBox(height: 3),
                      Text(
                        'Risiko tinggi hari ini. Lindungi tomat dan selada dari paparan terik sinar matahari langsung.',
                        style: TextStyle(fontSize: 12, color: Color(0xFFA26250), height: 1.4),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 22),

          // Section Heading: Tanaman Aktif
          Row(
            mainAxisAlignment: MainAxisAlignment.between,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
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
                label: const Text('Tambah', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
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
                        child: Image.network(
                          crop.imagePath,
                          width: 76,
                          height: 76,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Container(
                            width: 76,
                            height: 76,
                            color: const Color(0xFFEAF3E7),
                            child: const Icon(Icons.eco_outlined, color: Color(0xFF196B4A)),
                          ),
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
        ],
      ),
    );
  }
}
