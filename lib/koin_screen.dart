import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class KoinScreen extends StatefulWidget {
  const KoinScreen({super.key});

  @override
  State<KoinScreen> createState() => _KoinScreenState();
}

class _KoinScreenState extends State<KoinScreen> {
  String _selectedPoin = '100.000';
  String _cashReward = 'Rp 10.000';

  final List<Map<String, String>> _redeemOptions = [
    {'poin': '100.000', 'cash': 'Rp 10.000'},
    {'poin': '200.000', 'cash': 'Rp 20.000'},
    {'poin': '500.000', 'cash': 'Rp 50.000'},
    {'poin': '1.000.000', 'cash': 'Rp 100.000'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          child: Column(
            children: [
              // ========================================================
              // 1. TAMPILAN ATAS / HEADER (PERSIS ASLI FIGMA)
              // ========================================================
              Container(
                width: double.infinity,
                color: Colors.white,
                child: Stack(
                  children: [
                    // Gambar Header Asli Figma (Bercak Organik, XEMA POIN, & Garis Pembatas)
                    Image.asset(
                      'assets/images/koin_header.png',
                      width: double.infinity,
                      fit: BoxFit.fitWidth,
                      errorBuilder: (_, __, ___) => Container(
                        padding: const EdgeInsets.only(top: 45, bottom: 15),
                        color: const Color(0xFFFAF5FD),
                        child: Center(
                          child: Text(
                            'XEMA POIN',
                            style: GoogleFonts.poltawskiNowy(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF52086B),
                            ),
                          ),
                        ),
                      ),
                    ),

                    // Area Klik Tombol Kembali (Back Arrow)
                    Positioned(
                      left: 0,
                      top: 0,
                      bottom: 0,
                      width: 70,
                      child: GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onTap: () {
                          if (Navigator.canPop(context)) {
                            Navigator.pop(context);
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 14),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    // ========================================================
                    // 2. KARTU TOTAL POIN (GAMBAR KEDUA FIGMA 100% PERSIS)
                    // ========================================================
                    Image.asset(
                      'assets/images/koin_total_card.png',
                      width: double.infinity,
                      fit: BoxFit.contain,
                    ),

                    const SizedBox(height: 16),

                    // ========================================================
                    // 3. DAFTAR PILIHAN PENUKARAN POIN FIGMA
                    // ========================================================
                    ..._redeemOptions.map((opt) {
                      final isSelected = _selectedPoin == opt['poin'];
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedPoin = opt['poin']!;
                            _cashReward = opt['cash']!;
                          });
                        },
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          decoration: BoxDecoration(
                            color: const Color(0xFFEDD5FA),
                            borderRadius: BorderRadius.circular(22),
                            border: Border.all(
                              color: const Color(0xFFCA31FF),
                              width: isSelected ? 2.0 : 1.2,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: isSelected
                                    ? const Color(0x4DCA31FF)
                                    : const Color(0x24772096),
                                blurRadius: isSelected ? 10 : 6,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              // Ikon Koin Opsi Penukaran Figma (Coin Option)
                              Image.asset(
                                'assets/images/coin_option.png',
                                width: 44,
                                height: 44,
                                fit: BoxFit.contain,
                                errorBuilder: (_, __, ___) => const Icon(
                                  Icons.monetization_on,
                                  color: Color(0xFFE5A93C),
                                  size: 40,
                                ),
                              ),
                              const SizedBox(width: 12),

                              // Angka Poin & Nilai Tukar (Poppins)
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    opt['poin']!,
                                    style: GoogleFonts.poppins(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                  Text(
                                    opt['cash']!,
                                    style: GoogleFonts.poppins(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                      color: const Color(0xFF52086B),
                                    ),
                                  ),
                                ],
                              ),

                              const Spacer(),

                              // Tulisan "POIN" (Roboto Slab)
                              Text(
                                'POIN',
                                style: GoogleFonts.robotoSlab(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),

                    const SizedBox(height: 10),

                    // ========================================================
                    // 4. BAGIAN BAWAH: ILUSTRASI KUCING & TOMBOL KLAIM
                    // ========================================================
                    Container(
                      width: double.infinity,
                      constraints: const BoxConstraints(maxWidth: 380),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          // Ilustrasi Kucing Harta Karun & Teks "KUMPULKAN LEBIH BANYAK POIN!"
                          Image.asset(
                            'assets/images/koin_cat.png',
                            width: double.infinity,
                            fit: BoxFit.contain,
                            errorBuilder: (_, __, ___) => Row(
                              children: [
                                Text(
                                  'KUMPULKAN LEBIH\nBANYAK POIN!',
                                  style: GoogleFonts.robotoSlab(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: const Color(0xFF52086B),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Tombol "KLAIM" (Roboto Slab, Warna #CA31FF)
                          Positioned(
                            left: 14,
                            bottom: 12,
                            child: Container(
                              width: 115,
                              height: 38,
                              decoration: BoxDecoration(
                                color: const Color(0xFFCA31FF),
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Color(0x40CA31FF),
                                    blurRadius: 6,
                                    offset: Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(20),
                                  onTap: () {
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(22),
                                          ),
                                          title: Text(
                                            'Klaim Berhasil!',
                                            style: GoogleFonts.robotoSlab(
                                              fontWeight: FontWeight.bold,
                                              color: const Color(0xFF52086B),
                                            ),
                                          ),
                                          content: Text(
                                            'Selamat! Penukaran $_selectedPoin POIN ke saldo $_cashReward berhasil diajukan.',
                                            style: GoogleFonts.poppins(fontSize: 14),
                                          ),
                                          actions: [
                                            TextButton(
                                              onPressed: () => Navigator.pop(context),
                                              child: Text(
                                                'OK',
                                                style: GoogleFonts.robotoSlab(
                                                  fontWeight: FontWeight.bold,
                                                  color: const Color(0xFFCA31FF),
                                                ),
                                              ),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                  child: Center(
                                    child: Text(
                                      'KLAIM',
                                      style: GoogleFonts.robotoSlab(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 25),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
