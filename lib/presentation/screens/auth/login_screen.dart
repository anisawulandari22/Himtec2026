import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../core/providers/auth_provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _rememberMe = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleEmailLogin() async {
    if (!_formKey.currentState!.validate()) return;

    final authProvider = context.read<AuthProvider>();
    final success = await authProvider.loginWithEmail(
      email: _emailController.text,
      password: _passwordController.text,
    );

    if (!mounted) return;

    if (success) {
      context.go('/home');
    } else {
      final msg = authProvider.errorMessage ?? 'Gagal masuk. Periksa kembali email dan kata sandi Anda.';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(msg),
          backgroundColor: const Color(0xFFBA1A1A),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  Future<void> _handleGoogleLogin() async {
    final authProvider = context.read<AuthProvider>();

    // Tampilkan opsi pemilih akun Google yang elegan
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
              'Pilih Akun Google',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Color(0xFF17352B)),
            ),
            const SizedBox(height: 4),
            const Text(
              'Pilih akun untuk melanjutkan pendaftaran atau masuk ke AGL',
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

  void _fillDemoAccount() {
    _emailController.text = 'petani.mandiri@agl.id';
    _passwordController.text = 'petani123';
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    return Scaffold(
      backgroundColor: const Color(0xFFFAFBF7),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Logo AGL Brand
                  Center(
                    child: Container(
                      width: 68,
                      height: 68,
                      decoration: BoxDecoration(
                        color: const Color(0xFF104B36),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF104B36).withValues(alpha: 0.2),
                            blurRadius: 18,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.agriculture_rounded,
                          color: Colors.white,
                          size: 36,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Brand Text
                  const Center(
                    child: Text(
                      'AGL',
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 2.0,
                        color: Color(0xFF104B36),
                      ),
                    ),
                  ),
                  const Center(
                    child: Text(
                      'Applied Agriculture & Livestock',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF72827C),
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                  const SizedBox(height: 28),

                  // Card Form
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
                        const Text(
                          'Masuk ke Akun',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF17352B),
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Kelola kebun dan kandang Anda dengan data tersimpan aman.',
                          style: TextStyle(fontSize: 12, color: Color(0xFF72827C)),
                        ),
                        const SizedBox(height: 20),

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
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Email tidak boleh kosong';
                            }
                            if (!value.contains('@')) {
                              return 'Format email tidak valid';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),

                        // Input Password
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
                              onPressed: () {
                                setState(() => _isPasswordVisible = !_isPasswordVisible);
                              },
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
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Kata sandi tidak boleh kosong';
                            }
                            if (value.length < 6) {
                              return 'Kata sandi minimal 6 karakter';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 10),

                        // Remember Me & Forgot Password
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: Checkbox(
                                    value: _rememberMe,
                                    activeColor: const Color(0xFF104B36),
                                    onChanged: (val) => setState(() => _rememberMe = val ?? true),
                                  ),
                                ),
                                const SizedBox(width: 6),
                                const Text(
                                  'Ingat Saya',
                                  style: TextStyle(fontSize: 12, color: Color(0xFF4A554E)),
                                ),
                              ],
                            ),
                            TextButton(
                              onPressed: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Tautan pemulihan kata sandi telah dikirim ke email terdaftar.'),
                                    behavior: SnackBarBehavior.floating,
                                  ),
                                );
                              },
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.zero,
                                minimumSize: Size.zero,
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              ),
                              child: const Text(
                                'Lupa Sandi?',
                                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Color(0xFF196B4A)),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),

                        // Tombol Masuk
                        SizedBox(
                          width: double.infinity,
                          height: 48,
                          child: ElevatedButton(
                            onPressed: auth.isLoading ? null : _handleEmailLogin,
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
                                    'Masuk ke Akun',
                                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800),
                                  ),
                          ),
                        ),
                        const SizedBox(height: 18),

                        // Pembatas Atau
                        Row(
                          children: const [
                            Expanded(child: Divider(color: Color(0xFFE2E8E3))),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              child: Text(
                                'ATAU MASUK DENGAN',
                                style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: Color(0xFF72827C)),
                              ),
                            ),
                            Expanded(child: Divider(color: Color(0xFFE2E8E3))),
                          ],
                        ),
                        const SizedBox(height: 18),

                        // Tombol Masuk dengan Google
                        SizedBox(
                          width: double.infinity,
                          height: 48,
                          child: OutlinedButton(
                            onPressed: auth.isLoading ? null : _handleGoogleLogin,
                            style: OutlinedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: const Color(0xFF17352B),
                              side: const BorderSide(color: Color(0xFFCCD6D0), width: 1.2),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                // Google Official Vector Symbol
                                CustomPaint(
                                  size: const Size(20, 20),
                                  painter: _GoogleIconPainter(),
                                ),
                                const SizedBox(width: 12),
                                const Text(
                                  'Lanjutkan dengan Akun Google',
                                  style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w700),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Quick Demo Autofill Button
                  Center(
                    child: TextButton.icon(
                      onPressed: _fillDemoAccount,
                      icon: const Icon(Icons.flash_on_rounded, size: 16, color: Color(0xFF196B4A)),
                      label: const Text(
                        'Isi Cepat Akun Demo Petani',
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF196B4A)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Link Register
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Belum memiliki akun AGL? ',
                        style: TextStyle(fontSize: 13, color: Color(0xFF72827C)),
                      ),
                      GestureDetector(
                        onTap: () => context.push('/register'),
                        child: const Text(
                          'Daftar Sekarang',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF104B36),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _GoogleIconPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final double w = size.width;
    final double h = size.height;

    // Red
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

    // Blue
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

    // Yellow
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

    // Green
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

