import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/user_model.dart';
import '../../models/crop_model.dart';
import '../../models/livestock_model.dart';
import '../../models/growth_record_model.dart';

class StorageService {
  static const String _keyUser = 'agl_auth_user_json';
  static const String _keyIsLoggedIn = 'agl_auth_is_logged_in';
  static const String _keyCrops = 'agl_crops_list_json';
  static const String _keyLivestock = 'agl_livestock_list_json';
  static const String _keyGrowthRecords = 'agl_growth_records_list_json';
  static const String _keyGeminiApiKey = 'agl_gemini_api_key_str';

  // ===================== AUTH USER STORAGE =====================
  static Future<void> saveUser(UserModel user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyUser, jsonEncode(user.toJson()));
    await prefs.setBool(_keyIsLoggedIn, true);
  }

  static Future<UserModel?> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = prefs.getString(_keyUser);
    if (jsonStr == null || jsonStr.isEmpty) return null;
    try {
      final map = jsonDecode(jsonStr) as Map<String, dynamic>;
      return UserModel.fromJson(map);
    } catch (_) {
      return null;
    }
  }

  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyIsLoggedIn) ?? false;
  }

  static Future<void> clearUser() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyUser);
    await prefs.setBool(_keyIsLoggedIn, false);
  }

  // ===================== CROPS STORAGE =====================
  static Future<void> saveCrops(List<CropModel> crops) async {
    final prefs = await SharedPreferences.getInstance();
    final list = crops.map((c) => c.toJson()).toList();
    await prefs.setString(_keyCrops, jsonEncode(list));
  }

  static Future<List<CropModel>?> getCrops() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = prefs.getString(_keyCrops);
    if (jsonStr == null || jsonStr.isEmpty) return null;
    try {
      final decoded = jsonDecode(jsonStr) as List<dynamic>;
      return decoded.map((item) => CropModel.fromJson(item as Map<String, dynamic>)).toList();
    } catch (_) {
      return null;
    }
  }

  // ===================== LIVESTOCK STORAGE =====================
  static Future<void> saveLivestock(List<LivestockModel> livestock) async {
    final prefs = await SharedPreferences.getInstance();
    final list = livestock.map((l) => l.toJson()).toList();
    await prefs.setString(_keyLivestock, jsonEncode(list));
  }

  static Future<List<LivestockModel>?> getLivestock() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = prefs.getString(_keyLivestock);
    if (jsonStr == null || jsonStr.isEmpty) return null;
    try {
      final decoded = jsonDecode(jsonStr) as List<dynamic>;
      return decoded.map((item) => LivestockModel.fromJson(item as Map<String, dynamic>)).toList();
    } catch (_) {
      return null;
    }
  }

  // ===================== GROWTH RECORDS STORAGE =====================
  static Future<void> saveGrowthRecords(List<GrowthRecordModel> records) async {
    final prefs = await SharedPreferences.getInstance();
    final list = records.map((r) => r.toJson()).toList();
    await prefs.setString(_keyGrowthRecords, jsonEncode(list));
  }

  static Future<List<GrowthRecordModel>?> getGrowthRecords() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = prefs.getString(_keyGrowthRecords);
    if (jsonStr == null || jsonStr.isEmpty) return null;
    try {
      final decoded = jsonDecode(jsonStr) as List<dynamic>;
      return decoded.map((item) => GrowthRecordModel.fromJson(item as Map<String, dynamic>)).toList();
    } catch (_) {
      return null;
    }
  }

  // ===================== GEMINI API KEY STORAGE =====================
  static Future<void> saveGeminiApiKey(String key) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyGeminiApiKey, key.trim());
  }

  static Future<String?> getGeminiApiKey() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyGeminiApiKey);
  }
}

