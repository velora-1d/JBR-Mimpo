import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jbr_mimpo/core/theme/app_colors.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';
import 'dart:ui';

class InformationDetailScreen extends StatelessWidget {
  final Map<String, dynamic> info;

  const InformationDetailScreen({super.key, required this.info});

  @override
  Widget build(BuildContext context) {
    final color = info['color'] as Color;
    final isMaintenance = info['category'] == 'Maintenance';
    final isGangguan = info['category'] == 'Gangguan';

    return Scaffold(
      backgroundColor: AppColors.bgLight,
      body: Stack(
        children: [
          CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              // 1. Premium Mesh Header (SliverAppBar)
              SliverAppBar(
                expandedHeight: 420,
                pinned: true,
                stretch: true,
                backgroundColor: AppColors.bgLight,
                elevation: 0,
                leadingWidth: 70,
                leading: _buildHeaderAction(
                  context,
                  icon: Icons.arrow_back_rounded,
                  onPressed: () => context.pop(),
                ),
                actions: [
                  _buildHeaderAction(
                    context,
                    icon: Icons.share_rounded,
                    onPressed: () => SharePlus.instance.share(
                      ShareParams(
                        text: '${info['title']}\n\nBaca di JBR Minpo!',
                        subject: info['title'] as String?,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                ],
                flexibleSpace: FlexibleSpaceBar(
                  stretchModes: const [
                    StretchMode.zoomBackground,
                    StretchMode.blurBackground,
                  ],
                  background: Stack(
                    fit: StackFit.expand,
                    children: [
                      // Vibrant Mesh Gradient
                      _buildMeshGradient(color),

                      // Animated Icon Overlay
                      Center(
                        child:
                            Icon(info['icon'], color: Colors.white24, size: 140)
                                .animate(onPlay: (c) => c.repeat(reverse: true))
                                .moveY(begin: 0, end: 15, duration: 3.seconds)
                                .scale(
                                  begin: const Offset(1, 1),
                                  end: const Offset(1.1, 1.1),
                                ),
                      ),

                      // Overlay Soft Bottom Gradient
                      Positioned.fill(
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.transparent,
                                AppColors.bgLight.withValues(alpha: 0.6),
                                AppColors.bgLight,
                              ],
                              stops: const [0.4, 0.7, 1.0],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // 2. Content Sections
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title Section (Floating feel)
                      _buildPremiumTitle(info, color),

                      const SizedBox(height: 32),

                      // Main Article Content
                      _buildEnhancedArticle(
                        info,
                        color,
                        isMaintenance,
                        isGangguan,
                      ),

                      const SizedBox(height: 40),

                      // Impacted Areas (Bento Style)
                      if (isMaintenance || isGangguan) _buildBentoImpact(color),

                      const SizedBox(height: 48),

                      // Expert Advice / Tips
                      _buildPremiumTips(),

                      const SizedBox(height: 140), // Space for CS Button
                    ],
                  ),
                ),
              ),
            ],
          ),

          // 3. Floating Premium Action Button
          _buildFloatingCS(context),
        ],
      ),
    );
  }

  Widget _buildHeaderAction(
    BuildContext context, {
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white.withValues(alpha: 0.3)),
            ),
            child: IconButton(
              icon: Icon(icon, color: AppColors.textPrimary, size: 22),
              onPressed: onPressed,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMeshGradient(Color baseColor) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            baseColor,
            baseColor.withValues(alpha: 0.8),
            baseColor.withValues(alpha: 0.6),
          ],
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            top: -50,
            left: -50,
            child: _buildGlowSphere(baseColor.withValues(alpha: 0.4), 250),
          ),
          Positioned(
            bottom: 50,
            right: -30,
            child: _buildGlowSphere(Colors.white.withValues(alpha: 0.2), 200),
          ),
        ],
      ),
    );
  }

  Widget _buildGlowSphere(Color color, double size) {
    return Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(color: color, blurRadius: 100, spreadRadius: 20),
            ],
          ),
        )
        .animate(onPlay: (c) => c.repeat(reverse: true))
        .scale(
          begin: const Offset(1, 1),
          end: const Offset(1.2, 1.2),
          duration: 5.seconds,
        );
  }

  Widget _buildPremiumTitle(Map<String, dynamic> info, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            // Glassmorphism Tag
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: color.withValues(alpha: 0.3)),
                  ),
                  child: Text(
                    info['category'].toString().toUpperCase(),
                    style: GoogleFonts.jetBrainsMono(
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      color: color,
                      letterSpacing: 1.5,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Icon(
              Icons.access_time_rounded,
              size: 14,
              color: AppColors.textSecondary,
            ),
            const SizedBox(width: 6),
            Text(
              'UPDATE HARI INI',
              style: GoogleFonts.dmSans(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: AppColors.textSecondary,
                letterSpacing: 1,
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Text(
          info['title'],
          style: GoogleFonts.sora(
            fontSize: 28,
            fontWeight: FontWeight.w900,
            color: AppColors.textPrimary,
            height: 1.1,
            letterSpacing: -0.5,
          ),
        ),
      ],
    ).animate().fadeIn(delay: 300.ms).slideY(begin: 0.2);
  }

  Widget _buildEnhancedArticle(
    Map<String, dynamic> info,
    Color color,
    bool isMaint,
    bool isGangguan,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Detail Informasi',
          style: GoogleFonts.sora(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(28),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.03),
                blurRadius: 30,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            children: [
              Text(
                'Halo Pelanggan Setia JBR Minpo,\n\nKami menginformasikan bahwa saat ini sedang terjadi ${info['category'].toString().toLowerCase()} di wilayah Anda. Tim teknisi kami sedang bekerja keras untuk memastikan layanan kembali optimal secepat mungkin.',
                style: GoogleFonts.dmSans(
                  fontSize: 15,
                  height: 1.8,
                  color: AppColors.textPrimary.withValues(alpha: 0.8),
                ),
              ),
              const SizedBox(height: 20),
              const Divider(height: 1),
              const SizedBox(height: 20),
              _buildInfoRow(
                Icons.timer_outlined,
                'Estimasi Selesai',
                'Pukul 18:00 WIB',
                color,
              ),
              const SizedBox(height: 12),
              _buildInfoRow(
                Icons.sync_problem_rounded,
                'Status Perbaikan',
                'In Progress (75%)',
                color,
              ),
            ],
          ),
        ),
      ],
    ).animate().fadeIn(delay: 500.ms);
  }

  Widget _buildInfoRow(IconData icon, String label, String value, Color color) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, size: 16, color: color),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: GoogleFonts.dmSans(fontSize: 11, color: Colors.grey),
            ),
            Text(
              value,
              style: GoogleFonts.sora(
                fontSize: 13,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildBentoImpact(Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Wilayah Terdampak',
          style: GoogleFonts.sora(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 2.2,
          children: [
            _buildBentoItem('Grogol Indah', color),
            _buildBentoItem('Kebayoran', color),
            _buildBentoItem('Sunter Mall', color),
            _buildBentoItem('Kelapa Gading', color),
          ],
        ),
      ],
    );
  }

  Widget _buildBentoItem(String title, Color color) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.1)),
      ),
      child: Center(
        child: Text(
          title,
          style: GoogleFonts.dmSans(fontWeight: FontWeight.bold, fontSize: 13),
        ),
      ),
    ).animate().scale(delay: 600.ms);
  }

  Widget _buildPremiumTips() {
    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primary, AppColors.primary.withValues(alpha: 0.8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          const Icon(
            Icons.tips_and_updates_rounded,
            color: Colors.white,
            size: 40,
          ),
          const SizedBox(height: 16),
          Text(
            'Expert Advice',
            style: GoogleFonts.sora(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Coba restart router Anda secara berkala (cabut kabel power 10 detik lalu pasang kembali) untuk menyegarkan koneksi.',
            textAlign: TextAlign.center,
            style: GoogleFonts.dmSans(
              color: Colors.white.withValues(alpha: 0.9),
              height: 1.6,
              fontSize: 14,
            ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: 800.ms).slideY(begin: 0.1);
  }

  Widget _buildFloatingCS(BuildContext context) {
    return Positioned(
      bottom: 40,
      left: 24,
      right: 24,
      child: Container(
        height: 70,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 40,
              offset: const Offset(0, 20),
            ),
          ],
        ),
        child: ElevatedButton(
          onPressed: () => context.push('/chat-cs'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: AppColors.primary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
            elevation: 0,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.support_agent_rounded, size: 28),
              const SizedBox(width: 16),
              Text(
                'Hubungi Support Teknisi',
                style: GoogleFonts.sora(
                  fontWeight: FontWeight.w800,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    ).animate().slideY(begin: 1, delay: 1.seconds);
  }
}
