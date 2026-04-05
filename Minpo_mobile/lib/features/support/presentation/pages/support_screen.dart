import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jbr_mimpo/core/theme/app_colors.dart';
import 'package:go_router/go_router.dart';

class SupportScreen extends StatefulWidget {
  const SupportScreen({super.key});

  @override
  State<SupportScreen> createState() => _SupportScreenState();
}

class _SupportScreenState extends State<SupportScreen> {
  final List<Map<String, dynamic>> _faqs = [
    {'q': 'Bagaimana cara bayar tagihan?', 'a': 'Anda dapat membayar tagihan melalui Menu Pembayaran di App, transfer bank, atau gerai retail terdekat.', 'isOpen': false},
    {'q': 'Koneksi internet lambat tiba-tiba?', 'a': 'Coba restart router Anda selama 30 detik. Jika masih kendala, gunakan menu Lapor Gangguan.', 'isOpen': false},
    {'q': 'Cara ganti password WiFi?', 'a': 'Buka menu Pengaturan Router di Aplikasi JBR Minpo, pilih WiFi Settings.', 'isOpen': false},
    {'q': 'Biaya upgrade paket internet?', 'a': 'Biaya bervariasi tergantung kecepatan yang pilih. Cek menu Paket Saya.', 'isOpen': false},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgLight,
      body: RefreshIndicator(
        onRefresh: () async => await Future.delayed(const Duration(seconds: 1)),
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
          slivers: [
            _buildSliverHeader(),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildActiveTicketCard(),
                    const SizedBox(height: 32),
                    _buildBentoGrid(),
                    const SizedBox(height: 32),
                    _buildQuickContact(),
                    const SizedBox(height: 32),
                    _buildFaqSection(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSliverHeader() {
    return SliverAppBar(
      expandedHeight: 200,
      pinned: true,
      backgroundColor: AppColors.primary,
      elevation: 0,
      stretch: true,
      flexibleSpace: FlexibleSpaceBar(
        stretchModes: const [StretchMode.zoomBackground, StretchMode.blurBackground],
        title: Text('Pusat Bantuan', style: GoogleFonts.sora(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
        centerTitle: true,
        background: Stack(
          fit: StackFit.expand,
          children: [
             Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(colors: [AppColors.primary, Color(0xFF064e3b)], begin: Alignment.topLeft, end: Alignment.bottomRight),
              ),
            ),
            Positioned(
              right: -50,
              top: -20,
              child: Icon(Icons.support_agent_rounded, size: 250, color: Colors.white.withValues(alpha: 0.05)),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 80, 24, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Ada Kendala, Ahmad?', style: GoogleFonts.sora(fontSize: 24, fontWeight: FontWeight.w900, color: Colors.white)),
                  const SizedBox(height: 8),
                  Text('Kami siap membantu 24/7.', style: GoogleFonts.dmSans(fontSize: 14, color: Colors.white70)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActiveTicketCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.orange.withValues(alpha: 0.3)),
        boxShadow: [BoxShadow(color: Colors.orange.withValues(alpha: 0.05), blurRadius: 20, offset: const Offset(0, 5))],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: Colors.orange.withValues(alpha: 0.1), shape: BoxShape.circle), child: const Icon(Icons.bolt_rounded, color: Colors.orange, size: 20)),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Tiket Gangguan Aktif', style: GoogleFonts.sora(fontSize: 14, fontWeight: FontWeight.bold)),
                    Text('ID #89123 • Sedang ditangani teknisi', style: GoogleFonts.dmSans(fontSize: 11, color: Colors.grey)),
                  ],
                ),
              ),
              Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4), decoration: BoxDecoration(color: Colors.orange, borderRadius: BorderRadius.circular(8)), child: Text('Track', style: GoogleFonts.dmSans(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.white))),
            ],
          ),
          const SizedBox(height: 16),
           LinearProgressIndicator(value: 0.6, backgroundColor: Colors.orange.withValues(alpha: 0.1), color: Colors.orange, minHeight: 6, borderRadius: BorderRadius.circular(3)),
        ],
      ),
    ).animate().fadeIn().slideY(begin: 0.2);
  }

  Widget _buildBentoGrid() {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      childAspectRatio: 1.1,
      children: [
        _buildActionCard('Lapor Gangguan', 'Respon cepat', Icons.feedback_rounded, AppColors.primary, '/support/report-issue'),
        _buildActionCard('Cek Jaringan', 'Status koneksi', Icons.sensors_rounded, Colors.blue, '/support/check-connection'),
        _buildActionCard('Live Chat', 'Bicara dengan CS', Icons.chat_bubble_rounded, Colors.green, '/support/chat-cs'),
        _buildActionCard('Instalasi Baru', 'Tambah titik baru', Icons.add_business_rounded, Colors.purple, '/support/installation'),
      ],
    );
  }

  Widget _buildActionCard(String title, String sub, IconData icon, Color color, String route) {
    return GestureDetector(
      onTap: () => context.push(route),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24), boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 10)]),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 12),
            Text(title, style: GoogleFonts.sora(fontSize: 13, fontWeight: FontWeight.bold)),
            Text(sub, style: GoogleFonts.dmSans(fontSize: 10, color: Colors.grey)),
          ],
        ),
      ),
    ).animate().scale(delay: 50.ms);
  }

  Widget _buildQuickContact() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(32),
        image: const DecorationImage(image: NetworkImage('https://www.transparenttextures.com/patterns/carbon-fibre.png'), opacity: 0.05),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Butuh Bantuan Langsung?', style: GoogleFonts.sora(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                    const SizedBox(height: 4),
                    Text('Hubungi Call Center kami di 1500-123 atau melalui WhatsApp.', style: GoogleFonts.dmSans(fontSize: 12, color: Colors.white.withValues(alpha: 0.7))),
                  ],
                ),
              ),
              const Icon(Icons.headset_mic_rounded, color: Colors.white24, size: 60),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(child: _buildContactButton('Telepon CS', Icons.phone_rounded, Colors.white, AppColors.primary)),
              const SizedBox(width: 12),
              Expanded(child: _buildContactButton('WhatsApp', Icons.chat_rounded, Colors.green, Colors.white)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildContactButton(String label, IconData icon, Color bg, Color text) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(16)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: text, size: 18),
          const SizedBox(width: 8),
          Text(label, style: GoogleFonts.sora(fontSize: 12, fontWeight: FontWeight.bold, color: text)),
        ],
      ),
    );
  }

  Widget _buildFaqSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Pertanyaan Sering Diajukan', style: GoogleFonts.sora(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        ...List.generate(_faqs.length, (idx) => _buildFaqItem(idx)),
      ],
    );
  }

  Widget _buildFaqItem(int index) {
    final faq = _faqs[index];
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          key: PageStorageKey(index),
          title: Text(faq['q'], style: GoogleFonts.dmSans(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
          trailing: Icon(faq['isOpen'] ? Icons.remove_circle_outline_rounded : Icons.add_circle_outline_rounded, color: AppColors.primary),
          onExpansionChanged: (val) => setState(() => _faqs[index]['isOpen'] = val),
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
              child: Text(faq['a'], style: GoogleFonts.dmSans(fontSize: 13, height: 1.5, color: AppColors.textSecondary)),
            ),
          ],
        ),
      ),
    );
  }
}
