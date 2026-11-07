import 'package:flutter/material.dart';
import '../../../models/market_city_model.dart';

class MarketScreen extends StatefulWidget {
  const MarketScreen({super.key});

  @override
  State<MarketScreen> createState() => _MarketScreenState();
}

class _MarketScreenState extends State<MarketScreen> {
  // Kota aktif saat ini (default: Bandung)
  MarketCity _selectedCity = MarketDataRepository.cities[1];

  // Kategori aktif: 'Semua', 'Pertanian', 'Peternakan'
  int _selectedCategoryIndex = 0;
  final List<String> _categoryTabs = [
    'Semua',
    'Pertanian (Agriculture)',
    'Peternakan (Livestock)',
  ];

  // Komoditas aktif
  int _selectedCommodityIndex = 0;

  // Controllers untuk kalkulator panen
  late final TextEditingController _holesController;
  late final TextEditingController _weightController;
  late final TextEditingController _priceController;
  late final TextEditingController _costController;
  double _successRate = 0.90; // 90%

  // Controllers untuk kalkulator ternak: timbang hidup vs sembelih daging
  int _livestockTypeIndex = 0; // 0: Sapi Potong, 1: Kambing / Domba, 2: Ayam Broiler
  late final TextEditingController _lsWeightController;
  late final TextEditingController _lsLivePriceController;
  late final TextEditingController _lsCarcassPercentController;
  late final TextEditingController _lsMeatPriceController;
  late final TextEditingController _lsByproductController;
  late final TextEditingController _lsSlaughterCostController;

  @override
  void initState() {
    super.initState();
    final initialCommodity = MarketDataRepository.commodities[0];
    _holesController = TextEditingController(text: initialCommodity.defaultHolesOrHead.toString());
    _weightController = TextEditingController(text: initialCommodity.defaultWeightGrams.toString());
    _priceController = TextEditingController(
      text: initialCommodity.getPriceForCity(_selectedCity.id).toString(),
    );
    _costController = TextEditingController(text: initialCommodity.defaultCost.toString());

    // Inisialisasi Kalkulator Ternak
    _lsWeightController = TextEditingController(text: '450');
    _lsLivePriceController = TextEditingController(text: '54000');
    _lsCarcassPercentController = TextEditingController(text: '52.0');
    _lsMeatPriceController = TextEditingController(
      text: MarketDataRepository.commodities.firstWhere((c) => c.id == 'daging_sapi').getPriceForCity(_selectedCity.id).toString(),
    );
    _lsByproductController = TextEditingController(text: '1800000');
    _lsSlaughterCostController = TextEditingController(text: '250000');
  }

  @override
  void dispose() {
    _holesController.dispose();
    _weightController.dispose();
    _priceController.dispose();
    _costController.dispose();
    _lsWeightController.dispose();
    _lsLivePriceController.dispose();
    _lsCarcassPercentController.dispose();
    _lsMeatPriceController.dispose();
    _lsByproductController.dispose();
    _lsSlaughterCostController.dispose();
    super.dispose();
  }

  void _onLivestockPresetChanged(int index) {
    setState(() {
      _livestockTypeIndex = index;
      if (index == 0) {
        // Sapi Potong
        _lsWeightController.text = '450';
        _lsLivePriceController.text = '54000';
        _lsCarcassPercentController.text = '52.0';
        _lsMeatPriceController.text = MarketDataRepository.commodities.firstWhere((c) => c.id == 'daging_sapi').getPriceForCity(_selectedCity.id).toString();
        _lsByproductController.text = '1800000';
        _lsSlaughterCostController.text = '250000';
      } else if (index == 1) {
        // Kambing / Domba
        _lsWeightController.text = '40';
        _lsLivePriceController.text = '85000';
        _lsCarcassPercentController.text = '48.0';
        _lsMeatPriceController.text = '145000';
        _lsByproductController.text = '250000';
        _lsSlaughterCostController.text = '75000';
      } else if (index == 2) {
        // Ayam Broiler
        _lsWeightController.text = '2.0';
        _lsLivePriceController.text = '22000';
        _lsCarcassPercentController.text = '72.0';
        _lsMeatPriceController.text = MarketDataRepository.commodities.firstWhere((c) => c.id == 'daging_ayam').getPriceForCity(_selectedCity.id).toString();
        _lsByproductController.text = '3000';
        _lsSlaughterCostController.text = '2000';
      }
    });
  }

  List<CommodityMarketItem> get _filteredCommodities {
    if (_selectedCategoryIndex == 1) {
      return MarketDataRepository.commodities
          .where((item) => item.category == 'Pertanian')
          .toList();
    } else if (_selectedCategoryIndex == 2) {
      return MarketDataRepository.commodities
          .where((item) => item.category == 'Peternakan')
          .toList();
    }
    return MarketDataRepository.commodities;
  }

  CommodityMarketItem get _currentCommodity {
    final list = _filteredCommodities;
    if (_selectedCommodityIndex >= list.length) {
      return list.isNotEmpty ? list[0] : MarketDataRepository.commodities[0];
    }
    return list[_selectedCommodityIndex];
  }

  void _onCityChanged(MarketCity city) {
    setState(() {
      _selectedCity = city;
      // Perbarui harga jual di kalkulator sesuai harga komoditas di kota baru
      final newPrice = _currentCommodity.getPriceForCity(city.id);
      _priceController.text = newPrice.toString();
      _onLivestockPresetChanged(_livestockTypeIndex);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Harga acuan diperbarui untuk wilayah ${city.name} (${city.marketName})'),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _onCommoditySelected(int index) {
    setState(() {
      _selectedCommodityIndex = index;
      final selected = _filteredCommodities[index];
      _holesController.text = selected.defaultHolesOrHead.toString();
      _weightController.text = selected.defaultWeightGrams.toString();
      _priceController.text = selected.getPriceForCity(_selectedCity.id).toString();
      _costController.text = selected.defaultCost.toString();
    });
  }

  void _openCitySelectorModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        String query = '';
        return StatefulBuilder(
          builder: (context, setModalState) {
            final filteredCities = MarketDataRepository.cities.where((city) {
              final q = query.toLowerCase();
              return city.name.toLowerCase().contains(q) ||
                  city.province.toLowerCase().contains(q) ||
                  city.marketName.toLowerCase().contains(q);
            }).toList();

            return Container(
              height: MediaQuery.of(context).size.height * 0.72,
              decoration: const BoxDecoration(
                color: Color(0xFFFAFBF7),
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: Column(
                children: [
                  const SizedBox(height: 12),
                  Container(
                    width: 38,
                    height: 4,
                    decoration: BoxDecoration(
                      color: const Color(0xFFCCD6D0),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'PILIH KOTA & WILAYAH PASAR',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF196B4A),
                                letterSpacing: 1.2,
                              ),
                            ),
                            SizedBox(height: 2),
                            Text(
                              'Harga Komoditas Real-Time',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w800,
                                color: Color(0xFF17352B),
                              ),
                            ),
                          ],
                        ),
                        IconButton(
                          onPressed: () => Navigator.pop(ctx),
                          icon: const Icon(Icons.close),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: TextField(
                      onChanged: (val) {
                        setModalState(() => query = val);
                      },
                      decoration: InputDecoration(
                        hintText: 'Cari kota, provinsi, atau pasar...',
                        prefixIcon: const Icon(Icons.search_rounded, size: 20),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Color(0xFFE2E8E3)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Color(0xFFE2E8E3)),
                        ),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: ListView.separated(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                      itemCount: filteredCities.length,
                      separatorBuilder: (context, index) => const SizedBox(height: 8),
                      itemBuilder: (context, index) {
                        final city = filteredCities[index];
                        final isSelected = city.id == _selectedCity.id;

                        return InkWell(
                          onTap: () {
                            Navigator.pop(ctx);
                            _onCityChanged(city);
                          },
                          borderRadius: BorderRadius.circular(14),
                          child: Container(
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: isSelected ? const Color(0xFFEAF3E7) : Colors.white,
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                color: isSelected ? const Color(0xFF196B4A) : const Color(0xFFE2E8E3),
                                width: isSelected ? 1.5 : 1.0,
                              ),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: isSelected ? const Color(0xFF196B4A) : const Color(0xFFF3F6F1),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Icon(
                                    Icons.location_city_rounded,
                                    color: isSelected ? Colors.white : const Color(0xFF196B4A),
                                    size: 20,
                                  ),
                                ),
                                const SizedBox(width: 14),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            city.name,
                                            style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w800,
                                              color: isSelected ? const Color(0xFF196B4A) : const Color(0xFF17352B),
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          Text(
                                            '• ${city.province}',
                                            style: const TextStyle(fontSize: 12, color: Color(0xFF72827C)),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        city.marketName,
                                        style: const TextStyle(fontSize: 11, color: Color(0xFF56625D)),
                                      ),
                                    ],
                                  ),
                                ),
                                if (isSelected)
                                  const Icon(Icons.check_circle_rounded, color: Color(0xFF196B4A), size: 20),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  double get _totalHarvestKg {
    final holes = double.tryParse(_holesController.text) ?? 0;
    final grams = double.tryParse(_weightController.text) ?? 0;
    return (holes * grams * _successRate) / 1000.0;
  }

  double get _grossRevenue {
    final pricePerKg = double.tryParse(_priceController.text) ?? 0;
    return _totalHarvestKg * pricePerKg;
  }

  double get _netProfit {
    final operationalCost = double.tryParse(_costController.text) ?? 0;
    return _grossRevenue - operationalCost;
  }

  String _formatRupiah(double value) {
    final intVal = value.round();
    return 'Rp ${intVal.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.')}';
  }

  @override
  Widget build(BuildContext context) {
    final commoditiesList = _filteredCommodities;

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
                        child: const Icon(Icons.storefront_rounded, color: Colors.white, size: 24),
                      ),
                      const SizedBox(width: 12),
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'BURSA HARGA KOMODITAS REAL-TIME',
                            style: TextStyle(
                              color: Color(0xFF196B4A),
                              fontSize: 9.5,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 1.0,
                            ),
                          ),
                          SizedBox(height: 2),
                          Text(
                            'Pasar & Simulasi Laba',
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
                ],
              ),
              const SizedBox(height: 16),
            // 1. Selector Kota Interaktif Real-Time
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFDFE6DA)),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF196B4A).withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ],
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
                    child: const Icon(Icons.location_on_rounded, color: Color(0xFF196B4A), size: 24),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Text(
                              'WILAYAH PASAR REAL-TIME',
                              style: TextStyle(
                                fontSize: 9.5,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF72827C),
                                letterSpacing: 1.0,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Container(
                              width: 6,
                              height: 6,
                              decoration: const BoxDecoration(
                                color: Color(0xFF2E7D32),
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 4),
                            const Text(
                              'Live',
                              style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF2E7D32)),
                            ),
                          ],
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '${_selectedCity.name} (${_selectedCity.province})',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF17352B),
                          ),
                        ),
                        Text(
                          _selectedCity.marketName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 11, color: Color(0xFF56625D)),
                        ),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    onPressed: _openCitySelectorModal,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF196B4A),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    child: const Text('Ganti Kota', style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // Horizontal Quick-City Chips (Jakarta, Bandung, Surabaya, Medan, Makassar, Denpasar)
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: MarketDataRepository.cities.take(6).map((city) {
                  final isSelected = city.id == _selectedCity.id;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ActionChip(
                      label: Text(city.name),
                      backgroundColor: isSelected ? const Color(0xFF104B36) : Colors.white,
                      side: BorderSide(
                        color: isSelected ? const Color(0xFF104B36) : const Color(0xFFE2E8E3),
                      ),
                      labelStyle: TextStyle(
                        fontSize: 11,
                        fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                        color: isSelected ? Colors.white : const Color(0xFF17352B),
                      ),
                      onPressed: () => _onCityChanged(city),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 18),

            // 2. Proyeksi Laba Banner Card
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: const Color(0xFF104B36),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF104B36).withValues(alpha: 0.15),
                    blurRadius: 18,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Text(
                            'PROYEKSI LABA BERSIH • ',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 1.2,
                              color: Color(0xFFDCEAC7),
                            ),
                          ),
                          Text(
                            _selectedCity.name.toUpperCase(),
                            style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                              letterSpacing: 1.2,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          'Sukses ${(_successRate * 100).round()}%',
                          style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    _formatRupiah(_netProfit),
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _buildBannerMetric(
                          'Estimasi Total Panen',
                          '${_totalHarvestKg.toStringAsFixed(1)} ${_currentCommodity.unit}',
                        ),
                      ),
                      Container(width: 1, height: 30, color: Colors.white24),
                      Expanded(
                        child: _buildBannerMetric(
                          'Estimasi Omzet (${_selectedCity.name})',
                          _formatRupiah(_grossRevenue),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // 3. Tab Kategori (Semua / Pertanian / Peternakan)
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(_categoryTabs.length, (index) {
                  final isSelected = _selectedCategoryIndex == index;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: FilterChip(
                      label: Text(_categoryTabs[index]),
                      selected: isSelected,
                      onSelected: (val) {
                        setState(() {
                          _selectedCategoryIndex = index;
                          _selectedCommodityIndex = 0;
                          final first = _filteredCommodities.isNotEmpty ? _filteredCommodities[0] : null;
                          if (first != null) {
                            _priceController.text = first.getPriceForCity(_selectedCity.id).toString();
                            _holesController.text = first.defaultHolesOrHead.toString();
                            _weightController.text = first.defaultWeightGrams.toString();
                            _costController.text = first.defaultCost.toString();
                          }
                        });
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
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                  );
                }),
              ),
            ),
            const SizedBox(height: 14),

            // 4. Pilih Komoditas
            Text(
              'PILIH KOMODITAS (HARGA WILAYAH ${_selectedCity.name.toUpperCase()})',
              style: const TextStyle(
                fontSize: 10.5,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.0,
                color: Color(0xFF72827C),
              ),
            ),
            const SizedBox(height: 8),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(commoditiesList.length, (index) {
                  final item = commoditiesList[index];
                  final isSelected = _selectedCommodityIndex == index;
                  final cityPrice = item.getPriceForCity(_selectedCity.id);

                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text('${item.name} (${_formatRupiah(cityPrice.toDouble())})'),
                      selected: isSelected,
                      onSelected: (val) {
                        if (val) _onCommoditySelected(index);
                      },
                      backgroundColor: Colors.white,
                      selectedColor: const Color(0xFFEAF3E7),
                      side: BorderSide(
                        color: isSelected ? const Color(0xFF196B4A) : const Color(0xFFE2E8E3),
                      ),
                      labelStyle: TextStyle(
                        fontSize: 11.5,
                        fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                        color: isSelected ? const Color(0xFF196B4A) : const Color(0xFF17352B),
                      ),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                  );
                }),
              ),
            ),
            const SizedBox(height: 20),

            // 5. Input Parameter Box
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: const Color(0xFFE2E8E3)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'PARAMETER SIMULASI PANEN',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.8,
                          color: Color(0xFF72827C),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEAF3E7),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          _currentCommodity.category,
                          style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF196B4A)),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),

                  Row(
                    children: [
                      Expanded(
                        child: _buildInputField(
                          label: 'Populasi (${_currentCommodity.unitLabel})',
                          controller: _holesController,
                          suffix: 'unit',
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildInputField(
                          label: 'Bobot / Volume per Unit',
                          controller: _weightController,
                          suffix: 'gram',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),

                  Row(
                    children: [
                      Expanded(
                        child: _buildInputField(
                          label: 'Harga Pasar ${_selectedCity.name} / ${_currentCommodity.unit}',
                          controller: _priceController,
                          suffix: 'Rp',
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildInputField(
                          label: 'Total Biaya Operasional / Pakan',
                          controller: _costController,
                          suffix: 'Rp',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Slider Keberhasilan
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Tingkat Keberhasilan Panen:',
                        style: TextStyle(fontSize: 12, color: Color(0xFF4A554E), fontWeight: FontWeight.w600),
                      ),
                      Text(
                        '${(_successRate * 100).round()}%',
                        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: Color(0xFF196B4A)),
                      ),
                    ],
                  ),
                  SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      activeTrackColor: const Color(0xFF196B4A),
                      inactiveTrackColor: const Color(0xFFE2E8E3),
                      thumbColor: const Color(0xFF196B4A),
                      trackHeight: 4,
                    ),
                    child: Slider(
                      value: _successRate,
                      min: 0.50,
                      max: 1.00,
                      divisions: 10,
                      onChanged: (val) {
                        setState(() => _successRate = val);
                      },
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // 5b. Kalkulator Komparasi Ternak: Jual Hidup vs Sembelih Daging Karkas
            _buildLivestockComparisonSection(),
            const SizedBox(height: 24),

            // 6. Daftar Acuan Harga Real-Time Kota Terpilih
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'DAFTAR HARGA PASAR • ${_selectedCity.name.toUpperCase()}',
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.0,
                          color: Color(0xFF72827C),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        _selectedCity.marketName,
                        style: const TextStyle(fontSize: 11, color: Color(0xFF196B4A), fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
                TextButton.icon(
                  onPressed: _openCitySelectorModal,
                  icon: const Icon(Icons.tune_rounded, size: 16, color: Color(0xFF196B4A)),
                  label: const Text('Ganti', style: TextStyle(fontSize: 12, color: Color(0xFF196B4A), fontWeight: FontWeight.bold)),
                ),
              ],
            ),
            const SizedBox(height: 8),

            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFE2E8E3)),
              ),
              child: Column(
                children: commoditiesList.asMap().entries.map((entry) {
                  final index = entry.key;
                  final item = entry.value;
                  final isLast = index == commoditiesList.length - 1;
                  final price = item.getPriceForCity(_selectedCity.id);
                  final trend = item.getTrendForCity(_selectedCity.id);
                  final change = item.getChangeForCity(_selectedCity.id);

                  return Column(
                    children: [
                      _buildMarketPriceRow(
                        item: item,
                        price: price,
                        trend: trend,
                        change: change,
                        onTap: () => _onCommoditySelected(index),
                      ),
                      if (!isLast) const Divider(height: 1, color: Color(0xFFF0F4F1)),
                    ],
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBannerMetric(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 11, color: Color(0xFFD3E4DB)),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: Colors.white),
        ),
      ],
    );
  }

  Widget _buildLivestockComparisonSection() {
    final weight = double.tryParse(_lsWeightController.text) ?? 0;
    final livePrice = double.tryParse(_lsLivePriceController.text) ?? 0;
    final carcassPercent = double.tryParse(_lsCarcassPercentController.text) ?? 0;
    final meatPrice = double.tryParse(_lsMeatPriceController.text) ?? 0;
    final byproduct = double.tryParse(_lsByproductController.text) ?? 0;
    final slaughterCost = double.tryParse(_lsSlaughterCostController.text) ?? 0;

    final liveRevenue = weight * livePrice;
    final carcassWeightKg = weight * (carcassPercent / 100.0);
    final meatRevenue = carcassWeightKg * meatPrice;
    final carcassNetRevenue = meatRevenue + byproduct - slaughterCost;
    final marginDiff = carcassNetRevenue - liveRevenue;
    final bool isSlaughterBetter = marginDiff > 0;

    final presetLabels = ['Sapi Potong', 'Kambing / Domba', 'Ayam Broiler'];

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFDFE6DA)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF196B4A).withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: const Color(0xFFEAF3E7),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.scale_rounded, color: Color(0xFF196B4A), size: 22),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'KALKULATOR PENJUALAN TERNAK',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF196B4A),
                        letterSpacing: 1.0,
                      ),
                    ),
                    const SizedBox(height: 2),
                    const Text(
                      'Timbang Hidup vs Sembelih Daging',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF17352B),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Bandingkan laba bersih penjualan langsung vs karkas daging di ${_selectedCity.name}',
                      style: const TextStyle(fontSize: 11, color: Color(0xFF72827C)),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Preset Chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(presetLabels.length, (index) {
                final isSelected = _livestockTypeIndex == index;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(presetLabels[index]),
                    selected: isSelected,
                    onSelected: (val) {
                      if (val) _onLivestockPresetChanged(index);
                    },
                    backgroundColor: Colors.white,
                    selectedColor: const Color(0xFF196B4A),
                    side: BorderSide(
                      color: isSelected ? const Color(0xFF196B4A) : const Color(0xFFE2E8E3),
                    ),
                    labelStyle: TextStyle(
                      fontSize: 11,
                      fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                      color: isSelected ? Colors.white : const Color(0xFF17352B),
                    ),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                );
              }),
            ),
          ),
          const SizedBox(height: 16),

          // Grid Input
          Row(
            children: [
              Expanded(
                child: _buildInputField(
                  label: 'Bobot Timbang Hidup',
                  controller: _lsWeightController,
                  suffix: 'kg',
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildInputField(
                  label: 'Harga Timbang Hidup/kg',
                  controller: _lsLivePriceController,
                  suffix: 'Rp',
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          Row(
            children: [
              Expanded(
                child: _buildInputField(
                  label: 'Rendemen Karkas',
                  controller: _lsCarcassPercentController,
                  suffix: '%',
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildInputField(
                  label: 'Harga Daging Karkas/kg',
                  controller: _lsMeatPriceController,
                  suffix: 'Rp',
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          Row(
            children: [
              Expanded(
                child: _buildInputField(
                  label: 'Nilai Jeroan, Kulit & Kaki',
                  controller: _lsByproductController,
                  suffix: 'Rp',
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildInputField(
                  label: 'Biaya Jasa Potong / RPH',
                  controller: _lsSlaughterCostController,
                  suffix: 'Rp',
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),

          // Hasil Komparasi Opsi A vs Opsi B
          Row(
            children: [
              // Opsi A: Timbang Hidup
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: !isSlaughterBetter ? const Color(0xFFEAF3E7) : const Color(0xFFF7FAF8),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: !isSlaughterBetter ? const Color(0xFF196B4A) : const Color(0xFFE2E8E3),
                      width: !isSlaughterBetter ? 1.5 : 1.0,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'TIMBANG HIDUP',
                            style: TextStyle(
                              fontSize: 9.5,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF56625D),
                              letterSpacing: 0.6,
                            ),
                          ),
                          if (!isSlaughterBetter)
                            const Icon(Icons.check_circle_rounded, color: Color(0xFF196B4A), size: 14),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        _formatRupiah(liveRevenue),
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF17352B),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${weight.toStringAsFixed(1)} kg × ${_formatRupiah(livePrice)}',
                        style: const TextStyle(fontSize: 10, color: Color(0xFF72827C)),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 10),

              // Opsi B: Sembelih Daging Karkas
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isSlaughterBetter ? const Color(0xFFEAF3E7) : const Color(0xFFF7FAF8),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: isSlaughterBetter ? const Color(0xFF196B4A) : const Color(0xFFE2E8E3),
                      width: isSlaughterBetter ? 1.5 : 1.0,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'SEMBELIH KARKAS',
                            style: TextStyle(
                              fontSize: 9.5,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF56625D),
                              letterSpacing: 0.6,
                            ),
                          ),
                          if (isSlaughterBetter)
                            const Icon(Icons.check_circle_rounded, color: Color(0xFF196B4A), size: 14),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        _formatRupiah(carcassNetRevenue),
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF196B4A),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Karkas: ${carcassWeightKg.toStringAsFixed(1)} kg + Sampingan',
                        style: const TextStyle(fontSize: 10, color: Color(0xFF72827C)),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Rekomendasi Keputusan
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isSlaughterBetter ? const Color(0xFFF0F7ED) : const Color(0xFFFFF9E6),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSlaughterBetter ? const Color(0xFFB8DEBA) : const Color(0xFFFFE082),
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  isSlaughterBetter ? Icons.trending_up_rounded : Icons.check_circle_outline_rounded,
                  color: isSlaughterBetter ? const Color(0xFF196B4A) : const Color(0xFFB26A00),
                  size: 20,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        isSlaughterBetter
                            ? 'Rekomendasi: Potong & Jual Daging Karkas'
                            : 'Rekomendasi: Jual Timbang Hidup',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: isSlaughterBetter ? const Color(0xFF104B36) : const Color(0xFF8C5300),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        isSlaughterBetter
                            ? 'Menghasilkan surplus laba bersih +${_formatRupiah(marginDiff)} dibandingkan dijual hidup di pasaran ${_selectedCity.name}.'
                            : 'Penjualan timbang hidup lebih menguntungkan +${_formatRupiah(-marginDiff)} tanpa risiko susut karkas dan biaya potong.',
                        style: TextStyle(
                          fontSize: 11,
                          color: isSlaughterBetter ? const Color(0xFF2E5947) : const Color(0xFF6B4500),
                          height: 1.3,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
  }

  Widget _buildInputField({
    required String label,
    required TextEditingController controller,
    required String suffix,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 11, color: Color(0xFF72827C), fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          onChanged: (val) => setState(() {}),
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Color(0xFF17352B)),
          decoration: InputDecoration(
            suffixText: suffix,
            suffixStyle: const TextStyle(fontSize: 11, color: Color(0xFF72827C)),
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            isDense: true,
          ),
        ),
      ],
    );
  }

  Widget _buildMarketPriceRow({
    required CommodityMarketItem item,
    required int price,
    required String trend,
    required int change,
    required VoidCallback onTap,
  }) {
    Color trendColor = const Color(0xFF196B4A);
    Color trendBg = const Color(0xFFEAF3E7);

    if (trend == 'Tren Naik') {
      trendColor = const Color(0xFFC26D00);
      trendBg = const Color(0xFFFFF3E0);
    } else if (trend == 'Tren Turun') {
      trendColor = const Color(0xFF2E7D32);
      trendBg = const Color(0xFFE8F5E9);
    }

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        item.name,
                        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Color(0xFF17352B)),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        '(${item.category})',
                        style: const TextStyle(fontSize: 10, color: Color(0xFF72827C)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      Text(
                        '${_formatRupiah(price.toDouble())} / ${item.unit}',
                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: Color(0xFF196B4A)),
                      ),
                      if (change != 0) ...[
                        const SizedBox(width: 6),
                        Text(
                          change > 0 ? '+${_formatRupiah(change.toDouble())}' : _formatRupiah(change.toDouble()),
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: change > 0 ? Colors.red[700] : Colors.green[700],
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: trendBg,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                trend,
                style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: trendColor),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
