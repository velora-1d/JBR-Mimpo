import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:jbr_mimpo/core/theme/app_colors.dart';
import 'package:jbr_mimpo/core/utils/app_feedback.dart';
import 'package:jbr_mimpo/core/widgets/app_dialog.dart';
import 'package:go_router/go_router.dart';

class InstallationRequestScreen extends StatefulWidget {
  const InstallationRequestScreen({super.key});

  @override
  State<InstallationRequestScreen> createState() => _InstallationRequestScreenState();
}

class _InstallationRequestScreenState extends State<InstallationRequestScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _addressController = TextEditingController();
  final _phoneController = TextEditingController();
  String? _selectedPackage;

  final List<String> _packages = [
    'Home Basic - 30 Mbps',
    'Home Pro - 50 Mbps',
    'Home Ultra - 100 Mbps',
    'Business Start - 100 Mbps',
    'Business Enterprise - 200 Mbps',
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      AppDialog.showConfirmation(
        context: context,
        title: 'Konfirmasi Pengajuan',
        message: 'Apakah data yang Anda masukkan sudah benar? Tim kami akan menghubungi Anda dalam 1x24 jam.',
        confirmText: 'Ya, Kirim',
        cancelText: 'Periksa Lagi',
        icon: Icons.assignment_turned_in_rounded,
        onConfirm: () {
          AppFeedback.success(context, 'Pengajuan berhasil dikirim!');
          context.pop();
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgLight,
      appBar: AppBar(
        title: Text('Pengajuan Instalasi', style: GoogleFonts.sora(fontWeight: FontWeight.bold, fontSize: 18)),
        centerTitle: true,
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeaderInfo(),
              const SizedBox(height: 32),
              _buildFormSection(),
              const SizedBox(height: 32),
              _buildLocationPreview(),
              const SizedBox(height: 40),
              _buildSubmitButton(),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderInfo() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primary, AppColors.primaryLight],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.2),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.speed_rounded, color: Colors.white, size: 32),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Nikmati Internet Cepat',
                  style: GoogleFonts.sora(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                ),
                Text(
                  'Dapatkan promo gratis instalasi bulan ini!',
                  style: GoogleFonts.dmSans(color: Colors.white70, fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    ).animate().fadeIn().slideY(begin: 0.2);
  }

  Widget _buildFormSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Data Pelanggan'),
        const SizedBox(height: 16),
        _buildTextField(
          controller: _nameController,
          label: 'Nama Lengkap',
          hint: 'Masukkan nama sesuai KTP',
          icon: Icons.person_outline_rounded,
          validator: (val) => val == null || val.isEmpty ? 'Nama wajib diisi' : null,
        ),
        const SizedBox(height: 16),
        _buildTextField(
          controller: _phoneController,
          label: 'Nomor WhatsApp',
          hint: 'Contoh: 081234567890',
          icon: Icons.chat_outlined,
          keyboardType: TextInputType.phone,
          validator: (val) => val == null || val.isEmpty ? 'Nomor WA wajib diisi' : null,
        ),
        const SizedBox(height: 16),
        _buildDropdownField(),
        const SizedBox(height: 16),
        _buildTextField(
          controller: _addressController,
          label: 'Alamat Lengkap',
          hint: 'Jalan, Nomor Rumah, RT/RW, Kecamatan',
          icon: Icons.location_on_outlined,
          maxLines: 3,
          validator: (val) => val == null || val.isEmpty ? 'Alamat wajib diisi' : null,
        ),
      ],
    ).animate().fadeIn(delay: 200.ms);
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: GoogleFonts.sora(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    int maxLines = 1,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.dmSans(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textSecondary),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          keyboardType: keyboardType,
          style: GoogleFonts.dmSans(fontSize: 14),
          validator: validator,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(icon, size: 20, color: AppColors.primary),
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: Colors.red, width: 1),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdownField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Pilih Paket Internet',
          style: GoogleFonts.dmSans(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textSecondary),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          initialValue: _selectedPackage,
          style: GoogleFonts.dmSans(fontSize: 14, color: AppColors.textPrimary),
          validator: (val) => val == null ? 'Pilih paket terlebih dahulu' : null,
          decoration: InputDecoration(
            prefixIcon: const Icon(Icons.inventory_2_outlined, size: 20, color: AppColors.primary),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),
          ),
          hint: const Text('Pilih paket'),
          items: _packages.map((pkg) {
            return DropdownMenuItem(value: pkg, child: Text(pkg));
          }).toList(),
          onChanged: (val) => setState(() => _selectedPackage = val),
        ),
      ],
    );
  }

  Widget _buildLocationPreview() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Verifikasi Lokasi'),
        const SizedBox(height: 16),
        Container(
          height: 180,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.grey.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.grey.withValues(alpha: 0.2)),
            image: const DecorationImage(
              image: CachedNetworkImageProvider('https://images.unsplash.com/photo-1524661135-423995f22d0b?q=80&w=1000'),
              fit: BoxFit.cover,
              opacity: 0.4,
            ),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.map_rounded, color: AppColors.primary, size: 40),
                const SizedBox(height: 8),
                Text(
                  'Ketuk untuk milih lokasi di peta',
                  style: GoogleFonts.dmSans(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                ),
              ],
            ),
          ),
        ),
      ],
    ).animate().fadeIn(delay: 400.ms);
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: _submitForm,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 2,
          shadowColor: AppColors.primary.withValues(alpha: 0.3),
        ),
        child: Text(
          'Kirim Pengajuan',
          style: GoogleFonts.sora(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    ).animate(onPlay: (controller) => controller.repeat(reverse: true)).shimmer(duration: 2.seconds, color: Colors.white.withValues(alpha: 0.1));
  }
}
