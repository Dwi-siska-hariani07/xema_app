import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class GoldScreen extends StatefulWidget {
  const GoldScreen({super.key});

  @override
  State<GoldScreen> createState() => _GoldScreenState();
}

class _GoldScreenState extends State<GoldScreen> {
  final TextEditingController _buyAmountController = TextEditingController(text: '100000');
  double _goldGrams = 5.2400;
  final double _pricePerGram = 2300000;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Investasi Emas',
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF570374),
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Color(0xFF570374)),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Kartu Portofolio Emas
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF52086B), Color(0xFF9B1DC7), Color(0xFFE5A93C)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF772096).withValues(alpha: 0.35),
                    blurRadius: 15,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Tabungan Emas Anda',
                        style: GoogleFonts.poppins(fontSize: 13, color: Colors.white.withValues(alpha: 0.9)),
                      ),
                      const Icon(Icons.shield_outlined, color: Colors.white, size: 20),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Rp 13.200.000',
                    style: GoogleFonts.robotoSlab(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '$_goldGrams Gram',
                      style: GoogleFonts.robotoSlab(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFFFFF176),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 25),

            // Harga Emas Hari Ini
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8F5FB),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFFF3D8FF)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Harga Beli', style: GoogleFonts.poppins(fontSize: 12, color: const Color(0xFF939393))),
                        const SizedBox(height: 4),
                        Text('Rp 2.300.000', style: GoogleFonts.robotoSlab(fontSize: 15, fontWeight: FontWeight.bold, color: const Color(0xFF2E7D32))),
                        Text('/gram', style: GoogleFonts.poppins(fontSize: 10, color: const Color(0xFF939393))),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8F5FB),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFFF3D8FF)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Harga Jual', style: GoogleFonts.poppins(fontSize: 12, color: const Color(0xFF939393))),
                        const SizedBox(height: 4),
                        Text('Rp 2.250.000', style: GoogleFonts.robotoSlab(fontSize: 15, fontWeight: FontWeight.bold, color: const Color(0xFFCA31FF))),
                        Text('/gram', style: GoogleFonts.poppins(fontSize: 10, color: const Color(0xFF939393))),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 25),

            Text(
              'Beli Emas Mulai Rp 10.000',
              style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.bold, color: const Color(0xFF570374)),
            ),
            const SizedBox(height: 10),

            TextField(
              controller: _buyAmountController,
              keyboardType: TextInputType.number,
              style: GoogleFonts.robotoSlab(fontSize: 18, fontWeight: FontWeight.bold),
              decoration: InputDecoration(
                prefixText: 'Rp ',
                filled: true,
                fillColor: const Color(0xFFF3D8FF),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
              ),
              onChanged: (_) => setState(() {}),
            ),

            const SizedBox(height: 10),

            // Estimasi Gramasi Didapat
            Builder(builder: (context) {
              double amt = double.tryParse(_buyAmountController.text) ?? 0;
              double estGrams = amt / _pricePerGram;
              return Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFF3D8FF),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Estimasi Emas Bertambah:', style: GoogleFonts.poppins(fontSize: 12, color: const Color(0xFF570374))),
                    Text(
                      '+${estGrams.toStringAsFixed(4)} Gram',
                      style: GoogleFonts.robotoSlab(fontSize: 13, fontWeight: FontWeight.bold, color: const Color(0xFF52086B)),
                    ),
                  ],
                ),
              );
            }),

            const SizedBox(height: 25),

            // Banner Tips Figma
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF9E6),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFFFD54F)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.lightbulb_outline, color: Color(0xFFE5A93C), size: 24),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'TIPS: Mulai investasi rutin tiap bulan agar untung maksimal! Bebas Biaya Admin 5x Sebulan.',
                      style: GoogleFonts.poppins(fontSize: 11, color: const Color(0xFF795548)),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 35),

            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 50,
                    child: OutlinedButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Pencairan Emas ke Saldo Xema berhasil diproses!')),
                        );
                      },
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Color(0xFFCA31FF), width: 1.5),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                      ),
                      child: Text('Jual Emas', style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.bold, color: const Color(0xFFCA31FF))),
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: SizedBox(
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          double amt = double.tryParse(_buyAmountController.text) ?? 0;
                          _goldGrams += amt / _pricePerGram;
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Pembelian Emas Berhasil! Saldo tabungan emas Anda telah bertambah.')),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFCA31FF),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                      ),
                      child: Text('Beli Emas', style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white)),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
