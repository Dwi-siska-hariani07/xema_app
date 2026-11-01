import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Ukuran layar acuan Figma 393 x 852
    // Menggunakan LayoutBuilder atau SafeArea dengan padding presisi
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
            // Text "Profil Saya" SemiBold
            // Garis pembatas bawah header y: ~104 - 110
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
                  // Teks "Profil Saya" SemiBold 20
                  Text(
                    'Profil Saya',
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
            // 2. ROW 1: Edit Foto (Avatar Lingkaran w: 58, h: 58)
            // =========================================================
            Container(
              height: 80,
              padding: const EdgeInsets.only(left: 21.0, right: 21.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Edit Foto',
                    style: GoogleFonts.robotoSlab(
                      fontSize: 16,
                      fontWeight: FontWeight.w500, // Medium
                      color: Colors.black,
                    ),
                  ),
                  Image.asset(
                    'assets/profile/edit_foto_avatar.png',
                    width: 58,
                    height: 58,
                    fit: BoxFit.contain,
                  ),
                ],
              ),
            ),
            const Divider(height: 1, thickness: 1, color: Colors.black),

            // =========================================================
            // 3. ROW 2: Nama | Lisa Arunia
            // =========================================================
            Container(
              height: 60,
              padding: const EdgeInsets.only(left: 21.0, right: 21.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Nama',
                    style: GoogleFonts.robotoSlab(
                      fontSize: 16,
                      fontWeight: FontWeight.w500, // Medium
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    'Lisa Arunia',
                    style: GoogleFonts.robotoSlab(
                      fontSize: 16,
                      fontWeight: FontWeight.w500, // Medium
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 1, thickness: 1, color: Colors.black),

            // =========================================================
            // 4. ROW 3: No. Handphone | 0851 2343 5656
            // =========================================================
            Container(
              height: 60,
              padding: const EdgeInsets.only(left: 21.0, right: 21.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'No. Handphone',
                    style: GoogleFonts.robotoSlab(
                      fontSize: 16,
                      fontWeight: FontWeight.w500, // Medium
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    '0851 2343 5656',
                    style: GoogleFonts.robotoSlab(
                      fontSize: 16,
                      fontWeight: FontWeight.w500, // Medium
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 1, thickness: 1, color: Colors.black),

            // =========================================================
            // 5. ROW 4: Email | Lisaarunia@gmail.com
            // =========================================================
            Container(
              height: 60,
              padding: const EdgeInsets.only(left: 21.0, right: 21.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Email',
                    style: GoogleFonts.robotoSlab(
                      fontSize: 16,
                      fontWeight: FontWeight.w500, // Medium
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    'Lisaarunia@gmail.com',
                    style: GoogleFonts.robotoSlab(
                      fontSize: 16,
                      fontWeight: FontWeight.w500, // Medium
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 1, thickness: 1, color: Colors.black),
          ],
        ),
      ),
    );
  }
}
