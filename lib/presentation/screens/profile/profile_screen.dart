import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../core/providers/auth_provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final canPop = Navigator.canPop(context);
    final auth = context.watch<AuthProvider>();
    final user = auth.currentUser;

    final name = user?.name ?? 'Luna Teguh';
    final email = user?.email ?? 'luna.teguh@agl.id';
    final memberId = user?.memberId ?? 'AGL-ID-8829-IDN';
    final sector = user?.sector ?? 'Pertanian & Peternakan';
    final isGoogle = user?.provider == 'google';
    final initials = name.split(' ').map((w) => w.isNotEmpty ? w[0] : '').take(2).join('').toUpperCase();

    return Scaffold(
      backgroundColor: const Color(0xFFFAFBF7),
      appBar: AppBar(
        title: const Text('Profil Pengguna AGL'),
        centerTitle: false,
        leading: canPop
            ? IconButton(
                icon: const Icon(Icons.arrow_back_ios_new, size: 18),
                onPressed: () => Navigator.pop(context),
              )
            : null,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(
            color: const Color(0xFFE2E8E3),
            height: 1.0,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          children: [
            // Header Profile Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(22),
                border: Border.all(color: const Color(0xFFE2E8E3)),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF1E3B2E).withValues(alpha: 0.04),
                    blurRadius: 16,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: const Color(0xFF104B36),
                    child: Text(
                      initials.isNotEmpty ? initials : 'AG',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        letterSpacing: 1.0,
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF17352B),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    email,
                    style: const TextStyle(
                      fontSize: 12.5,
                      color: Color(0xFF72827C),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 6,
                    alignment: WrapAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEAF3E7),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.verified, size: 14, color: Color(0xFF196B4A)),
                            const SizedBox(width: 4),
                            Text(
                              memberId,
                              style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF196B4A),
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (isGoogle)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE3F2FD),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: const Text(
                            'Akun Google Terhubung',
                            style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Color(0xFF1565C0)),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 22),

            // Statistics Grid
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'STATISTIK AGRO & TERNAK',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.0,
                  color: Color(0xFF72827C),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: _buildStatTile(
                    title: 'Total Panen',
                    value: '28.5 kg',
                    icon: Icons.eco_rounded,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _buildStatTile(
                    title: 'Populasi Ternak',
                    value: '5 Ekor',
                    icon: Icons.pets_rounded,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: _buildStatTile(
                    title: 'Tingkat Sukses',
                    value: '94%',
                    icon: Icons.trending_up_rounded,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _buildStatTile(
                    title: 'Lama Bergabung',
                    value: '180 Hari',
                    icon: Icons.calendar_today_rounded,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Informasi Akun & Sektor
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'INFORMASI AKUN & SEKTOR USAHA',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.0,
                  color: Color(0xFF72827C),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFE2E8E3)),
              ),
              child: Column(
                children: [
                  _buildSpecRow('Sektor Fokus', sector),
                  const Divider(height: 1),
                  _buildSpecRow('Metode Pertanian', 'Hidroponik & Kebun Terbuka'),
                  const Divider(height: 1),
                  _buildSpecRow('Penyimpanan Data', 'Tersimpan Permanen (Lokal & Akun)'),
                  const Divider(height: 1),
                  _buildSpecRow('Metode Masuk', isGoogle ? 'Google OAuth' : 'Email & Password'),
                  const Divider(height: 1),
                  _buildSpecRow('Wilayah Acuan Pasar', 'Bandung (Pasar Caringin)'),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Tombol Keluar dari Akun (Logout)
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () => _confirmLogout(context),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  side: const BorderSide(color: Color(0xFFF0CBCB)),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  backgroundColor: const Color(0xFFFFF8F8),
                ),
                icon: const Icon(Icons.logout_rounded, size: 18, color: Color(0xFFBA1A1A)),
                label: const Text(
                  'Keluar dari Akun',
                  style: TextStyle(color: Color(0xFFBA1A1A), fontWeight: FontWeight.w700),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _confirmLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Keluar dari Akun', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 17)),
        content: const Text(
          'Apakah Anda yakin ingin keluar? Seluruh data riwayat kebun dan ternak Anda tetap tersimpan aman di aplikasi.',
          style: TextStyle(fontSize: 13, height: 1.4),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFBA1A1A),
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            onPressed: () async {
              Navigator.pop(ctx);
              await context.read<AuthProvider>().logout();
              if (context.mounted) {
                context.go('/login');
              }
            },
            child: const Text('Ya, Keluar'),
          ),
        ],
      ),
    );
  }

  Widget _buildStatTile({
    required String title,
    required String value,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8E3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF72827C),
                ),
              ),
              Icon(icon, size: 16, color: const Color(0xFF196B4A)),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: Color(0xFF17352B),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSpecRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 12, color: Color(0xFF72827C)),
          ),
          Text(
            value,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Color(0xFF17352B)),
          ),
        ],
      ),
    );
  }
}
