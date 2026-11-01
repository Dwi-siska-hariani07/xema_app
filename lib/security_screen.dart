import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SecurityScreen extends StatelessWidget {
  const SecurityScreen({super.key});

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
            // Sesuai Figma: Arrow x: 5, y: 44, w: 51, h: 51
            // Text "Keamanan" SemiBold, 24
            // Garis pembatas bawah header Divider hitam 1px
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
                  // Teks "Keamanan" Roboto Slab SemiBold, 24
                  Text(
                    'Keamanan',
                    style: GoogleFonts.robotoSlab(
                      fontSize: 24,
                      fontWeight: FontWeight.w600, // SemiBold
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
            // Garis hitam pemisah header
            const Divider(height: 1, thickness: 1, color: Colors.black),

            // =========================================================
            // 2. ROW 1: Ubah PIN
            // Ubah PIN: Roboto Slab Medium, 20
            // Subtitle: Roboto Slab Reguler, 16
            // Panah Chevron: W: 66, H: 66
            // =========================================================
            InkWell(
              onTap: () {},
              child: SizedBox(
                height: 88,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(width: 21),
                    Image.asset(
                      'assets/profile/icon_shield_figma.png',
                      width: 38,
                      height: 38,
                      fit: BoxFit.contain,
                    ),
                    const SizedBox(width: 18),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Ubah PIN',
                            style: GoogleFonts.robotoSlab(
                              fontSize: 20,
                              fontWeight: FontWeight.w500, // Medium
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            'Ubah PIN untuk keamanan transaksi',
                            style: GoogleFonts.robotoSlab(
                              fontSize: 16,
                              fontWeight: FontWeight.w400, // Reguler
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Tombol Chevron W: 66, H: 66
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
            ),
            const Divider(height: 1, thickness: 1, color: Colors.black),

            // =========================================================
            // 3. ROW 2: Ubah password
            // Ubah password: Roboto Slab Medium, 20
            // Subtitle: Roboto Slab Reguler, 16
            // Panah Chevron: W: 66, H: 66
            // =========================================================
            InkWell(
              onTap: () {},
              child: SizedBox(
                height: 88,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(width: 21),
                    Image.asset(
                      'assets/profile/icon_lock_figma.png',
                      width: 38,
                      height: 38,
                      fit: BoxFit.contain,
                    ),
                    const SizedBox(width: 18),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Ubah password',
                            style: GoogleFonts.robotoSlab(
                              fontSize: 20,
                              fontWeight: FontWeight.w500, // Medium
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            'Ubah password untuk login',
                            style: GoogleFonts.robotoSlab(
                              fontSize: 16,
                              fontWeight: FontWeight.w400, // Reguler
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Tombol Chevron W: 66, H: 66
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
            ),
            const Divider(height: 1, thickness: 1, color: Colors.black),
          ],
        ),
      ),
    );
  }
}
