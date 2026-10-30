import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'ewallet_dana_nominal_screen.dart';

class EwalletDanaInputScreen extends StatefulWidget {
  const EwalletDanaInputScreen({super.key});

  @override
  State<EwalletDanaInputScreen> createState() => _EwalletDanaInputScreenState();
}

class _EwalletDanaInputScreenState extends State<EwalletDanaInputScreen> {
  // Nomor handphone yang diketik
  String _phoneNumber = '';
  // State keyboard numerik: default terbuka, ditutup jika klik tombol centang ✓
  bool _isKeyboardVisible = true;

  void _onNumberTap(String number) {
    if (_phoneNumber.length < 15) {
      setState(() {
        _phoneNumber += number;
      });
    }
  }

  void _onDeleteTap() {
    if (_phoneNumber.isNotEmpty) {
      setState(() {
        _phoneNumber = _phoneNumber.substring(0, _phoneNumber.length - 1);
      });
    }
  }

  void _onCheckmarkTap() {
    // Sesuai logika permintaan pengguna:
    // "setelah memasukan nomor hp saya klik centang keyboardnya hilang tapi ada tambahkan button lanjutkan seperti gambar ke 3"
    setState(() {
      _isKeyboardVisible = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

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
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // =============================================================
                    // 1. HEADER UNGU FIGMA
                    // Berisi: Tombol Back (Ungu Tua #52086B), Judul "E-Wallet" (Ungu Tua #52086B), Icon Dompet Ungu Tua
                    // =============================================================
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
                          // Icon dompet ungu tua
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

                    // =============================================================
                    // 2. KOTAK 1: NAMA MERCHANT (DANA)
                    // Saat keyboard aktif: border highlight biru muda Figma
                    // Saat keyboard tutup / DANA1: border abu-abu halus / shadow subtle Figma
                    // =============================================================
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
                                color: _isKeyboardVisible
                                    ? const Color(0xFF00A2FD) // Highlight biru frame DANA
                                    : const Color(0xFFE2E2E2), // Frame DANA1
                                width: _isKeyboardVisible ? 2.5 : 1.5,
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

                    const SizedBox(height: 24),

                    // =============================================================
                    // 3. KOTAK 2: NOMOR HANDPHONE / REKENING
                    // Klik pada kotak akan memunculkan kembali keyboard jika tertutup
                    // =============================================================
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
                          GestureDetector(
                            onTap: () {
                              if (!_isKeyboardVisible) {
                                setState(() {
                                  _isKeyboardVisible = true;
                                });
                              }
                            },
                            child: Container(
                              width: 345,
                              height: 54,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: const Color(0xFFD6D6D6),
                                  width: 1.5,
                                ),
                              ),
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      _phoneNumber.isEmpty ? '' : _phoneNumber,
                                      style: GoogleFonts.poppins(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: const Color(0xFF1E1E1E),
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                                  ),
                                  // Icon buku kontak ungu
                                  Image.asset(
                                    'assets/images/ewallet_contact_icon.png',
                                    width: 22,
                                    height: 22,
                                    fit: BoxFit.contain,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                // =============================================================
                // 4. TOMBOL "Lanjutkan" (Gambar 3 / Frame DANA1)
                // Muncul saat keyboard hilang setelah klik tombol centang ✓
                // =============================================================
                if (!_isKeyboardVisible)
                  Positioned(
                    bottom: 60,
                    left: 28,
                    right: 28,
                    child: SizedBox(
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {
                          // Aksi Lanjutkan ke tahap DANA2 berikutnya (pilih nominal)
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EwalletDanaNominalScreen(
                                phoneNumber: _phoneNumber,
                              ),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFCA31FF), // Warna ungu tombol Figma #CA31FF
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: Text(
                          'Lanjutkan',
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),

                // =============================================================
                // 5. KEYPAD NUMERIK 4x4 (Gambar 2 / Figma Frame DANA)
                // Didesain lebih proporsional & compact (tidak terlalu besar)
                // =============================================================
                if (_isKeyboardVisible)
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    height: 260, // Ukuran lebih compact sesuai gambar 2
                    child: Container(
                      color: const Color(0xFFD9D9D9), // Background abu-abu keypad Figma
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Row 1: 1, 2, 3, -
                          _buildKeypadRow([
                            _buildKeyBtn('1', () => _onNumberTap('1')),
                            _buildKeyBtn('2', () => _onNumberTap('2')),
                            _buildKeyBtn('3', () => _onNumberTap('3')),
                            _buildKeyBtn('-', () => _onNumberTap('-')),
                          ]),
                          // Row 2: 4, 5, 6, [bracket dash]
                          _buildKeypadRow([
                            _buildKeyBtn('4', () => _onNumberTap('4')),
                            _buildKeyBtn('5', () => _onNumberTap('5')),
                            _buildKeyBtn('6', () => _onNumberTap('6')),
                            _buildCustomDashBtn(),
                          ]),
                          // Row 3: 7, 8, 9, ⌫
                          _buildKeypadRow([
                            _buildKeyBtn('7', () => _onNumberTap('7')),
                            _buildKeyBtn('8', () => _onNumberTap('8')),
                            _buildKeyBtn('9', () => _onNumberTap('9')),
                            _buildActionIconBtn(
                              icon: Icons.backspace_outlined,
                              size: 19,
                              onTap: _onDeleteTap,
                            ),
                          ]),
                          // Row 4: ' , 0 , . , ✓
                          _buildKeypadRow([
                            _buildKeyBtn("'", () => _onNumberTap("'")),
                            _buildKeyBtn('0', () => _onNumberTap('0')),
                            _buildKeyBtn('.', () => _onNumberTap('.')),
                            _buildActionIconBtn(
                              icon: Icons.check_rounded,
                              size: 24,
                              onTap: _onCheckmarkTap,
                            ),
                          ]),
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

  Widget _buildKeypadRow(List<Widget> buttons) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: buttons,
    );
  }

  Widget _buildKeyBtn(String value, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 78,
        height: 44, // Tinggi proporsional lebih compact
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [
            BoxShadow(
              color: Color(0x1A000000),
              blurRadius: 2,
              offset: Offset(0, 1),
            ),
          ],
        ),
        alignment: Alignment.center,
        child: Text(
          value,
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF1E1E1E),
          ),
        ),
      ),
    );
  }

  Widget _buildActionIconBtn({
    required IconData icon,
    required double size,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 78,
        height: 44,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [
            BoxShadow(
              color: Color(0x1A000000),
              blurRadius: 2,
              offset: Offset(0, 1),
            ),
          ],
        ),
        alignment: Alignment.center,
        child: Icon(
          icon,
          size: size,
          color: const Color(0xFF1E1E1E),
        ),
      ),
    );
  }

  Widget _buildCustomDashBtn() {
    return GestureDetector(
      onTap: () => _onNumberTap('_'),
      child: Container(
        width: 78,
        height: 44,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [
            BoxShadow(
              color: Color(0x1A000000),
              blurRadius: 2,
              offset: Offset(0, 1),
            ),
          ],
        ),
        alignment: Alignment.center,
        child: CustomPaint(
          size: const Size(16, 6),
          painter: _BottomBracketPainter(),
        ),
      ),
    );
  }
}

class _BottomBracketPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF1E1E1E)
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.square
      ..style = PaintingStyle.stroke;

    final path = Path();
    path.moveTo(0, 0);
    path.lineTo(0, size.height);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 0);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
