import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class TopUpScreen extends StatefulWidget {
  const TopUpScreen({super.key});

  @override
  State<TopUpScreen> createState() => _TopUpScreenState();
}

class _TopUpScreenState extends State<TopUpScreen> {
  // 1: Pilihan Metode Top Up (Figma 144:1077 & 144:1490)
  // 2: Detail Pembayaran Virtual Account (Figma 167:31)
  int _currentStep = 1;

  String _selectedMethod = 'Bank BRI';
  String _selectedVaNumber = '1120 8227 3013 438';

  final List<Map<String, dynamic>> _bankMethods = [
    {'name': 'Bank BRI', 'va': '1120 8227 3013 438', 'code': 'BRI', 'color': Color(0xFF00529C)},
    {'name': 'Bank BCA', 'va': '8801 0851 2343 5656', 'code': 'BCA', 'color': Color(0xFF005EAA)},
    {'name': 'Bank Mandiri', 'va': '8950 8227 3013 438', 'code': 'MANDIRI', 'color': Color(0xFF003D79)},
    {'name': 'Bank BNI', 'va': '9881 0851 2343 5656', 'code': 'BNI', 'color': Color(0xFFF37021)},
    {'name': 'Bank Syariah Indonesia (BSI)', 'va': '7243 0851 2343 565', 'code': 'BSI', 'color': Color(0xFF00A39D)},
    {'name': 'Bank Permata', 'va': '8450 8227 3013 438', 'code': 'PERMATA', 'color': Color(0xFF00833E)},
    {'name': 'Bank CIMB Niaga', 'va': '2329 0851 2343 5656', 'code': 'CIMB', 'color': Color(0xFF8B1D2C)},
    {'name': 'SeaBank', 'va': '7820 8227 3013 438', 'code': 'SEABANK', 'color': Color(0xFFF05A28)},
    {'name': 'Bank Lainnya', 'va': '1120 8227 3013 438', 'code': 'OTHER', 'color': Color(0xFF570374)},
  ];

  final List<Map<String, dynamic>> _retailMethods = [
    {'name': 'Indomaret', 'va': '8801 0851 2343 5656', 'color': Color(0xFF005EAA)},
    {'name': 'Alfamart / Alfamidi', 'va': '2329 0851 2343 5656', 'color': Color(0xFFD32F2F)},
    {'name': 'Kantor Pos Indonesia', 'va': '1120 8227 3013 438', 'color': Color(0xFFFF9800)},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildFigmaHeader(),
      body: SafeArea(
        child: _currentStep == 1 ? _buildSelectMethodStep() : _buildPaymentDetailStep(),
      ),
    );
  }

  // ==================== HEADER UNGU FIGMA (#D373FC) ====================
  PreferredSizeWidget _buildFigmaHeader() {
    return PreferredSize(
      preferredSize: const Size.fromHeight(65),
      child: Container(
        decoration: const BoxDecoration(
          color: Color(0xFFD373FC),
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new, color: Color(0xFF490461), size: 22),
                  onPressed: () {
                    if (_currentStep == 2) {
                      setState(() => _currentStep = 1);
                    } else {
                      Navigator.pop(context);
                    }
                  },
                ),
                Expanded(
                  child: Text(
                    'ISI SALDO',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.robotoSlab(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF490461),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.info_outline, color: Color(0xFF52086B), size: 22),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Pilih metode transfer bank atau gerai ritel untuk isi saldo Xema')),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // =========================================================================
  // STEP 1: PILIHAN METODE ISI SALDO (FIGMA FRAME #144:1077 & #144:1490)
  // =========================================================================
  Widget _buildSelectMethodStep() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section: Transfer Bank
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Transfer Bank',
                style: GoogleFonts.robotoSlab(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF52086B),
                ),
              ),
              const Icon(Icons.keyboard_arrow_down, color: Color(0xFF52086B)),
            ],
          ),
          const SizedBox(height: 12),

          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _bankMethods.length,
            separatorBuilder: (_, __) => const Divider(color: Color(0xFFF0F0F0), height: 1),
            itemBuilder: (context, index) {
              final bank = _bankMethods[index];
              final isSelected = _selectedMethod == bank['name'];

              return ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                leading: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: (bank['color'] as Color).withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Icon(Icons.account_balance, color: bank['color'] as Color, size: 22),
                  ),
                ),
                title: Text(
                  bank['name'],
                  style: GoogleFonts.robotoSlab(
                    fontSize: 15,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w400,
                    color: isSelected ? const Color(0xFF52086B) : Colors.black87,
                  ),
                ),
                trailing: isSelected
                    ? Container(
                        width: 24,
                        height: 24,
                        decoration: const BoxDecoration(
                          color: Color(0xFFCA31FF),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.check, color: Colors.white, size: 16),
                      )
                    : Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: const Color(0xFFD3D3D3), width: 1.5),
                        ),
                      ),
                onTap: () {
                  setState(() {
                    _selectedMethod = bank['name'];
                    _selectedVaNumber = bank['va'];
                  });
                },
              );
            },
          ),

          const SizedBox(height: 24),
          const Divider(color: Color(0xFFE5E5E5), thickness: 1),
          const SizedBox(height: 14),

          // Section: Gerai Ritel & Kantor Pos
          Text(
            'Gerai Ritel & Kantor Pos',
            style: GoogleFonts.robotoSlab(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF52086B),
            ),
          ),
          const SizedBox(height: 12),

          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _retailMethods.length,
            separatorBuilder: (_, __) => const Divider(color: Color(0xFFF0F0F0), height: 1),
            itemBuilder: (context, index) {
              final retail = _retailMethods[index];
              final isSelected = _selectedMethod == retail['name'];

              return ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                leading: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: (retail['color'] as Color).withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Icon(Icons.storefront_outlined, color: retail['color'] as Color, size: 22),
                  ),
                ),
                title: Text(
                  retail['name'],
                  style: GoogleFonts.robotoSlab(
                    fontSize: 15,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w400,
                    color: isSelected ? const Color(0xFF52086B) : Colors.black87,
                  ),
                ),
                trailing: isSelected
                    ? Container(
                        width: 24,
                        height: 24,
                        decoration: const BoxDecoration(
                          color: Color(0xFFCA31FF),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.check, color: Colors.white, size: 16),
                      )
                    : Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: const Color(0xFFD3D3D3), width: 1.5),
                        ),
                      ),
                onTap: () {
                  setState(() {
                    _selectedMethod = retail['name'];
                    _selectedVaNumber = retail['va'];
                  });
                },
              );
            },
          ),

          const SizedBox(height: 35),

          // Tombol Konfirmasi Figma (Rectangle 87)
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: () {
                setState(() => _currentStep = 2);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFCA31FF),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(26)),
              ),
              child: Text(
                'Konfirmasi',
                style: GoogleFonts.robotoSlab(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  // =========================================================================
  // STEP 2: DETAIL PEMBAYARAN VIRTUAL ACCOUNT (FIGMA FRAME #167:31)
  // =========================================================================
  Widget _buildPaymentDetailStep() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Kartu Pembayaran Virtual Account (Figma Group 133)
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFFCA31FF), width: 1.2),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF772096).withValues(alpha: 0.08),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Bank
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _selectedMethod,
                      style: GoogleFonts.robotoSlab(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF52086B),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF3D8FF),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        'Virtual Account',
                        style: GoogleFonts.poppins(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF570374),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),
                const Divider(color: Color(0xFFF3D8FF), thickness: 1),
                const SizedBox(height: 12),

                Text(
                  'No. Rek/Virtual Account',
                  style: GoogleFonts.robotoSlab(
                    fontSize: 14,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 6),

                // Nomor Virtual Account & Tombol Salin
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        _selectedVaNumber,
                        style: GoogleFonts.poppins(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFFCA31FF),
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Clipboard.setData(ClipboardData(text: _selectedVaNumber.replaceAll(' ', '')));
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Nomor Virtual Account berhasil disalin ke clipboard!'),
                            backgroundColor: Color(0xFF52086B),
                          ),
                        );
                      },
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF3D8FF),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: const Color(0xFFCA31FF), width: 0.8),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.copy, size: 14, color: Color(0xFF52086B)),
                            const SizedBox(width: 4),
                            Text(
                              'Salin',
                              style: GoogleFonts.robotoSlab(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF52086B),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                // Peringatan Minimal 10.000 Figma (#D32F2F)
                Text(
                  '* Minimal 10.000',
                  style: GoogleFonts.robotoSlab(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFFD32F2F),
                  ),
                ),

                const SizedBox(height: 14),
                const Divider(color: Color(0xFFF3D8FF), thickness: 1),
                const SizedBox(height: 12),

                // Deskripsi Resmi Figma
                Text(
                  'Transfer ke nomor Virtual Account di atas menggunakan $_selectedMethod. Saldo akan langsung masuk tanpa konfirmasi manual.',
                  style: GoogleFonts.robotoSlab(
                    fontSize: 14,
                    height: 1.5,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Instruksi Pembayaran (Accordion / ExpansionTile)
          Text(
            'Petunjuk Pembayaran',
            style: GoogleFonts.robotoSlab(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF52086B),
            ),
          ),
          const SizedBox(height: 12),

          _buildInstructionTile(
            title: 'Petunjuk Transfer Mobile Banking',
            steps: [
              'Buka aplikasi Mobile Banking ($_selectedMethod) Anda dan lakukan login.',
              'Pilih menu Transfer atau Pembayaran > Virtual Account / BRIVA.',
              'Masukkan nomor Virtual Account: $_selectedVaNumber.',
              'Masukkan nominal top up yang Anda inginkan (Minimal Rp 10.000).',
              'Periksa kembali data nama akun XEMA dan jumlah saldo.',
              'Masukkan PIN transaksi Mobile Banking Anda.',
              'Transaksi berhasil, saldo XEMA Anda otomatis bertambah!',
            ],
          ),

          const SizedBox(height: 10),

          _buildInstructionTile(
            title: 'Petunjuk Transfer ATM',
            steps: [
              'Masukkan kartu ATM dan PIN kartu Anda.',
              'Pilih menu Transaksi Lainnya > Pembayaran > Virtual Account.',
              'Ketikkan nomor Virtual Account: $_selectedVaNumber.',
              'Masukkan nominal pengisian saldo yang diinginkan.',
              'Konfirmasi rincian pembayaran pada layar ATM.',
              'Simpan struk ATM sebagai bukti transaksi pembayaran.',
            ],
          ),

          const SizedBox(height: 10),

          _buildInstructionTile(
            title: 'Petunjuk Transfer Internet Banking',
            steps: [
              'Login ke situs web Internet Banking bank Anda.',
              'Buka menu Pembayaran Tagihan > Virtual Account.',
              'Pilih rekening sumber dan masukkan nomor VA $_selectedVaNumber.',
              'Otorisasi transaksi menggunakan token bank Anda.',
            ],
          ),

          const SizedBox(height: 35),

          // Tombol OK Figma (Rectangle 87)
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFCA31FF),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(26)),
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
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildInstructionTile({required String title, required List<String> steps}) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFFBF8FD),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFEBD4FA)),
      ),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        title: Text(
          title,
          style: GoogleFonts.robotoSlab(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF52086B),
          ),
        ),
        iconColor: const Color(0xFF772096),
        childrenPadding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
        children: steps.asMap().entries.map((entry) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 22,
                  height: 22,
                  decoration: const BoxDecoration(
                    color: Color(0xFFF3D8FF),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      '${entry.key + 1}',
                      style: GoogleFonts.poppins(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF52086B),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    entry.value,
                    style: GoogleFonts.poppins(
                      fontSize: 12.5,
                      height: 1.4,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}
