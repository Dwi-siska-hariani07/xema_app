import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BuktiTransaksiGameScreen extends StatelessWidget {
  final String totalAmount;
  final String transactionDate;
  final String transactionId;
  final String orderId;
  final String userName;
  final String userPhone;

  const BuktiTransaksiGameScreen({
    super.key,
    this.totalAmount = 'Rp 33.000',
    this.transactionDate = '1 Okt 2026 09:18:67 WIB',
    this.transactionId = 'A220261002143010V',
    this.orderId = 'MLBEXIA0FD05C6C',
    this.userName = 'LISA ARUNIA',
    this.userPhone = '085*******656',
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        top: false,
        bottom: true, // Pastikan tombol OK pas di atas bar navigasi bawah HP
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight,
                ),
                child: IntrinsicHeight(
                  child: Column(
                    children: [
                      // ========================================================
                      // 1. HEADER ATAS WARNA UNGU PERSIS FIGMA
                      // Berisi Party Popper & Tombol Share
                      // ========================================================
                      Container(
                        width: double.infinity,
                        color: const Color(0xFFD373FC),
                        child: SafeArea(
                          bottom: false,
                          child: Stack(
                            children: [
                              Image.asset(
                                'assets/images/receipt_top_header.png',
                                width: double.infinity,
                                fit: BoxFit.fitWidth,
                              ),
                              Positioned(
                                right: 8,
                                top: 4,
                                width: 52,
                                height: 52,
                                child: GestureDetector(
                                  behavior: HitTestBehavior.opaque,
                                  onTap: () {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          'Membagikan Bukti Transaksi...',
                                          style: GoogleFonts.robotoSlab(),
                                        ),
                                        backgroundColor: const Color(0xFF772096),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // ========================================================
                      // 2. KARTU BUKTI TRANSAKSI & TOMBOL OK
                      // Mengisi penuh layar bawah tanpa ada ruang kosong tersisa
                      // ========================================================
                      Expanded(
                        child: Transform.translate(
                          offset: const Offset(0, -22),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Column(
                              children: [
                                // Kartu Lavender Mengembang Mengisi Ruang Layar
                                Expanded(
                                  child: Container(
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFF6E1FF),
                                      borderRadius: BorderRadius.circular(26),
                                      boxShadow: const [
                                        BoxShadow(
                                          color: Color(0x1F000000),
                                          blurRadius: 16,
                                          offset: Offset(0, 5),
                                        ),
                                      ],
                                    ),
                                    padding: const EdgeInsets.fromLTRB(22, 24, 22, 24),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        // 2A. Header Kartu (Centang Ungu & Bukti Transaksi)
                                        Column(
                                          children: [
                                            Container(
                                              width: 58,
                                              height: 58,
                                              decoration: const BoxDecoration(
                                                color: Color(0xFFCA31FF),
                                                shape: BoxShape.circle,
                                              ),
                                              child: const Icon(
                                                Icons.check,
                                                color: Colors.white,
                                                size: 36,
                                              ),
                                            ),
                                            const SizedBox(height: 12),
                                            Text(
                                              'Bukti Transaksi',
                                              style: GoogleFonts.robotoSlab(
                                                fontSize: 22,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black,
                                              ),
                                            ),
                                          ],
                                        ),

                                        // 2B. Informasi Tanggal & Metode Pembayaran
                                        Column(
                                          children: [
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(
                                                  'Tanggal Transaksi',
                                                  style: GoogleFonts.robotoSlab(
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                                Text(
                                                  transactionDate,
                                                  style: GoogleFonts.robotoSlab(
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 12),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'Metode Pembayaran\n(XEMA):',
                                                  style: GoogleFonts.robotoSlab(
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black,
                                                    height: 1.25,
                                                  ),
                                                ),
                                                Text(
                                                  '$userName\n$userPhone',
                                                  textAlign: TextAlign.right,
                                                  style: GoogleFonts.robotoSlab(
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black,
                                                    height: 1.25,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),

                                        const Divider(height: 1, thickness: 1, color: Color(0xFFD1C0D9)),

                                        // 2C. Teks SUKSES! Besar
                                        Text(
                                          'SUKSES!',
                                          style: GoogleFonts.robotoSlab(
                                            fontSize: 28,
                                            fontWeight: FontWeight.bold,
                                            color: const Color(0xFFCA31FF),
                                            letterSpacing: 0.5,
                                          ),
                                        ),

                                        // 2D. ID Transaksi & Order ID
                                        Column(
                                          children: [
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(
                                                  'ID Transaksi:',
                                                  style: GoogleFonts.robotoSlab(
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                                Text(
                                                  transactionId,
                                                  style: GoogleFonts.robotoSlab(
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 10),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(
                                                  'Order ID:',
                                                  style: GoogleFonts.robotoSlab(
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                                Text(
                                                  orderId,
                                                  style: GoogleFonts.robotoSlab(
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),

                                        const Divider(height: 1, thickness: 1, color: Color(0xFFD1C0D9)),

                                        // 2E. Keterangan & Biaya Admin
                                        Column(
                                          children: [
                                            Align(
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                'Keterangan: Top Up Game',
                                                style: GoogleFonts.robotoSlab(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(height: 10),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(
                                                  'Biaya Admin',
                                                  style: GoogleFonts.robotoSlab(
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                                Text(
                                                  'Gratis',
                                                  style: GoogleFonts.robotoSlab(
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.bold,
                                                    color: const Color(0xFFFF383C),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),

                                        const Divider(height: 1, thickness: 1, color: Color(0xFFD1C0D9)),

                                        // 2F. TOTAL Rp 33.000
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              'TOTAL',
                                              style: GoogleFonts.robotoSlab(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black,
                                              ),
                                            ),
                                            Text(
                                              totalAmount,
                                              style: GoogleFonts.robotoSlab(
                                                fontSize: 22,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),

                                const SizedBox(height: 16),

                                // ========================================================
                                // 3. TOMBOL "OK" TEPAT DI BAWAH KARTU (MENGISI PENUH)
                                // ========================================================
                                SizedBox(
                                  width: double.infinity,
                                  height: 52,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      Navigator.popUntil(context, (route) => route.isFirst);
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFFCA31FF),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(14),
                                        side: const BorderSide(color: Color(0xFF140519), width: 1.5),
                                      ),
                                      elevation: 0,
                                    ),
                                    child: Text(
                                      'OK',
                                      style: GoogleFonts.robotoSlab(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),

                                const SizedBox(height: 12),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
