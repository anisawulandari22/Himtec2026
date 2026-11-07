import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final canPop = Navigator.canPop(context);

    return Scaffold(
      backgroundColor: const Color(0xFFFAFBF7),
      appBar: AppBar(
        title: const Text('Profil Petani'),
        centerTitle: false,
        leading: canPop
            ? IconButton(
                icon: const Icon(Icons.arrow_back_ios_new, size: 18),
                onPressed: () => Navigator.pop(context),
              )
            : null,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(
            color: const Color(0xFFE2E8E3),
            height: 1.0,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          children: [
            // Header Profile Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(22),
                border: Border.all(color: const Color(0xFFE2E8E3)),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF1E3B2E).withValues(alpha: 0.04),
                    blurRadius: 16,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: const Color(0xFF104B36),
                    child: const Text(
                      'PU',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        letterSpacing: 1.0,
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  const Text(
                    'Luna Teguh',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF17352B),
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Penggiat Urban Farming & Hidroponik',
                    style: TextStyle(
                      fontSize: 12,
                      color: Color(0xFF72827C),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEAF3E7),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Icon(Icons.verified, size: 14, color: Color(0xFF196B4A)),
                        SizedBox(width: 6),
                        Text(
                          'Petani Urban Aktif • Rooftop Bandung',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF196B4A),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 22),

            // Statistics Grid
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'STATISTIK PERKEBUNAN',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.0,
                  color: const Color(0xFF72827C),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: _buildStatTile(
                    title: 'Total Panen',
                    value: '28.5 kg',
                    icon: Icons.eco_rounded,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _buildStatTile(
                    title: 'Tanaman Aktif',
                    value: '3 Ragam',
                    icon: Icons.yard_outlined,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: _buildStatTile(
                    title: 'Tingkat Sukses',
                    value: '94%',
                    icon: Icons.trending_up_rounded,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _buildStatTile(
                    title: 'Lama Bertani',
                    value: '180 Hari',
                    icon: Icons.calendar_today_rounded,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Spesifikasi Kebun
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'SPESIFIKASI INSTALASI KEBUN',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.0,
                  color: const Color(0xFF72827C),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFE2E8E3)),
              ),
              child: Column(
                children: [
                  _buildSpecRow('Metode Utama', 'Hidroponik NFT & Dutch Bucket'),
                  const Divider(height: 1),
                  _buildSpecRow('Kapasitas Tanam', '120 Lubang Tanam'),
                  const Divider(height: 1),
                  _buildSpecRow('Nutrisi Digunakan', 'AB Mix Formulasi Sayur Daun'),
                  const Divider(height: 1),
                  _buildSpecRow('Sensor Otomasi', 'ESP32 pH & TDS Monitor Aktif'),
                  const Divider(height: 1),
                  _buildSpecRow('Lokasi', 'Coblong, Kota Bandung'),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Actions Menu
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Form pengeditan data kebun dibuka.'),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  side: const BorderSide(color: Color(0xFFDFE6DA)),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  backgroundColor: Colors.white,
                ),
                icon: const Icon(Icons.edit_outlined, size: 18, color: Color(0xFF196B4A)),
                label: const Text(
                  'Ubah Profil & Data Kebun',
                  style: TextStyle(color: Color(0xFF196B4A), fontWeight: FontWeight.w700),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatTile({
    required String title,
    required String value,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8E3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF72827C),
                ),
              ),
              Icon(icon, size: 16, color: const Color(0xFF196B4A)),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: Color(0xFF17352B),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSpecRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 12, color: Color(0xFF72827C)),
          ),
          Text(
            value,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Color(0xFF17352B)),
          ),
        ],
      ),
    );
  }
}
