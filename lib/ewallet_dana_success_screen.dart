import 'package:flutter/material.dart';
import 'beranda_screen.dart';

class EwalletDanaSuccessScreen extends StatelessWidget {
  final String phoneNumber;
  final String nominal;

  const EwalletDanaSuccessScreen({
    super.key,
    required this.phoneNumber,
    required this.nominal,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      // Latar belakang putih bersih persis 1:1 Figma (frame 674-661)
      backgroundColor: Colors.white,
      body: SizedBox(
        width: size.width,
        height: size.height,
        child: FittedBox(
          fit: BoxFit.fill,
          alignment: Alignment.center,
          child: SizedBox(
            // Ukuran kanvas presisi Figma (393 x 852)
            width: 393,
            height: 852,
            child: Stack(
              children: [
                // =============================================================
                // 1. DOME UNGU ATAS (Ilustrasi Party Popper + Tombol Share)
                // =============================================================
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  height: 240,
                  child: Image.asset(
                    'assets/images/ewallet_d5_top_dome.png',
                    fit: BoxFit.fill,
                  ),
                ),

                // =============================================================
                // 2. KARTU STRUK / BUKTI TRANSAKSI LENGKAP PERSIS FIGMA
                // Memiliki latar ungu lembut #F8EEFF, divider, neon SUKSES!, dan total
                // =============================================================
                Positioned(
                  top: 175,
                  left: 14,
                  right: 14,
                  height: 600,
                  child: Image.asset(
                    'assets/images/ewallet_d5_card.png',
                    fit: BoxFit.fill,
                  ),
                ),

                // =============================================================
                // 3. TOMBOL "OK" DI ATAS LATAR PUTIH PERSIS FIGMA
                // Berada tepat di bawah kartu dengan border hitam dan radius Figma
                // =============================================================
                Positioned(
                  bottom: 14,
                  left: 14,
                  right: 14,
                  height: 48,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const BerandaScreen(),
                        ),
                        (route) => false,
                      );
                    },
                    child: Image.asset(
                      'assets/images/ewallet_d5_ok_btn.png',
                      fit: BoxFit.fill,
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
