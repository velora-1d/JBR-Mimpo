import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jbr_mimpo/core/theme/app_colors.dart';
import 'package:go_router/go_router.dart';
import 'dart:ui';

class PromoDetailScreen extends StatelessWidget {
  final Map<String, dynamic> promo;

  const PromoDetailScreen({super.key, required this.promo});

  @override
  Widget build(BuildContext context) {
    final isFlashSale = promo['tag'] == 'Flash Sale' || promo['tag'] == 'Limited';
    final accentColor = isFlashSale ? const Color(0xFFFF4D4D) : AppColors.primary;

    return Scaffold(
      backgroundColor: AppColors.bgLight,
      body: Stack(
        children: [
          CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              // 1. Premium Image Header
              SliverAppBar(
                expandedHeight: 400,
                pinned: true,
                backgroundColor: AppColors.bgLight,
                elevation: 0,
                leading: _buildCircleAction(context, Icons.arrow_back_rounded, () => context.pop()),
                flexibleSpace: FlexibleSpaceBar(
                  background: Stack(
                    fit: StackFit.expand,
                    children: [
                      _buildMeshPromoHeader(accentColor),
                      
                      // Floating Promo Icon
                      Center(
                        child: Container(
                          padding: const EdgeInsets.all(40),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(promo['icon'] ?? Icons.loyalty_rounded, color: Colors.white, size: 100),
                        ).animate(onPlay: (c) => c.repeat(reverse: true))
                         .scale(begin: const Offset(1,1), end: const Offset(1.1, 1.1), duration: 2.seconds)
                         .rotate(begin: -0.05, end: 0.05),
                      ),

                      // Bottom Gradient Overlay
                      Positioned.fill(
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.transparent,
                                AppColors.bgLight.withValues(alpha: 0.8),
                                AppColors.bgLight,
                              ],
                              stops: const [0.5, 0.8, 1.0],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // 2. Promo Content
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Badge & Title
                      _buildPromoTitleArea(promo, accentColor, isFlashSale),

                      const SizedBox(height: 32),

                      // Description Card
                      _buildDescriptionCard(promo),

                      const SizedBox(height: 32),

                      // Bento Style Terms & Conditions
                      _buildBentoTerms(accentColor),

                      const SizedBox(height: 160), // Space for button
                    ],
                  ),
                ),
              ),
            ],
          ),

          // 3. Floating Bottom Action
          _buildFloatingAction(context, promo, accentColor),
        ],
      ),
    );
  }

  Widget _buildCircleAction(BuildContext context, IconData icon, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.05),
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
            ),
            child: IconButton(icon: Icon(icon, color: AppColors.textPrimary, size: 20), onPressed: onTap),
          ),
        ),
      ),
    );
  }

  Widget _buildMeshPromoHeader(Color color) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [color, color.withValues(alpha: 0.7)],
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            top: -20,
            right: -20,
            child: Icon(Icons.stars_rounded, size: 200, color: Colors.white.withValues(alpha: 0.1)),
          ),
        ],
      ),
    );
  }

  Widget _buildPromoTitleArea(Map<String, dynamic> promo, Color color, bool isFlash) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: color.withValues(alpha: 0.2)),
              ),
              child: Row(
                children: [
                  if (isFlash) 
                    const Icon(Icons.bolt_rounded, size: 16, color: Color(0xFFFF4D4D))
                        .animate(onPlay: (c) => c.repeat())
                        .shimmer(duration: 1500.ms),
                  const SizedBox(width: 4),
                  Text(
                    promo['tag']?.toString().toUpperCase() ?? 'PROMO',
                    style: GoogleFonts.jetBrainsMono(fontSize: 11, fontWeight: FontWeight.w800, color: color),
                  ),
                ],
              ),
            ),
            if (isFlash)
              Text(
                '04 : 22 : 11', // Dummy Timer
                style: GoogleFonts.jetBrainsMono(fontSize: 16, fontWeight: FontWeight.w900, color: color),
              ).animate(onPlay: (c) => c.repeat()).fadeOut(duration: 500.ms, begin: 1.0, curve: Curves.easeIn).fadeIn(),
          ],
        ),
        const SizedBox(height: 20),
        Text(
          promo['title'] ?? 'Kejutan Promo Menarik',
          style: GoogleFonts.sora(fontSize: 32, fontWeight: FontWeight.w900, color: AppColors.textPrimary, height: 1.1),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            const Icon(Icons.event_available_rounded, size: 16, color: Colors.grey),
            const SizedBox(width: 8),
            Text(
              'Berakhir dalam 3 hari lagi',
              style: GoogleFonts.dmSans(fontSize: 14, color: AppColors.textSecondary, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ],
    ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.1);
  }

  Widget _buildDescriptionCard(Map<String, dynamic> promo) {
    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 40, offset: const Offset(0, 10)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Tentang Promo', style: GoogleFonts.sora(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          Text(
            promo['subtitle'] ?? 'Nikmati penawaran eksklusif khusus untuk pelanggan setia JBR Minpo. Tingkatkan pengalaman internet Anda dengan harga yang lebih hemat.',
            style: GoogleFonts.dmSans(fontSize: 15, height: 1.7, color: AppColors.textPrimary.withValues(alpha: 0.7)),
          ),
          const SizedBox(height: 24),
          const Divider(height: 1),
          const SizedBox(height: 24),
          _buildBenefitRow(Icons.check_circle_rounded, 'Hemat hingga 50% untuk Top-Up'),
          const SizedBox(height: 12),
          _buildBenefitRow(Icons.check_circle_rounded, 'Berlaku untuk semua metode pembayaran'),
        ],
      ),
    ).animate().fadeIn(delay: 400.ms);
  }

  Widget _buildBenefitRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.green),
        const SizedBox(width: 12),
        Expanded(child: Text(text, style: GoogleFonts.dmSans(fontSize: 14, fontWeight: FontWeight.bold))),
      ],
    );
  }

  Widget _buildBentoTerms(Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Syarat & Ketentuan', style: GoogleFonts.sora(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 1.5,
          children: [
            _buildBentoItem('Satu Kali Klaim', Icons.person_rounded, color),
            _buildBentoItem('Min. 100 Mbps', Icons.speed_rounded, color),
            _buildBentoItem('User Aktif', Icons.verified_user_rounded, color),
            _buildBentoItem('Area Jakarta', Icons.location_on_rounded, color),
          ],
        ),
      ],
    ).animate().fadeIn(delay: 600.ms);
  }

  Widget _buildBentoItem(String title, IconData icon, Color color) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: color.withValues(alpha: 0.1)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 10),
          Text(title, style: GoogleFonts.dmSans(fontSize: 12, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
        ],
      ),
    );
  }

  Widget _buildFloatingAction(BuildContext context, Map<String, dynamic> promo, Color color) {
    return Positioned(
      bottom: 40,
      left: 24,
      right: 24,
      child: Container(
        height: 80,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(color: color.withValues(alpha: 0.3), blurRadius: 40, offset: const Offset(0, 15)),
          ],
        ),
        child: ElevatedButton(
          onPressed: () {
            _showClaimSuccess(context);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: color,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
            elevation: 0,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.confirmation_num_rounded, size: 24),
              const SizedBox(width: 16),
              Text(
                'Klaim Promo Sekarang',
                style: GoogleFonts.sora(fontWeight: FontWeight.w800, fontSize: 18),
              ),
            ],
          ),
        ),
      ).animate().slideY(begin: 1, delay: 800.ms),
    );
  }

  void _showClaimSuccess(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => Center(
        child: Container(
          width: 320,
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(40)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: const BoxDecoration(color: Color(0xFFE8F5E9), shape: BoxShape.circle),
                child: const Icon(Icons.check_rounded, color: Colors.green, size: 48),
              ),
              const SizedBox(height: 24),
              Text('Berhasil Diklaim!', style: GoogleFonts.sora(fontSize: 22, fontWeight: FontWeight.w900)),
              const SizedBox(height: 12),
              Text(
                'Promo Anda telah aktif. Silakan cek di menu "My Vouchers".',
                textAlign: TextAlign.center,
                style: GoogleFonts.dmSans(fontSize: 14, color: Colors.grey),
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  minimumSize: const Size(double.infinity, 54),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                ),
                child: Text('Mantap!', style: GoogleFonts.sora(fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
      ).animate().scale(curve: Curves.easeOutBack),
    );
  }
}
