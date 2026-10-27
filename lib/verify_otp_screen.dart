import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
  final Color textDarkPurple = const Color(0xFF3A0054); // Warna teks judul & deskripsi
  final Color boxBorderColor = const Color(0xFFD9D9D9); // Warna garis border kotak OTP
  final Color linkPurple = const Color(0xFFB828EE); // Warna ungu link Resend
  final Color ovalLightPurple = const Color(0xFFD89ADF); // Oval 1: Ungu lilac (#D89ADF)
  final Color ovalDarkPurple = const Color(0xFF904F9F); // Oval 2: Ungu core (#904F9F)

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
                // 1. HEADER: TOMBOL KEMBALI (<) DAN JUDUL "Verify OTP"
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
                        'Verify OTP',
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
                // 2. DUA OVAL UNGU BERTINGKAT DUA WARNA PERSIS FIGMA (SUDUT -37.2°, PUSAT 208, 229)
                // Oval 1 (Luar): Ungu Lilac (#D89ADF) 320 x 180 px
                // Oval 2 (Dalam): Ungu Core (#904F9F) 246 x 147 px
                // =========================================================================
                // OVAL 1: LUAR (UNGU LILAC #D89ADF)
                Positioned(
                  top: 139,
                  left: 48,
                  child: ImageFiltered(
                    imageFilter: ui.ImageFilter.blur(sigmaX: 4.0, sigmaY: 4.0),
                    child: Transform.rotate(
                      angle: -0.65, // Sudut kemiringan diagonal persis Figma (-37.2°)
                      child: Container(
                        width: 320,
                        height: 180,
                        decoration: const BoxDecoration(
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.all(
                            Radius.elliptical(320 / 2, 180 / 2),
                          ),
                          color: Color(0xFFD89ADF), // Warna ungu muda lilac persis Figma
                        ),
                      ),
                    ),
                  ),
                ),

                // OVAL 2: DALAM (UNGU CORE #904F9F)
                Positioned(
                  top: 155.5,
                  left: 85,
                  child: ImageFiltered(
                    imageFilter: ui.ImageFilter.blur(sigmaX: 3.0, sigmaY: 3.0),
                    child: Transform.rotate(
                      angle: -0.65, // Sudut kemiringan sejajar dengan oval luar (-37.2°)
                      child: Container(
                        width: 246,
                        height: 147,
                        decoration: const BoxDecoration(
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.all(
                            Radius.elliptical(246 / 2, 147 / 2),
                          ),
                          color: Color(0xFF904F9F), // Warna ungu core persis Figma
                        ),
                      ),
                    ),
                  ),
                ),

                // =========================================================================
                // 3. ILUSTRASI KARTUN: TANGAN MEMEGANG PONSEL DENGAN BALON OTP
                // =========================================================================
                Positioned(
                  top: 135,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Image.asset(
                      'assets/images/verify_otp_illustration.png',
                      height: 225,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),

                // =========================================================================
                // 4. TEKS DESKRIPSI
                // "We have just sent a 6 digit code to your entered number. Enter the code below."
                // =========================================================================
                Positioned(
                  top: 380,
                  left: 33.5,
                  width: 326,
                  child: Text(
                    'We have just sent a 6 digit code to your entered number. Enter the code below.',
                    textAlign: TextAlign.center,
                    style: pochaevskFont(
                      fontSize: 16,
                      height: 1.4,
                      fontWeight: FontWeight.normal,
                      color: textDarkPurple,
                    ),
                  ),
                ),

                // =========================================================================
                // 5. ENAM KOTAK INPUT DIGIT OTP (KOTAK 46 x 55, RADIUS 10)
                // =========================================================================
                Positioned(
                  top: 450,
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
                // 6. TEKS "Didn't receive any code? Resend"
                // =========================================================================
                Positioned(
                  top: 550,
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
                // 7. TOMBOL "Verify" (326 x 55, Solid Purple #B952DD, Radius 16)
                // =========================================================================
                Positioned(
                  top: 615,
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
                          // Nanti akan mengarah ke Halaman Reset Password (Halaman 4)
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
