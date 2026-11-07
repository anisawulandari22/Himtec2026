import 'package:flutter/material.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Riwayat Aktivitas'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(
            color: colorScheme.outlineVariant,
            height: 1.0,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        children: [
          _buildTimelineItem(
            context,
            date: '04 Nov 2026, 14:00 WIB',
            title: 'Presensi Rapat Mingguan Divisi IT',
            category: 'Presensi Kegiatan',
            details: 'Tercatat hadir tepat waktu di Laboratorium Rekayasa Perangkat Lunak.',
          ),
          _buildTimelineItem(
            context,
            date: '31 Okt 2026, 20:15 WIB',
            title: 'Pengunggahan Modul Pelatihan Git & GitHub',
            category: 'Manajemen Berkas',
            details: 'Dokumen versi 1.2 diunggah ke repositori modul himpunan.',
          ),
          _buildTimelineItem(
            context,
            date: '24 Okt 2026, 09:30 WIB',
            title: 'Pembayaran Iuran Kas Periode Oktober',
            category: 'Keuangan',
            details: 'Transaksi Rp 25.000 diverifikasi oleh Bendahara Umum.',
          ),
          _buildTimelineItem(
            context,
            date: '18 Okt 2026, 13:00 WIB',
            title: 'Kepanitiaan Seminar Nasional Teknologi',
            category: 'Penugasan',
            details: 'Ditugaskan sebagai Koordinator Perlengkapan & Teknis Sistem.',
            isLast: true,
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineItem(
    BuildContext context, {
    required String date,
    required String title,
    required String category,
    required String details,
    bool isLast = false,
  }) {
    final colorScheme = Theme.of(context).colorScheme;

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: colorScheme.primary,
                ),
              ),
              if (!isLast)
                Expanded(
                  child: Container(
                    width: 2,
                    color: colorScheme.outlineVariant,
                  ),
                ),
            ],
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        category.toUpperCase(),
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: colorScheme.primary,
                          letterSpacing: 0.5,
                        ),
                      ),
                      Text(
                        date,
                        style: TextStyle(
                          fontSize: 11,
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    details,
                    style: TextStyle(
                      fontSize: 12,
                      color: colorScheme.onSurfaceVariant,
                      height: 1.35,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

