import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jbr_mimpo/core/theme/app_colors.dart';

class OtpScreen extends StatefulWidget {
  const OtpScreen({super.key});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final List<TextEditingController> _controllers = List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());

  int _secondsRemaining = 59;
  Timer? _timer;
  bool _canResend = false;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    setState(() {
      _secondsRemaining = 59;
      _canResend = false;
    });
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining > 0) {
        setState(() => _secondsRemaining--);
      } else {
        setState(() => _canResend = true);
        _timer?.cancel();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  void _onOtpChanged(int index, String value) {
    if (value.isNotEmpty && index < 5) {
      _focusNodes[index + 1].requestFocus();
    }
    if (value.isEmpty && index > 0) {
      _focusNodes[index - 1].requestFocus();
    }
  }

  String get _timerText {
    final minutes = (_secondsRemaining / 60).floor().toString().padLeft(2, '0');
    final seconds = (_secondsRemaining % 60).floor().toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgLight,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // 1. Custom App Bar
              _buildAppBar(context),

              const SizedBox(height: 10),

              // 2. Illustration Section
              _buildIllustration(),

              const SizedBox(height: 24),

              // 3. Title & Info
              _buildTitleInfo(),

              const SizedBox(height: 48),

              // 4. OTP Input Row
              _buildOtpInput(),

              const SizedBox(height: 48),

              // 5. Timer & Resend
              _buildTimerSection(),

              const SizedBox(height: 32),

              // 6. Action Button
              _buildVerifyButton(context),

              const SizedBox(height: 24),

              // 7. Small Footer
              _buildTermsText(),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Container(
      height: 64,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: AppColors.primary),
            onPressed: () => context.pop(),
          ),
          const SizedBox(width: 8),
          Text(
            'Verifikasi',
            style: GoogleFonts.sora(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIllustration() {
    return Container(
      width: 240,
      height: 240,
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.05),
        shape: BoxShape.circle,
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Glassy circles behind
          Positioned(
            right: 20,
            top: 20,
            child: Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: Colors.blue.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
            ),
          ).animate(onPlay: (c) => c.repeat(reverse: true)).scale(
                duration: 2.seconds,
                begin: const Offset(1, 1),
                end: const Offset(1.2, 1.2),
              ),
          
          // The Phone Illustration
          Image.asset(
            'assets/images/otp_illustration_3d.png',
            width: 200,
            height: 200,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) => Icon(
              Icons.phonelink_lock,
              size: 100,
              color: AppColors.primary.withValues(alpha: 0.5),
            ),
          ).animate().slideY(begin: 0.1, duration: 1.seconds, curve: Curves.easeOutBack),
        ],
      ),
    );
  }

  Widget _buildTitleInfo() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Column(
        children: [
          Text(
            'Verifikasi Nomor Kamu',
            style: GoogleFonts.sora(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
              letterSpacing: -0.5,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Text.rich(
            TextSpan(
              style: GoogleFonts.dmSans(fontSize: 14, color: AppColors.textSecondary, height: 1.5),
              children: [
                const TextSpan(text: 'Kode OTP dikirim via WhatsApp ke \n'),
                TextSpan(
                  text: '0812****',
                  style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                ),
              ],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    ).animate().fadeIn(delay: 300.ms);
  }

  Widget _buildOtpInput() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(6, (index) {
          return SizedBox(
            width: 50,
            height: 60,
            child: TextFormField(
              controller: _controllers[index],
              focusNode: _focusNodes[index],
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              style: GoogleFonts.jetBrainsMono(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(1),
              ],
              onChanged: (value) => _onOtpChanged(index, value),
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey.shade100,
                contentPadding: EdgeInsets.zero,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppColors.primary, width: 2),
                ),
              ),
            ),
          );
        }),
      ),
    ).animate().fadeIn(delay: 500.ms).slideY(begin: 0.1);
  }

  Widget _buildTimerSection() {
    return Column(
      children: [
        Text(
          _timerText,
          style: GoogleFonts.jetBrainsMono(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
            letterSpacing: 2,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Mohon tunggu sebelum mengirim ulang',
          style: GoogleFonts.dmSans(fontSize: 12, color: AppColors.textSecondary),
        ),
        const SizedBox(height: 16),
        TextButton(
          onPressed: _canResend ? _startTimer : null,
          child: Text(
            'Kirim Ulang Kode',
            style: GoogleFonts.dmSans(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: _canResend ? Colors.blue : Colors.grey,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildVerifyButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: SizedBox(
        width: double.infinity,
        height: 56,
        child: ElevatedButton(
          onPressed: () {
            // Berhasil verifikasi, masuk ke Dashboard
            context.go('/home');
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            elevation: 8,
            shadowColor: AppColors.primary.withValues(alpha: 0.4),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          child: Text(
            'Verifikasi',
            style: GoogleFonts.sora(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
      ),
    );
  }

  Widget _buildTermsText() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 48),
      child: Text.rich(
        TextSpan(
          style: GoogleFonts.dmSans(fontSize: 10, color: AppColors.textSecondary, height: 1.5),
          children: [
            const TextSpan(text: 'Dengan melanjutkan, kamu menyetujui '),
            TextSpan(
              text: 'Syarat & Ketentuan',
              style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold),
            ),
            const TextSpan(text: ' serta '),
            TextSpan(
              text: 'Kebijakan Privasi',
              style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold),
            ),
            const TextSpan(text: ' JBR Minpo.'),
          ],
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
