import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'beranda_screen.dart';

class PinScreen extends StatefulWidget {
  const PinScreen({super.key});

  @override
  State<PinScreen> createState() => _PinScreenState();
}

class _PinScreenState extends State<PinScreen> {
  // PIN tersimpan (maksimal 6 digit)
  String _enteredPin = '';

  // Status popup modal "Successfull"
  bool _showSuccessPopup = false;

  void _onNumberTap(String number) {
    if (_enteredPin.length < 6) {
      setState(() {
        _enteredPin += number;
      });
    }
  }

  void _onDeleteTap() {
    if (_enteredPin.isNotEmpty) {
      setState(() {
        _enteredPin = _enteredPin.substring(0, _enteredPin.length - 1);
      });
    }
  }

  void _onCheckmarkTap() {
    // Menampilkan popup "Successfull"
    setState(() {
      _showSuccessPopup = true;
    });
  }

  void _onGoToHome() {
    // Alur selesai: langsung menuju Beranda
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const BerandaScreen()),
      (route) => false,
    );
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
              clipBehavior: Clip.none,
              children: [
                // =============================================================
                // 1. TOMBOL BACK (Lingkaran hitam panah kiri sesuai Figma)
                // =============================================================
                Positioned(
                  top: 68,
                  left: 48,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: const Color(0xFF1E1E1E),
                          width: 2.2,
                        ),
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.arrow_back,
                          color: Color(0xFF1E1E1E),
                          size: 24,
                        ),
                      ),
                    ),
                  ),
                ),

                // =============================================================
                // 2. ICON KUNCI (Rounded Box Hitam + Kunci Ungu Bersih 100%)
                // =============================================================
                Positioned(
                  top: 125,
                  left: (393 - 82) / 2,
                  width: 82,
                  height: 82,
                  child: Image.asset(
                    'assets/images/figma_pin_key_icon.png',
                    fit: BoxFit.contain,
                  ),
                ),

                // =============================================================
                // 3. JUDUL: "Konfirmasi PIN"
                // =============================================================
                Positioned(
                  top: 228,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Text(
                      'Konfirmasi PIN',
                      style: GoogleFonts.poppins(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF0F0B13),
                        letterSpacing: 0.1,
                      ),
                    ),
                  ),
                ),

                // =============================================================
                // 4. SUBTITLE: "Masukkan 6-digit PIN Trasaksi kamu"
                // =============================================================
                Positioned(
                  top: 268,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Text(
                      'Masukkan 6-digit PIN Trasaksi kamu',
                      style: GoogleFonts.pochaevsk(
                        fontSize: 14,
                        fontWeight: FontWeight.normal,
                        color: const Color(0xFF4C4253),
                      ),
                    ),
                  ),
                ),

                // =============================================================
                // 5. INDIKATOR PIN: Bulatan kosong jika belum diisi,
                //    atau Angka yang diketik jika sudah diisi (sesuai variasi Figma)
                // =============================================================
                Positioned(
                  top: 338,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: _buildPinIndicator(),
                  ),
                ),

                // =============================================================
                // 6. TEKS "Lupa PIN?" (Warna Ungu)
                // =============================================================
                Positioned(
                  top: 418,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: GestureDetector(
                      onTap: () {
                        // Dapat diarahkan jika diinginkan
                      },
                      child: Text(
                        'Lupa PIN?',
                        style: GoogleFonts.pochaevsk(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF7F26A5),
                        ),
                      ),
                    ),
                  ),
                ),

                // =============================================================
                // 7. KEYPAD NUMERIK FIGMA (3 Kolom x 4 Baris)
                // Row 1: 1, 2, 3
                // Row 2: 4, 5, 6
                // Row 3: 7, 8, 9
                // Row 4: [Kosong], 0, [Tombol Centang Ungu / Hapus]
                // =============================================================
                Positioned(
                  top: 480,
                  left: 45,
                  right: 45,
                  child: Column(
                    children: [
                      // Row 1
                      _buildKeypadRow(['1', '2', '3']),
                      const SizedBox(height: 28),
                      // Row 2
                      _buildKeypadRow(['4', '5', '6']),
                      const SizedBox(height: 28),
                      // Row 3
                      _buildKeypadRow(['7', '8', '9']),
                      const SizedBox(height: 28),
                      // Row 4
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Kolom kiri (kosong)
                          const SizedBox(width: 60, height: 50),

                          // Kolom tengah: Angka 0
                          _buildNumberKey('0'),

                          // Kolom kanan: Centang Ungu jika sudah isi, atau Hapus
                          SizedBox(
                            width: 60,
                            height: 50,
                            child: _enteredPin.length == 6
                                ? GestureDetector(
                                    onTap: _onCheckmarkTap,
                                    child: Center(
                                      child: Container(
                                        width: 44,
                                        height: 44,
                                        decoration: const BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Color(0xFFCA30FE),
                                        ),
                                        child: const Icon(
                                          Icons.check_rounded,
                                          color: Colors.white,
                                          size: 28,
                                        ),
                                      ),
                                    ),
                                  )
                                : GestureDetector(
                                    onTap: _onDeleteTap,
                                    child: Center(
                                      child: Container(
                                        width: 40,
                                        height: 30,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(6),
                                          border: Border.all(
                                            color: const Color(0xFF1E1E1E),
                                            width: 1.8,
                                          ),
                                        ),
                                        child: const Center(
                                          child: Icon(
                                            Icons.close_rounded,
                                            size: 20,
                                            color: Color(0xFF1E1E1E),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // =============================================================
                // 8. MODAL DIALOG "Successfull" (Frame: Konfirmasi PIN akun2)
                // Muncul saat PIN 6 digit selesai dikonfirmasi
                // =============================================================
                if (_showSuccessPopup) ...[
                  // Dimmed overlay background
                  Positioned.fill(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _showSuccessPopup = false;
                        });
                      },
                      child: Container(
                        color: const Color(0xFFE8E8E8).withValues(alpha: 0.85),
                      ),
                    ),
                  ),

                  // Popup Dialog Card
                  Positioned(
                    top: 290,
                    left: (393 - 295) / 2,
                    width: 295,
                    height: 275,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.12),
                            blurRadius: 24,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 24,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Lingkaran Centang Ungu Figma
                          Container(
                            width: 68,
                            height: 68,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color(0xFFCA30FE),
                            ),
                            child: const Icon(
                              Icons.check_rounded,
                              size: 44,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Teks "Successfull"
                          Text(
                            'Successfull',
                            style: GoogleFonts.poppins(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF1E1E1E),
                            ),
                          ),
                          const SizedBox(height: 6),

                          // Subtitle teks
                          Text(
                            'Your account is successfully\ncreated.',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(
                              fontSize: 12.5,
                              fontWeight: FontWeight.normal,
                              color: const Color(0xFF555555),
                              height: 1.35,
                            ),
                          ),
                          const SizedBox(height: 18),

                          // Tombol "Go to home"
                          SizedBox(
                            width: 190,
                            height: 44,
                            child: ElevatedButton(
                              onPressed: _onGoToHome,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFB952DD),
                                shape: RoundedRectangle100PercentBorder(),
                                elevation: 0,
                              ),
                              child: Text(
                                'Go to home',
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPinIndicator() {
    if (_enteredPin.isEmpty) {
      // 6 Bulatan abu-abu terang sesuai Figma awal
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(6, (index) {
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 8),
            width: 15,
            height: 15,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xFFD6D6D6),
            ),
          );
        }),
      );
    } else {
      // Menampilkan angka-angka yang sudah diketik sejajar (misal: 1 2 3 ...)
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(6, (index) {
          final hasChar = index < _enteredPin.length;
          final char = hasChar ? _enteredPin[index] : '';
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 10),
            width: 22,
            alignment: Alignment.center,
            child: Text(
              hasChar ? char : '•',
              style: GoogleFonts.poppins(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: hasChar ? const Color(0xFF1E1E1E) : const Color(0xFFBDBDBD),
              ),
            ),
          );
        }),
      );
    }
  }

  Widget _buildKeypadRow(List<String> numbers) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: numbers.map((n) => _buildNumberKey(n)).toList(),
    );
  }

  Widget _buildNumberKey(String number) {
    return GestureDetector(
      onTap: () => _onNumberTap(number),
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: 60,
        height: 50,
        alignment: Alignment.center,
        child: Text(
          number,
          style: GoogleFonts.poppins(
            fontSize: 24,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF1E1E1E),
          ),
        ),
      ),
    );
  }
}

class RoundedRectangle100PercentBorder extends RoundedRectangleBorder {
  RoundedRectangle100PercentBorder()
      : super(borderRadius: BorderRadius.circular(100));
}

