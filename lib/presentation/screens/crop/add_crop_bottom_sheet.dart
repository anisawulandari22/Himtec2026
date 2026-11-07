import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/providers/crop_provider.dart';
import '../../../models/crop_model.dart';

class AddCropBottomSheet extends StatefulWidget {
  final Function(CropModel)? onCropAdded;

  const AddCropBottomSheet({super.key, this.onCropAdded});

  @override
  State<AddCropBottomSheet> createState() => _AddCropBottomSheetState();
}

class _AddCropBottomSheetState extends State<AddCropBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _categoryController = TextEditingController(text: 'Fase pindah tanam');
  final _totalDaysController = TextEditingController(text: '30');
  String _selectedImage = 'https://images.unsplash.com/photo-1594282484620-df6495d46101?w=300';
  String _initialTask = 'Pemberian pupuk dan nutrisi awal';

  final List<Map<String, dynamic>> _cropPresets = [
    {
      'name': 'Padi Inpari 32',
      'phase': 'Fase vegetatif / anakan',
      'days': 115,
      'image': 'https://images.unsplash.com/photo-1536657464919-892534f60d6e?w=400',
      'task': 'Pengaturan irigasi macak-macak & pemupukan urea susulan',
    },
    {
      'name': 'Cabai Rawit Merah',
      'phase': 'Fase pindah tanam',
      'days': 100,
      'image': 'https://images.unsplash.com/photo-1588252303782-cb80119abd6d?w=400',
      'task': 'Pemasangan mulsa plastik & semprot fungisida nabati',
    },
    {
      'name': 'Jagung Hibrida',
      'phase': 'Fase vegetatif',
      'days': 90,
      'image': 'https://images.unsplash.com/photo-1551754655-cd27e38d2076?w=400',
      'task': 'Pembumbunan tanah akar & cek hama ulat FAW',
    },
    {
      'name': 'Bawang Merah',
      'phase': 'Fase pembentukan umbi',
      'days': 65,
      'image': 'https://images.unsplash.com/photo-1618512496248-a07fe83aa8cb?w=400',
      'task': 'Penyiraman pagi hari & pengecekan daun dari embun ungu',
    },
    {
      'name': 'Pakcoy Hidroponik',
      'phase': 'Fase pembesaran daun',
      'days': 35,
      'image': 'https://images.unsplash.com/photo-1594282484620-df6495d46101?w=300',
      'task': 'Kontrol EC nutrisi 1.200 uS/cm & suhu tandon',
    },
    {
      'name': 'Tomat Sayur',
      'phase': 'Fase berbunga',
      'days': 80,
      'image': 'https://images.unsplash.com/photo-1592924357228-91a4daadcfea?w=300',
      'task': 'Pengikatan ajir bambu & pemangkasan tunas air',
    },
  ];

  void _selectPreset(Map<String, dynamic> preset) {
    setState(() {
      _nameController.text = preset['name'];
      _categoryController.text = preset['phase'];
      _totalDaysController.text = preset['days'].toString();
      _selectedImage = preset['image'];
      _initialTask = preset['task'];
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _categoryController.dispose();
    _totalDaysController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final newCrop = CropModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: _nameController.text.trim(),
        category: _categoryController.text.trim(),
        imagePath: _selectedImage,
        currentDay: 1,
        totalDays: int.tryParse(_totalDaysController.text.trim()) ?? 30,
        progressPercent: 5,
        healthStatus: 'Sehat',
        tasks: [
          TaskModel(
            title: _initialTask,
            subtitle: 'Tahap pertama',
            isCompleted: false,
          ),
        ],
      );

      // Save to centralized CropProvider
      context.read<CropProvider>().addCrop(newCrop);

      widget.onCropAdded?.call(newCrop);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 36,
                  height: 4,
                  decoration: BoxDecoration(
                    color: colorScheme.outlineVariant,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Tambah Tanaman Baru',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 12),
              // Preset Cepat Komoditas Nusantara
              Text(
                'PILIH TEMPLATE TANAMAN CEPAT',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: colorScheme.onSurfaceVariant,
                  letterSpacing: 1.0,
                ),
              ),
              const SizedBox(height: 8),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: _cropPresets.map((preset) {
                    final isSelected = _nameController.text == preset['name'];
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ActionChip(
                        label: Text(preset['name']),
                        backgroundColor: isSelected ? const Color(0xFFEAF3E7) : colorScheme.surfaceContainerLow,
                        side: BorderSide(
                          color: isSelected ? const Color(0xFF196B4A) : colorScheme.outlineVariant,
                        ),
                        labelStyle: TextStyle(
                          fontSize: 11,
                          fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                          color: isSelected ? const Color(0xFF196B4A) : colorScheme.onSurface,
                        ),
                        onPressed: () => _selectPreset(preset),
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 14),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Nama Tanaman',
                  hintText: 'Misal: Padi Inpari 32 / Cabai Rawit',
                  prefixIcon: Icon(Icons.eco_outlined),
                ),
                validator: (val) =>
                    (val == null || val.trim().isEmpty) ? 'Nama tanaman wajib diisi' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _categoryController,
                decoration: const InputDecoration(
                  labelText: 'Fase Pertumbuhan',
                  hintText: 'Misal: Fase vegetatif / anakan',
                  prefixIcon: Icon(Icons.category_outlined),
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _totalDaysController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Estimasi Masa Tanam (Hari)',
                  hintText: '115',
                  prefixIcon: Icon(Icons.calendar_today_outlined),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _submit,
                  child: const Text('Simpan ke Kebun / Sawah'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

