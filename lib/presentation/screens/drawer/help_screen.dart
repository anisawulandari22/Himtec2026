import 'package:flutter/material.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Bantuan & Dukungan'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(
            color: colorScheme.outlineVariant,
            height: 1.0,
          ),
        ),
      ),
      body: ListView(
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
            question: 'Bagaimana cara memvalidasi presensi kehadiran acara?',
            answer:
                'Buka menu Presensi di beranda, lalu arahkan kamera ke kode QR dinamis yang ditampilkan oleh panitia saat kegiatan berlangsung.',
          ),
          const SizedBox(height: 8),
          _buildFaqItem(
            context,
            question: 'Bagaimana prosedur pengajuan anggaran kegiatan divisi?',
            answer:
                'Pengajuan anggaran dilakukan melalui modul Kas dengan mengunggah proposal kegiatan paling lambat 14 hari sebelum hari pelaksanaan acara.',
          ),
          const SizedBox(height: 8),
          _buildFaqItem(
            context,
            question: 'Siapa yang dapat mengakses repositori riset himpunan?',
            answer:
                'Seluruh anggota aktif dengan status terdaftar dapat mengunduh materi dan berkas riset melalui tab Eksplor.',
          ),
          const SizedBox(height: 24),

          Text(
            'SALURAN DUKUNGAN RESMI',
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
                  icon: Icons.alternate_email_rounded,
                  label: 'Sekretariat Utama',
                  value: 'sekretariat@himtec.org',
                ),
                const Divider(height: 24),
                _buildContactRow(
                  context,
                  icon: Icons.chat_outlined,
                  label: 'Helpdesk Divisi IT',
                  value: 'support@himtec.org',
                ),
                const Divider(height: 24),
                _buildContactRow(
                  context,
                  icon: Icons.location_on_outlined,
                  label: 'Ruang Himpunan',
                  value: 'Gedung Teknik Lt. 2, Ruang 204',
                ),
              ],
            ),
          ),
        ],
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

