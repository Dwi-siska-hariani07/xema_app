import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'reset_password_screen.dart';

class VerifyOtpScreen extends StatefulWidget {
  const VerifyOtpScreen({super.key});

  @override
  State<VerifyOtpScreen> createState() => _VerifyOtpScreenState();
}

class _VerifyOtpScreenState extends State<VerifyOtpScreen> {
  // 6 Controller & FocusNode untuk kotak OTP 6 digit
  final List<TextEditingController> _otpControllers =
      List.generate(6, (index) => TextEditingController(text: '1'));
  final List<FocusNode> _otpFocusNodes =
      List.generate(6, (index) => FocusNode());

  // Warna Presisi Sesuai Figma
  final Color primaryPurple = const Color(0xFFB952DD); // Warna solid tombol Verify (#B952DD)
  final Color textDarkPurple = const Color(0xFF52086B); // Warna teks judul & deskripsi
  final Color boxBorderColor = const Color(0xFFD9D9D9); // Warna garis border kotak OTP
  final Color linkPurple = const Color(0xFFB828EE); // Warna ungu link Resend

  // Style font Pochaevsk resmi dari Google Fonts
  TextStyle pochaevskFont({
    double fontSize = 16,
    FontWeight fontWeight = FontWeight.normal,
    Color? color,
    double? height,
    List<Shadow>? shadows,
  }) {
    return GoogleFonts.pochaevsk(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color ?? textDarkPurple,
      height: height,
      shadows: shadows,
    );
  }

  @override
  void dispose() {
    for (var controller in _otpControllers) {
      controller.dispose();
    }
    for (var node in _otpFocusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SizedBox(
        width: size.width,
        height: size.height,
        child: FittedBox(
          fit: BoxFit.fill,
          alignment: Alignment.center,
          child: SizedBox(
            // Mengunci kanvas presisi 100% Figma (393 x 852)
            width: 393,
            height: 852,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                // =========================================================================
                // 1. HEADER: TOMBOL KEMBALI (<) DAN JUDUL "Verify OTP"
                // Posisi persis disamakan dengan Forget Password: top=57, left=10
                // =========================================================================
                Positioned(
                  top: 57,
                  left: 10,
                  right: 16,
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          width: 40,
                          height: 40,
                          color: Colors.transparent,
                          alignment: Alignment.center,
                          child: Icon(
                            Icons.arrow_back_ios_new_rounded,
                            size: 22,
                            color: textDarkPurple,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Verify OTP',
                        style: pochaevskFont(
                          fontSize: 32,
                          fontWeight: FontWeight.normal,
                          color: textDarkPurple,
                          shadows: const [
                            BoxShadow(
                              color: Color(0x40000000),
                              offset: Offset(0, 4),
                              blurRadius: 4,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // =========================================================================
                // 2. ILUSTRASI LENGKAP PERSIS FIGMA ASLI (Tangan, HP, Balon OTP, Lingkaran Ungu)
                // Gambar diekstrak langsung 100% dari artboard Figma tanpa distorsi
                // =========================================================================
                Positioned(
                  top: 110,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Image.asset(
                      'assets/images/figma_verify_otp_illustration_exact.png',
                      width: 360,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),

                // =========================================================================
                // 3. TEKS DESKRIPSI
                // "We have just sent a 6 digit code to your entered number. Enter the code below."
                // =========================================================================
                Positioned(
                  top: 365,
                  left: 24,
                  right: 24,
                  child: Text(
                    'We have just sent a 6 digit code to your entered number. Enter the code below.',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.rasa(
                      fontSize: 18,
                      height: 1.25,
                      fontWeight: FontWeight.normal,
                      color: textDarkPurple,
                    ),
                  ),
                ),

                // =========================================================================
                // 4. ENAM KOTAK INPUT DIGIT OTP (KOTAK 46 x 55, RADIUS 10)
                // =========================================================================
                Positioned(
                  top: 425,
                  left: 33.5,
                  width: 326,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(6, (index) {
                      return Container(
                        width: 46,
                        height: 55,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: boxBorderColor, width: 1.2),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.04),
                              blurRadius: 6,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Center(
                          child: TextField(
                            controller: _otpControllers[index],
                            focusNode: _otpFocusNodes[index],
                            keyboardType: TextInputType.number,
                            textAlign: TextAlign.center,
                            maxLength: 1,
                            style: pochaevskFont(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF222222),
                            ),
                            decoration: const InputDecoration(
                              counterText: '',
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.zero,
                            ),
                            onChanged: (value) {
                              if (value.isNotEmpty && index < 5) {
                                _otpFocusNodes[index + 1].requestFocus();
                              } else if (value.isEmpty && index > 0) {
                                _otpFocusNodes[index - 1].requestFocus();
                              }
                            },
                          ),
                        ),
                      );
                    }),
                  ),
                ),

                // =========================================================================
                // 5. TEKS "Didn't receive any code? Resend"
                // =========================================================================
                Positioned(
                  top: 555,
                  left: 33.5,
                  width: 326,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Didn't receive any code? ",
                        style: pochaevskFont(
                          fontSize: 15,
                          color: const Color(0xFF333333),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          // Aksi kirim ulang OTP
                        },
                        child: Text(
                          'Resend',
                          style: pochaevskFont(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: linkPurple,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // =========================================================================
                // 6. TOMBOL "Verify" (326 x 55, Solid Purple #B952DD, Radius 16)
                // =========================================================================
                Positioned(
                  top: 630,
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
                          // Menavigasi ke Halaman Reset Password
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const ResetPasswordScreen(),
                            ),
                          );
                        },
                        child: Center(
                          child: Text(
                            'Verify',
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
