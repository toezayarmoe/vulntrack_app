import 'dart:collection';
import 'package:shared_preferences/shared_preferences.dart';

class Preferences {
  static SharedPreferences? _prefs;
  static final Map<String, dynamic> _memoryPrefs = HashMap();

  /// Initialize shared preferences (safe to call multiple times)
  static Future<void> init() async {
    if (_prefs != null) return; // Already initialized

    _prefs = await SharedPreferences.getInstance();

    // Load all existing preferences into memory
    final keys = _prefs!.getKeys();
    for (String key in keys) {
      _memoryPrefs[key] = _prefs!.get(key);
    }
  }

  // ================= SETTERS =================
  static Future<bool> setString(String key, String value) async {
    try {
      final success = await _prefs!.setString(key, value);
      if (success) _memoryPrefs[key] = value;
      return success;
    } catch (_) {
      _memoryPrefs[key] = value;
      return false;
    }
  }

  static Future<bool> setInt(String key, int value) async {
    try {
      final success = await _prefs!.setInt(key, value);
      if (success) _memoryPrefs[key] = value;
      return success;
    } catch (_) {
      _memoryPrefs[key] = value;
      return false;
    }
  }

  static Future<bool> setDouble(String key, double value) async {
    try {
      final success = await _prefs!.setDouble(key, value);
      if (success) _memoryPrefs[key] = value;
      return success;
    } catch (_) {
      _memoryPrefs[key] = value;
      return false;
    }
  }

  static Future<bool> setBool(String key, bool value) async {
    try {
      final success = await _prefs!.setBool(key, value);
      if (success) _memoryPrefs[key] = value;
      return success;
    } catch (_) {
      _memoryPrefs[key] = value;
      return false;
    }
  }

  static Future<bool> setStringList(String key, List<String> value) async {
    try {
      final success = await _prefs!.setStringList(key, value);
      if (success) _memoryPrefs[key] = value;
      return success;
    } catch (_) {
      _memoryPrefs[key] = value;
      return false;
    }
  }

  // ================= GETTERS =================
  static String? getString(String key) => _memoryPrefs[key] as String?;
  static int? getInt(String key) => _memoryPrefs[key] as int?;
  static double? getDouble(String key) => _memoryPrefs[key] as double?;
  static bool? getBool(String key) => _memoryPrefs[key] as bool?;
  static List<String>? getStringList(String key) =>
      _memoryPrefs[key] as List<String>?;

  // ================= REMOVE =================
  static Future<bool> remove(String key) async {
    try {
      final success = await _prefs!.remove(key);
      if (success) _memoryPrefs.remove(key);
      return success;
    } catch (_) {
      _memoryPrefs.remove(key);
      return false;
    }
  }

  static Future<void> clear() async {
    try {
      await _prefs!.clear();
    } finally {
      _memoryPrefs.clear();
    }
  }

  static bool containsKey(String key) => _memoryPrefs.containsKey(key);

  static Set<String> getKeys() => _memoryPrefs.keys.toSet();

  static int getCount() => _memoryPrefs.length;
}
