import 'package:flutter/material.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  int _selectedFilterIndex = 0;
  final List<String> _filters = [
    'Semua',
    'Divisi IT',
    'Litbang',
    'Kaderisasi',
    'Humas',
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Search Input
          TextField(
            decoration: InputDecoration(
              hintText: 'Cari modul, repositori, atau anggota...',
              prefixIcon: Icon(
                Icons.search_rounded,
                color: colorScheme.onSurfaceVariant,
                size: 20,
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 12,
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Horizontal Filter Chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(_filters.length, (index) {
                final isSelected = _selectedFilterIndex == index;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(_filters[index]),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        _selectedFilterIndex = index;
                      });
                    },
                    showCheckmark: false,
                    backgroundColor: colorScheme.surfaceContainer,
                    selectedColor: colorScheme.primaryContainer,
                    side: BorderSide(
                      color: isSelected
                          ? colorScheme.primary
                          : colorScheme.outlineVariant,
                      width: 1,
                    ),
                    labelStyle: TextStyle(
                      fontSize: 12,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                      color: isSelected
                          ? colorScheme.primary
                          : colorScheme.onSurfaceVariant,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                );
              }),
            ),
          ),
          const SizedBox(height: 20),

          // Repository & Projects Heading
          Text(
            'DIREKTORI PROYEK TERBUKA',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.8,
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 12),

          _buildProjectItem(
            context,
            title: 'HIMTEC Core API Gateway',
            department: 'Divisi IT & Infrastruktur',
            techStack: 'Go / gRPC / Docker',
            status: 'Aktif',
            contributors: '6 Kontributor',
          ),
          const SizedBox(height: 10),
          _buildProjectItem(
            context,
            title: 'Sistem Informasi Akademik Terintegrasi',
            department: 'Divisi Riset & Pengembangan',
            techStack: 'Flutter / PostgreSQL',
            status: 'Pengembangan',
            contributors: '9 Kontributor',
          ),
          const SizedBox(height: 10),
          _buildProjectItem(
            context,
            title: 'Pustaka Komponen UI Mobile',
            department: 'Divisi Frontend & UI/UX',
            techStack: 'Dart / Material 3',
            status: 'Revisi',
            contributors: '4 Kontributor',
          ),
          const SizedBox(height: 10),
          _buildProjectItem(
            context,
            title: 'Automasi Presensi Berbasis QR Standar',
            department: 'Divisi IT & Infrastruktur',
            techStack: 'Node.js / Redis',
            status: 'Selesai',
            contributors: '3 Kontributor',
          ),
        ],
      ),
    );
  }

  Widget _buildProjectItem(
    BuildContext context, {
    required String title,
    required String department,
    required String techStack,
    required String status,
    required String contributors,
  }) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: colorScheme.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                department.toUpperCase(),
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: colorScheme.primary,
                  letterSpacing: 0.4,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainer,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  status,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(
                Icons.terminal_rounded,
                size: 14,
                color: colorScheme.onSurfaceVariant,
              ),
              const SizedBox(width: 4),
              Text(
                techStack,
                style: TextStyle(
                  fontSize: 12,
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              const Spacer(),
              Icon(
                Icons.people_outline_rounded,
                size: 14,
                color: colorScheme.onSurfaceVariant,
              ),
              const SizedBox(width: 4),
              Text(
                contributors,
                style: TextStyle(
                  fontSize: 12,
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

