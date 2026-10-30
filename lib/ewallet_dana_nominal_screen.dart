import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'ewallet_dana_confirm_screen.dart';

class EwalletDanaNominalScreen extends StatefulWidget {
  final String phoneNumber;

  const EwalletDanaNominalScreen({
    super.key,
    required this.phoneNumber,
  });

  @override
  State<EwalletDanaNominalScreen> createState() =>
      _EwalletDanaNominalScreenState();
}

class _EwalletDanaNominalScreenState extends State<EwalletDanaNominalScreen> {
  // Nominal input (default kosong)
  String _rawNominal = '';
  // Status keyboard aktif (default false saat masuk DANA2 awal)
  bool _isKeyboardOpen = false;

  void _onDigitTap(String digit) {
    if (_rawNominal.length < 10) {
      setState(() {
        _rawNominal += digit;
      });
    }
  }

  void _onDeleteTap() {
    if (_rawNominal.isNotEmpty) {
      setState(() {
        _rawNominal = _rawNominal.substring(0, _rawNominal.length - 1);
      });
    }
  }

  void _onCheckmarkTap() {
    // Sesuai alur permintaan pengguna:
    // "di bagian gambar ke 2 itu di emulator dia tidak ada button lanjutkan hanya muncul keyboard aja,
    // jika di klik centang di keyboard, keyboard hilang dan button lanjutkan berubah ungu aktif"
    setState(() {
      _isKeyboardOpen = false;
    });
  }

  // Format nominal rupiah dengan pemisah ribuan titik (contoh: 200000 -> 200.000)
  String _formattedNominal(String raw) {
    if (raw.isEmpty) return '';
    final number = int.tryParse(raw);
    if (number == null) return raw;

    final str = number.toString();
    final buffer = StringBuffer();
    int count = 0;
    for (int i = str.length - 1; i >= 0; i--) {
      buffer.write(str[i]);
      count++;
      if (count % 3 == 0 && i != 0) {
        buffer.write('.');
      }
    }
    return buffer.toString().split('').reversed.join('');
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final formattedValue = _formattedNominal(_rawNominal);
    final hasNominal = _rawNominal.isNotEmpty;

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

                    // =============================================================
                    // 3. KOTAK 2: MASUKAN NOMINAL (Tombol Rp)
                    // =============================================================
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
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                _isKeyboardOpen = true;
                              });
                            },
                            child: Container(
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
                                  // Garis kursor vertikal jika belum ada angka
                                  if (formattedValue.isEmpty)
                                    Container(
                                      width: 2,
                                      height: 22,
                                      color: const Color(0xFFBFBFBF),
                                    ),
                                  if (formattedValue.isNotEmpty)
                                    Expanded(
                                      child: Text(
                                        formattedValue,
                                        style: GoogleFonts.poppins(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w800,
                                          color: const Color(0xFF1E1E1E),
                                          letterSpacing: 0.5,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 22),

                    // =============================================================
                    // 4. KOTAK 3: REKENING SUMBER
                    // =============================================================
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Rekening Sumber',
                            style: GoogleFonts.poppins(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF1E1E1E),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            width: 345,
                            height: 80,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: const Color(0xFFE2E2E2),
                                width: 1.2,
                              ),
                              boxShadow: const [
                                BoxShadow(
                                  color: Color(0x18000000),
                                  blurRadius: 8,
                                  offset: Offset(0, 3),
                                ),
                              ],
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            child: Row(
                              children: [
                                Container(
                                  width: 48,
                                  height: 48,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFC736FE),
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                  alignment: Alignment.center,
                                  child: const Icon(
                                    Icons.person_outline_rounded,
                                    color: Colors.black,
                                    size: 28,
                                  ),
                                ),
                                const SizedBox(width: 14),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Rekening Sumber',
                                        style: GoogleFonts.poppins(
                                          fontSize: 13.5,
                                          fontWeight: FontWeight.w600,
                                          color: const Color(0xFF1E1E1E),
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        'Rp  300.000,00',
                                        style: GoogleFonts.poppins(
                                          fontSize: 13.5,
                                          fontWeight: FontWeight.w600,
                                          color: const Color(0xFF1E1E1E),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Text(
                                  'Ubah',
                                  style: GoogleFonts.poppins(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: const Color(0xFFCA31FF),
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
                // 5. TOMBOL "Lanjutkan" DI BAGIAN BAWAH
                // - Jika keyboard AKTIF (gambar 2): TIDAK ADA tombol Lanjutkan (hanya keyboard)
                // - Jika keyboard TIDAK AKTIF dan nominal KOSONG (gambar 1): tombol abu-abu
                // - Jika keyboard TIDAK AKTIF dan nominal TERISI (gambar 3): tombol ungu aktif
                // =============================================================
                if (!_isKeyboardOpen)
                  Positioned(
                    bottom: 60,
                    left: 28,
                    right: 28,
                    child: SizedBox(
                      height: 50,
                      child: ElevatedButton(
                        onPressed: hasNominal
                            ? () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => EwalletDanaConfirmScreen(
                                      phoneNumber: widget.phoneNumber,
                                      nominal: formattedValue,
                                    ),
                                  ),
                                );
                              }
                            : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: hasNominal
                              ? const Color(0xFFCA31FF) // Ungu aktif sesuai gambar 3
                              : const Color(0xFFD4D4D4), // Abu-abu sesuai gambar 1
                          disabledBackgroundColor: const Color(0xFFD4D4D4),
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
                // 6. KEYPAD NUMERIK 4x4 (Gambar 2)
                // Hanya muncul saat _isKeyboardOpen == true, tanpa tombol Lanjutkan
                // =============================================================
                if (_isKeyboardOpen)
                  Positioned(
                    bottom: 24,
                    left: 20,
                    right: 20,
                    height: 220,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Row 1
                        _buildKeypadRow([
                          _buildNumKey('1', () => _onDigitTap('1')),
                          _buildNumKey('2', () => _onDigitTap('2')),
                          _buildNumKey('3', () => _onDigitTap('3')),
                          _buildNumKey('-', () => _onDigitTap('-')),
                        ]),
                        // Row 2
                        _buildKeypadRow([
                          _buildNumKey('4', () => _onDigitTap('4')),
                          _buildNumKey('5', () => _onDigitTap('5')),
                          _buildNumKey('6', () => _onDigitTap('6')),
                          _buildCustomDashKey(),
                        ]),
                        // Row 3
                        _buildKeypadRow([
                          _buildNumKey('7', () => _onDigitTap('7')),
                          _buildNumKey('8', () => _onDigitTap('8')),
                          _buildNumKey('9', () => _onDigitTap('9')),
                          _buildActionKey(
                            icon: Icons.backspace_outlined,
                            size: 19,
                            onTap: _onDeleteTap,
                          ),
                        ]),
                        // Row 4
                        _buildKeypadRow([
                          _buildNumKey("'", () => _onDigitTap("'")),
                          _buildNumKey('0', () => _onDigitTap('0')),
                          _buildNumKey('.', () => _onDigitTap('.')),
                          _buildActionKey(
                            icon: Icons.check_rounded,
                            size: 24,
                            onTap: _onCheckmarkTap,
                          ),
                        ]),
                      ],
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

  Widget _buildNumKey(String value, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 78,
        height: 44,
        decoration: BoxDecoration(
          color: const Color(0xFFD9D9D9), // Tombol abu-abu Figma DANA3
          borderRadius: BorderRadius.circular(12),
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

  Widget _buildActionKey({
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
          color: const Color(0xFFD9D9D9), // Tombol abu-abu Figma DANA3
          borderRadius: BorderRadius.circular(12),
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

  Widget _buildCustomDashKey() {
    return GestureDetector(
      onTap: () => _onDigitTap('_'),
      child: Container(
        width: 78,
        height: 44,
        decoration: BoxDecoration(
          color: const Color(0xFFD9D9D9), // Tombol abu-abu Figma DANA3
          borderRadius: BorderRadius.circular(12),
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
