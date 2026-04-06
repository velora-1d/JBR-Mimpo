import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jbr_mimpo/core/theme/app_colors.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToNext();
  }

  void _navigateToNext() {
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        context.go('/onboarding');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 1. Deep Emerald Gradient Background
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppColors.splashGradStart,
                  AppColors.splashGradMid,
                  AppColors.splashGradEnd,
                ],
              ),
            ),
          ),

          // 2. Fiber Optic / Decorative SVG Lines (Simulated with CustomPaint/Container)
          // For now, we use a subtle overlay or ignore for performance unless SVG is ready

          // 3. Main Content
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Mascot 3D Glow Effect
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: 250,
                      height: 250,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withValues(alpha: 0.2),
                            blurRadius: 80,
                            spreadRadius: 20,
                          ),
                        ],
                      ),
                    ).animate(onPlay: (controller) => controller.repeat(reverse: true))
                        .scale(begin: const Offset(1, 1), end: const Offset(1.2, 1.2), duration: 2.seconds),
                    
                    // Mascot Image (Local Logo)
                    Image.asset(
                      'assets/logo/app_logo.png',
                      width: 280,
                      height: 280,
                      fit: BoxFit.contain,
                    ).animate().fadeIn(duration: 800.ms).slideY(begin: 0.1, end: 0),
                  ],
                ),
                
                const SizedBox(height: 48),

                // Branding Section
                Column(
                  children: [
                    Text(
                      'JBR MINPO',
                      style: GoogleFonts.sora(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 8,
                        shadows: [
                          Shadow(
                            color: Colors.white.withValues(alpha: 0.3),
                            blurRadius: 20,
                          ),
                        ],
                      ),
                    ).animate().fadeIn(delay: 400.ms).scale(begin: const Offset(0.95, 0.95)),
                    
                    const SizedBox(height: 8),
                    
                    Text(
                      'PUSAT INFORMASI',
                      style: GoogleFonts.jetBrainsMono(
                        fontSize: 10,
                        color: AppColors.primaryFixedDim.withValues(alpha: 0.8),
                        letterSpacing: 5,
                        fontWeight: FontWeight.w400,
                      ),
                    ).animate().fadeIn(delay: 600.ms),
                  ],
                ),

                const SizedBox(height: 64),

                // Loading System
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Column(
                    children: [
                      // Progress Bar
                      Container(
                        height: 2,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(1),
                        ),
                        child: FractionallySizedBox(
                          alignment: Alignment.centerLeft,
                          widthFactor: 0.75, // 75% as designed
                          child: Container(
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.primary.withValues(alpha: 0.6),
                                  blurRadius: 10,
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                          ).animate().shimmer(duration: 2.seconds, color: Colors.white24),
                        ),
                      ),
                      
                      const SizedBox(height: 16),
                      
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'SABAR YA GANTENG / CANTIK...',
                            style: GoogleFonts.jetBrainsMono(
                              fontSize: 9,
                              color: AppColors.primaryFixedDim.withValues(alpha: 0.6),
                              letterSpacing: 1,
                            ),
                          ),
                          Text(
                            '75%',
                            style: GoogleFonts.jetBrainsMono(
                              fontSize: 10,
                              color: AppColors.primaryFixedDim,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ).animate().fadeIn(delay: 800.ms),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // 4. Bottom Glass Information
          Positioned(
            bottom: 48,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.verified_user_outlined, color: AppColors.primaryFixedDim, size: 14),
                    const SizedBox(width: 8),
                    Text(
                      'REWARD MENUNGGUMU..',
                      style: GoogleFonts.manrope(
                        color: Colors.white.withValues(alpha: 0.7),
                        fontSize: 10,
                        letterSpacing: 2,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ).animate().fadeIn(delay: 1.seconds).slideY(begin: 0.3, end: 0),
        ],
      ),
    );
  }
}
