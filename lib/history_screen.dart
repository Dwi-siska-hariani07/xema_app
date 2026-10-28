import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> transactions = [
      {
        'title': 'Pembayaran e-Wallet Berhasil ke JENNY ROSA',
        'date': '5 Okt 2026, 21:00',
        'amount': '-Rp 50.000',
        'isIncome': false,
        'category': 'E-Wallet',
        'icon': Icons.account_balance_wallet_outlined,
      },
      {
        'title': 'Top Up Saldo via Virtual Account BCA',
        'date': '3 Okt 2026, 14:20',
        'amount': '+Rp 2.000.000',
        'isIncome': true,
        'category': 'Top Up',
        'icon': Icons.add_circle_outline,
      },
      {
        'title': 'Pembelian Token Listrik PLN',
        'date': '2 Okt 2026, 10:15',
        'amount': '-Rp 101.500',
        'isIncome': false,
        'category': 'PLN',
        'icon': Icons.bolt,
      },
      {
        'title': 'Top Up Game Mobile Legends 250 Diamonds',
        'date': '1 Okt 2026, 09:18',
        'amount': '-Rp 70.000',
        'isIncome': false,
        'category': 'Game',
        'icon': Icons.sports_esports_outlined,
      },
      {
        'title': 'Investasi Pembelian Emas 0,0434 Gram',
        'date': '30 Sep 2026, 18:45',
        'amount': '-Rp 100.000',
        'isIncome': false,
        'category': 'Emas',
        'icon': Icons.monetization_on_outlined,
      },
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Riwayat Transaksi',
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF570374),
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text(
            'Oktober 2026',
            style: GoogleFonts.robotoSlab(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF570374),
            ),
          ),
          const SizedBox(height: 12),
          ...transactions.map((tx) {
            final isIncome = tx['isIncome'] as bool;
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFFF8F5FB),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: const Color(0xFFF3D8FF)),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: isIncome ? const Color(0xFFE8F5E9) : const Color(0xFFF3D8FF),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      tx['icon'] as IconData,
                      color: isIncome ? const Color(0xFF2E7D32) : const Color(0xFF772096),
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          tx['title'] as String,
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF1C0823),
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          tx['date'] as String,
                          style: GoogleFonts.poppins(
                            fontSize: 10,
                            color: const Color(0xFF939393),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    tx['amount'] as String,
                    style: GoogleFonts.robotoSlab(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: isIncome ? const Color(0xFF2E7D32) : const Color(0xFFCA31FF),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}

