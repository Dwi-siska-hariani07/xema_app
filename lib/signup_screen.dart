import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'login_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  // State input
  String phoneNumber = '';
  String password = '';
  String rePassword = '';

  // State keyboard & input aktif
  bool isKeyboardOpen = false;
  String activeField = '';

  // Toggle visibilitas sandi
  bool isPasswordHidden = true;
  bool isRePasswordHidden = true;

  void _onKeyPress(String val) {
    setState(() {
      if (activeField == 'phone') {
        phoneNumber += val;
      } else if (activeField == 'password') {
        password += val;
      } else if (activeField == 'rePassword') {
        rePassword += val;
      }
    });
  }

  void _onDelete() {
    setState(() {
      if (activeField == 'phone' && phoneNumber.isNotEmpty) {
        phoneNumber = phoneNumber.substring(0, phoneNumber.length - 1);
      } else if (activeField == 'password' && password.isNotEmpty) {
        password = password.substring(0, password.length - 1);
      } else if (activeField == 'rePassword' && rePassword.isNotEmpty) {
        rePassword = rePassword.substring(0, rePassword.length - 1);
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
  Widget build(BuildContext context) {
    // Mengunci resolusi kanvas presisi Figma 393 x 852 (Pixel-Perfect)
    const scaleY = 1.0;
    const scaleX = 1.0;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: FittedBox(
          fit: BoxFit.contain,
          child: SizedBox(
            width: 393,
            height: 852,
            child: Stack(
          clipBehavior: Clip.none,
          children: [
            // ============================================================
            // 1. ELEMEN BULAT KIRI BAWAH (Ellipse 13 Asli Figma)
            // Kurva melengkung luas dari Y ≈ 655 hingga X ≈ 235 di dasar layar
            // Fill: #CA31FF, Opacity: 50%
            // ============================================================
            Positioned(
              bottom: 0,
              left: 0,
              width: 250 * scaleX,
              height: 197 * scaleY,
              child: CustomPaint(
                painter: _BottomEllipsePainter(),
              ),
            ),

            // ============================================================
            // 2. HEADER LENGKUNG ATAS (Ellipse 8 Asli Figma)
            // X: -23, Y: -218, W: 419.82, H: 448.01, Rotasi: 87.88°
            // Fill: #B952DD 100%
            // ============================================================
            Positioned(
              top: -218 * scaleY,
              left: -23 * scaleX,
              width: 419.82 * scaleX,
              height: 448.01 * scaleY,
              child: Transform.rotate(
                angle: 87.88 * math.pi / 180,
                child: CustomPaint(
                  painter: _HeaderEllipsePainter(),
                ),
              ),
            ),

            // ============================================================
            // 3. LOGO ASLI FIGMA ([Dompet] Xema dari logo.png 330x247)
            // Posisi Presisi Figma: Left: 12, Top: -36 (Puncak Logo di Y ≈ 72, X ≈ 110)
            // ============================================================
            Positioned(
              top: -36 * scaleY,
              left: 12 * scaleX,
              width: 330 * scaleX,
              height: 247 * scaleY,
              child: IgnorePointer(
                child: Image.asset(
                  'assets/images/logo.png',
                  fit: BoxFit.contain,
                ),
              ),
            ),

            // ============================================================
            // 4. JUDUL: Sign up (Posisi X: 48, Y: 275, Ukuran 32, Triodion)
            // ============================================================
            Positioned(
              top: 275 * scaleY,
              left: 48 * scaleX,
              child: Text(
                'Sign up',
                style: GoogleFonts.triodion(
                  fontSize: 32 * scaleY,
                  fontWeight: FontWeight.normal,
                  color: const Color(0xFF570374),
                ),
              ),
            ),

            // ============================================================
            // 5. TIGA KOTAK FORMULIR INPUT (W: 328, H: 55, Radius: 25)
            // Fill: #F3D8FF, Stroke: #CA31FF, Font: Rasa 24, #CA31FF
            // ============================================================

            // Kotak 1: Phone number (Y = 340)
            Positioned(
              top: 340 * scaleY,
              left: 36 * scaleX,
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    isKeyboardOpen = true;
                    activeField = 'phone';
                  });
                },
                child: _buildInputField(
                  scaleY: scaleY,
                  scaleX: scaleX,
                  icon: Icons.phone_outlined,
                  hint: 'Phone number',
                  value: phoneNumber,
                  isActive: activeField == 'phone',
                ),
              ),
            ),

            // Kotak 2: Password (Y = 423)
            Positioned(
              top: 423 * scaleY,
              left: 36 * scaleX,
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    isKeyboardOpen = true;
                    activeField = 'password';
                  });
                },
                child: _buildInputField(
                  scaleY: scaleY,
                  scaleX: scaleX,
                  icon: Icons.lock_outline,
                  hint: 'Password',
                  value: password,
                  isPassword: true,
                  isObscured: isPasswordHidden,
                  onToggleObscure: () {
                    setState(() {
                      isPasswordHidden = !isPasswordHidden;
                    });
                  },
                  isActive: activeField == 'password',
                ),
              ),
            ),

            // Kotak 3: Re enter password (Y = 506)
            Positioned(
              top: 506 * scaleY,
              left: 36 * scaleX,
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    isKeyboardOpen = true;
                    activeField = 'rePassword';
                  });
                },
                child: _buildInputField(
                  scaleY: scaleY,
                  scaleX: scaleX,
                  icon: Icons.lock_outline,
                  hint: 'Re enter password',
                  value: rePassword,
                  isPassword: true,
                  isObscured: isRePasswordHidden,
                  onToggleObscure: () {
                    setState(() {
                      isRePasswordHidden = !isRePasswordHidden;
                    });
                  },
                  isActive: activeField == 'rePassword',
                ),
              ),
            ),

            // ============================================================
            // 6. TOMBOL "Log In" & FOOTER (Saat Keyboard Tertutup)
            // ============================================================
            if (!isKeyboardOpen) ...[
              // Tombol "Log In" (Rectangle 23: Y = 628, W = 328, H = 55, Radius = 25)
              Positioned(
                top: 628 * scaleY,
                left: 36 * scaleX,
                width: 328 * scaleX,
                height: 55 * scaleY,
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFFF3D8FF), // Fill Figma #F3D8FF
                    borderRadius: BorderRadius.circular(25),
                    border: Border.all(
                      color: const Color(0xFFCA31FF), // Stroke #CA31FF
                      width: 1.0,
                    ),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x33000000), // Shadow 20% hitam
                        blurRadius: 4,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(25),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const LoginScreen()),
                        );
                      },
                      child: Center(
                        child: Text(
                          'Log In',
                          style: GoogleFonts.poppins(
                            fontSize: 24 * scaleY,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF570374),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              // Footer: "Already have an account? Log in" (Y = 716)
              Positioned(
                top: 716 * scaleY,
                left: 0,
                right: 0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Already have an account? ',
                      style: GoogleFonts.triodion(
                        fontSize: 14 * scaleY,
                        color: const Color(0xFF570374),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const LoginScreen()),
                        );
                      },
                      child: Text(
                        'Log in',
                        style: GoogleFonts.triodion(
                          fontSize: 14 * scaleY,
                          color: const Color(0xFFCA31FF),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],

            // ============================================================
            // 7. KEYBOARD NUMERIK IN-APP
            // ============================================================
            if (isKeyboardOpen)
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  decoration: const BoxDecoration(
                    color: Color(0xFFF3F3F3),
                    borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0x1F000000),
                        blurRadius: 10,
                        offset: Offset(0, -2),
                      ),
                    ],
                  ),
                  padding: EdgeInsets.symmetric(
                    horizontal: 24 * scaleX,
                    vertical: 14 * scaleY,
                  ),
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
                              fontSize: 13 * scaleY,
                              fontWeight: FontWeight.w500,
                              color: const Color(0xFF570374),
                            ),
                          ),
                          GestureDetector(
                            onTap: _onCloseKeyboard,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFFCA31FF),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                'Selesai',
                                style: GoogleFonts.poppins(
                                  fontSize: 12 * scaleY,
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
                      const SizedBox(height: 10),
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
  // WIDGET KOTAK INPUT (100% Parameter Figma: Rectangle 20, 21, 24)
  // ============================================================================
  Widget _buildInputField({
    required double scaleY,
    required double scaleX,
    required IconData icon,
    required String hint,
    required String value,
    bool isPassword = false,
    bool isObscured = true,
    VoidCallback? onToggleObscure,
    required bool isActive,
  }) {
    return Container(
      width: 328 * scaleX,
      height: 55 * scaleY,
      padding: EdgeInsets.symmetric(horizontal: 20 * scaleX),
      decoration: BoxDecoration(
        color: const Color(0xFFF3D8FF), // Fill Asli Figma
        borderRadius: BorderRadius.circular(25),
        border: Border.all(
          color: const Color(0xFFCA31FF), // Stroke Asli Figma
          width: isActive ? 2.0 : 1.0,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x33000000), // Drop shadow 20% hitam
            blurRadius: 4,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Ikon Kiri (Phone / Lock) - Warna #1C1C1C
          Icon(
            icon,
            size: 24 * scaleY,
            color: const Color(0xFF1C1C1C),
          ),
          SizedBox(width: 14 * scaleX),

          // Teks Input / Placeholder - Font Rasa Regular 24, Warna #CA31FF
          Expanded(
            child: Text(
              value.isEmpty
                  ? hint
                  : (isPassword && isObscured ? '●' * value.length : value),
              style: GoogleFonts.rasa(
                fontSize: 24 * scaleY,
                fontWeight: FontWeight.normal,
                color: const Color(0xFFCA31FF),
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),

          // Ikon Kanan (Mata Tidur Mungil & Rapi)
          if (isPassword)
            GestureDetector(
              onTap: onToggleObscure,
              child: SizedBox(
                width: 18 * scaleX,
                height: 12 * scaleY,
                child: isObscured
                    ? CustomPaint(painter: _ClosedEyePainter())
                    : Icon(
                        Icons.visibility_outlined,
                        size: 20 * scaleY,
                        color: const Color(0xFF1C1C1C),
                      ),
              ),
            ),
        ],
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
      [',', '0', 'del'],
    ];

    return Column(
      children: keys.map((row) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: row.map((key) {
              Widget child;
              if (key == 'del') {
                child = const Icon(
                  Icons.backspace_outlined,
                  size: 20,
                  color: Color(0xFF1C1C1C),
                );
              } else {
                child = Text(
                  key,
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF1C1C1C),
                  ),
                );
              }
              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5.0),
                  child: _buildKeyButton(key, child),
                ),
              );
            }).toList(),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildKeyButton(String key, Widget child) {
    return InkWell(
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
    );
  }
}

// ============================================================================
// CUSTOM PAINTER: Header Kubah Lengkung (Ellipse 8 Asli Figma)
// Warna Fill: #B952DD 100% Sesuai Screenshot Inspektor
// ============================================================================
class _HeaderEllipsePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFB952DD) // Warna B952DD asli Figma Anda
      ..style = PaintingStyle.fill;

    canvas.drawOval(
      Rect.fromLTWH(0, 0, size.width, size.height),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ============================================================================
// CUSTOM PAINTER: Elemen Bulat Kiri Bawah (Ellipse 13 Asli Figma)
// Melengkung tinggi & memotong area teks footer persis Figma
// ============================================================================
class _BottomEllipsePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0x80CA31FF) // #CA31FF 50% opacity asli Figma
      ..style = PaintingStyle.fill;

    final path = Path();
    path.moveTo(0, 0); // Mulai di Y ≈ 655
    path.cubicTo(
      size.width * 0.25, size.height * 0.05,
      size.width * 0.65, size.height * 0.45,
      size.width * 0.94, size.height,
    );
    path.lineTo(0, size.height);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ============================================================================
// CUSTOM PAINTER: Ikon Mata Tidur Mungil & Halus (Vector Asli Figma)
// ============================================================================
class _ClosedEyePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF1C1C1C) // Warna gelap #1C1C1C Figma
      ..strokeWidth = 1.5
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final path = Path();
    path.moveTo(0, size.height * 0.35);
    path.quadraticBezierTo(
      size.width / 2,
      size.height * 0.75,
      size.width,
      size.height * 0.35,
    );
    canvas.drawPath(path, paint);

    canvas.drawLine(
      Offset(size.width * 0.25, size.height * 0.60),
      Offset(size.width * 0.15, size.height * 0.95),
      paint,
    );
    canvas.drawLine(
      Offset(size.width * 0.50, size.height * 0.75),
      Offset(size.width * 0.50, size.height * 1.15),
      paint,
    );
    canvas.drawLine(
      Offset(size.width * 0.75, size.height * 0.60),
      Offset(size.width * 0.85, size.height * 0.95),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}