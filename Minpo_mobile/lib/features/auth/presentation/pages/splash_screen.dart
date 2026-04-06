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
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (mounted) {
        context.go('/onboarding');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // 1. Aesthetic Mint Mesh Gradient Background
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.splashWhiteHighlight,
                  AppColors.splashMintLight,
                  AppColors.splashMintSoft,
                ],
              ),
            ),
          ),

          // 2. Decorative Floating Orbs (Aesthetic Elements)
          Positioned(
            top: -100,
            right: -50,
            child: _buildOrb(300, AppColors.primary.withValues(alpha: 0.04)),
          ).animate(onPlay: (c) => c.repeat(reverse: true))
           .moveY(begin: 0, end: 50, duration: 4.seconds, curve: Curves.easeInOut),
          
          Positioned(
            bottom: -50,
            left: -80,
            child: _buildOrb(250, AppColors.primary.withValues(alpha: 0.03)),
          ).animate(onPlay: (c) => c.repeat(reverse: true))
           .moveX(begin: 0, end: 30, duration: 3.seconds, curve: Curves.easeInOut),

          // 3. Subtle Abstract Decorative Lines
          Opacity(
            opacity: 0.04,
            child: CustomPaint(
              size: Size.infinite,
              painter: GridPatternPainter(),
            ),
          ).animate().fadeIn(duration: 1.seconds),

          // 4. Main Content (Centered Logo with Glow)
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    // Dynamic Soft Glow behind Logo
                    Container(
                      width: 200,
                      height: 200,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withValues(alpha: 0.15),
                            blurRadius: 100,
                            spreadRadius: 20,
                          ),
                        ],
                      ),
                    ).animate(onPlay: (controller) => controller.repeat(reverse: true))
                        .scale(begin: const Offset(1, 1), end: const Offset(1.1, 1.1), duration: 2.seconds),
                    
                    // The Brand New Jabbar23 Logo
                    Image.asset(
                      'assets/logo/jabbar_logo.png',
                      width: 320, 
                      height: 320,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) => 
                        // Fallback indicator if file is missing
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.image_not_supported_outlined, color: AppColors.primary, size: 48),
                            const SizedBox(height: 8),
                            Text('Logo Jabbar23', style: GoogleFonts.sora(color: AppColors.primary)),
                          ],
                        ),
                    ).animate()
                     .fadeIn(duration: 600.ms)
                     .scale(begin: const Offset(0.9, 0.9), end: const Offset(1, 1), curve: Curves.easeOutBack),
                  ],
                ),
              ],
            ),
          ),

          // 5. Minimalist Footer
          Positioned(
            bottom: 60,
            left: 0,
            right: 0,
            child: Center(
              child: Column(
                children: [
                  const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 1.5,
                      valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                    ),
                  ).animate().fadeIn(delay: 500.ms),
                  const SizedBox(height: 20),
                  Text(
                    'POWERED BY JABBAR23',
                    style: GoogleFonts.dmSans(
                      fontSize: 9,
                      fontWeight: FontWeight.w800,
                      color: AppColors.primary.withValues(alpha: 0.3),
                      letterSpacing: 4,
                    ),
                  ).animate().fadeIn(delay: 800.ms),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrb(double size, Color color) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
      ),
    );
  }
}

// Custom Painter for Aesthetic Subtle Grid
class GridPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.primary.withValues(alpha: 0.1)
      ..strokeWidth = 0.5;

    const spacing = 50.0;
    for (double i = 0; i < size.width; i += spacing) {
      canvas.drawLine(Offset(i, 0), Offset(i, size.height), paint);
    }
    for (double i = 0; i < size.height; i += spacing) {
      canvas.drawLine(Offset(0, i), Offset(size.width, i), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
