import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// GANTI dengan link aplikasi yang sebenarnya (Play Store, website, dsb.)
const linkBagikan = 'https://example.com/himtec';

const _hijauTua = Color(0xFF1B5E3F);
const _hijauGelap = Color(0xFF124A33);
const _hijauMuda = Color(0xFFD4F07A);
const _latar = Color(0xFFF8F8F0);
const _abuTab = Color(0xFFE6EBE4);

class PasarHitungPage extends StatelessWidget {
  const PasarHitungPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: _latar,
        body: SafeArea(
          child: Column(
            children: [
              const _Header(),
              const _TabSwitcher(),
              Expanded(
                child: TabBarView(
                  children: [
                    HargaLokalTab(),
                    KalkulatorTab(),
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

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: _hijauTua,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.eco_outlined, color: Colors.white, size: 20),
          ),
          const Expanded(
            child: Text(
              'Pasar & Hasil Panen',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ),
          const SizedBox(width: 40), // penyeimbang agar judul tetap di tengah
        ],
      ),
    );
  }
}

class _TabSwitcher extends StatelessWidget {
  const _TabSwitcher();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: _abuTab,
        borderRadius: BorderRadius.circular(14),
      ),
      child: TabBar(
        dividerColor: Colors.transparent,
        indicatorSize: TabBarIndicatorSize.tab,
        indicator: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        labelColor: _hijauTua,
        unselectedLabelColor: Colors.black54,
        labelStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
        tabs: const [
          Tab(text: 'Harga lokal', height: 36),
          Tab(text: 'Kalkulator panen', height: 36),
        ],
      ),
    );
  }
}

// ---------------- DATA & HELPER ----------------

class HargaPasar {
  final String nama;
  final String keterangan;
  final int harga;
  final String? gambar; // path asset, boleh kosong dulu

  const HargaPasar(this.nama, this.keterangan, this.harga, {this.gambar});

  HargaPasar copyWith({int? harga}) =>
      HargaPasar(nama, keterangan, harga ?? this.harga, gambar: gambar);
}

// Daftar harga dipakai bersama oleh tab Harga lokal dan Kalkulator panen.
// Kalau nilainya diubah, kedua tab ikut diperbarui.
final daftarHarga = ValueNotifier<List<HargaPasar>>([
  const HargaPasar('Tomat', 'Panen segar', 18000),
  const HargaPasar('Selada', 'Kualitas organik', 22000),
  const HargaPasar('Pakcoy', 'Panen segar', 16000),
]);

String formatRupiah(int n) {
  final s = n.toString();
  final buf = StringBuffer();
  for (var i = 0; i < s.length; i++) {
    if (i > 0 && (s.length - i) % 3 == 0) buf.write('.');
    buf.write(s[i]);
  }
  return 'Rp $buf';
}

// ---------------- TAB HARGA LOKAL ----------------

class HargaLokalTab extends StatelessWidget {
  const HargaLokalTab({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<List<HargaPasar>>(
      valueListenable: daftarHarga,
      builder: (context, daftar, _) => ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text(
          'PASAR BANDUNG',
          style: TextStyle(
            fontSize: 11,
            letterSpacing: 1.5,
            fontWeight: FontWeight.w600,
            color: Colors.black54,
          ),
        ),
        const SizedBox(height: 6),
        const Text(
          'Harga lokal terbaru.',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w800,
            color: _hijauTua,
          ),
        ),
        const SizedBox(height: 4),
        const Text(
          'Referensi harga diperbarui untuk minggu ini.',
          style: TextStyle(fontSize: 12, color: Colors.black54),
        ),
        const SizedBox(height: 4),
        const Text(
          'Ketuk kartu untuk mengubah harga.',
          style: TextStyle(fontSize: 11, color: Colors.black38),
        ),
        const SizedBox(height: 16),
        for (final item in daftar) ...[
          _KartuHarga(item: item),
          const SizedBox(height: 12),
        ],
      ],
    ),
    );
  }
}

class _KartuHarga extends StatelessWidget {
  final HargaPasar item;
  const _KartuHarga({required this.item});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _editHarga(context, item),
      child: Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.black12),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: item.gambar != null
                ? Image.asset(item.gambar!,
                    width: 60, height: 60, fit: BoxFit.cover)
                : Container(
                    width: 60,
                    height: 60,
                    color: const Color(0xFFCFE3D4),
                    child: const Icon(Icons.eco, color: _hijauTua),
                  ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.nama,
                    style: const TextStyle(
                        fontSize: 15, fontWeight: FontWeight.w600)),
                const SizedBox(height: 4),
                Text(item.keterangan,
                    style:
                        const TextStyle(fontSize: 10, color: Colors.black54)),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(formatRupiah(item.harga),
                  style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                      color: _hijauTua)),
              const Text('/kg',
                  style: TextStyle(fontSize: 10, color: Colors.black54)),
            ],
          ),
          const SizedBox(width: 8),
          const Icon(Icons.edit_outlined, size: 14, color: Colors.black38),
          const SizedBox(width: 4),
        ],
      ),
      ),
    );
  }
}

Future<void> _editHarga(BuildContext context, HargaPasar item) async {
  final hargaBaru = await showDialog<int>(
    context: context,
    builder: (_) => _EditHargaDialog(item: item),
  );
  if (hargaBaru == null) return;
  daftarHarga.value = [
    for (final t in daftarHarga.value)
      t.nama == item.nama ? t.copyWith(harga: hargaBaru) : t,
  ];
}

class _EditHargaDialog extends StatefulWidget {
  final HargaPasar item;
  const _EditHargaDialog({required this.item});

  @override
  State<_EditHargaDialog> createState() => _EditHargaDialogState();
}

class _EditHargaDialogState extends State<_EditHargaDialog> {
  late final TextEditingController _ctrl =
      TextEditingController(text: widget.item.harga.toString());
  String? _error;

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _simpan() {
    final nilai = int.tryParse(_ctrl.text);
    if (nilai == null || nilai <= 0) {
      setState(() => _error = 'Masukkan harga yang valid');
      return;
    }
    Navigator.pop(context, nilai);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Ubah harga ${widget.item.nama}'),
      content: TextField(
        controller: _ctrl,
        autofocus: true,
        keyboardType: TextInputType.number,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        onSubmitted: (_) => _simpan(),
        decoration: InputDecoration(
          prefixText: 'Rp ',
          suffixText: '/kg',
          errorText: _error,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Batal'),
        ),
        FilledButton(
          onPressed: _simpan,
          style: FilledButton.styleFrom(backgroundColor: _hijauTua),
          child: const Text('Simpan'),
        ),
      ],
    );
  }
}

// ---------------- TAB KALKULATOR PANEN ----------------

class KalkulatorTab extends StatefulWidget {
  const KalkulatorTab({super.key});

  @override
  State<KalkulatorTab> createState() => _KalkulatorTabState();
}

class _KalkulatorTabState extends State<KalkulatorTab> {
  String _namaTanaman = daftarHarga.value.first.nama;

  // Selalu ambil data terbaru dari daftarHarga, jadi kalau harga diubah di
  // tab Harga lokal, perhitungan di sini ikut berubah.
  HargaPasar get _tanaman => daftarHarga.value.firstWhere(
        (t) => t.nama == _namaTanaman,
        orElse: () => daftarHarga.value.first,
      );
  final _potCtrl = TextEditingController(text: '20');
  final _kgCtrl = TextEditingController(text: '0.25');
  double _kgPerPot = 0.25;

  int get _pot => int.tryParse(_potCtrl.text) ?? 0;
  double get _totalKg => _pot * _kgPerPot;
  int get _pendapatan => (_totalKg * _tanaman.harga).round();

  void _tampilPesan(String teks) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(teks)));
  }

  // Salin link ke clipboard, lalu pengguna menempelkannya sendiri
  // ke WhatsApp atau chat lain.
  Future<void> _bagikan() async {
    await Clipboard.setData(const ClipboardData(text: linkBagikan));
    if (!mounted) return;
    _tampilPesan('Link disalin');
  }

  void _hargaBerubah() {
    if (mounted) setState(() {});
  }

  @override
  void initState() {
    super.initState();
    daftarHarga.addListener(_hargaBerubah);
  }

  @override
  void dispose() {
    daftarHarga.removeListener(_hargaBerubah);
    _potCtrl.dispose();
    _kgCtrl.dispose();
    super.dispose();
  }

  InputDecoration _dekorasi() {
    return InputDecoration(
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Colors.black12),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Colors.black12),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: _hijauTua),
      ),
    );
  }

  Widget _label(String teks) => Padding(
        padding: const EdgeInsets.only(bottom: 6),
        child: Text(teks,
            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600)),
      );

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text(
          'RENCANAKAN PANEN',
          style: TextStyle(
            fontSize: 11,
            letterSpacing: 1.5,
            fontWeight: FontWeight.w600,
            color: Colors.black54,
          ),
        ),
        const SizedBox(height: 6),
        const Text(
          'Hitung perkiraan\nhasil panen.',
          style: TextStyle(
            fontSize: 28,
            height: 1.1,
            fontWeight: FontWeight.w800,
            color: _hijauTua,
          ),
        ),
        const SizedBox(height: 4),
        const Text(
          'Dapatkan proyeksi cepat berdasarkan harga lokal hari ini.',
          style: TextStyle(fontSize: 12, color: Colors.black54),
        ),
        const SizedBox(height: 20),

        // Dropdown tanaman
        _label('Tanaman siap panen'),
        DropdownButtonFormField<HargaPasar>(
          value: _tanaman,
          decoration: _dekorasi(),
          icon: const Icon(Icons.keyboard_arrow_down),
          items: [
            for (final t in daftarHarga.value)
              DropdownMenuItem(value: t, child: Text(t.nama)),
          ],
          onChanged: (v) =>
              setState(() => _namaTanaman = v?.nama ?? _namaTanaman),
        ),
        const SizedBox(height: 14),

        // Input pot dan kg per pot
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _label('Pot siap panen'),
                  TextField(
                    controller: _potCtrl,
                    keyboardType: TextInputType.number,
                    decoration: _dekorasi(),
                    onChanged: (_) => setState(() {}),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _label('Kg per pot'),
                  TextField(
                    controller: _kgCtrl,
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    decoration: _dekorasi(),
                    onChanged: (v) {
                      final angka = double.tryParse(v.replaceAll(',', '.'));
                      setState(() => _kgPerPot = angka ?? 0);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),

        // Slider berat rata-rata
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Berat rata-rata per pot',
                style: TextStyle(fontSize: 11, color: Colors.black54)),
            Text('${_kgPerPot.toStringAsFixed(2)} kg',
                style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: _hijauTua)),
          ],
        ),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: _hijauTua,
            inactiveTrackColor: _abuTab,
            thumbColor: _hijauTua,
            trackHeight: 4,
          ),
          child: Slider(
            min: 0.05,
            max: 1.0,
            divisions: 19,
            value: _kgPerPot.clamp(0.05, 1.0).toDouble(),
            onChanged: (v) {
              setState(() {
                _kgPerPot = double.parse(v.toStringAsFixed(2));
                _kgCtrl.text = _kgPerPot.toString();
              });
            },
          ),
        ),
        const SizedBox(height: 8),

        // Kartu hasil
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: _hijauGelap,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'TOTAL PERKIRAAN',
                style: TextStyle(
                    fontSize: 10,
                    letterSpacing: 1.2,
                    fontWeight: FontWeight.w600,
                    color: Colors.white70),
              ),
              const SizedBox(height: 10),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Icon(Icons.eco_outlined, color: _hijauMuda, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    _totalKg.toStringAsFixed(1),
                    style: const TextStyle(
                        fontSize: 34,
                        fontWeight: FontWeight.w800,
                        color: Colors.white),
                  ),
                  const SizedBox(width: 4),
                  const Padding(
                    padding: EdgeInsets.only(bottom: 6),
                    child: Text('kg',
                        style: TextStyle(fontSize: 12, color: Colors.white70)),
                  ),
                ],
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 14),
                child: Divider(color: Colors.white24, height: 1),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Referensi harga',
                          style:
                              TextStyle(fontSize: 10, color: Colors.white70)),
                      const SizedBox(height: 2),
                      Text(_tanaman.nama,
                          style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Colors.white)),
                    ],
                  ),
                  Text('${formatRupiah(_tanaman.harga)} /kg',
                      style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: Colors.white)),
                ],
              ),
              const SizedBox(height: 14),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Perkiraan pendapatan',
                      style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: Colors.white)),
                  Text(formatRupiah(_pendapatan),
                      style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          color: _hijauMuda)),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),

        // Tombol bagikan
        SizedBox(
          height: 48,
          child: ElevatedButton.icon(
            onPressed: _bagikan,
            icon: const Icon(Icons.share_outlined, size: 16),
            label: const Text('Bagikan'),
            style: ElevatedButton.styleFrom(
              backgroundColor: _hijauGelap,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14)),
              textStyle:
                  const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
            ),
          ),
        ),
      ],
    );
  }
}