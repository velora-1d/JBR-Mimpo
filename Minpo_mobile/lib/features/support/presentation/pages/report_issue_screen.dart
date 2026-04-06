import 'dart:ui';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:jbr_mimpo/core/theme/app_colors.dart';
import 'package:jbr_mimpo/core/utils/app_feedback.dart';
import 'package:go_router/go_router.dart';

class ReportIssueScreen extends StatefulWidget {
  const ReportIssueScreen({super.key});

  @override
  State<ReportIssueScreen> createState() => _ReportIssueScreenState();
}

class _ReportIssueScreenState extends State<ReportIssueScreen> {
  String? _selectedIssue;
  final TextEditingController _descriptionController = TextEditingController();
  bool _isSubmitting = false;
  XFile? _imageFile;
  final ImagePicker _picker = ImagePicker();

  final List<String> _issueTypes = [
    'Koneksi Terputus Total',
    'Internet Lambat (Lags)',
    'Wifi Tidak Terdeteksi',
    'Lampu Indikator Router Merah',
    'Lainnya',
  ];

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  void _submitReport() async {
    if (_selectedIssue == null) {
      AppFeedback.warning(context, 'Pilih jenis gangguan terlebih dahulu');
      return;
    }

    setState(() => _isSubmitting = true);
    
    // Simulate API Call
    await Future.delayed(2.seconds);
    
    if (!mounted) return;
    
    setState(() => _isSubmitting = false);
    _showSuccessDialog();
  }

  Future<void> _pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 70,
      );
      if (image != null) {
        setState(() => _imageFile = image);
      }
    } catch (e) {
      if (mounted) {
        AppFeedback.error(context, 'Gagal mengambil gambar: $e');
      }
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withValues(alpha: 0.5),
      builder: (context) => BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        child: Center(
          child: Container(
            width: 340,
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.98),
              borderRadius: BorderRadius.circular(40),
              boxShadow: [
                BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 40, offset: const Offset(0, 20)),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE8F5E9),
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.green.withValues(alpha: 0.2), width: 8),
                    ),
                    child: const Icon(Icons.check_circle_rounded, color: Colors.green, size: 56),
                  ).animate().scale(duration: 600.ms, curve: Curves.easeOutBack),
                  const SizedBox(height: 32),
                  Text('Laporan Terkirim!', style: GoogleFonts.sora(fontSize: 24, fontWeight: FontWeight.w900)),
                  const SizedBox(height: 16),
                  Text(
                    'Terima kasih atas laporannya. Tim teknisi kami akan segera menindaklanjuti masalah ini dalam waktu maksimal 1x24 jam.',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.dmSans(color: Colors.grey.shade600, height: 1.6, fontSize: 13),
                  ),
                  const SizedBox(height: 40),
                  SizedBox(
                    width: double.infinity,
                    height: 60,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                      ),
                      child: Text('Siap, Saya Mengerti', style: GoogleFonts.sora(fontWeight: FontWeight.bold, fontSize: 15)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgLight,
      body: Stack(
        children: [
          RefreshIndicator(
            onRefresh: () async => await Future.delayed(2.seconds),
            color: AppColors.primary,
            child: CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
              slivers: [
                _buildSliverHeader(),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildStepIndicator(),
                        const SizedBox(height: 40),
                        
                        _buildHeaderSection(),
                        const SizedBox(height: 40),
  
                        _buildSectionTitle('Detail Gangguan', Icons.error_outline_rounded),
                        const SizedBox(height: 16),
                        _buildIssueDropdown(),
                        const SizedBox(height: 24),
  
                        _buildSectionTitle('Deskripsi Masalah', Icons.edit_note_rounded),
                        const SizedBox(height: 16),
                        _buildDescriptionField(),
                        const SizedBox(height: 32),
  
                        _buildEvidenceSection(),
                        const SizedBox(height: 32),
  
                        _buildInfoBanner(),
                        const SizedBox(height: 140), // Space for sticky button
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          _buildStickyButton(),
          if (_isSubmitting)
            _buildLoadingOverlay(),
        ],
      ),
    );
  }

  Widget _buildSliverHeader() {
    return SliverAppBar(
      expandedHeight: 180,
      pinned: true,
      backgroundColor: AppColors.primary,
      elevation: 0,
      stretch: true,
      leading: Padding(
        padding: const EdgeInsets.all(8.0),
        child: _buildGlassButton(
          icon: Icons.arrow_back_rounded,
          onPressed: () => context.pop(),
        ),
      ),
      flexibleSpace: FlexibleSpaceBar(
        stretchModes: const [StretchMode.zoomBackground, StretchMode.blurBackground],
        title: Text(
          'Lapor Gangguan',
          style: GoogleFonts.sora(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
        background: Stack(
          fit: StackFit.expand,
          children: [
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.primary, Color(0xFF064e3b)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
            Positioned(
              right: -20,
              bottom: -20,
              child: Icon(Icons.rss_feed_rounded, size: 200, color: Colors.white.withValues(alpha: 0.05)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGlassButton({required IconData icon, required VoidCallback onPressed}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(12)),
          child: IconButton(icon: Icon(icon, color: Colors.white, size: 20), onPressed: onPressed),
        ),
      ),
    );
  }

  Widget _buildStepIndicator() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 10)]),
      child: Row(
        children: [
          _buildStepCircle('1', isCompleted: true),
          Expanded(child: Container(height: 2, color: AppColors.primary)),
          _buildStepCircle('2', isActive: true),
          Expanded(child: Container(height: 2, color: Colors.grey.shade200)),
          _buildStepCircle('3'),
          const SizedBox(width: 16),
          Text('Informasi Detail', style: GoogleFonts.sora(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.primary)),
        ],
      ),
    ).animate().fadeIn(duration: 300.ms).slideY(begin: 0.05, curve: Curves.easeOutQuad);
  }

  Widget _buildStepCircle(String label, {bool isCompleted = false, bool isActive = false}) {
    return Container(
      width: 28,
      height: 28,
      decoration: BoxDecoration(
        color: isCompleted || isActive ? AppColors.primary : Colors.grey.shade100,
        shape: BoxShape.circle,
        border: isActive ? Border.all(color: AppColors.primary.withValues(alpha: 0.2), width: 4) : null,
      ),
      child: Center(
        child: isCompleted 
          ? const Icon(Icons.check_rounded, size: 14, color: Colors.white)
          : Text(label, style: GoogleFonts.jetBrainsMono(fontSize: 12, fontWeight: FontWeight.bold, color: isActive ? Colors.white : Colors.grey)),
      ),
    );
  }

  Widget _buildHeaderSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Layanan Terkendala?',
          style: GoogleFonts.sora(fontSize: 26, fontWeight: FontWeight.w900, color: AppColors.textPrimary),
        ),
        const SizedBox(height: 8),
        Text(
          'Beritahu kami kendala Anda agar tim teknis dapat memberikan solusi terbaik secepatnya.',
          style: GoogleFonts.dmSans(fontSize: 14, color: AppColors.textSecondary, height: 1.5),
        ),
      ],
    ).animate().fadeIn(duration: 300.ms, delay: 100.ms).slideY(begin: 0.05, curve: Curves.easeOutQuad);
  }

  Widget _buildSectionTitle(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 18, color: AppColors.primary),
        const SizedBox(width: 8),
        Text(title, style: GoogleFonts.sora(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
      ],
    );
  }

  Widget _buildIssueDropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade100),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _selectedIssue,
          hint: Text('Pilih kategori gangguan', style: GoogleFonts.dmSans(color: Colors.grey.shade400, fontSize: 14)),
          isExpanded: true,
          icon: const Icon(Icons.keyboard_arrow_down_rounded, color: AppColors.primary),
          items: _issueTypes.map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value, style: GoogleFonts.dmSans(fontWeight: FontWeight.w600, fontSize: 14)),
            );
          }).toList(),
          onChanged: (val) => setState(() => _selectedIssue = val),
        ),
      ),
    );
  }

  Widget _buildDescriptionField() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.grey.shade100),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: TextField(
        controller: _descriptionController,
        maxLines: 4,
        style: GoogleFonts.dmSans(fontSize: 14),
        decoration: InputDecoration(
          hintText: 'Contoh: Lampu LOS merah atau internet mati total sejak pukul 10 pagi...',
          hintStyle: GoogleFonts.dmSans(color: Colors.grey.shade300, fontSize: 13, height: 1.5),
          border: InputBorder.none,
          isDense: true,
          contentPadding: EdgeInsets.zero,
        ),
      ),
    );
  }

  Widget _buildEvidenceSection() {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionTitle('Foto Bukti', Icons.camera_alt_outlined),
              const SizedBox(height: 12),
              _buildUploadCard(),
            ],
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionTitle('Lokasi', Icons.location_on_outlined),
              const SizedBox(height: 12),
              _buildLocationCard(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildUploadCard() {
    return GestureDetector(
      onTap: _pickImage,
      child: Container(
        height: 140,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: AppColors.primary.withValues(alpha: 0.1), style: BorderStyle.solid),
          image: _imageFile != null 
            ? DecorationImage(image: FileImage(File(_imageFile!.path)), fit: BoxFit.cover)
            : null,
        ),
        child: _imageFile != null
          ? Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                color: Colors.black.withValues(alpha: 0.3),
              ),
              child: const Center(child: Icon(Icons.edit_rounded, color: Colors.white, size: 28)),
            )
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.05), shape: BoxShape.circle),
                  child: const Icon(Icons.add_a_photo_rounded, color: AppColors.primary, size: 24),
                ),
                const SizedBox(height: 12),
                Text('Ambil Foto', style: GoogleFonts.sora(fontSize: 12, fontWeight: FontWeight.bold)),
              ],
            ),
      ),
    );
  }

  Widget _buildLocationCard() {
    return Container(
      height: 140,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        image: const DecorationImage(
          image: CachedNetworkImageProvider('https://images.unsplash.com/photo-1524661135-423995f22d0b?q=80&w=2674&auto=format&fit=crop'),
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Colors.transparent, Colors.black.withValues(alpha: 0.6)]),
        ),
        child: const Center(child: Icon(Icons.my_location_rounded, color: Colors.white, size: 24)),
      ),
    );
  }

  Widget _buildInfoBanner() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.blue.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.blue.withValues(alpha: 0.1)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.info_rounded, color: Colors.blue, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Laporan Anda akan diprioritaskan. Gunakan menu Tracking untuk memantau status perbaikan.',
              style: GoogleFonts.dmSans(fontSize: 12, color: Colors.blue.shade700, height: 1.5, fontWeight: FontWeight.w500),
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
        padding: const EdgeInsets.fromLTRB(24, 20, 24, 40),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColors.bgLight.withValues(alpha: 0), AppColors.bgLight.withValues(alpha: 0.9), AppColors.bgLight],
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            boxShadow: [BoxShadow(color: AppColors.primary.withValues(alpha: 0.2), blurRadius: 20, offset: const Offset(0, 10))],
          ),
          child: ElevatedButton(
            onPressed: _isSubmitting ? null : _submitReport,
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 64),
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
              elevation: 0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.send_rounded, size: 20),
                const SizedBox(width: 12),
                Text('Kirim Laporan', style: GoogleFonts.sora(fontSize: 16, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingOverlay() {
    return Container(
      color: Colors.black.withValues(alpha: 0.4),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
        child: Center(
          child: Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(32)),
            child: const CircularProgressIndicator(color: AppColors.primary, strokeWidth: 5),
          ),
        ),
      ),
    );
  }
}
