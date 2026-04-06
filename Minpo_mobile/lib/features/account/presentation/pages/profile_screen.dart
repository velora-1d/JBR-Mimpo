import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:jbr_mimpo/core/theme/app_colors.dart';
import 'package:jbr_mimpo/core/utils/app_feedback.dart';
import 'package:go_router/go_router.dart';
import 'dart:ui';
import 'package:jbr_mimpo/features/account/domain/models/membership_tier.dart';
import 'package:jbr_mimpo/features/account/presentation/providers/membership_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tier = ref.watch(membershipProvider);
    return Scaffold(
      backgroundColor: AppColors.bgLight,
      body: RefreshIndicator(
        color: AppColors.primary,
        onRefresh: () async => await Future.delayed(const Duration(seconds: 1)),
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
          slivers: [
            _buildHeader(context, tier),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
                child: Column(
                  children: [
                    _buildMembershipCard(context, tier),
                    const SizedBox(height: 32),
                    _buildStatsGrid(),
                    const SizedBox(height: 32),
                    _buildMenuSection(context, 'Akun & Keamanan', [
                      _buildMenuItem(context, 'Edit Profil', Icons.person_outline_rounded, '/profile/edit-profile'),
                      _buildMenuItem(context, 'Alamat Pemasangan', Icons.location_on_outlined, '/profile/address'),
                      _buildMenuItem(context, 'Ubah Password', Icons.lock_outline_rounded, '/profile/change-password'),
                      _buildMenuItem(context, 'Layanan Keamanan (2FA)', Icons.security_rounded, '/profile/security'),
                    ]),
                    const SizedBox(height: 24),
                    _buildMenuSection(context, 'Aplikasi & Preferensi', [
                      _buildMenuItem(context, 'Pengaturan Notifikasi', Icons.notifications_none_rounded, '/profile/notifications-settings'),
                      _buildMenuItem(context, 'Bahasa & Wilayah', Icons.language_rounded, '/profile/app-settings'),
                      _buildMenuItem(context, 'Hapus Akun', Icons.delete_outline_rounded, '/profile/delete-account', isDanger: true),
                    ]),
                    const SizedBox(height: 24),
                    _buildMenuSection(context, 'Informasi', [
                      _buildMenuItem(context, 'Tentang JBR Minpo', Icons.info_outline_rounded, '/profile/about'),
                      _buildMenuItem(context, 'Syarat & Ketentuan', Icons.gavel_rounded, '/profile/tos'),
                      _buildMenuItem(context, 'Kebijakan Privasi', Icons.privacy_tip_outlined, '/profile/privacy'),
                      _buildMenuItem(context, 'Kebijakan Khusus', Icons.star_outline_rounded, '/profile/special-policy'),
                    ]),
                    const SizedBox(height: 32),
                    _buildLogoutSection(context),
                    const SizedBox(height: 100), // Extra padding for bottom nav
                    Text('JBR Minpo v2.5.1 Stable', style: GoogleFonts.dmSans(fontSize: 10, color: Colors.grey)),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, MembershipTier tier) {
    return SliverAppBar(
      expandedHeight: 220,
      pinned: true,
      backgroundColor: AppColors.primary,
      elevation: 0,
      stretch: true,
      centerTitle: false,
      title: Text('Profil Saya', style: GoogleFonts.sora(color: Colors.white, fontWeight: FontWeight.bold)),
      flexibleSpace: FlexibleSpaceBar(
        stretchModes: const [StretchMode.zoomBackground, StretchMode.blurBackground],
        background: Stack(
          fit: StackFit.expand,
          children: [
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.primary, tier.color],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
            // Decorative background circles
            Positioned(
              top: -50,
              right: -50,
              child: CircleAvatar(radius: 100, backgroundColor: Colors.white.withValues(alpha: 0.05)),
            ),
            Positioned(
              left: 24,
              bottom: 30,
              child: Row(
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 3),
                      image: const DecorationImage(
                        image: CachedNetworkImageProvider('https://i.pravatar.cc/150?u=ahmad'),
                        fit: BoxFit.cover,
                      ),
                      boxShadow: [
                        BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 20)
                      ],
                    ),
                  ).animate().scale(duration: 500.ms),
                  const SizedBox(width: 20),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Ahmad Syarif',
                        style: GoogleFonts.sora(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: tier.bgColor,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: tier.color.withValues(alpha: 0.3)),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.workspace_premium_rounded, color: tier.color, size: 12),
                            const SizedBox(width: 4),
                            Text(
                              tier.label,
                              style: GoogleFonts.jetBrainsMono(fontSize: 9, fontWeight: FontWeight.bold, color: tier.color),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMembershipCard(BuildContext context, MembershipTier tier) {
    return Container(
      width: double.infinity,
      height: 100,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: LinearGradient(
          colors: [Colors.white.withValues(alpha: 0.3), Colors.white.withValues(alpha: 0.1)],
        ),
        border: Border.all(color: Colors.white.withValues(alpha: 0.4)),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 20, offset: const Offset(0, 10))
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(tier.benefitTitle, style: GoogleFonts.jetBrainsMono(fontSize: 10, fontWeight: FontWeight.bold, color: tier.color)),
                      const SizedBox(height: 4),
                      Text(tier.benefitDescription, style: GoogleFonts.sora(fontSize: 13, color: AppColors.textPrimary)),
                    ],
                  ),
                ),
                TextButton(
                  onPressed: () => context.push('/profile/platinum-benefits'),
                  child: Text('LIHAT', style: GoogleFonts.sora(fontSize: 12, fontWeight: FontWeight.bold, color: tier.color)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatsGrid() {
    return Row(
      children: [
        Expanded(child: _buildStatItem('345', 'Hari Aktif', Icons.calendar_month_rounded, AppColors.primary)),
        const SizedBox(width: 12),
        Expanded(child: _buildStatItem('50M', 'Speed', Icons.speed_rounded, Colors.blue)),
        const SizedBox(width: 12),
        Expanded(child: _buildStatItem('8', 'Perangkat', Icons.devices_rounded, Colors.purple)),
      ],
    );
  }

  Widget _buildStatItem(String val, String label, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.01), blurRadius: 10)],
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: 8),
          Text(val, style: GoogleFonts.sora(fontSize: 16, fontWeight: FontWeight.bold)),
          Text(label, style: GoogleFonts.dmSans(fontSize: 10, color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _buildMenuSection(BuildContext context, String title, List<Widget> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 12),
          child: Text(
            title,
            style: GoogleFonts.sora(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(color: Colors.black.withValues(alpha: 0.01), blurRadius: 20)
            ],
          ),
          child: Column(children: items),
        ),
      ],
    );
  }

  Widget _buildMenuItem(BuildContext context, String title, IconData icon, String route, {bool isDanger = false}) {
    return ListTile(
      onTap: () => context.push(route),
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(color: AppColors.bgLight, borderRadius: BorderRadius.circular(10)),
        child: Icon(icon, color: isDanger ? Colors.red : AppColors.primary, size: 20),
      ),
      title: Text(
        title,
        style: GoogleFonts.dmSans(fontSize: 14, fontWeight: FontWeight.w500, color: isDanger ? Colors.red : AppColors.textPrimary),
      ),
      trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: Colors.grey),
    );
  }

  Widget _buildLogoutSection(BuildContext context) {
    return Column(
      children: [
        _buildLogoutButton(
          label: 'Keluar dari Akun',
          onTap: () => _showLogoutDialog(context, isMass: false),
          isMass: false,
        ),
        const SizedBox(height: 12),
        _buildLogoutButton(
          label: 'Logout dari Semua Perangkat',
          onTap: () => _showLogoutDialog(context, isMass: true),
          isMass: true,
        ),
      ],
    );
  }

  void _showLogoutDialog(BuildContext context, {required bool isMass}) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
        contentPadding: const EdgeInsets.all(24),
        title: Row(
          children: [
            Icon(
              isMass ? Icons.devices_other_rounded : Icons.logout_rounded,
              color: isMass ? Colors.orange : Colors.red,
            ),
            const SizedBox(width: 12),
            Text(
              isMass ? 'Logout Semua?' : 'Keluar Akun?',
              style: GoogleFonts.sora(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        content: Text(
          isMass
              ? 'Anda akan dikeluarkan dari semua perangkat aktif saat ini. Lanjutkan?'
              : 'Anda yakin ingin keluar dari akun JBR Minpo di perangkat ini?',
          style: GoogleFonts.dmSans(fontSize: 14, color: AppColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Batal',
              style: GoogleFonts.sora(color: Colors.grey, fontWeight: FontWeight.bold),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              if (isMass) {
                AppFeedback.success(context, 'Berhasil logout dari semua perangkat');
              } else {
                context.go('/login');
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: isMass ? Colors.orange : Colors.red,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text('Keluar'),
          ),
        ],
      ),
    );
  }

  Widget _buildLogoutButton({required String label, required VoidCallback onTap, required bool isMass}) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: isMass ? Colors.orange.withValues(alpha: 0.05) : Colors.red.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: isMass ? Colors.orange.withValues(alpha: 0.1) : Colors.red.withValues(alpha: 0.1)),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 18),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(isMass ? Icons.devices_other_rounded : Icons.logout_rounded, color: isMass ? Colors.orange : Colors.red, size: 22),
                const SizedBox(width: 12),
                Text(
                  label,
                  style: GoogleFonts.sora(fontSize: 14, fontWeight: FontWeight.bold, color: isMass ? Colors.orange : Colors.red),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
