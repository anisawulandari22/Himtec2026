import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../widgets/app_drawer.dart';

class MainWrapper extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const MainWrapper({
    super.key,
    required this.navigationShell,
  });

  void _onDestinationSelected(int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  String _getTitleForIndex(int index) {
    switch (index) {
      case 0:
        return 'Beranda';
      case 1:
        return 'Eksplorasi';
      case 2:
        return 'Notifikasi';
      case 3:
        return 'Profil Pengurus';
      default:
        return 'HIMTEC Mobile';
    }
  }

  List<Widget> _getActionsForIndex(BuildContext context, int index) {
    final colorScheme = Theme.of(context).colorScheme;

    switch (index) {
      case 0:
        return [
          IconButton(
            icon: const Icon(Icons.search_rounded, size: 22),
            tooltip: 'Pencarian',
            onPressed: () => navigationShell.goBranch(1),
          ),
          IconButton(
            icon: const Icon(Icons.notifications_outlined, size: 22),
            tooltip: 'Notifikasi',
            onPressed: () => navigationShell.goBranch(2),
          ),
          const SizedBox(width: 4),
        ];
      case 1:
        return [
          IconButton(
            icon: const Icon(Icons.tune_rounded, size: 22),
            tooltip: 'Filter Pencarian',
            onPressed: () {},
          ),
          const SizedBox(width: 4),
        ];
      case 2:
        return [
          IconButton(
            icon: const Icon(Icons.done_all_rounded, size: 22),
            tooltip: 'Tandai Semua Dibaca',
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Semua notifikasi ditandai telah dibaca.'),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
          ),
          const SizedBox(width: 4),
        ];
      case 3:
        return [
          IconButton(
            icon: const Icon(Icons.qr_code_rounded, size: 22),
            tooltip: 'Kartu Tanda Anggota Digital',
            onPressed: () {
              _showQrDialog(context);
            },
          ),
          const SizedBox(width: 4),
        ];
      default:
        return [];
    }
  }

  void _showQrDialog(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: const Text(
          'Identitas Digital Anggota',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 170,
              height: 170,
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainer,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: colorScheme.outlineVariant),
              ),
              child: Center(
                child: Icon(
                  Icons.qr_code_2_rounded,
                  size: 140,
                  color: colorScheme.primary,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'NIM: 2210511048',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurface,
              ),
            ),
            Text(
              'Gunakan kode ini untuk presensi rapat dan kegiatan',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 11,
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Tutup'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final currentIndex = navigationShell.currentIndex;

    return Scaffold(
      appBar: AppBar(
        title: Text(_getTitleForIndex(currentIndex)),
        leading: Builder(
          builder: (scaffoldContext) => IconButton(
            icon: const Icon(Icons.menu_rounded, size: 24),
            tooltip: 'Menu Utama',
            onPressed: () => Scaffold.of(scaffoldContext).openDrawer(),
          ),
        ),
        actions: _getActionsForIndex(context, currentIndex),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(
            color: colorScheme.outlineVariant,
            height: 1.0,
          ),
        ),
      ),
      drawer: AppDrawer(
        currentRoute: GoRouterState.of(context).uri.toString(),
      ),
      body: navigationShell,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              color: colorScheme.outlineVariant,
              width: 1.0,
            ),
          ),
        ),
        child: NavigationBar(
          selectedIndex: currentIndex,
          onDestinationSelected: _onDestinationSelected,
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.home_outlined),
              selectedIcon: Icon(Icons.home_rounded),
              label: 'Beranda',
            ),
            NavigationDestination(
              icon: Icon(Icons.explore_outlined),
              selectedIcon: Icon(Icons.explore_rounded),
              label: 'Eksplor',
            ),
            NavigationDestination(
              icon: Icon(Icons.notifications_none_rounded),
              selectedIcon: Icon(Icons.notifications_rounded),
              label: 'Notifikasi',
            ),
            NavigationDestination(
              icon: Icon(Icons.person_outline_rounded),
              selectedIcon: Icon(Icons.person_rounded),
              label: 'Profil',
            ),
          ],
        ),
      ),
    );
  }
}

