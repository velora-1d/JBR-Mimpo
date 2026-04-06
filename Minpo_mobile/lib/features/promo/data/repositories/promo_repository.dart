import 'package:flutter/material.dart';
import 'package:jbr_mimpo/core/cache/cache_manager.dart';
import '../../domain/models/promo_model.dart';

class PromoRepository {
  final CacheManager _cache = CacheManager();

  /// Ambil data promo dengan strategi Cache-First
  Future<List<PromoModel>> getPromos() async {
    // 1. Coba ambil dari Cache
    final cached = _cache.getCachedData('promos_aktif');
    if (cached != null && cached is List) {
      return cached.map((e) => PromoModel.fromJson(e as Map<String, dynamic>)).toList();
    }

    // 2. Jika tidak ada, return Mock Data (Simulasi API)
    final mockData = _getMockPromos();
    await _cache.cacheData('promos_aktif', mockData.map((e) => e.toJson()).toList());
    return mockData;
  }

  List<PromoModel> _getMockPromos() {
    return [
      PromoModel(
        id: '1',
        title: 'Turbo Upgrade: Naik ke 100Mbps',
        description: 'Nikmati internet tanpa batas dengan diskon 50% untuk 3 bulan!',
        price: '225.000',
        originalPrice: '450.000',
        timer: '02 : 14 : 55',
        isFlashSale: true,
        color: Colors.blue,
        imageUrl: 'https://images.unsplash.com/photo-1544197150-b99a580bb7a8?q=80&w=2670&auto=format&fit=crop',
      ),
      PromoModel(
        id: '2',
        title: 'Cashback Tagihan Akhir Bulan',
        description: 'Gunakan kode HEMATJBR untuk diskon tagihan sebesar 50rb.',
        price: 'Potongan s/d 50rb',
        isFlashSale: false,
        color: Colors.teal,
        imageUrl: 'https://images.unsplash.com/photo-1559526324-4b87b5e36e44?q=80&w=2671&auto=format&fit=crop',
      ),
      PromoModel(
        id: '3',
        title: 'Voucher Streaming 1 Tahun',
        description: 'Beli paket Fiber Pro dan dapatkan langganan OTT gratis.',
        price: 'Gratis 12 Bulan',
        isFlashSale: false,
        color: Colors.orange,
        imageUrl: 'https://images.unsplash.com/photo-1522869635100-9f4c5e86aa37?q=80&w=2670&auto=format&fit=crop',
      ),
    ];
  }
}
