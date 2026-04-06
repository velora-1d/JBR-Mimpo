import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:jbr_mimpo/core/theme/app_colors.dart';
import 'package:jbr_mimpo/core/widgets/shimmer_loader.dart';
import 'dart:math' as math;

class PackageDetailScreen extends StatefulWidget {
  const PackageDetailScreen({super.key});

  @override
  State<PackageDetailScreen> createState() => _PackageDetailScreenState();
}

class _PackageDetailScreenState extends State<PackageDetailScreen> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgLight,
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            // 1. Custom Top Bar
            _buildAppBar(context),
            
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  // 2. Hero Glass Card
                  _buildHeroGlassCard(),
                  const SizedBox(height: 24),
                  
                  // 3. Usage Gauge Grid
                  _buildUsageGaugeGrid(),
                  const SizedBox(height: 24),
                  
                  // 4. Network Specs Card
                  _buildNetworkSpecsCard(),
                  const SizedBox(height: 24),
                  
                  // 5. Action Section
                  _buildActionSection(),
                  
                  const SizedBox(height: 120), // Bottom padding
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const CircleAvatar(
                  radius: 20,
                  backgroundImage: CachedNetworkImageProvider('https://lh3.googleusercontent.com/aida-public/AB6AXuBWemjxFV6B__HQV4yyQeZQSg-zszgymP3w2vssTlH6-YETvxMrdV-E3xqzWfW0GCv90sP2vOdjxyu13s2cU7UdsxM9wD8q8c4xISCbmnVQyzVjW-SJy4e8RT4zalXoACSYmUXLPjrXzLzVZ_ibIVj1VIk2cIXL3jcN1UqhiRN2GWjpgcdYgFxq3Pj8fm5n4inpAtZKdWkq5OFwGiB6TGP1oZm0YWve6fhGFBhLzfoJ-TahS0WEZKd-aP8Dw5tyjoqWnLCbFZp2oSLQ'),
                ),
                const SizedBox(width: 12),
                Text(
                  'JBR Minpo',
                  style: GoogleFonts.sora(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.primary),
                ),
              ],
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.support_agent_rounded, color: AppColors.primary),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeroGlassCard() {
    if (_isLoading) {
      return ShimmerLoader(width: double.infinity, height: 260, borderRadius: 32);
    }
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.1)),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 20, offset: const Offset(0, 10)),
        ],
      ),
      child: Stack(
        children: [
          // Background Glow
          Positioned(
            top: -20,
            right: -20,
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.05),
                shape: BoxShape.circle,
              ),
            ),
          ),
          
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF71a1ff).withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'AKTIF',
                      style: GoogleFonts.sora(fontSize: 11, fontWeight: FontWeight.w800, color: const Color(0xFF00367a)),
                    ),
                  ),
                  const Icon(Icons.wifi_tethering_rounded, color: AppColors.primary, size: 32),
                ],
              ),
              const SizedBox(height: 24),
              Text(
                'Paket Home Ultimate',
                style: GoogleFonts.sora(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
              ),
              const SizedBox(height: 8),
              Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(
                    '100',
                    style: GoogleFonts.sora(fontSize: 48, fontWeight: FontWeight.w800, color: AppColors.primary),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Mbps',
                    style: GoogleFonts.sora(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.primary),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.event_available_rounded, color: Colors.white, size: 16),
                    const SizedBox(width: 8),
                    Text(
                      'Aktif hingga 20 Jan 2024',
                      style: GoogleFonts.dmSans(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    ).animate().fadeIn().scale(curve: Curves.easeOutBack);
  }

  Widget _buildUsageGaugeGrid() {
    return Row(
      children: [
        Expanded(
          child: _buildGaugeCard(
            label: 'Kapasitas Terpakai',
            value: '75%',
            detail: '750 GB / 1 TB',
            percentage: 0.75,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildGaugeCard(
            label: 'Kecepatan Saat Ini',
            value: '88',
            detail: '88.4 Mbps',
            percentage: 0.88,
            color: const Color(0xFF005ac2),
          ),
        ),
      ],
    ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.1);
  }

  Widget _buildGaugeCard({
    required String label,
    required String value,
    required String detail,
    required double percentage,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        children: [
          SizedBox(
            width: 80,
            height: 80,
            child: Stack(
              children: [
                Center(
                  child: CustomPaint(
                    size: const Size(80, 80),
                    painter: GaugePainter(percentage: percentage, color: color),
                  ),
                ),
                Center(
                  child: Text(
                    value,
                    style: GoogleFonts.jetBrainsMono(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Text(
            label,
            textAlign: TextAlign.center,
            style: GoogleFonts.dmSans(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.grey),
          ),
          const SizedBox(height: 4),
          Text(
            detail,
            style: GoogleFonts.jetBrainsMono(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
          ),
        ],
      ),
    );
  }

  Widget _buildNetworkSpecsCard() {
    if (_isLoading) {
      return ShimmerLoader(width: double.infinity, height: 180, borderRadius: 32);
    }
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32),
      ),
      child: Column(
        children: [
          Row(
            children: [
              const Icon(Icons.router_rounded, color: AppColors.primary),
              const SizedBox(width: 12),
              Text(
                'Network Specs',
                style: GoogleFonts.sora(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _buildSpecRow('IP Address', '192.168.100.42'),
          _buildSpecRow('MAC Address', 'F4:6A:92:B1:0C:55'),
          _buildSpecRow('Tipe Router', 'ZTE F670L Dual Band', last: true),
        ],
      ),
    ).animate().fadeIn(delay: 400.ms);
  }

  Widget _buildSpecRow(String label, String value, {bool last = false}) {
    return Padding(
      padding: EdgeInsets.only(bottom: last ? 0 : 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: GoogleFonts.dmSans(fontSize: 13, color: Colors.grey)),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.bgLight,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              value,
              style: GoogleFonts.jetBrainsMono(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionSection() {
    return Column(
      children: [
        ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            minimumSize: const Size(double.infinity, 60),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            elevation: 8,
            shadowColor: AppColors.primary.withValues(alpha: 0.3),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.upgrade_rounded),
              const SizedBox(width: 12),
              Text(
                'Upgrade Paket',
                style: GoogleFonts.sora(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Butuh bantuan teknis? ',
              style: GoogleFonts.dmSans(fontSize: 12, color: Colors.grey),
            ),
            GestureDetector(
              onTap: () {},
              child: Text(
                'Hubungi Support',
                style: GoogleFonts.dmSans(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.primary),
              ),
            ),
          ],
        ),
      ],
    ).animate().fadeIn(delay: 600.ms);
  }
}

class GaugePainter extends CustomPainter {
  final double percentage;
  final Color color;

  GaugePainter({required this.percentage, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    const strokeWidth = 8.0;

    // Background circle
    final bgPaint = Paint()
      ..color = AppColors.bgLight
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;
    canvas.drawCircle(center, radius - strokeWidth / 2, bgPaint);

    // Progress arc
    final progressPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius - strokeWidth / 2),
      -math.pi / 2,
      2 * math.pi * percentage,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
