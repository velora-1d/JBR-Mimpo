import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:jbr_mimpo/core/theme/app_colors.dart';
import 'package:go_router/go_router.dart';

class PromoDetailScreen extends StatelessWidget {
  final Map<String, dynamic> promo;

  const PromoDetailScreen({super.key, required this.promo});

  @override
  Widget build(BuildContext context) {
    final isFlashSale =
        promo['tag'] == 'Flash Sale' || promo['tag'] == 'Limited';
    final accentColor = isFlashSale
        ? const Color(0xFFFF4D4D)
        : AppColors.primary;

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
                leading: _buildCircleAction(
                  context,
                  Icons.arrow_back_rounded,
                  () => context.pop(),
                ),
                flexibleSpace: FlexibleSpaceBar(
                  background: Stack(
                    fit: StackFit.expand,
                    children: [
                      Hero(
                        tag: promo['title'] ?? 'promo_header',
                        child: _buildMeshPromoHeader(accentColor, promo['imageUrl']),
                      ),

                      // Floating Promo Icon
                      Center(
                        child:
                            Container(
                                  padding: const EdgeInsets.all(40),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withValues(alpha: 0.1),
                                    shape: BoxShape.circle,
                                  ),
                                  child: promo['imageUrl'] != null ? const SizedBox.shrink() : Icon(
                                    promo['icon'] ?? Icons.loyalty_rounded,
                                    color: Colors.white,
                                    size: 100,
                                  ),
                                )
                                .animate(onPlay: (c) => c.repeat(reverse: true))
                                .scale(
                                  begin: const Offset(1, 1),
                                  end: const Offset(1.1, 1.1),
                                  duration: 2.seconds,
                                )
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

  Widget _buildCircleAction(
    BuildContext context,
    IconData icon,
    VoidCallback onTap,
  ) {
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
            child: IconButton(
              icon: Icon(icon, color: AppColors.textPrimary, size: 20),
              onPressed: onTap,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMeshPromoHeader(Color color, String? imageUrl) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [color, color.withValues(alpha: 0.7)],
        ),
      ),
      child: imageUrl != null 
        ? CachedNetworkImage(
            imageUrl: imageUrl,
            fit: BoxFit.cover,
            color: Colors.black.withValues(alpha: 0.3),
            colorBlendMode: BlendMode.darken,
          )
        : Stack(
            children: [
              Positioned(
                top: -20,
                right: -20,
                child: Icon(
                  Icons.stars_rounded,
                  size: 200,
                  color: Colors.white.withValues(alpha: 0.1),
                ),
              ),
            ],
          ),
    );
  }

  Widget _buildPromoTitleArea(
    Map<String, dynamic> promo,
    Color color,
    bool isFlash,
  ) {
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
                    const Icon(
                          Icons.bolt_rounded,
                          size: 16,
                          color: Color(0xFFFF4D4D),
                        )
                        .animate(onPlay: (c) => c.repeat())
                        .shimmer(duration: 1500.ms),
                  const SizedBox(width: 4),
                  Text(
                    promo['tag']?.toString().toUpperCase() ?? 'PROMO',
                    style: GoogleFonts.jetBrainsMono(
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      color: color,
                    ),
                  ),
                ],
              ),
            ),
            if (isFlash)
              Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFF4D4D).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.timer_rounded,
                          size: 14,
                          color: Color(0xFFFF4D4D),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '04:22:11', // Dummy Timer
                          style: GoogleFonts.jetBrainsMono(
                            fontSize: 14,
                            fontWeight: FontWeight.w900,
                            color: const Color(0xFFFF4D4D),
                          ),
                        ),
                      ],
                    ),
                  )
                  .animate(onPlay: (c) => c.repeat())
                  .fadeOut(duration: 500.ms, begin: 1.0, curve: Curves.easeIn)
                  .fadeIn(),
          ],
        ),
        const SizedBox(height: 24),
        Text(
          promo['title'] ?? 'Kejutan Promo Menarik',
          style: GoogleFonts.sora(
            fontSize: 32,
            fontWeight: FontWeight.w900,
            color: AppColors.textPrimary,
            height: 1.2,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.grey.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.withValues(alpha: 0.1)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.event_available_rounded,
                size: 18,
                color: Colors.grey,
              ),
              const SizedBox(width: 8),
              Text(
                'Berakhir dalam 3 hari lagi',
                style: GoogleFonts.dmSans(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
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
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 40,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Tentang Promo',
            style: GoogleFonts.sora(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Text(
            promo['subtitle'] ??
                'Nikmati penawaran eksklusif khusus untuk pelanggan setia JBR Minpo. Tingkatkan pengalaman internet Anda dengan harga yang lebih hemat.',
            style: GoogleFonts.dmSans(
              fontSize: 15,
              height: 1.7,
              color: AppColors.textPrimary.withValues(alpha: 0.7),
            ),
          ),
          const SizedBox(height: 24),
          const Divider(height: 1),
          const SizedBox(height: 24),
          _buildBenefitRow(
            Icons.check_circle_rounded,
            'Hemat hingga 50% untuk Top-Up',
          ),
          const SizedBox(height: 12),
          _buildBenefitRow(
            Icons.check_circle_rounded,
            'Berlaku untuk semua metode pembayaran',
          ),
        ],
      ),
    ).animate().fadeIn(delay: 400.ms);
  }

  Widget _buildBenefitRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.green),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: GoogleFonts.dmSans(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBentoTerms(Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Syarat & Ketentuan',
          style: GoogleFonts.sora(fontSize: 18, fontWeight: FontWeight.bold),
        ),
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
          Text(
            title,
            style: GoogleFonts.dmSans(
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildFloatingAction(
    BuildContext context,
    Map<String, dynamic> promo,
    Color color,
  ) {
    return Positioned(
      bottom: 40,
      left: 24,
      right: 24,
      child:
          Container(
                height: 64, // Sleeker height
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(32), // Rounder corner
                  boxShadow: [
                    BoxShadow(
                      color: color.withValues(alpha: 0.4),
                      blurRadius: 24,
                      offset: const Offset(0, 12),
                    ),
                  ],
                  gradient: LinearGradient(
                    colors: [color, color.withValues(alpha: 0.8)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: ElevatedButton(
                  onPressed: () {
                    _showClaimSuccess(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors
                        .transparent, // Background transparent so gradient shows
                    shadowColor: Colors.transparent,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32),
                    ), // Match container
                    elevation: 0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.confirmation_num_rounded, size: 24),
                      const SizedBox(width: 12),
                      Text(
                        'Klaim Promo',
                        style: GoogleFonts.sora(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                ),
              )
              .animate()
              .slideY(begin: 1, delay: 800.ms)
              .then()
              .shimmer(duration: 2.seconds, delay: 1.seconds),
    );
  }

  void _showClaimSuccess(BuildContext context) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.5),
      builder: (context) => BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        child: Center(
          child: Container(
            width: 320,
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.95),
              borderRadius: BorderRadius.circular(40),
            ),
            child: Material(
              color: Colors.transparent,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: const BoxDecoration(
                      color: Color(0xFFE8F5E9),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.check_rounded,
                      color: Colors.green,
                      size: 48,
                    ),
                  ).animate().scale(duration: 500.ms, curve: Curves.easeOutBack),
                  const SizedBox(height: 24),
                  Text(
                    'Klaim Berhasil!',
                    style: GoogleFonts.sora(
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Promo telah ditambahkan ke akun Anda. Gunakan segera sebelum kedaluwarsa.',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.dmSans(
                      color: Colors.grey.shade600,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF10B981),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: Text(
                        'Lihat Voucher Saya',
                        style: GoogleFonts.sora(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
