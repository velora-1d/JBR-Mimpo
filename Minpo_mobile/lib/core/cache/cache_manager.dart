import 'dart:convert';
import 'package:hive_flutter/hive_flutter.dart';

class CacheManager {
  static final CacheManager _instance = CacheManager._internal();
  factory CacheManager() => _instance;

  CacheManager._internal();

  static const String _boxName = 'jbr_minpo_cache';
  late Box _box;

  Future<void> init() async {
    await Hive.initFlutter();
    _box = await Hive.openBox(_boxName);
  }

  /// Simpan data berupa Map/JSON string ke Hive dengan key tertentu
  Future<void> cacheData(String key, dynamic data) async {
    if (data is Map || data is List) {
      await _box.put(key, jsonEncode(data));
    } else {
      await _box.put(key, data);
    }
  }

  /// Ambil data dari Hive. Jika JSON string, akan otomatis di-decode
  dynamic getCachedData(String key) {
    final data = _box.get(key);
    if (data is String) {
      try {
        return jsonDecode(data);
      } catch (e) {
        return data; // Bukan JSON
      }
    }
    return data;
  }

  /// Hapus data berdasarkan key
  Future<void> removeData(String key) async {
    await _box.delete(key);
  }

  /// Bersihkan seluruh cache
  Future<void> clearAll() async {
    await _box.clear();
  }

  /// Cek pakah data ada dan tidak expired (opsional, bisa ditambah TTL)
  bool hasData(String key) => _box.containsKey(key);
}
