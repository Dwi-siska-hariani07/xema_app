import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final double statusBarHeight = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // =========================================================
            // 1. TOP HEADER / APP BAR SECTION
            // Tombol Arrow Back: x: 5, y: 44, w: 51, h: 51
            // Text "Bantuan": Roboto Slab SemiBold 24
            // =========================================================
            Container(
              color: Colors.white,
              padding: EdgeInsets.only(
                top: statusBarHeight > 0 ? statusBarHeight : 20,
                bottom: 8,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(width: 5),
                  // Tombol panah kembali ukuran W: 51, H: 51
                  InkWell(
                    onTap: () => Navigator.pop(context),
                    borderRadius: BorderRadius.circular(25),
                    child: Container(
                      width: 51,
                      height: 51,
                      alignment: Alignment.center,
                      child: Image.asset(
                        'assets/profile/arrow_back.png',
                        width: 36,
                        height: 36,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Teks "Bantuan" Roboto Slab SemiBold 24
                  Text(
                    'Bantuan',
                    style: GoogleFonts.robotoSlab(
                      fontSize: 24,
                      fontWeight: FontWeight.w600, // SemiBold
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),

            // =========================================================
            // 2. BANNER UNGU (#D786F3)
            // Hallo LISA, (SemiBold 24)
            // APA YANG BISA KAMI BANTU? (SemiBold 16)
            // =========================================================
            Container(
              width: double.infinity,
              padding:
                  const EdgeInsets.symmetric(horizontal: 21.0, vertical: 24.0),
              decoration: const BoxDecoration(
                color: Color(0xFFD786F3),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Hallo LISA,',
                    style: GoogleFonts.robotoSlab(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'APA YANG BISA KAMI BANTU?',
                    style: GoogleFonts.robotoSlab(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
            ),

            // =========================================================
            // 3. JUDUL SECTION: Sering Diajukan
            // Roboto Slab SemiBold 20
            // =========================================================
            Padding(
              padding:
                  const EdgeInsets.only(left: 21.0, top: 24.0, bottom: 18.0),
              child: Text(
                'Sering Diajukan',
                style: GoogleFonts.robotoSlab(
                  fontSize: 20,
                  fontWeight: FontWeight.w600, // SemiBold
                  color: Colors.black,
                ),
              ),
            ),

            // Garis pembatas hitam 1px
            const Divider(height: 1, thickness: 1, color: Colors.black),

            // =========================================================
            // 4. LIST FAQ ITEMS
            // Menggunakan font Roboto Slab Medium/SemiBold 16-17 tajam
            // Chevron Kanan presisi W: 66, H: 66
            // Garis pembatas hitam 1px
            // =========================================================
            _buildFaqItem(
              'Apa yang harus saya lakukan jika terjadi kendala saat melakukan aktivasi Xema?',
            ),
            const Divider(height: 1, thickness: 1, color: Colors.black),

            _buildFaqItem(
              'Apa yang harus saya lakukan jika saya tidak menerima kode verifikasi SMS OTP?',
            ),
            const Divider(height: 1, thickness: 1, color: Colors.black),

            _buildFaqItem(
              'Apa yang harus saya lakukan jika saya lupa password saat log in ke aplikasi Xema?',
            ),
            const Divider(height: 1, thickness: 1, color: Colors.black),
          ],
        ),
      ),
    );
  }

  Widget _buildFaqItem(String question) {
    return InkWell(
      onTap: () {},
      child: Padding(
        padding: const EdgeInsets.only(left: 21.0, top: 6.0, bottom: 6.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Text(
                question,
                style: GoogleFonts.robotoSlab(
                  fontSize: 16,
                  fontWeight: FontWeight.w500, // Medium tajam
                  color: Colors.black,
                  height: 1.4,
                ),
              ),
            ),
            // Tombol Chevron W: 66, H: 66 sesuai node Figma
            Container(
              width: 66,
              height: 66,
              alignment: Alignment.center,
              child: Image.asset(
                'assets/profile/chevron_right_figma.png',
                width: 30,
                height: 30,
                fit: BoxFit.contain,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
