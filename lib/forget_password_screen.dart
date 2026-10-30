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
  // Controller nomor handphone (dikosongkan secara default sesuai permintaan pengguna)
  final TextEditingController _phoneController = TextEditingController(text: '');

  // State keyboard numerik in-app
  bool isKeyboardOpen = false;

  // Kode Warna Presisi Figma Xema
  final Color primaryPurple = const Color(0xFFB952DD); // #B952DD Tombol Get OTP
  final Color textDarkPurple = const Color(0xFF52086B); // #52086B Judul Forget Password
  final Color textDescription = const Color(0xFF570374); // #570374 Teks instruksi
  final Color inputBorderColor = const Color(0xFFD9D9D9); // #D9D9D9 Border input
  final Color purpleBg50 = const Color(0x80CA31FF); // #CA31FF dengan 50% opacity (Figma Ellipse)

  void _onKeyPress(String val) {
    setState(() {
      _phoneController.text += val;
    });
  }

  void _onDelete() {
    setState(() {
      if (_phoneController.text.isNotEmpty) {
        _phoneController.text =
            _phoneController.text.substring(0, _phoneController.text.length - 1);
      }
    });
  }

  void _onCloseKeyboard() {
    setState(() {
      isKeyboardOpen = false;
    });
  }

  @override
  void dispose() {
    _phoneController.dispose();
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
            // Mengunci kanvas presisi 100% Figma node #60:14 (393 x 852)
            width: 393,
            height: 852,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                // =============================================================
                // 1. ELEMEN FIGMA: LENGKUNGAN UNGU KIRI ATAS (Ellipse 14)
                // Relatif Figma: x=-232, y=-248, w=541, h=544, Blur=4
                // =============================================================
                Positioned(
                  left: -232,
                  top: -248,
                  width: 541,
                  height: 544,
                  child: ImageFiltered(
                    imageFilter: ui.ImageFilter.blur(sigmaX: 4.0, sigmaY: 4.0),
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: purpleBg50,
                      ),
                    ),
                  ),
                ),

                // =============================================================
                // 2. ELEMEN FIGMA: LENGKUNGAN UNGU KANAN BAWAH (Ellipse 15)
                // Relatif Figma: x=49, y=708, w=594, h=619, Blur=4
                // =============================================================
                Positioned(
                  left: 49,
                  top: 708,
                  width: 594,
                  height: 619,
                  child: ImageFiltered(
                    imageFilter: ui.ImageFilter.blur(sigmaX: 4.0, sigmaY: 4.0),
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: purpleBg50,
                      ),
                    ),
                  ),
                ),

                // =============================================================
                // 3. HEADER: TOMBOL KEMBALI (<) DAN JUDUL "Forget Password"
                // Posisi presisi Figma: x=10, y=57
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
                        'Forget Password',
                        style: GoogleFonts.pochaevsk(
                          fontSize: 32,
                          fontWeight: FontWeight.normal,
                          color: textDarkPurple,
                          shadows: [
                            const BoxShadow(
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
                // 4. ILUSTRASI KARTUN TENGAH (Figma node #101:19)
                // =============================================================
                Positioned(
                  top: 135,
                  left: (393 - 330) / 2,
                  width: 330,
                  height: 250,
                  child: Image.asset(
                    'assets/images/forgot_password_illustration.png',
                    fit: BoxFit.contain,
                  ),
                ),

                // =============================================================
                // 5. TEKS DESKRIPSI (Figma node #60:18)
                // Posisi presisi: top=400, left=16, width=362
                // =============================================================
                Positioned(
                  top: 400,
                  left: 16,
                  width: 362,
                  child: Text(
                    'Please enter your phone number. We will send a code to your number to reset your password.',
                    style: GoogleFonts.rasa(
                      fontSize: 20,
                      height: 1.25,
                      fontWeight: FontWeight.normal,
                      color: textDescription,
                    ),
                  ),
                ),

                // =============================================================
                // 6. INPUT NOMOR HANDPHONE (Figma Rectangle 42, node #60:25)
                // Posisi presisi: top=482, left=18, width=357, height=61, radius=15
                // Dikosongkan sesuai permintaan user dan membuka keyboard numerik
                // =============================================================
                Positioned(
                  top: 482,
                  left: 18,
                  width: 357,
                  height: 61,
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        isKeyboardOpen = true;
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(
                          color: isKeyboardOpen
                              ? const Color(0xFFCA31FF)
                              : inputBorderColor,
                          width: isKeyboardOpen ? 1.8 : 1.2,
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
                            Icons.phone_outlined,
                            size: 24,
                            color: Color(0xFF1E1E1E),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Text(
                              _phoneController.text.isEmpty
                                  ? 'Phone number'
                                  : _phoneController.text,
                              style: GoogleFonts.pochaevsk(
                                fontSize: 18,
                                color: _phoneController.text.isEmpty
                                    ? const Color(0xFFB0B0B0)
                                    : const Color(0xFF1E1E1E),
                                fontWeight: FontWeight.normal,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // =============================================================
                // 7. TOMBOL "Get OTP" (Figma Rectangle 23 + Text, node #60:16)
                // Posisi presisi: top=619, left=36, width=326, height=55, radius=15
                // =============================================================
                Positioned(
                  top: 619,
                  left: 36,
                  width: 326,
                  height: 55,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const VerifyOtpScreen(),
                        ),
                      );
                    },
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
                      child: Center(
                        child: Text(
                          'Get OTP',
                          style: GoogleFonts.poppins(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                // =============================================================
                // 8. KEYBOARD NUMERIK IN-APP UNTUK MENGISI NOMOR HP
                // =============================================================
                if (isKeyboardOpen)
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Color(0xFFF8F5FA),
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(24)),
                        boxShadow: [
                          BoxShadow(
                            color: Color(0x29000000),
                            blurRadius: 12,
                            offset: Offset(0, -3),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 14),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Masukkan Nomor Telepon',
                                style: GoogleFonts.poppins(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: textDarkPurple,
                                ),
                              ),
                              GestureDetector(
                                onTap: _onCloseKeyboard,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFCA31FF),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    'Selesai',
                                    style: GoogleFonts.poppins(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          _buildKeyboardGrid(),
                          const SizedBox(height: 8),
                        ],
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

  // ============================================================================
  // GRID TOMBOL KEYBOARD NUMERIK (1 - 9, 0, Backspace)
  // ============================================================================
  Widget _buildKeyboardGrid() {
    final List<String> keys = [
      '1', '2', '3',
      '4', '5', '6',
      '7', '8', '9',
      '', '0', 'delete',
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 2.1,
        crossAxisSpacing: 10,
        mainAxisSpacing: 8,
      ),
      itemCount: keys.length,
      itemBuilder: (context, index) {
        final keyVal = keys[index];
        if (keyVal.isEmpty) {
          return const SizedBox.shrink();
        }
        if (keyVal == 'delete') {
          return Material(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            elevation: 2,
            shadowColor: const Color(0x1A000000),
            child: InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: _onDelete,
              child: const Center(
                child: Icon(
                  Icons.backspace_outlined,
                  size: 20,
                  color: Color(0xFF1E1E1E),
                ),
              ),
            ),
          );
        }

        return Material(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          elevation: 2,
          shadowColor: const Color(0x1A000000),
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: () => _onKeyPress(keyVal),
            child: Center(
              child: Text(
                keyVal,
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF1E1E1E),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
