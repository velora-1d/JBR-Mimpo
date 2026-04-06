import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jbr_mimpo/core/theme/app_colors.dart';
import 'package:go_router/go_router.dart';

class TicketTrackingScreen extends StatefulWidget {
  const TicketTrackingScreen({super.key});

  @override
  State<TicketTrackingScreen> createState() => _TicketTrackingScreenState();
}

class _TicketTrackingScreenState extends State<TicketTrackingScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<Map<String, dynamic>> _tickets = [
    {
      'id': 'TKT-9921',
      'title': 'Internet Lambat di Area Grogol',
      'status': 'Open',
      'date': '05 Apr 2026',
      'category': 'Technical',
      'progress': 0.3,
    },
    {
      'id': 'TKT-8812',
      'title': 'Permintaan Upgrade Paket PRO',
      'status': 'In Progress',
      'date': '04 Apr 2026',
      'category': 'Billing',
      'progress': 0.7,
    },
    {
      'id': 'TKT-7701',
      'title': 'Wifi Tidak Terdeteksi',
      'status': 'Resolved',
      'date': '01 Apr 2026',
      'category': 'Technical',
      'progress': 1.0,
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
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
        title: const Text('Tracking Tiket'),
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColors.primary,
          unselectedLabelColor: Colors.grey,
          indicatorColor: AppColors.primary,
          indicatorWeight: 3,
          labelStyle: GoogleFonts.sora(fontWeight: FontWeight.bold, fontSize: 14),
          unselectedLabelStyle: GoogleFonts.sora(fontSize: 14),
          tabs: const [
            Tab(text: 'Aktif'),
            Tab(text: 'Riwayat'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildTicketList(isActive: true),
          _buildTicketList(isActive: false),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/support/report-issue'),
        backgroundColor: AppColors.primary,
        icon: const Icon(Icons.add_rounded, color: Colors.white),
        label: Text('Buat Tiket', style: GoogleFonts.sora(fontWeight: FontWeight.bold, color: Colors.white)),
      ).animate().scale(delay: 200.ms, duration: 400.ms, curve: Curves.easeOutBack),
    );
  }

  Widget _buildTicketList({required bool isActive}) {
    final filteredTickets = _tickets.where((t) {
      if (isActive) return t['status'] != 'Resolved';
      return t['status'] == 'Resolved';
    }).toList();

    return RefreshIndicator(
      onRefresh: () async => await Future.delayed(const Duration(seconds: 1)),
      color: AppColors.primary,
      child: filteredTickets.isEmpty
          ? SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.7,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.confirmation_num_outlined, size: 80, color: Colors.grey.withValues(alpha: 0.2)),
                      const SizedBox(height: 16),
                      Text('Tidak ada tiket ${isActive ? 'aktif' : 'riwayat'}', style: GoogleFonts.dmSans(color: Colors.grey)),
                    ],
                  ),
                ),
              ),
            )
          : ListView.separated(
              physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
              padding: const EdgeInsets.all(24),
              itemCount: filteredTickets.length,
              separatorBuilder: (context, index) => const SizedBox(height: 16),
              itemBuilder: (context, index) {
                final ticket = filteredTickets[index];
                return _buildTicketCard(ticket).animate().fadeIn(duration: 300.ms, delay: (index * 100).ms).slideY(begin: 0.05, curve: Curves.easeOutQuad);
              },
            ),
    );
  }

  Widget _buildTicketCard(Map<String, dynamic> ticket) {
    final statusColor = _getStatusColor(ticket['status']);

    return GestureDetector(
      onTap: () => context.push('/support/ticket-detail', extra: ticket),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 20, offset: const Offset(0, 5)),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    ticket['status'].toUpperCase(),
                    style: GoogleFonts.jetBrainsMono(fontSize: 10, fontWeight: FontWeight.bold, color: statusColor),
                  ),
                ),
                Text(
                  ticket['id'],
                  style: GoogleFonts.jetBrainsMono(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              ticket['title'],
              style: GoogleFonts.sora(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.category_outlined, size: 14, color: Colors.grey.shade400),
                const SizedBox(width: 4),
                Text(ticket['category'], style: GoogleFonts.dmSans(fontSize: 12, color: Colors.grey)),
                const SizedBox(width: 16),
                Icon(Icons.calendar_today_rounded, size: 14, color: Colors.grey.shade400),
                const SizedBox(width: 4),
                Text(ticket['date'], style: GoogleFonts.dmSans(fontSize: 12, color: Colors.grey)),
              ],
            ),
            const SizedBox(height: 20),
            if (ticket['status'] != 'Resolved') ...[
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: ticket['progress'],
                  backgroundColor: Colors.grey.shade100,
                  color: statusColor,
                  minHeight: 6,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Estimasi selesai: Hari ini',
                style: GoogleFonts.dmSans(fontSize: 11, fontWeight: FontWeight.bold, color: statusColor),
              ),
            ],
          ],
        ),
      ),
    ).animate().fadeIn(delay: 100.ms * _tickets.indexOf(ticket)).slideX(begin: 0.1);
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Open': return Colors.orange;
      case 'In Progress': return Colors.blue;
      case 'Resolved': return Colors.green;
      default: return Colors.grey;
    }
  }
}
