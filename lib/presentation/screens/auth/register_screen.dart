import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../core/providers/auth_provider.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isPasswordVisible = false;
  bool _isConfirmVisible = false;
  bool _agreeTerms = true;
  String _selectedSector = 'Pertanian & Peternakan';

  final List<String> _sectorOptions = [
    'Pertanian & Peternakan',
    'Pertanian (Kebun)',
    'Peternakan (Kandang)',
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleRegister() async {
    if (!_formKey.currentState!.validate()) return;

    if (!_agreeTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Anda harus menyetujui Syarat & Ketentuan AGL untuk mendaftar.'),
          backgroundColor: Color(0xFFBA1A1A),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    final authProvider = context.read<AuthProvider>();
    final success = await authProvider.registerWithEmail(
      name: _nameController.text,
      email: _emailController.text,
      password: _passwordController.text,
      sector: _selectedSector,
    );

    if (!mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Pendaftaran berhasil! Selamat datang di AGL.'),
          backgroundColor: Color(0xFF104B36),
          behavior: SnackBarBehavior.floating,
        ),
      );
      context.go('/home');
    } else {
      final msg = authProvider.errorMessage ?? 'Gagal mendaftar. Silakan coba kembali.';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(msg),
          backgroundColor: const Color(0xFFBA1A1A),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  Future<void> _handleGoogleRegister() async {
    final authProvider = context.read<AuthProvider>();

    final selected = await showModalBottomSheet<Map<String, String>>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: const Color(0xFFCCD6D0),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Daftar dengan Akun Google',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Color(0xFF17352B)),
            ),
            const SizedBox(height: 4),
            const Text(
              'Data profil dan email akan disinkronkan secara otomatis ke akun AGL Anda',
              style: TextStyle(fontSize: 12, color: Color(0xFF72827C)),
            ),
            const SizedBox(height: 16),
            ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: const BorderSide(color: Color(0xFFE2E8E3)),
              ),
              leading: const CircleAvatar(
                backgroundColor: Color(0xFF196B4A),
                child: Text('LT', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
              title: const Text('Luna Teguh', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
              subtitle: const Text('luna.teguh@agl.id', style: TextStyle(fontSize: 12)),
              trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 14),
              onTap: () => Navigator.pop(ctx, {'name': 'Luna Teguh', 'email': 'luna.teguh@agl.id'}),
            ),
            const SizedBox(height: 10),
            ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: const BorderSide(color: Color(0xFFE2E8E3)),
              ),
              leading: const CircleAvatar(
                backgroundColor: Color(0xFF285E61),
                child: Text('AG', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
              title: const Text('Agro Mandiri', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
              subtitle: const Text('agromandiri.farm@gmail.com', style: TextStyle(fontSize: 12)),
              trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 14),
              onTap: () => Navigator.pop(ctx, {'name': 'Agro Mandiri', 'email': 'agromandiri.farm@gmail.com'}),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );

    if (selected == null) return;

    final success = await authProvider.loginWithGoogle(
      selectedName: selected['name'],
      selectedEmail: selected['email'],
    );

    if (!mounted) return;

    if (success) {
      context.go('/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    return Scaffold(
      backgroundColor: const Color(0xFFFAFBF7),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Color(0xFF17352B)),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Header
                  const Text(
                    'Pendaftaran Akun Baru',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF104B36),
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Daftar akun AGL agar riwayat kebun, ternak, dan kalkulator pasar tersimpan permanen.',
                    style: TextStyle(fontSize: 12.5, color: Color(0xFF72827C)),
                  ),
                  const SizedBox(height: 22),

                  // Form Container
                  Container(
                    padding: const EdgeInsets.all(22),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: const Color(0xFFE2E8E3)),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF104B36).withValues(alpha: 0.04),
                          blurRadius: 16,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Input Nama Lengkap
                        const Text(
                          'Nama Lengkap',
                          style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w700, color: Color(0xFF4A554E)),
                        ),
                        const SizedBox(height: 6),
                        TextFormField(
                          controller: _nameController,
                          textCapitalization: TextCapitalization.words,
                          decoration: InputDecoration(
                            hintText: 'Contoh: Budi Santoso',
                            prefixIcon: const Icon(Icons.person_outline_rounded, size: 20, color: Color(0xFF72827C)),
                            filled: true,
                            fillColor: const Color(0xFFFAFBF7),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(color: Color(0xFFE2E8E3)),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(color: Color(0xFFE2E8E3)),
                            ),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                          ),
                          validator: (val) {
                            if (val == null || val.trim().isEmpty) return 'Nama lengkap wajib diisi';
                            return null;
                          },
                        ),
                        const SizedBox(height: 14),

                        // Input Email
                        const Text(
                          'Alamat Email',
                          style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w700, color: Color(0xFF4A554E)),
                        ),
                        const SizedBox(height: 6),
                        TextFormField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            hintText: 'nama@domain.com',
                            prefixIcon: const Icon(Icons.email_outlined, size: 20, color: Color(0xFF72827C)),
                            filled: true,
                            fillColor: const Color(0xFFFAFBF7),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(color: Color(0xFFE2E8E3)),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(color: Color(0xFFE2E8E3)),
                            ),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                          ),
                          validator: (val) {
                            if (val == null || val.trim().isEmpty) return 'Email wajib diisi';
                            if (!val.contains('@')) return 'Format email tidak valid';
                            return null;
                          },
                        ),
                        const SizedBox(height: 14),

                        // Pilihan Sektor Usaha
                        const Text(
                          'Sektor Usaha',
                          style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w700, color: Color(0xFF4A554E)),
                        ),
                        const SizedBox(height: 6),
                        DropdownButtonFormField<String>(
                          initialValue: _selectedSector,
                          decoration: InputDecoration(
                            prefixIcon: const Icon(Icons.domain_rounded, size: 20, color: Color(0xFF72827C)),
                            filled: true,
                            fillColor: const Color(0xFFFAFBF7),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(color: Color(0xFFE2E8E3)),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(color: Color(0xFFE2E8E3)),
                            ),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                          ),
                          items: _sectorOptions.map((sec) {
                            return DropdownMenuItem(
                              value: sec,
                              child: Text(sec, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                            );
                          }).toList(),
                          onChanged: (val) {
                            if (val != null) setState(() => _selectedSector = val);
                          },
                        ),
                        const SizedBox(height: 14),

                        // Input Kata Sandi
                        const Text(
                          'Kata Sandi',
                          style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w700, color: Color(0xFF4A554E)),
                        ),
                        const SizedBox(height: 6),
                        TextFormField(
                          controller: _passwordController,
                          obscureText: !_isPasswordVisible,
                          decoration: InputDecoration(
                            hintText: 'Minimal 6 karakter',
                            prefixIcon: const Icon(Icons.lock_outline_rounded, size: 20, color: Color(0xFF72827C)),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _isPasswordVisible ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                                size: 20,
                                color: const Color(0xFF72827C),
                              ),
                              onPressed: () => setState(() => _isPasswordVisible = !_isPasswordVisible),
                            ),
                            filled: true,
                            fillColor: const Color(0xFFFAFBF7),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(color: Color(0xFFE2E8E3)),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(color: Color(0xFFE2E8E3)),
                            ),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                          ),
                          validator: (val) {
                            if (val == null || val.isEmpty) return 'Kata sandi wajib diisi';
                            if (val.length < 6) return 'Minimal 6 karakter';
                            return null;
                          },
                        ),
                        const SizedBox(height: 14),

                        // Konfirmasi Kata Sandi
                        const Text(
                          'Konfirmasi Kata Sandi',
                          style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w700, color: Color(0xFF4A554E)),
                        ),
                        const SizedBox(height: 6),
                        TextFormField(
                          controller: _confirmPasswordController,
                          obscureText: !_isConfirmVisible,
                          decoration: InputDecoration(
                            hintText: 'Ulangi kata sandi',
                            prefixIcon: const Icon(Icons.lock_outline_rounded, size: 20, color: Color(0xFF72827C)),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _isConfirmVisible ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                                size: 20,
                                color: const Color(0xFF72827C),
                              ),
                              onPressed: () => setState(() => _isConfirmVisible = !_isConfirmVisible),
                            ),
                            filled: true,
                            fillColor: const Color(0xFFFAFBF7),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(color: Color(0xFFE2E8E3)),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(color: Color(0xFFE2E8E3)),
                            ),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                          ),
                          validator: (val) {
                            if (val != _passwordController.text) {
                              return 'Kata sandi tidak cocok';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 14),

                        // Checkbox Ketentuan
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: 24,
                              height: 24,
                              child: Checkbox(
                                value: _agreeTerms,
                                activeColor: const Color(0xFF104B36),
                                onChanged: (val) => setState(() => _agreeTerms = val ?? true),
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Expanded(
                              child: Text(
                                'Saya menyetujui Ketentuan Layanan dan Kebijakan Privasi penyimpanan data AGL.',
                                style: TextStyle(fontSize: 11.5, color: Color(0xFF56625D), height: 1.3),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),

                        // Tombol Buat Akun
                        SizedBox(
                          width: double.infinity,
                          height: 48,
                          child: ElevatedButton(
                            onPressed: auth.isLoading ? null : _handleRegister,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF104B36),
                              foregroundColor: Colors.white,
                              elevation: 0,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                            child: auth.isLoading
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                                  )
                                : const Text(
                                    'Daftar Akun AGL',
                                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800),
                                  ),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Pembatas Atau
                        const Row(
                          children: [
                            Expanded(child: Divider(color: Color(0xFFE2E8E3))),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              child: Text(
                                'ATAU DAFTAR DENGAN',
                                style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: Color(0xFF72827C)),
                              ),
                            ),
                            Expanded(child: Divider(color: Color(0xFFE2E8E3))),
                          ],
                        ),
                        const SizedBox(height: 16),

                        // Tombol Google
                        SizedBox(
                          width: double.infinity,
                          height: 48,
                          child: OutlinedButton(
                            onPressed: auth.isLoading ? null : _handleGoogleRegister,
                            style: OutlinedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: const Color(0xFF17352B),
                              side: const BorderSide(color: Color(0xFFCCD6D0), width: 1.2),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CustomPaint(
                                  size: const Size(20, 20),
                                  painter: _GoogleLogoPainter(),
                                ),
                                const SizedBox(width: 12),
                                const Text(
                                  'Daftar Cepat dengan Akun Google',
                                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),

                  // Footer Sudah punya akun
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Sudah memiliki akun AGL? ',
                        style: TextStyle(fontSize: 13, color: Color(0xFF72827C)),
                      ),
                      GestureDetector(
                        onTap: () => context.pop(),
                        child: const Text(
                          'Masuk Sekarang',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF104B36),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _GoogleLogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final double w = size.width;
    final double h = size.height;

    final Paint redPaint = Paint()..color = const Color(0xFFEA4335);
    final Path redPath = Path()
      ..moveTo(w * 0.5, h * 0.2)
      ..cubicTo(w * 0.65, h * 0.2, w * 0.75, h * 0.26, w * 0.83, h * 0.33)
      ..lineTo(w * 0.98, h * 0.18)
      ..cubicTo(w * 0.86, h * 0.07, w * 0.69, 0, w * 0.5, 0)
      ..cubicTo(w * 0.31, 0, w * 0.14, h * 0.11, w * 0.06, h * 0.27)
      ..lineTo(w * 0.24, h * 0.41)
      ..cubicTo(w * 0.28, h * 0.29, w * 0.38, h * 0.2, w * 0.5, h * 0.2);
    canvas.drawPath(redPath, redPaint);

    final Paint bluePaint = Paint()..color = const Color(0xFF4285F4);
    final Path bluePath = Path()
      ..moveTo(w * 0.98, h * 0.5)
      ..cubicTo(w * 0.98, h * 0.46, w * 0.97, h * 0.42, w * 0.96, h * 0.38)
      ..lineTo(w * 0.5, h * 0.38)
      ..lineTo(w * 0.5, h * 0.6)
      ..lineTo(w * 0.77, h * 0.6)
      ..cubicTo(w * 0.76, h * 0.68, w * 0.71, h * 0.74, w * 0.64, h * 0.79)
      ..lineTo(w * 0.82, h * 0.93)
      ..cubicTo(w * 0.92, h * 0.84, w * 0.98, h * 0.69, w * 0.98, h * 0.5);
    canvas.drawPath(bluePath, bluePaint);

    final Paint yellowPaint = Paint()..color = const Color(0xFFFBBC05);
    final Path yellowPath = Path()
      ..moveTo(w * 0.06, h * 0.27)
      ..cubicTo(w * 0.02, h * 0.34, 0, h * 0.42, 0, h * 0.5)
      ..cubicTo(0, h * 0.58, w * 0.02, h * 0.66, w * 0.06, h * 0.73)
      ..lineTo(w * 0.24, h * 0.59)
      ..cubicTo(w * 0.23, h * 0.56, w * 0.22, h * 0.53, w * 0.22, h * 0.5)
      ..cubicTo(w * 0.22, h * 0.47, w * 0.23, h * 0.44, w * 0.24, h * 0.41)
      ..lineTo(w * 0.06, h * 0.27);
    canvas.drawPath(yellowPath, yellowPaint);

    final Paint greenPaint = Paint()..color = const Color(0xFF34A853);
    final Path greenPath = Path()
      ..moveTo(w * 0.5, h)
      ..cubicTo(w * 0.69, h, w * 0.85, h * 0.94, w * 0.96, h * 0.82)
      ..lineTo(w * 0.78, h * 0.68)
      ..cubicTo(w * 0.71, h * 0.73, w * 0.62, h * 0.78, w * 0.5, h * 0.78)
      ..cubicTo(w * 0.38, h * 0.78, w * 0.28, h * 0.7, w * 0.24, h * 0.59)
      ..lineTo(w * 0.06, h * 0.73)
      ..cubicTo(w * 0.14, h * 0.89, w * 0.31, h, w * 0.5, h);
    canvas.drawPath(greenPath, greenPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

