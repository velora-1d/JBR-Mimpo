import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:jbr_mimpo/core/theme/app_colors.dart';
import 'package:jbr_mimpo/core/widgets/shimmer_loader.dart';
import 'package:go_router/go_router.dart';
import '../../../promo/presentation/providers/promo_provider.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  bool _isLoading = true;
  late final PageController _pageController;
  int _currentBannerIndex = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _startBannerTimer();
    _loadData();
  }

  void _startBannerTimer() {
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (_pageController.hasClients) {
        int nextIndex = _currentBannerIndex + 1;
        if (nextIndex >= 5) nextIndex = 0;
        _pageController.animateToPage(
          nextIndex,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    await Future.delayed(const Duration(seconds: 1));
    if (mounted) setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgLight,
      body: Stack(
        children: [
          _buildHomeContent(),
          _buildFloatingHeader(),
          _buildFloatingChatButton(),
        ],
      ),
    );
  }

  Widget _buildHomeContent() {
    return RefreshIndicator(
      color: AppColors.primary,
      onRefresh: () async {
        await ref.read(promoListProvider.notifier).refresh();
        if (mounted) setState(() {});
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
        padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top + 80, bottom: 120),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildPromoBanner(),
            const SizedBox(height: 24),
            _buildStatusSection(),
            const SizedBox(height: 24),
            _buildQuickActions(),
            const SizedBox(height: 24),
            _buildNewsSlider(),
          ],
        ),
      ),
    );
  }

  Widget _buildFloatingHeader() {
    final topPadding = MediaQuery.of(context).padding.top;
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: EdgeInsets.fromLTRB(20, topPadding + 10, 20, 10),
        decoration: BoxDecoration(
          color: AppColors.bgLight,
          boxShadow: [
            BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, 2))
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'JBR Minpo',
                  style: GoogleFonts.sora(fontSize: 18, fontWeight: FontWeight.w800, color: AppColors.primary, letterSpacing: -1),
                ),
                Text('Halo, Ahmad 👋', style: GoogleFonts.dmSans(fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.textPrimary)),
              ],
            ),
            GestureDetector(
              onTap: () => context.push('/home/notifications'),
              child: Stack(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade100),
                    ),
                    child: const Icon(Icons.notifications_none_rounded, color: AppColors.primary, size: 24),
                  ),
                  Positioned(
                    top: 10,
                    right: 10,
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(color: Colors.red, shape: BoxShape.circle, border: Border.all(color: Colors.white, width: 2)),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPromoBanner() {
    final promoAsync = ref.watch(promoListProvider);

    return promoAsync.when(
      data: (promos) => _buildPromoCarousel(promos),
      loading: () => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: const ShimmerLoader(width: double.infinity, height: 160, borderRadius: 24),
      ),
      error: (err, stack) => const SizedBox.shrink(),
    );
  }

  Widget _buildPromoCarousel(List promos) {

    return Column(
      children: [
        SizedBox(
          height: 180,
          child: PageView.builder(
            controller: _pageController,
            onPageChanged: (index) => setState(() => _currentBannerIndex = index),
            itemCount: promos.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () => StatefulNavigationShell.of(context).goBranch(2), // Go to Promo Tab
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  clipBehavior: Clip.hardEdge,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(color: AppColors.primary.withValues(alpha: 0.15), blurRadius: 20, offset: const Offset(0, 10))
                    ],
                  ),
                  child: Stack(
                    children: [
                      // Background Image
                      Positioned.fill(
                        child: CachedNetworkImage(
                          imageUrl: (promos[index] as dynamic).imageUrl,
                          fit: BoxFit.cover,
                          color: Colors.black.withValues(alpha: 0.4),
                          colorBlendMode: BlendMode.darken,
                        ),
                      ),
                      // Gradient overlay
                      Positioned.fill(
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                              colors: [
                                Colors.black.withValues(alpha: 0.8),
                                Colors.transparent,
                              ],
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text('PROMO SPESIAL', style: GoogleFonts.jetBrainsMono(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white)),
                            ),
                            const SizedBox(height: 12),
                            Text((promos[index] as dynamic).title, style: GoogleFonts.sora(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white, height: 1.2)),
                            const SizedBox(height: 8),
                            Text((promos[index] as dynamic).description, style: GoogleFonts.dmSans(fontSize: 13, color: Colors.white.withValues(alpha: 0.9), height: 1.4), maxLines: 2, overflow: TextOverflow.ellipsis),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            promos.length,
            (index) => AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.symmetric(horizontal: 4),
              height: 6,
              width: _currentBannerIndex == index ? 24 : 6,
              decoration: BoxDecoration(
                color: _currentBannerIndex == index ? AppColors.primary : Colors.grey.shade300, 
                borderRadius: BorderRadius.circular(3),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatusSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Layanan Saya', style: GoogleFonts.sora(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
          const SizedBox(height: 16),
          GestureDetector(
            onTap: () => context.push('/home/package-detail'),
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 20, offset: const Offset(0, 10))],
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('STATUS PAKET AKTIF', style: GoogleFonts.jetBrainsMono(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey)),
                          const SizedBox(height: 4),
                          Text('Family Plan', style: GoogleFonts.sora(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(20)),
                        child: Text('AKTIF', style: GoogleFonts.jetBrainsMono(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.primary)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildMiniInfo('KADALUWARSA', '24 Mar 2026'),
                      _buildMiniInfo('KECEPATAN', '50 Mbps'),
                      _buildMiniInfo('TAGIHAN', 'Rp 299rb'),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMiniInfo(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: GoogleFonts.jetBrainsMono(fontSize: 9, color: Colors.grey)),
        Text(value, style: GoogleFonts.dmSans(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
      ],
    );
  }

  Widget _buildQuickActions() {
    final actions = [
      {'icon': Icons.flash_on_rounded, 'label': 'Upgrade', 'color': Colors.orange, 'route': '/home/upgrade-package'},
      {'icon': Icons.language_rounded, 'label': 'Status', 'color': Colors.blue, 'route': '/info/network-status'},
      {'icon': Icons.support_agent_rounded, 'label': 'Bantuan', 'color': Colors.purple, 'route': '/support'},
      {'icon': Icons.history_rounded, 'label': 'Riwayat', 'color': Colors.green, 'route': '/support/ticket-tracking'},
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: actions.map((act) => _buildActionIcon(act)).toList(),
      ),
    );
  }

  Widget _buildActionIcon(Map<String, dynamic> act) {
    return GestureDetector(
      onTap: () => context.push(act['route']),
      child: Column(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(color: (act['color'] as Color).withValues(alpha: 0.1), borderRadius: BorderRadius.circular(20)),
            child: Icon(act['icon'] as IconData, color: act['color'] as Color, size: 28),
          ),
          const SizedBox(height: 8),
          Text(act['label'], style: GoogleFonts.dmSans(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textSecondary)),
        ],
      ),
    );
  }

  Widget _buildNewsSlider() {
    if (_isLoading) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: ShimmerLoader(width: double.infinity, height: 150, borderRadius: 24),
      );
    }
    
    final news = [
      {
        'title': 'Kabel Laut Terputus di Area Jawa',
        'desc': 'Estimasi perbaikan memakan waktu 2x24 jam. Kami mohon maaf atas ketidaknyamanan ini.',
        'tag': 'Gangguan',
        'color': Colors.red,
        'icon': Icons.warning_amber_rounded,
        'date': '24 Okt 2026',
        'imageUrl': 'https://images.unsplash.com/photo-1620288627223-53302f4e8c74?q=80&w=600&auto=format&fit=crop',
      },
      {
        'title': 'Maintenance JKT Selatan',
        'desc': 'Peningkatan kapasitas untuk stabilitas koneksi jaringan.',
        'tag': 'Maintenance',
        'color': Colors.blue,
        'icon': Icons.build_rounded,
        'date': '22 Okt 2026',
        'imageUrl': 'https://images.unsplash.com/photo-1544197150-b99a580bb7a8?q=80&w=600&auto=format&fit=crop',
      },
      {
        'title': 'Promo Upgrade 100Mbps',
        'desc': 'Nikmati kecepatan maksimal dengan harga spesial.',
        'tag': 'Promo',
        'color': AppColors.primary,
        'icon': Icons.speed_rounded,
        'date': '20 Okt 2026',
        'imageUrl': 'https://images.unsplash.com/photo-1451187580459-43490279c0fa?q=80&w=600&auto=format&fit=crop',
      },
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Kabar Minpo',
                style: GoogleFonts.sora(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
              ),
              TextButton(
                onPressed: () => StatefulNavigationShell.of(context).goBranch(1),
                child: Text(
                  'Lihat Semua',
                  style: GoogleFonts.dmSans(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.primary),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Column(
            children: List.generate(news.length, (index) {
              final item = news[index];
              return Container(
                margin: const EdgeInsets.only(bottom: 16),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () => context.push('/info/detail', extra: item),
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 15, offset: const Offset(0, 8))
                        ],
                        border: Border.all(color: Colors.grey.shade100),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Thumbnail
                          Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.only(topLeft: Radius.circular(20), bottomLeft: Radius.circular(20)),
                              color: (item['color'] as Color).withValues(alpha: 0.1),
                              image: DecorationImage(
                                image: CachedNetworkImageProvider(item['imageUrl'] as String),
                                fit: BoxFit.cover,
                                colorFilter: ColorFilter.mode(
                                  Colors.black.withValues(alpha: 0.3),
                                  BlendMode.darken,
                                ),
                              ),
                            ),
                            child: Center(
                              child: Icon(item['icon'] as IconData, color: Colors.white.withValues(alpha: 0.9), size: 32),
                            ),
                          ),
                          const SizedBox(width: 16),
                          // Content
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(0, 16, 16, 16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                        decoration: BoxDecoration(
                                          color: (item['color'] as Color).withValues(alpha: 0.05),
                                          borderRadius: BorderRadius.circular(6),
                                        ),
                                        child: Text(
                                          (item['tag'] as String).toUpperCase(),
                                          style: GoogleFonts.jetBrainsMono(fontSize: 9, fontWeight: FontWeight.bold, color: item['color'] as Color),
                                        ),
                                      ),
                                      Text(
                                        item['date'] as String,
                                        style: GoogleFonts.dmSans(fontSize: 10, color: Colors.grey, fontWeight: FontWeight.w500),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    item['title'] as String,
                                    style: GoogleFonts.sora(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textPrimary, height: 1.2),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ).animate().fadeIn(delay: (index * 100).ms).slideY(begin: 0.1);
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildFloatingChatButton() {
    return Positioned(
      bottom: 90,
      right: 20,
      child: FloatingActionButton(
        onPressed: () => context.push('/support/chat-cs'),
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.chat_bubble_rounded, color: Colors.white),
      ).animate().scale(delay: 1.seconds),
    );
  }
}
