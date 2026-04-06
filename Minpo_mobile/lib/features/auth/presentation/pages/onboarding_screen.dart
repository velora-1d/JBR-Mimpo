import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jbr_mimpo/core/theme/app_colors.dart';

class OnboardingContent {
  final String title;
  final String description;
  final String imageUrl;
  final String technicalHint;

  OnboardingContent({
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.technicalHint,
  });
}

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingContent> _contents = [
    OnboardingContent(
      title: 'Info Gangguan Real-Time',
      description: 'Pantau status jaringan di area kamu secara akurat',
      imageUrl: 'assets/icons/3d/wifi.png',
      technicalHint: 'Precision Protocol v6.2',
    ),
    OnboardingContent(
      title: 'Promo & Reward Eksklusif',
      description: 'Kumpulkan poin setiap bulan dan tukar dengan hadiah menarik',
      imageUrl: 'assets/icons/3d/money.png',
      technicalHint: 'LOYALTY PROGRAM V2.0',
    ),
    OnboardingContent(
      title: 'CS Online 24 Jam',
      description: 'Bantuan teknis kapan saja, solusi cepat langsung dari genggaman',
      imageUrl: 'assets/icons/3d/mobile.png',
      technicalHint: 'Uptime Guarantee 99.9%',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgLight,
      body: Stack(
        children: [
          // 1. PageView Content
          Column(
            children: [
              Expanded(
                flex: 6,
                child: PageView.builder(
                  controller: _pageController,
                  onPageChanged: (index) => setState(() => _currentPage = index),
                  itemCount: _contents.length,
                  itemBuilder: (context, index) {
                    return _buildHeroSection(_contents[index]);
                  },
                ),
              ),
              
              // 2. Bottom Card Content
              Expanded(
                flex: 4,
                child: Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 20,
                        offset: Offset(0, -5),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 40),
                    child: Column(
                      children: [
                        // Title & Desc with Animation on Page Change
                        _buildAnimatedText(index: _currentPage),

                        const Spacer(),

                        // Pagination Dots
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(
                            _contents.length,
                            (index) => _buildDot(index),
                          ),
                        ),

                        const SizedBox(height: 32),

                        // Technical Hint
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: AppColors.bgLight,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.security, color: AppColors.primary, size: 14),
                              const SizedBox(width: 8),
                              Text(
                                _contents[_currentPage].technicalHint,
                                style: GoogleFonts.jetBrainsMono(
                                  fontSize: 10,
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1,
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 32),

                        // Action Button
                        SizedBox(
                          width: double.infinity,
                          height: 56,
                          child: ElevatedButton(
                            onPressed: () {
                              if (_currentPage < _contents.length - 1) {
                                _pageController.nextPage(
                                  duration: 500.ms,
                                  curve: Curves.easeInOut,
                                );
                              } else {
                                context.go('/login');
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              elevation: 8,
                              shadowColor: AppColors.primary.withValues(alpha: 0.3),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            child: Text(
                              _currentPage == _contents.length - 1 ? 'Mulai Sekarang' : 'Lanjut',
                              style: GoogleFonts.sora(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ).animate().scale(begin: const Offset(0.95, 0.95)),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),

          // 3. Skip Button (Top Right) dipindah ke sini agar bisa diklik (z-index atas)
          Positioned(
            top: 60,
            right: 24,
            child: TextButton(
              onPressed: () => context.go('/login'),
              child: Text(
                'Skip',
                style: GoogleFonts.manrope(
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
            ),
          ).animate().fadeIn(delay: 500.ms),
        ],
      ),
    );
  }

  Widget _buildHeroSection(OnboardingContent content) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.primary.withValues(alpha: 0.05),
            Colors.white,
          ],
        ),
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(40.0),
          child: Image.asset(
            content.imageUrl,
            height: 300,
            fit: BoxFit.contain,
          ).animate(key: ValueKey(content.title))
           .fadeIn(duration: 800.ms)
           .slideY(begin: 0.2, end: 0, curve: Curves.easeOutBack)
           .then() // Tunggu animasi masuk selesai
           .animate(onPlay: (controller) => controller.repeat(reverse: true))
           .moveY(begin: -15, end: 15, duration: 2.seconds, curve: Curves.easeInOut),
        ),
      ),
    );
  }

  Widget _buildAnimatedText({required int index}) {
    final content = _contents[index];
    return Column(
      key: ValueKey('text_$index'),
      children: [
        Text(
          content.title,
          textAlign: TextAlign.center,
          style: GoogleFonts.sora(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ).animate().fadeIn(duration: 600.ms).slideY(begin: 0.1, end: 0),
        const SizedBox(height: 12),
        Text(
          content.description,
          textAlign: TextAlign.center,
          style: GoogleFonts.dmSans(
            fontSize: 16,
            color: AppColors.textSecondary,
            height: 1.5,
          ),
        ).animate().fadeIn(delay: 200.ms, duration: 600.ms),
      ],
    );
  }

  Widget _buildDot(int index) {
    bool isActive = _currentPage == index;
    return AnimatedContainer(
      duration: 300.ms,
      margin: const EdgeInsets.only(right: 8),
      height: 8,
      width: isActive ? 24 : 8,
      decoration: BoxDecoration(
        color: isActive ? AppColors.primary : AppColors.primary.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}
