import 'beranda_screen.dart';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'forget_password_screen.dart';
import 'signup_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _rememberMe = false;
  bool _obscurePassword = true;

  // Kode Warna Presisi Figma Xema
  final Color topPurple = const Color(0xFFB952DD); // #B952DD kubah atas
  final Color bottomPurple50 = const Color(0x80CA31FF); // #CA31FF dengan 50% opacity
  final Color inputBgColor = const Color(0xFFF3D8FF); // Fill kotak: #F3D8FF
  final Color strokeColor = const Color(0xFFCA31FF); // Border kotak: #CA31FF
  final Color textPurple = const Color(0xFF5A007A); // Warna judul Login
  final Color hintPurple = const Color(0xFFC730FF); // Warna teks hint/link

  // Style font Pochaevsk resmi dari Google Fonts
  TextStyle pochaevskFont({
    double fontSize = 20,
    FontWeight fontWeight = FontWeight.normal,
    Color? color,
  }) {
    return GoogleFonts.pochaevsk(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color ?? textPurple,
    );
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
                // 1. ELLIPSE KUBAH UNGU ATAS (#B952DD) DENGAN EFFECT LAYER BLUR FIGMA (BLUR: 4)
                // Figma: Ellipse X: -148, Y: -377, W: 478.1, H: 491.48, Rotation: 45.73°
                // Effects: Layer blur = 4 (Uniform)
                // =========================================================================
                Positioned.fill(
                  child: ImageFiltered(
                    imageFilter: ui.ImageFilter.blur(sigmaX: 2.0, sigmaY: 2.0),
                    child: CustomPaint(
                      painter: FigmaTopDomePainter(color: topPurple),
                    ),
                  ),
                ),

                // =========================================================================
                // 2. ELLIPSE UNGU BAWAH KIRI (#CA31FF, 50% Opacity) DENGAN EFFECT LAYER BLUR (BLUR: 4)
                // Bentuk lengkungan penuh, lebar, dan tinggi persis gambar asli Figma:
                // Tepi kiri di Y: 640, melengkung penuh hingga X: 220 di tepi bawah
                // =========================================================================
                Positioned(
                  left: -277,
                  top: 638,
                  width: 500,
                  height: 500,
                  child: ImageFiltered(
                    imageFilter: ui.ImageFilter.blur(sigmaX: 2.0, sigmaY: 2.0),
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: bottomPurple50,
                      ),
                    ),
                  ),
                ),

                // =========================================================================
                // 3. LOGO DOMPET & TULISAN "Xema" - TIDAK RATA / BERTINGKAT PERSIS FIGMA
                // Dompet berada di atas, tulisan Xema turun ke bawah sehingga
                // puncak huruf X sejajar dengan kancing dompet dan dasarnya lebih rendah
                // =========================================================================
                Positioned(
                  top: 72,
                  left: 96,
                  child: Image.asset(
                    'assets/images/logo_transparent.png',
                    width: 76,
                    height: 82,
                    fit: BoxFit.contain,
                  ),
                ),

                Positioned(
                  top: 124, // Puncak huruf X sejajar tepat dengan kancing dompet
                  left: 174, // Posisi rapat persis di samping kancing dompet
                  child: Text(
                    'Xema',
                    style: GoogleFonts.poppins(
                      fontSize: 40,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                      letterSpacing: 0.5,
                      shadows: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.25),
                          offset: const Offset(0, 3),
                          blurRadius: 4,
                        ),
                      ],
                    ),
                  ),
                ),

                // =========================================================================
                // 4. JUDUL "Login" (Font Pochaevsk Ukuran 32)
                // Letak: X: 48, Y: 275 (Figma Property)
                // =========================================================================
                Positioned(
                  top: 275,
                  left: 33.5,
                  child: Text(
                    'Login',
                    style: pochaevskFont(
                      fontSize: 32,
                      fontWeight: FontWeight.normal,
                      color: textPurple,
                    ),
                  ),
                ),

                // =========================================================================
                // 5. INPUT PHONE NUMBER (326 x 55, Radius 27.5, Font 20)
                // =========================================================================
                Positioned(
                  top: 330,
                  left: 33.5,
                  child: _buildFigmaInputField(
                    hintText: 'Phone number',
                    icon: Icons.phone_outlined,
                    keyboardType: TextInputType.phone,
                  ),
                ),

                // =========================================================================
                // 6. INPUT PASSWORD (326 x 55, Radius 27.5, Font 20)
                // =========================================================================
                Positioned(
                  top: 403,
                  left: 33.5,
                  child: _buildFigmaInputField(
                    hintText: 'Password',
                    icon: Icons.lock_outline_rounded,
                    isPassword: true,
                    obscureText: _obscurePassword,
                    onTogglePassword: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  ),
                ),

                // =========================================================================
                // 7. ROW: REMEMBER ME & FORGOT PASSWORD?
                // =========================================================================
                Positioned(
                  top: 473,
                  left: 33.5,
                  width: 326,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Checkbox Remember Me
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _rememberMe = !_rememberMe;
                          });
                        },
                        child: Row(
                          children: [
                            Container(
                              width: 20,
                              height: 20,
                              decoration: BoxDecoration(
                                color: _rememberMe ? strokeColor : Colors.transparent,
                                borderRadius: BorderRadius.circular(4),
                                border: Border.all(color: strokeColor, width: 1.5),
                              ),
                              child: _rememberMe
                                  ? const Icon(Icons.check, size: 14, color: Colors.white)
                                  : null,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Remember Me',
                              style: pochaevskFont(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: const Color(0xFF222222),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Link Forgot Pasword?
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const ForgetPasswordScreen(),
                            ),
                          );
                        },
                        child: Text(
                          'Forgot Pasword?',
                          style: pochaevskFont(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: strokeColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // =========================================================================
                // 8. TOMBOL "Log In" (326 x 55, Radius 27.5, Font 24 Bold)
                // =========================================================================
                Positioned(
                  top: 520,
                  left: 33.5,
                  child: Container(
                    width: 326,
                    height: 55,
                    decoration: BoxDecoration(
                      color: inputBgColor,
                      borderRadius: BorderRadius.circular(27.5),
                      border: Border.all(color: strokeColor, width: 1.2),
                      boxShadow: [
                        BoxShadow(
                          color: strokeColor.withValues(alpha: 0.38),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(27.5),
                        onTap: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (_) => const BerandaScreen()),
                          );
                        },
                        child: Center(
                          child: Text(
                            'Log In',
                            style: pochaevskFont(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF3A0054),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                // =========================================================================
                // 9. TEKS BAWAH: "Don't have an account? Sign up"
                // =========================================================================
                Positioned(
                  top: 595,
                  left: 33.5,
                  width: 326,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Don't have an account? ",
                        style: pochaevskFont(
                          fontSize: 16,
                          color: const Color(0xFF333333),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const SignUpScreen()),
                          );
                        },
                        child: Text(
                          'Sign up',
                          style: pochaevskFont(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: strokeColor,
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
      ),
    );
  }

  // WIDGET INPUT FIELD FIGMA: 326 x 55 DENGAN RADIUS 27.5, FILL #F3D8FF, GLOW UNGU
  Widget _buildFigmaInputField({
    required String hintText,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    bool isPassword = false,
    bool obscureText = false,
    VoidCallback? onTogglePassword,
  }) {
    return Container(
      width: 326,
      height: 55,
      decoration: BoxDecoration(
        color: inputBgColor, // Fill: #F3D8FF
        borderRadius: BorderRadius.circular(27.5), // Pill radius 27.5
        border: Border.all(color: strokeColor, width: 1.2), // Stroke: #CA31FF
        boxShadow: [
          BoxShadow(
            color: strokeColor.withValues(alpha: 0.35),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Center(
        child: TextField(
          keyboardType: keyboardType,
          obscureText: obscureText,
          style: pochaevskFont(fontSize: 20, color: textPurple),
          decoration: InputDecoration(
            isDense: true,
            hintText: hintText,
            hintStyle: pochaevskFont(
              fontSize: 20,
              color: hintPurple,
            ),
            prefixIcon: Padding(
              padding: const EdgeInsets.only(left: 14, right: 8),
              child: Icon(icon, color: const Color(0xFF222222), size: 22),
            ),
            prefixIconConstraints: const BoxConstraints(minWidth: 44, minHeight: 24),
            suffixIcon: isPassword
                ? Padding(
                    padding: const EdgeInsets.only(right: 14),
                    child: IconButton(
                      icon: Icon(
                        obscureText ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                        color: const Color(0xFF222222),
                        size: 22,
                      ),
                      onPressed: onTogglePassword,
                    ),
                  )
                : null,
            suffixIconConstraints: const BoxConstraints(minWidth: 44, minHeight: 24),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
        ),
      ),
    );
  }
}

// PAINTER UNTUK ELLIPSE KUBAH UNGU ATAS (#B952DD) - LENGKUNGAN LINGKARAN MURNI FIGMA
class FigmaTopDomePainter extends CustomPainter {
  final Color color;
  FigmaTopDomePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    // Busur lingkaran murni persis Ellipse 13 di Figma (Radius: 240)
    // Tepi kiri/kanan di Y: 148, Puncak lengkungan tengah turun ke Y: 250
    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(0, 148)
      ..arcToPoint(
        const Offset(393, 148),
        radius: const Radius.circular(240),
        clockwise: false,
      )
      ..lineTo(393, 0)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}


