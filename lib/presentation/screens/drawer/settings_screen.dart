import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/services/gemini_service.dart';
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
                    'Pengaturan',
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
          _buildSectionHeader(context, 'TEMA TAMPILAN'),
          const SizedBox(height: 10),
          _buildSettingsContainer(
            context,
            children: [
              Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Pilih Mode Tampilan Aplikasi',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Sesuaikan nuansa antarmuka dengan kebutuhan pencahayaan Anda.',
                      style: TextStyle(
                        fontSize: 12,
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 14),
                    SizedBox(
                      width: double.infinity,
                      child: SegmentedButton<ThemeMode>(
                        segments: const [
                          ButtonSegment<ThemeMode>(
                            value: ThemeMode.system,
                            icon: Icon(Icons.brightness_auto_outlined, size: 18),
                            label: Text('Sistem'),
                          ),
                          ButtonSegment<ThemeMode>(
                            value: ThemeMode.light,
                            icon: Icon(Icons.light_mode_outlined, size: 18),
                            label: Text('Terang'),
                          ),
                          ButtonSegment<ThemeMode>(
                            value: ThemeMode.dark,
                            icon: Icon(Icons.dark_mode_outlined, size: 18),
                            label: Text('Gelap'),
                          ),
                        ],
                        selected: {themeProvider.themeMode},
                        onSelectionChanged: (newSelection) {
                          themeProvider.setThemeMode(newSelection.first);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          _buildSectionHeader(context, 'INTEGRASI AI & DIAGNOSA'),
          const SizedBox(height: 10),
          _buildSettingsContainer(
            context,
            children: [
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: GeminiService.hasCustomKey
                        ? const Color(0xFF196B4A).withValues(alpha: 0.12)
                        : colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.auto_awesome_rounded,
                    color: GeminiService.hasCustomKey ? const Color(0xFF196B4A) : colorScheme.onSurfaceVariant,
                    size: 20,
                  ),
                ),
                title: const Text('Google Gemini API Key', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                subtitle: Text(
                  GeminiService.hasCustomKey
                      ? 'Tersambung (Gemini 1.5/2.0 Flash AI Aktif)'
                      : 'Belum diatur (Menggunakan Mode Diagnosa Offline)',
                  style: TextStyle(
                    fontSize: 12,
                    color: GeminiService.hasCustomKey ? const Color(0xFF196B4A) : colorScheme.onSurfaceVariant,
                  ),
                ),
                trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 14),
                onTap: () => _showApiKeyDialog(context),
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
    ),
  ],
),
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

  void _showApiKeyDialog(BuildContext context) {
    final controller = TextEditingController(text: GeminiService.apiKey);
    bool isTesting = false;
    String? testResultMessage;
    bool? testResultSuccess;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (dialogCtx, setDialogState) {
          return AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            title: const Row(
              children: [
                Icon(Icons.key_rounded, color: Color(0xFF196B4A), size: 22),
                SizedBox(width: 8),
                Text('Google Gemini API Key', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ],
            ),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Hubungkan API Key Google Gemini (1.5 Flash / 2.0 Flash) untuk diagnosa penyakit tanaman dan ternak berbasis visual multimodal Google AI:',
                    style: TextStyle(fontSize: 12, color: Color(0xFF56625D)),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: controller,
                    decoration: InputDecoration(
                      hintText: 'Tempel AIzaSy...',
                      labelText: 'Google Gemini API Key',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      suffixIcon: controller.text.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear, size: 18),
                              onPressed: () {
                                controller.clear();
                                setDialogState(() {
                                  testResultMessage = null;
                                  testResultSuccess = null;
                                });
                              },
                            )
                          : null,
                    ),
                    onChanged: (_) {
                      setDialogState(() {
                        testResultMessage = null;
                        testResultSuccess = null;
                      });
                    },
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Dapatkan gratis tanpa kartu kredit di https://aistudio.google.com/',
                    style: TextStyle(fontSize: 10.5, color: Color(0xFF72827C)),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      onPressed: isTesting
                          ? null
                          : () async {
                              final text = controller.text.trim();
                              if (text.isEmpty) {
                                setDialogState(() {
                                  testResultMessage = 'Masukkan API Key terlebih dahulu.';
                                  testResultSuccess = false;
                                });
                                return;
                              }
                              setDialogState(() {
                                isTesting = true;
                                testResultMessage = null;
                              });
                              final res = await GeminiService.testApiKey(text);
                              setDialogState(() {
                                isTesting = false;
                                testResultSuccess = res['success'] == true;
                                testResultMessage = res['message'] as String?;
                              });
                            },
                      icon: isTesting
                          ? const SizedBox(
                              width: 14,
                              height: 14,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(Icons.network_check_rounded, size: 18),
                      label: Text(
                        isTesting ? 'Menguji Koneksi...' : 'Uji Koneksi API Key',
                        style: const TextStyle(fontSize: 12),
                      ),
                    ),
                  ),
                  if (testResultMessage != null) ...[
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: testResultSuccess == true
                            ? const Color(0xFFE8F5E9)
                            : const Color(0xFFFFEBEE),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: testResultSuccess == true
                              ? const Color(0xFF4CAF50)
                              : const Color(0xFFEF5350),
                        ),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            testResultSuccess == true
                                ? Icons.check_circle_outline
                                : Icons.error_outline,
                            size: 16,
                            color: testResultSuccess == true
                                ? const Color(0xFF2E7D32)
                                : const Color(0xFFC62828),
                          ),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              testResultMessage!,
                              style: TextStyle(
                                fontSize: 11,
                                color: testResultSuccess == true
                                    ? const Color(0xFF1B5E20)
                                    : const Color(0xFFB71C1C),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text('Batal'),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF196B4A),
                  foregroundColor: Colors.white,
                ),
                onPressed: () async {
                  await GeminiService.setApiKey(controller.text);
                  if (ctx.mounted) Navigator.pop(ctx);
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          controller.text.trim().isNotEmpty
                              ? 'API Key Gemini berhasil disimpan & siap digunakan!'
                              : 'API Key dihapus. Aplikasi kembali ke mode offline.',
                        ),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                    setState(() {});
                  }
                },
                child: const Text('Simpan'),
              ),
            ],
          );
        },
      ),
    );
  }
}
