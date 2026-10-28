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
  bool _rememberMe = false;
  bool _obscurePassword = true;

  // Kode Warna Presisi Figma Xema
  final Color topPurple = const Color(0xFFB952DD); // #B952DD kubah atas
  final Color bottomPurple50 = const Color(0x80CA31FF); // #CA31FF dengan 50% opacity
  final Color inputBgColor = const Color(0xFFF3D8FF); // Fill kotak: #F3D8FF
  final Color strokeColor = const Color(0xFFCA31FF); // Border kotak: #CA31FF
  final Color textPurple = const Color(0xFF5A007A); // Warna judul Login
  final Color hintPurple = const Color(0xFFC730FF); // Warna teks hint/link

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
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SizedBox(
        width: size.width,
        height: size.height,
        child: Stack(
          children: [
            // =========================================================================
            // 1. ELEMEN UNGU LENGKUNGAN KIRI BAWAH (#CA31FF, 50% Opacity)
            // Menempel tepat di pojok kiri bawah layar tanpa celah putih gantung
            // =========================================================================
            Positioned(
              left: -180,
              bottom: -140,
              width: 440,
              height: 440,
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: bottomPurple50,
                ),
              ),
            ),

            // =========================================================================
            // 2. KUBAH UNGU ATAS (#B952DD) - Menutupi status bar penuh ke atas
            // =========================================================================
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              height: 250,
              child: CustomPaint(
                painter: _TopDomePainter(color: topPurple),
              ),
            ),

            // =========================================================================
            // 3. LOGO & TEKS XEMA DI DALAM KUBAH ATAS
            // =========================================================================
            Positioned(
              top: 50,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/logo_transparent.png',
                    width: 72,
                    height: 72,
                    fit: BoxFit.contain,
                    errorBuilder: (_, __, ___) => Image.asset(
                      'assets/images/logo.png',
                      width: 65,
                      height: 65,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Xema',
                    style: GoogleFonts.poppins(
                      fontSize: 38,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      shadows: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.25),
                          offset: const Offset(0, 3),
                          blurRadius: 4,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // =========================================================================
            // 4. FORMULIR LOGIN DI TENGAH (Responsif, Rapi, Jarak Pas)
            // =========================================================================
            Positioned.fill(
              top: 255,
              bottom: 40,
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Judul "Login"
                    Text(
                      'Login',
                      style: pochaevskFont(
                        fontSize: 32,
                        fontWeight: FontWeight.normal,
                        color: textPurple,
                      ),
                    ),
                    const SizedBox(height: 22),

                    // Input Phone number
                    _buildInputField(
                      hintText: 'Phone number',
                      icon: Icons.phone_outlined,
                      keyboardType: TextInputType.phone,
                    ),
                    const SizedBox(height: 18),

                    // Input Password
                    _buildInputField(
                      hintText: 'Password',
                      icon: Icons.lock_outline,
                      isPassword: true,
                      obscureText: _obscurePassword,
                      onTogglePassword: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    ),
                    const SizedBox(height: 14),

                    // Remember Me & Forgot Password
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  _rememberMe = !_rememberMe;
                                });
                              },
                              child: Container(
                                width: 22,
                                height: 22,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFDD3FF),
                                  borderRadius: BorderRadius.circular(6),
                                  border: Border.all(color: const Color(0xFFB93FD1), width: 1.2),
                                ),
                                child: _rememberMe
                                    ? const Icon(Icons.check, size: 16, color: Color(0xFF570374))
                                    : null,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Remember Me',
                              style: pochaevskFont(
                                fontSize: 13,
                                color: const Color(0xFF570374),
                              ),
                            ),
                          ],
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => const ForgetPasswordScreen()),
                            );
                          },
                          child: Text(
                            'Forgot Password?',
                            style: pochaevskFont(
                              fontSize: 13,
                              color: const Color(0xFFCA31FF),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 28),

                    // Tombol "Log In"
                    Container(
                      width: double.infinity,
                      height: 54,
                      decoration: BoxDecoration(
                        color: inputBgColor,
                        borderRadius: BorderRadius.circular(27),
                        border: Border.all(color: strokeColor, width: 1.2),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF772096).withValues(alpha: 0.3),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(27),
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
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFF570374),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Don't have an account? Sign up
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Don't have an account? ",
                          style: pochaevskFont(
                            fontSize: 14,
                            color: const Color(0xFF570374),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => const SignUpScreen()),
                            );
                          },
                          child: Text(
                            'Sign up',
                            style: pochaevskFont(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFFCA31FF),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField({
    required String hintText,
    required IconData icon,
    bool isPassword = false,
    bool obscureText = false,
    VoidCallback? onTogglePassword,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Container(
      width: double.infinity,
      height: 54,
      decoration: BoxDecoration(
        color: inputBgColor,
        borderRadius: BorderRadius.circular(27),
        border: Border.all(color: strokeColor, width: 1.2),
        boxShadow: [
          BoxShadow(
            color: strokeColor.withValues(alpha: 0.25),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Center(
        child: TextField(
          keyboardType: keyboardType,
          obscureText: obscureText,
          style: pochaevskFont(fontSize: 17, color: textPurple),
          decoration: InputDecoration(
            isDense: true,
            hintText: hintText,
            hintStyle: pochaevskFont(
              fontSize: 17,
              color: hintPurple,
            ),
            prefixIcon: Padding(
              padding: const EdgeInsets.only(left: 16, right: 10),
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

// PAINTER UNTUK KUBAH LENGKUNGAN UNGU ATAS (#B952DD) PENUH
class _TopDomePainter extends CustomPainter {
  final Color color;
  _TopDomePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path();
    path.moveTo(0, 0);
    path.lineTo(0, size.height * 0.72);
    path.quadraticBezierTo(
      size.width / 2,
      size.height * 1.15,
      size.width,
      size.height * 0.72,
    );
    path.lineTo(size.width, 0);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
