import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'signup_screen.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final scaleY = size.height / 852.0;
    final scaleX = size.width / 393.0;

    return Scaffold(
      backgroundColor: const Color(0xFF1C0823),
      body: SafeArea(
        child: SizedBox(
          width: size.width,
          height: size.height,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              // 1. Elemen Bintang (stars.png)
              Positioned(
                top: -5.69 * scaleY,
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
                top: 237 * scaleY,
                left: (size.width - (380.87 * scaleX)) / 2,
                width: 380.87 * scaleX,
                height: 424.63 * scaleY,
                child: Image.asset(
                  'assets/images/group_277.png',
                  fit: BoxFit.contain,
                ),
              ),

              // 3. Teks "xema" (Y = 616, Poppins Bold 40, Warna #EAD6D6)
              Positioned(
                top: 616 * scaleY,
                left: 0,
                right: 0,
                child: Center(
                  child: Text(
                    'xema',
                    style: GoogleFonts.poppins(
                      fontSize: 40 * scaleY,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFFEAD6D6),
                      letterSpacing: 0,
                    ),
                  ),
                ),
              ),

              // 4. Teks "Solusi dompet..." (Y = 696, Adamina Regular 12)
              Positioned(
                top: 696 * scaleY,
                left: 16 * scaleX,
                right: 16 * scaleX,
                child: Center(
                  child: Text(
                    'Solusi dompet digital modern untuk mengatur keuangan\ndan transaksi harianmu dengan lebih cepat dan aman',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.adamina(
                      fontSize: 12 * scaleY,
                      fontWeight: FontWeight.normal,
                      color: const Color(0xFFFFFFFF),
                      height: 1.5,
                    ),
                  ),
                ),
              ),

              // 5. Tombol "Lanjut" (Y = 777, W = 72, H = 28, Radius = 8)
              Positioned(
                top: 777 * scaleY,
                left: (size.width - (72 * scaleX)) / 2,
                width: 72 * scaleX,
                height: 28 * scaleY,
                child: ElevatedButton(
                  onPressed: () {
                    // Berpindah ke halaman Sign Up (tanpa kata const)
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SignUpScreen()),
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
                        fontSize: 12 * scaleY,
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
    );
  }
}