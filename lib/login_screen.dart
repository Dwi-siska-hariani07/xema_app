import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'beranda_screen.dart';
import 'forget_password_screen.dart';
import 'signup_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // Controller input
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // State keyboard numerik in-app
  bool isKeyboardOpen = false;
  String activeField = '';

  // Toggle visibilitas sandi (default tertutup sesuai Figma)
  bool isPasswordHidden = true;
  bool rememberMe = false;

  // Kode Warna Presisi Figma Xema
  final Color inputBgColor = const Color(0xFFF3D8FF); // Fill kotak #F3D8FF
  final Color strokeColor = const Color(0xFFCA31FF); // Border kotak #CA31FF
  final Color textPurple = const Color(0xFF772096); // Judul Login #772096
  final Color hintPurple = const Color(0xFFCA31FF); // Teks placeholder #CA31FF
  final Color darkText = const Color(0xFF570374); // Remember Me & teks utama #570374

  void _onKeyPress(String val) {
    setState(() {
      if (activeField == 'phone') {
        _phoneController.text += val;
      } else if (activeField == 'password') {
        _passwordController.text += val;
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
      }
    });
  }

  void _onCloseKeyboard() {
    setState(() {
      isKeyboardOpen = false;
      activeField = '';
    });
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _passwordController.dispose();
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
            // Mengunci kanvas presisi 100% Figma node #30:18 (393 x 852)
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
                  height: 210,
                  child: Image.asset(
                    'assets/images/figma_login_top_dome.png',
                    fit: BoxFit.fill,
                  ),
                ),

                // =============================================================
                // 1B. ELEMEN FIGMA: LENGKUNGAN UNGU BAWAH (Kiri Bawah)
                // Diekstrak persis dari Figma
                // =============================================================
                Positioned(
                  bottom: 0,
                  left: 0,
                  width: 230,
                  height: 130,
                  child: Image.asset(
                    'assets/images/figma_login_bottom_curve.png',
                    fit: BoxFit.fill,
                  ),
                ),

                // =============================================================
                // 2. JUDUL: "Login" (Figma node #30:30)
                // Posisi presisi Figma: top: 275, left: 48
                // Font: Pochaevsk 32, Warna: #772096
                // =============================================================
                Positioned(
                  top: 275,
                  left: 48,
                  child: Text(
                    'Login',
                    style: GoogleFonts.pochaevsk(
                      fontSize: 32,
                      fontWeight: FontWeight.normal,
                      color: textPurple,
                    ),
                  ),
                ),

                // =============================================================
                // 3. KOTAK 1: Phone number (Figma Rectangle 20, node #30:31)
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
                // 4. KOTAK 2: Password (Figma Rectangle 21, node #30:33)
                // Posisi presisi Figma: top: 436, width: 326, height: 55, radius: 25
                // =============================================================
                Positioned(
                  top: 436,
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
                // 5. ROW: Remember Me & Forgot Pasword? (Figma nodes #30:35..38)
                // Posisi presisi Figma: top: 523
                // =============================================================
                Positioned(
                  top: 523,
                  left: (393 - 326) / 2 + 5,
                  right: (393 - 326) / 2 + 5,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Remember Me
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            rememberMe = !rememberMe;
                          });
                        },
                        child: Row(
                          children: [
                            Container(
                              width: 24,
                              height: 24,
                              decoration: BoxDecoration(
                                color: const Color(0xFFFDD3FF),
                                borderRadius: BorderRadius.circular(4),
                                border: Border.all(
                                  color: const Color(0xFF9B1DC7),
                                  width: 1.2,
                                ),
                              ),
                              child: rememberMe
                                  ? const Icon(
                                      Icons.check,
                                      size: 18,
                                      color: Color(0xFF570374),
                                    )
                                  : null,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Remember Me',
                              style: GoogleFonts.rasa(
                                fontSize: 18,
                                color: darkText,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Forgot Pasword?
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const ForgetPasswordScreen(),
                            ),
                          );
                        },
                        child: Text(
                          'Forgot Pasword?',
                          style: GoogleFonts.rasa(
                            fontSize: 18,
                            color: hintPurple,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // =============================================================
                // 6. TOMBOL: Log In (Figma Rectangle 23 + Text, node #30:43)
                // Posisi presisi Figma: top: 592, width: 326, height: 55, radius: 25
                // =============================================================
                Positioned(
                  top: 592,
                  left: (393 - 326) / 2,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const BerandaScreen(),
                        ),
                      );
                    },
                    child: Container(
                      width: 326,
                      height: 55,
                      decoration: BoxDecoration(
                        color: inputBgColor,
                        borderRadius: BorderRadius.circular(25),
                        border: Border.all(
                          color: strokeColor,
                          width: 1.0,
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
                        child: Text(
                          'Log In',
                          style: GoogleFonts.poppins(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: darkText,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                // =============================================================
                // 7. FOOTER: "Don’t have an account? Sign up" (Figma nodes #30:53, #40:112)
                // Posisi presisi Figma: top: 679
                // =============================================================
                Positioned(
                  top: 679,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Don’t have an account? ',
                          style: GoogleFonts.pochaevsk(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: darkText,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const SignUpScreen(),
                              ),
                            );
                          },
                          child: Text(
                            'Sign up',
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
                // 8. KEYBOARD NUMERIK IN-APP
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
                                    : 'Masukkan Kata Sandi',
                                style: GoogleFonts.poppins(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: darkText,
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
                  color: controller.text.isEmpty ? hintPurple : darkText,
                  fontWeight: FontWeight.normal,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (isPassword && onToggleObscure != null)
              GestureDetector(
                onTap: onToggleObscure,
                child: Padding(
                  padding: const EdgeInsets.only(left: 8.0),
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
              ),
          ],
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

// ============================================================================
// CUSTOM PAINTER: Ikon Mata Tertutup Tidur (Vector Asli Figma #302:135)
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
