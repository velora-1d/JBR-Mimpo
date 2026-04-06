import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jbr_mimpo/core/theme/app_colors.dart';
import 'package:jbr_mimpo/core/utils/app_feedback.dart';
import 'package:jbr_mimpo/core/widgets/app_dialog.dart';

class RewardDetailScreen extends StatelessWidget {
  final Map<String, dynamic> item;

  const RewardDetailScreen({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final title = item['title'] ?? 'Hadiah Premium';
    final points = item['points'] ?? item['sisa'] ?? '0';
    final icon = item['icon'] as IconData? ?? Icons.card_giftcard_rounded;
    final color = item['color'] as Color? ?? AppColors.primary;
    final isUndian = item.containsKey('sisa');

    return Scaffold(
      backgroundColor: AppColors.bgLight,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // 1. Premium Sliver App Bar
          SliverAppBar(
            expandedHeight: 350,
            pinned: true,
            stretch: true,
            backgroundColor: color,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
            flexibleSpace: FlexibleSpaceBar(
              stretchModes: const [
                StretchMode.zoomBackground,
                StretchMode.blurBackground,
              ],
              background: Stack(
                alignment: Alignment.center,
                children: [
                   // Decorative background elements
                  Positioned(
                    top: -50,
                    right: -50,
                    child: Container(
                      width: 250,
                      height: 250,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                  
                  // Main Icon with Glow
                  Container(
                    width: 140,
                    height: 140,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 30,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Icon(
                      icon,
                      size: 72,
                      color: Colors.white,
                    ).animate(onPlay: (c) => c.repeat(reverse: true))
                     .scale(duration: 2.seconds, begin: const Offset(1, 1), end: const Offset(1.1, 1.1))
                     .shimmer(duration: 3.seconds, color: Colors.white.withValues(alpha: 0.3)),
                  ),

                  // Floating tags
                  Positioned(
                    bottom: 40,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(100),
                        border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.workspace_premium_rounded, color: Colors.amber, size: 16),
                          const SizedBox(width: 8),
                          Text(
                            isUndian ? 'EDISI TERBATAS' : 'REWARD EKSKLUSIF',
                            style: GoogleFonts.jetBrainsMono(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // 2. Content
          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.bgLight,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              title,
                              style: GoogleFonts.sora(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              isUndian ? 'Status: Tersedia di Undian Akhir Tahun' : 'Kategori: Penukaran Poin JBR',
                              style: GoogleFonts.dmSans(
                                color: AppColors.textSecondary,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        decoration: BoxDecoration(
                          color: color.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          children: [
                            Text(
                              isUndian ? points : points.split(' ')[0],
                              style: GoogleFonts.sora(
                                fontSize: 20,
                                fontWeight: FontWeight.w800,
                                color: color,
                              ),
                            ),
                            Text(
                              isUndian ? 'UNIT' : 'POIN',
                              style: GoogleFonts.jetBrainsMono(
                                fontSize: 9,
                                fontWeight: FontWeight.bold,
                                color: color,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 32),
                  
                  _buildSectionTitle('Deskripsi Hadiah'),
                  const SizedBox(height: 12),
                  Text(
                    'Dapatkan kesempatan istimewa untuk memiliki ${title.toLowerCase()} eksklusif dari JBR Minpo. Hadiah ini dikurasi khusus untuk pelanggan setia kami sebagai bentuk apresiasi atas dukungan Anda.',
                    style: GoogleFonts.dmSans(
                      fontSize: 15,
                      color: AppColors.textPrimary.withValues(alpha: 0.7),
                      height: 1.6,
                    ),
                  ),
                  
                  const SizedBox(height: 32),
                  
                  _buildSectionTitle('Cara Mendapatkan'),
                  const SizedBox(height: 16),
                  _buildStepItem(1, isUndian ? 'Kumpulkan poin JBR sebanyak-banyaknya.' : 'Pastikan saldo poin Anda mencukupi.'),
                  _buildStepItem(2, isUndian ? 'Tukarkan 1.000 poin dengan 1 kupon undian.' : 'Klik tombol "Tukar Sekarang" di bawah.'),
                  _buildStepItem(3, isUndian ? 'Nantikan pengumuman pemenang di aplikasi.' : 'Konfirmasi alamat pengiriman atau pengambilan.'),
                  
                  const SizedBox(height: 40),
                  
                  // Action Button
                  SizedBox(
                    width: double.infinity,
                    height: 64,
                    child: ElevatedButton(
                      onPressed: () {
                        AppDialog.showConfirmation(
                          context: context,
                          title: 'Konfirmasi',
                          message: isUndian 
                              ? 'Tukar 1.000 Poin untuk 1 Kupon Undian $title?'
                              : 'Tukar $points untuk $title?',
                          confirmText: 'Konfirmasi',
                          icon: isUndian ? Icons.confirmation_number_rounded : Icons.shopping_cart_checkout_rounded,
                          onConfirm: () {
                            AppFeedback.success(context, 'Berhasil! Permintaan Anda sedang diproses.');
                          },
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: color,
                        foregroundColor: Colors.white,
                        elevation: 10,
                        shadowColor: color.withValues(alpha: 0.4),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: Text(
                        isUndian ? 'AMBIL KUPON SEKARANG' : 'TUKAR HADIAH SEKARANG',
                        style: GoogleFonts.sora(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 18,
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 10),
        Text(
          title,
          style: GoogleFonts.sora(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }

  Widget _buildStepItem(int step, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Text(
              step.toString(),
              style: GoogleFonts.jetBrainsMono(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.dmSans(
                fontSize: 14,
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
