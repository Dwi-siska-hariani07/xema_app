import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'profile_screen.dart';

class SignupVerifyOtpScreen extends StatefulWidget {
  const SignupVerifyOtpScreen({super.key});

  @override
  State<SignupVerifyOtpScreen> createState() => _SignupVerifyOtpScreenState();
}

class _SignupVerifyOtpScreenState extends State<SignupVerifyOtpScreen> {
  // 6 digit OTP input state
  String _otpCode = '';

  // Warna Presisi Sesuai Figma
  final Color textDarkPurple = const Color(0xFF52086B); // #52086B Judul Verify OTP
  final Color textDescription = const Color(0xFF570374); // #570374 Teks deskripsi
  final Color boxBorderColor = const Color(0xFFD9D9D9); // Garis kotak OTP
  final Color linkPurple = const Color(0xFFCA31FF); // Link Resend ungu
  final Color keyBgColor = const Color(0xFFD9D9D9); // Warna tombol keyboard numerik Figma
  final Color keyTextColor = const Color(0xFF000000); // Warna teks tombol keyboard

  void _onKeyPress(String val) {
    if (_otpCode.length < 6) {
      setState(() {
        _otpCode += val;
      });
      // Jika sudah 6 digit terisi otomatis dapat dilanjutkan
    }
  }

  void _onDelete() {
    if (_otpCode.isNotEmpty) {
      setState(() {
        _otpCode = _otpCode.substring(0, _otpCode.length - 1);
      });
    }
  }

  void _onSubmit() {
    // Selesai verifikasi OTP dari pendaftaran -> lanjut ke ProfileScreen (Personal Details)
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const ProfileScreen()),
      (route) => false,
    );
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
            // Kanvas presisi 1:1 Figma (393 x 852)
            width: 393,
            height: 852,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                // =============================================================
                // 1. HEADER: TOMBOL KEMBALI (<) DAN JUDUL "Verify OTP"
                // =============================================================
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
                        style: GoogleFonts.pochaevsk(
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

                // =============================================================
                // 2. ILUSTRASI OTP FIGMA ASLI (Tangan, HP, Balon OTP, Lingkaran Ungu)
                // =============================================================
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

                // =============================================================
                // 3. TEKS DESKRIPSI
                // "We have just sent a 6 digit code to your entered number. Enter the code below."
                // =============================================================
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
                      color: textDescription,
                    ),
                  ),
                ),

                // =============================================================
                // 4. ENAM KOTAK INPUT DIGIT OTP (KOSONG DENGAN TEKS DIGIT INPUT)
                // Kotak Figma: width ~46, height ~58, radius 10
                // =============================================================
                Positioned(
                  top: 425,
                  left: 20,
                  right: 20,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(6, (index) {
                      final bool hasChar = index < _otpCode.length;
                      final String char = hasChar ? _otpCode[index] : '';

                      return Container(
                        width: 48,
                        height: 58,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: hasChar
                                ? const Color(0xFFCA31FF)
                                : boxBorderColor,
                            width: hasChar ? 1.8 : 1.2,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.04),
                              blurRadius: 6,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          char,
                          style: GoogleFonts.pochaevsk(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF222222),
                          ),
                        ),
                      );
                    }),
                  ),
                ),

                // =============================================================
                // 5. TEKS "Didn't receive any code? Resend"
                // =============================================================
                Positioned(
                  top: 510,
                  left: 0,
                  right: 0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Didn't receive any code? ",
                        style: GoogleFonts.pochaevsk(
                          fontSize: 15,
                          color: textDescription,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          // Aksi kirim ulang OTP
                        },
                        child: Text(
                          'Resend',
                          style: GoogleFonts.pochaevsk(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: linkPurple,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // =============================================================
                // 6. KEYBOARD NUMERIK FIGMA PERSIS 1:1 DI BAGIAN BAWAH
                // Grid 4 Kolom x 4 Baris (1-3 -, 4-6 space, 7-9 del, , 0 . check)
                // =============================================================
                Positioned(
                  bottom: 24,
                  left: 18,
                  right: 18,
                  child: Column(
                    children: [
                      // Baris 1: 1, 2, 3, -
                      _buildKeyboardRow([
                        _KeyData(label: '1', onTap: () => _onKeyPress('1')),
                        _KeyData(label: '2', onTap: () => _onKeyPress('2')),
                        _KeyData(label: '3', onTap: () => _onKeyPress('3')),
                        _KeyData(label: '—', onTap: () {}),
                      ]),
                      const SizedBox(height: 12),

                      // Baris 2: 4, 5, 6, ␣
                      _buildKeyboardRow([
                        _KeyData(label: '4', onTap: () => _onKeyPress('4')),
                        _KeyData(label: '5', onTap: () => _onKeyPress('5')),
                        _KeyData(label: '6', onTap: () => _onKeyPress('6')),
                        _KeyData(icon: Icons.space_bar_rounded, onTap: () {}),
                      ]),
                      const SizedBox(height: 12),

                      // Baris 3: 7, 8, 9, backspace
                      _buildKeyboardRow([
                        _KeyData(label: '7', onTap: () => _onKeyPress('7')),
                        _KeyData(label: '8', onTap: () => _onKeyPress('8')),
                        _KeyData(label: '9', onTap: () => _onKeyPress('9')),
                        _KeyData(icon: Icons.backspace_outlined, onTap: _onDelete),
                      ]),
                      const SizedBox(height: 12),

                      // Baris 4: , , 0, . , ✓
                      _buildKeyboardRow([
                        _KeyData(label: ',', onTap: () {}),
                        _KeyData(label: '0', onTap: () => _onKeyPress('0')),
                        _KeyData(label: '.', onTap: () {}),
                        _KeyData(
                          icon: Icons.check_rounded,
                          onTap: _onSubmit,
                          isAction: true,
                        ),
                      ]),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildKeyboardRow(List<_KeyData> keys) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: keys.map((k) {
        return GestureDetector(
          onTap: k.onTap,
          child: Container(
            width: 78,
            height: 48,
            decoration: BoxDecoration(
              color: k.isAction ? const Color(0xFFD0D0D0) : keyBgColor,
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            alignment: Alignment.center,
            child: k.icon != null
                ? Icon(
                    k.icon,
                    size: 22,
                    color: keyTextColor,
                  )
                : Text(
                    k.label ?? '',
                    style: GoogleFonts.poppins(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                      color: keyTextColor,
                    ),
                  ),
          ),
        );
      }).toList(),
    );
  }
}

class _KeyData {
  final String? label;
  final IconData? icon;
  final VoidCallback onTap;
  final bool isAction;

  _KeyData({
    this.label,
    this.icon,
    required this.onTap,
    this.isAction = false,
  });
}

