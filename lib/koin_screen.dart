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
      appBar: AppBar(
        title: Text(
          'XEMA POIN',
          style: GoogleFonts.poltawskiNowy(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF52086B),
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Kartu Total Poin Figma
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                color: const Color(0xFFE9CAF7),
                borderRadius: BorderRadius.circular(25),
                border: Border.all(color: const Color(0xFFCA31FF), width: 1.2),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x33772096),
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Image.asset(
                    'assets/images/coin_gold.png',
                    width: 60,
                    height: 60,
                    errorBuilder: (_, __, ___) => const Icon(
                      Icons.monetization_on,
                      color: Color(0xFFE5A93C),
                      size: 60,
                    ),
                  ),
                  const SizedBox(width: 18),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Total Poin Anda',
                        style: GoogleFonts.robotoSlab(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF570374),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '1.500 Poin',
                        style: GoogleFonts.robotoSlab(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF52086B),
                        ),
                      ),
                      Text(
                        'Setara Rp 150,00',
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: const Color(0xFF570374),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 25),

            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Tukar Poin ke Saldo Tunai',
                style: GoogleFonts.poppins(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF570374),
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Opsi Penukaran Figma
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
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                  decoration: BoxDecoration(
                    color: isSelected ? const Color(0xFFF3D8FF) : const Color(0xFFF8F5FB),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isSelected ? const Color(0xFFCA31FF) : const Color(0xFFE0E0E0),
                      width: isSelected ? 1.5 : 1,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.stars_rounded,
                            color: isSelected ? const Color(0xFFCA31FF) : const Color(0xFF939393),
                            size: 28,
                          ),
                          const SizedBox(width: 14),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${opt['poin']} POIN',
                                style: GoogleFonts.robotoSlab(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xFF1C0823),
                                ),
                              ),
                              Text(
                                opt['cash']!,
                                style: GoogleFonts.robotoSlab(
                                  fontSize: 13,
                                  color: const Color(0xFF570374),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Icon(
                        isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
                        color: isSelected ? const Color(0xFFCA31FF) : const Color(0xFF939393),
                      ),
                    ],
                  ),
                ),
              );
            }),

            const SizedBox(height: 16),

            // Banner Kumpulkan Lebih Banyak Poin
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFCA31FF), Color(0xFF772096)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'KUMPULKAN LEBIH BANYAK POIN!',
                          style: GoogleFonts.robotoSlab(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Lakukan transaksi harian untuk mendapat cashback poin hingga 10%!',
                          style: GoogleFonts.poppins(
                            fontSize: 11,
                            color: Colors.white.withValues(alpha: 0.9),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
                        title: const Text('Klaim Berhasil!'),
                        content: Text('Selamat! Penukaran $_selectedPoin ke saldo $_cashReward berhasil diajukan.'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('OK'),
                          ),
                        ],
                      );
                    },
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFCA31FF),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                ),
                child: Text(
                  'KLAIM SEKARANG',
                  style: GoogleFonts.robotoSlab(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
