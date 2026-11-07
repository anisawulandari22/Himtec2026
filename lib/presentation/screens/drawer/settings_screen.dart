import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/theme_provider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _pushNotifications = true;
  bool _emailDigest = false;
  bool _biometricAuth = true;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final themeProvider = context.watch<ThemeProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pengaturan'),
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
          _buildSectionHeader(context, 'TEMA TAMPILAN'),
          const SizedBox(height: 10),
          _buildSettingsContainer(
            context,
            children: [
              RadioListTile<ThemeMode>(
                title: const Text('Ikuti Pengaturan Sistem', style: TextStyle(fontSize: 14)),
                subtitle: const Text(
                  'Menyesuaikan otomatis dengan preferensi perangkat Anda',
                  style: TextStyle(fontSize: 12),
                ),
                value: ThemeMode.system,
                groupValue: themeProvider.themeMode,
                activeColor: colorScheme.primary,
                onChanged: (val) {
                  if (val != null) themeProvider.setThemeMode(val);
                },
              ),
              const Divider(),
              RadioListTile<ThemeMode>(
                title: const Text('Mode Terang (Light Mode)', style: TextStyle(fontSize: 14)),
                subtitle: const Text(
                  'Latar cerah dengan aksen Deep Forest Green',
                  style: TextStyle(fontSize: 12),
                ),
                value: ThemeMode.light,
                groupValue: themeProvider.themeMode,
                activeColor: colorScheme.primary,
                onChanged: (val) {
                  if (val != null) themeProvider.setThemeMode(val);
                },
              ),
              const Divider(),
              RadioListTile<ThemeMode>(
                title: const Text('Mode Gelap (Dark Mode)', style: TextStyle(fontSize: 14)),
                subtitle: const Text(
                  'Latar gelap hemat daya dengan aksen Soft Emerald',
                  style: TextStyle(fontSize: 12),
                ),
                value: ThemeMode.dark,
                groupValue: themeProvider.themeMode,
                activeColor: colorScheme.primary,
                onChanged: (val) {
                  if (val != null) themeProvider.setThemeMode(val);
                },
              ),
            ],
          ),
          const SizedBox(height: 24),

          _buildSectionHeader(context, 'PREFERENSI NOTIFIKASI'),
          const SizedBox(height: 10),
          _buildSettingsContainer(
            context,
            children: [
              SwitchListTile(
                title: const Text('Notifikasi Aplikasi', style: TextStyle(fontSize: 14)),
                subtitle: const Text(
                  'Dapatkan pembaruan langsung tentang agenda dan tugas',
                  style: TextStyle(fontSize: 12),
                ),
                value: _pushNotifications,
                activeColor: colorScheme.primary,
                onChanged: (val) => setState(() => _pushNotifications = val),
              ),
              const Divider(),
              SwitchListTile(
                title: const Text('Ringkasan Mingguan Surel', style: TextStyle(fontSize: 14)),
                subtitle: const Text(
                  'Terima rangkuman kegiatan via email terdaftar',
                  style: TextStyle(fontSize: 12),
                ),
                value: _emailDigest,
                activeColor: colorScheme.primary,
                onChanged: (val) => setState(() => _emailDigest = val),
              ),
            ],
          ),
          const SizedBox(height: 24),

          _buildSectionHeader(context, 'KEAMANAN & PRIVASI'),
          const SizedBox(height: 10),
          _buildSettingsContainer(
            context,
            children: [
              SwitchListTile(
                title: const Text('Autentikasi Sidik Jari / Biometrik', style: TextStyle(fontSize: 14)),
                subtitle: const Text(
                  'Kunci akses aplikasi dengan sensor perangkat',
                  style: TextStyle(fontSize: 12),
                ),
                value: _biometricAuth,
                activeColor: colorScheme.primary,
                onChanged: (val) => setState(() => _biometricAuth = val),
              ),
              const Divider(),
              ListTile(
                title: const Text('Ubah Kata Sandi Akun', style: TextStyle(fontSize: 14)),
                trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 14),
                onTap: () {},
              ),
            ],
          ),
          const SizedBox(height: 24),

          _buildSectionHeader(context, 'DATA & CACHE'),
          const SizedBox(height: 10),
          _buildSettingsContainer(
            context,
            children: [
              ListTile(
                title: const Text('Hapus Berkas Sementara (Cache)', style: TextStyle(fontSize: 14)),
                subtitle: const Text('Penggunaan penyimpanan lokal: 14.8 MB', style: TextStyle(fontSize: 12)),
                trailing: TextButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Cache aplikasi berhasil dibersihkan.'),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                  child: Text(
                    'Bersihkan',
                    style: TextStyle(color: colorScheme.primary, fontSize: 13),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    final colorScheme = Theme.of(context).colorScheme;
    return Text(
      title,
      style: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.8,
        color: colorScheme.onSurfaceVariant,
      ),
    );
  }

  Widget _buildSettingsContainer(BuildContext context, {required List<Widget> children}) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: colorScheme.outlineVariant),
      ),
      child: Column(children: children),
    );
  }
}
