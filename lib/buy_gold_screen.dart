import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import 'core/app_icons.dart';

class BuyGoldScreen extends StatefulWidget {
  final double pricePerGram;
  final Function(double gramsBought, double rupiahSpent)? onBuySuccess;

  const BuyGoldScreen({
    super.key,
    this.pricePerGram = 2300000, // Harga beli: Rp 2.300.000 / gr (Node 211:1033)
    this.onBuySuccess,
  });

  @override
  State<BuyGoldScreen> createState() => _BuyGoldScreenState();
}

class _BuyGoldScreenState extends State<BuyGoldScreen> {
  // Controller
  final TextEditingController _amountController = TextEditingController();

  // State Nominal & Data
  double _nominalRupiah = 0;
  final double _saldoXema = 76565000; // Rp 76.565.000,00 sesuai Figma Node 296:928

  // State Responsif Keypad Figma (seperti di Transfer)
  bool _isKeypadOpen = false;

  // Stage Flow:
  // 0 = Input Beli Emas (Nodes 224:265 & 296:928)
  // 1 = Layar Konfirmasi Pembelian (Node 224:176 "investasi pembayaran emas")
  // 2 = Layar Masukkan PIN (Node 270:258)
  // 3 = Layar Bukti Transaksi Resi Sukses (Node 403:671)
  int _currentStep = 0;
  String _pin = '';

  @override
  void initState() {
    super.initState();
    HardwareKeyboard.instance.addHandler(_handleHardwareKey);
  }

  @override
  void dispose() {
    HardwareKeyboard.instance.removeHandler(_handleHardwareKey);
    _amountController.dispose();
    super.dispose();
  }

  // Dukungan input keyboard fisik laptop/PC & keypad layar
  bool _handleHardwareKey(KeyEvent event) {
    if (event is! KeyDownEvent && event is! KeyRepeatEvent) return false;

    final key = event.logicalKey;
    final char = event.character;

    // Handle saat di Layar PIN (Step 2)
    if (_currentStep == 2) {
      if (key == LogicalKeyboardKey.backspace || key == LogicalKeyboardKey.delete) {
        _handlePinDelete();
        return true;
      }
      if (char != null && RegExp(r'^[0-9]$').hasMatch(char)) {
        _handlePinDigit(char);
        return true;
      }
      return false;
    }

    // Handle saat di Layar Input Beli Emas (Step 0)
    if (_currentStep == 0) {
      if (key == LogicalKeyboardKey.backspace || key == LogicalKeyboardKey.delete) {
        _handleKeypadDelete();
        return true;
      }
      if (char != null && RegExp(r'^[0-9]$').hasMatch(char)) {
        _handleKeypadDigit(char);
        return true;
      }
      if (key == LogicalKeyboardKey.enter || key == LogicalKeyboardKey.numpadEnter) {
        _handleKeypadSubmit();
        return true;
      }
    }

    return false;
  }

  // Pengetikan Keypad Angka
  void _handleKeypadDigit(String digit) {
    setState(() {
      final currentStr = _nominalRupiah > 0 ? _nominalRupiah.round().toString() : '';
      if (currentStr.length < 10) {
        final newStr = currentStr + digit;
        _nominalRupiah = double.tryParse(newStr) ?? 0;
        _amountController.text = _formatNumber(_nominalRupiah);
      }
    });
  }

  void _handleKeypadDelete() {
    setState(() {
      final currentStr = _nominalRupiah > 0 ? _nominalRupiah.round().toString() : '';
      if (currentStr.isNotEmpty) {
        final newStr = currentStr.substring(0, currentStr.length - 1);
        _nominalRupiah = double.tryParse(newStr) ?? 0;
        _amountController.text = _nominalRupiah > 0 ? _formatNumber(_nominalRupiah) : '';
      }
    });
  }

  void _handleKeypadSubmit() {
    setState(() {
      _isKeypadOpen = false;
    });
  }

  // Format angka ribuan dengan font Poppins
  String _formatNumber(num number) {
    final str = number.round().toString();
    final buffer = StringBuffer();
    for (int i = 0; i < str.length; i++) {
      if (i > 0 && (str.length - i) % 3 == 0) {
        buffer.write('.');
      }
      buffer.write(str[i]);
    }
    return buffer.toString();
  }

  void _setAmount(double amount) {
    setState(() {
      _nominalRupiah = amount;
      _amountController.text = _formatNumber(amount);
    });
  }

  // Ikon 4 Balok Kuning Emas di Pojok Kanan Atas Header (#FFD900)
  Widget _buildStaircaseChartIcon() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildSingleBar(height: 10),
        const SizedBox(width: 3.5),
        _buildSingleBar(height: 16),
        const SizedBox(width: 3.5),
        _buildSingleBar(height: 22),
        const SizedBox(width: 3.5),
        _buildSingleBar(height: 28),
      ],
    );
  }

  Widget _buildSingleBar({required double height}) {
    return Container(
      width: 5.5,
      height: height,
      decoration: BoxDecoration(
        color: const Color(0xFFFFD900),
        borderRadius: BorderRadius.circular(1.5),
      ),
    );
  }

  // Kartu Pilihan Cepat (2x2 Grid)
  Widget _buildQuickChoiceCard(String label, double value) {
    final bool isSelected = _nominalRupiah == value;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          _setAmount(value);
        },
        child: Container(
          height: 63,
          decoration: BoxDecoration(
            color: const Color(0xFFF3D8FF),
            borderRadius: BorderRadius.circular(10),
            border: isSelected
                ? Border.all(color: const Color(0xFFCA31FF), width: 2)
                : null,
            boxShadow: const [
              BoxShadow(
                color: Color(0x10000000),
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Center(
            child: Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
        ),
      ),
    );
  }

  // =========================================================================
  // KEYBOARD 4-KOLOM OTENTIK FIGMA (PERSIS SEPERTI DI MENU TRANSFER #246:49)
  // =========================================================================
  Widget _buildFigma4ColKeypad({
    required Function(String) onDigit,
    required VoidCallback onDelete,
    required VoidCallback onSubmit,
  }) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildFigmaKey('1', () => onDigit('1')),
              _buildFigmaKey('2', () => onDigit('2')),
              _buildFigmaKey('3', () => onDigit('3')),
              _buildFigmaKey('-', () => onDigit('-')),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildFigmaKey('4', () => onDigit('4')),
              _buildFigmaKey('5', () => onDigit('5')),
              _buildFigmaKey('6', () => onDigit('6')),
              _buildFigmaKey(
                'space',
                () => onDigit(' '),
                customChild: Container(
                  width: 26,
                  height: 9,
                  decoration: const BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: Colors.black, width: 2.6),
                      left: BorderSide(color: Colors.black, width: 2.6),
                      right: BorderSide(color: Colors.black, width: 2.6),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildFigmaKey('7', () => onDigit('7')),
              _buildFigmaKey('8', () => onDigit('8')),
              _buildFigmaKey('9', () => onDigit('9')),
              _buildFigmaKey('del', onDelete, icon: Icons.backspace_outlined),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildFigmaKey(',', () => onDigit(',')),
              _buildFigmaKey('0', () => onDigit('0')),
              _buildFigmaKey('.', () => onDigit('.')),
              _buildFigmaKey('ok', onSubmit, icon: Icons.check),
            ],
          ),
          const SizedBox(height: 4),
        ],
      ),
    );
  }

  Widget _buildFigmaKey(
    String label,
    VoidCallback onTap, {
    IconData? icon,
    Widget? customChild,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        width: 76,
        height: 48,
        decoration: BoxDecoration(
          color: const Color(0xFFD9D9D9),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: customChild ??
              (icon != null
                  ? Icon(icon, color: Colors.black, size: 22)
                  : Text(
                      label,
                      style: GoogleFonts.poppins(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    )),
        ),
      ),
    );
  }

  // ==========================================
  // STAGE 1 (Figma Node 224:176): Layar Konfirmasi Pembelian "investasi pembayaran emas"
  // ==========================================
  Widget _buildKonfirmasiScreen(double gramsAdded) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            // 1. Header (Tinggi 90px, Background #D373FC, Seamless)
            Container(
              width: double.infinity,
              height: 90,
              color: const Color(0xFFD373FC),
              padding: const EdgeInsets.only(top: 36, left: 16, right: 20),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _currentStep = 0; // Kembali ke layar input beli
                      });
                    },
                    behavior: HitTestBehavior.opaque,
                    child: const Icon(
                      Icons.arrow_back,
                      color: Color(0xFF52086B),
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Text(
                    'BELI',
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

            // 2. Body Konfirmasi Sesuai Screenshot Figma Node 224:176
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Card 1: Tabungan Emas
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF3D8FF),
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x10000000),
                            blurRadius: 6,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Tabungan Emas',
                            style: GoogleFonts.robotoSlab(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '${gramsAdded.toStringAsFixed(4).replaceAll('.', ', ')} Gram',
                            style: GoogleFonts.robotoSlab(
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text.rich(
                            TextSpan(
                              text: 'Harga Beli: ',
                              style: GoogleFonts.robotoSlab(
                                fontSize: 14,
                                color: Colors.black,
                              ),
                              children: [
                                TextSpan(
                                  text: 'Rp ${_formatNumber(widget.pricePerGram)}/ gr',
                                  style: GoogleFonts.poppins(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Label: Metode Pembayaran
                    Text(
                      'Metode Pembayaran',
                      style: GoogleFonts.robotoSlab(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Card 2: Rekening Sumber (XEMA)
                    Container(
                      width: double.infinity,
                      height: 96,
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF3D8FF),
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x12000000),
                            blurRadius: 6,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Stack(
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                width: 52,
                                height: 46,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFCA31FF),
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                child: const Icon(
                                  Icons.person,
                                  color: Colors.black,
                                  size: 26,
                                ),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Rekening Sumber (XEMA)',
                                      style: GoogleFonts.robotoSlab(
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                    const SizedBox(height: 3),
                                    Text.rich(
                                      TextSpan(
                                        text: 'Rp ',
                                        style: GoogleFonts.robotoSlab(fontSize: 12, color: Colors.black),
                                        children: [
                                          TextSpan(
                                            text: '${_formatNumber(_saldoXema)},00',
                                            style: GoogleFonts.poppins(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.black,
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
                          Positioned(
                            right: 4,
                            bottom: 2,
                            child: Text(
                              '0851 2343 5656',
                              style: GoogleFonts.poppins(
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 28),

                    // Card 3: Detail Transaksi
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF3D8FF),
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x12000000),
                            blurRadius: 6,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Detail Transaksi',
                            style: GoogleFonts.robotoSlab(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 14),
                          _buildDetailRow(
                            'Nominal Pembelian',
                            'Rp${_formatNumber(_nominalRupiah)}',
                            isBold: true,
                            isNumber: true,
                          ),
                          const SizedBox(height: 6),
                          _buildDetailRow(
                            'Biaya Admin',
                            'Gratis',
                            isHighlight: true,
                          ),
                          const SizedBox(height: 10),
                          const Divider(
                            color: Color(0xFF52086B),
                            thickness: 0.8,
                            height: 16,
                          ),
                          const SizedBox(height: 6),
                          _buildDetailRow(
                            'Total Pembayaran',
                            'Rp${_formatNumber(_nominalRupiah)}',
                            isBold: true,
                            isNumber: true,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 48),
                  ],
                ),
              ),
            ),

            // 3. Tombol Konfirmasi Bawah (Stadium Pill Ungu #CA31FF)
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, bottom: 28),
              child: SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFCA31FF),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    elevation: 0,
                  ),
                  onPressed: () {
                    setState(() {
                      _pin = '';
                      _currentStep = 2; // Ke Layar Masukkan PIN (Node 270:258)
                    });
                  },
                  child: Text(
                    'Konfirmasi',
                    style: GoogleFonts.robotoSlab(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, {bool isBold = false, bool isHighlight = false, bool isNumber = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            label,
            style: GoogleFonts.robotoSlab(
              fontSize: 14,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              color: Colors.black,
            ),
          ),
        ),
        Text(
          value,
          style: isHighlight
              ? GoogleFonts.robotoSlab(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFFFF383C), // Merah cerah seperti di screenshot
                )
              : (isNumber
                  ? GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
                      color: Colors.black,
                    )
                  : GoogleFonts.robotoSlab(
                      fontSize: 14,
                      fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
                      color: Colors.black,
                    )),
        ),
      ],
    );
  }

  // ==========================================
  // STAGE 2 (Figma Node 270:258): Layar Konfirmasi PIN
  // Muncul angka ketika diklik (sama seperti transfer)
  // ==========================================
  void _handlePinDigit(String digit) {
    if (_pin.length < 6) {
      setState(() {
        _pin += digit;
      });
      if (_pin.length == 6) {
        Future.delayed(const Duration(milliseconds: 300), () {
          if (mounted) {
            setState(() {
              _currentStep = 3; // Masuk ke Bukti Transaksi (Node 403:671)
            });
          }
        });
      }
    }
  }

  void _handlePinDelete() {
    if (_pin.isNotEmpty) {
      setState(() {
        _pin = _pin.substring(0, _pin.length - 1);
      });
    }
  }

  Widget _buildPinScreen() {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const SizedBox(height: 12),
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _pin = '';
                        _currentStep = 1; // Kembali ke layar Konfirmasi Pembelian (Node 224:176)
                      });
                    },
                    child: AppIcons.buildImageOrIcon(
                      AppIcons.icBackCircle,
                      width: 44,
                      height: 44,
                      fallbackIcon: Icons.arrow_circle_left_outlined,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Ikon Kunci Ungu
              Center(
                child: AppIcons.buildImageOrIcon(
                  AppIcons.icPinKey,
                  width: 90,
                  height: 90,
                  fallbackIcon: Icons.key_rounded,
                  fallbackColor: const Color(0xFFCA31FF),
                ),
              ),
              const SizedBox(height: 18),

              // Title: Konfirmasi PIN (Font Rasa)
              Text(
                'Konfirmasi PIN',
                textAlign: TextAlign.center,
                style: GoogleFonts.rasa(
                  fontSize: 34,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 6),

              // Subtitle
              Text(
                'Masukkan 6-digit PIN Transaksi kamu',
                textAlign: TextAlign.center,
                style: GoogleFonts.robotoSlab(
                  fontSize: 15,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 36),

              // Indikator 6 Digit PIN: Muncul Angka Font Poppins saat diisi, Titik Abu saat kosong (Persis Transfer)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(6, (idx) {
                  final bool isFilled = idx < _pin.length;
                  return Container(
                    margin: EdgeInsets.only(right: idx < 5 ? 16 : 0),
                    width: 28,
                    height: 38,
                    alignment: Alignment.center,
                    child: isFilled
                        ? Text(
                            _pin[idx],
                            style: GoogleFonts.poppins(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF1C0823),
                            ),
                          )
                        : Container(
                            width: 18,
                            height: 18,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color(0xFFD9D9D9),
                            ),
                          ),
                  );
                }),
              ),
              const SizedBox(height: 28),

              // Teks Lupa PIN?
              Text(
                'Lupa PIN?',
                style: GoogleFonts.robotoSlab(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFFCA31FF),
                ),
              ),

              const Spacer(),

              // Keypad Angka 3x4
              _buildPinKeypad(),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPinKeypad() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildPinKeypadButton('1'),
            _buildPinKeypadButton('2'),
            _buildPinKeypadButton('3'),
          ],
        ),
        const SizedBox(height: 18),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildPinKeypadButton('4'),
            _buildPinKeypadButton('5'),
            _buildPinKeypadButton('6'),
          ],
        ),
        const SizedBox(height: 18),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildPinKeypadButton('7'),
            _buildPinKeypadButton('8'),
            _buildPinKeypadButton('9'),
          ],
        ),
        const SizedBox(height: 18),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const SizedBox(width: 80, height: 60),
            _buildPinKeypadButton('0'),
            GestureDetector(
              onTap: _handlePinDelete,
              behavior: HitTestBehavior.opaque,
              child: SizedBox(
                width: 80,
                height: 60,
                child: Center(
                  child: AppIcons.buildImageOrIcon(
                    AppIcons.icKeypadDelete,
                    width: 32,
                    height: 32,
                    fallbackIcon: Icons.backspace_outlined,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPinKeypadButton(String digit) {
    return GestureDetector(
      onTap: () => _handlePinDigit(digit),
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: 80,
        height: 60,
        alignment: Alignment.center,
        child: Text(
          digit,
          style: GoogleFonts.poppins(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
    );
  }

  // ==========================================
  // STAGE 3 (Figma Node 403:671): Layar Resi Bukti Transaksi Sukses
  // Persis seperti di Transfer tapi bagian rincian disesuaikan Beli Emas (Figma Frame #403:671)
  // ==========================================
  Widget _buildBuktiTransaksiScreen(double gramsAdded) {
    final nowFormatted = DateFormat('d MMM yyyy  HH:mm:ss').format(DateTime.now());

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Container(
          color: Colors.white,
          width: double.infinity,
          height: double.infinity,
          child: Stack(
            children: [
              // 1. Header Ungu Penuh Menembus ke Paling Atas Layar HP (y = 0)
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                height: 280,
                child: Container(
                  color: const Color(0xFFD373FC),
                ),
              ),

              // 2. Kanvas Konten Utama Presisi Figma Frame #403:671 (393 x 852 px)
              Positioned.fill(
                child: SafeArea(
                  top: false,
                  bottom: true,
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      return Align(
                        alignment: Alignment.topCenter,
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          alignment: Alignment.topCenter,
                          child: SizedBox(
                            width: 393,
                            height: 852,
                            child: Stack(
                              clipBehavior: Clip.none,
                              children: [
                                // Header Ungu dengan Art Party Popper & Tombol Share (Figma Node #403:671)
                                Positioned(
                                  top: 0,
                                  left: 0,
                                  right: 0,
                                  height: 220,
                                  child: Stack(
                                    alignment: Alignment.topCenter,
                                    children: [
                                      Container(
                                        width: double.infinity,
                                        height: 220,
                                        color: const Color(0xFFD373FC),
                                      ),
                                      // Tombol Share di pojok kanan atas (x=337-363, y=28-63)
                                      Positioned(
                                        top: 36,
                                        right: 24,
                                        child: GestureDetector(
                                          onTap: () {
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              SnackBar(
                                                content: Text('Membagikan Bukti Transaksi...', style: GoogleFonts.robotoSlab()),
                                                behavior: SnackBarBehavior.floating,
                                              ),
                                            );
                                          },
                                          child: AppIcons.buildImageOrIcon(
                                            AppIcons.icShareBukti,
                                            width: 30,
                                            height: 32,
                                            fallbackIcon: Icons.share_outlined,
                                            fallbackColor: const Color(0xFFF6E1FF),
                                          ),
                                        ),
                                      ),
                                      // Gambar Party Popper otentik dari Figma
                                      Positioned(
                                        top: 42,
                                        child: Image.asset(
                                          'assets/images/img_bukti_transaksi_popper.png',
                                          width: 115,
                                          height: 102,
                                          fit: BoxFit.contain,
                                          errorBuilder: (_, __, ___) => const Icon(
                                            Icons.celebration,
                                            color: Colors.white,
                                            size: 70,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                // Kartu Struk Resi Putih Lavender Otentik Figma (x=25, w=351, y=178, h=588)
                                Positioned(
                                  top: 178,
                                  left: 25,
                                  width: 351,
                                  height: 588,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFF6E1FF),
                                      borderRadius: BorderRadius.circular(28),
                                      boxShadow: [
                                        // Bayangan Ungu Otentik Figma Frame #403:671 (glow lavender kaya pekat)
                                        BoxShadow(
                                          color: const Color(0xFFCA31FF).withValues(alpha: 0.45),
                                          blurRadius: 24,
                                          spreadRadius: 2,
                                          offset: const Offset(0, 8),
                                        ),
                                        BoxShadow(
                                          color: const Color(0xFFCA31FF).withValues(alpha: 0.20),
                                          blurRadius: 8,
                                          spreadRadius: 0,
                                          offset: const Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(28),
                                      child: SingleChildScrollView(
                                        physics: const ClampingScrollPhysics(),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                        const SizedBox(height: 18),
                                        // Badge Ceklis Sukses Lingkaran Otentik Figma (size 67x67)
                                        AppIcons.buildImageOrIcon(
                                          AppIcons.icReceiptCheck,
                                          width: 67,
                                          height: 67,
                                          fallbackIcon: Icons.check_circle,
                                          fallbackColor: const Color(0xFFCA31FF),
                                        ),
                                        const SizedBox(height: 10),

                                        // Header: Bukti Transaksi [Font: Rasa, Bold 26sp]
                                        Text(
                                          'Bukti Transaksi',
                                          textAlign: TextAlign.center,
                                          style: GoogleFonts.rasa(
                                            fontSize: 26,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                          ),
                                        ),

                                        const SizedBox(height: 18),

                                        // Bagian 1: Data Transaksi
                                        Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 20),
                                          child: Column(
                                            children: [
                                              _buildReceiptRow('Nomor  Referensi', '45499730898', isNumber: true),
                                              const SizedBox(height: 8),
                                              _buildReceiptRow('Tanggal Transaksi', '$nowFormatted WIB', isNumber: true),
                                              const SizedBox(height: 8),
                                              _buildReceiptRow(
                                                'Sumber Dana (XEMA):',
                                                'LISA ARUNIA\n085******656',
                                                isSender: true,
                                              ),
                                            ],
                                          ),
                                        ),

                                        const SizedBox(height: 14),
                                        // Divider 1 (Figma: M25 425.5H376 stroke black opacity 0.25)
                                        const Divider(color: Color(0x40000000), height: 1, thickness: 1),
                                        const SizedBox(height: 12),

                                        // Bagian 2: SUKSES! dengan glow effect
                                        Text(
                                          'SUKSES!',
                                          textAlign: TextAlign.center,
                                          style: GoogleFonts.robotoSlab(
                                            fontSize: 28,
                                            fontWeight: FontWeight.bold,
                                            color: const Color(0xFFCA31FF),
                                            shadows: [
                                              Shadow(
                                                color: const Color(0xFFCA31FF).withValues(alpha: 0.38),
                                                blurRadius: 12,
                                                offset: const Offset(0, 2),
                                              ),
                                            ],
                                          ),
                                        ),

                                        const SizedBox(height: 12),

                                        // Bagian 3: Rincian Pembelian (Figma: Nominal Pembelian & Emas Didapat)
                                        Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 20),
                                          child: Column(
                                            children: [
                                              Row(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Text(
                                                    'Nominal  Pembelian',
                                                    style: GoogleFonts.robotoSlab(
                                                      fontSize: 14,
                                                      fontWeight: FontWeight.bold,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                  const SizedBox(width: 8),
                                                  Flexible(
                                                    child: Text.rich(
                                                      TextSpan(
                                                        children: [
                                                          TextSpan(
                                                            text: 'Rp ',
                                                            style: GoogleFonts.robotoSlab(
                                                              fontSize: 14,
                                                              fontWeight: FontWeight.bold,
                                                              color: Colors.black,
                                                            ),
                                                          ),
                                                          TextSpan(
                                                            text: _formatNumber(_nominalRupiah),
                                                            style: GoogleFonts.poppins(
                                                              fontSize: 14,
                                                              fontWeight: FontWeight.bold,
                                                              color: Colors.black,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      textAlign: TextAlign.right,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(height: 8),
                                              Row(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Text(
                                                    'Emas Didapat',
                                                    style: GoogleFonts.robotoSlab(
                                                      fontSize: 14,
                                                      fontWeight: FontWeight.bold,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                  const SizedBox(width: 8),
                                                  Flexible(
                                                    child: Text.rich(
                                                      TextSpan(
                                                        children: [
                                                          TextSpan(
                                                            text: gramsAdded.toStringAsFixed(4).replaceAll('.', ','),
                                                            style: GoogleFonts.poppins(
                                                              fontSize: 14,
                                                              fontWeight: FontWeight.bold,
                                                              color: Colors.black,
                                                            ),
                                                          ),
                                                          TextSpan(
                                                            text: ' Gram',
                                                            style: GoogleFonts.robotoSlab(
                                                              fontSize: 14,
                                                              fontWeight: FontWeight.bold,
                                                              color: Colors.black,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      textAlign: TextAlign.right,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),

                                        const SizedBox(height: 14),
                                        // Divider 2 (Figma: M25 599.5H376 stroke black opacity 0.25)
                                        const Divider(color: Color(0x40000000), height: 1, thickness: 1),
                                        const SizedBox(height: 12),

                                        // Bagian 4: Harga Beli/gr & Biaya Admin (Figma Node #403:671)
                                        Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 20),
                                          child: Column(
                                            children: [
                                              Row(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Text(
                                                    'Harga Beli/gr',
                                                    style: GoogleFonts.robotoSlab(
                                                      fontSize: 14,
                                                      fontWeight: FontWeight.bold,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                  const SizedBox(width: 8),
                                                  Flexible(
                                                    child: Text.rich(
                                                      TextSpan(
                                                        children: [
                                                          TextSpan(
                                                            text: 'Rp ',
                                                            style: GoogleFonts.robotoSlab(
                                                              fontSize: 14,
                                                              fontWeight: FontWeight.bold,
                                                              color: Colors.black,
                                                            ),
                                                          ),
                                                          TextSpan(
                                                            text: _formatNumber(widget.pricePerGram),
                                                            style: GoogleFonts.poppins(
                                                              fontSize: 14,
                                                              fontWeight: FontWeight.bold,
                                                              color: Colors.black,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      textAlign: TextAlign.right,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(height: 8),
                                              Row(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Text(
                                                    'Biaya Admin',
                                                    style: GoogleFonts.robotoSlab(
                                                      fontSize: 14,
                                                      fontWeight: FontWeight.bold,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                  const SizedBox(width: 8),
                                                  Flexible(
                                                    child: Text(
                                                      'Gratis',
                                                      textAlign: TextAlign.right,
                                                      style: GoogleFonts.robotoSlab(
                                                        fontSize: 14,
                                                        fontWeight: FontWeight.bold,
                                                        color: const Color(0xFFFF383C),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),

                                        const SizedBox(height: 14),
                                        // Divider 3 (Figma: M25 687.5H376 stroke black opacity 0.25)
                                        const Divider(color: Color(0x40000000), height: 1, thickness: 1),
                                        const SizedBox(height: 14),

                                        // Bagian 5: TOTAL
                                        Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 20),
                                          child: Row(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                'TOTAL',
                                                style: GoogleFonts.robotoSlab(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black,
                                                ),
                                              ),
                                              const SizedBox(width: 8),
                                              Flexible(
                                                child: Text.rich(
                                                  TextSpan(
                                                    children: [
                                                      TextSpan(
                                                        text: 'Rp ',
                                                        style: GoogleFonts.robotoSlab(
                                                          fontSize: 18,
                                                          fontWeight: FontWeight.bold,
                                                          color: Colors.black,
                                                        ),
                                                      ),
                                                      TextSpan(
                                                        text: _formatNumber(_nominalRupiah),
                                                        style: GoogleFonts.poppins(
                                                          fontSize: 20,
                                                          fontWeight: FontWeight.bold,
                                                          color: Colors.black,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  textAlign: TextAlign.right,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),

                                // Tombol OK Bawah (Figma: x=14, y=785, width=365, height=49, rx=15, fill=#CA31FF, stroke=black 1px)
                                Positioned(
                                  top: 785,
                                  left: 14,
                                  right: 14,
                                  height: 49,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFCA31FF),
                                      borderRadius: BorderRadius.circular(15),
                                      border: Border.all(color: Colors.black, width: 1.0),
                                    ),
                                    child: Material(
                                      color: Colors.transparent,
                                      child: InkWell(
                                        borderRadius: BorderRadius.circular(15),
                                        onTap: () {
                                          if (widget.onBuySuccess != null) {
                                            widget.onBuySuccess!(gramsAdded, _nominalRupiah);
                                          }
                                          Navigator.pop(context); // Kembali ke GoldScreen
                                        },
                                        child: Center(
                                          child: Text(
                                            'OK',
                                            style: GoogleFonts.robotoSlab(
                                              fontSize: 17,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                              letterSpacing: 1,
                                            ),
                                          ),
                                        ),
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
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildReceiptRow(String label, String value, {bool isNumber = false, bool isSender = false}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.robotoSlab(
            fontSize: 13,
            color: Colors.black87,
          ),
        ),
        const SizedBox(width: 8),
        Flexible(
          child: isSender
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      value.split('\n')[0],
                      textAlign: TextAlign.right,
                      style: GoogleFonts.robotoSlab(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      value.split('\n').length > 1 ? value.split('\n')[1] : '',
                      textAlign: TextAlign.right,
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ],
                )
              : Text(
                  value,
                  textAlign: TextAlign.right,
                  style: isNumber
                      ? GoogleFonts.poppins(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        )
                      : GoogleFonts.robotoSlab(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                ),
        ),
      ],
    );
  }

  // ==========================================
  // STAGE 0: LAYAR UTAMA BELI EMAS (Nodes 224:265 & 296:928)
  // ==========================================
  @override
  Widget build(BuildContext context) {
    // Estimasi gram bertambah: nominal / harga per gram
    final double gramsAdded = _nominalRupiah > 0 ? _nominalRupiah / widget.pricePerGram : 0.0;

    // Jika sedang di step Konfirmasi Pembelian (Figma Node 224:176)
    if (_currentStep == 1) {
      return _buildKonfirmasiScreen(gramsAdded);
    }

    // Jika sedang di step PIN (Figma Node 270:258)
    if (_currentStep == 2) {
      return _buildPinScreen();
    }

    // Jika sedang di step Bukti Transaksi (Figma Node 403:671)
    if (_currentStep == 3) {
      return _buildBuktiTransaksiScreen(gramsAdded);
    }

    // State Beli Emas: Ada nominal yang dipilih/diketik
    final bool hasNominal = _nominalRupiah > 0;

    return PopScope(
      canPop: !_isKeypadOpen && _currentStep == 0,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        if (_isKeypadOpen) {
          setState(() => _isKeypadOpen = false);
          return;
        }
        if (_currentStep == 3) {
          Navigator.pop(context);
          return;
        }
        if (_currentStep == 2) {
          setState(() {
            _pin = '';
            _currentStep = 1;
          });
          return;
        }
        if (_currentStep == 1) {
          setState(() => _currentStep = 0);
          return;
        }
        Navigator.pop(context);
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          top: false,
          child: Column(
            children: [
              // 1. HEADER (Tinggi 90px, Background #D373FC, Seamless)
              Container(
                width: double.infinity,
                height: 90,
                color: const Color(0xFFD373FC),
                padding: const EdgeInsets.only(top: 36, left: 16, right: 20),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        if (_isKeypadOpen) {
                          setState(() => _isKeypadOpen = false);
                          return;
                        }
                        Navigator.pop(context);
                      },
                      behavior: HitTestBehavior.opaque,
                      child: const Icon(
                        Icons.arrow_back,
                        color: Color(0xFF52086B),
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Text(
                      'BELI',
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

              // 2. KONTEN BODY (Bebas overflow, kartu tips turun ke bawah persis y=652 Figma)
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final double contentHeight = hasNominal ? 643 : 521;
                    final double tipsTopGap = (constraints.maxHeight - contentHeight).clamp(28.0, 200.0);

                    return SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Label "Masukkan Nominal Pembelian"
                          Text(
                            'Masukkan Nominal Pembelian',
                            style: GoogleFonts.robotoSlab(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 14),

                          // Kotak Input Abu-abu (#AEADAD)
                          // KLIK 1: Munculkan keyboard 4-kolom otentik (Transfer)
                          // KLIK 2: Sembunyikan keyboard (Responsive Toggle!)
                          // TIDAK ADA TANDA X / ICON APAPUN DI UJUNG SESUAI PERMINTAAN USER
                          GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onTap: () {
                              setState(() {
                                _isKeypadOpen = !_isKeypadOpen;
                              });
                            },
                            child: Container(
                              height: 67,
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              decoration: BoxDecoration(
                                color: const Color(0xFFAEADAD),
                                borderRadius: BorderRadius.circular(10),
                                border: _isKeypadOpen
                                    ? Border.all(color: const Color(0xFF52086B), width: 2)
                                    : null,
                              ),
                              child: Row(
                                children: [
                                  Text(
                                    'Rp',
                                    style: GoogleFonts.poppins(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black,
                                    ),
                                  ),
                                  const SizedBox(width: 14),
                                  Expanded(
                                    child: Row(
                                      children: [
                                        if (_nominalRupiah > 0)
                                          Text(
                                            _formatNumber(_nominalRupiah),
                                            style: GoogleFonts.poppins(
                                              fontSize: 26,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black,
                                            ),
                                          ),
                                        // Kursor vertikal saat keypad aktif atau nominal kosong
                                        if (_isKeypadOpen || _nominalRupiah == 0)
                                          Container(
                                            width: 2.2,
                                            height: 28,
                                            margin: const EdgeInsets.only(left: 2),
                                            color: const Color(0xFF52086B),
                                          ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),

                          // Keterangan Gram (Rata Kanan)
                          Align(
                            alignment: Alignment.centerRight,
                            child: Text.rich(
                              TextSpan(
                                text: 'Emas Bertambah ',
                                style: GoogleFonts.robotoSlab(
                                  fontSize: 13,
                                  color: Colors.black,
                                ),
                                children: [
                                  TextSpan(
                                    text: '${gramsAdded.toStringAsFixed(4).replaceAll('.', ',')} Gram',
                                    style: GoogleFonts.poppins(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),

                          // KARTU REKENING SUMBER (XEMA) - (Figma Node 296:928)
                          // Tampil saat nominal terisi
                          if (hasNominal) ...[
                            Container(
                              width: double.infinity,
                              height: 98,
                              padding: const EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF3D8FF),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Stack(
                                children: [
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      // Badge Ikon Ungu (#CA31FF) dengan siluet user
                                      Container(
                                        width: 57,
                                        height: 46,
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFCA31FF),
                                          borderRadius: BorderRadius.circular(17),
                                        ),
                                        child: const Icon(
                                          Icons.person_outline,
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
                                              'Rekening Sumber (XEMA)',
                                              style: GoogleFonts.robotoSlab(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Text.rich(
                                              TextSpan(
                                                text: 'Rp ',
                                                style: GoogleFonts.robotoSlab(fontSize: 14, color: Colors.black),
                                                children: [
                                                  TextSpan(
                                                    text: '${_formatNumber(_saldoXema)},00',
                                                    style: GoogleFonts.poppins(
                                                      fontSize: 14,
                                                      fontWeight: FontWeight.w600,
                                                      color: Colors.black,
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
                                  // Nomor Telepon / Akun di Pojok Kanan Bawah
                                  Positioned(
                                    right: 4,
                                    bottom: 2,
                                    child: Text(
                                      '0851 2343 5656',
                                      style: GoogleFonts.poppins(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black87,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 24),
                          ],

                          // PILIHAN CEPAT (2x2 Grid)
                          Text(
                            'Pilihan Cepat',
                            style: GoogleFonts.robotoSlab(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 14),

                          // Grid 2x2
                          Row(
                            children: [
                              _buildQuickChoiceCard('Rp 100.000', 100000),
                              const SizedBox(width: 14),
                              _buildQuickChoiceCard('Rp 300.000', 300000),
                            ],
                          ),
                          const SizedBox(height: 14),
                          Row(
                            children: [
                              _buildQuickChoiceCard('Rp 500.000', 500000),
                              const SizedBox(width: 14),
                              _buildQuickChoiceCard('Rp 1.000.000', 1000000),
                            ],
                          ),

                          // GAP DINAMIS: Menurunkan TIPS kuning ke bawah layar persis y=652 Figma Node 224:265
                          SizedBox(height: tipsTopGap),

                          // KARTU TIPS KUNING (#FFC107) - POSISI LEBIH TURUN KE BAWAH PERSIS FIGMA NODE 224:265
                          // Lebar 309, Tinggi 156, Radius 10
                          Center(
                            child: Container(
                              width: 309,
                              constraints: const BoxConstraints(minHeight: 156),
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFFC107),
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Color(0x20000000),
                                    blurRadius: 8,
                                    offset: Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'TIPS:',
                                    style: GoogleFonts.robotoSlab(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: const Color(0xFFFF383C),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Mulai investasi rutin tiap bulan agar untung maksimal !!',
                                    style: GoogleFonts.robotoSlab(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      height: 1.35,
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  Text(
                                    'Bebas Biaya Admin 5x Sebulan',
                                    style: GoogleFonts.robotoSlab(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                      color: const Color(0xFFFF383C),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),
                        ],
                      ),
                    );
                  },
                ),
              ),

              // 3. TOMBOL KONFIRMASI (Sticky di Bawah Layar / di atas keyboard saat nominal > 0)
              if (hasNominal)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 10),
                  color: Colors.white,
                  child: SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFCA31FF),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                        elevation: 0,
                      ),
                      onPressed: () {
                        setState(() {
                          _isKeypadOpen = false;
                          _currentStep = 1; // Masuk ke Layar Konfirmasi Pembelian (Node 224:176)
                        });
                      },
                      child: Text(
                        'Konfirmasi',
                        style: GoogleFonts.robotoSlab(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),

              // 4. KEYBOARD 4-KOLOM FIGMA (Responsive: Muncul saat kotak abu-abu diklik)
              if (_isKeypadOpen)
                _buildFigma4ColKeypad(
                  onDigit: _handleKeypadDigit,
                  onDelete: _handleKeypadDelete,
                  onSubmit: _handleKeypadSubmit,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
