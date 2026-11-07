import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppDrawer extends StatelessWidget {
  final String currentRoute;

  const AppDrawer({
    super.key,
    required this.currentRoute,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Drawer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildHeader(context, colorScheme),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              children: [
                _DrawerItem(
                  icon: Icons.dashboard_outlined,
                  selectedIcon: Icons.dashboard_rounded,
                  title: 'Dashboard',
                  isSelected: currentRoute == '/home',
                  onTap: () {
                    Navigator.of(context).pop();
                    context.go('/home');
                  },
                ),
                _DrawerItem(
                  icon: Icons.history_rounded,
                  selectedIcon: Icons.history_toggle_off_rounded,
                  title: 'Riwayat',
                  isSelected: currentRoute == '/history',
                  onTap: () {
                    Navigator.of(context).pop();
                    context.push('/history');
                  },
                ),
                _DrawerItem(
                  icon: Icons.settings_outlined,
                  selectedIcon: Icons.settings_rounded,
                  title: 'Pengaturan',
                  isSelected: currentRoute == '/settings',
                  onTap: () {
                    Navigator.of(context).pop();
                    context.push('/settings');
                  },
                ),
                _DrawerItem(
                  icon: Icons.help_outline_rounded,
                  selectedIcon: Icons.help_rounded,
                  title: 'Bantuan & Dukungan',
                  isSelected: currentRoute == '/help',
                  onTap: () {
                    Navigator.of(context).pop();
                    context.push('/help');
                  },
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: Divider(),
                ),
                _DrawerItem(
                  icon: Icons.logout_rounded,
                  selectedIcon: Icons.logout_rounded,
                  title: 'Keluar',
                  isDestructive: true,
                  isSelected: false,
                  onTap: () {
                    Navigator.of(context).pop();
                    _showLogoutDialog(context);
                  },
                ),
              ],
            ),
          ),
          _buildFooter(context, colorScheme),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, ColorScheme colorScheme) {
    return Container(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 20,
        bottom: 20,
        left: 20,
        right: 20,
      ),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainer,
        border: Border(
          bottom: BorderSide(
            color: colorScheme.outlineVariant,
            width: 1,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 26,
                backgroundColor: colorScheme.primary,
                child: Text(
                  'LT',
                  style: TextStyle(
                    color: colorScheme.onPrimary,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: colorScheme.surface,
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(
                    color: colorScheme.outlineVariant,
                    width: 1,
                  ),
                ),
                child: Text(
                  'Anggota Aktif',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: colorScheme.primary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            'Luna Teguh',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: colorScheme.onSurface,
              letterSpacing: -0.2,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            'luna.teguh@himtec.org',
            style: TextStyle(
              fontSize: 13,
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter(BuildContext context, ColorScheme colorScheme) {
    return Container(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        bottom: MediaQuery.of(context).padding.bottom + 12,
        top: 12,
      ),
      child: Text(
        'HIMTEC Mobile v1.0.0',
        style: TextStyle(
          fontSize: 11,
          color: colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) {
        final colorScheme = Theme.of(ctx).colorScheme;
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          title: const Text(
            'Konfirmasi Keluar',
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
          ),
          content: const Text(
            'Apakah Anda yakin ingin keluar dari sesi akun saat ini?',
            style: TextStyle(fontSize: 14),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: Text(
                'Batal',
                style: TextStyle(color: colorScheme.onSurfaceVariant),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: colorScheme.error,
                foregroundColor: colorScheme.onError,
              ),
              onPressed: () {
                Navigator.of(ctx).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Berhasil keluar dari sesi.'),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
              child: const Text('Keluar'),
            ),
          ],
        );
      },
    );
  }
}

class _DrawerItem extends StatelessWidget {
  final IconData icon;
  final IconData selectedIcon;
  final String title;
  final bool isSelected;
  final bool isDestructive;
  final VoidCallback onTap;

  const _DrawerItem({
    required this.icon,
    required this.selectedIcon,
    required this.title,
    required this.isSelected,
    this.isDestructive = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    Color iconColor;
    Color textColor;
    Color? tileColor;

    if (isDestructive) {
      iconColor = colorScheme.error;
      textColor = colorScheme.error;
      tileColor = null;
    } else if (isSelected) {
      iconColor = colorScheme.primary;
      textColor = colorScheme.primary;
      tileColor = colorScheme.primaryContainer.withValues(alpha: 0.5);
    } else {
      iconColor = colorScheme.onSurfaceVariant;
      textColor = colorScheme.onSurface;
      tileColor = null;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 2),
      child: ListTile(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        tileColor: tileColor,
        dense: true,
        leading: Icon(
          isSelected ? selectedIcon : icon,
          size: 20,
          color: iconColor,
        ),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 14,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
            color: textColor,
          ),
        ),
        onTap: onTap,
      ),
    );
  }
}
