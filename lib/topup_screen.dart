import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class TopUpScreen extends StatelessWidget {
  const TopUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const String vaNumber = '8801 0851 2343 5656';

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Isi Saldo Xema',
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
            // Kartu Virtual Account
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFCA31FF), Color(0xFF772096)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(22),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF772096).withValues(alpha: 0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Nomor Virtual Account Anda',
                    style: GoogleFonts.poppins(fontSize: 12, color: Colors.white.withValues(alpha: 0.85)),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        vaNumber,
                        style: GoogleFonts.robotoSlab(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 1.2,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Clipboard.setData(const ClipboardData(text: '8801085123435656'));
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Nomor Virtual Account berhasil disalin!')),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.copy, color: Colors.white, size: 14),
                              const SizedBox(width: 4),
                              Text('Salin', style: GoogleFonts.poppins(fontSize: 11, color: Colors.white)),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Akun: LISA ARUNIA',
                    style: GoogleFonts.poppins(fontSize: 12, color: const Color(0xFFF3D8FF)),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 25),

            Text(
              'Metode Pembayaran',
              style: GoogleFonts.poppins(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF570374),
              ),
            ),
            const SizedBox(height: 12),

            _buildPaymentMethod(
              icon: Icons.account_balance,
              title: 'Transfer Bank (BCA, Mandiri, BRI, BNI)',
              subtitle: 'Bebas biaya admin dengan Virtual Account',
            ),
            _buildPaymentMethod(
              icon: Icons.storefront,
              title: 'Gerai Ritel (Indomaret / Alfamart)',
              subtitle: 'Tunjukkan nomor VA ke kasir terdekat',
            ),
            _buildPaymentMethod(
              icon: Icons.qr_code_scanner,
              title: 'QRIS',
              subtitle: 'Pindai kode QR dari aplikasi m-banking apa saja',
            ),

            const SizedBox(height: 20),

            Text(
              'Petunjuk Pembayaran Transfer Bank',
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF570374),
              ),
            ),
            const SizedBox(height: 10),
            _buildStep('1. Buka aplikasi m-Banking atau ATM bank Anda.'),
            _buildStep('2. Pilih menu Transfer > Virtual Account.'),
            _buildStep('3. Masukkan nomor VA: 8801 0851 2343 5656.'),
            _buildStep('4. Masukkan nominal top up yang diinginkan.'),
            _buildStep('5. Ikuti instruksi sampai transaksi selesai dan saldo akan langsung bertambah.'),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentMethod({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F5FB),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF3D8FF)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFFF3D8FF),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: const Color(0xFF772096), size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.bold, color: const Color(0xFF1C0823)),
                ),
                Text(
                  subtitle,
                  style: GoogleFonts.poppins(fontSize: 11, color: const Color(0xFF939393)),
                ),
              ],
            ),
          ),
          const Icon(Icons.arrow_forward_ios, size: 14, color: Color(0xFF939393)),
        ],
      ),
    );
  }

  Widget _buildStep(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: GoogleFonts.poppins(fontSize: 12, color: const Color(0xFF570374), height: 1.4),
      ),
    );
  }
}
