import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/providers/livestock_provider.dart';
import '../../../models/livestock_model.dart';

class AddLivestockBottomSheet extends StatefulWidget {
  const AddLivestockBottomSheet({super.key});

  @override
  State<AddLivestockBottomSheet> createState() => _AddLivestockBottomSheetState();
}

class _AddLivestockBottomSheetState extends State<AddLivestockBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  final _tagController = TextEditingController(text: 'AGL-TR-');
  final _nameController = TextEditingController();
  final _breedController = TextEditingController();
  final _ageController = TextEditingController(text: '12');
  final _currentWeightController = TextEditingController(text: '350');
  final _targetWeightController = TextEditingController(text: '550');
  final _forageController = TextEditingController(text: '35');
  final _concentrateController = TextEditingController(text: '4.5');
  final _waterController = TextEditingController(text: '40');

  String _selectedCategory = 'Sapi Potong';
  String _selectedGender = 'Jantan';
  String _selectedImage = 'https://images.unsplash.com/photo-1546445317-29f4545e9d53?w=400';

  final List<String> _categories = [
    'Sapi Potong',
    'Sapi Perah',
    'Kambing / Domba',
    'Ayam Broiler',
    'Ayam Petelur',
  ];

  final List<Map<String, dynamic>> _presets = [
    {
      'category': 'Sapi Potong',
      'name': 'Sapi Simental / Limosin',
      'breed': 'Simental Cross',
      'weight': 380,
      'target': 600,
      'forage': 40.0,
      'concentrate': 5.5,
      'water': 50.0,
      'image': 'https://images.unsplash.com/photo-1546445317-29f4545e9d53?w=400',
    },
    {
      'category': 'Kambing / Domba',
      'name': 'Kambing Boer / Etawa',
      'breed': 'Boer Cross F1',
      'weight': 30,
      'target': 48,
      'forage': 3.5,
      'concentrate': 0.7,
      'water': 5.0,
      'image': 'https://images.unsplash.com/photo-1524024973431-2ad916746881?w=400',
    },
    {
      'category': 'Kambing / Domba',
      'name': 'Domba Garut Super',
      'breed': 'Domba Garut Ras',
      'weight': 35,
      'target': 60,
      'forage': 4.0,
      'concentrate': 0.9,
      'water': 6.0,
      'image': 'https://images.unsplash.com/photo-1484557052118-f32bd25b45b5?w=400',
    },
    {
      'category': 'Sapi Perah',
      'name': 'Sapi Perah FH',
      'breed': 'Friesian Holstein',
      'weight': 480,
      'target': 550,
      'forage': 48.0,
      'concentrate': 7.5,
      'water': 70.0,
      'image': 'https://images.unsplash.com/photo-1570042225831-d98fa7577f1e?w=400',
    },
    {
      'category': 'Ayam Broiler',
      'name': 'Ayam Broiler Kandang Baru',
      'breed': 'Cobb 500 / Ross',
      'weight': 1,
      'target': 2,
      'forage': 0.0,
      'concentrate': 0.15,
      'water': 0.35,
      'image': 'https://images.unsplash.com/photo-1548550023-2bdb3c5beed7?w=400',
    },
  ];

  void _applyPreset(Map<String, dynamic> preset) {
    setState(() {
      _selectedCategory = preset['category'];
      _nameController.text = preset['name'];
      _breedController.text = preset['breed'];
      _currentWeightController.text = preset['weight'].toString();
      _targetWeightController.text = preset['target'].toString();
      _forageController.text = preset['forage'].toString();
      _concentrateController.text = preset['concentrate'].toString();
      _waterController.text = preset['water'].toString();
      _selectedImage = preset['image'];
      _tagController.text = 'AGL-${preset['category'].substring(0, 2).toUpperCase()}-${DateTime.now().millisecondsSinceEpoch.toString().substring(8)}';
    });
  }

  @override
  void dispose() {
    _tagController.dispose();
    _nameController.dispose();
    _breedController.dispose();
    _ageController.dispose();
    _currentWeightController.dispose();
    _targetWeightController.dispose();
    _forageController.dispose();
    _concentrateController.dispose();
    _waterController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final newLivestock = LivestockModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        tagNumber: _tagController.text.trim(),
        name: _nameController.text.trim(),
        category: _selectedCategory,
        breed: _breedController.text.trim().isEmpty ? _selectedCategory : _breedController.text.trim(),
        gender: _selectedGender,
        ageMonths: int.tryParse(_ageController.text.trim()) ?? 12,
        currentWeightKg: double.tryParse(_currentWeightController.text.trim()) ?? 100,
        targetWeightKg: double.tryParse(_targetWeightController.text.trim()) ?? 200,
        healthStatus: 'Sehat',
        imagePath: _selectedImage,
        feedRequirement: FeedRequirement(
          forageKgDaily: double.tryParse(_forageController.text.trim()) ?? 10,
          concentrateKgDaily: double.tryParse(_concentrateController.text.trim()) ?? 2,
          waterLitersDaily: double.tryParse(_waterController.text.trim()) ?? 20,
          vitaminsAndMinerals: [
            'Premix Mineral & Vitamin Esensial harian',
            'Suplemen vitamin A-D-E larut air',
          ],
          feedingSchedule: 'Pemberian konsentrat pagi & sore, hijauan segar tersedia rutin',
        ),
        tasks: [
          LivestockTaskModel(
            title: 'Pemberian ransum pakan hijauan & konsentrat',
            subtitle: 'Pagi hari',
            isCompleted: false,
          ),
          LivestockTaskModel(
            title: 'Pembersihan sanitasi kotoran kandang',
            subtitle: 'Rutin harian',
            isCompleted: false,
          ),
        ],
      );

      context.read<LivestockProvider>().addLivestock(newLivestock);
      Navigator.pop(context);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${newLivestock.name} (${newLivestock.tagNumber}) berhasil ditambahkan ke kandang!'),
          behavior: SnackBarBehavior.floating,
        ),
      );
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
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.88,
        ),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          children: [
            const SizedBox(height: 12),
            Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: colorScheme.outlineVariant,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 14),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'TAMBAH TERNAK BARU',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: colorScheme.primary,
                          letterSpacing: 1.2,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Input Data Hewan & Pakan',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: colorScheme.onSurface,
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
            ),
            const Divider(height: 16),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Preset Cepat
                      Text(
                        'TEMPLATE CEPAT HEWAN TERNAK NUSANTARA',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: colorScheme.onSurfaceVariant,
                          letterSpacing: 0.8,
                        ),
                      ),
                      const SizedBox(height: 8),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: _presets.map((preset) {
                            return Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: ActionChip(
                                label: Text(preset['name']),
                                backgroundColor: const Color(0xFFEAF3E7),
                                side: const BorderSide(color: Color(0xFF196B4A)),
                                labelStyle: const TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF196B4A),
                                ),
                                onPressed: () => _applyPreset(preset),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Kategori Ternak
                      Text(
                        'Kategori Hewan Ternak',
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: colorScheme.onSurface),
                      ),
                      const SizedBox(height: 6),
                      DropdownButtonFormField<String>(
                        value: _selectedCategory,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        items: _categories.map((cat) {
                          return DropdownMenuItem(value: cat, child: Text(cat, style: const TextStyle(fontSize: 13)));
                        }).toList(),
                        onChanged: (val) {
                          if (val != null) setState(() => _selectedCategory = val);
                        },
                      ),
                      const SizedBox(height: 14),

                      // Tag ID & Nama Ternak
                      Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: TextFormField(
                              controller: _tagController,
                              decoration: const InputDecoration(
                                labelText: 'Tag / Eartag ID',
                                hintText: 'AGL-SP-01',
                                isDense: true,
                              ),
                              validator: (val) => val == null || val.isEmpty ? 'Wajib diisi' : null,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            flex: 3,
                            child: TextFormField(
                              controller: _nameController,
                              decoration: const InputDecoration(
                                labelText: 'Nama / Julukan Ternak',
                                hintText: 'Sapi Bima / Kandang A',
                                isDense: true,
                              ),
                              validator: (val) => val == null || val.isEmpty ? 'Wajib diisi' : null,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),

                      // Ras & Jenis Kelamin
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _breedController,
                              decoration: const InputDecoration(
                                labelText: 'Ras / Breed',
                                hintText: 'Simental Cross',
                                isDense: true,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: DropdownButtonFormField<String>(
                              value: _selectedGender,
                              decoration: const InputDecoration(labelText: 'Kelamin', isDense: true),
                              items: const [
                                DropdownMenuItem(value: 'Jantan', child: Text('Jantan', style: TextStyle(fontSize: 13))),
                                DropdownMenuItem(value: 'Betina', child: Text('Betina', style: TextStyle(fontSize: 13))),
                                DropdownMenuItem(value: 'Campur', child: Text('Campur (Unggas)', style: TextStyle(fontSize: 13))),
                              ],
                              onChanged: (val) {
                                if (val != null) setState(() => _selectedGender = val);
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),

                      // Bobot Saat Ini & Target Bobot
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _currentWeightController,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                labelText: 'Bobot Saat Ini',
                                suffixText: 'kg',
                                isDense: true,
                              ),
                              validator: (val) => val == null || val.isEmpty ? 'Wajib diisi' : null,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: TextFormField(
                              controller: _targetWeightController,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                labelText: 'Target Bobot Panen',
                                suffixText: 'kg',
                                isDense: true,
                              ),
                              validator: (val) => val == null || val.isEmpty ? 'Wajib diisi' : null,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 18),

                      // Section Kebutuhan Pakan & Vitamin
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF7FAF5),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: const Color(0xFFDFE6DA)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: const [
                                Icon(Icons.restaurant_rounded, size: 16, color: Color(0xFF196B4A)),
                                SizedBox(width: 6),
                                Text(
                                  'ESTIMASI KEBUTUHAN PAKAN & AIR HARIAN',
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w800,
                                    color: Color(0xFF196B4A),
                                    letterSpacing: 0.8,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                Expanded(
                                  child: TextFormField(
                                    controller: _forageController,
                                    keyboardType: TextInputType.number,
                                    decoration: const InputDecoration(
                                      labelText: 'Hijauan / Rumput',
                                      suffixText: 'kg/hari',
                                      isDense: true,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: TextFormField(
                                    controller: _concentrateController,
                                    keyboardType: TextInputType.number,
                                    decoration: const InputDecoration(
                                      labelText: 'Konsentrat / Pakan',
                                      suffixText: 'kg/hari',
                                      isDense: true,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            TextFormField(
                              controller: _waterController,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                labelText: 'Kebutuhan Air Minum Bersih',
                                suffixText: 'liter/hari',
                                isDense: true,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),

                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _submit,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF196B4A),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          child: const Text('Simpan ke Data Kandang', style: TextStyle(fontWeight: FontWeight.bold)),
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
    );
  }
}

