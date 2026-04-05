import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jbr_mimpo/core/theme/app_colors.dart';
import 'package:go_router/go_router.dart';

class ReportIssueScreen extends StatefulWidget {
  const ReportIssueScreen({super.key});

  @override
  State<ReportIssueScreen> createState() => _ReportIssueScreenState();
}

class _ReportIssueScreenState extends State<ReportIssueScreen> {
  String? _selectedIssue;
  final List<String> _issueTypes = [
    'Koneksi Terputus Total',
    'Internet Lambat (Lags)',
    'Wifi Tidak Terdeteksi',
    'Lampu Indikator Router Merah',
    'Lainnya',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgLight,
      appBar: AppBar(
        backgroundColor: AppColors.bgLight,
        elevation: 0,
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_back_rounded, color: AppColors.primary),
        ),
        title: Text(
          'Support',
          style: GoogleFonts.sora(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.primary),
        ),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.contact_support_rounded, color: AppColors.primary)),
        ],
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. Progress Indicator
                _buildProgress(),
                const SizedBox(height: 32),

                // 2. Header Text
                Text(
                  'Lapor Gangguan',
                  style: GoogleFonts.sora(fontSize: 24, fontWeight: FontWeight.w800, color: AppColors.textPrimary),
                ),
                const SizedBox(height: 8),
                Text(
                  'Mohon lengkapi detail gangguan yang Anda alami agar teknisi kami dapat segera membantu.',
                  style: GoogleFonts.dmSans(fontSize: 14, color: AppColors.textSecondary),
                ),
                const SizedBox(height: 32),

                // 3. Form Fields
                _buildLabel('Jenis Gangguan'),
                _buildIssueDropdown(),
                const SizedBox(height: 24),

                _buildLabel('Deskripsi Masalah'),
                _buildDescriptionField(),
                const SizedBox(height: 24),

                // 4. Bento Upload & Map Row
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildLabel('Foto Bukti (Opsional)'),
                          _buildUploadBox(),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildLabel('Lokasi Kejadian'),
                          _buildMapPreview(),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),

                // 5. Info Box
                _buildInfoBox(),
                const SizedBox(height: 120), // Padding for sticky button
              ],
            ),
          ),

          // 6. Sticky Send Button
          _buildStickyButton(),
        ],
      ),
    );
  }

  Widget _buildProgress() {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 8,
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: 0.66,
              child: Container(
                decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(10)),
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Text('STEP 02 / 03', style: GoogleFonts.jetBrainsMono(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.primary)),
      ],
    ).animate().fadeIn().slideX(begin: 0.1);
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(text, style: GoogleFonts.sora(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
    );
  }

  Widget _buildIssueDropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _selectedIssue,
          hint: Text('Pilih jenis gangguan', style: GoogleFonts.dmSans(color: Colors.grey)),
          isExpanded: true,
          icon: const Icon(Icons.expand_more_rounded, color: AppColors.textSecondary),
          items: _issueTypes.map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value, style: GoogleFonts.dmSans(fontWeight: FontWeight.w500)),
            );
          }).toList(),
          onChanged: (val) => setState(() => _selectedIssue = val),
        ),
      ),
    );
  }

  Widget _buildDescriptionField() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
      child: TextField(
        maxLines: 4,
        style: GoogleFonts.dmSans(),
        decoration: InputDecoration(
          hintText: 'Ceritakan detail kendala yang dialami...',
          hintStyle: GoogleFonts.dmSans(color: Colors.grey.withValues(alpha: 0.6)),
          border: InputBorder.none,
          isDense: true,
          contentPadding: EdgeInsets.zero,
        ),
      ),
    );
  }

  Widget _buildUploadBox() {
    return Container(
      height: 160,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.grey.withValues(alpha: 0.2), style: BorderStyle.solid),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.1), shape: BoxShape.circle),
            child: const Icon(Icons.photo_camera_rounded, color: AppColors.primary),
          ),
          const SizedBox(height: 12),
          Text('Ambil atau Unggah', style: GoogleFonts.sora(fontSize: 11, fontWeight: FontWeight.bold)),
          Text('MAX 5MB', style: GoogleFonts.jetBrainsMono(fontSize: 9, color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _buildMapPreview() {
    return Container(
      height: 160,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        image: const DecorationImage(
          image: NetworkImage('https://lh3.googleusercontent.com/aida-public/AB6AXuAQ-VYcIK5WcaOHf1PxhWLxWJSz4ddB_6AI4w0kQdpgQOz5fZvMOYRdehoDTh1ldrU-xzgIKHR9EDNLF-ZsWFq6QMIanddxXo1hCoDL9RTXGsUXhwrf7zikHIDxe7WW0s7xBUd41yOG15tUfOH3bQGwV23QgCDEbho74YDnDhG4xuf0WZ1G1cCBBBc86E3M4-YHvDIdV-SsCOKs1lgiftz84EidkDeJKCvQi9LudOsZJ1Y909BUEQSMB1PpGGuAJlJ56etbKkUJWhUR'),
          fit: BoxFit.cover,
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            bottom: 8,
            left: 8,
            right: 8,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.8),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Icon(Icons.location_on_rounded, size: 14, color: AppColors.primary),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      'Jl. Kebon Jeruk No. 12...',
                      style: GoogleFonts.jetBrainsMono(fontSize: 9, fontWeight: FontWeight.bold),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoBox() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.blue.withValues(alpha: 0.1)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.info_outline_rounded, size: 20, color: Colors.blue),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Laporan Anda akan diproses dalam waktu maksimal 1x24 jam. Tim teknisi akan menghubungi nomor telepon yang terdaftar.',
              style: GoogleFonts.dmSans(fontSize: 12, color: Colors.blue.shade800, height: 1.5),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStickyButton() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColors.bgLight.withValues(alpha: 0), AppColors.bgLight],
          ),
        ),
        child: ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            minimumSize: const Size(double.infinity, 56),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            elevation: 8,
            shadowColor: AppColors.primary.withValues(alpha: 0.3),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Kirim Laporan', style: GoogleFonts.sora(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(width: 12),
              const Icon(Icons.send_rounded, size: 20),
            ],
          ),
        ),
      ).animate().slideY(begin: 1),
    );
  }
}
