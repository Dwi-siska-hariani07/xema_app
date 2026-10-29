import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'signup_screen.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1C0823),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final screenHeight = constraints.maxHeight;
            // Menghitung ukuran ilustrasi agar selalu pas dan tidak terpotong di emulator mana pun
            final illustrationHeight = (screenHeight * 0.44).clamp(260.0, 420.0);

            return Stack(
              children: [
                // 1. Elemen Bintang di bagian atas kanvas
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: Image.asset(
                    'assets/images/stars.png',
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => const SizedBox(),
                  ),
                ),

                // 2. Konten Utama: Ilustrasi, Teks, & Tombol
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    children: [
                      const SizedBox(height: 10),
                      // Ilustrasi Utama HP & Tangan 3D (group_277.png)
                      SizedBox(
                        height: illustrationHeight,
                        child: Center(
                          child: Image.asset(
                            'assets/images/group_277.png',
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Teks "xema" (Poppins Bold 40, #EAD6D6 resmi Figma)
                      Text(
                        'xema',
                        style: GoogleFonts.poppins(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFFEAD6D6),
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 8),

                      // Teks Informasi Deskripsi (Adamina 12, #FFFFFF resmi Figma)
                      Text(
                        'Solusi dompet digital modern untuk mengatur keuangan\ndan transaksi harianmu dengan lebih cepat dan aman',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.adamina(
                          fontSize: 12,
                          color: const Color(0xFFFFFFFF),
                          height: 1.6,
                        ),
                      ),

                      const Spacer(),

                      // Tombol "Lanjut" (Figma: #CA31FF, Radius 8, Poppins Bold 12)
                      Container(
                        margin: const EdgeInsets.only(bottom: 24),
                        width: 80,
                        height: 32,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const SignUpScreen()),
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
                                fontSize: 13,
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
              ],
            );
          },
        ),
      ),
    );
  }
}
