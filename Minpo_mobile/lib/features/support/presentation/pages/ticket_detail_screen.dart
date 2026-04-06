import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:jbr_mimpo/core/theme/app_colors.dart';
import 'package:jbr_mimpo/features/support/presentation/widgets/horizontal_stepper.dart';
import 'package:go_router/go_router.dart';

class TicketDetailScreen extends StatefulWidget {
  final Map<String, dynamic> ticket;
  const TicketDetailScreen({super.key, required this.ticket});

  @override
  State<TicketDetailScreen> createState() => _TicketDetailScreenState();
}

class _TicketDetailScreenState extends State<TicketDetailScreen> {
  int _rating = 0;
  late String _currentStatus;

  @override
  void initState() {
    super.initState();
    _currentStatus = widget.ticket['status'] ?? 'DIPROSES';
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
          IconButton(onPressed: () {}, icon: const Icon(Icons.contact_support_rounded, color: AppColors.primary)),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // 1. Live Status Header
            _buildLiveStatusHeader(),
            const SizedBox(height: 32),

            // 2. Horizontal Stepper
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 20, offset: const Offset(0, 8)),
                ],
              ),
              child: HorizontalStepper(currentStatus: _currentStatus),
            ).animate().fadeIn().slideY(begin: 0.1),
            const SizedBox(height: 32),

            // 3. Timeline Section
            _buildTimelineSection(),
            const SizedBox(height: 32),

            // 3. Rating Section
            if (_currentStatus == 'SELESAI') _buildRatingSection(),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildLiveStatusHeader() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
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
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'LIVE TRACKING',
                    style: GoogleFonts.jetBrainsMono(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.primary, letterSpacing: 1),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Teknisi Budi sedang\nmenuju lokasi',
                    style: GoogleFonts.sora(fontSize: 20, fontWeight: FontWeight.bold, height: 1.2),
                  ),
                ],
              ),
              const Icon(Icons.speed_rounded, size: 40, color: AppColors.primary).animate(onPlay: (c) => c.repeat()).shimmer(duration: 2.seconds),
            ],
          ),
          const SizedBox(height: 12),
          RichText(
            text: TextSpan(
              style: GoogleFonts.dmSans(fontSize: 14, color: AppColors.textSecondary),
              children: [
                const TextSpan(text: 'Estimasi tiba dalam '),
                TextSpan(
                  text: '12 Menit',
                  style: GoogleFonts.jetBrainsMono(fontWeight: FontWeight.bold, color: Colors.blue),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: AppColors.bgLight, borderRadius: BorderRadius.circular(16)),
            child: Row(
              children: [
                const CircleAvatar(
                  radius: 24,
                  backgroundImage: CachedNetworkImageProvider('https://lh3.googleusercontent.com/aida-public/AB6AXuDJwyeH3EZSv12EUu9a40D-l1sSkmfjlv571NuARf8rrgkaeTdpLRQWiW0v6vy46TojEBBKSRXxAcwNJg-_WGHzA8x8BIiRMBOcjVvWpSj5bxxavaz05XWHdguQX_E4rcrWZmjE5-bxTi2X7OcZepXcwJ4nn1H8uEWvc0-5sYDut33WXvkz3khDMNqkhDRkEigFmV_UoAFlY5NhpHCUJjFRnknvyN92VhNV7ba6LlD7wuAz1C5uWItzpzoEZPX_kMoIGA86n5_Si5QG'),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Budi Santoso', style: GoogleFonts.sora(fontSize: 14, fontWeight: FontWeight.bold)),
                      Text('Senior Field Engineer', style: GoogleFonts.dmSans(fontSize: 11, color: Colors.grey)),
                    ],
                  ),
                ),
                Row(
                  children: [
                    _buildQuickAction(Icons.call_rounded, AppColors.primary),
                    const SizedBox(width: 8),
                    _buildQuickAction(Icons.chat_rounded, Colors.blue),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    ).animate().fadeIn().slideY(begin: 0.1);
  }

  Widget _buildQuickAction(IconData icon, Color color) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(color: color.withValues(alpha: 0.1), shape: BoxShape.circle),
      child: Center(child: Icon(icon, color: color, size: 20)),
    );
  }

  Widget _buildTimelineSection() {
    return Column(
      children: [
        _buildTimelineStep(
          icon: Icons.check_rounded,
          title: 'Tiket Diterima',
          desc: 'Laporan Anda #TKT-8829 telah diverifikasi oleh sistem.',
          time: '10:00 AM',
          isCompleted: true,
        ),
        _buildTimelineStep(
          icon: Icons.check_rounded,
          title: 'Alokasi Teknisi',
          desc: 'Teknisi ahli telah ditugaskan untuk menangani kendala Anda.',
          time: '10:15 AM',
          isCompleted: true,
        ),
        _buildTimelineStep(
          icon: Icons.directions_car_rounded,
          title: 'Sedang Menuju Lokasi',
          desc: 'Budi sedang dalam perjalanan melalui Jl. Sudirman.',
          time: 'LIVE UPDATING',
          isActive: true,
        ),
        _buildTimelineStep(
          icon: Icons.build_rounded,
          title: 'Proses Perbaikan',
          desc: 'Estimasi pengerjaan memakan waktu sekitar 30-45 menit.',
          isPending: true,
        ),
        _buildTimelineStep(
          icon: Icons.verified_rounded,
          title: 'Selesai & Konfirmasi',
          desc: 'Verifikasi koneksi setelah perbaikan selesai dilakukan.',
          isPending: true,
          isLast: true,
        ),
      ],
    );
  }

  Widget _buildTimelineStep({
    required IconData icon,
    required String title,
    required String desc,
    String? time,
    bool isCompleted = false,
    bool isActive = false,
    bool isPending = false,
    bool isLast = false,
  }) {
    Color color = isCompleted ? AppColors.primary : (isActive ? Colors.blue : Colors.grey.shade300);
    
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
                border: isActive ? Border.all(color: color.withValues(alpha: 0.3), width: 4) : null,
              ),
              child: Icon(icon, size: 16, color: isPending ? Colors.grey : Colors.white),
            ).animate(onPlay: (c) => isActive ? c.repeat() : null).scale(begin: const Offset(1,1), end: const Offset(1.1, 1.1), duration: 1.seconds).then().scale(begin: const Offset(1.1, 1.1), end: const Offset(1, 1)),
            if (!isLast)
              Container(
                width: 2,
                height: 50,
                color: isCompleted ? AppColors.primary : Colors.grey.shade200,
              ),
          ],
        ),
        const SizedBox(width: 20),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.sora(fontSize: 14, fontWeight: FontWeight.bold, color: isActive ? Colors.blue : AppColors.textPrimary.withValues(alpha: isPending ? 0.4 : 1)),
              ),
              const SizedBox(height: 4),
              Text(
                desc,
                style: GoogleFonts.dmSans(fontSize: 12, color: AppColors.textSecondary.withValues(alpha: isPending ? 0.4 : 1), height: 1.5),
              ),
              if (time != null) ...[
                const SizedBox(height: 6),
                Text(
                  time,
                  style: GoogleFonts.jetBrainsMono(fontSize: 9, fontWeight: FontWeight.bold, color: isActive ? Colors.blue : Colors.grey),
                ),
              ],
              const SizedBox(height: 24),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRatingSection() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.1)),
      ),
      child: Column(
        children: [
          Text('Bantu kami berkembang', style: GoogleFonts.sora(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text('Berikan rating untuk layanan perbaikan hari ini.', style: GoogleFonts.dmSans(fontSize: 12, color: AppColors.textSecondary)),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(5, (index) {
              return GestureDetector(
                onTap: () => setState(() => _rating = index + 1),
                child: Icon(
                  index < _rating ? Icons.star_rounded : Icons.star_outline_rounded,
                  size: 40,
                  color: index < _rating ? Colors.amber : Colors.grey.shade300,
                ),
              );
            }),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: _rating > 0 ? () {
              // Show Modal and Update Status
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return Dialog(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.check_circle_rounded, color: Colors.green, size: 60),
                          const SizedBox(height: 16),
                          Text('Terima Kasih!', style: GoogleFonts.sora(fontSize: 20, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 8),
                          Text(
                            'Penilaian Anda sangat berharga bagi peningkatan layanan kami.',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.dmSans(color: AppColors.textSecondary),
                          ),
                          const SizedBox(height: 24),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context); // Close dialog
                              setState(() {
                                _currentStatus = 'DITUTUP';
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              foregroundColor: Colors.white,
                              minimumSize: const Size(double.infinity, 50),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                            child: Text('Tutup', style: GoogleFonts.sora(fontWeight: FontWeight.bold)),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            } : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              minimumSize: const Size(double.infinity, 50),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              disabledBackgroundColor: Colors.grey.shade300,
            ),
            child: Text('Kirim Feedback', style: GoogleFonts.sora(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    ).animate().fadeIn(delay: 500.ms);
  }
}
