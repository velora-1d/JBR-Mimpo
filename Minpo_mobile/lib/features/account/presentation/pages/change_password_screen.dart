import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jbr_mimpo/core/utils/app_feedback.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  
  bool _obscureOld = true;
  bool _obscureNew = true;
  bool _obscureConfirm = true;

  final _oldController = TextEditingController();
  final _newController = TextEditingController();
  final _confirmController = TextEditingController();

  double _passwordStrength = 0.0;
  Color _strengthColor = Colors.grey;
  String _strengthLabel = 'Sangat Lemah';

  @override
  void initState() {
    super.initState();
    _newController.addListener(_checkPasswordStrength);
  }

  @override
  void dispose() {
    _oldController.dispose();
    _newController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  void _checkPasswordStrength() {
    final password = _newController.text;
    double strength = 0;
    
    if (password.length >= 8) strength += 0.25;
    if (password.contains(RegExp(r'[A-Z]'))) strength += 0.25;
    if (password.contains(RegExp(r'[0-9]'))) strength += 0.25;
    if (password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) strength += 0.25;

    setState(() {
      _passwordStrength = strength;
      if (strength == 0) {
        _strengthColor = Colors.grey;
        _strengthLabel = 'Sangat Lemah';
      } else if (strength <= 0.25) {
        _strengthColor = Colors.red;
        _strengthLabel = 'Lemah';
      } else if (strength <= 0.5) {
        _strengthColor = Colors.orange;
        _strengthLabel = 'Sedang';
      } else if (strength <= 0.75) {
        _strengthColor = Colors.lightGreen;
        _strengthLabel = 'Kuat';
      } else {
        _strengthColor = Colors.green;
        _strengthLabel = 'Sangat Kuat';
      }
    });
  }

  void _savePassword() {
    if (_formKey.currentState!.validate()) {
      AppFeedback.success(context, 'Sandi berhasil diperbarui');
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFF006C49);
    const Color surfaceColor = Color(0xFFF8FAFB);

    return Scaffold(
      backgroundColor: surfaceColor,
      appBar: AppBar(
        title: Text('Ganti Sandi', style: GoogleFonts.sora(fontWeight: FontWeight.bold, fontSize: 18)),
        backgroundColor: surfaceColor,
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Buat sandi baru yang kuat untuk menjaga keamanan akun JBR Minpo Anda.',
                style: GoogleFonts.dmSans(color: Colors.grey.shade600, fontSize: 14),
              ),
              const SizedBox(height: 32),

              // Old Password
              Text('Sandi Saat Ini', style: GoogleFonts.dmSans(fontWeight: FontWeight.bold, fontSize: 14)),
              const SizedBox(height: 8),
              TextFormField(
                controller: _oldController,
                obscureText: _obscureOld,
                decoration: _buildInputDecoration(
                  hint: 'Masukkan sandi saat ini',
                  icon: Icons.lock_outline_rounded,
                  isObscured: _obscureOld,
                  onToggle: () => setState(() => _obscureOld = !_obscureOld),
                ),
                validator: (value) => value!.isEmpty ? 'Sandi saat ini wajib diisi' : null,
              ),
              const SizedBox(height: 24),

              // New Password
              Text('Sandi Baru', style: GoogleFonts.dmSans(fontWeight: FontWeight.bold, fontSize: 14)),
              const SizedBox(height: 8),
              TextFormField(
                controller: _newController,
                obscureText: _obscureNew,
                decoration: _buildInputDecoration(
                  hint: 'Masukkan sandi baru',
                  icon: Icons.lock_reset_rounded,
                  isObscured: _obscureNew,
                  onToggle: () => setState(() => _obscureNew = !_obscureNew),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Sandi baru wajib diisi';
                  if (value.length < 8) return 'Sandi minimal 8 karakter';
                  return null;
                },
              ),
              const SizedBox(height: 12),
              
              // Password Strength Indicator
              Row(
                children: [
                  Expanded(
                    child: LinearProgressIndicator(
                      value: _passwordStrength,
                      backgroundColor: Colors.grey.shade200,
                      color: _strengthColor,
                      minHeight: 6,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(_strengthLabel, style: GoogleFonts.jetBrainsMono(fontSize: 10, color: _strengthColor, fontWeight: FontWeight.bold)),
                ],
              ),
              const SizedBox(height: 24),

              // Confirm Password
              Text('Konfirmasi Sandi Baru', style: GoogleFonts.dmSans(fontWeight: FontWeight.bold, fontSize: 14)),
              const SizedBox(height: 8),
              TextFormField(
                controller: _confirmController,
                obscureText: _obscureConfirm,
                decoration: _buildInputDecoration(
                  hint: 'Ulangi sandi baru',
                  icon: Icons.lock_rounded,
                  isObscured: _obscureConfirm,
                  onToggle: () => setState(() => _obscureConfirm = !_obscureConfirm),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Konfirmasi sandi wajib diisi';
                  if (value != _newController.text) return 'Sandi tidak cocok';
                  return null;
                },
              ),
              const SizedBox(height: 48),

              // Save Button
              ElevatedButton(
                onPressed: _savePassword,
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 56),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  elevation: 0,
                ),
                child: Text(
                  'Simpan Sandi Baru',
                  style: GoogleFonts.sora(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration _buildInputDecoration({
    required String hint,
    required IconData icon,
    required bool isObscured,
    required VoidCallback onToggle,
  }) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: Colors.white,
      prefixIcon: Icon(icon, color: Colors.grey),
      suffixIcon: IconButton(
        icon: Icon(isObscured ? Icons.visibility_off_rounded : Icons.visibility_rounded, color: Colors.grey),
        onPressed: onToggle,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: Colors.grey.shade200),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Color(0xFF006C49), width: 2),
      ),
    );
  }
}
