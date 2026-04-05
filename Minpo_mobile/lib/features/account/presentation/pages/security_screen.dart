import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jbr_mimpo/core/theme/app_colors.dart';

class SecurityScreen extends StatelessWidget {
  const SecurityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgLight,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              // 1. Custom App Bar
              _buildAppBar(context),
              
              // 2. Hero Section
              _buildSecurityHero(),
              
              const SizedBox(height: 16),
              
              // 3. Device List Section
              _buildDeviceSection(),
              
              const SizedBox(height: 32),
              
              // 4. Logout All Button
              _buildMassLogoutSection(),
              
              const SizedBox(height: 120), // Bottom Navi padding
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const CircleAvatar(
                radius: 20,
                backgroundImage: NetworkImage('https://lh3.googleusercontent.com/aida-public/AB6AXuBgRX_SoYRKkMkyH5IysWhbBc4uT616_O7AX7siRtbI-ZPQWngYshaoBi_zPnj8sBIm17ip3ChcLdoxyXsLFi099Ib8n3lKPgC-seaTjMbsaEbNf502iuAx1vT5k_3Nae3JLWW4invwi8wOf1KGeZGLb3nuTStpznXM3AfEPmT83-dHBpZwChP6syO3u3I1ZkTDe8BQomhALyDetUKXb7lTgJEoSJZ_rWVB6ORwu4gf4Swweem7zH3lj45bGlBBaQOP8zXPAGz3Dqpk'),
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
    );
  }

  Widget _buildSecurityHero() {
    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            // Outer Glows
            Container(
              width: 180,
              height: 180,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.05),
                shape: BoxShape.circle,
              ),
            ).animate().scale(duration: 2.seconds, curve: Curves.easeInOut).fadeIn(),
            
            // 3D Shield Icon Container
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.primary, Color(0xFF10b981)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(40),
                boxShadow: [
                  BoxShadow(color: AppColors.primary.withValues(alpha: 0.3), blurRadius: 20, offset: const Offset(0, 10)),
                  BoxShadow(color: Colors.white.withValues(alpha: 0.3), blurRadius: 2, offset: const Offset(2, 2), spreadRadius: -2),
                ],
              ),
              child: const Icon(
                Icons.security_rounded,
                size: 64,
                color: Colors.white,
              ),
            ).animate().scale(curve: Curves.easeOutBack),
            
            // Floating Dots
            Positioned(
              top: 20,
              right: 20,
              child: Container(width: 8, height: 8, decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle)).animate().fadeIn(delay: 500.ms),
            ),
          ],
        ),
        const SizedBox(height: 24),
        Text(
          'Keamanan Akun',
          style: GoogleFonts.sora(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
        ).animate().fadeIn(delay: 300.ms),
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Text(
            'Pantau aktivitas login dan amankan akun Anda dari akses yang tidak sah.',
            textAlign: TextAlign.center,
            style: GoogleFonts.dmSans(fontSize: 14, color: Colors.grey),
          ),
        ).animate().fadeIn(delay: 400.ms),
      ],
    );
  }

  Widget _buildDeviceSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Perangkat Terhubung',
                style: GoogleFonts.sora(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(color: const Color(0xFF82f5c1).withValues(alpha: 0.2), borderRadius: BorderRadius.circular(20)),
                child: Text(
                  '3 AKTIF',
                  style: GoogleFonts.sora(fontSize: 10, fontWeight: FontWeight.w800, color: const Color(0xFF00714e)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildDeviceCard(
            label: 'iPhone 14',
            location: 'Jakarta, Indonesia',
            ip: '192.168.1.45',
            icon: Icons.smartphone_rounded,
            isActive: true,
          ),
          _buildDeviceCard(
            label: 'Macbook Pro',
            location: 'Bandung, Indonesia',
            ip: '10.20.44.12',
            icon: Icons.laptop_mac_rounded,
            time: '2 jam lalu',
          ),
          _buildDeviceCard(
            label: 'Chrome Windows',
            location: 'Bekasi, Indonesia',
            ip: '172.16.254.1',
            icon: Icons.browser_updated_rounded,
            time: 'Kemarin',
          ),
        ],
      ),
    ).animate().fadeIn(delay: 500.ms).slideY(begin: 0.1);
  }

  Widget _buildDeviceCard({
    required String label,
    required String location,
    required String ip,
    required IconData icon,
    bool isActive = false,
    String? time,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.05)),
      ),
      child: Row(
        children: [
          // Claymorphism Icon container
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                 BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(2, 4)),
                 BoxShadow(color: Colors.white, blurRadius: 4, offset: const Offset(-2, -4)),
              ],
            ),
            child: Icon(icon, color: isActive ? AppColors.primary : Colors.grey, size: 28),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(label, style: GoogleFonts.sora(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                    if (isActive)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)),
                        child: Text(
                          'AKTIF',
                          style: GoogleFonts.sora(fontSize: 8, fontWeight: FontWeight.w900, color: AppColors.primary),
                        ),
                      )
                    else
                      Text(time ?? '', style: GoogleFonts.jetBrainsMono(fontSize: 10, color: Colors.grey)),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.location_on_rounded, size: 12, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text(location, style: GoogleFonts.dmSans(fontSize: 11, color: Colors.grey)),
                  ],
                ),
                Text(
                  'IP: $ip',
                  style: GoogleFonts.jetBrainsMono(fontSize: 10, color: Colors.grey.withValues(alpha: 0.6)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMassLogoutSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          OutlinedButton(
            onPressed: () {},
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.red,
              side: const BorderSide(color: Colors.red, width: 2),
              minimumSize: const Size(double.infinity, 60),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.logout_rounded),
                const SizedBox(width: 12),
                Text(
                  'Logout dari Semua Perangkat',
                  style: GoogleFonts.sora(fontWeight: FontWeight.bold, fontSize: 14),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              'Tindakan ini akan mengakhiri semua sesi aktif kecuali perangkat yang Anda gunakan saat ini.',
              textAlign: TextAlign.center,
              style: GoogleFonts.dmSans(fontSize: 11, color: Colors.grey, height: 1.5),
            ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: 700.ms);
  }
}
