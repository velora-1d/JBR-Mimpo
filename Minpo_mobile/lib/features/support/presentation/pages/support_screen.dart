import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jbr_mimpo/core/theme/app_colors.dart';
import 'package:jbr_mimpo/core/theme/app_dimensions.dart';
import 'package:go_router/go_router.dart';

class SupportScreen extends StatelessWidget {
  const SupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // 1. Header Area
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 40, 20, 20),
            sliver: SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.support_agent_rounded, color: AppColors.primary),
                      ),
                      IconButton(onPressed: () {}, icon: const Icon(Icons.help_outline_rounded, color: Colors.grey)),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Halo, ada kendala?',
                    style: GoogleFonts.sora(
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ).animate().fadeIn().slideX(begin: -0.2),
                  const SizedBox(height: 8),
                  Text(
                    'Kami siap membantu memastikan koneksi Anda tetap lancar secepat kilat.',
                    style: GoogleFonts.dmSans(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                    ),
                  ).animate().fadeIn(delay: 200.ms),
                ],
              ),
            ),
          ),

          // 2. Bento Grid Actions
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: 1.0,
              ),
              delegate: SliverChildListDelegate([
                GestureDetector(
                  onTap: () {
                    HapticFeedback.lightImpact();
                    context.push('/report-issue');
                  },
                  child: _buildActionCard(
                    context,
                    title: 'Lapor Gangguan',
                    subtitle: 'Respon < 2 jam',
                    icon: Icons.bolt_rounded,
                    bgIcon: Icons.report_problem_outlined,
                    color: AppColors.primary,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    HapticFeedback.lightImpact();
                    context.push('/ticket-tracking');
                  },
                  child: _buildActionCard(
                    context,
                    title: 'Cek Tiket',
                    subtitle: 'Pantau status',
                    icon: Icons.receipt_long_rounded,
                    bgIcon: Icons.confirmation_number_outlined,
                    color: Colors.blue,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    HapticFeedback.lightImpact();
                    context.push('/chat-cs');
                  },
                  child: _buildActionCard(
                    context,
                    title: 'Chat CS',
                    subtitle: 'Live Chat 24/7',
                    icon: Icons.forum_rounded,
                    bgIcon: Icons.support_agent_outlined,
                    color: Colors.orange,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    HapticFeedback.lightImpact();
                    context.push('/faq');
                  },
                  child: _buildActionCard(
                    context,
                    title: 'FAQ',
                    subtitle: 'Solusi instan',
                    icon: Icons.quiz_rounded,
                    bgIcon: Icons.help_outline_rounded,
                    color: Colors.teal,
                  ),
                ),
              ]),
            ),
          ),

          // 3. Latest Ticket
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 32, 20, 20),
            sliver: SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Tiket Terakhir Kamu',
                        style: GoogleFonts.sora(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      GestureDetector(
                        onTap: () => context.push('/ticket-tracking'),
                        child: Text('Lihat Semua', style: GoogleFonts.dmSans(fontSize: 13, color: AppColors.primary, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildTicketCard(context),
                ],
              ),
            ),
          ),

          // 4. Banner Illustration
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 100),
            sliver: SliverToBoxAdapter(
              child: _buildVisitBanner(context),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required IconData bgIcon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(AppDimensions.radiusCard),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            right: -25,
            top: -25,
            child: Icon(bgIcon, size: 100, color: color.withValues(alpha: 0.05)),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(icon, color: color, size: 24),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.sora(fontSize: 15, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface),
                  ),
                  Text(
                    subtitle,
                    style: GoogleFonts.dmSans(fontSize: 11, fontWeight: FontWeight.w500, color: AppColors.textSecondary),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    ).animate().fadeIn(delay: 300.ms).scale(begin: const Offset(0.9, 0.9));
  }

  Widget _buildTicketCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(AppDimensions.radiusCard),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.1)),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 20, offset: const Offset(0, 8)),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(color: Theme.of(context).scaffoldBackgroundColor, shape: BoxShape.circle),
            child: const Icon(Icons.router_rounded, color: AppColors.primary),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Ticket ID', style: GoogleFonts.jetBrainsMono(fontSize: 10, color: Colors.grey, fontWeight: FontWeight.bold)),
                Text('#JBR-9901', style: GoogleFonts.jetBrainsMono(fontSize: 16, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface)),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
                    ).animate(onPlay: (c) => c.repeat()).scale(begin: const Offset(1, 1), end: const Offset(1.5, 1.5), duration: 1.seconds).fadeOut(),
                    const SizedBox(width: 6),
                    Text('DIPROSES', style: GoogleFonts.jetBrainsMono(fontSize: 9, fontWeight: FontWeight.bold, color: AppColors.primary)),
                  ],
                ),
              ),
              const SizedBox(height: 4),
              Text('Update: 15 Menit lalu', style: GoogleFonts.dmSans(fontSize: 10, color: Colors.grey)),
            ],
          ),
        ],
      ),
    ).animate().fadeIn(delay: 500.ms).slideY(begin: 0.2);
  }

  Widget _buildVisitBanner(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push('/network-status'),
      child: Container(
        height: 140,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(32),
          gradient: const LinearGradient(
            colors: [Color(0xFF0ea5e9), Color(0xFF2563eb)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.blue.withValues(alpha: 0.2),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Stack(
          children: [
            Positioned(
              right: -20,
              bottom: -20,
              child: Icon(Icons.router_rounded, size: 160, color: Colors.white.withValues(alpha: 0.1)),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      'STATUS JARINGAN',
                      style: GoogleFonts.jetBrainsMono(fontSize: 9, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Cek Kondisi Area Kamu',
                    style: GoogleFonts.sora(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  const SizedBox(height: 4),
                  SizedBox(
                    width: 200,
                    child: Text(
                      'Pantau status koneksi dan estimasi perbaikan secara real-time.',
                      style: GoogleFonts.dmSans(fontSize: 13, color: Colors.white.withValues(alpha: 0.8)),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ).animate().fadeIn(delay: 700.ms);
  }
}
