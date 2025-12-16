import 'dart:collection';
import 'package:shared_preferences/shared_preferences.dart'; // Ensure this is imported

class Preferences {
  static late final SharedPreferences _prefs;
  static final Map<String, dynamic> _memoryPrefs = HashMap();

  static Future<SharedPreferences> load() async {
    _prefs = await SharedPreferences.getInstance();

    // Load all existing preferences into memory
    final keys = _prefs.getKeys();
    for (String key in keys) {
      _memoryPrefs[key] = _prefs.get(key);
    }

    return _prefs;
  }

  // ============== SETTERS (Async with error handling) ==============
  // FIX: Ensure the signature is Future<bool> and all paths return bool.
  static Future<bool> setString(String key, String value) async {
    try {
      final success = await _prefs.setString(key, value);
      if (success) _memoryPrefs[key] = value;
      return success; // Returns bool on success
    } catch (e) {
      // Fallback logic
      _memoryPrefs[key] = value;
      return false; // Returns bool on disk failure
    }
  }

  static Future<bool> setInt(String key, int value) async {
    try {
      final success = await _prefs.setInt(key, value);
      if (success) _memoryPrefs[key] = value;
      return success;
    } catch (e) {
      _memoryPrefs[key] = value;
      return false;
    }
  }

  static Future<bool> setDouble(String key, double value) async {
    try {
      final success = await _prefs.setDouble(key, value);
      if (success) _memoryPrefs[key] = value;
      return success;
    } catch (e) {
      _memoryPrefs[key] = value;
      return false;
    }
  }

  static Future<bool> setBool(String key, bool value) async {
    try {
      final success = await _prefs.setBool(key, value);
      if (success) _memoryPrefs[key] = value;
      return success;
    } catch (e) {
      _memoryPrefs[key] = value;
      return false;
    }
  }

  static Future<bool> setStringList(String key, List<String> value) async {
    try {
      final success = await _prefs.setStringList(key, value);
      if (success) _memoryPrefs[key] = value;
      return success;
    } catch (e) {
      _memoryPrefs[key] = value;
      return false;
    }
  }

  // ============== GETTERS (Fast memory access) ==============
  static String? getString(String key) => _memoryPrefs[key] as String?;
  static int? getInt(String key) => _memoryPrefs[key] as int?;
  static double? getDouble(String key) => _memoryPrefs[key] as double?;
  static bool? getBool(String key) => _memoryPrefs[key] as bool?;
  static List<String>? getStringList(String key) =>
      _memoryPrefs[key] as List<String>?;

  // ============== REMOVAL ==============
  static Future<bool> remove(String key) async {
    try {
      final success = await _prefs.remove(key);
      if (success) _memoryPrefs.remove(key);
      return success;
    } catch (e) {
      _memoryPrefs.remove(key);
      return false;
    }
  }

  // ============== UTILITY METHODS ==============
  static bool containsKey(String key) => _memoryPrefs.containsKey(key);

  static Set<String> getKeys() => _memoryPrefs.keys.toSet();

  static int getCount() => _memoryPrefs.length;

  static Future<void> clear() async {
    try {
      await _prefs.clear();
    } finally {
      _memoryPrefs.clear();
    }
  }

  // Force refresh from disk (useful for multi-process apps)
  static Future<void> refreshFromDisk() async {
    final keys = _prefs.getKeys();

    // Update existing or add new
    for (String key in keys) {
      _memoryPrefs[key] = _prefs.get(key);
    }

    // Remove keys that no longer exist on disk
    final memoryKeys = _memoryPrefs.keys.toSet();
    for (String key in memoryKeys) {
      if (!_prefs.containsKey(key)) {
        _memoryPrefs.remove(key);
      }
    }
  }

  // ============== TYPE-SAFE GETTERS WITH DEFAULTS ==============
  static String getStringWithDefault(String key, String defaultValue) =>
      getString(key) ?? defaultValue;

  static int getIntWithDefault(String key, int defaultValue) =>
      getInt(key) ?? defaultValue;

  static bool getBoolWithDefault(String key, bool defaultValue) =>
      getBool(key) ?? defaultValue;

  static double getDoubleWithDefault(String key, double defaultValue) =>
      getDouble(key) ?? defaultValue;

  static List<String> getStringListWithDefault(
    String key,
    List<String> defaultValue,
  ) => getStringList(key) ?? defaultValue;

  // ============== BATCH OPERATIONS ==============
  // FIX: This should also return Future<void> or Future<bool> to be consistent.
  // We'll keep it as Future<void> for simplicity.
  static Future<void> setMultiple(Map<String, dynamic> values) async {
    for (final entry in values.entries) {
      final key = entry.key;
      final value = entry.value;

      // Note: We are ignoring the result of setString/setInt/etc. here
      // which is fine for a batch operation that just needs to run.
      if (value is String) {
        await setString(key, value);
      } else if (value is int) {
        await setInt(key, value);
      } else if (value is double) {
        await setDouble(key, value);
      } else if (value is bool) {
        await setBool(key, value);
      } else if (value is List<String>) {
        await setStringList(key, value);
      } else {
        throw ArgumentError(
          'Unsupported type for key $key: ${value.runtimeType}',
        );
      }
    }
  }
}
