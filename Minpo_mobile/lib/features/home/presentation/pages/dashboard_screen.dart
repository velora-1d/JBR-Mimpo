import 'dart:ui';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jbr_mimpo/core/theme/app_colors.dart';
import 'package:jbr_mimpo/core/theme/app_dimensions.dart';
import 'package:jbr_mimpo/core/widgets/shimmer_loader.dart';
import 'package:jbr_mimpo/features/info/presentation/pages/information_screen.dart';
import 'package:jbr_mimpo/features/promo/presentation/pages/promo_screen.dart';
import 'package:jbr_mimpo/features/support/presentation/pages/support_screen.dart';
import 'package:jbr_mimpo/features/account/presentation/pages/profile_screen.dart';
import 'package:go_router/go_router.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _currentIndex = 0;
  bool _isLoading = true;
  
  // Banner state
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
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Stack(
        children: [
          // Main Content Area
          _currentIndex == 0 
            ? _buildHomeContent() 
            : _currentIndex == 1 
              ? const SafeArea(child: InformationScreen())
              : _currentIndex == 2
                ? const PromoScreen()
                : _currentIndex == 3
                  ? const SupportScreen()
                  : const SafeArea(child: ProfileScreen()),

          // Custom Top Header (Floating) - Only show on Home
          if (_currentIndex == 0) _buildFloatingHeader(),

          // Floating Chat Button
          _buildFloatingChatButton(),

          // Custom Bottom Navigation
          _buildBottomNav(),
        ],
      ),
    );
  }

  Widget _buildHomeContent() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.only(top: 100, bottom: 120),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Promo Banner
          _buildPromoBanner(),

          const SizedBox(height: 24),

          // 2. Active Status Section
          _buildStatusSection(),

          const SizedBox(height: 24),

          // 3. Quick Actions Grid
          _buildQuickActions(),

          const SizedBox(height: 24),

          // 4. News/Announcement Slider
          _buildNewsSlider(),
        ],
      ),
    );
  }

  Widget _buildFloatingHeader() {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: Container(
        height: 100,
        padding: const EdgeInsets.fromLTRB(20, 40, 20, 0),
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            )
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
                  style: GoogleFonts.sora(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: AppColors.primary,
                    letterSpacing: -1,
                  ),
                ),
                Text(
                  'Halo, Ahmad 👋',
                  style: GoogleFonts.dmSans(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              ],
            ),
            GestureDetector(
              onTap: () => context.push('/notifications'),
              child: Stack(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
                      border: Border.all(color: Theme.of(context).dividerColor.withValues(alpha: 0.1)),
                    ),
                    child: const Icon(Icons.notifications_none_rounded, color: AppColors.primary, size: 24),
                  ),
                  Positioned(
                    top: 10,
                    right: 10,
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                        border: Border.all(color: Theme.of(context).scaffoldBackgroundColor, width: 2),
                      ),
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
    if (_isLoading) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: ShimmerLoader(width: double.infinity, height: 160, borderRadius: 24),
      );
    }
    
    final promos = [
      {'title': 'Diskon Paket 50%', 'desc': 'Upgrade kecepatan internetmu hari ini!'},
      {'title': 'Cashback 20%', 'desc': 'Bayar tagihan lebih hemat bulan ini.'},
      {'title': 'Gratis Router', 'desc': 'Untuk pelanggan baru paket Ultimate.'},
      {'title': 'Poin Ganda', 'desc': 'Kumpulkan poin lebih cepat khusus weekend.'},
      {'title': 'Referral Bonus', 'desc': 'Ajak teman dan dapatkan saldo Rp50.000.'},
    ];

    return Column(
      children: [
        SizedBox(
          height: 160,
          child: PageView.builder(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentBannerIndex = index;
              });
            },
            itemCount: promos.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () => setState(() => _currentIndex = 2),
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(AppDimensions.radiusCard),
                    gradient: LinearGradient(
                      colors: [
                        AppColors.primary.withValues(alpha: 1 - (index * 0.1)), 
                        const Color(0xFF059669)
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.3),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      )
                    ],
                  ),
                  child: Stack(
                    children: [
                      Positioned(
                        right: -20,
                        top: -20,
                        child: Opacity(
                          opacity: 0.2,
                          child: Container(
                            width: 150,
                            height: 150,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ).animate(onPlay: (c) => c.repeat(reverse: true)).scale(
                                duration: 3.seconds,
                                begin: const Offset(1, 1),
                                end: const Offset(1.3, 1.3),
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
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                'PROMO TERBATAS',
                                style: GoogleFonts.jetBrainsMono(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              promos[index]['title']!,
                              style: GoogleFonts.sora(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                letterSpacing: -0.5,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              promos[index]['desc']!,
                              style: GoogleFonts.dmSans(
                                fontSize: 12,
                                color: Colors.white.withValues(alpha: 0.9),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ).animate().fadeIn().slideY(begin: 0.1),
        const SizedBox(height: 12),
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
    if (_isLoading) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          children: [
            Expanded(child: ShimmerLoader(width: double.infinity, height: 100, borderRadius: 20)),
            const SizedBox(width: 16),
            Expanded(child: ShimmerLoader(width: double.infinity, height: 100, borderRadius: 20)),
          ],
        ),
      );
    }
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Layanan Saya',
            style: GoogleFonts.sora(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 16),
          GestureDetector(
            onTap: () => context.push('/package-detail'),
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: Theme.of(context).dividerColor.withValues(alpha: 0.05)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.02),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  )
                ],
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'STATUS PAKET AKTIF',
                            style: GoogleFonts.jetBrainsMono(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
                              letterSpacing: 1,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Family Plan',
                            style: GoogleFonts.sora(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.circle, color: AppColors.primary, size: 8).animate(onPlay: (c) => c.repeat()).fade(duration: 1.seconds),
                            const SizedBox(width: 6),
                            Text(
                              'AKTIF',
                              style: GoogleFonts.jetBrainsMono(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Divider(color: Theme.of(context).dividerColor.withValues(alpha: 0.05), height: 1),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      _buildStatusItem(Icons.speed_rounded, 'Kecepatan', '50 Mbps', Colors.green),
                      const SizedBox(width: 12),
                      _buildStatusItem(Icons.cloud_download_rounded, 'Sisa Kuota', 'UNLIMITED', Colors.blue),
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

  Widget _buildStatusItem(IconData icon, String label, String value, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 12),
            Text(
              label.toUpperCase(),
              style: GoogleFonts.jetBrainsMono(
                fontSize: 9,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
              ),
            ),
            const SizedBox(height: 2),
            Text(
              value,
              style: GoogleFonts.sora(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActions() {
    if (_isLoading) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          children: [
            Expanded(child: ShimmerLoader(width: double.infinity, height: 100, borderRadius: 24)),
            const SizedBox(width: 16),
            Expanded(child: ShimmerLoader(width: double.infinity, height: 100, borderRadius: 24)),
          ],
        ),
      );
    }
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          _buildActionButton(
            'Lapor Gangguan',
            Icons.report_problem_rounded,
            AppColors.primary,
            Colors.white,
            onTap: () => context.push('/report-issue'),
          ),
          const SizedBox(width: 16),
          _buildActionButton(
            'Lihat Promo',
            Icons.card_giftcard_rounded,
            null,
            AppColors.primary,
            isOutlined: true,
            onTap: () => setState(() => _currentIndex = 2),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(String title, IconData icon, Color? bg, Color text, {bool isOutlined = false, VoidCallback? onTap}) {
    return Expanded(
      child: Container(
        height: 100,
        decoration: BoxDecoration(
          color: isOutlined ? Colors.transparent : bg,
          borderRadius: BorderRadius.circular(AppDimensions.radiusCard),
          border: isOutlined ? Border.all(color: AppColors.primary.withValues(alpha: 0.2), width: 1) : null,
          boxShadow: isOutlined
              ? []
              : [BoxShadow(color: (bg ?? AppColors.primary).withValues(alpha: 0.2), blurRadius: 10, offset: const Offset(0, 6))],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              HapticFeedback.lightImpact();
              onTap?.call();
            },
            borderRadius: BorderRadius.circular(AppDimensions.radiusCard),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: text, size: 32),
                const SizedBox(height: 10),
                Text(
                  title,
                  style: GoogleFonts.sora(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: isOutlined ? Theme.of(context).colorScheme.onSurface : text,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNewsSlider() {
    if (_isLoading) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            ShimmerLoader(width: double.infinity, height: 20, borderRadius: 4),
            const SizedBox(height: 16),
            ShimmerLoader(width: double.infinity, height: 120, borderRadius: 20),
          ],
        ),
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Pengumuman Terbaru',
                style: GoogleFonts.sora(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              GestureDetector(
                onTap: () => setState(() => _currentIndex = 1),
                child: Text(
                  'Lihat Semua',
                  style: GoogleFonts.dmSans(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 220,
          child: ScrollConfiguration(
            behavior: ScrollConfiguration.of(context).copyWith(
              dragDevices: {
                PointerDeviceKind.touch,
                PointerDeviceKind.mouse,
                PointerDeviceKind.trackpad,
              },
            ),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.only(left: 20),
              physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
              itemCount: 3,
              itemBuilder: (context, index) {
                final newsTitle = index % 2 == 0 
                    ? 'Peningkatan Jaringan Area Jakarta Selatan'
                    : 'Optimalkan Sinyal Wi-Fi di Rumah Anda';
                final newsCategory = index % 2 == 0 ? 'MAINTENANCE' : 'TIPS & TRICK';
                return GestureDetector(
                  onTap: () => context.push('/info-detail', extra: {
                    'title': newsTitle,
                    'category': newsCategory,
                    'date': '5 April 2026',
                    'content': 'Detail informasi $newsTitle.',
                  }),
                  child: Container(
                    width: 280,
                    margin: const EdgeInsets.only(right: 16),
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.02),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        )
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 120,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                            gradient: LinearGradient(
                              colors: index % 2 == 0 
                                  ? [Colors.blue.shade300, Colors.blue.shade600]
                                  : [AppColors.primary, const Color(0xFF059669)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                          ),
                          child: Icon(Icons.hub_rounded, color: Colors.white.withValues(alpha: 0.5), size: 48),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                newsCategory,
                                style: GoogleFonts.jetBrainsMono(
                                  fontSize: 9,
                                  fontWeight: FontWeight.bold,
                                  color: index % 2 == 0 ? Colors.blue : AppColors.primary,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                newsTitle,
                                style: GoogleFonts.sora(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).colorScheme.onSurface,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
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
        ),
      ],
    );
  }

  Widget _buildBottomNav() {
    return Positioned(
      bottom: 24,
      left: 20,
      right: 20,
      child: Container(
        height: 72,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 20,
              offset: const Offset(0, 8),
            )
          ],
          border: Border.all(
            color: Theme.of(context).dividerColor.withValues(alpha: 0.05),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildNavItem(0, Icons.home_rounded, 'Home'),
            _buildNavItem(1, Icons.info_rounded, 'Info'),
            _buildNavItem(2, Icons.local_offer_rounded, 'Promo'),
            _buildNavItem(3, Icons.support_agent_rounded, 'Support'),
            _buildNavItem(4, Icons.person_rounded, 'Akun'),
          ],
        ),
      ),
    );
  }

  Widget _buildFloatingChatButton() {
    return Positioned(
      bottom: 110,
      right: 16,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          FloatingActionButton(
            heroTag: 'chat_cs_fab',
            onPressed: () => context.push('/chat-cs'),
            backgroundColor: AppColors.primary,
            elevation: 4,
            child: const Icon(Icons.chat_bubble_rounded, color: Colors.white),
          ),
          Positioned(
            top: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: AppColors.error,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
              ),
              child: Text(
                '1',
                style: GoogleFonts.dmSans(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ).animate(onPlay: (controller) => controller.repeat())
           .shimmer(duration: 2.seconds, color: Colors.white54),
        ],
      ).animate().scale(delay: 500.ms, duration: 400.ms, curve: Curves.easeOutBack),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label) {
    bool isActive = _currentIndex == index;
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        setState(() => _currentIndex = index);
      },
      child: AnimatedContainer(
        duration: 300.ms,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? AppColors.primary.withValues(alpha: 0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isActive ? AppColors.primary : Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.4),
              size: 24,
            ).animate(target: isActive ? 1 : 0).scale(begin: const Offset(1, 1), end: const Offset(1.1, 1.1)),
            const SizedBox(height: 4),
            Text(
              label,
              style: GoogleFonts.sora(
                fontSize: 10,
                fontWeight: isActive ? FontWeight.bold : FontWeight.w600,
                color: isActive ? AppColors.primary : Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.4),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
