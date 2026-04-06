import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:jbr_mimpo/core/utils/app_feedback.dart';

// Assuming AppColors is in core theme, we'll try to find its actual import later
// Using raw colors matching project to be safe.
class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController(text: 'Anjay Mabar');
  String _selectedArea = 'Jakarta Selatan';

  final List<String> _areas = [
    'Jakarta Selatan',
    'Jakarta Pusat',
    'Jakarta Barat',
    'Jakarta Timur',
    'Jakarta Utara',
    'Bekasi',
    'Tangerang',
    'Depok',
  ];

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _saveProfile() {
    if (_formKey.currentState!.validate()) {
      // Simulate save
      AppFeedback.success(context, 'Profil berhasil diperbarui');
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
        title: Text('Edit Profil', style: GoogleFonts.sora(fontWeight: FontWeight.bold, fontSize: 18)),
        backgroundColor: surfaceColor,
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Avatar Section
              Stack(
                alignment: Alignment.bottomRight,
                children: [
                  const CircleAvatar(
                    radius: 50,
                    backgroundImage: CachedNetworkImageProvider('https://i.pravatar.cc/150?img=11'),
                  ),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(
                      color: primaryColor,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.camera_alt_rounded, color: Colors.white, size: 20),
                  ),
                ],
              ),
              const SizedBox(height: 32),

              // Name Input
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Nama Lengkap', style: GoogleFonts.dmSans(fontWeight: FontWeight.bold, fontSize: 14)),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      hintText: 'Masukkan nama lengkap',
                      filled: true,
                      fillColor: Colors.white,
                      prefixIcon: const Icon(Icons.person_outline_rounded, color: Colors.grey),
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
                        borderSide: const BorderSide(color: primaryColor, width: 2),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) return 'Nama tidak boleh kosong';
                      return null;
                    },
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Area Dropdown
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Alamat/Area', style: GoogleFonts.dmSans(fontWeight: FontWeight.bold, fontSize: 14)),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    initialValue: _selectedArea,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      prefixIcon: const Icon(Icons.location_on_outlined, color: Colors.grey),
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
                        borderSide: const BorderSide(color: primaryColor, width: 2),
                      ),
                    ),
                    items: _areas.map((area) {
                      return DropdownMenuItem(
                        value: area,
                        child: Text(area, style: GoogleFonts.dmSans()),
                      );
                    }).toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() => _selectedArea = value);
                      }
                    },
                  ),
                ],
              ),
              const SizedBox(height: 48),

              // Save Button
              ElevatedButton(
                onPressed: _saveProfile,
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 56),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  elevation: 0,
                ),
                child: Text(
                  'Simpan Perubahan',
                  style: GoogleFonts.sora(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
