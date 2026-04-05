import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jbr_mimpo/core/theme/app_colors.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AppSettingsScreen extends ConsumerStatefulWidget {
  const AppSettingsScreen({super.key});

  @override
  ConsumerState<AppSettingsScreen> createState() => _AppSettingsScreenState();
}

class _AppSettingsScreenState extends ConsumerState<AppSettingsScreen> {
  String _selectedLanguage = 'id';
  ConnectivityResult _connectionStatus = ConnectivityResult.none;
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;

  @override
  void initState() {
    super.initState();
    _initConnectivity();
    _connectivitySubscription = Connectivity().onConnectivityChanged.listen(_updateConnectionStatus);
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }

  Future<void> _initConnectivity() async {
    late List<ConnectivityResult> result;
    try {
      result = await Connectivity().checkConnectivity();
    } catch (e) {
      return;
    }
    if (!mounted) return;
    _updateConnectionStatus(result);
  }

  void _updateConnectionStatus(List<ConnectivityResult> result) {
    setState(() {
      _connectionStatus = result.isEmpty ? ConnectivityResult.none : result.first;
    });
  }

  String get _connectionLabel {
    switch (_connectionStatus) {
      case ConnectivityResult.wifi: return 'Terhubung (WiFi)';
      case ConnectivityResult.mobile: return 'Terhubung (Data Seluler)';
      case ConnectivityResult.none: return 'Offline';
      default: return 'Terhubung';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgLight,
      appBar: AppBar(
        title: const Text('Pengaturan'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Language Selection
            _buildLanguageHeader(),
            const SizedBox(height: 16),
            _buildLanguageCard(
              id: 'id',
              label: 'Indonesia',
              subtitle: 'Bahasa Default untuk wilayah Anda',
              flag: '🇮🇩',
            ),
            _buildLanguageCard(
              id: 'en',
              label: 'English',
              subtitle: 'United States / Global',
              flag: '🇺🇸',
            ),
            
            const SizedBox(height: 32),
            
            // 2. App Info Hub
            _buildAppInfoCard(),
            
            const SizedBox(height: 32),
            
            // 3. Information Section
            Text(
              'Informasi Tambahan',
              style: GoogleFonts.sora(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
            ),
            const SizedBox(height: 12),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.primary.withValues(alpha: 0.05)),
              ),
              child: Column(
                children: [
                  _buildSimpleMenuItem('Status Jaringan', Icons.wifi_protected_setup_rounded, trailing: _connectionLabel),
                  _buildSimpleMenuItem('Versi Database', Icons.storage_rounded, trailing: 'v1.0.4-dev'),
                  _buildSimpleMenuItem('Lisensi Open Source', Icons.library_books_rounded),
                ],
              ),
            ),
            
            const SizedBox(height: 120), // Bottom Navi padding
          ],
        ),
      ),
    );
  }

  Widget _buildLanguageHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Bahasa & Wilayah',
          style: GoogleFonts.sora(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
        ),
        const SizedBox(height: 4),
        Text(
          'Pilih bahasa yang ingin Anda gunakan dalam aplikasi.',
          style: GoogleFonts.dmSans(fontSize: 14, color: Colors.grey),
        ),
      ],
    ).animate().fadeIn().slideX(begin: -0.1);
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
            ],
          ),
          const SizedBox(height: 20),
          const Divider(height: 1, color: Colors.black12),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('© 2026 JBR Tech Digital', style: GoogleFonts.dmSans(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey)),
              Text('ENTERPRISE', style: GoogleFonts.jetBrainsMono(fontSize: 9, fontWeight: FontWeight.w900, color: AppColors.primary.withValues(alpha: 0.5), letterSpacing: 1)),
            ],
          ),
        ],
      ),
    ).animate().fadeIn(delay: 400.ms);
  }

  Widget _buildSimpleMenuItem(String label, IconData icon, {String? trailing}) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primary, size: 20),
      title: Text(label, style: GoogleFonts.dmSans(fontSize: 14, fontWeight: FontWeight.w500)),
      trailing: trailing != null 
        ? Text(trailing, style: GoogleFonts.dmSans(fontSize: 12, color: trailing == 'Offline' ? Colors.red : Colors.grey, fontWeight: FontWeight.bold))
        : const Icon(Icons.arrow_forward_ios_rounded, size: 12, color: Colors.grey),
    );
  }
}
