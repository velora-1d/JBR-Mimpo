import 'package:flutter/material.dart';
import 'package:jbr_mimpo/core/cache/cache_manager.dart';
import 'package:jbr_mimpo/core/theme/app_colors.dart';
import '../../domain/models/information_model.dart';

class InformationRepository {
  final CacheManager _cache = CacheManager();

  Future<List<InformationModel>> getInformations() async {
    // 1. Ambil dari Cache
    final cached = _cache.getCachedData('info_list');
    if (cached != null && cached is List) {
      return cached.map((e) => InformationModel.fromJson(e as Map<String, dynamic>)).toList();
    }

    // 2. Fetch Mock Data (Simulasi API)
    final mockData = _getMockInfos();
    await _cache.cacheData('info_list', mockData.map((e) => e.toJson()).toList());
    return mockData;
  }

  List<InformationModel> _getMockInfos() {
    return [
      InformationModel(
        id: '1',
        title: 'Promo Upgrade Kecepatan',
        description: 'Dapatkan upgrade kecepatan hingga 100Mbps dengan harga spesial.',
        category: 'Info Umum',
        time: 'SELAMANYA',
        isPinned: true,
        iconCodePoint: Icons.card_giftcard_rounded.codePoint,
        iconFontFamily: Icons.card_giftcard_rounded.fontFamily!,
        color: AppColors.primary,
      ),
      InformationModel(
        id: '2',
        title: 'Pemeliharaan Jaringan Jakarta Selatan',
        description: 'Peningkatan kapasitas backbone untuk stabilitas.',
        category: 'Maintenance',
        date: 'Kamis, 24 Okt',
        time: '00:00 - 04:00 WIB',
        isPinned: false,
        iconCodePoint: Icons.build_rounded.codePoint,
        iconFontFamily: Icons.build_rounded.fontFamily!,
        color: Colors.blue,
      ),
      InformationModel(
        id: '3',
        title: 'Gangguan Massal Bekasi',
        description: 'Tim teknis sedang melakukan pengecekan kabel backbone.',
        category: 'Gangguan',
        status: 'Sedang Ditangani',
        updateTime: '5 menit lalu',
        isPinned: false,
        iconCodePoint: Icons.warning_amber_rounded.codePoint,
        iconFontFamily: Icons.warning_amber_rounded.fontFamily!,
        color: Colors.red,
      ),
    ];
  }
}
