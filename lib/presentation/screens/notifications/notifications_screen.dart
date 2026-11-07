import 'package:flutter/material.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'HARI INI',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.8,
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            TextButton(
              onPressed: () {},
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: Text(
                'Tandai sudah dibaca',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: colorScheme.primary,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        _buildNotificationTile(
          context,
          icon: Icons.event_available_outlined,
          title: 'Pengingat Rapat Pleno Terbuka',
          body: 'Rapat koordinasi bulanan akan diselenggarakan pukul 16.30 WIB di Ruang Seminar 2.',
          time: '35 menit lalu',
          isUnread: true,
        ),
        const SizedBox(height: 10),
        _buildNotificationTile(
          context,
          icon: Icons.description_outlined,
          title: 'Proposal Proyek Disetujui',
          body: 'Proposal integrasi server lokal telah diverifikasi oleh Ketua Divisi IT.',
          time: '3 jam lalu',
          isUnread: true,
        ),
        const SizedBox(height: 24),
        Text(
          'SEBELUMNYA',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.8,
            color: colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 12),
        _buildNotificationTile(
          context,
          icon: Icons.task_alt_outlined,
          title: 'Presensi Kegiatan Workshop Berhasil',
          body: 'Kehadiran Anda pada Pelatihan Dart Clean Architecture telah tercatat dalam sistem.',
          time: '2 hari lalu',
          isUnread: false,
        ),
        const SizedBox(height: 10),
        _buildNotificationTile(
          context,
          icon: Icons.campaign_outlined,
          title: 'Pengumuman Iuran Kas Himpunan',
          body: 'Pembayaran iuran operasional himpunan untuk semester ganjil telah dibuka.',
          time: '5 hari lalu',
          isUnread: false,
        ),
      ],
    );
  }

  Widget _buildNotificationTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String body,
    required String time,
    required bool isUnread,
  }) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isUnread
            ? colorScheme.primaryContainer.withValues(alpha: 0.25)
            : colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isUnread ? colorScheme.primary.withValues(alpha: 0.3) : colorScheme.outlineVariant,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainer,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Icon(
              icon,
              size: 18,
              color: colorScheme.primary,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: isUnread ? FontWeight.w700 : FontWeight.w600,
                          color: colorScheme.onSurface,
                        ),
                      ),
                    ),
                    if (isUnread)
                      Container(
                        width: 7,
                        height: 7,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: colorScheme.primary,
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  body,
                  style: TextStyle(
                    fontSize: 12,
                    color: colorScheme.onSurfaceVariant,
                    height: 1.35,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  time,
                  style: TextStyle(
                    fontSize: 11,
                    color: colorScheme.onSurfaceVariant.withValues(alpha: 0.8),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

