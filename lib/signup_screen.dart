import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'login_screen.dart';
import 'signup_verify_otp_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  // Controller input form
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _rePasswordController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _pobController = TextEditingController(); // Tempat Lahir
  final TextEditingController _idNumberController = TextEditingController(); // Nomor KTP / Passport

  // State Tanggal Lahir
  DateTime? _selectedDate;

  // Pilihan Jenis Identitas (KTP atau Pasport)
  String _selectedIdType = 'KTP'; // 'KTP' atau 'Pasport'

  // State Status Upload Foto KTP & Pas Foto
  bool _isKtpUploaded = false;
  String _ktpFileName = '';
  bool _isPhotoUploaded = false;
  String _photoFileName = '';

  // Toggle visibilitas sandi
  bool isPasswordHidden = true;
  bool isRePasswordHidden = true;

  // Kode Warna Presisi Figma Desain User
  final Color inputBgColor = const Color(0xFFF3D8FF); // Fill #F3D8FF
  final Color strokeColor = const Color(0xFFCA31FF); // Border #CA31FF
  final Color textPurple = const Color(0xFF570374); // Judul Sign up #570374
  final Color hintPurple = const Color(0xFFC751EE); // Teks placeholder persis gambar
  final Color iconColor = const Color(0xFF1E1E1E); // Ikon garis hitam tegas
  final Color btnDaftarColor = const Color(0xFFCA31FF); // Warna tombol Daftar Sekarang

  @override
  void dispose() {
    _phoneController.dispose();
    _passwordController.dispose();
    _rePasswordController.dispose();
    _emailController.dispose();
    _pobController.dispose();
    _idNumberController.dispose();
    super.dispose();
  }

  // Dialog / DatePicker untuk Tanggal Lahir
  Future<void> _selectDate(BuildContext context) async {
    final DateTime initialDate = _selectedDate ?? DateTime(2000, 1, 1);
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(1945),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFFCA31FF),
              onPrimary: Colors.white,
              onSurface: Color(0xFF570374),
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: const Color(0xFFCA31FF),
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  // Upload Dokumen KTP / Pasport
  void _pickKtpDocument() {
    setState(() {
      _isKtpUploaded = true;
      _ktpFileName = '${_selectedIdType.toLowerCase()}_dokumen.jpg';
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle_rounded, color: Colors.white),
            const SizedBox(width: 10),
            Text(
              'Dokumen $_selectedIdType berhasil dipilih!',
              style: GoogleFonts.poppins(fontSize: 13),
            ),
          ],
        ),
        backgroundColor: const Color(0xFFCA31FF),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  // Upload Pas Foto Wajah
  void _pickUserPhoto() {
    setState(() {
      _isPhotoUploaded = true;
      _photoFileName = 'pas_foto_wajah.jpg';
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle_rounded, color: Colors.white),
            const SizedBox(width: 10),
            Text(
              'Pas foto wajah berhasil dipilih!',
              style: GoogleFonts.poppins(fontSize: 13),
            ),
          ],
        ),
        backgroundColor: const Color(0xFFCA31FF),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  // Validasi dan Lanjut ke Verifikasi OTP
  void _onSignUpSubmit() {
    if (_phoneController.text.trim().isEmpty) {
      _showWarning('Harap isi nomor telepon terlebih dahulu');
      return;
    }
    if (_emailController.text.trim().isEmpty) {
      _showWarning('Harap isi email terlebih dahulu');
      return;
    }
    if (_passwordController.text.isEmpty) {
      _showWarning('Harap isi kata sandi');
      return;
    }
    if (_rePasswordController.text != _passwordController.text) {
      _showWarning('Kata sandi konfirmasi tidak cocok');
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const SignupVerifyOtpScreen(),
      ),
    );
  }

  void _showWarning(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.warning_amber_rounded, color: Colors.white),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                message,
                style: GoogleFonts.poppins(fontSize: 13),
              ),
            ),
          ],
        ),
        backgroundColor: const Color(0xFFE91E63),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // =============================================================
          // Latar Belakang Lengkungan Ungu Bawah (Fixed di Dasar Layar)
          // =============================================================
          Positioned(
            bottom: 0,
            left: 0,
            width: 254,
            height: 131,
            child: IgnorePointer(
              child: Image.asset(
                'assets/images/figma_bottom_curve.png',
                fit: BoxFit.fill,
              ),
            ),
          ),

          // =============================================================
          // KONTEN UTAMA: BISA DI-SCROLL
          // =============================================================
          SafeArea(
            top: false,
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // 1. KUBAH ATAS (Logo & Xema)
                  SizedBox(
                    width: double.infinity,
                    height: 203,
                    child: Image.asset(
                      'assets/images/figma_top_dome.png',
                      fit: BoxFit.fill,
                      alignment: Alignment.topCenter,
                    ),
                  ),

                  const SizedBox(height: 16),

                  // 2. JUDUL: "Sign up"
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Sign up',
                        style: GoogleFonts.pochaevsk(
                          fontSize: 32,
                          fontWeight: FontWeight.normal,
                          color: textPurple,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 18),

                  // 3. KOTAK INPUT: Phone number (Ikon Gagang Telepon Outline)
                  _buildTextFormField(
                    icon: Icons.phone_outlined,
                    hint: 'Phone number',
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                  ),

                  const SizedBox(height: 16),

                  // 4. KOTAK INPUT: Email address (Ikon Amplop Surat Outline)
                  _buildTextFormField(
                    icon: Icons.mail_outline_rounded,
                    hint: 'Email address',
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                  ),

                  const SizedBox(height: 16),

                  // 5. KOTAK INPUT: Tempat Lahir (Ikon Rumah Outline dengan Garis Bawah)
                  _buildTextFormField(
                    icon: Icons.roofing_rounded,
                    hint: 'Tempat Lahir',
                    controller: _pobController,
                    keyboardType: TextInputType.text,
                  ),

                  const SizedBox(height: 16),

                  // 6. KOTAK INPUT: Tanggal Lahir (Ikon Kalender & Panah Bawah Bulat Ungu)
                  _buildDatePickerField(context),

                  const SizedBox(height: 18),

                  // 7. PILIH JENIS IDENTITAS (KTP / Pasport)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Pilih Jenis Identitas',
                          style: GoogleFonts.pochaevsk(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: textPurple,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            // Tombol KTP
                            Expanded(
                              child: _buildIdPill(
                                label: 'KTP',
                                isSelected: _selectedIdType == 'KTP',
                                onTap: () => setState(() => _selectedIdType = 'KTP'),
                              ),
                            ),
                            const SizedBox(width: 16),
                            // Tombol Pasport
                            Expanded(
                              child: _buildIdPill(
                                label: 'Pasport',
                                isSelected: _selectedIdType == 'Pasport',
                                onTap: () => setState(() => _selectedIdType = 'Pasport'),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // 8. KOTAK INPUT: Nomor Induk Kependudukan / Pasport (Tanpa Ikon Depan)
                  _buildPlainFormField(
                    hint: _selectedIdType == 'KTP' ? 'Nomor Induk Kependuduka..' : 'Nomor Pasport..',
                    controller: _idNumberController,
                    keyboardType: _selectedIdType == 'KTP' ? TextInputType.number : TextInputType.text,
                  ),

                  const SizedBox(height: 16),

                  // 9. KOTAK UPLOAD DOKUMEN KTP (Rounded Rectangle Ungu 2 Baris Tengah)
                  _buildUploadDocumentBox(
                    title: 'Upload Dokumen $_selectedIdType',
                    subtitle: _isKtpUploaded ? _ktpFileName : 'Format JPG/PNG maks 5mb',
                    onTap: _pickKtpDocument,
                  ),

                  const SizedBox(height: 16),

                  // 10. KOTAK INPUT: Password (Gembok Outline + Ikon Mata Tidur)
                  _buildTextFormField(
                    icon: Icons.lock_outline_rounded,
                    hint: 'Password',
                    controller: _passwordController,
                    isPassword: true,
                    isObscured: isPasswordHidden,
                    onToggleObscure: () {
                      setState(() {
                        isPasswordHidden = !isPasswordHidden;
                      });
                    },
                  ),

                  const SizedBox(height: 16),

                  // 11. KOTAK INPUT: Re enter password (Gembok Outline + Ikon Mata Tidur)
                  _buildTextFormField(
                    icon: Icons.lock_outline_rounded,
                    hint: 'Re enter password',
                    controller: _rePasswordController,
                    isPassword: true,
                    isObscured: isRePasswordHidden,
                    onToggleObscure: () {
                      setState(() {
                        isRePasswordHidden = !isRePasswordHidden;
                      });
                    },
                  ),

                  const SizedBox(height: 16),

                  // 12. KOTAK UPLOAD PAS FOTO WAJAH (Ikon Kamera Kotak Outline + Teks 2 Baris Rata Kiri)
                  _buildUploadPhotoBox(
                    title: 'Upload Pas Foto Wajah',
                    subtitle: _isPhotoUploaded ? _photoFileName : 'Ambil foto selfie/format diri anda',
                    onTap: _pickUserPhoto,
                  ),

                  const SizedBox(height: 24),

                  // 13. TOMBOL DAFTAR SEKARANG (Ungu Cerah #CA31FF, Teks Poppins Bold Putih)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: GestureDetector(
                      onTap: _onSignUpSubmit,
                      child: Container(
                        width: double.infinity,
                        height: 52,
                        decoration: BoxDecoration(
                          color: btnDaftarColor,
                          borderRadius: BorderRadius.circular(26),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF772096).withValues(alpha: 0.35),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          'Daftar Sekarang',
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: 0.3,
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // 14. FOOTER: "Already have an account? Log in"
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Already have an account? ',
                        style: GoogleFonts.pochaevsk(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: textPurple,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const LoginScreen(),
                            ),
                          );
                        },
                        child: Text(
                          'Log in',
                          style: GoogleFonts.pochaevsk(
                            fontSize: 16,
                            color: const Color(0xFFCA31FF),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 50),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================================
  // WIDGET KOTAK INPUT STANDARD DENGAN IKON (Fill #F3D8FF, Stroke #CA31FF, Radius 25)
  // ============================================================================
  Widget _buildTextFormField({
    required IconData icon,
    required String hint,
    required TextEditingController controller,
    TextInputType keyboardType = TextInputType.text,
    bool isPassword = false,
    bool isObscured = false,
    VoidCallback? onToggleObscure,
  }) {
    return Container(
      width: 326,
      height: 55,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: inputBgColor,
        borderRadius: BorderRadius.circular(25),
        border: Border.all(
          color: strokeColor,
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF772096).withValues(alpha: 0.35),
            blurRadius: 8,
            spreadRadius: 1,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(
            icon,
            size: 22,
            color: iconColor,
          ),
          const SizedBox(width: 14),
          Expanded(
            child: TextField(
              controller: controller,
              keyboardType: keyboardType,
              obscureText: isPassword && isObscured,
              style: GoogleFonts.rasa(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: textPurple,
              ),
              decoration: InputDecoration(
                hintText: hint,
                hintStyle: GoogleFonts.rasa(
                  fontSize: 20,
                  fontWeight: FontWeight.normal,
                  color: hintPurple,
                ),
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),
          if (isPassword)
            GestureDetector(
              onTap: onToggleObscure,
              child: SizedBox(
                width: 26,
                height: 18,
                child: isObscured
                    ? CustomPaint(painter: _ClosedEyePainter())
                    : const Icon(
                        Icons.visibility_outlined,
                        size: 20,
                        color: Color(0xFF1E1E1E),
                      ),
              ),
            ),
        ],
      ),
    );
  }

  // ============================================================================
  // WIDGET KOTAK INPUT TANPA IKON (Nomor Induk Kependudukan)
  // ============================================================================
  Widget _buildPlainFormField({
    required String hint,
    required TextEditingController controller,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Container(
      width: 326,
      height: 55,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: inputBgColor,
        borderRadius: BorderRadius.circular(25),
        border: Border.all(
          color: strokeColor,
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF772096).withValues(alpha: 0.35),
            blurRadius: 8,
            spreadRadius: 1,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Center(
        child: TextField(
          controller: controller,
          keyboardType: keyboardType,
          style: GoogleFonts.rasa(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: textPurple,
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: GoogleFonts.rasa(
              fontSize: 20,
              fontWeight: FontWeight.normal,
              color: hintPurple,
            ),
            border: InputBorder.none,
            isDense: true,
            contentPadding: EdgeInsets.zero,
          ),
        ),
      ),
    );
  }

  // ============================================================================
  // WIDGET DATE PICKER (Tanggal Lahir dengan Ikon Kalender & Chevron Dropdown)
  // ============================================================================
  Widget _buildDatePickerField(BuildContext context) {
    final String dateDisplay = _selectedDate == null
        ? 'Tanggal Lahir'
        : '${_selectedDate!.day.toString().padLeft(2, '0')}/${_selectedDate!.month.toString().padLeft(2, '0')}/${_selectedDate!.year}';

    return GestureDetector(
      onTap: () => _selectDate(context),
      child: Container(
        width: 326,
        height: 55,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: inputBgColor,
          borderRadius: BorderRadius.circular(25),
          border: Border.all(
            color: strokeColor,
            width: 1.2,
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF772096).withValues(alpha: 0.35),
              blurRadius: 8,
              spreadRadius: 1,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(
              Icons.calendar_today_outlined,
              size: 20,
              color: iconColor,
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                dateDisplay,
                style: GoogleFonts.rasa(
                  fontSize: 20,
                  fontWeight: _selectedDate == null ? FontWeight.normal : FontWeight.w600,
                  color: _selectedDate == null ? hintPurple : textPurple,
                ),
              ),
            ),
            const Icon(
              Icons.keyboard_arrow_down_rounded,
              color: Color(0xFFCA31FF),
              size: 26,
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================================
  // WIDGET KAPSUL PILIHAN IDENTITAS (KTP / Pasport) Sesuai Gambar
  // ============================================================================
  Widget _buildIdPill({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          color: inputBgColor,
          borderRadius: BorderRadius.circular(25),
          border: Border.all(
            color: strokeColor,
            width: isSelected ? 2.0 : 1.2,
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF772096).withValues(alpha: 0.35),
              blurRadius: 8,
              spreadRadius: 1,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: GoogleFonts.pochaevsk(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: textPurple,
          ),
        ),
      ),
    );
  }

  // ============================================================================
  // WIDGET UPLOAD DOKUMEN KTP (Teks 2 Baris Rata Tengah)
  // ============================================================================
  Widget _buildUploadDocumentBox({
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 326,
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
        decoration: BoxDecoration(
          color: inputBgColor,
          borderRadius: BorderRadius.circular(25),
          border: Border.all(
            color: strokeColor,
            width: 1.2,
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF772096).withValues(alpha: 0.35),
              blurRadius: 8,
              spreadRadius: 1,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              style: GoogleFonts.pochaevsk(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: textPurple,
              ),
            ),
            const SizedBox(height: 3),
            Text(
              subtitle,
              style: GoogleFonts.rasa(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: textPurple,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================================
  // WIDGET UPLOAD PAS FOTO WAJAH (Ikon Kamera Outline + Teks Rata Kiri)
  // ============================================================================
  Widget _buildUploadPhotoBox({
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 326,
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
        decoration: BoxDecoration(
          color: inputBgColor,
          borderRadius: BorderRadius.circular(25),
          border: Border.all(
            color: strokeColor,
            width: 1.2,
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF772096).withValues(alpha: 0.35),
              blurRadius: 8,
              spreadRadius: 1,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(
              Icons.camera_alt_outlined,
              size: 28,
              color: iconColor,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.pochaevsk(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: textPurple,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: GoogleFonts.rasa(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: textPurple,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================================
// CUSTOM PAINTER: Ikon Mata Tidur (Vector Asli Figma #302:139)
// ============================================================================
class _ClosedEyePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF1E1E1E)
      ..strokeWidth = 1.8
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final path = Path();
    path.moveTo(0, size.height * 0.35);
    path.quadraticBezierTo(
      size.width / 2,
      size.height * 0.85,
      size.width,
      size.height * 0.35,
    );
    canvas.drawPath(path, paint);

    // 3 Bulu mata bawah
    canvas.drawLine(
      Offset(size.width * 0.25, size.height * 0.65),
      Offset(size.width * 0.15, size.height * 1.05),
      paint,
    );
    canvas.drawLine(
      Offset(size.width * 0.50, size.height * 0.80),
      Offset(size.width * 0.50, size.height * 1.25),
      paint,
    );
    canvas.drawLine(
      Offset(size.width * 0.75, size.height * 0.65),
      Offset(size.width * 0.85, size.height * 1.05),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
