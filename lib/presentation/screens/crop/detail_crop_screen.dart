import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../../core/providers/crop_provider.dart';
import '../../../models/crop_model.dart';
import 'add_crop_bottom_sheet.dart';

class DetailCropScreen extends StatefulWidget {
  final CropModel crop;

  const DetailCropScreen({super.key, required this.crop});

  @override
  State<DetailCropScreen> createState() => _DetailCropScreenState();
}

class _DetailCropScreenState extends State<DetailCropScreen> {
  late final TextEditingController _journalNoteController;

  @override
  void initState() {
    super.initState();
    _journalNoteController = TextEditingController();
  }

  @override
  void dispose() {
    _journalNoteController.dispose();
    super.dispose();
  }

  String _getExpertTip(String cropName) {
    final lower = cropName.toLowerCase();
    if (lower.contains('padi')) {
      return 'Jaga ketinggian air macak-macak pada fase pembungaan dan lakukan pengeringan berkala (intermittent) untuk memperkuat perakaran serta mencegah wereng coklat.';
    } else if (lower.contains('cabai') || lower.contains('cabe')) {
      return 'Semprot pupuk kalsium-boron menjelang pembungaan untuk mencegah rontok bunga dan pastikan drainase bedengan lancar guna hindari antraknosa (patek).';
    } else if (lower.contains('jagung')) {
      return 'Lakukan pemupukan susulan kedua di umur 30-35 hari dan periksa pucuk daun secara berkala dari serangan ulat grayak jagung (FAW).';
    } else if (lower.contains('bawang')) {
      return 'Lakukan penyiraman rutin di pagi hari sebelum terik matahari untuk membersihkan embun jelaga dan pasang perangkap lampu guna memantau ulat grayak.';
    } else if (lower.contains('tomat')) {
      return 'Lakukan pewiwilan (pemangkasan tunas air liar) dan ikat batang tanaman ke ajir bambu agar sirkulasi udara optimal dan buah tidak menyentuh tanah.';
    }
    return 'Pertahankan nutrisi dan kelembapan media tanam optimal agar penyerapan nutrisi akar $cropName tetap prima hingga masa panen.';
  }

  void _openJournalModal() {
    String? pickedImagePath;
    final ImagePicker picker = ImagePicker();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (modalContext) => StatefulBuilder(
        builder: (context, setModalState) {
          Future<void> pickJournalImage(ImageSource source) async {
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
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Gagal mengambil gambar: ${e.toString()}'),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              }
            }
          }

          return Padding(
            padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Container(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 30),
              decoration: const BoxDecoration(
                color: Color(0xFFFBFCF8),
                borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
              ),
              child: SingleChildScrollView(
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
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'JURNAL PERKEMBANGAN TANAMAN',
                              style: TextStyle(
                                color: Color(0xFF196B4A),
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.2,
                              ),
                            ),
                            SizedBox(height: 2),
                            Text(
                              'Catat Perkembangan',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w800,
                                color: Color(0xFF17352B),
                              ),
                            ),
                          ],
                        ),
                        IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(Icons.close, color: Color(0xFF17352B)),
                          style: IconButton.styleFrom(
                            backgroundColor: Colors.white,
                            side: const BorderSide(color: Color(0xFFE2E8E3)),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Area Foto Perkembangan Real-Time
                    if (pickedImagePath != null && File(pickedImagePath!).existsSync())
                      Container(
                        height: 180,
                        width: double.infinity,
                        margin: const EdgeInsets.only(bottom: 14),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(color: const Color(0xFFB8C7BD)),
                          image: DecorationImage(
                            image: FileImage(File(pickedImagePath!)),
                            fit: BoxFit.cover,
                          ),
                        ),
                        alignment: Alignment.topRight,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: CircleAvatar(
                            backgroundColor: Colors.black.withValues(alpha: 0.6),
                            child: IconButton(
                              icon: const Icon(Icons.refresh_rounded, color: Colors.white, size: 20),
                              tooltip: 'Ganti Foto',
                              onPressed: () => pickJournalImage(ImageSource.camera),
                            ),
                          ),
                        ),
                      )
                    else
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                        decoration: BoxDecoration(
                          border: Border.all(color: const Color(0xFFB8C7BD), style: BorderStyle.solid),
                          borderRadius: BorderRadius.circular(18),
                          color: const Color(0xFFF5F8F1),
                        ),
                        child: Column(
                          children: [
                            const Icon(Icons.camera_alt_outlined, color: Color(0xFF196B4A), size: 32),
                            const SizedBox(height: 8),
                            const Text(
                              'Ambil Foto Perkembangan Tanaman',
                              style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF17352B)),
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              'Dokumentasikan kondisi daun, batang, atau buah secara berkala',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 11, color: Color(0xFF72827C)),
                            ),
                            const SizedBox(height: 14),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ElevatedButton.icon(
                                  onPressed: () => pickJournalImage(ImageSource.camera),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF196B4A),
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                  ),
                                  icon: const Icon(Icons.camera_alt_rounded, size: 16),
                                  label: const Text('Kamera', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
                                ),
                                const SizedBox(width: 10),
                                OutlinedButton.icon(
                                  onPressed: () => pickJournalImage(ImageSource.gallery),
                                  style: OutlinedButton.styleFrom(
                                    side: const BorderSide(color: Color(0xFF196B4A)),
                                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                  ),
                                  icon: const Icon(Icons.photo_library_outlined, size: 16, color: Color(0xFF196B4A)),
                                  label: const Text('Galeri', style: TextStyle(fontSize: 12, color: Color(0xFF196B4A), fontWeight: FontWeight.w700)),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                    const SizedBox(height: 14),
                    TextField(
                      controller: _journalNoteController,
                      maxLines: 3,
                      decoration: InputDecoration(
                        hintText: 'Tuliskan catatan pertumbuhan, tinggi tanaman, warna daun, atau pupuk yang diberikan hari ini...',
                        hintStyle: const TextStyle(fontSize: 12, color: Color(0xFF89948F), height: 1.4),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: const BorderSide(color: Color(0xFFE2E8E3)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: const BorderSide(color: Color(0xFFE2E8E3)),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          _journalNoteController.clear();
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Catatan perkembangan dan foto tanaman berhasil disimpan ke jurnal!'),
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF196B4A),
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                          elevation: 4,
                        ),
                        child: const Text(
                          'Simpan Catatan Perkembangan',
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
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

  void _confirmDelete(BuildContext context, CropModel crop) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Hapus Tanaman'),
        content: Text('Apakah Anda yakin ingin menghapus "${crop.name}" dari kebun?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Batal'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.red[700]),
            onPressed: () {
              context.read<CropProvider>().removeCrop(crop.id);
              Navigator.pop(ctx); // Close dialog
              Navigator.pop(context); // Back to HomeScreen
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('${crop.name} berhasil dihapus dari kebun.'),
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

  void _openEditModal(BuildContext context, CropModel crop) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => AddCropBottomSheet(initialCrop: crop),
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
    return const NetworkImage('https://images.unsplash.com/photo-1594282484620-df6495d46101?w=300');
  }

  @override
  Widget build(BuildContext context) {
    final cropProvider = context.watch<CropProvider>();
    final currentCrop = cropProvider.getCropById(widget.crop.id) ?? widget.crop;

    final completedTasks = currentCrop.tasks.where((t) => t.isCompleted).length;
    final totalTasks = currentCrop.tasks.length;

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
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Text(
                          'Detail ${currentCrop.name}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          onPressed: () => _openEditModal(context, currentCrop),
                          tooltip: 'Edit Tanaman',
                          icon: const Icon(Icons.edit_outlined, size: 19, color: Color(0xFF196B4A)),
                          style: IconButton.styleFrom(
                            backgroundColor: Colors.white,
                            side: const BorderSide(color: Color(0xFFE2E8E3)),
                          ),
                        ),
                        const SizedBox(width: 6),
                        IconButton(
                          onPressed: () => _confirmDelete(context, currentCrop),
                          tooltip: 'Hapus Tanaman',
                          icon: const Icon(Icons.delete_outline_rounded, size: 19, color: Colors.redAccent),
                          style: IconButton.styleFrom(
                            backgroundColor: Colors.white,
                            side: const BorderSide(color: Color(0xFFE2E8E3)),
                          ),
                        ),
                      ],
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
                    image: _getImageProvider(currentCrop.imagePath),
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
                        'TANAMAN ANDA',
                        style: TextStyle(color: Color(0xFFDCEAC7), fontSize: 9, fontWeight: FontWeight.bold, letterSpacing: 1.5),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        currentCrop.name,
                        style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w800, color: Colors.white),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.18),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              'Hari ke-${currentCrop.currentDay}',
                              style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                            ),
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
                                Container(
                                  width: 6,
                                  height: 6,
                                  decoration: const BoxDecoration(color: Color(0xFF53A15C), shape: BoxShape.circle),
                                ),
                                const SizedBox(width: 5),
                                Text(
                                  currentCrop.healthStatus,
                                  style: const TextStyle(color: Color(0xFF21583E), fontSize: 10, fontWeight: FontWeight.bold),
                                ),
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
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('RUTINITAS HARIAN', style: TextStyle(color: Color(0xFF72827C), fontSize: 10, fontWeight: FontWeight.bold)),
                            SizedBox(height: 2),
                            Text('Tugas Hari Ini', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE9F3DF),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            '$completedTasks/$totalTasks',
                            style: const TextStyle(
                              color: Color(0xFF196B4A),
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: currentCrop.tasks.length,
                      separatorBuilder: (context, index) => const SizedBox(height: 10),
                      itemBuilder: (context, index) {
                        final task = currentCrop.tasks[index];
                        return InkWell(
                          onTap: () {
                            context.read<CropProvider>().toggleTask(currentCrop.id, index);
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
                                    border: Border.all(
                                      color: task.isCompleted ? const Color(0xFF196B4A) : const Color(0xFFCCD6D0),
                                      width: 1.5,
                                    ),
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
                              children: [
                                const Text('Tips ahli hari ini', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF526921))),
                                const SizedBox(height: 4),
                                Text(
                                  _getExpertTip(currentCrop.name),
                                  style: const TextStyle(fontSize: 11.5, color: Color(0xFF697255), height: 1.4),
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
                        label: const Text(
                          'Catat Perkembangan Tanaman',
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                        ),
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

