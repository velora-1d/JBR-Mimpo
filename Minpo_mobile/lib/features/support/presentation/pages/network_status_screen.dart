import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jbr_mimpo/core/theme/app_colors.dart';
import 'package:jbr_mimpo/core/widgets/animated_status_illustration.dart';

class NetworkStatusScreen extends StatelessWidget {
  const NetworkStatusScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgLight,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async => await Future.delayed(const Duration(seconds: 1)),
          color: AppColors.primary,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
          child: Column(
            children: [
              // 1. App Bar
              _buildAppBar(context),

              // 2. Header
              _buildPageHeader(),

              const SizedBox(height: 24),

              // 3. Overall Status Banner
              _buildOverallStatus(),

              const SizedBox(height: 24),

              // 4. Area Status List
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Status Per Area',
                      style: GoogleFonts.sora(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                    ),
                    const SizedBox(height: 16),
                    _buildAreaCard(
                      area: 'Jakarta Selatan',
                      status: 'normal',
                      speed: '50 Mbps',
                      latency: '12ms',
                      uptime: '99.8%',
                    ),
                    _buildAreaCard(
                      area: 'Jakarta Barat',
                      status: 'gangguan',
                      speed: '—',
                      latency: '—',
                      uptime: '87.2%',
                      issue: 'Kerusakan kabel fiber optik di area Kebon Jeruk',
                      eta: '~3 jam (estimasi pukul 15:00 WIB)',
                    ),
                    _buildAreaCard(
                      area: 'Tangerang',
                      status: 'maintenance',
                      speed: '25 Mbps',
                      latency: '45ms',
                      uptime: '95.1%',
                      issue: 'Pemeliharaan rutin upgrade OLT',
                      eta: '~1 jam (estimasi pukul 12:00 WIB)',
                    ),
                    _buildAreaCard(
                      area: 'Depok',
                      status: 'normal',
                      speed: '100 Mbps',
                      latency: '8ms',
                      uptime: '99.9%',
                    ),
                    _buildAreaCard(
                      area: 'Bekasi',
                      status: 'normal',
                      speed: '50 Mbps',
                      latency: '15ms',
                      uptime: '99.5%',
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // 5. Info Footer
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.primary.withValues(alpha: 0.1)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.info_outline_rounded, color: AppColors.primary, size: 20),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Data diperbarui setiap 5 menit. Hubungi CS untuk informasi lebih lanjut.',
                          style: GoogleFonts.dmSans(fontSize: 12, color: AppColors.textSecondary, height: 1.5),
                        ),
                      ),
                    ],
                  ),
                ),
              ).animate().fadeIn(duration: 300.ms),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    ),
   );
  }

  Widget _buildAppBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, 4)),
                ],
              ),
              child: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.primary, size: 18),
            ),
          ),
          const SizedBox(width: 16),
          Text(
            'Status Jaringan',
            style: GoogleFonts.sora(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.primary),
          ),
        ],
      ),
    );
  }

  Widget _buildPageHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Status Jaringan',
                style: GoogleFonts.sora(fontSize: 28, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
              ),
              Text(
                'Area',
                style: GoogleFonts.sora(fontSize: 28, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
              ),
              const SizedBox(height: 8),
              Text(
                'Pantau status koneksi internet di wilayah kamu secara real-time.',
                style: GoogleFonts.dmSans(fontSize: 14, color: AppColors.textSecondary, height: 1.5),
              ),
            ],
          ),
          Positioned(
            right: -10,
            top: -20,
            child: Icon(
              Icons.cell_tower_rounded,
              size: 100,
              color: AppColors.textPrimary.withValues(alpha: 0.05),
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 300.ms).slideX(begin: -0.05);
  }

  Widget _buildOverallStatus() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [AppColors.primary, Color(0xFF059669)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.3),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const AnimatedStatusIllustration(
                type: StatusType.success, // Gunakan sukses (normal) sebagai default
                height: 80,
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'SISTEM KESELURUHAN',
                    style: GoogleFonts.jetBrainsMono(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white70, letterSpacing: 1),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Sebagian Besar Normal',
                    style: GoogleFonts.sora(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '1 area mengalami gangguan, 1 dalam pemeliharaan',
                    style: GoogleFonts.dmSans(fontSize: 12, color: Colors.white70),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 300.ms).slideY(begin: 0.05);
  }

  Widget _buildAreaCard({
    required String area,
    required String status,
    required String speed,
    required String latency,
    required String uptime,
    String? issue,
    String? eta,
  }) {
    Color statusColor;
    String statusLabel;
    IconData statusIcon;

    switch (status) {
      case 'gangguan':
        statusColor = Colors.red;
        statusLabel = 'GANGGUAN';
        statusIcon = Icons.error_rounded;
        break;
      case 'maintenance':
        statusColor = Colors.orange;
        statusLabel = 'MAINTENANCE';
        statusIcon = Icons.build_circle_rounded;
        break;
      default:
        statusColor = AppColors.primary;
        statusLabel = 'NORMAL';
        statusIcon = Icons.check_circle_rounded;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: status != 'normal'
            ? Border(left: BorderSide(color: statusColor, width: 4))
            : Border.all(color: Colors.grey.shade100),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.location_on_rounded, color: statusColor, size: 18),
                  const SizedBox(width: 8),
                  Text(
                    area,
                    style: GoogleFonts.sora(fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(statusIcon, color: statusColor, size: 12),
                    const SizedBox(width: 4),
                    Text(
                      statusLabel,
                      style: GoogleFonts.jetBrainsMono(fontSize: 9, fontWeight: FontWeight.w900, color: statusColor, letterSpacing: 0.5),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Stats Row
          Row(
            children: [
              _buildStatChip(Icons.speed_rounded, 'Speed', speed, Colors.green),
              const SizedBox(width: 8),
              _buildStatChip(Icons.timer_rounded, 'Latency', latency, Colors.blue),
              const SizedBox(width: 8),
              _buildStatChip(Icons.trending_up_rounded, 'Uptime', uptime, Colors.purple),
            ],
          ),

          // Issue info
          if (issue != null) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: statusColor.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Keterangan:',
                    style: GoogleFonts.sora(fontSize: 11, fontWeight: FontWeight.bold, color: statusColor),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    issue,
                    style: GoogleFonts.dmSans(fontSize: 12, color: AppColors.textSecondary, height: 1.5),
                  ),
                  if (eta != null) ...[
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.schedule_rounded, color: statusColor, size: 14),
                        const SizedBox(width: 6),
                        Text(
                          'ETA: $eta',
                          style: GoogleFonts.jetBrainsMono(fontSize: 11, fontWeight: FontWeight.bold, color: statusColor),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ],
        ],
      ),
    ).animate().fadeIn(duration: 300.ms).slideX(begin: 0.03);
  }

  Widget _buildStatChip(IconData icon, String label, String value, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 16),
            const SizedBox(height: 4),
            Text(
              value,
              style: GoogleFonts.jetBrainsMono(fontSize: 11, fontWeight: FontWeight.bold, color: color),
            ),
            Text(
              label,
              style: GoogleFonts.dmSans(fontSize: 9, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
