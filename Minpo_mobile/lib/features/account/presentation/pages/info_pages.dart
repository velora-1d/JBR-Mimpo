import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jbr_mimpo/core/theme/app_colors.dart';

class InfoPage extends StatelessWidget {
  final String title;
  final String type;

  const InfoPage({
    super.key,
    required this.title,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgLight,
      appBar: AppBar(
        title: Text(title),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildContentHeader(),
            const SizedBox(height: 32),
            _buildMainContent(),
            const SizedBox(height: 60),
            Center(
              child: Text(
                'Terakhir diperbarui: 5 April 2026',
                style: GoogleFonts.dmSans(fontSize: 12, color: Colors.grey),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildContentHeader() {
    String subtitle = '';
    IconData icon = Icons.info_outline_rounded;
    
    if (type == 'about') {
      subtitle = 'Mengenal lebih dekat JBR Minpo & JBR Digital Infrastructure.';
      icon = Icons.domain_rounded;
    } else if (type == 'tos') {
      subtitle = 'Aturan penggunaan layanan untuk memastikan kenyamanan bersama.';
      icon = Icons.gavel_rounded;
    } else if (type == 'special') {
      subtitle = 'Ketentuan khusus mengenai penggunaan infrastruktur dan layanan tertentu.';
      icon = Icons.star_outline_rounded;
    } else {
      subtitle = 'Bagaimana kami menjaga dan melindungi data pribadi Anda.';
      icon = Icons.privacy_tip_outlined;
    }

    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Icon(icon, color: AppColors.primary, size: 32),
        ),
        const SizedBox(width: 20),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Informasi Resmi',
                style: GoogleFonts.jetBrainsMono(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.primary),
              ),
              Text(
                subtitle,
                style: GoogleFonts.dmSans(fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.textSecondary),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMainContent() {
    if (type == 'about') {
      return _buildAboutContent();
    } else {
      return _buildLegalContent();
    }
  }

  Widget _buildAboutContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSection('Visi Kami', 'Menjadi penyedia solusi infrastruktur digital terbaik di Indonesia yang menghubungkan setiap individu dengan teknologi masa depan.'),
        const SizedBox(height: 24),
        _buildSection('Misi Kami', 'Menyediakan layanan internet yang stabil, cepat, dan terjangkau untuk semua lapisan masyarakat.'),
        const SizedBox(height: 24),
        _buildSection('Teknologi', 'Kami menggunakan jaringan fiber optic ultra-modern yang tahan terhadap cuaca dan gangguan eksternal untuk menjamin uptime 99.9%.'),
      ],
    );
  }

  Widget _buildLegalContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSection('1. Ketentuan Umum', 'Layanan JBR Minpo tunduk pada hukum yang berlaku di Republik Indonesia. Pengguna wajib mematuhi aturan penggunaan yang wajar.'),
        const SizedBox(height: 24),
        _buildSection('2. Kewajiban Pengguna', 'Pengguna dilarang menggunakan jaringan JBR Minpo untuk aktivitas ilegal, hacking, atau penyebaran konten berbahaya.'),
        const SizedBox(height: 24),
        _buildSection('3. Keamanan Data', 'Data pribadi Anda disimpan dalam server terenkripsi dan tidak akan dibagikan kepada pihak ketiga tanpa izin eksplisit.'),
        const SizedBox(height: 24),
        _buildSection('4. Perubahan Layanan', 'JBR Minpo berhak memperbarui sistem atau paket layanan demi meningkatkan kualitas pengalaman pengguna.'),
      ],
    );
  }

  Widget _buildSection(String title, String content) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 20, offset: const Offset(0, 10))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.sora(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
          ),
          const SizedBox(height: 12),
          Text(
            content,
            style: GoogleFonts.dmSans(fontSize: 14, color: AppColors.textSecondary, height: 1.6),
          ),
        ],
      ),
    );
  }
}
