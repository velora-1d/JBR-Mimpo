import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jbr_mimpo/core/theme/app_colors.dart';

class DeleteAccountScreen extends StatefulWidget {
  const DeleteAccountScreen({super.key});

  @override
  State<DeleteAccountScreen> createState() => _DeleteAccountScreenState();
}

class _DeleteAccountScreenState extends State<DeleteAccountScreen> {
  bool _isConfirmed = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Hapus Akun'),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.red,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.red.withValues(alpha: 0.05),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.warning_rounded, color: Colors.red, size: 80),
            ).animate().shake(duration: 1.seconds),
            const SizedBox(height: 32),
            Text(
              'Apakah Anda yakin?',
              style: GoogleFonts.sora(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              'Penghapusan akun bersifat permanen dan tidak dapat dibatalkan. Semua data layanan, riwayat tagihan, dan akses Anda akan dihapus sepenuhnya.',
              style: GoogleFonts.dmSans(fontSize: 14, color: Colors.grey, height: 1.6),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 48),
            _buildWarningCard(),
            const SizedBox(height: 40),
            CheckboxListTile(
              value: _isConfirmed,
              onChanged: (v) => setState(() => _isConfirmed = v ?? false),
              title: Text(
                'Saya memahami konsekuensi penghapusan akun.',
                style: GoogleFonts.dmSans(fontSize: 13, fontWeight: FontWeight.bold),
              ),
              activeColor: Colors.red,
              controlAffinity: ListTileControlAffinity.leading,
              contentPadding: EdgeInsets.zero,
            ),
            const SizedBox(height: 32),
            _buildActionButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildWarningCard() {
    final warnings = [
      'Akses ke aplikasi JBR Minpo akan dihentikan.',
      'Sisa poin dan reward akan hangus.',
      'Riwayat tiket gangguan tidak bisa diakses.',
      'Data profil & perangkat terhubung akan dihapus.',
    ];

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.red.withValues(alpha: 0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: warnings.map((w) => Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Row(
            children: [
              const Icon(Icons.check_circle_rounded, color: Colors.red, size: 18),
              const SizedBox(width: 12),
              Expanded(child: Text(w, style: GoogleFonts.dmSans(fontSize: 12, color: AppColors.textSecondary))),
            ],
          ),
        )).toList(),
      ),
    ).animate().fadeIn(delay: 300.ms).slideY(begin: 0.1);
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 60,
          child: ElevatedButton(
            onPressed: _isConfirmed ? () {
              // Implementation of account deletion
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Permintaan penghapusan akun sedang diproses.')),
              );
            } : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            ),
            child: Text(
              'Hapus Akun Sekarang',
              style: GoogleFonts.sora(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        const SizedBox(height: 16),
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(
            'Batalkan & Kembali',
            style: GoogleFonts.dmSans(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.primary),
          ),
        ),
      ],
    ).animate().fadeIn(delay: 500.ms);
  }
}
