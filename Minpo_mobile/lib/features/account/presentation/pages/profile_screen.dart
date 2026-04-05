import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jbr_mimpo/core/theme/app_colors.dart';
import 'package:jbr_mimpo/core/theme/app_dimensions.dart';
import 'package:go_router/go_router.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            // 1. Premium Emerald Header
            _buildPremiumHeader(context),
            
            // 2. Bento Stats Hub
            _buildBentoStatsHub(context),
            
            // 3. Menu List
            _buildMenuList(context),
            
            // 4. Footer
            _buildFooter(),
            
            const SizedBox(height: 120), // Padding for Bottom Navigation
          ],
        ),
      ),
    );
  }

  Widget _buildPremiumHeader(BuildContext context) {
    return Stack(
      children: [
        // Background Gradient with Glow
        Container(
          height: 320,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColors.primary, Color(0xFF064e3b)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(40),
              bottomRight: Radius.circular(40),
            ),
          ),
        ),
        // Ambient Glow Dots
        Positioned(
          top: -50,
          left: -50,
          child: Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
          ).animate().scale(duration: 3.seconds, curve: Curves.easeInOut).fadeIn(),
        ),
        
        // Content
        SafeArea(
          child: Column(
            children: [
              // Top Bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                     Row(
                      children: [
                         Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.2),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.person_rounded, color: Colors.white, size: 20),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'JBR Minpo',
                          style: GoogleFonts.sora(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                      ],
                    ),
                    IconButton(
                      onPressed: () => context.push('/faq'),
                      icon: const Icon(Icons.support_agent_rounded, color: Colors.white),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 20),
              
              // Avatar
              Center(
                child: Stack(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white.withValues(alpha: 0.3), width: 4),
                        boxShadow: [
                          BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 20, offset: const Offset(0, 10)),
                        ],
                      ),
                      child: const CircleAvatar(
                        radius: 50,
                        backgroundImage: NetworkImage('https://lh3.googleusercontent.com/aida-public/AB6AXuBWemjxFV6B__HQV4yyQeZQSg-zszgymP3w2vssTlH6-YETvxMrdV-E3xqzWfW0GCv90sP2vOdjxyu13s2cU7UdsxM9wD8q8c4xISCbmnVQyzVjW-SJy4e8RT4zalXoACSYmUXLPjrXzLzVZ_ibIVj1VIk2cIXL3jcN1UqhiRN2GWjpgcdYgFxq3Pj8fm5n4inpAtZKdWkq5OFwGiB6TGP1oZm0YWve6fhGFBhLzfoJ-TahS0WEZKd-aP8Dw5tyjoqWnLCbFZp2oSLQ'),
                      ),
                    ),
                    Positioned(
                      bottom: 5,
                      right: 5,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                        child: const Icon(Icons.verified_rounded, color: AppColors.primary, size: 20),
                      ),
                    ),
                  ],
                ),
              ).animate().scale(delay: 200.ms, curve: Curves.easeOutBack),
              
              const SizedBox(height: 16),
              
              // Name & Phone
              Text(
                'Budi Santoso',
                style: GoogleFonts.sora(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
              ).animate().fadeIn(delay: 300.ms),
              Text(
                '0812-3456-7890',
                style: GoogleFonts.jetBrainsMono(fontSize: 14, color: Colors.white.withValues(alpha: 0.7), fontWeight: FontWeight.w500),
              ).animate().fadeIn(delay: 400.ms),
              
              const SizedBox(height: 16),
              
              // Platinum Badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.white.withValues(alpha: 0.3)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.workspace_premium_rounded, color: Colors.amber, size: 16),
                    const SizedBox(width: 8),
                    Text(
                      'MEMBER PLATINUM',
                      style: GoogleFonts.sora(fontSize: 11, fontWeight: FontWeight.w800, color: Colors.white, letterSpacing: 1),
                    ),
                  ],
                ),
              ).animate().fadeIn(delay: 500.ms).slideY(begin: 0.5),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBentoStatsHub(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: Row(
        children: [
          Expanded(
            child: _buildBentoCard(
              context,
              label: 'Total Points',
              value: '12,450',
              unit: 'PTS',
              icon: Icons.auto_awesome_rounded,
              color: Colors.amber,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: _buildBentoCard(
              context,
              label: 'Active Plan',
              value: '500',
              unit: 'MBPS',
              icon: Icons.speed_rounded,
              color: AppColors.primary,
            ),
          ),
        ],
      ).animate().fadeIn(delay: 600.ms).slideY(begin: 0.2),
    );
  }

  Widget _buildBentoCard(
    BuildContext context, {
    required String label,
    required String value,
    required String unit,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(AppDimensions.radiusCard),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 20, offset: const Offset(0, 8)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: color.withValues(alpha: 0.1), shape: BoxShape.circle),
            child: Icon(icon, color: color, size: 16),
          ),
          const SizedBox(height: 12),
          Text(label, style: GoogleFonts.dmSans(fontSize: 12, color: Colors.grey)),
          const SizedBox(height: 4),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(value, style: GoogleFonts.sora(fontSize: 22, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface)),
              const SizedBox(width: 4),
              Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Text(unit, style: GoogleFonts.sora(fontSize: 10, fontWeight: FontWeight.bold, color: color)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMenuList(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(AppDimensions.radiusCard),
              boxShadow: [
                BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 10, offset: const Offset(0, 4)),
              ],
            ),
            child: Column(
              children: [
                _buildMenuItem(
                  icon: Icons.person_outline_rounded,
                  title: 'Edit Profil',
                  onTap: () {
                    HapticFeedback.selectionClick();
                    context.push('/edit-profile');
                  },
                ),
                _buildDivider(),
                _buildMenuItem(
                  icon: Icons.lock_reset_rounded,
                  title: 'Ganti Sandi',
                  onTap: () {
                    HapticFeedback.selectionClick();
                    context.push('/change-password');
                  },
                ),
                _buildDivider(),
                _buildMenuItem(
                  icon: Icons.notifications_none_rounded,
                  title: 'Pusat Notifikasi',
                  onTap: () {
                    HapticFeedback.selectionClick();
                    context.push('/notifications');
                  },
                ),
                _buildDivider(),
                _buildMenuItem(
                  icon: Icons.security_rounded,
                  title: 'Keamanan Akun',
                  onTap: () {
                    HapticFeedback.selectionClick();
                    context.push('/security');
                  },
                ),
                _buildDivider(),
                _buildMenuItem(
                  icon: Icons.language_rounded,
                  title: 'Bahasa & Info Aplikasi',
                  onTap: () {
                    HapticFeedback.selectionClick();
                    context.push('/app-settings');
                  },
                ),
                _buildDivider(),
                _buildMenuItem(
                  icon: Icons.help_outline_rounded,
                  title: 'Pusat Bantuan',
                  onTap: () {
                    HapticFeedback.selectionClick();
                    context.push('/faq');
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          
          // Logout Button
          GestureDetector(
            onTap: () => context.go('/login'),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: Colors.red.withValues(alpha: 0.1)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.logout_rounded, color: Colors.red, size: 20),
                  const SizedBox(width: 12),
                  Text(
                    'Logout Account',
                    style: GoogleFonts.sora(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.red),
                  ),
                ],
              ),
            ),
          ),
        ],
      ).animate().fadeIn(delay: 700.ms),
    );
  }

  Widget _buildMenuItem({required IconData icon, required String title, required VoidCallback onTap}) {
    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 6),
      leading: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.05), borderRadius: BorderRadius.circular(16)),
        child: Icon(icon, color: AppColors.primary, size: 22),
      ),
      title: Text(
        title,
        style: GoogleFonts.sora(fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
      ),
      trailing: const Icon(Icons.chevron_right_rounded, color: Colors.grey),
    );
  }

  Widget _buildDivider() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      height: 1,
      color: Colors.grey.withValues(alpha: 0.05),
    );
  }

  Widget _buildFooter() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 40),
      child: Column(
        children: [
          Text(
            'JBR MINPO V4.8.2-STABLE',
            style: GoogleFonts.jetBrainsMono(fontSize: 10, color: Colors.grey, fontWeight: FontWeight.bold, letterSpacing: 2),
          ),
          const SizedBox(height: 8),
          Text(
            '© 2024 JBR Connectivity Hub. All rights reserved.',
            style: GoogleFonts.dmSans(fontSize: 11, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
