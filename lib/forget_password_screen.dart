import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'verify_otp_screen.dart';

class ForgetPasswordScreen extends StatefulWidget {
  const ForgetPasswordScreen({super.key});

  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  final TextEditingController _phoneController =
      TextEditingController(text: '081212120908');

  // Kode Warna Presisi Sesuai Figma
  final Color purpleBg50 = const Color(0x66CA31FF); // Lengkungan ungu dengan transparansi lembut
  final Color primaryPurple = const Color(0xFFB952DD); // Warna solid tombol Get OTP (#B952DD)
  final Color textDarkPurple = const Color(0xFF3A0054); // Warna teks judul & deskripsi
  final Color inputBorderColor = const Color(0xFFD9D9D9); // Kode warna border D9D9D9 sesuai permintaan

  // Style font Pochaevsk resmi dari Google Fonts
  TextStyle pochaevskFont({
    double fontSize = 16,
    FontWeight fontWeight = FontWeight.normal,
    Color? color,
    double? height,
  }) {
    return GoogleFonts.pochaevsk(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color ?? textDarkPurple,
      height: height,
    );
  }

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Container(
            width: 393,
            height: 852,
            clipBehavior: Clip.antiAlias,
            decoration: const BoxDecoration(
              color: Colors.white,
            ),
            child: Stack(
              children: [
                // =========================================================================
                // 1. LENGKUNGAN UNGU ATAS-KIRI (DENGAN LAYER BLUR = 4 FIGMA)
                // =========================================================================
                Positioned(
                  left: -140,
                  top: -100,
                  width: 380,
                  height: 380,
                  child: ImageFiltered(
                    imageFilter: ui.ImageFilter.blur(sigmaX: 2.0, sigmaY: 2.0),
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: purpleBg50,
                      ),
                    ),
                  ),
                ),

                // =========================================================================
                // 2. LENGKUNGAN UNGU BAWAH-KANAN (PERSIS GAMBAR FIGMA: LANDAI DI DASAR)
                // =========================================================================
                Positioned.fill(
                  child: ImageFiltered(
                    imageFilter: ui.ImageFilter.blur(sigmaX: 2.0, sigmaY: 2.0),
                    child: CustomPaint(
                      painter: BottomRightMoundPainter(color: purpleBg50),
                    ),
                  ),
                ),

                // =========================================================================
                // 3. HEADER: TOMBOL KEMBALI (<) DAN JUDUL "Forget Password"
                // =========================================================================
                Positioned(
                  top: 64,
                  left: 20,
                  right: 20,
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          color: Colors.transparent,
                          child: Icon(
                            Icons.arrow_back_ios_new_rounded,
                            size: 22,
                            color: textDarkPurple,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Forget Password',
                        style: pochaevskFont(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: textDarkPurple,
                        ),
                      ),
                    ],
                  ),
                ),

                // =========================================================================
                // 4. ILUSTRASI KARTUN TENGAH (UKURAN BESAR PERSIS FIGMA, 330 x 236)
                // =========================================================================
                Positioned(
                  top: 175,
                  left: 31.5,
                  width: 330,
                  height: 240,
                  child: Image.asset(
                    'assets/images/forgot_password_illustration.png',
                    fit: BoxFit.contain,
                  ),
                ),

                // =========================================================================
                // 5. TEKS DESKRIPSI (UKURAN ASLI 16 PERSIS FIGMA, ELEGAN & RAPI)
                // "Please enter your phone number. We will send a code..."
                // =========================================================================
                Positioned(
                  top: 440,
                  left: 33.5,
                  width: 326,
                  child: Text(
                    'Please enter your phone number. We will send a code to your number to reset your password.',
                    style: pochaevskFont(
                      fontSize: 16,
                      height: 1.35,
                      fontWeight: FontWeight.normal,
                      color: textDarkPurple,
                    ),
                  ),
                ),

                // =========================================================================
                // 6. INPUT NOMOR HANDPHONE (326 x 55, UKURAN ASLI 18, BORDER D9D9D9)
                // =========================================================================
                Positioned(
                  top: 505,
                  left: 33.5,
                  child: Container(
                    width: 326,
                    height: 55,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: inputBorderColor, width: 1.2),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Center(
                      child: TextField(
                        controller: _phoneController,
                        keyboardType: TextInputType.phone,
                        style: pochaevskFont(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF222222),
                        ),
                        decoration: InputDecoration(
                          isDense: true,
                          prefixIcon: Padding(
                            padding: const EdgeInsets.only(left: 16, right: 10),
                            child: Icon(
                              Icons.phone_outlined,
                              color: const Color(0xFF222222),
                              size: 22,
                            ),
                          ),
                          prefixIconConstraints: const BoxConstraints(
                            minWidth: 48,
                            minHeight: 24,
                          ),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 14,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                // =========================================================================
                // 7. TOMBOL "Get OTP" (326 x 55, Solid Purple #B952DD, Dinaikkan Rapi)
                // =========================================================================
                Positioned(
                  top: 610,
                  left: 33.5,
                  child: Container(
                    width: 326,
                    height: 55,
                    decoration: BoxDecoration(
                      color: primaryPurple,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFF4A006A), width: 1),
                      boxShadow: [
                        BoxShadow(
                          color: primaryPurple.withValues(alpha: 0.40),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(16),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const VerifyOtpScreen(),
                            ),
                          );
                        },
                        child: Center(
                          child: Text(
                            'Get OTP',
                            style: pochaevskFont(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// PAINTER UNTUK LENGKUNGAN UNGU BAWAH-KANAN PERSIS FIGMA
class BottomRightMoundPainter extends CustomPainter {
  final Color color;
  BottomRightMoundPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    // Busur lingkaran cembung murni persis gambar asli Figma (Radius: 268.5):
    // Mulai dari X: 135 di dasar layar, melengkung bulat ke (393, 715) di tepi kanan
    final path = Path()
      ..moveTo(135, 852)
      ..arcToPoint(
        const Offset(393, 715),
        radius: const Radius.circular(268.5),
        clockwise: true, // Bulat cembung sempurna ke atas
      )
      ..lineTo(393, 852)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
