import 'dart:ui';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jbr_mimpo/core/theme/app_colors.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _whatsappController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isPasswordVisible = false;

  @override
  void dispose() {
    _whatsappController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgLight,
      body: Stack(
        children: [
          // 1. Background Ethereal Blobs
          Positioned(
            top: -100,
            left: -100,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
            ).animate().fadeIn(duration: 2.seconds).scale(begin: const Offset(0.5, 0.5)),
          ),
          Positioned(
            bottom: -150,
            right: -150,
            child: Container(
              width: 400,
              height: 400,
              decoration: BoxDecoration(
                color: Colors.blue.withValues(alpha: 0.05),
                shape: BoxShape.circle,
              ),
            ),
          ),

          // 2. Main Content
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Header Section
                    _buildHeader(),
                    
                    const SizedBox(height: 40),

                    // Login Card
                    _buildLoginCard(),

                    const SizedBox(height: 40),

                    // Footer Section (Register Link)
                    _buildFooter(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.security, color: AppColors.primary, size: 32),
            const SizedBox(width: 12),
            Text(
              'JBR MINPO',
              style: GoogleFonts.sora(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
                letterSpacing: -0.5,
              ),
            ),
          ],
        ).animate().slideY(begin: -0.2, end: 0).fadeIn(),
        const SizedBox(height: 24),
        Text(
          'Selamat Datang Kembali',
          style: GoogleFonts.sora(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ).animate().fadeIn(delay: 200.ms),
        const SizedBox(height: 8),
        Text(
          'Lihat Informasi Realtime & Kumpulkan Reward',
          textAlign: TextAlign.center,
          style: GoogleFonts.dmSans(
            fontSize: 14,
            color: AppColors.textSecondary,
          ),
        ).animate().fadeIn(delay: 400.ms),
      ],
    );
  }

  Widget _buildLoginCard() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(30),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          padding: const EdgeInsets.all(32.0),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.8),
            borderRadius: BorderRadius.circular(30),
            border: Border.all(color: Colors.white.withValues(alpha: 0.4), width: 1.5),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.03),
                blurRadius: 40,
                offset: const Offset(0, 20),
              ),
            ],
          ),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // WhatsApp Input
                _buildLabel('Nomor WhatsApp Wajib Di Isi'),
                const SizedBox(height: 8),
                _buildTextField(
                  controller: _whatsappController,
                  hint: '812xxxx',
                  icon: Icons.chat_bubble_outline,
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'Nomor wajib diisi';
                    if (value.length < 8) return 'Nomor tidak valid';
                    return null;
                  },
                ),

                const SizedBox(height: 24),

                // Password Input
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildLabel('Kata Sandi'),
                    TextButton(
                      onPressed: () => context.push('/forgot-password'),
                      style: TextButton.styleFrom(padding: EdgeInsets.zero, minimumSize: Size.zero),
                      child: Text(
                        'Lupa Sandi?',
                        style: GoogleFonts.dmSans(
                          fontSize: 12,
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                _buildTextField(
                  controller: _passwordController,
                  hint: '••••••••',
                  icon: Icons.lock_outline,
                  obscureText: !_isPasswordVisible,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                      size: 20,
                      color: AppColors.textSecondary,
                    ),
                    onPressed: () => setState(() => _isPasswordVisible = !_isPasswordVisible),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'Sandi wajib diisi';
                    return null;
                  },
                ),

                const SizedBox(height: 32),

                // Login Button
                _buildLoginButton(),

                const SizedBox(height: 24),

                // Security Badges
                _buildSecurityRow(),
              ],
            ),
          ),
        ),
      ),
    ).animate().scale(delay: 600.ms, begin: const Offset(0.95, 0.95)).fadeIn();
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: GoogleFonts.dmSans(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: AppColors.textPrimary,
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool obscureText = false,
    Widget? suffixIcon,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      validator: validator,
      style: GoogleFonts.jetBrainsMono(fontSize: 14, color: AppColors.textPrimary),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: GoogleFonts.jetBrainsMono(color: AppColors.textSecondary.withValues(alpha: 0.5)),
        prefixIcon: Icon(icon, color: AppColors.textSecondary, size: 20),
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: Colors.grey.shade100.withValues(alpha: 0.5),
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
        contentPadding: const EdgeInsets.symmetric(vertical: 18),
      ),
    );
  }

  Widget _buildLoginButton() {
    return Container(
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: const LinearGradient(
          colors: [Color(0xFF10b981), AppColors.primary],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            // Proses Login → navigasi ke OTP
            context.go('/otp');
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
        child: Text(
          'Masuk',
          style: GoogleFonts.sora(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  Widget _buildSecurityRow() {
    return Column(
      children: [
        Row(
          children: [
             Expanded(child: Divider(color: AppColors.textSecondary.withValues(alpha: 0.1))),
             Padding(
               padding: const EdgeInsets.symmetric(horizontal: 16),
               child: Text(
                 'KEAMANAN TERJAMIN',
                 style: GoogleFonts.jetBrainsMono(
                   fontSize: 10,
                   color: AppColors.textSecondary,
                   letterSpacing: 1,
                 ),
               ),
             ),
             Expanded(child: Divider(color: AppColors.textSecondary.withValues(alpha: 0.1))),
          ],
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildBadge(Icons.verified_user, 'SSL Encrypted'),
            const SizedBox(width: 24),
            _buildBadge(Icons.support_agent, 'Bantuan 24/7'),
          ],
        ),
      ],
    );
  }

  Widget _buildBadge(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, color: AppColors.primary, size: 16),
        const SizedBox(width: 6),
        Text(
          text,
          style: GoogleFonts.jetBrainsMono(
            fontSize: 10,
            fontWeight: FontWeight.w500,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildFooter() {
    return RichText(
      text: TextSpan(
        style: GoogleFonts.dmSans(color: AppColors.textSecondary, fontSize: 14),
        children: [
          const TextSpan(text: 'Belum punya akun? '),
          TextSpan(
            text: 'Daftar',
            recognizer: TapGestureRecognizer()..onTap = () => context.go('/register'),
            style: const TextStyle(
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
              decoration: TextDecoration.underline,
            ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: 1.seconds);
  }
}
