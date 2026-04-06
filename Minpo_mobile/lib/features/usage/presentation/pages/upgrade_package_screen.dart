import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jbr_mimpo/core/theme/app_colors.dart';
import 'package:go_router/go_router.dart';

class UpgradePackageScreen extends StatefulWidget {
  const UpgradePackageScreen({super.key});

  @override
  State<UpgradePackageScreen> createState() => _UpgradePackageScreenState();
}

class _UpgradePackageScreenState extends State<UpgradePackageScreen> {
  int _selectedPackageIndex = 1; // Default to 'PRO'

  final List<Map<String, dynamic>> _packages = [
    {
      'name': 'LITE',
      'speed': '50',
      'price': 'Rp 249.000',
      'features': ['SD Streaming', '2 Devices', 'Unlimited FUP'],
      'isPopular': false,
    },
    {
      'name': 'PRO',
      'speed': '150',
      'price': 'Rp 499.000',
      'features': ['4K Streaming', '10 Devices', 'Priority Support', 'Public IP'],
      'isPopular': true,
    },
    {
      'name': 'ULTRA',
      'speed': '500',
      'price': 'Rp 899.000',
      'features': ['8K Streaming', '25 Devices', 'Personal Manager', 'Zero Latency'],
      'isPopular': false,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgLight,
      appBar: AppBar(
        title: const Text('Upgrade Paket'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => context.pop(),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Pilih Kecepatan Impianmu',
                style: GoogleFonts.sora(fontSize: 24, fontWeight: FontWeight.w900, color: AppColors.textPrimary),
              ),
              const SizedBox(height: 8),
              Text(
                'Rasakan pengalaman internet tanpa batas dengan paket premium kami.',
                style: GoogleFonts.dmSans(fontSize: 14, color: AppColors.textSecondary),
              ),
              const SizedBox(height: 32),
              
              // Package List
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _packages.length,
                separatorBuilder: (context, index) => const SizedBox(height: 16),
                itemBuilder: (context, index) {
                  return _buildPackageCard(index);
                },
              ),
              
              const SizedBox(height: 40),
              
              // Bottom Action
              _buildBottomAction(),
              
              const SizedBox(height: 48),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPackageCard(int index) {
    final pkg = _packages[index];
    final isSelected = _selectedPackageIndex == index;
    final color = pkg['isPopular'] ? AppColors.primary : Colors.white;
    final textColor = pkg['isPopular'] ? Colors.white : AppColors.textPrimary;
    final subTextColor = pkg['isPopular'] ? Colors.white70 : AppColors.textSecondary;

    return GestureDetector(
      onTap: () => setState(() => _selectedPackageIndex = index),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(32),
          border: Border.all(
            color: isSelected ? AppColors.primary : Colors.transparent,
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: pkg['isPopular'] 
                  ? AppColors.primary.withValues(alpha: 0.3) 
                  : Colors.black.withValues(alpha: 0.05),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Stack(
          children: [
            if (pkg['isPopular'])
              Positioned(
                top: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'HOT DEAL',
                    style: GoogleFonts.jetBrainsMono(
                      fontSize: 10,
                      fontWeight: FontWeight.w900,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ),
            
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  pkg['name'],
                  style: GoogleFonts.jetBrainsMono(
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    color: subTextColor,
                    letterSpacing: 2,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(
                      pkg['speed'],
                      style: GoogleFonts.sora(
                        fontSize: 40,
                        fontWeight: FontWeight.w900,
                        color: textColor,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Mbps',
                      style: GoogleFonts.sora(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  pkg['price'] + ' / bulan',
                  style: GoogleFonts.dmSans(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
                const SizedBox(height: 20),
                Wrap(
                  spacing: 12,
                  runSpacing: 8,
                  children: (pkg['features'] as List<String>).map((feat) {
                    return Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.check_circle_rounded, size: 14, color: textColor),
                        const SizedBox(width: 8),
                        Text(
                          feat,
                          style: GoogleFonts.dmSans(fontSize: 12, color: subTextColor),
                        ),
                      ],
                    );
                  }).toList(),
                ),
              ],
            ),
          ],
        ),
      ).animate(target: isSelected ? 1 : 0)
       .scale(begin: const Offset(1, 1), end: const Offset(1.02, 1.02), duration: 200.ms),
    );
  }

  Widget _buildBottomAction() {
    final selectedPkg = _packages[_selectedPackageIndex];
    
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 40),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Total Pembayaran', style: GoogleFonts.dmSans(fontSize: 12, color: Colors.grey)),
                  Text(
                    selectedPkg['price'],
                    style: GoogleFonts.sora(fontSize: 20, fontWeight: FontWeight.w900, color: AppColors.primary),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'Tax Included',
                  style: GoogleFonts.dmSans(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.primary),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => _showConfirmation(),
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 64),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              elevation: 8,
              shadowColor: AppColors.primary.withValues(alpha: 0.3),
            ),
            child: Text(
              'Konfirmasi Upgrade',
              style: GoogleFonts.sora(fontWeight: FontWeight.w800, fontSize: 16),
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 300.ms).slideY(begin: 0.05);
  }

  void _showConfirmation() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.all(32),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(2))),
            const SizedBox(height: 24),
            Text('Konfirmasi Pesanan', style: GoogleFonts.sora(fontSize: 20, fontWeight: FontWeight.w900)),
            const SizedBox(height: 12),
            Text(
              'Apakah Anda yakin ingin melakukan upgrade ke paket ${_packages[_selectedPackageIndex]['name']}?',
              textAlign: TextAlign.center,
              style: GoogleFonts.dmSans(color: Colors.grey),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                _showSuccess();
              },
              child: const Text('Ya, Upgrade Sekarang'),
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Batal', style: GoogleFonts.dmSans(color: Colors.grey, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }

  void _showSuccess() {
    showDialog(
      context: context,
      builder: (context) => Center(
        child: Container(
          width: 320,
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(40)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.rocket_launch_rounded, color: AppColors.primary, size: 64),
              const SizedBox(height: 24),
              Text('Wushhh!', style: GoogleFonts.sora(fontSize: 24, fontWeight: FontWeight.w900)),
              const SizedBox(height: 12),
              Text(
                'Permintaan upgrade Anda sedang diproses. Kecepatan baru akan aktif dalam 5-10 menit.',
                textAlign: TextAlign.center,
                style: GoogleFonts.dmSans(fontSize: 14, color: Colors.grey),
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context); // Close dialog
                  context.go('/home'); // Go back home
                },
                child: const Text('Kembali ke Dashboard'),
              ),
            ],
          ),
        ),
      ).animate().fadeIn(duration: 200.ms).scale(begin: const Offset(0.95, 0.95), curve: Curves.easeOutCubic),
    );
  }
}
