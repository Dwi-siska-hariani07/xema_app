import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'login_screen.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _rePasswordController = TextEditingController();

  bool _isNewPasswordObscured = true;
  bool _isRePasswordObscured = true;

  // Status popup modal dialog "Reset Success"
  bool _showSuccessPopup = false;

  // Warna Presisi Sesuai Figma
  final Color primaryPurple = const Color(0xFFB952DD); // #B952DD Tombol Reset
  final Color textDarkPurple = const Color(0xFF1E1E1E); // Warna icon back arrow hitam presisi Figma
  final Color inputBorderColor = const Color(0xFFD9D9D9); // #D9D9D9 Border input

  @override
  void dispose() {
    _newPasswordController.dispose();
    _rePasswordController.dispose();
    super.dispose();
  }

  void _onResetPressed() {
    setState(() {
      _showSuccessPopup = true;
    });
  }

  void _onClosePopup() {
    setState(() {
      _showSuccessPopup = false;
    });
    // Setelah sukses, arahkan kembali ke LoginScreen
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
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
                // 1. ELEMEN FIGMA ASLI: LENGKUNGAN UNGU KANAN ATAS (PERSIS 1:1 DARI FIGMA)
                // Diekstrak langsung dari artboard Figma tanpa blur tiruan
                // =============================================================
                Positioned(
                  top: 0,
                  right: 0,
                  width: 221,
                  height: 158,
                  child: Image.asset(
                    'assets/images/figma_reset_top_right_exact.png',
                    fit: BoxFit.fill,
                  ),
                ),

                // =============================================================
                // 2. ELEMEN FIGMA ASLI: LENGKUNGAN UNGU KIRI BAWAH (PERSIS 1:1 DARI FIGMA)
                // Diekstrak langsung dari artboard Figma tanpa blur tiruan
                // =============================================================
                Positioned(
                  bottom: 0,
                  left: 0,
                  width: 265,
                  height: 136,
                  child: Image.asset(
                    'assets/images/figma_reset_bot_left_exact.png',
                    fit: BoxFit.fill,
                  ),
                ),

                // =============================================================
                // 3. HEADER: TOMBOL KEMBALI (<)
                // Posisi persis Figma referensi: top=63, left=18
                // =============================================================
                Positioned(
                  top: 63,
                  left: 18,
                  child: GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: 36,
                      height: 36,
                      color: Colors.transparent,
                      alignment: Alignment.centerLeft,
                      child: const Icon(
                        Icons.arrow_back_ios_new_rounded,
                        size: 22,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),

                // =============================================================
                // 4. ILUSTRASI KOMPUTER FIGMA (LAYAR UNGU, GEMBOK TERBUKA, BINTANG PASSWORD)
                // Diekstrak langsung dari potongan gambar Figma yang dikirim pengguna
                // =============================================================
                Positioned(
                  top: 175,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Image.asset(
                      'assets/images/figma_user_exact_computer_illustration.png',
                      width: 220,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),

                // =============================================================
                // 5. TEKS PETUNJUK: "Use at least 6 characters strong password"
                // =============================================================
                Positioned(
                  top: 382,
                  left: 20,
                  right: 20,
                  child: Text(
                    'Use at least 6 characters strong password',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.rasa(
                      fontSize: 18,
                      height: 1.25,
                      fontWeight: FontWeight.normal,
                      color: const Color(0xFF222222),
                    ),
                  ),
                ),

                // =============================================================
                // 6. INPUT 1: "Enter new password"
                // =============================================================
                Positioned(
                  top: 440,
                  left: 18,
                  width: 357,
                  height: 58,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(
                        color: inputBorderColor,
                        width: 1.2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.04),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 18),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.lock_outline_rounded,
                          size: 22,
                          color: Color(0xFF444444),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: TextField(
                            controller: _newPasswordController,
                            obscureText: _isNewPasswordObscured,
                            style: GoogleFonts.rasa(
                              fontSize: 18,
                              color: const Color(0xFF1E1E1E),
                            ),
                            decoration: InputDecoration(
                              hintText: 'Enter new password',
                              hintStyle: GoogleFonts.rasa(
                                fontSize: 18,
                                color: const Color(0xFF757575),
                              ),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.zero,
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _isNewPasswordObscured = !_isNewPasswordObscured;
                            });
                          },
                          child: Icon(
                            _isNewPasswordObscured
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                            size: 22,
                            color: const Color(0xFF555555),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // =============================================================
                // 7. INPUT 2: "Re enter password"
                // =============================================================
                Positioned(
                  top: 525,
                  left: 18,
                  width: 357,
                  height: 58,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(
                        color: inputBorderColor,
                        width: 1.2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.04),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 18),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.lock_outline_rounded,
                          size: 22,
                          color: Color(0xFF444444),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: TextField(
                            controller: _rePasswordController,
                            obscureText: _isRePasswordObscured,
                            style: GoogleFonts.rasa(
                              fontSize: 18,
                              color: const Color(0xFF1E1E1E),
                            ),
                            decoration: InputDecoration(
                              hintText: 'Re enter password',
                              hintStyle: GoogleFonts.rasa(
                                fontSize: 18,
                                color: const Color(0xFF757575),
                              ),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.zero,
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _isRePasswordObscured = !_isRePasswordObscured;
                            });
                          },
                          child: Icon(
                            _isRePasswordObscured
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                            size: 22,
                            color: const Color(0xFF555555),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // =============================================================
                // 8. TOMBOL "Reset" (Figma Solid Purple #B952DD)
                // =============================================================
                Positioned(
                  top: 618,
                  left: 36,
                  width: 326,
                  height: 55,
                  child: GestureDetector(
                    onTap: _onResetPressed,
                    child: Container(
                      decoration: BoxDecoration(
                        color: primaryPurple,
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(
                          color: const Color(0xFF1C0823),
                          width: 1.0,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: primaryPurple.withValues(alpha: 0.40),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        'Reset',
                        style: GoogleFonts.poppins(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),

                // =============================================================
                // 9. ELEMEN MODAL POPUP: "Reset Successfull"
                // =============================================================
                if (_showSuccessPopup) ...[
                  // Dimmed overlay backdrop
                  Positioned.fill(
                    child: GestureDetector(
                      onTap: _onClosePopup,
                      child: Container(
                        color: Colors.black.withValues(alpha: 0.35),
                      ),
                    ),
                  ),

                  // Popup Dialog Card
                  Positioned(
                    top: 290,
                    left: (393 - 265) / 2,
                    width: 265,
                    height: 250,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.18),
                            blurRadius: 20,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Stack(
                        children: [
                          // Tombol Close (x) kecil di sudut kanan atas
                          Positioned(
                            top: 12,
                            right: 14,
                            child: GestureDetector(
                              onTap: _onClosePopup,
                              child: const Icon(
                                Icons.close_rounded,
                                size: 20,
                                color: Color(0xFF555555),
                              ),
                            ),
                          ),

                          // Konten Modal: Lingkaran Centang Ungu + Teks "Reset Successfull"
                          Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                GestureDetector(
                                  onTap: _onClosePopup,
                                  child: Container(
                                    width: 76,
                                    height: 76,
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Color(0xFFB952DD),
                                    ),
                                    child: const Icon(
                                      Icons.check_rounded,
                                      size: 48,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 24),
                                Text(
                                  'Reset Successfull',
                                  style: GoogleFonts.poppins(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
