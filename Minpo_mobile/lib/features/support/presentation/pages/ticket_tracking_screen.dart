import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jbr_mimpo/core/theme/app_colors.dart';
import 'package:jbr_mimpo/core/widgets/shimmer_loader.dart';
import 'package:jbr_mimpo/features/support/presentation/widgets/horizontal_stepper.dart';
import 'package:go_router/go_router.dart';

class TicketTrackingScreen extends StatefulWidget {
  const TicketTrackingScreen({super.key});

  @override
  State<TicketTrackingScreen> createState() => _TicketTrackingScreenState();
}

class _TicketTrackingScreenState extends State<TicketTrackingScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadData();
  }

  Future<void> _loadData() async {
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) setState(() => _isLoading = false);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

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
          IconButton(onPressed: () {}, icon: const Icon(Icons.history_rounded, color: AppColors.primary)),
        ],
      ),
      body: Column(
        children: [
          // 1. Hero Section
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Status Tiket',
                      style: GoogleFonts.sora(fontSize: 24, fontWeight: FontWeight.w800, color: AppColors.textPrimary),
                    ),
                    const Icon(Icons.history_edu_rounded, color: AppColors.primary),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'Kelola dan pantau setiap laporan teknis serta permintaan layanan Anda.',
                  style: GoogleFonts.dmSans(fontSize: 14, color: AppColors.textSecondary),
                ),
              ],
            ),
          ),

          // 2. Tab Bar
          TabBar(
            controller: _tabController,
            indicatorColor: AppColors.primary,
            indicatorWeight: 3,
            labelColor: AppColors.primary,
            unselectedLabelColor: Colors.grey,
            labelStyle: GoogleFonts.sora(fontSize: 14, fontWeight: FontWeight.bold),
            tabs: const [
              Tab(text: 'Aktif'),
              Tab(text: 'Selesai'),
            ],
          ),

          // 3. Tab View (Active Only for now)
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildActiveTickets(),
                const Center(child: Text('Belum ada tiket yang selesai')),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActiveTickets() {
    if (_isLoading) {
      return ListView.separated(
        padding: const EdgeInsets.all(20),
        itemCount: 3,
        separatorBuilder: (_, _) => const SizedBox(height: 16),
        itemBuilder: (context, index) => ShimmerLoader(width: double.infinity, height: 160, borderRadius: 32),
      );
    }

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        _buildTicketCard(
          id: 'TKT-2024-0892',
          title: 'Koneksi Lambat di Kamar Tidur',
          icon: Icons.wifi_off_rounded,
          techName: 'Andra Wijaya',
          techAvatar: 'https://lh3.googleusercontent.com/aida-public/AB6AXuDPcOtXl-ZriXCF-d4G_KR8xFqCjRPTQVykgOsoc5iMMo-n6L7xvAxRTSCKOyeFYpV_XMxwcR-lBfv6G9iQFQeD2LrST8TTUmTPzppjslwGYjNDoLfC3c0XLX7bd45AdGA5RFH3PNVJcmM6PNTTN0jWr3i3U4nIUKQa8rjskwE0FbJ7tTOFnd6loyaJuMqanogRUl0InGDqKj6VCZrBZMLIN2GK0cGisPtxgnNw8dBp7oEdki9GypImtszRLZwAZj48xcHjQoCuT0CB',
          date: '12 Mei 2024, 09:45',
          status: 'DIPROSES',
          statusColor: Colors.blue,
        ),
        const SizedBox(height: 16),
        _buildTicketCard(
          id: 'TKT-2024-1104',
          title: 'Upgrade Paket Ultra-Fast 1Gbps',
          icon: Icons.rocket_launch_rounded,
          requestType: 'Billing & Upgrade',
          eta: '~ 2 Jam',
          date: 'Hari ini, 14:15',
          status: 'MENUNGGU',
          statusColor: Colors.grey,
        ),
        const SizedBox(height: 24),
        _buildNewTicketCTA(),
      ],
    );
  }

  Widget _buildTicketCard({
    required String id,
    required String title,
    required IconData icon,
    String? techName,
    String? techAvatar,
    String? requestType,
    String? eta,
    required String date,
    required String status,
    required Color statusColor,
  }) {
    return GestureDetector(
      onTap: () {
        context.push('/ticket-detail', extra: {
          'id': id,
          'title': title,
          'status': status,
        });
      },
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(32),
          boxShadow: [
            BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 20, offset: const Offset(0, 8)),
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
                  decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(20)),
                  child: Text(id, style: GoogleFonts.jetBrainsMono(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.primary)),
                ),
                Icon(icon, color: statusColor, size: 20),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: GoogleFonts.sora(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
            ),
            const SizedBox(height: 16),
            
            if (techName != null) ...[
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(color: AppColors.bgLight, borderRadius: BorderRadius.circular(16)),
                child: Row(
                  children: [
                    CircleAvatar(radius: 18, backgroundImage: NetworkImage(techAvatar!)),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Teknisi Bertugas', style: GoogleFonts.dmSans(fontSize: 10, color: Colors.grey)),
                        Text(techName, style: GoogleFonts.sora(fontSize: 13, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ],
                ),
              ),
            ] else if (requestType != null) ...[
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(color: AppColors.bgLight, borderRadius: BorderRadius.circular(16)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Tipe Permintaan', style: GoogleFonts.dmSans(fontSize: 10, color: Colors.grey)),
                        Text(requestType, style: GoogleFonts.sora(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.primary)),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text('Estimasi Respon', style: GoogleFonts.dmSans(fontSize: 10, color: Colors.grey)),
                        Text(eta!, style: GoogleFonts.jetBrainsMono(fontSize: 12, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ],
                ),
              ),
            ],
            
            const SizedBox(height: 16),
            HorizontalStepper(currentStatus: status),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.calendar_today_rounded, size: 14, color: Colors.grey),
                    const SizedBox(width: 6),
                    Text(date, style: GoogleFonts.dmSans(fontSize: 11, color: Colors.grey)),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      if (status == 'DIPROSES')
                        Container(
                          width: 6,
                          height: 6,
                          margin: const EdgeInsets.only(right: 6),
                          decoration: BoxDecoration(color: statusColor, shape: BoxShape.circle),
                        ).animate(onPlay: (c) => c.repeat()).scale(begin: const Offset(1,1), end: const Offset(1.5, 1.5), duration: 1.seconds).fadeOut(),
                      Text(status, style: GoogleFonts.sora(fontSize: 10, fontWeight: FontWeight.bold, color: statusColor)),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.1);
  }

  Widget _buildNewTicketCTA() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.2), style: BorderStyle.solid),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.1), shape: BoxShape.circle),
            child: const Icon(Icons.add_rounded, color: AppColors.primary, size: 28),
          ),
          const SizedBox(height: 16),
          Text('Butuh bantuan lain?', style: GoogleFonts.sora(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(
            'Buat tiket baru untuk masalah teknis',
            style: GoogleFonts.dmSans(fontSize: 13, color: AppColors.textSecondary),
          ),
        ],
      ),
    ).animate().fadeIn(delay: 400.ms);
  }
}
