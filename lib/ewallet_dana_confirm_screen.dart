import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'ewallet_dana_success_screen.dart';

class EwalletDanaConfirmScreen extends StatelessWidget {
  final String phoneNumber;
  final String nominal;

  const EwalletDanaConfirmScreen({
    super.key,
    required this.phoneNumber,
    required this.nominal,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final displayPhone =
        phoneNumber.isNotEmpty ? phoneNumber : '085189898989';
    final displayNominal =
        nominal.isNotEmpty ? nominal : '200.000';

    return Scaffold(
      backgroundColor: Colors.white,
      body: SizedBox(
        width: size.width,
        height: size.height,
        child: FittedBox(
          fit: BoxFit.fill,
          alignment: Alignment.center,
          child: SizedBox(
            // Kanvas presisi 1:1 Figma (393 x 852)
            width: 393,
            height: 852,
            child: Stack(
              children: [
                // =============================================================
                // 1. LATAR BELAKANG HALAMAN DANA (Header + Merchant + Nominal)
                // =============================================================
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header Ungu
                    Container(
                      width: 393,
                      height: 110,
                      color: const Color(0xFFC736FE),
                      padding: const EdgeInsets.only(top: 45, left: 16, right: 18),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              GestureDetector(
                                onTap: () => Navigator.pop(context),
                                child: const Icon(
                                  Icons.arrow_back,
                                  size: 26,
                                  color: Color(0xFF52086B),
                                ),
                              ),
                              const SizedBox(width: 14),
                              Text(
                                'E-Wallet',
                                style: GoogleFonts.poppins(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                  color: const Color(0xFF52086B),
                                ),
                              ),
                            ],
                          ),
                          Image.asset(
                            'assets/images/ewallet_header_wallet.png',
                            width: 30,
                            height: 30,
                            fit: BoxFit.contain,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Kotak 1: Nama Merchant (DANA)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Nama Merchant',
                            style: GoogleFonts.poppins(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF1E1E1E),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            width: 345,
                            height: 60,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: const Color(0xFFE2E2E2),
                                width: 1.5,
                              ),
                              boxShadow: const [
                                BoxShadow(
                                  color: Color(0x14000000),
                                  blurRadius: 6,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Row(
                              children: [
                                Image.asset(
                                  'assets/images/ewallet_dana_icon.png',
                                  width: 32,
                                  height: 32,
                                  fit: BoxFit.contain,
                                ),
                                const SizedBox(width: 14),
                                Text(
                                  'DANA',
                                  style: GoogleFonts.poppins(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    color: const Color(0xFF1E1E1E),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 22),

                    // Kotak 2: Masukan Nominal (Rp 200.000)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Masukan Nominal',
                            style: GoogleFonts.poppins(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF1E1E1E),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            width: 345,
                            height: 56,
                            decoration: BoxDecoration(
                              color: const Color(0xFFD9D9D9),
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                color: const Color(0xFFB5B5B5),
                                width: 1.0,
                              ),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Row(
                              children: [
                                Text(
                                  'Rp',
                                  style: GoogleFonts.poppins(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w800,
                                    color: const Color(0xFF1E1E1E),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  displayNominal,
                                  style: GoogleFonts.poppins(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w800,
                                    color: const Color(0xFF1E1E1E),
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                // =============================================================
                // 2. BOTTOM SHEET KONFIRMASI TRANSAKSI (Figma Frame DANA4)
                // Berada di bagian bawah dengan handle bar abu-abu dan detail transaksi
                // =============================================================
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  height: 440,
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                      boxShadow: [
                        BoxShadow(
                          color: Color(0x26000000),
                          blurRadius: 16,
                          offset: Offset(0, -4),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Drag handle bar
                        Center(
                          child: Container(
                            width: 50,
                            height: 5,
                            decoration: BoxDecoration(
                              color: const Color(0xFFD6D6D6),
                              borderRadius: BorderRadius.circular(3),
                            ),
                          ),
                        ),
                        const SizedBox(height: 18),

                        // Judul: Konfirmasi Transaksi
                        Text(
                          'Konfirmasi Transaksi',
                          style: GoogleFonts.poppins(
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF1E1E1E),
                          ),
                        ),
                        const SizedBox(height: 14),

                        // Info Merchant DANA & Nomor Tujuan
                        Row(
                          children: [
                            Image.asset(
                              'assets/images/ewallet_dana_icon.png',
                              width: 38,
                              height: 38,
                              fit: BoxFit.contain,
                            ),
                            const SizedBox(width: 14),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'DANA',
                                  style: GoogleFonts.poppins(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700,
                                    color: const Color(0xFF1E1E1E),
                                  ),
                                ),
                                Text(
                                  displayPhone,
                                  style: GoogleFonts.poppins(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                    color: const Color(0xFF555555),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),

                        const SizedBox(height: 14),
                        // Garis putus-putus
                        _buildDashedLine(),
                        const SizedBox(height: 12),

                        // Rincian Pembayaran
                        _buildRow('Nama Pelanggan', 'DNI* DXX SIS**'),
                        const SizedBox(height: 10),
                        _buildDashedLine(),
                        const SizedBox(height: 10),
                        _buildRow('Nominal Top UP', 'Rp $displayNominal'),
                        const SizedBox(height: 8),
                        _buildRow('Biaya Admin', 'Rp 500'),
                        const SizedBox(height: 8),
                        _buildRow(
                          'Total',
                          'Rp 200.500',
                          isBold: true,
                        ),

                        const Spacer(),

                        // Tombol Ungu "Konfirmasi"
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => EwalletDanaSuccessScreen(
                                    phoneNumber: displayPhone,
                                    nominal: displayNominal,
                                  ),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFCA31FF), // Ungu tombol Figma
                              foregroundColor: Colors.white,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                            child: Text(
                              'Konfirmasi',
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                      ],
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

  Widget _buildRow(String title, String value, {bool isBold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: GoogleFonts.poppins(
            fontSize: 13,
            fontWeight: isBold ? FontWeight.w700 : FontWeight.w500,
            color: const Color(0xFF333333),
          ),
        ),
        Text(
          value,
          style: GoogleFonts.poppins(
            fontSize: 13,
            fontWeight: isBold ? FontWeight.w800 : FontWeight.w600,
            color: const Color(0xFF1E1E1E),
          ),
        ),
      ],
    );
  }

  Widget _buildDashedLine() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final boxWidth = constraints.constrainWidth();
        const dashWidth = 5.0;
        const dashSpace = 3.0;
        final dashCount = (boxWidth / (dashWidth + dashSpace)).floor();
        return Flex(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          direction: Axis.horizontal,
          children: List.generate(dashCount, (_) {
            return const SizedBox(
              width: dashWidth,
              height: 1,
              child: DecoratedBox(
                decoration: BoxDecoration(color: Color(0xFFD6D6D6)),
              ),
            );
          }),
        );
      },
    );
  }
}

