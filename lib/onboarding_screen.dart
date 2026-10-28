import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'signup_screen.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Mengunci resolusi kanvas presisi Figma 393 x 852 (Pixel-Perfect)
    return Scaffold(
      backgroundColor: const Color(0xFF1C0823),
      body: Center(
        child: FittedBox(
          fit: BoxFit.contain,
          child: SizedBox(
            width: 393,
            height: 852,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                // 1. Elemen Bintang (stars.png)
                Positioned(
                  top: -5.69,
                  left: 0,
                  right: 0,
                  child: Image.asset(
                    'assets/images/stars.png',
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) => const SizedBox(),
                  ),
                ),

                // 2. Ilustrasi Utama HP & Tangan (group_277.png)
                Positioned(
                  top: 237,
                  left: (393 - 380.87) / 2,
                  width: 380.87,
                  height: 424.63,
                  child: Image.asset(
                    'assets/images/group_277.png',
                    fit: BoxFit.contain,
                  ),
                ),

                // 3. Teks "xema" (Y = 616, Poppins Bold 40, Warna #EAD6D6)
                Positioned(
                  top: 616,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Text(
                      'xema',
                      style: GoogleFonts.poppins(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFFEAD6D6),
                        letterSpacing: 0,
                      ),
                    ),
                  ),
                ),

                // 4. Teks "Solusi dompet..." (Y = 696, Adamina Regular 12)
                Positioned(
                  top: 696,
                  left: 20,
                  right: 20,
                  child: Center(
                    child: Text(
                      'Solusi dompet digital modern untuk mengatur keuangan\ndan transaksi harianmu dengan lebih cepat dan aman',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.adamina(
                        fontSize: 12,
                        fontWeight: FontWeight.normal,
                        color: const Color(0xFFFFFFFF),
                        height: 1.5,
                      ),
                    ),
                  ),
                ),

                // 5. Tombol "Lanjut" (Y = 777, W = 72, H = 28, Radius = 8)
                Positioned(
                  top: 777,
                  left: (393 - 72) / 2,
                  width: 72,
                  height: 28,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const SignUpScreen()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFCA31FF),
                      foregroundColor: const Color(0xFFFFFFFF),
                      elevation: 0,
                      padding: EdgeInsets.zero,
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Center(
                      child: Text(
                        'Lanjut',
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFFFFFFFF),
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
