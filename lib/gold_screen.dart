import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'beranda_screen.dart';
import 'buy_gold_screen.dart';
import 'sell_gold_screen.dart';

class GoldScreen extends StatefulWidget {
  const GoldScreen({super.key});

  @override
  State<GoldScreen> createState() => _GoldScreenState();
}

class _GoldScreenState extends State<GoldScreen> {
  // Saldo emas saat ini (dapat bertambah/berkurang sesuai transaksi)
  double _goldGrams = 5.2400;
  final double _pricePerGramSell = 2250000; // Harga Jual ke Aplikasi
  final double _pricePerGramBuy = 2300000;  // Harga Beli dari Aplikasi

  // Format angka ke format rupiah
  String _formatRupiah(num number) {
    final str = number.round().toString();
    final buffer = StringBuffer();
    for (int i = 0; i < str.length; i++) {
      if (i > 0 && (str.length - i) % 3 == 0) {
        buffer.write('.');
      }
      buffer.write(str[i]);
    }
    return 'Rp ${buffer.toString()}';
  }


  // Ikon 4 Balok Kuning Emas di Pojok Kanan Atas
  Widget _buildStaircaseChartIcon() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildSingleBar(height: 8),
        const SizedBox(width: 3),
        _buildSingleBar(height: 14),
        const SizedBox(width: 3),
        _buildSingleBar(height: 20),
        const SizedBox(width: 3),
        _buildSingleBar(height: 26),
      ],
    );
  }

  Widget _buildSingleBar({required double height}) {
    return Container(
      width: 5,
      height: height,
      decoration: BoxDecoration(
        color: const Color(0xFFFFD900),
        borderRadius: BorderRadius.circular(1.5),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double currentValue = _goldGrams * _pricePerGramSell;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // 1. HEADER (Tinggi 90px, Seamless dari Status Bar y=0, Warna #D373FC)
          Container(
            width: double.infinity,
            height: 90,
            color: const Color(0xFFD373FC),
            padding: const EdgeInsets.only(top: 32, left: 16, right: 20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    if (Navigator.canPop(context)) {
                      Navigator.pop(context);
                    } else {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (_) => const BerandaScreen()),
                      );
                    }
                  },
                  child: const Icon(
                    Icons.arrow_back,
                    color: Color(0xFF52086B),
                    size: 26,
                  ),
                ),
                const SizedBox(width: 14),
                Text(
                  'INVESTASI EMAS',
                  style: GoogleFonts.robotoSlab(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF52086B),
                    letterSpacing: 0.5,
                  ),
                ),
                const Spacer(),
                _buildStaircaseChartIcon(),
              ],
            ),
          ),

          // 2. KONTEN BODY (Bisa di-scroll, bebas overflow)
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // --- KARTU TABUNGAN EMAS ANDA ---
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF3D8FF),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x1A000000),
                          blurRadius: 10,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Tabungan Emas Anda',
                          style: GoogleFonts.robotoSlab(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF1E1E1E),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          '${_goldGrams.toStringAsFixed(4).replaceAll('.', ',')} Gram',
                          style: GoogleFonts.robotoSlab(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text.rich(
                          TextSpan(
                            style: GoogleFonts.robotoSlab(
                              fontSize: 15,
                              color: const Color(0xFF1E1E1E),
                            ),
                            children: [
                              const TextSpan(text: 'Nilai Saat Ini: '),
                              TextSpan(
                                text: _formatRupiah(currentValue),
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        // Badge Keuntungan Pill (#CA31FF dengan border putih 1px)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                          decoration: BoxDecoration(
                            color: const Color(0xFFCA31FF),
                            borderRadius: BorderRadius.circular(15.5),
                            border: Border.all(color: Colors.white, width: 1.2),
                            boxShadow: const [
                              BoxShadow(
                                color: Color(0x26000000),
                                blurRadius: 6,
                                offset: Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Text(
                            '+ Rp 100.000 (0.8%)',
                            style: GoogleFonts.robotoSlab(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),

                  // --- SECTION: HARGA EMAS HARI INI ---
                  Text(
                    'Harga Emas Hari Ini',
                    style: GoogleFonts.robotoSlab(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // 2 Kartu Berdampingan (Jual & Beli)
                  Row(
                    children: [
                      // Kartu Kiri: Jual ke Aplikasi
                      Expanded(
                        child: Container(
                          height: 84,
                          decoration: BoxDecoration(
                            color: const Color(0xFFF3D8FF),
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: const [
                              BoxShadow(
                                color: Color(0x15000000),
                                blurRadius: 8,
                                offset: Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Jual',
                                style: GoogleFonts.robotoSlab(
                                  fontSize: 13,
                                  color: Colors.black87,
                                ),
                              ),
                              Text(
                                'ke Aplikasi',
                                style: GoogleFonts.robotoSlab(
                                  fontSize: 13,
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                '${_formatRupiah(_pricePerGramSell)}/gr',
                                style: GoogleFonts.robotoSlab(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),

                      // Kartu Kanan: Beli dari Aplikasi
                      Expanded(
                        child: Container(
                          height: 84,
                          decoration: BoxDecoration(
                            color: const Color(0xFFF3D8FF),
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: const [
                              BoxShadow(
                                color: Color(0x15000000),
                                blurRadius: 8,
                                offset: Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Beli dari',
                                style: GoogleFonts.robotoSlab(
                                  fontSize: 13,
                                  color: Colors.black87,
                                ),
                              ),
                              Text(
                                'Aplikasi',
                                style: GoogleFonts.robotoSlab(
                                  fontSize: 13,
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                '${_formatRupiah(_pricePerGramBuy)}/gr',
                                style: GoogleFonts.robotoSlab(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 18),

                  // 2 Tombol Aksi: JUAL & BELI
                  Row(
                    children: [
                      // Tombol JUAL
                      Expanded(
                        child: SizedBox(
                          height: 56,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF570374),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              elevation: 4,
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => SellGoldScreen(
                                    currentGrams: _goldGrams,
                                    pricePerGramSell: _pricePerGramSell,
                                    onSellSuccess: (sold, rupiah) {
                                      setState(() {
                                        _goldGrams = (_goldGrams - sold).clamp(0.0, double.infinity);
                                      });
                                    },
                                  ),
                                ),
                              );
                            },
                            child: Text(
                              'JUAL',
                              style: GoogleFonts.robotoSlab(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                letterSpacing: 1,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),

                      // Tombol BELI
                      Expanded(
                        child: SizedBox(
                          height: 56,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF570374),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              elevation: 4,
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => BuyGoldScreen(
                                    pricePerGram: _pricePerGramBuy,
                                    onBuySuccess: (bought, rupiah) {
                                      setState(() {
                                        _goldGrams += bought;
                                      });
                                    },
                                  ),
                                ),
                              );
                            },
                            child: Text(
                              'BELI',
                              style: GoogleFonts.robotoSlab(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                letterSpacing: 1,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 36),

                  // --- GARIS PEMISAH / DIVIDER ---
                  Container(
                    height: 1.5,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.3),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x15000000),
                          blurRadius: 4,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),

                  // --- SECTION: RINGKASAN KINERJA ---
                  Text(
                    'Ringkasan Kinerja',
                    style: GoogleFonts.robotoSlab(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 16),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          'Harga Rata-rata Beli',
                          style: GoogleFonts.robotoSlab(
                            fontSize: 14,
                            color: const Color(0xFF1E1E1E),
                          ),
                        ),
                      ),
                      Text(
                        'Rp 2.250.000 / gr',
                        style: GoogleFonts.robotoSlab(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          'Total Modal Diinvestasikan',
                          style: GoogleFonts.robotoSlab(
                            fontSize: 14,
                            color: const Color(0xFF1E1E1E),
                          ),
                        ),
                      ),
                      Text(
                        'Rp 13.000.000 / gr',
                        style: GoogleFonts.robotoSlab(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
