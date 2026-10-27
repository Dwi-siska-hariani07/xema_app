import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'history_screen.dart';

class PersonalDetailsScreen extends StatefulWidget {
  const PersonalDetailsScreen({super.key});

  @override
  State<PersonalDetailsScreen> createState() => _PersonalDetailsScreenState();
}

class _PersonalDetailsScreenState extends State<PersonalDetailsScreen> {
  // Controller untuk menangani input form
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  final FocusNode _nameFocus = FocusNode();
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _addressFocus = FocusNode();

  bool _isNameFilled = false;

  @override
  void initState() {
    super.initState();
    _nameController.addListener(() {
      final isFilled = _nameController.text.trim().isNotEmpty;
      if (isFilled != _isNameFilled) {
        setState(() {
          _isNameFilled = isFilled;
        });
      }
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    _nameFocus.dispose();
    _emailFocus.dispose();
    _addressFocus.dispose();
    super.dispose();
  }

  // Fungsi saat tombol Save ditekan
  void _onSave() {
    if (!_isNameFilled) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: Color(0xFFF3E5F5),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check_circle_rounded,
                color: Color(0xFFCA31FF),
                size: 60,
              ),
            ),
            const SizedBox(height: 18),
            Text(
              'Data Tersimpan!',
              style: GoogleFonts.rasa(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Selamat datang, ${_nameController.text.trim()}!',
              textAlign: TextAlign.center,
              style: GoogleFonts.rasa(
                fontSize: 15,
                color: const Color(0xFF545252),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );

    Future.delayed(const Duration(milliseconds: 1500), () {
      if (mounted) {
        Navigator.pop(context);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HistoryScreen()),
        );
      }
    });
  }

  // Shortcut untuk mengisi otomatis "Lisa Aruni" sesuai contoh Figma
  void _quickFillLisaAruni() {
    setState(() {
      _nameController.text = 'Lisa Aruni';
      _emailController.text = 'lisa.aruni@gmail.com';
      _addressController.text = 'Jakarta, Indonesia';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      body: Center(
        child: Container(
          // Presisi Frame iPhone 16 di Figma (W: 393, H: 852)
          constraints: const BoxConstraints(
            maxWidth: 393,
            maxHeight: 852,
          ),
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            color: Colors.white,
          ),
          child: Stack(
            fit: StackFit.expand,
            clipBehavior: Clip.antiAlias,
            children: [
              // ==========================================
              // 1. DEKORASI BACKGROUND ELIPS (FIGMA ASLI)
              // ==========================================

              // Ellipse 14: Lengkungan sudut kiri atas
              Positioned(
                top: -45,
                left: -45,
                child: IgnorePointer(
                  child: Container(
                    width: 210,
                    height: 160,
                    decoration: BoxDecoration(
                      color: const Color(0xFFCA31FF).withValues(alpha: 0.35),
                      borderRadius: const BorderRadius.all(
                        Radius.elliptical(210, 160),
                      ),
                    ),
                  ),
                ),
              ),

              // Ellipse 22: Lengkungan sudut kanan bawah (Figma y: ~780-852)
              Positioned(
                bottom: -50,
                right: -30,
                child: IgnorePointer(
                  child: Container(
                    width: 250,
                    height: 160,
                    decoration: BoxDecoration(
                      color: const Color(0xFFCA31FF).withValues(alpha: 0.35),
                      borderRadius: const BorderRadius.all(
                        Radius.elliptical(250, 160),
                      ),
                    ),
                  ),
                ),
              ),

              // ==========================================
              // 2. KONTEN UTAMA
              // ==========================================
              SafeArea(
                child: Column(
                  children: [
                    // --- TOP BAR: TOMBOL BACK & JUDUL ---
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: Row(
                        children: [
                          IconButton(
                            icon: const Icon(
                              Icons.arrow_back_ios_new,
                              size: 20,
                              color: Color(0xFFCA31FF), // Ungu khas Figma (#CA31FF)
                            ),
                            onPressed: () => Navigator.maybePop(context),
                          ),
                          const SizedBox(width: 4),
                          // HEADER "Personal Details" -> FONT POCHAEVSK
                          Text(
                            'Personal Details',
                            style: GoogleFonts.pochaevsk(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          const Spacer(),
                          // Tombol Demo opsional untuk menguji preset "Lisa Aruni"
                          TextButton(
                            onPressed: _quickFillLisaAruni,
                            style: TextButton.styleFrom(
                              padding: const EdgeInsets.symmetric(horizontal: 8),
                              minimumSize: Size.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            child: Text(
                              'Demo',
                              style: GoogleFonts.rasa(
                                fontSize: 13,
                                color: const Color(0xFFCA31FF),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // --- AREA SCROLLABLE FORM ---
                    Expanded(
                      child: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        padding: const EdgeInsets.symmetric(horizontal: 24.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const SizedBox(height: 10),

                            // --- SUBTITLE: FONT RASA ---
                            Text(
                              'Your personal information will help our\nservice to reach you easily',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.rasa(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                                color: const Color(0xFF545252),
                                height: 1.35,
                              ),
                            ),

                            const SizedBox(height: 26),

                            // --- AVATAR PROFIL (Generic Avatar) ---
                            Center(
                              child: Container(
                                width: 88,
                                height: 88,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: const Color(0xFFFAF2FF),
                                  border: Border.all(
                                    color: const Color(0xFFCA31FF),
                                    width: 2.2,
                                  ),
                                ),
                                child: const Center(
                                  child: Icon(
                                    Icons.person_outline_rounded,
                                    color: Color(0xFFCA31FF),
                                    size: 52,
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(height: 34),

                            // --- INPUT 1: FULL NAME (Rectangle 45) ---
                            _buildInputField(
                              controller: _nameController,
                              focusNode: _nameFocus,
                              hintText: 'Full name',
                              icon: Icons.person_outline_rounded,
                              iconColor: const Color(0xFFCA31FF),
                            ),

                            const SizedBox(height: 18),

                            // --- INPUT 2: GMAIL (Rectangle 44) ---
                            _buildInputField(
                              controller: _emailController,
                              focusNode: _emailFocus,
                              hintText: 'Gmail',
                              icon: Icons.mail_outline_rounded,
                              iconColor: Colors.black87,
                              keyboardType: TextInputType.emailAddress,
                            ),

                            const SizedBox(height: 18),

                            // --- INPUT 3: ADDRESS (Rectangle 43) ---
                            _buildInputField(
                              controller: _addressController,
                              focusNode: _addressFocus,
                              hintText: 'Address',
                              icon: Icons.location_on_outlined,
                              iconColor: Colors.black87,
                              keyboardType: TextInputType.streetAddress,
                            ),

                            const SizedBox(height: 28),

                            // --- TOMBOL SAVE (Rectangle 42 / save) ---
                            // FONT: ROBOTO SLAB
                            SizedBox(
                              width: double.infinity,
                              height: 52,
                              child: ElevatedButton(
                                onPressed: _isNameFilled ? _onSave : null,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: _isNameFilled
                                      ? const Color(0xFFCA31FF)
                                      : const Color(0xFFD9D9D9),
                                  disabledBackgroundColor: const Color(0xFFD9D9D9),
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: Text(
                                  'Save',
                                  style: GoogleFonts.robotoSlab(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(height: 36),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget pembantu untuk merender setiap kotak input form
  Widget _buildInputField({
    required TextEditingController controller,
    required FocusNode focusNode,
    required String hintText,
    required IconData icon,
    required Color iconColor,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Container(
      height: 52,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFFD9D9D9),
          width: 1.2,
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Icon(
            icon,
            color: iconColor,
            size: 22,
          ),
          const SizedBox(width: 14),
          Expanded(
            child: TextField(
              controller: controller,
              focusNode: focusNode,
              keyboardType: keyboardType,
              // TEKS INPUT USER -> FONT RASA
              style: GoogleFonts.rasa(
                fontSize: 16,
                color: Colors.black87,
                fontWeight: FontWeight.w600,
              ),
              decoration: InputDecoration(
                hintText: hintText,
                // PLACEHOLDER STRING -> FONT RASA
                hintStyle: GoogleFonts.rasa(
                  fontSize: 16,
                  color: const Color(0xFF545252).withValues(alpha: 0.65),
                  fontWeight: FontWeight.normal,
                ),
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
