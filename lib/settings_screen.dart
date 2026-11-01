import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

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
            // Text "Pengaturan" SemiBold 20
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
                  // Teks "Pengaturan" SemiBold 20
                  Text(
                    'Pengaturan',
                    style: GoogleFonts.robotoSlab(
                      fontSize: 20,
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
            // 2. ROW 1: Notifikasi
            // Ikon Lonceng Ungu Figma | Teks "Notifikasi" | Panah Chevron w: 66, h: 66
            // =========================================================
            InkWell(
              onTap: () {},
              child: SizedBox(
                height: 76,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(width: 21),
                    Image.asset(
                      'assets/profile/icon_notif_figma.png',
                      width: 34,
                      height: 34,
                      fit: BoxFit.contain,
                    ),
                    const SizedBox(width: 18),
                    Expanded(
                      child: Text(
                        'Notifikasi',
                        style: GoogleFonts.robotoSlab(
                          fontSize: 16,
                          fontWeight: FontWeight.w500, // Medium
                          color: Colors.black,
                        ),
                      ),
                    ),
                    // Tombol Chevron W: 66, H: 66 sesuai Figma (x: 328)
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
            // 3. ROW 2: Bahasa / Language
            // Ikon Terjemahan Ungu Figma | Teks + Subtitle | Panah Chevron w: 66, h: 66
            // =========================================================
            InkWell(
              onTap: () {},
              child: SizedBox(
                height: 82,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(width: 21),
                    Image.asset(
                      'assets/profile/icon_bahasa_figma.png',
                      width: 36,
                      height: 36,
                      fit: BoxFit.contain,
                    ),
                    const SizedBox(width: 18),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Bahasa/ Language',
                            style: GoogleFonts.robotoSlab(
                              fontSize: 16,
                              fontWeight: FontWeight.w500, // Medium
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            'Bahasa Indonesia',
                            style: GoogleFonts.robotoSlab(
                              fontSize: 13,
                              fontWeight: FontWeight.w400,
                              color: const Color(0xFF6B7280),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Tombol Chevron W: 66, H: 66 sesuai Figma (Node 302:501, position x: 328, y: 229)
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
