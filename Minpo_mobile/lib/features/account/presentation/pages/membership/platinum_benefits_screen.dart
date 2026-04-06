import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jbr_mimpo/core/theme/app_colors.dart';
import 'package:jbr_mimpo/features/account/domain/models/membership_tier.dart';

class PlatinumBenefitsScreen extends StatelessWidget {
  const PlatinumBenefitsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const tier = MembershipTier.platinum;

    return Scaffold(
      backgroundColor: AppColors.bgLight,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Keuntungan Platinum',
          style: GoogleFonts.sora(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.textPrimary, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeroCard(tier),
            const SizedBox(height: 32),
            Text(
              'Rincian Keuntungan',
              style: GoogleFonts.sora(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
            ),
            const SizedBox(height: 16),
            _buildBenefitList(tier),
            const SizedBox(height: 40),
            _buildUpgradeInfo(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeroCard(MembershipTier tier) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [tier.color, tier.color.withValues(alpha: 0.8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: tier.color.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.star_rounded, color: Colors.white, size: 16),
                    const SizedBox(width: 4),
                    Text(
                      tier.label,
                      style: GoogleFonts.jetBrainsMono(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.workspace_premium_rounded, color: Colors.white, size: 32),
            ],
          ),
          const SizedBox(height: 24),
          Text(
            'Selamat!\nAnda di Level Tertinggi',
            style: GoogleFonts.sora(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 8),
          Text(
            'Nikmati akses penuh ke seluruh fitur eksklusif JBR Minpo.',
            style: GoogleFonts.dmSans(fontSize: 14, color: Colors.white.withValues(alpha: 0.9)),
          ),
        ],
      ),
    );
  }

  Widget _buildBenefitList(MembershipTier tier) {
    final benefits = [
      {'icon': Icons.account_balance_wallet_rounded, 'title': 'Cashback 5%', 'desc': 'Kumpulkan saldo dari setiap transaksi.'},
      {'icon': Icons.support_agent_rounded, 'title': 'Prioritas CS 24/7', 'desc': 'Bantuan langsung tanpa antrian panjang.'},
      {'icon': Icons.devices_rounded, 'title': 'Batas 4 Perangkat', 'desc': 'Gunakan akun di lebih banyak perangkat.'},
      {'icon': Icons.bolt_rounded, 'title': 'Akses Event Cepat', 'desc': 'Daftar event lebih awal dari member lain.'},
    ];

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: benefits.length,
      separatorBuilder: (context, index) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        final item = benefits[index];
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.grey.withValues(alpha: 0.1)),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: tier.color.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(item['icon'] as IconData, color: tier.color, size: 24),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(item['title'] as String, style: GoogleFonts.sora(fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                    const SizedBox(height: 2),
                    Text(item['desc'] as String, style: GoogleFonts.dmSans(fontSize: 13, color: AppColors.textSecondary)),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildUpgradeInfo() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.1)),
      ),
      child: Column(
        children: [
          Icon(Icons.info_outline_rounded, color: AppColors.primary, size: 24),
          const SizedBox(height: 12),
          Text(
            'Status Keanggotaan Selamanya',
            textAlign: TextAlign.center,
            style: GoogleFonts.sora(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.primary),
          ),
          const SizedBox(height: 4),
          Text(
            'Nikmati keuntungan ini tanpa perlu perpanjangan biaya berlangganan.',
            textAlign: TextAlign.center,
            style: GoogleFonts.dmSans(fontSize: 12, color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }
}
