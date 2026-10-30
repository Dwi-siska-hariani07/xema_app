import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'signup_screen.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Background warna ungu gelap resmi Figma #1C0823
    return Scaffold(
      backgroundColor: const Color(0xFF1C0823),
      body: Center(
        child: FittedBox(
          fit: BoxFit.contain,
          alignment: Alignment.center,
          child: SizedBox(
            // Mengunci kanvas presisi 100% Figma node #19:4 (393 x 852)
            width: 393,
            height: 852,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                // =========================================================
                // 1. ELEMEN BINTANG LATAR BELAKANG (Figma node #136:468)
                // W: 393, H: 852 - Mencakup 3 bintang (kiri atas, kanan atas, bawah)
                // =========================================================
                Positioned(
                  left: 0,
                  top: 0,
                  width: 393,
                  height: 852,
                  child: Image.asset(
                    'assets/images/stars.png',
                    fit: BoxFit.fill,
                    errorBuilder: (context, error, stackTrace) => const SizedBox(),
                  ),
                ),

                // =========================================================
                // 2. ILUSTRASI UTAMA HP & TANGAN 3D (Figma node #830:4450)
                // Posisi persis Figma: Top: 237, Left: 0, W: 380.87, H: 424.63
                // Dilengkapi 4 ikon mengapung (kartu kredit, handshake, transfer, grafik)
                // =========================================================
                Positioned(
                  top: 237,
                  left: 0,
                  width: 380.87,
                  height: 424.63,
                  child: Image.asset(
                    'assets/images/onboarding_hands.png',
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return Image.asset(
                        'assets/images/group_277.png',
                        fit: BoxFit.contain,
                      );
                    },
                  ),
                ),

                // =========================================================
                // 3. TEKS LOGO "xema" (Figma node #33:141)
                // Tepat di tengah bintang bawah, Y: 616
                // Font: Poppins Bold 40, Warna: #EAE6E6
                // =========================================================
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
                        color: const Color(0xFFEAE6E6),
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ),

                // =========================================================
                // 4. TEKS INFORMASI DESKRIPSI (Figma node #33:136)
                // Di dalam lekukan bintang bawah, Y: 696
                // Font: Adamina 12, Warna: #FFFFFF, Line Height: 1.6
                // =========================================================
                Positioned(
                  top: 696,
                  left: 24,
                  right: 24,
                  child: Text(
                    'Solusi dompet digital modern untuk mengatur keuangan\ndan transaksi harianmu dengan lebih cepat dan aman',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.adamina(
                      fontSize: 12,
                      color: const Color(0xFFFFFFFF),
                      height: 1.6,
                    ),
                  ),
                ),

                // =========================================================
                // 5. TOMBOL "Lanjut" (Figma node #142:211)
                // Posisi persis Figma: Top: 777, Center X, W: 72, H: 28, Radius: 8
                // Fill: #CA31FF, Teks: Poppins Bold 12 Putih
                // =========================================================
                Positioned(
                  top: 777,
                  left: (393 - 72) / 2,
                  width: 72,
                  height: 28,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SignUpScreen(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFCA31FF),
                      foregroundColor: Colors.white,
                      elevation: 4,
                      padding: EdgeInsets.zero,
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
                          color: Colors.white,
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
