import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jbr_mimpo/core/theme/app_colors.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jbr_mimpo/core/theme/theme_provider.dart';

class AppSettingsScreen extends ConsumerStatefulWidget {
  const AppSettingsScreen({super.key});

  @override
  ConsumerState<AppSettingsScreen> createState() => _AppSettingsScreenState();
}

class _AppSettingsScreenState extends ConsumerState<AppSettingsScreen> {
  String _selectedLanguage = 'id';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgLight,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              // 1. App Bar
              _buildAppBar(context),
              
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 2. Theme Selection
                    _buildThemeHeader(),
                    const SizedBox(height: 16),
                    _buildThemeSelection(context),
                    const SizedBox(height: 32),

                    // 3. Language Selection
                    _buildLanguageHeader(),
                    const SizedBox(height: 16),
                    _buildLanguageCard(
                      id: 'id',
                      label: 'Indonesia',
                      subtitle: 'Bahasa Default',
                      flag: '🇮🇩',
                    ),
                    _buildLanguageCard(
                      id: 'en',
                      label: 'English',
                      subtitle: 'United States',
                      flag: '🇺🇸',
                    ),
                    
                    const SizedBox(height: 32),
                    
                    // 3. App Info Hub
                    _buildAppInfoCard(),
                    
                    const SizedBox(height: 32),
                    
                    // 4. Logout Action
                    _buildLogoutSection(),
                    
                    const SizedBox(height: 120), // Bottom Navi padding
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const CircleAvatar(
                radius: 18,
                backgroundImage: NetworkImage('https://lh3.googleusercontent.com/aida-public/AB6AXuC7oy2583cHYIraanpR6r13YE_4XSzi8DPm-E7mLuRvnNnTu0omenETOX9Uq68EMVr6cpEVq5-OBptzOR_OGfJnAv2peorpL73iT3BeGDMLiQHr3Y27WlVjRXb42qd3tUnIztP9RhK91EfzyBloIpv1lyOnig0bRCx1vPwE-jaLeJJiO1glVPrg2dDGJZRZTzo87TmRfi-e4hNodXfiSqv3DTm4t1ejuswerLfum_JIdsjjlZtiGyyH4N5e2p6DgqDxQ2u4rVptk6j5'),
              ),
              const SizedBox(width: 12),
              Text(
                'JBR Minpo',
                style: GoogleFonts.sora(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.primary),
              ),
            ],
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.support_agent_rounded, color: AppColors.primary),
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Pilih Bahasa',
          style: GoogleFonts.sora(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
        ),
        const SizedBox(height: 4),
        Text(
          'Sesuaikan preferensi bahasa aplikasi Anda.',
          style: GoogleFonts.dmSans(fontSize: 14, color: Colors.grey),
        ),
      ],
    ).animate().fadeIn().slideX(begin: -0.1);
  }

  Widget _buildThemeHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Tema Tampilan',
          style: GoogleFonts.sora(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
        ),
        const SizedBox(height: 4),
        Text(
          'Pilih mode terang, gelap, atau ikuti sistem.',
          style: GoogleFonts.dmSans(fontSize: 14, color: Colors.grey),
        ),
      ],
    ).animate().fadeIn().slideX(begin: -0.1);
  }

  Widget _buildThemeSelection(BuildContext context) {
    final themeMode = ref.watch(themeModeProvider);

    Widget buildOption(String label, ThemeMode mode) {
      final isSelected = themeMode == mode;
      return ListTile(
        title: Text(label, style: GoogleFonts.sora(fontSize: 14, fontWeight: FontWeight.bold)),
        trailing: Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: isSelected ? AppColors.primary : Colors.grey.shade300, width: 2),
          ),
          child: isSelected
              ? Center(child: Container(width: 12, height: 12, decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle)))
              : null,
        ),
        onTap: () => ref.read(themeModeProvider.notifier).setThemeMode(mode),
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.05)),
      ),
      child: Column(
        children: [
          buildOption('Ikuti Sistem', ThemeMode.system),
          Divider(height: 1, color: Colors.grey.withValues(alpha: 0.1)),
          buildOption('Mode Terang', ThemeMode.light),
          Divider(height: 1, color: Colors.grey.withValues(alpha: 0.1)),
          buildOption('Mode Gelap', ThemeMode.dark),
        ],
      ),
    ).animate().fadeIn().slideY(begin: 0.1);
  }

  Widget _buildLanguageCard({
    required String id,
    required String label,
    required String subtitle,
    required String flag,
  }) {
    final isSelected = _selectedLanguage == id;
    
    return GestureDetector(
      onTap: () => setState(() => _selectedLanguage = id),
      child: AnimatedContainer(
        duration: 300.ms,
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF82f5c1).withValues(alpha: 0.1) : Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.primary.withValues(alpha: 0.05),
            width: isSelected ? 2 : 1,
          ),
          boxShadow: [
            if (isSelected) BoxShadow(color: AppColors.primary.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, 4)),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10)],
              ),
              alignment: Alignment.center,
              child: Text(flag, style: const TextStyle(fontSize: 24)),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: GoogleFonts.sora(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                  Text(subtitle, style: GoogleFonts.dmSans(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey)),
                ],
              ),
            ),
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: isSelected ? AppColors.primary : Colors.grey.shade300, width: 2),
              ),
              child: isSelected 
                ? Center(child: Container(width: 12, height: 12, decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle)))
                : null,
            ),
          ],
        ),
      ).animate().fadeIn(delay: isSelected ? 0.ms : 200.ms).scale(begin: const Offset(0.95, 0.95)),
    );
  }

  Widget _buildAppInfoCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFFf2f3ff),
        borderRadius: BorderRadius.circular(32),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [BoxShadow(color: AppColors.primary.withValues(alpha: 0.05), blurRadius: 20)],
                ),
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(colors: [AppColors.primary, Colors.blue]),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.router_rounded, color: Colors.white, size: 24),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('JBR Minpo', style: GoogleFonts.sora(fontSize: 18, fontWeight: FontWeight.bold)),
                    Text('v2.5.1 Stable', style: GoogleFonts.jetBrainsMono(fontSize: 12, color: Colors.grey)),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(80, 40),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 4,
                  shadowColor: AppColors.primary.withValues(alpha: 0.3),
                ),
                child: Text('Cek Update', style: GoogleFonts.sora(fontSize: 10, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          const SizedBox(height: 24),
          const Divider(height: 1, color: Colors.black12),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Dikelola oleh JBR Tech Digital', style: GoogleFonts.dmSans(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey)),
              Text('ENTERPRISE EDITION', style: GoogleFonts.jetBrainsMono(fontSize: 9, fontWeight: FontWeight.w900, color: AppColors.primary.withValues(alpha: 0.5), letterSpacing: 1)),
            ],
          ),
        ],
      ),
    ).animate().fadeIn(delay: 400.ms);
  }

  Widget _buildLogoutSection() {
    return Column(
      children: [
        OutlinedButton(
          onPressed: () {},
          style: OutlinedButton.styleFrom(
            foregroundColor: Colors.red,
            side: const BorderSide(color: Colors.red, width: 2),
            minimumSize: const Size(double.infinity, 60),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.logout_rounded),
              const SizedBox(width: 12),
              Text(
                'Keluar dari Akun',
                style: GoogleFonts.sora(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        Text(
          '© 2024 JBR DIGITAL INFRASTRUCTURE',
          style: GoogleFonts.jetBrainsMono(fontSize: 9, color: Colors.grey, letterSpacing: 2),
        ),
      ],
    ).animate().fadeIn(delay: 600.ms);
  }
}
