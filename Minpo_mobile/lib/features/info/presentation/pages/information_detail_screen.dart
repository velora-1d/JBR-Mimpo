import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jbr_mimpo/core/theme/app_colors.dart';
import 'package:go_router/go_router.dart';

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
              // 1. Hero Animated Header (SliverAppBar)
              SliverAppBar(
                expandedHeight: 380,
                backgroundColor: AppColors.bgLight,
                leading: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CircleAvatar(
                    backgroundColor: Colors.white.withValues(alpha: 0.6),
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back_rounded, color: AppColors.textPrimary),
                      onPressed: () => context.pop(),
                    ),
                  ),
                ),
                actions: [
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: CircleAvatar(
                      backgroundColor: Colors.white.withValues(alpha: 0.6),
                      child: IconButton(
                        icon: const Icon(Icons.share_rounded, color: AppColors.textPrimary),
                        onPressed: () {},
                      ),
                    ),
                  ),
                ],
                flexibleSpace: FlexibleSpaceBar(
                  background: Stack(
                    fit: StackFit.expand,
                    children: [
                      // Placeholder Image with Gradient
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [color.withValues(alpha: 0.8), color],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                        child: Icon(info['icon'], color: Colors.white.withValues(alpha: 0.2), size: 120)
                            .animate(onPlay: (c) => c.repeat(reverse: true))
                            .moveY(begin: 0, end: 10, duration: 2.seconds),
                      ),
                      // Overlay Gradient
                      Container(
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.black12,
                              AppColors.bgLight,
                            ],
                            stops: [0.6, 0.8, 1.0],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // 2. Content Sections
              SliverToBoxAdapter(
                child: Transform.translate(
                  offset: const Offset(0, -40),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Title Card (Floating overlap)
                        _buildTitleCard(info, color),

                        const SizedBox(height: 32),

                        // Article Body
                        _buildArticleContent(info, color, isMaintenance, isGangguan),

                        const SizedBox(height: 32),

                        // Impacted Areas
                        if (isMaintenance || isGangguan) _buildImpactedAreas(color),

                        const SizedBox(height: 32),

                        // Tips Box
                        _buildTipsBox(),

                        const SizedBox(height: 120), // Padding for sticky button
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),

          // 3. Sticky Bottom Action Button
          _buildStickyCSButton(),
        ],
      ),
    );
  }

  Widget _buildTitleCard(Map<String, dynamic> info, Color color) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 30,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: color.withValues(alpha: 0.2)),
                ),
                child: Text(
                  info['category'].toString().toUpperCase(),
                  style: GoogleFonts.jetBrainsMono(
                    fontSize: 9,
                    fontWeight: FontWeight.bold,
                    color: color,
                    letterSpacing: 1,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Icon(Icons.calendar_today_rounded, size: 14, color: Colors.grey.shade400),
              const SizedBox(width: 4),
              Text(
                '24 OKTOBER 2023',
                style: GoogleFonts.jetBrainsMono(
                  fontSize: 10,
                  color: Colors.grey.shade500,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            info['title'],
            style: GoogleFonts.sora(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
              height: 1.2,
            ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: 200.ms).moveY(begin: 20, end: 0);
  }

  Widget _buildArticleContent(Map<String, dynamic> info, Color color, bool isMaint, bool isGangguan) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            style: GoogleFonts.dmSans(fontSize: 15, color: AppColors.textSecondary, height: 1.8),
            children: [
              const TextSpan(text: 'Kami informasikan bahwa tim teknis '),
              TextSpan(text: 'JBR Minpo', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
              TextSpan(text: ' akan melakukan ${info['category'].toString().toLowerCase()} infrastruktur kabel fiber optik di beberapa titik strategis wilayah Bekasi dan sekitarnya.'),
            ],
          ),
        ),
        const SizedBox(height: 24),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(20),
            border: Border(left: BorderSide(color: color, width: 4)),
          ),
          child: Text(
            '"Langkah ini merupakan bagian dari komitmen kami untuk memastikan stabilitas koneksi internet pita lebar bagi seluruh pelanggan residensial dan bisnis."',
            style: GoogleFonts.dmSans(
              fontSize: 14,
              fontStyle: FontStyle.italic,
              color: AppColors.textPrimary.withValues(alpha: 0.8),
              height: 1.6,
            ),
          ),
        ),
        const SizedBox(height: 24),
        Text(
          'Estimasi waktu pengerjaan dimulai pukul 01:00 WIB hingga 04:00 WIB untuk meminimalisir gangguan aktivitas pengguna. Selama proses ini berlangsung, mungkin akan terjadi penurunan kecepatan atau diskoneksi singkat.',
          style: GoogleFonts.dmSans(fontSize: 15, color: AppColors.textSecondary, height: 1.8),
        ),
      ],
    ).animate().fadeIn(delay: 400.ms);
  }

  Widget _buildImpactedAreas(Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Area Terdampak',
          style: GoogleFonts.sora(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
        ),
        const SizedBox(height: 16),
        _buildRegionItem('REGION 01', 'Bekasi Barat & Summarecon', color),
        const SizedBox(height: 12),
        _buildRegionItem('REGION 02', 'Harapan Indah & Kranji', color),
      ],
    ).animate().fadeIn(delay: 600.ms);
  }

  Widget _buildRegionItem(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)),
            child: Icon(Icons.location_on_rounded, color: color, size: 20),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: GoogleFonts.jetBrainsMono(fontSize: 10, color: Colors.grey, fontWeight: FontWeight.bold)),
              const SizedBox(height: 2),
              Text(value, style: GoogleFonts.dmSans(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTipsBox() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.info_outline_rounded, color: Colors.blue, size: 24),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Tips Koneksi',
                  style: GoogleFonts.sora(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                ),
                const SizedBox(height: 4),
                Text(
                  'Jika koneksi belum kembali normal setelah jadwal tersebut, silakan restart router Anda selama 30 detik.',
                  style: GoogleFonts.dmSans(fontSize: 13, color: AppColors.textSecondary, height: 1.5),
                ),
              ],
            ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: 800.ms);
  }

  Widget _buildStickyCSButton() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColors.bgLight.withValues(alpha: 0), AppColors.bgLight],
          ),
        ),
        child: Container(
          width: double.infinity,
          height: 60,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            gradient: const LinearGradient(
              colors: [AppColors.primary, Color(0xFF10b981)],
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.3),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.support_agent_rounded, color: Colors.white),
                const SizedBox(width: 12),
                Text(
                  'Hubungi CS',
                  style: GoogleFonts.sora(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
