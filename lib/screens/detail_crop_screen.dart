import 'package:flutter/material.dart';
import '../models/crop_model.dart';

class DetailCropScreen extends StatefulWidget {
  final CropModel crop;

  const DetailCropScreen({Key? key, required this.crop}) : super(key: key);

  @override
  State<DetailCropScreen> createState() => _DetailCropScreenState();
}

class _DetailCropScreenState extends State<DetailCropScreen> {
  void _openJournalModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Container(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 30),
          decoration: const BoxDecoration(
            color: Color(0xFFFBFCF8),
            borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 38,
                  height: 4,
                  decoration: BoxDecoration(
                    color: const Color(0xFFCBD3CE),
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
              ),
              const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.between,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        "JURNAL HARIAN",
                        style: TextStyle(color: Color(0xFF72827C), fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1.2),
                      ),
                      SizedBox(height: 2),
                      Text(
                        "Catat Perkembangan",
                        style: TextStyle(fontFamily: 'Manrope', fontSize: 20, fontWeight: FontWeight.w800, color: Color(0xFF17352B)),
                      ),
                    ],
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close, color: Color(0xFF17352B)),
                    style: IconButton.styleFrom(backgroundColor: Colors.white, border: Border.all(color: const Color(0xFFE2E8E3))),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              // Kotak Unggah Foto
              Container(
                width: double.infinity,
                height: 120,
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xFFB8C7BD), style: BorderStyle.solid),
                  borderRadius: BorderRadius.circular(18),
                  color: const Color(0xFFF5F8F1),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.camera_alt_outlined, color: Color(0xFF196B4A), size: 28),
                    SizedBox(height: 6),
                    Text("Tambahkan foto tanaman", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF196B4A))),
                    SizedBox(height: 2),
                    Text("Ketuk untuk memilih dari perangkat", style: TextStyle(fontSize: 10, color: Color(0xFF72827C))),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              TextField(
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: "Bagaimana kondisi tanaman Anda hari ini?",
                  hintStyle: const TextStyle(fontSize: 12, color: Color(0xFF89948F)),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: const BorderSide(color: Color(0xFFE2E8E3))),
                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: const BorderSide(color: Color(0xFFE2E8E3))),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Perkembangan berhasil disimpan!")),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF196B4A),
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    elevation: 5,
                  ),
                  child: const Text("Simpan perkembangan", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFBF7),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.between,
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.arrow_back_ios_new, size: 18),
                      style: IconButton.styleFrom(
                        backgroundColor: Colors.white,
                        border: Border.all(color: const Color(0xFFE2E8E3)),
                      ),
                    ),
                    Text(
                      "Detail ${widget.crop.name}",
                      style: const TextStyle(fontFamily: 'Manrope', fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.bar_chart, size: 18),
                      style: IconButton.styleFrom(
                        backgroundColor: Colors.white,
                        border: Border.all(color: const Color(0xFFE2E8E3)),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 6),

              // Hero Image & Banner info
              Container(
                height: 275,
                margin: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(26),
                  image: DecorationImage(
                    image: NetworkImage(widget.crop.imagePath),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(26),
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
                      const Text(
                        "TANAMAN ANDA",
                        style: TextStyle(color: Color(0xFFDCEAC7), fontSize: 9, fontWeight: FontWeight.bold, letterSpacing: 1.5),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        widget.crop.name,
                        style: const TextStyle(fontFamily: 'Manrope', fontSize: 28, fontWeight: FontWeight.w800, color: Colors.white),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.18),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text("Hari ke-${widget.crop.currentDay}", style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                            decoration: BoxDecoration(
                              color: const Color(0xFFE9F6CC),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              children: [
                                Container(width: 6, height: 6, decoration: const BoxDecoration(color: Color(0xFF53A15C), shape: BoxShape.circle)),
                                const SizedBox(width: 5),
                                Text(widget.crop.healthStatus, style: const TextStyle(color: Color(0xFF21583E), fontSize: 10, fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),

              // Task List Content
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.between,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text("RUTINITAS HARIAN", style: TextStyle(color: Color(0xFF72827C), fontSize: 10, fontWeight: FontWeight.bold)),
                            SizedBox(height: 2),
                            Text("Tugas Hari Ini", style: TextStyle(fontFamily: 'Manrope', fontSize: 18, fontWeight: FontWeight.w800)),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(color: const Color(0xFFE9F3DF), borderRadius: BorderRadius.circular(20)),
                          child: const Text("1/2", style: TextStyle(color: Color(0xFF196B4A), fontSize: 11, fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: widget.crop.tasks.length,
                      separatorBuilder: (context, index) => const SizedBox(height: 10),
                      itemBuilder: (context, index) {
                        final task = widget.crop.tasks[index];
                        return InkWell(
                          onTap: () {
                            setState(() {
                              task.isCompleted = !task.isCompleted;
                              task.subtitle = task.isCompleted ? "Selesai" : "Belum selesai";
                            });
                          },
                          borderRadius: BorderRadius.circular(15),
                          child: Container(
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(color: const Color(0xFFE2E8E3)),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 24,
                                  height: 24,
                                  decoration: BoxDecoration(
                                    color: task.isCompleted ? const Color(0xFF196B4A) : Colors.transparent,
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(color: task.isCompleted ? const Color(0xFF196B4A) : const Color(0xFFCCD6D0), width: 1.5),
                                  ),
                                  child: task.isCompleted ? const Icon(Icons.check, size: 16, color: Colors.white) : null,
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        task.title,
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                          decoration: task.isCompleted ? TextDecoration.lineThrough : null,
                                          color: task.isCompleted ? const Color(0xFF87938E) : const Color(0xFF17352B),
                                        ),
                                      ),
                                      const SizedBox(height: 3),
                                      Text(task.subtitle, style: const TextStyle(fontSize: 10, color: Color(0xFF72827C))),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 20),

                    // Tip Card
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEFF4DA),
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color: const Color(0xFFE0E8BD)),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: const Color(0xFFDFF09D),
                              borderRadius: BorderRadius.circular(13),
                            ),
                            child: const Icon(Icons.eco, color: Color(0xFF637C1D), size: 20),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                Text("Tips ahli hari ini", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF526921))),
                                SizedBox(height: 4),
                                Text(
                                  "Pertahankan pH nutrisi sekitar 5,5 - 6,5 agar penyerapan akar pakcoy optimal.",
                                  style: TextStyle(fontSize: 11.5, color: Color(0xFF697255), height: 1.4),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Tombol Aksi Catat Perkembangan
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: _openJournalModal,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF104B36),
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                          elevation: 6,
                        ),
                        icon: const Icon(Icons.camera_alt_outlined, color: Colors.white, size: 18),
                        label: const Text("Catat perkembangan hari ini", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
