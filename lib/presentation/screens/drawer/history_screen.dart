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
            date: '06 Nov 2026, 07:30 WIB',
            title: 'Penyemprotan Agens Hayati Beauveria bassiana',
            category: 'Pengendalian Hama',
            details: 'Aplikasi pencegahan wereng batang coklat pada petak Padi Inpari 32 selesai dengan dosis 5 gr/liter.',
          ),
          _buildTimelineItem(
            context,
            date: '02 Nov 2026, 08:15 WIB',
            title: 'Kocor Pupuk Kalsium-Boron & NPK Cair',
            category: 'Nutrisi Tanaman',
            details: 'Penguatan calon bunga dan pencegahan patek pada 1.000 pohon Cabai Rawit Merah.',
          ),
          _buildTimelineItem(
            context,
            date: '28 Okt 2026, 16:00 WIB',
            title: 'Pengurasan & Penyesuaian EC Tandon Hidroponik',
            category: 'Perawatan Sistem',
            details: 'Kalibrasi nutrisi AB Mix Pakcoy tercapai di EC 1.250 uS/cm dengan tingkat keasaman pH 6.3.',
          ),
          _buildTimelineItem(
            context,
            date: '21 Okt 2026, 09:00 WIB',
            title: 'Panen Perdana Tomat Cherry Batch #4',
            category: 'Pencatatan Panen',
            details: 'Hasil panen 12.4 kg kualitas Grade A disalurkan ke mitra pasar komunitas.',
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

