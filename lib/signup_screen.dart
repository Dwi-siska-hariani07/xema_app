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
  // Controller input
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _rePasswordController = TextEditingController();

  // State keyboard numerik in-app
  bool isKeyboardOpen = false;
  String activeField = '';

  // Toggle visibilitas sandi (default tertutup sesuai Figma)
  bool isPasswordHidden = true;
  bool isRePasswordHidden = true;

  // Kode Warna Presisi Figma Xema
  final Color inputBgColor = const Color(0xFFF3D8FF); // Fill kotak #F3D8FF
  final Color strokeColor = const Color(0xFFCA31FF); // Border kotak #CA31FF
  final Color textPurple = const Color(0xFF570374); // Judul Sign up #570374
  final Color hintPurple = const Color(0xFFCA31FF); // Teks placeholder #CA31FF

  void _onKeyPress(String val) {
    setState(() {
      if (activeField == 'phone') {
        _phoneController.text += val;
      } else if (activeField == 'password') {
        _passwordController.text += val;
      } else if (activeField == 'rePassword') {
        _rePasswordController.text += val;
      }
    });
  }

  void _onDelete() {
    setState(() {
      if (activeField == 'phone' && _phoneController.text.isNotEmpty) {
        _phoneController.text =
            _phoneController.text.substring(0, _phoneController.text.length - 1);
      } else if (activeField == 'password' && _passwordController.text.isNotEmpty) {
        _passwordController.text =
            _passwordController.text.substring(0, _passwordController.text.length - 1);
      } else if (activeField == 'rePassword' && _rePasswordController.text.isNotEmpty) {
        _rePasswordController.text =
            _rePasswordController.text.substring(0, _rePasswordController.text.length - 1);
      }
    });
  }

  void _onCloseKeyboard() {
    // Jika sedang mengisi rePassword (password kedua), langsung arahkan ke Verify OTP (Figma node #302-304)
    if (activeField == 'rePassword') {
      setState(() {
        isKeyboardOpen = false;
        activeField = '';
      });
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const SignupVerifyOtpScreen(),
        ),
      );
      return;
    }

    setState(() {
      isKeyboardOpen = false;
      activeField = '';
    });
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _passwordController.dispose();
    _rePasswordController.dispose();
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
            // Mengunci kanvas presisi 100% Figma node #40:114 (393 x 852)
            width: 393,
            height: 852,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                // =============================================================
                // 1. ELEMEN FIGMA: KUBAH ATAS (Logo & Xema)
                // =============================================================
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  height: 203,
                  child: Image.asset(
                    'assets/images/figma_top_dome.png',
                    fit: BoxFit.fill,
                  ),
                ),

                // =============================================================
                // 1B. ELEMEN FIGMA: LENGKUNGAN UNGU BAWAH (Kiri Bawah)
                // Diekstrak persis dari Figma tanpa teks bawaan
                // =============================================================
                Positioned(
                  bottom: 0,
                  left: 0,
                  width: 254,
                  height: 131,
                  child: Image.asset(
                    'assets/images/figma_bottom_curve.png',
                    fit: BoxFit.fill,
                  ),
                ),

                // =============================================================
                // 2. JUDUL: "Sign up" (Figma node #40:120)
                // Posisi presisi Figma: top: 275, left: 48
                // Font: Pochaevsk 32, Warna: #570374
                // =============================================================
                Positioned(
                  top: 275,
                  left: 48,
                  child: Text(
                    'Sign up',
                    style: GoogleFonts.pochaevsk(
                      fontSize: 32,
                      fontWeight: FontWeight.normal,
                      color: textPurple,
                    ),
                  ),
                ),

                // =============================================================
                // 3. KOTAK 1: Phone number (Figma Group #391:536)
                // Posisi presisi Figma: top: 340, width: 326, height: 55, radius: 25
                // =============================================================
                Positioned(
                  top: 340,
                  left: (393 - 326) / 2,
                  child: _buildInputField(
                    icon: Icons.phone_outlined,
                    hint: 'Phone number',
                    controller: _phoneController,
                    fieldKey: 'phone',
                  ),
                ),

                // =============================================================
                // 4. KOTAK 2: Password (Figma Group #391:535)
                // Posisi presisi Figma: top: 423, width: 326, height: 55, radius: 25
                // =============================================================
                Positioned(
                  top: 423,
                  left: (393 - 326) / 2,
                  child: _buildInputField(
                    icon: Icons.lock_outline,
                    hint: 'Password',
                    controller: _passwordController,
                    fieldKey: 'password',
                    isPassword: true,
                    isObscured: isPasswordHidden,
                    onToggleObscure: () {
                      setState(() {
                        isPasswordHidden = !isPasswordHidden;
                      });
                    },
                  ),
                ),

                // =============================================================
                // 5. KOTAK 3: Re enter password (Figma Group #391:534)
                // Posisi presisi Figma: top: 506, width: 326, height: 55, radius: 25
                // =============================================================
                Positioned(
                  top: 506,
                  left: (393 - 326) / 2,
                  child: _buildInputField(
                    icon: Icons.lock_outline,
                    hint: 'Re enter password',
                    controller: _rePasswordController,
                    fieldKey: 'rePassword',
                    isPassword: true,
                    isObscured: isRePasswordHidden,
                    onToggleObscure: () {
                      setState(() {
                        isRePasswordHidden = !isRePasswordHidden;
                      });
                    },
                  ),
                ),

                // =============================================================
                // 6. FOOTER: "Already have an account? Log in" (Group #391:537)
                // Posisi persis Figma referensi (top: 672, di atas lengkungan ungu)
                // =============================================================
                Positioned(
                  top: 672,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Row(
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
                              color: hintPurple,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // =============================================================
                // 8. KEYBOARD NUMERIK IN-APP (Muncul saat kolom input diklik)
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
                                activeField == 'phone'
                                    ? 'Masukkan Nomor Telepon'
                                    : (activeField == 'password'
                                        ? 'Masukkan Kata Sandi'
                                        : 'Ulangi Kata Sandi'),
                                style: GoogleFonts.poppins(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: textPurple,
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
  // WIDGET KOTAK INPUT (Figma EL-326ed6de: Fill #F3D8FF, Stroke #CA31FF, Radius 25)
  // Glow Shadow Ungu Asli Figma: rgba(119, 32, 150, 0.35)
  // ============================================================================
  Widget _buildInputField({
    required IconData icon,
    required String hint,
    required TextEditingController controller,
    required String fieldKey,
    bool isPassword = false,
    bool isObscured = true,
    VoidCallback? onToggleObscure,
  }) {
    final bool isActive = activeField == fieldKey;

    return GestureDetector(
      onTap: () {
        setState(() {
          isKeyboardOpen = true;
          activeField = fieldKey;
        });
      },
      child: Container(
        width: 326,
        height: 55,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: inputBgColor,
          borderRadius: BorderRadius.circular(25),
          border: Border.all(
            color: strokeColor,
            width: isActive ? 2.0 : 1.0,
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
              color: const Color(0xFF1E1E1E),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                controller.text.isEmpty
                    ? hint
                    : (isPassword && isObscured
                        ? '●' * controller.text.length
                        : controller.text),
                style: GoogleFonts.rasa(
                  fontSize: 22,
                  fontWeight: FontWeight.normal,
                  color: controller.text.isEmpty
                      ? hintPurple.withValues(alpha: 0.8)
                      : textPurple,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (isPassword)
              GestureDetector(
                onTap: onToggleObscure,
                child: SizedBox(
                  width: 24,
                  height: 14,
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
      ),
    );
  }

  // ============================================================================
  // GRID KEYBOARD NUMERIK
  // ============================================================================
  Widget _buildKeyboardGrid() {
    final keys = [
      ['1', '2', '3'],
      ['4', '5', '6'],
      ['7', '8', '9'],
      ['', '0', 'del'],
    ];

    return Column(
      children: keys.map((row) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: row.map((key) {
              if (key.isEmpty) {
                return const Expanded(child: SizedBox());
              }
              Widget child;
              if (key == 'del') {
                child = const Icon(
                  Icons.backspace_outlined,
                  size: 20,
                  color: Color(0xFF1E1E1E),
                );
              } else {
                child = Text(
                  key,
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF1E1E1E),
                  ),
                );
              }
              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5.0),
                  child: InkWell(
                    onTap: () {
                      if (key == 'del') {
                        _onDelete();
                      } else {
                        _onKeyPress(key);
                      }
                    },
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      height: 48,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x14000000),
                            blurRadius: 3,
                            offset: Offset(0, 1),
                          ),
                        ],
                      ),
                      alignment: Alignment.center,
                      child: child,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        );
      }).toList(),
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
