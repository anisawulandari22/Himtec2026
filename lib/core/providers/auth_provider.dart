import 'dart:math';
import 'package:flutter/foundation.dart';
import '../../models/user_model.dart';
import '../services/storage_service.dart';

class AuthProvider extends ChangeNotifier {
  UserModel? _currentUser;
  bool _isLoading = false;
  String? _errorMessage;

  UserModel? get currentUser => _currentUser;
  bool get isAuthenticated => _currentUser != null;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  AuthProvider() {
    initAuth();
  }

  Future<void> initAuth() async {
    _isLoading = true;
    notifyListeners();

    try {
      final savedUser = await StorageService.getUser();
      if (savedUser != null) {
        _currentUser = savedUser;
      }
    } catch (_) {
      _currentUser = null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> loginWithEmail({
    required String email,
    required String password,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await Future.delayed(const Duration(milliseconds: 600));

      if (email.trim().isEmpty || !email.contains('@')) {
        _errorMessage = 'Format email tidak valid';
        _isLoading = false;
        notifyListeners();
        return false;
      }

      if (password.length < 6) {
        _errorMessage = 'Password minimal harus 6 karakter';
        _isLoading = false;
        notifyListeners();
        return false;
      }

      // Extract user display name from email
      final namePrefix = email.split('@').first.replaceAll('.', ' ');
      final words = namePrefix.split(' ').map((w) => w.isNotEmpty ? '${w[0].toUpperCase()}${w.substring(1)}' : '').join(' ');
      final displayName = words.isNotEmpty ? words : 'Petani Mandiri';

      final user = UserModel(
        id: 'agl_usr_${DateTime.now().millisecondsSinceEpoch}',
        name: displayName,
        email: email.trim().toLowerCase(),
        photoUrl: 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=300',
        sector: 'Pertanian & Peternakan',
        provider: 'email',
        memberId: 'AGL-ID-${Random().nextInt(9000) + 1000}-IDN',
        createdAt: DateTime.now().toIso8601String(),
      );

      await StorageService.saveUser(user);
      _currentUser = user;
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'Gagal masuk: ${e.toString()}';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> registerWithEmail({
    required String name,
    required String email,
    required String password,
    required String sector,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await Future.delayed(const Duration(milliseconds: 700));

      if (name.trim().isEmpty) {
        _errorMessage = 'Nama lengkap wajib diisi';
        _isLoading = false;
        notifyListeners();
        return false;
      }

      if (email.trim().isEmpty || !email.contains('@')) {
        _errorMessage = 'Format email tidak valid';
        _isLoading = false;
        notifyListeners();
        return false;
      }

      if (password.length < 6) {
        _errorMessage = 'Password minimal 6 karakter';
        _isLoading = false;
        notifyListeners();
        return false;
      }

      final user = UserModel(
        id: 'agl_usr_${DateTime.now().millisecondsSinceEpoch}',
        name: name.trim(),
        email: email.trim().toLowerCase(),
        photoUrl: 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=300',
        sector: sector,
        provider: 'email',
        memberId: 'AGL-ID-${Random().nextInt(9000) + 1000}-IDN',
        createdAt: DateTime.now().toIso8601String(),
      );

      await StorageService.saveUser(user);
      _currentUser = user;
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'Gagal mendaftar: ${e.toString()}';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> loginWithGoogle({
    String? selectedEmail,
    String? selectedName,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await Future.delayed(const Duration(milliseconds: 800));

      final email = selectedEmail ?? 'luna.teguh@agl.id';
      final name = selectedName ?? 'Luna Teguh';

      final user = UserModel(
        id: 'agl_google_${DateTime.now().millisecondsSinceEpoch}',
        name: name,
        email: email,
        photoUrl: 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=300',
        sector: 'Pertanian & Peternakan',
        provider: 'google',
        memberId: 'AGL-GOOG-8829-IDN',
        createdAt: DateTime.now().toIso8601String(),
      );

      await StorageService.saveUser(user);
      _currentUser = user;
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'Gagal masuk dengan Google: ${e.toString()}';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> logout() async {
    _isLoading = true;
    notifyListeners();

    await StorageService.clearUser();
    _currentUser = null;
    _isLoading = false;
    notifyListeners();
  }
}
