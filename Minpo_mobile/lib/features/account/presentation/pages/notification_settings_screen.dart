import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jbr_mimpo/core/theme/app_colors.dart';
import 'package:jbr_mimpo/core/utils/app_feedback.dart';

class NotificationSettingsScreen extends StatefulWidget {
  const NotificationSettingsScreen({super.key});

  @override
  State<NotificationSettingsScreen> createState() => _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState extends State<NotificationSettingsScreen> {
  bool _pushNotifications = true;
  bool _emailNotifications = false;
  bool _whatsappNotifications = true;
  bool _marketingNotifications = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgLight,
      appBar: AppBar(
        title: const Text('Pengaturan Notifikasi'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeader(
              'Saluran Notifikasi',
              'Pilih bagaimana kami menghubungi Anda untuk informasi penting.',
            ),
            const SizedBox(height: 16),
            _buildNotificationCard([
              _buildSwitchItem(
                'Notifikasi Push',
                'Terima update langsung di ponsel Anda',
                Icons.notifications_active_rounded,
                _pushNotifications,
                (v) => setState(() => _pushNotifications = v),
              ),
              _buildSwitchItem(
                'Notifikasi WhatsApp',
                'Informasi tagihan & gangguan via WA',
                Icons.message_rounded,
                _whatsappNotifications,
                (v) => setState(() => _whatsappNotifications = v),
              ),
              _buildSwitchItem(
                'Email',
                'Laporan bulanan & berita eksklusif',
                Icons.alternate_email_rounded,
                _emailNotifications,
                (v) => setState(() => _emailNotifications = v),
              ),
            ]),
            const SizedBox(height: 32),
            _buildSectionHeader(
              'Preferensi Konten',
              'Kelola notifikasi berdasarkan konten yang Anda minati.',
            ),
            const SizedBox(height: 16),
            _buildNotificationCard([
              _buildSwitchItem(
                'Promo & Penawaran',
                'Update produk baru & diskon spesial',
                Icons.star_rounded,
                _marketingNotifications,
                (v) => setState(() => _marketingNotifications = v),
              ),
            ]),
            const SizedBox(height: 40),
            _buildSaveButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, String subtitle) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.sora(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
        ),
        const SizedBox(height: 4),
        Text(
          subtitle,
          style: GoogleFonts.dmSans(fontSize: 14, color: Colors.grey),
        ),
      ],
    ).animate().fadeIn().slideX(begin: -0.1);
  }

  Widget _buildNotificationCard(List<Widget> items) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 20, offset: const Offset(0, 10))
        ],
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.05)),
      ),
      child: Column(
        children: items.asMap().entries.map((entry) {
          int idx = entry.key;
          Widget item = entry.value;
          return Column(
            children: [
              item,
              if (idx < items.length - 1)
                Divider(height: 1, color: Colors.grey.withValues(alpha: 0.1), indent: 40),
            ],
          );
        }).toList(),
      ),
    ).animate().fadeIn().slideY(begin: 0.1);
  }

  Widget _buildSwitchItem(String title, String subtitle, IconData icon, bool value, Function(bool) onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.bgLight,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: AppColors.primary, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: GoogleFonts.sora(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                Text(subtitle, style: GoogleFonts.dmSans(fontSize: 12, color: Colors.grey)),
              ],
            ),
          ),
          Switch.adaptive(
            value: value,
            onChanged: onChanged,
            activeTrackColor: AppColors.primary.withValues(alpha: 0.5),
            activeThumbColor: AppColors.primary,
          ),
        ],
      ),
    );
  }

  Widget _buildSaveButton() {
    return SizedBox(
      width: double.infinity,
      height: 60,
      child: ElevatedButton(
        onPressed: () {
          AppFeedback.success(context, 'Preferensi notifikasi berhasil disimpan!');
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          elevation: 8,
          shadowColor: AppColors.primary.withValues(alpha: 0.3),
        ),
        child: Text(
          'Simpan Pengaturan',
          style: GoogleFonts.sora(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    ).animate().fadeIn(delay: 500.ms);
  }
}
