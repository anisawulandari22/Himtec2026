import 'package:flutter/material.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new, size: 18),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Bantuan & Dukungan',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
            ),
            Divider(height: 1, color: colorScheme.outlineVariant),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                children: [
          Text(
            'PERTANYAAN UMUM (FAQ)',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.8,
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 10),
          _buildFaqItem(
            context,
            question: 'Bagaimana cara menentukan fase dan jadwal pemupukan tanaman?',
            answer:
                'Anda dapat memantau umur tanaman di kartu Beranda atau membuka Detail Tanaman. Sistem menyediakan tips pakar kontekstual dan checklist perawatan harian sesuai fase pertumbuhan.',
          ),
          const SizedBox(height: 8),
          _buildFaqItem(
            context,
            question: 'Bagaimana penanganan darurat saat tanaman diserang hama/penyakit?',
            answer:
                'Buka tab "Hama & Rawat", cari hama berdasarkan ciri visual atau tanaman terdampak (misal wereng, patek, ulat), lalu terapkan solusi agens hayati nabati yang direkomendasikan.',
          ),
          const SizedBox(height: 8),
          _buildFaqItem(
            context,
            question: 'Bagaimana cara menghitung proyeksi panen dan laba bersih?',
            answer:
                'Gunakan tab "Pasar & Hitung". Pilih komoditas Anda atau masukkan jumlah rumpun/lubang tanam, bobot panen, dan modal operasional untuk melihat proyeksi laba dengan memperhitungkan tingkat keberhasilan (success rate).',
          ),
          const SizedBox(height: 8),
          _buildFaqItem(
            context,
            question: 'Apakah aplikasi mendukung budidaya pertanian dan peternakan sekaligus?',
            answer:
                'Ya, AGL (Applied Agriculture & Livestock) mendukung multisistem budidaya terapan, mulai dari komoditas tanaman sawah pangan, hortikultura, hingga peternakan ayam, sapi, dan perah dengan acuan harga pasar per kota.',
          ),
          const SizedBox(height: 24),

          Text(
            'SALURAN DUKUNGAN RESMI AGL',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.8,
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: colorScheme.surface,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: colorScheme.outlineVariant),
            ),
            child: Column(
              children: [
                _buildContactRow(
                  context,
                  icon: Icons.eco_outlined,
                  label: 'Konsultasi Agronomi & Budidaya',
                  value: 'agronomi@agl.id',
                ),
                const Divider(height: 24),
                _buildContactRow(
                  context,
                  icon: Icons.pets_outlined,
                  label: 'Konsultasi Peternakan (Livestock)',
                  value: 'livestock@agl.id',
                ),
                const Divider(height: 24),
                _buildContactRow(
                  context,
                  icon: Icons.location_on_outlined,
                  label: 'Pusat Riset Terapan AGL',
                  value: 'Kawasan Riset Terpadu AGL Indonesia',
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

  Widget _buildFaqItem(
    BuildContext context, {
    required String question,
    required String answer,
  }) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: colorScheme.outlineVariant),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
          title: Text(
            question,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: colorScheme.onSurface,
            ),
          ),
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 14, right: 14, bottom: 14),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  answer,
                  style: TextStyle(
                    fontSize: 13,
                    color: colorScheme.onSurfaceVariant,
                    height: 1.4,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactRow(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
  }) {
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      children: [
        Icon(icon, size: 20, color: colorScheme.primary),
        const SizedBox(width: 14),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              value,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurface,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

