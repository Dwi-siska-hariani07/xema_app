import 'dart:ui';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import 'core/app_icons.dart';

/// Layar Alur Penjualan Emas (JUAL EMAS)
/// Mengimplementasikan 5 Frame Figma secara Pixel-Perfect:
/// 1. Frame #905:1764 & #954:1777 (investasi jual emas 4 - State Kosong)
/// 2. Frame investasi jual emas 5 (State Terisi + Nominal + Emas Berkurang)
/// 3. Frame investasi jual emas 3 (Layar Konfirmasi Tujuan Pencairan & Detail Transaksi)
/// 4. Frame PIN jual emas (Layar Masukkan 6-digit PIN Transaksi + Keypad Custom)
/// 5. Frame transaksi jual emas (Layar Resi Bukti Transaksi Sukses)
class SellGoldScreen extends StatefulWidget {
  final double currentGrams;
  final double pricePerGramSell;
  final Function(double gramsSold, double rupiahReceived)? onSellSuccess;

  const SellGoldScreen({
    super.key,
    this.currentGrams = 5.2834, // Sesuai Frame Figma #905:1764: 5,2834 Gram
    this.pricePerGramSell = 2250000, // Sesuai Frame Figma: Rp 2.250.000/ gr
    this.onSellSuccess,
  });

  @override
  State<SellGoldScreen> createState() => _SellGoldScreenState();
}

class _SellGoldScreenState extends State<SellGoldScreen> {
  final TextEditingController _amountController = TextEditingController();
  final ScrollController _quickChoiceScrollController = ScrollController();

  double _dragStartX = 0;
  double _dragStartScrollOffset = 0;
  bool _isDraggingQuickChoice = false;

  double _nominalRupiah = 0;
  final double _saldoXema = 76465000; // Rp 76.465.000,00 sesuai Frame investasi jual emas 3

  // State Responsif Keypad Figma (muncul/sembunyi saat kotak abu-abu diklik)
  bool _isKeypadOpen = false;

  // Stage Flow:
  // 0 = Input Nominal Penjualan (investasi jual emas 4 & 5)
  // 1 = Layar Konfirmasi Penjualan / Tujuan Pencairan (investasi jual emas 3)
  // 2 = Layar Masukkan PIN (PIN jual emas)
  // 3 = Layar Bukti Transaksi Resi Sukses (transaksi jual emas)
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
    _quickChoiceScrollController.dispose();
    super.dispose();
  }

  // Dukungan input keyboard laptop/PC & keypad layar
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

    // Handle saat di Layar Input Jual Emas (Step 0)
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

  // Kartu Pilihan Cepat (Scrollable horizontal sesuai frame #905:1764)
  Widget _buildQuickChoiceCard(String label, double value) {
    final bool isSelected = _nominalRupiah == value;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: () {
          _setAmount(value);
        },
        child: Container(
          width: 146,
          height: 61,
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
  // KEYBOARD 4-KOLOM OTENTIK FIGMA (PERSIS SEPERTI DI MENU BELI EMAS & TRANSFER)
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
  // STAGE 1: LAYAR KONFIRMASI TUJUAN PENCAIRAN
  // (Figma Frame investasi jual emas 3)
  // ==========================================
  Widget _buildKonfirmasiScreen(double gramsSold) {
    final double currentValue = widget.currentGrams * widget.pricePerGramSell;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            // 1. Header JUAL (#D373FC, tinggi 90, tombol back, chart icon)
            Container(
              width: double.infinity,
              height: 90,
              padding: const EdgeInsets.only(top: 36, left: 16, right: 16),
              color: const Color(0xFFD373FC),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Color(0xFF52086B), size: 26),
                    onPressed: () {
                      setState(() {
                        _currentStep = 0; // Kembali ke layar input jual
                      });
                    },
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'JUAL',
                    style: GoogleFonts.robotoSlab(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF52086B),
                    ),
                  ),
                  const Spacer(),
                  _buildStaircaseChartIcon(),
                ],
              ),
            ),

            // 2. Konten Scrollable
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Card 1: Tabungan Emas Anda dengan blue outline otentik Figma
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF3D8FF),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: const Color(0xFF00A3FF), width: 2),
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
                            'Tabungan Emas Anda',
                            style: GoogleFonts.robotoSlab(
                              fontSize: 14,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '${widget.currentGrams.toStringAsFixed(4).replaceAll('.', ',')} Gram',
                            style: GoogleFonts.poppins(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Nilai Saat Ini: Rp ${_formatNumber(currentValue)}',
                            style: GoogleFonts.robotoSlab(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Section 2: Tujuan Pencairan
                    Text(
                      'Tujuan Pencairan',
                      style: GoogleFonts.robotoSlab(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Card Rekening XEMA (#F3D8FF, radius 10)
                    Container(
                      width: double.infinity,
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
                                width: 54,
                                height: 46,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFCA31FF),
                                  borderRadius: BorderRadius.circular(16),
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
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Rp ${_formatNumber(_saldoXema)},00',
                                      style: GoogleFonts.poppins(
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          // Nomor Telepon di Pojok Kanan Bawah
                          Positioned(
                            right: 4,
                            bottom: 0,
                            child: Text(
                              '0851 2343 5656',
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Section 3: Detail Transaksi
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF3D8FF),
                        borderRadius: BorderRadius.circular(10),
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
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                child: Text(
                                  'Nominal Penjualan',
                                  style: GoogleFonts.robotoSlab(fontSize: 13, color: Colors.black87),
                                ),
                              ),
                              Text(
                                'Rp${_formatNumber(_nominalRupiah)}',
                                style: GoogleFonts.poppins(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                child: Text(
                                  'Biaya Admin',
                                  style: GoogleFonts.robotoSlab(fontSize: 13, color: Colors.black87),
                                ),
                              ),
                              Text(
                                'Rp 0',
                                style: GoogleFonts.poppins(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 10),
                            child: Divider(color: Colors.black26, height: 1),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                child: Text(
                                  'Total Diterima',
                                  style: GoogleFonts.robotoSlab(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                              Text(
                                'Rp${_formatNumber(_nominalRupiah)}',
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // 3. Tombol Konfirmasi Bawah (#CA31FF, Radius 25, Stadium Pill)
            Padding(
              padding: const EdgeInsets.all(16),
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
                      _currentStep = 2; // Masuk ke Layar PIN (PIN jual emas)
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

  // ==========================================
  // STAGE 2: LAYAR MASUKKAN PIN TRANSAKSI
  // (Figma Frame PIN jual emas)
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
              _currentStep = 3; // Menuju Bukti Transaksi Sukses
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
        child: Column(
          children: [
            // Tombol Back di pojok kiri atas (Persis Frame PIN jual emas)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _pin = '';
                        _currentStep = 1; // Kembali ke layar konfirmasi
                      });
                    },
                    child: AppIcons.buildImageOrIcon(
                      AppIcons.icBackCircle,
                      width: 38,
                      height: 38,
                      fallbackIcon: Icons.arrow_circle_left_outlined,
                      fallbackColor: Colors.black,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // Icon Kunci Ungu di dalam Kotak Hitam Ungu (#1C0823 & #CA31FF)
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: const Color(0xFF1C0823),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Icon(
                Icons.vpn_key_rounded,
                color: Color(0xFFCA31FF),
                size: 38,
              ),
            ),

            const SizedBox(height: 20),

            // Judul: Konfirmasi PIN (Font Rasa bold 32sp)
            Text(
              'Konfirmasi PIN',
              style: GoogleFonts.rasa(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),

            const SizedBox(height: 6),

            // Subtitle
            Text(
              'Masukkan 6-digit PIN Transaksi kamu',
              style: GoogleFonts.robotoSlab(
                fontSize: 13,
                color: Colors.black54,
              ),
            ),

            const SizedBox(height: 36),

            // Indikator 6 Digit PIN: Muncul Angka Font Poppins saat diisi, Titik Abu 18x18 saat kosong (Persis Figma Frame PIN jual emas)
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

            // Link: Lupa PIN?
            GestureDetector(
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Fitur reset PIN dipilih', style: GoogleFonts.robotoSlab()),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
              child: Text(
                'Lupa PIN?',
                style: GoogleFonts.robotoSlab(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFFCA31FF),
                ),
              ),
            ),

            const Spacer(),

            // Keypad Angka Custom 3x4 Otentik Figma
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 16),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildPinKeyCell('1'),
                      _buildPinKeyCell('2'),
                      _buildPinKeyCell('3'),
                    ],
                  ),
                  const SizedBox(height: 18),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildPinKeyCell('4'),
                      _buildPinKeyCell('5'),
                      _buildPinKeyCell('6'),
                    ],
                  ),
                  const SizedBox(height: 18),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildPinKeyCell('7'),
                      _buildPinKeyCell('8'),
                      _buildPinKeyCell('9'),
                    ],
                  ),
                  const SizedBox(height: 18),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      const SizedBox(width: 64, height: 64), // Empty space kiri bawah
                      _buildPinKeyCell('0'),
                      // Tombol Aksi Kanan Bawah:
                      // Jika < 6 angka: ikon hapus/backspace
                      // Begitu 6 angka terpenuhi: diganti menjadi centang ungu (#CA31FF)
                      _buildPinActionKey(),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  // Tombol aksi di pojok kanan bawah keypad:
  // - Belum mencapai 6 angka: menampilkan tanda hapus/backspace
  // - Begitu angka ke-6 terpenuhi: tanda hapus diganti centang ungu (#CA31FF)
  Widget _buildPinActionKey() {
    final bool isComplete = _pin.length == 6;
    return SizedBox(
      key: const ValueKey('pin_action_button'),
      width: 64,
      height: 64,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(32),
          onTap: () {
            if (isComplete) {
              setState(() {
                _currentStep = 3;
              });
            } else {
              _handlePinDelete();
            }
          },
          child: Center(
            child: isComplete
                ? Container(
                    width: 36,
                    height: 36,
                    decoration: const BoxDecoration(
                      color: Color(0xFFCA31FF),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 22,
                    ),
                  )
                : AppIcons.buildImageOrIcon(
                    AppIcons.icKeypadDelete,
                    width: 32,
                    height: 32,
                    fallbackIcon: Icons.backspace_outlined,
                    fallbackColor: Colors.black,
                  ),
          ),
        ),
      ),
    );
  }

  Widget _buildPinKeyCell(String digit) {
    return SizedBox(
      width: 64,
      height: 64,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(32),
          onTap: () => _handlePinDigit(digit),
          child: Center(
            child: Text(
              digit,
              style: GoogleFonts.poppins(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ==========================================
  // ==========================================
  // STAGE 3: LAYAR BUKTI TRANSAKSI RESI SUKSES
  // (Figma Frame transaksi jual emas #342:607)
  // ==========================================
  Widget _buildReceiptScreen(double gramsSold) {
    final now = DateTime.now();
    final formattedDate = '${now.day} Okt ${now.year}  ${DateFormat('HH:mm').format(now)}:67 WIB';

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        top: false,
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              child: SizedBox(
                width: constraints.maxWidth,
                height: 852, // Standard Figma Canvas height
                child: Stack(
                  alignment: Alignment.topCenter,
                  children: [
                    // 1. Header Ungu (#D373FC) dengan Party Popper & Share
                    Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      height: 228,
                      child: Stack(
                        alignment: Alignment.topCenter,
                        children: [
                          Container(
                            width: double.infinity,
                            height: 228,
                            color: const Color(0xFFD373FC),
                          ),
                          // Tombol Share di pojok kanan atas
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

                    // 2. Kartu Struk Resi Lavender Otentik Figma (#F6E1FF, radius top 50, Frame #342:607)
                    Positioned(
                      top: 178,
                      left: 21,
                      right: 21,
                      height: 589,
                      child: Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFFF6E1FF),
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(50),
                            topRight: Radius.circular(50),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFFD373FC).withValues(alpha: 0.60),
                              blurRadius: 20,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(50),
                            topRight: Radius.circular(50),
                          ),
                          child: SingleChildScrollView(
                            physics: const ClampingScrollPhysics(),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                const SizedBox(height: 20),

                                // Badge Ceklis Lingkaran Ungu (#CA31FF, size 67x67)
                                Center(
                                  child: AppIcons.buildImageOrIcon(
                                    AppIcons.icReceiptCheck,
                                    width: 67,
                                    height: 67,
                                    fallbackIcon: Icons.check_circle,
                                    fallbackColor: const Color(0xFFCA31FF),
                                  ),
                                ),
                                const SizedBox(height: 8),

                                // Judul: Bukti Transaksi (Font Rasa bold 26sp)
                                Center(
                                  child: Text(
                                    'Bukti Transaksi',
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.rasa(
                                      fontSize: 26,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 20),

                                // Bagian 1: Data Transaksi
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 20),
                                  child: Column(
                                    children: [
                                      _buildReceiptRow('Nomor  Referensi', '45499730898', isNumber: true),
                                      const SizedBox(height: 8),
                                      _buildReceiptRow('Tanggal Transaksi', formattedDate, isNumber: true),
                                      const SizedBox(height: 8),
                                      _buildReceiptRow(
                                        'Tujuan Dana (XEMA):',
                                        'LISA ARUNIA\n085******656',
                                        isSender: true,
                                      ),
                                    ],
                                  ),
                                ),

                                const SizedBox(height: 16),
                                // Divider 1 (Figma SVG: M25 425.5H376 stroke black opacity 0.25)
                                const Divider(color: Color(0x40000000), height: 1, thickness: 1),
                                const SizedBox(height: 18),

                                // Bagian 2: Status SUKSES! (Glow ungu otentik, TANPA divider di bawahnya sesuai Figma)
                                Center(
                                  child: Text(
                                    'SUKSES!',
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.robotoSlab(
                                      fontSize: 28,
                                      fontWeight: FontWeight.bold,
                                      color: const Color(0xFFCA31FF),
                                      shadows: const [
                                        Shadow(
                                          color: Color(0x40000000),
                                          blurRadius: 15,
                                          offset: Offset(0, 4),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),

                                const SizedBox(height: 22),

                                // Bagian 3: Rincian Penjualan (Nominal Penjualan & Emas Dijual)
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 20),
                                  child: Column(
                                    children: [
                                      _buildReceiptRow(
                                        'Nominal  Penjualan',
                                        'Rp ${_nominalRupiah > 0 ? _formatNumber(_nominalRupiah) : '100.000'}',
                                        isNumber: true,
                                        isBoldLabel: true,
                                      ),
                                      const SizedBox(height: 10),
                                      _buildReceiptRow(
                                        'Emas Dijual',
                                        '${gramsSold > 0 ? gramsSold.toStringAsFixed(4).replaceAll('.', ',') : '0,0434'} Gram',
                                        isNumber: true,
                                        isBoldLabel: true,
                                      ),
                                    ],
                                  ),
                                ),

                                const SizedBox(height: 16),
                                // Divider 2 (Figma SVG: M25 599.5H376 stroke black opacity 0.25)
                                const Divider(color: Color(0x40000000), height: 1, thickness: 1),
                                const SizedBox(height: 16),

                                // Bagian 4: Harga Jual & Biaya Admin
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 20),
                                  child: Column(
                                    children: [
                                      _buildReceiptRow(
                                        'Harga Jual/gr',
                                        'Rp ${_formatNumber(widget.pricePerGramSell)}',
                                        isNumber: true,
                                        isBoldLabel: true,
                                      ),
                                      const SizedBox(height: 10),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Flexible(
                                            child: Text(
                                              'Biaya Admin',
                                              style: GoogleFonts.robotoSlab(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black,
                                              ),
                                            ),
                                          ),
                                          Text(
                                            'Gratis',
                                            style: GoogleFonts.poppins(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              color: const Color(0xFFFF383C), // Coral red otentik
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),

                                const SizedBox(height: 16),
                                // Divider 3 (Figma SVG: M25 687.5H376 stroke black opacity 0.25)
                                const Divider(color: Color(0x40000000), height: 1, thickness: 1),
                                const SizedBox(height: 18),

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
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Flexible(
                                        child: Text(
                                          _nominalRupiah > 0
                                              ? 'Rp ${_formatNumber(_nominalRupiah)}'
                                              : 'Rp 2.250.000',
                                          textAlign: TextAlign.right,
                                          style: GoogleFonts.poppins(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 16),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),

                    // 3. Tombol OK Bawah (Radius 15, Background #CA31FF, Border hitam 1px)
                    Positioned(
                      top: 784,
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
                              if (widget.onSellSuccess != null) {
                                widget.onSellSuccess!(gramsSold, _nominalRupiah);
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
            );
          },
        ),
      ),
    );
  }

  Widget _buildReceiptRow(
    String label,
    String value, {
    bool isNumber = false,
    bool isSender = false,
    bool isBoldLabel = false,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Text(
            label,
            style: GoogleFonts.robotoSlab(
              fontSize: isBoldLabel ? 14 : 13,
              fontWeight: isBoldLabel ? FontWeight.bold : FontWeight.normal,
              color: isBoldLabel ? Colors.black : Colors.black87,
            ),
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
                          fontSize: isBoldLabel ? 14 : 13,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        )
                      : GoogleFonts.robotoSlab(
                          fontSize: isBoldLabel ? 14 : 13,
                          fontWeight: isBoldLabel ? FontWeight.bold : FontWeight.normal,
                          color: Colors.black,
                        ),
                ),
        ),
      ],
    );
  }

  // ==========================================
  // STAGE 0: LAYAR UTAMA JUAL EMAS
  // (Figma Frames #905:1764 & #954:1777 & investasi jual emas 5)
  // ==========================================
  @override
  Widget build(BuildContext context) {
    // Estimasi gram berkurang: nominal / harga per gram jual
    final double gramsSold = _nominalRupiah > 0 ? _nominalRupiah / widget.pricePerGramSell : 0.0;
    final double currentValue = widget.currentGrams * widget.pricePerGramSell;
    final bool hasNominal = _nominalRupiah > 0;

    if (_currentStep == 1) {
      return _buildKonfirmasiScreen(gramsSold);
    }

    if (_currentStep == 2) {
      return _buildPinScreen();
    }

    if (_currentStep == 3) {
      return _buildReceiptScreen(gramsSold);
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        top: false,
        child: GestureDetector(
          onTap: _isKeypadOpen
              ? () {
                  setState(() {
                    _isKeypadOpen = false;
                  });
                }
              : null,
          behavior: _isKeypadOpen ? HitTestBehavior.opaque : HitTestBehavior.deferToChild,
          child: Column(
            children: [
              // 1. HEADER (Tinggi 90, #D373FC, Tombol Back, Title JUAL, Chart Icon)
              Container(
                width: double.infinity,
                height: 90,
                padding: const EdgeInsets.only(top: 36, left: 16, right: 16),
                color: const Color(0xFFD373FC),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Color(0xFF52086B), size: 26),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'JUAL',
                      style: GoogleFonts.robotoSlab(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF52086B),
                      ),
                    ),
                    const Spacer(),
                    _buildStaircaseChartIcon(),
                  ],
                ),
              ),

              // 2. KONTEN UTAMA SCROLLABLE
              Expanded(
                child: SingleChildScrollView(
                  physics: _isKeypadOpen
                      ? const BouncingScrollPhysics()
                      : const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // KARTU 1: TABUNGAN EMAS ANDA (#F3D8FF, Radius 10)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 18),
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(18),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF3D8FF),
                            borderRadius: BorderRadius.circular(10),
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
                                'Tabungan Emas Anda',
                                style: GoogleFonts.robotoSlab(
                                  fontSize: 14,
                                  color: Colors.black,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                '${widget.currentGrams.toStringAsFixed(4).replaceAll('.', ',')} Gram',
                                style: GoogleFonts.poppins(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Nilai Saat Ini: Rp ${_formatNumber(currentValue)}',
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

                      const SizedBox(height: 24),

                      // LABEL: Masukkan Nominal Penjualan
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 18),
                        child: Text(
                          'Masukkan Nominal Penjualan',
                          style: GoogleFonts.robotoSlab(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),

                      // KOTAK INPUT ABU-ABU (#AEADAD, Radius 10, Tinggi ~60)
                      // Responsive: Klik untuk toggle keyboard, tidak ada ikon silang tambahan
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 18),
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              _isKeypadOpen = !_isKeypadOpen;
                            });
                          },
                          child: Container(
                            width: double.infinity,
                            height: 60,
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            decoration: BoxDecoration(
                              color: const Color(0xFFAEADAD),
                              borderRadius: BorderRadius.circular(10),
                              border: _isKeypadOpen
                                  ? Border.all(color: const Color(0xFF52086B), width: 1.8)
                                  : null,
                            ),
                            child: Row(
                              children: [
                                Text(
                                  'Rp ',
                                  style: GoogleFonts.robotoSlab(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                Expanded(
                                  child: Row(
                                    children: [
                                      if (hasNominal)
                                        Text(
                                          _formatNumber(_nominalRupiah),
                                          style: GoogleFonts.poppins(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                          ),
                                        ),
                                      // Kursor vertikal saat keypad aktif atau nominal kosong
                                      if (_isKeypadOpen || !hasNominal)
                                        Container(
                                          width: 2.2,
                                          height: 26,
                                          margin: const EdgeInsets.only(left: 2),
                                          color: Colors.black,
                                        ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 6),

                      // Keterangan Emas Berkurang (Rata Kanan)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 18),
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Text.rich(
                            TextSpan(
                              text: 'Emas Berkurang ',
                              style: GoogleFonts.robotoSlab(
                                fontSize: 13,
                                color: Colors.black,
                              ),
                              children: [
                                TextSpan(
                                  text: '${gramsSold.toStringAsFixed(4).replaceAll('.', ',')} Gram',
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
                      ),

                      const SizedBox(height: 24),

                      // LABEL: Pilihan Cepat (Otentik Figma Frame #905:1764)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 18),
                        child: Text(
                          'Pilihan Cepat',
                          style: GoogleFonts.robotoSlab(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      const SizedBox(height: 14),

                      // PILIHAN CEPAT HORIZONTAL LIST (Bisa digeser/drag secara langsung dengan mouse/touch atau tombol navigasi)
                      SizedBox(
                        height: 68,
                        child: Listener(
                          onPointerDown: (PointerDownEvent event) {
                            _dragStartX = event.position.dx;
                            if (_quickChoiceScrollController.hasClients) {
                              _dragStartScrollOffset = _quickChoiceScrollController.offset;
                              _isDraggingQuickChoice = true;
                            }
                          },
                          onPointerMove: (PointerMoveEvent event) {
                            if (_isDraggingQuickChoice && _quickChoiceScrollController.hasClients) {
                              final double dx = event.position.dx - _dragStartX;
                              final double maxScroll = _quickChoiceScrollController.position.maxScrollExtent;
                              final double newOffset = (_dragStartScrollOffset - dx).clamp(0.0, maxScroll);
                              _quickChoiceScrollController.jumpTo(newOffset);
                            }
                          },
                          onPointerUp: (PointerUpEvent event) {
                            _isDraggingQuickChoice = false;
                          },
                          onPointerCancel: (PointerCancelEvent event) {
                            _isDraggingQuickChoice = false;
                          },
                          child: ScrollConfiguration(
                            behavior: ScrollConfiguration.of(context).copyWith(
                              dragDevices: {
                                PointerDeviceKind.touch,
                                PointerDeviceKind.mouse,
                                PointerDeviceKind.stylus,
                                PointerDeviceKind.trackpad,
                                PointerDeviceKind.unknown,
                              },
                            ),
                            child: SingleChildScrollView(
                              controller: _quickChoiceScrollController,
                              scrollDirection: Axis.horizontal,
                              physics: const BouncingScrollPhysics(
                                parent: AlwaysScrollableScrollPhysics(),
                              ),
                              padding: const EdgeInsets.symmetric(horizontal: 18),
                              child: Row(
                                children: [
                                  _buildQuickChoiceCard('Rp 100.000', 100000),
                                  const SizedBox(width: 12),
                                  _buildQuickChoiceCard('Rp 300.000', 300000),
                                  const SizedBox(width: 12),
                                  _buildQuickChoiceCard('Rp 500.000', 500000),
                                  const SizedBox(width: 12),
                                  _buildQuickChoiceCard('Rp 1.000.000', 1000000),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              ),

              // 3. BOTTOM SECTION: Garis Separator, Harga Jual, & Tombol Lanjutkan
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border(
                    top: BorderSide(
                      color: Colors.black.withValues(alpha: 0.15),
                      width: 1,
                    ),
                  ),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x08000000),
                      blurRadius: 8,
                      offset: Offset(0, -3),
                    ),
                  ],
                ),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Row Harga Jual: Rp 2.250.000/ gr
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Text(
                            'Harga Jual:',
                            style: GoogleFonts.robotoSlab(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Flexible(
                          child: Text(
                            'Rp ${_formatNumber(widget.pricePerGramSell)}/ gr',
                            textAlign: TextAlign.right,
                            style: GoogleFonts.poppins(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // Tombol Utama: Lanjutkan (Radius 25, Background #CA31FF, Stadium Pill)
                    SizedBox(
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
                        onPressed: (!hasNominal || gramsSold > widget.currentGrams)
                            ? null
                            : () {
                                setState(() {
                                  _isKeypadOpen = false;
                                  _currentStep = 1; // Masuk ke Konfirmasi Pencairan
                                });
                              },
                        child: Text(
                          'Lanjutkan',
                          style: GoogleFonts.robotoSlab(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // 4. KEYBOARD 4-KOLOM (Responsive: Muncul saat kotak abu-abu diklik)
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
