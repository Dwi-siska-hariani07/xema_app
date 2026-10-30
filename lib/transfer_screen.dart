import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'core/app_icons.dart';
import 'forget_password_screen.dart';

class TransferScreen extends StatefulWidget {
  final bool isEwallet;
  const TransferScreen({super.key, this.isEwallet = false});

  @override
  State<TransferScreen> createState() => _TransferScreenState();
}

class _TransferScreenState extends State<TransferScreen> {
  // Support Input Keyboard Fisik Laptop / PC & Mobile
  String _pin = '';
  final FocusNode _pinMobileFocusNode = FocusNode();
  bool _isKonfirmasiOpen = false;
  VoidCallback? _konfirmasiOnSubmit;

  @override
  void initState() {
    super.initState();
    // Handler untuk menangkap ketikan keyboard laptop secara otomatis
    HardwareKeyboard.instance.addHandler(_handleHardwareKey);
  }

  @override
  void dispose() {
    HardwareKeyboard.instance.removeHandler(_handleHardwareKey);
    _pinMobileFocusNode.dispose();
    super.dispose();
  }

  bool _handleHardwareKey(KeyEvent event) {
    if (event is! KeyDownEvent && event is! KeyRepeatEvent) {
      return false;
    }

    final key = event.logicalKey;
    final char = event.character;

    // Backspace / Delete
    if (key == LogicalKeyboardKey.backspace || key == LogicalKeyboardKey.delete) {
      _handleHardwareDelete();
      return true;
    }

    // Enter / Numpad Enter (Lanjutkan / Konfirmasi / OK)
    if (key == LogicalKeyboardKey.enter || key == LogicalKeyboardKey.numpadEnter) {
      _handleHardwareSubmit();
      return true;
    }

    // Koma ','
    if (key == LogicalKeyboardKey.comma || char == ',') {
      _handleHardwareDigit(',');
      return true;
    }

    // Titik '.'
    if (key == LogicalKeyboardKey.period || key == LogicalKeyboardKey.numpadDecimal || char == '.') {
      _handleHardwareDigit('.');
      return true;
    }

    // Space ' '
    if (key == LogicalKeyboardKey.space || char == ' ') {
      _handleHardwareDigit(' ');
      return true;
    }

    // Minus '-'
    if (key == LogicalKeyboardKey.minus || key == LogicalKeyboardKey.numpadSubtract || char == '-') {
      _handleHardwareDigit('-');
      return true;
    }

    // Angka 0 - 9 dari karakter
    if (char != null && RegExp(r'^[0-9]$').hasMatch(char)) {
      _handleHardwareDigit(char);
      return true;
    }

    // Angka 0 - 9 dari LogicalKeyboardKey
    if (key == LogicalKeyboardKey.digit0 || key == LogicalKeyboardKey.numpad0) {
      _handleHardwareDigit('0');
      return true;
    }
    if (key == LogicalKeyboardKey.digit1 || key == LogicalKeyboardKey.numpad1) {
      _handleHardwareDigit('1');
      return true;
    }
    if (key == LogicalKeyboardKey.digit2 || key == LogicalKeyboardKey.numpad2) {
      _handleHardwareDigit('2');
      return true;
    }
    if (key == LogicalKeyboardKey.digit3 || key == LogicalKeyboardKey.numpad3) {
      _handleHardwareDigit('3');
      return true;
    }
    if (key == LogicalKeyboardKey.digit4 || key == LogicalKeyboardKey.numpad4) {
      _handleHardwareDigit('4');
      return true;
    }
    if (key == LogicalKeyboardKey.digit5 || key == LogicalKeyboardKey.numpad5) {
      _handleHardwareDigit('5');
      return true;
    }
    if (key == LogicalKeyboardKey.digit6 || key == LogicalKeyboardKey.numpad6) {
      _handleHardwareDigit('6');
      return true;
    }
    if (key == LogicalKeyboardKey.digit7 || key == LogicalKeyboardKey.numpad7) {
      _handleHardwareDigit('7');
      return true;
    }
    if (key == LogicalKeyboardKey.digit8 || key == LogicalKeyboardKey.numpad8) {
      _handleHardwareDigit('8');
      return true;
    }
    if (key == LogicalKeyboardKey.digit9 || key == LogicalKeyboardKey.numpad9) {
      _handleHardwareDigit('9');
      return true;
    }

    return false;
  }

  void _handleHardwareDigit(String digit) {
    if (_currentStep == 1) {
      final intVal = int.tryParse(digit);
      if (intVal != null && intVal >= 1 && intVal <= _popularBanks.length) {
        _selectBank(_popularBanks[intVal - 1]);
      }
    } else if (_currentStep == 2) {
      if (_inputAccountNumber.length < 20) {
        setState(() => _inputAccountNumber += digit);
      }
    } else if (_currentStep == 3) {
      if (digit == '.' || digit == ',' || digit == '-') return;
      if (_amount.length < 9) {
        setState(() {
          _isNominalKeypadOpen = true;
          _amount += digit;
        });
      }
    } else if (_currentStep == 4) {
      _onPinDigit(digit);
    }
  }

  void _handleHardwareDelete() {
    if (_currentStep == 2) {
      if (_showPenerimaSheet) {
        setState(() => _showPenerimaSheet = false);
        return;
      }
      if (_inputAccountNumber.isNotEmpty) {
        setState(() => _inputAccountNumber =
            _inputAccountNumber.substring(0, _inputAccountNumber.length - 1));
      }
    } else if (_currentStep == 3) {
      if (_amount.isNotEmpty) {
        setState(() => _amount = _amount.substring(0, _amount.length - 1));
      }
    } else if (_currentStep == 4) {
      _onPinDelete();
    }
  }

  void _handleHardwareSubmit() {
    if (_isKonfirmasiOpen) {
      _konfirmasiOnSubmit?.call();
      return;
    }

    if (_currentStep == 2) {
      if (!_showPenerimaSheet) {
        if (_inputAccountNumber.isEmpty) {
          _inputAccountNumber = _selectedBankCode;
        }
        setState(() => _showPenerimaSheet = true);
      } else {
        setState(() {
          _showPenerimaSheet = false;
          _currentStep = 3;
        });
      }
    } else if (_currentStep == 3) {
      if (_amount.isEmpty || int.tryParse(_amount) == 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Masukkan nominal transfer terlebih dahulu')),
        );
        return;
      }
      _showKonfirmasiTransferSheet();
    } else if (_currentStep == 4) {
      _submitPin();
    } else if (_currentStep == 5) {
      setState(() => _currentStep = 1);
    }
  }
  // Navigation Flow State:
  // 1: Pilih Bank (Figma #103:296)
  // 2: Input No Rekening per Bank (Figma #246:49)
  // 3: Tujuan Transfer & Input Nominal (Figma #152:856 & #558:975)
  // 4: Konfirmasi PIN (Figma #180:1255)
  // 5: Resi Bukti Transaksi Sukses (Figma #403:1048)
  int _currentStep = 1;
  bool _showPenerimaSheet = false;

  // Selected Bank Details (Dynamically reflects whichever bank was tapped)
  String _selectedBankName = 'BSI';
  String _selectedBankFullName = 'Bank Syariah Indonesia (BSI)';
  String _selectedBankCode = '7243567687';
  String _selectedBankLogo = AppIcons.logoBsi;
  String _inputAccountNumber = '';
  final String _recipientName = 'Zavella Meica';
  String _amount = '';
  bool _isNominalKeypadOpen = false;

  final String _userSenderName = 'LISA ARUNIA';
  final String _userSenderPhone = '0851 2343 5656';
  final String _userBalance = '300.000,00';

  // Bank Populer 8 Grid Sesuai Urutan Posisi Node Figma #103:296
  // Baris 1: BAS, BRI, BSI, BNI
  // Baris 2: BTN, MANDIRI, BCA, SeaBank
  final List<Map<String, String>> _popularBanks = [
    {
      'name': 'BAS',
      'fullName': 'Bank Aceh Syariah',
      'acc': '5018273645',
      'logo': AppIcons.logoBas,
    },
    {
      'name': 'BRI',
      'fullName': 'Bank BRI',
      'acc': '0019018273645',
      'logo': AppIcons.logoBri,
    },
    {
      'name': 'BSI',
      'fullName': 'Bank Syariah Indonesia (BSI)',
      'acc': '7243567687',
      'logo': AppIcons.logoBsi,
    },
    {
      'name': 'BNI',
      'fullName': 'Bank BNI',
      'acc': '0981726354',
      'logo': AppIcons.logoBni,
    },
    {
      'name': 'BTN',
      'fullName': 'Bank BTN',
      'acc': '0001827364501',
      'logo': AppIcons.logoBtn,
    },
    {
      'name': 'MANDIRI',
      'fullName': 'Bank Mandiri',
      'acc': '1370019283748',
      'logo': AppIcons.logoMandiri,
    },
    {
      'name': 'BCA',
      'fullName': 'Bank BCA',
      'acc': '8801928374',
      'logo': AppIcons.logoBca,
    },
    {
      'name': 'SeaBank',
      'fullName': 'SeaBank',
      'acc': '9018273645',
      'logo': AppIcons.logoSeaBank,
    },
  ];

  // Daftar Bank Daerah Sesuai Node Figma #103:296 (Line 1 - 15)
  final List<Map<String, String>> _regionalBanks = [
    {
      'name': 'Bank Aceh Syariah',
      'fullName': 'Bank Aceh Syariah',
      'acc': '5018273645',
      'logo': AppIcons.logoBankAceh,
    },
    {
      'name': 'Bank Banten',
      'fullName': 'Bank Banten',
      'acc': '1382910283',
      'logo': AppIcons.logoBankBanten,
    },
    {
      'name': 'Bank Bengkulu',
      'fullName': 'Bank Bengkulu',
      'acc': '1482910284',
      'logo': AppIcons.logoBankBengkulu,
    },
    {
      'name': 'Bank Jabar & Banten (BJB)',
      'fullName': 'Bank Jabar & Banten (BJB)',
      'acc': '1102910285',
      'logo': AppIcons.logoBankBjb,
    },
    {
      'name': 'Bank Jambi',
      'fullName': 'Bank Jambi',
      'acc': '1582910286',
      'logo': AppIcons.logoBankJambi,
    },
    {
      'name': 'Bank Jateng',
      'fullName': 'Bank Jateng',
      'acc': '1682910287',
      'logo': AppIcons.logoBankJateng,
    },
    {
      'name': 'Bank Jatim',
      'fullName': 'Bank Jatim',
      'acc': '1782910288',
      'logo': AppIcons.logoBankJatim,
    },
    {
      'name': 'Bank Kalbar',
      'fullName': 'Bank Kalbar',
      'acc': '1882910289',
      'logo': AppIcons.logoBankKalbar,
    },
    {
      'name': 'Bank Kalsel',
      'fullName': 'Bank Kalsel',
      'acc': '1982910290',
      'logo': AppIcons.logoBankKalsel,
    },
    {
      'name': 'Bank Lampung',
      'fullName': 'Bank Lampung',
      'acc': '2082910291',
      'logo': AppIcons.logoBankLampung,
    },
    {
      'name': 'Bank Maluku Malut',
      'fullName': 'Bank Maluku Malut',
      'acc': '2182910292',
      'logo': AppIcons.logoBankMaluku,
    },
    {
      'name': 'Bank NTT',
      'fullName': 'Bank NTT',
      'acc': '2282910293',
      'logo': AppIcons.logoBankNtt,
    },
    {
      'name': 'Bank Papua',
      'fullName': 'Bank Papua',
      'acc': '2382910294',
      'logo': AppIcons.logoBankPapua,
    },
    {
      'name': 'Bank Pembangunan Daerah Bali',
      'fullName': 'Bank Pembangunan Daerah Bali',
      'acc': '2482910295',
      'logo': AppIcons.logoBankBali,
    },
    {
      'name': 'Bank Sulteng',
      'fullName': 'Bank Sulteng',
      'acc': '2582910296',
      'logo': AppIcons.logoBankSulteng,
    },
    {
      'name': 'Bank Sumut',
      'fullName': 'Bank Sumut',
      'acc': '2682910297',
      'logo': AppIcons.logoBankSumut,
    },
  ];

  // Helper agar nama bank TIDAK double ("BANK Bank Aceh Syariah" -> "BANK ACEH SYARIAH")
  String get _formattedBankTitle {
    final clean = _selectedBankName.trim();
    if (clean.toUpperCase().startsWith('BANK ')) {
      return clean.toUpperCase();
    }
    return 'BANK ${clean.toUpperCase()}';
  }

  String _formatCurrency(String rawNumber) {
    if (rawNumber.isEmpty) return '0';
    try {
      final num = int.parse(rawNumber);
      return NumberFormat.currency(
        locale: 'id_ID',
        symbol: '',
        decimalDigits: 0,
      ).format(num).trim();
    } catch (_) {
      return rawNumber;
    }
  }

  void _selectBank(Map<String, String> bank) {
    setState(() {
      _selectedBankName = bank['name']!;
      _selectedBankFullName = bank['fullName'] ?? bank['name']!;
      _selectedBankCode = bank['acc']!;
      _selectedBankLogo = bank['logo']!;
      _inputAccountNumber = '';
      _showPenerimaSheet = false;
      _currentStep = 2; // Pindah ke Frame Input No Rekening Bank Terpilih (#246:49)
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: _currentStep == 1,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        if (_currentStep == 4) {
          setState(() {
            _pin = '';
            _currentStep = 3;
          });
        } else if (_currentStep == 5) {
          setState(() => _currentStep = 1);
        } else if (_currentStep == 3) {
          if (_isNominalKeypadOpen) {
            setState(() => _isNominalKeypadOpen = false);
            return;
          }
          setState(() => _currentStep = 2);
        } else if (_currentStep == 2) {
          if (_showPenerimaSheet) {
            setState(() => _showPenerimaSheet = false);
            return;
          }
          setState(() => _currentStep = 1);
        }
      },
      child: Scaffold(
        backgroundColor: _currentStep == 5 ? const Color(0xFFF8EAFF) : Colors.white,
        appBar: (_currentStep == 4 || _currentStep == 5) ? null : _buildCustomNavbar(),
        body: SafeArea(
          top: _currentStep != 5,
          child: _buildBody(),
        ),
      ),
    );
  }

  // ==================== NAVBAR FIGMA DENGAN ATURAN FONT ====================
  PreferredSizeWidget _buildCustomNavbar() {
    return PreferredSize(
      preferredSize: const Size.fromHeight(60),
      child: Container(
        color: const Color(0xFFD373FC),
        child: SafeArea(
          bottom: false,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back, color: Color(0xFF300742), size: 26),
                  onPressed: () {
                    if (_currentStep == 2 && _showPenerimaSheet) {
                      setState(() => _showPenerimaSheet = false);
                      return;
                    }
                    if (_currentStep == 2) {
                      setState(() => _currentStep = 1);
                    } else if (_currentStep == 3) {
                      if (_isNominalKeypadOpen) {
                        setState(() => _isNominalKeypadOpen = false);
                        return;
                      }
                      setState(() => _currentStep = 2);
                    } else {
                      Navigator.pop(context);
                    }
                  },
                ),
                const SizedBox(width: 4),
                // Aturan Tipografi User:
                // "Tujuan Transfer" -> Font Rasa
                // Judul lain -> Font Roboto Slab
                Expanded(
                  child: _currentStep == 3
                      ? Text(
                          'Tujuan Transfer',
                          style: GoogleFonts.rasa(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF300742),
                          ),
                        )
                      : Text(
                          'Transfer',
                          style: GoogleFonts.robotoSlab(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF300742),
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

  Widget _buildBody() {
    switch (_currentStep) {
      case 1:
        return _buildPilihBankView();
      case 2:
        return _buildInputNoRekeningView();
      case 3:
        return _buildTujuanTransferNominalView();
      case 4:
        return _buildKonfirmasiPinView();
      case 5:
        return _buildResiBuktiView();
      default:
        return _buildPilihBankView();
    }
  }

  // =========================================================================
  // FRAME 1: TRANSFER (FIGMA FRAME #103:296)
  // Jarak presisi: 2 baris x 4 kolom bank populer di atas banner "Semua Bank"
  // =========================================================================
  Widget _buildPilihBankView() {
    final row1 = _popularBanks.sublist(0, 4); // BAS, BRI, BSI, BNI
    final row2 = _popularBanks.sublist(4, 8); // BTN, MANDIRI, BCA, SeaBank

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Jarak atas ke Baris 1 sesuai Figma (#103:296)
          const SizedBox(height: 20),

          // Baris 1: BAS, BRI, BSI, BNI
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: row1.map((bank) => _buildPopularBankItem(bank)).toList(),
            ),
          ),

          // Jarak antara Baris 1 dan Baris 2 sesuai Figma (~24px)
          const SizedBox(height: 24),

          // Baris 2: BTN, MANDIRI, BCA, SeaBank
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: row2.map((bank) => _buildPopularBankItem(bank)).toList(),
            ),
          ),

          // Jarak bawah Baris 2 sebelum banner "Semua Bank" sesuai Figma (~22px)
          const SizedBox(height: 22),

          // Full-Width Purple Banner "Semua Bank"
          Container(
            width: double.infinity,
            height: 56,
            padding: const EdgeInsets.symmetric(horizontal: 22),
            alignment: Alignment.centerLeft,
            color: const Color(0xFFD373FC),
            child: Text(
              'Semua Bank',
              style: GoogleFonts.robotoSlab(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF300742),
              ),
            ),
          ),

          // Daftar Bank Daerah dengan Logo & Divider Garis Hitam Tipis Persis Figma (Line 1 - 15)
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _regionalBanks.length,
            separatorBuilder: (_, __) => const Divider(
              color: Colors.black,
              height: 1,
              thickness: 0.8,
            ),
            itemBuilder: (context, index) {
              final bank = _regionalBanks[index];
              return InkWell(
                onTap: () => _selectBank(bank),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  child: Row(
                    children: [
                      Container(
                        width: 56,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(14),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.08),
                              blurRadius: 6,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                          child: Center(
                            child: AppIcons.buildImageOrIcon(
                              bank['logo']!,
                              width: 40,
                              height: 36,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 18),
                      Expanded(
                        child: Text(
                          bank['name']!,
                          style: GoogleFonts.robotoSlab(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      // Tanpa ikon chevron '>' sesuai Figma asli
                    ],
                  ),
                ),
              );
            },
          ),
          const Divider(color: Colors.black, height: 1, thickness: 0.8),
          const SizedBox(height: 28),
        ],
      ),
    );
  }

  Widget _buildPopularBankItem(Map<String, String> bank) {
    return InkWell(
      onTap: () => _selectBank(bank),
      borderRadius: BorderRadius.circular(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 72,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.08),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              child: Center(
                child: AppIcons.buildImageOrIcon(
                  bank['logo']!,
                  width: 50,
                  height: 42,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            bank['name']!,
            style: GoogleFonts.robotoSlab(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  // =========================================================================
  // FRAME 2: INPUT NOMOR REKENING SESUAI FIGMA (#246:49)
  // - Posisi logo & nama bank agak ke bawahan dikit
  // - Nama bank bersih tanpa double 'BANK BANK'
  // - Box 'Masukkan no. rekening/nama' warna abu-abu Figma (#AEADAD / #C4C4C4)
  // - Tombol 'Lanjutkan' full-width menempel persis di atas keyboard 4-kolom
  // =========================================================================
  Widget _buildInputNoRekeningView() {
    return Stack(
      children: [
        // Content Atas: Bank Info, Label, Input Box, Tombol Lanjutkan, & Keypad (#246:49)
        Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Jarak vertikal agar letak logo & nama agak ke bawahan dikit sesuai Figma
                    const SizedBox(height: 38),

                    // Icon & Nama Bank Terpilih (Clean format tanpa double BANK)
                    Row(
                      children: [
                        Container(
                          width: 58,
                          height: 52,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.08),
                                blurRadius: 6,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Center(
                            child: AppIcons.buildImageOrIcon(
                              _selectedBankLogo,
                              width: 42,
                              height: 38,
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Text(
                            _formattedBankTitle,
                            style: GoogleFonts.robotoSlab(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 36),

                    // Label Masukkan no. rekening/nama (Font: Roboto Slab)
                    Text(
                      'Masukkan no. rekening/nama',
                      style: GoogleFonts.robotoSlab(
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Box Masukkan no. rekening/nama Figma (Rounded Grey Container #C4C4C4)
                    Container(
                      width: double.infinity,
                      height: 58,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFC4C4C4),
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.12),
                            blurRadius: 6,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              _inputAccountNumber.isEmpty ? '|' : '$_inputAccountNumber|',
                              style: GoogleFonts.poppins(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                                letterSpacing: 1.0,
                              ),
                            ),
                          ),
                          if (_inputAccountNumber.isNotEmpty)
                            GestureDetector(
                              onTap: () => setState(() => _inputAccountNumber = ''),
                              child: const Icon(Icons.close, color: Colors.black54, size: 22),
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),

            // Tombol Lanjutkan Full-Width Persis di Atas Keyboard Sesuai Figma #246:49
            InkWell(
              onTap: () {
                if (_inputAccountNumber.isEmpty) {
                  _inputAccountNumber = _selectedBankCode;
                }
                setState(() => _showPenerimaSheet = true);
              },
              child: Container(
                width: double.infinity,
                height: 56,
                color: const Color(0xFFD373FC),
                alignment: Alignment.center,
                child: Text(
                  'Lanjutkan',
                  style: GoogleFonts.robotoSlab(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF300742),
                  ),
                ),
              ),
            ),

            // Keyboard 4-Kolom Tombol Abu-abu (#D9D9D9) Persis Figma Frame #246:49
            _buildFigma4ColKeypad(
              onDigit: (digit) {
                if (_inputAccountNumber.length < 16) {
                  setState(() => _inputAccountNumber += digit);
                }
              },
              onDelete: () {
                if (_inputAccountNumber.isNotEmpty) {
                  setState(() => _inputAccountNumber =
                      _inputAccountNumber.substring(0, _inputAccountNumber.length - 1));
                }
              },
              onSubmit: () {
                if (_inputAccountNumber.isEmpty) {
                  _inputAccountNumber = _selectedBankCode;
                }
                setState(() => _showPenerimaSheet = true);
              },
            ),
          ],
        ),

        // MODAL / SHEET KONFIRMASI PENERIMA (FIGMA FRAME #558:911)
        if (_showPenerimaSheet) ...[
          // Backdrop redup (dimmed overlay) sesuai Figma
          Positioned.fill(
            child: GestureDetector(
              onTap: () => setState(() => _showPenerimaSheet = false),
              child: Container(
                color: Colors.black.withValues(alpha: 0.2),
              ),
            ),
          ),

          // Bottom Sheet Panel "Penerima" + Card Zavella Meica + Tombol "Konfirmasi" + Keypad
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.15),
                    blurRadius: 16,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 22),
                  // Header "Penerima" (Font Rasa)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Text(
                      'Penerima',
                      style: GoogleFonts.rasa(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),

                  // Card Penerima (Avatar Recipient + Zavella Meica + BSI 7243567687)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0xFFE5E5E5), width: 1.2),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.06),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          // User circular avatar icon persis Figma #558:911
                          AppIcons.buildImageOrIcon(
                            AppIcons.avatarRecipient,
                            width: 44,
                            height: 44,
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _recipientName, // 'Zavella Meica'
                                  style: GoogleFonts.robotoSlab(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                FittedBox(
                                  fit: BoxFit.scaleDown,
                                  alignment: Alignment.centerLeft,
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        '$_selectedBankName  ',
                                        style: GoogleFonts.robotoSlab(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                      ),
                                      Text(
                                        _selectedBankCode,
                                        style: GoogleFonts.poppins(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black,
                                          letterSpacing: 0.5,
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
                    ),
                  ),
                  const SizedBox(height: 18),

                  // Tombol Konfirmasi Full-Width Persis di Atas Keyboard Sesuai Figma #558:911
                  InkWell(
                    onTap: () {
                      setState(() {
                        _showPenerimaSheet = false;
                        _currentStep = 3; // Lanjut ke Frame Tujuan Transfer & Input Nominal
                      });
                    },
                    child: Container(
                      width: double.infinity,
                      height: 56,
                      color: const Color(0xFFD373FC),
                      alignment: Alignment.center,
                      child: Text(
                        'Konfirmasi',
                        style: GoogleFonts.robotoSlab(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF300742),
                        ),
                      ),
                    ),
                  ),

                  // Keyboard 4-Kolom di Bawah Tombol Konfirmasi
                  _buildFigma4ColKeypad(
                    onDigit: (digit) {
                      if (_inputAccountNumber.length < 16) {
                        setState(() => _inputAccountNumber += digit);
                      }
                    },
                    onDelete: () {
                      if (_inputAccountNumber.isNotEmpty) {
                        setState(() => _inputAccountNumber =
                            _inputAccountNumber.substring(0, _inputAccountNumber.length - 1));
                      }
                    },
                    onSubmit: () {
                      setState(() {
                        _showPenerimaSheet = false;
                        _currentStep = 3;
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ],
    );
  }

  // =========================================================================
  // FRAME 3: TUJUAN TRANSFER & NOMINAL (FIGMA #152:856 & #558:975)
  // - "Tujuan Transfer" -> FONT RASA (Header)
  // - Tanpa pilihan cepat nominal (100, 200, dst)
  // - Box Nominal Abu-abu teks putih 'Rp |'
  // - Tombol Lanjutkan full-width menempel persis di atas keyboard 4-kolom
  // =========================================================================
  Widget _buildTujuanTransferNominalView() {
    final displayAccount =
        _inputAccountNumber.isEmpty ? _selectedBankCode : _inputAccountNumber;

    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. Kartu Penerima (Figma Frame #152:856)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.08),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      // Avatar bulat Zavella Meica persis ukuran item Figma (42 x 42)
                      AppIcons.buildImageOrIcon(
                        AppIcons.avatarRecipient,
                        width: 42,
                        height: 42,
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _recipientName, // 'Zavella Meica'
                              style: GoogleFonts.robotoSlab(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(height: 4),
                            FittedBox(
                              fit: BoxFit.scaleDown,
                              alignment: Alignment.centerLeft,
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    '$_selectedBankName  ',
                                    style: GoogleFonts.robotoSlab(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                  Text(
                                    displayAccount,
                                    style: GoogleFonts.poppins(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black,
                                      letterSpacing: 0.5,
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
                ),

                const SizedBox(height: 24),

                // 2. Input Nominal (Label Roboto Slab + Box Abu-abu Figma dengan Teks Putih)
                Text(
                  'Masukkan Nominal',
                  style: GoogleFonts.robotoSlab(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 8),

                GestureDetector(
                  onTap: () => setState(() => _isNominalKeypadOpen = true),
                  child: Container(
                    width: double.infinity,
                    height: 58,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFC4C4C4),
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.12),
                          blurRadius: 6,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Text(
                          'Rp ',
                          style: GoogleFonts.robotoSlab(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            _amount.isEmpty ? '|' : '${_formatCurrency(_amount)}|',
                            style: GoogleFonts.poppins(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        if (_amount.isNotEmpty)
                          GestureDetector(
                            onTap: () => setState(() => _amount = ''),
                            child: const Icon(Icons.close, color: Colors.white, size: 20),
                          ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // 3. Kartu Rekening Sumber (Figma Frame #152:856)
                Text(
                  'Rekening Sumber',
                  style: GoogleFonts.robotoSlab(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 8),

                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.08),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Icon user Rekening Sumber: squircle ungu 60 x 46 persis Figma
                      AppIcons.buildImageOrIcon(
                        AppIcons.icSumberUser,
                        width: 60,
                        height: 46,
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Rekening Sumber',
                              style: GoogleFonts.robotoSlab(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(height: 3),
                            Row(
                              children: [
                                Text(
                                  'Rp ',
                                  style: GoogleFonts.robotoSlab(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                Text(
                                  _userBalance,
                                  style: GoogleFonts.poppins(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Text(
                        _userSenderPhone,
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        ),

        // 4. Tombol Lanjutkan & Keypad
        if (!_isNominalKeypadOpen)
          // Frame #152:856: Tombol Lanjutkan Stadium Pill di Bagian Bawah
          Padding(
            padding: const EdgeInsets.only(left: 16, right: 16, bottom: 42),
            child: InkWell(
              onTap: _handleLanjutkanTransfer,
              borderRadius: BorderRadius.circular(30),
              child: Container(
                width: double.infinity,
                height: 56,
                decoration: BoxDecoration(
                  color: const Color(0xFFD373FC),
                  borderRadius: BorderRadius.circular(30),
                ),
                alignment: Alignment.center,
                child: Text(
                  'Lanjutkan',
                  style: GoogleFonts.robotoSlab(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF300742),
                  ),
                ),
              ),
            ),
          )
        else ...[
          // Frame #558:975: Tombol Lanjutkan Full-Width di Atas Keypad
          // Sedikit bergeser naik (-20px) agar menutupi bagian bawah Rekening Sumber sesuai Figma #578:1675
          Transform.translate(
            offset: const Offset(0, -20),
            child: InkWell(
              onTap: _handleLanjutkanTransfer,
              child: Container(
                width: double.infinity,
                height: 56,
                color: const Color(0xFFD373FC),
                alignment: Alignment.center,
                child: Text(
                  'Lanjutkan',
                  style: GoogleFonts.robotoSlab(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF300742),
                  ),
                ),
              ),
            ),
          ),

          // Keypad 4-Kolom
          _buildFigma4ColKeypad(
            onDigit: (digit) {
              if (_amount.length < 9) {
                setState(() => _amount += digit);
              }
            },
            onDelete: () {
              if (_amount.isNotEmpty) {
                setState(() => _amount = _amount.substring(0, _amount.length - 1));
              }
            },
            onSubmit: _handleLanjutkanTransfer,
          ),
        ],
      ],
    );
  }

  void _handleLanjutkanTransfer() {
    if (_amount.isEmpty || int.tryParse(_amount) == 0) {
      _amount = '100000'; // Default nominal transfer Figma
    }
    _showKonfirmasiTransferSheet();
  }

  Widget _buildFigma4ColKeypad({
    required Function(String) onDigit,
    required VoidCallback onDelete,
    required VoidCallback onSubmit,
  }) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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

  // =========================================================================
  // FRAME 4: MODAL KONFIRMASI TRANSFER (FIGMA #578:1675)
  // - Logo User (BUKAN Bank)
  // - Tanpa garis divider terlihat
  // - Nominal, Biaya Admin Rp 0, Total
  // - Tombol Konfirmasi Magenta (#BD38FC)
  // =========================================================================
  void _showKonfirmasiTransferSheet() {
    final displayAccount =
        _inputAccountNumber.isEmpty ? _selectedBankCode : _inputAccountNumber;

    // Pastikan tombol Lanjutkan di background terangkat tinggi menutupi Rekening Sumber sesuai Figma #578:1675
    setState(() {
      _isNominalKeypadOpen = true;
    });

    _isKonfirmasiOpen = true;
    _konfirmasiOnSubmit = () {
      Navigator.pop(context);
      setState(() {
        _pin = '';
        _currentStep = 4;
      });
    };

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withValues(alpha: 0.25), // Background tertutup bayangan/scrim tanpa blur sesuai Figma
      builder: (context) {
        return Container(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(32),
              topRight: Radius.circular(32),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.22),
                blurRadius: 24,
                spreadRadius: 3,
                offset: const Offset(0, -8),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header: Konfirmasi Transfer [Font: Rasa, Bold 24sp]
              Text(
                'Konfirmasi Transfer',
                style: GoogleFonts.rasa(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 18),

              // Detail Penerima: Kartu Ungu Muda (#F3D8FF) dengan Ikon User Bulat Resmi Figma
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  color: const Color(0xFFF3D8FF),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.04),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    // Avatar User Bulat Figma (42 x 42 px)
                    AppIcons.buildImageOrIcon(
                      AppIcons.avatarRecipient,
                      width: 42,
                      height: 42,
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _recipientName,
                            style: GoogleFonts.robotoSlab(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 3),
                          FittedBox(
                            fit: BoxFit.scaleDown,
                            alignment: Alignment.centerLeft,
                            child: Row(
                              children: [
                                Text(
                                  '$_selectedBankName ',
                                  style: GoogleFonts.robotoSlab(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black,
                                  ),
                                ),
                                Text(
                                  displayAccount,
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
              ),

              const SizedBox(height: 24),

              // Baris Rincian Transfer [Label: Roboto Slab, Nominal/Angka: Poppins]
              _buildKonfirmasiRow('Nominal', 'Rp ${_formatCurrency(_amount)}'),
              const SizedBox(height: 16),
              _buildKonfirmasiRow('Biaya Admin', 'Rp 0'),
              const SizedBox(height: 16),
              _buildKonfirmasiRow(
                'Total',
                'Rp ${_formatCurrency(_amount)}',
                isBold: true,
              ),

              const SizedBox(height: 30),

              // Tombol Konfirmasi Magenta Stadium Pill (#CA31FF) Sesuai Figma #578:1675
              Center(
                child: SizedBox(
                  width: 260,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context); // Tutup konfirmasi modal sheet
                      setState(() {
                        _pin = '';
                        _currentStep = 4; // Transisi full screen ke Frame Konfirmasi PIN (#180:1255)
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFCA31FF),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      elevation: 0,
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
              ),
              const SizedBox(height: 10),
            ],
          ),
        );
      },
    ).whenComplete(() {
      _isKonfirmasiOpen = false;
      _konfirmasiOnSubmit = null;
    });
  }

      Widget _buildKonfirmasiRow(String label, String value, {bool isBold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.robotoSlab(
            fontSize: 16,
            color: Colors.black,
            fontWeight: isBold ? FontWeight.bold : FontWeight.w400,
          ),
        ),
        Text(
          value,
          style: isBold
              ? GoogleFonts.poppins(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                )
              : GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
        ),
      ],
    );
  }

  // =========================================================================
  // FRAME 4: KONFIRMASI PIN FULL SCREEN (FIGMA FRAME #180:1255)
  // - Full Frame View: Transisi mulus dari konfirmasi transfer sheet
  // - Top Left: Tombol Kembali Bulat (AppIcons.icBackCircle)
  // - Center Icon: Logo Kunci Squircle Asli Figma (AppIcons.icPinKey)
  // - Header: 'Konfirmasi PIN' [Font: Rasa, Bold 32sp]
  // - Subtitle: 'Masukkan 6-digit PIN Trasaksi kamu' [Font: Roboto Slab 16sp]
  // - 6 Dots PIN Indicator: Bulat 20x20 pt, jarak 17 pt, warna aktif #1C0823, inaktif #D9D9D9
  // - Link 'Lupa PIN?': Terhubung ke ForgetPasswordScreen [Font: Roboto Slab 18sp]
  // - Keypad 3-Kolom Font Poppins untuk Angka (1-9, 0)
  // - Dynamic Action Key: Ikon Backspace saat digit < 6, berubah jadi Ikon Centang saat 6 digit lengkap
  // - Tapping Centang / Enter langsung menuju ke Bukti Transaksi Sukses (_currentStep = 5)
  // - Dual Keyboard: Mengetik via keyboard fisik laptop/PC & keyboard HP / on-screen
  // =========================================================================
  void _onPinDigit(String digit) {
    if (_pin.length < 6) {
      setState(() {
        _pin += digit;
      });
    }
  }

  void _onPinDelete() {
    if (_pin.isNotEmpty) {
      setState(() {
        _pin = _pin.substring(0, _pin.length - 1);
      });
    }
  }

  void _submitPin() {
    if (_pin.length == 6) {
      setState(() {
        _currentStep = 5; // Masuk ke Bukti Transaksi Sukses (Figma #403:1048)
      });
    }
  }

  Widget _buildKonfirmasiPinView() {
    return Container(
      color: Colors.white,
      width: double.infinity,
      height: double.infinity,
      child: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      children: [
                        const SizedBox(height: 8),
                        // Tombol Kembali Bulat Otentik Figma di pojok kiri atas
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  _pin = '';
                                  _currentStep = 3;
                                });
                              },
                              child: AppIcons.buildImageOrIcon(
                                AppIcons.icBackCircle,
                                width: 48,
                                height: 48,
                                fallbackIcon: Icons.arrow_circle_left_outlined,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 16),

                        // Logo Kunci Squircle Otentik Figma Frame #180:1255 (BUKAN Gembok)
                        Center(
                          child: AppIcons.buildImageOrIcon(
                            AppIcons.icPinKey,
                            width: 104,
                            height: 102,
                            fallbackIcon: Icons.key_rounded,
                          ),
                        ),

                        const SizedBox(height: 18),

                        // Header: Konfirmasi PIN [Font: Rasa, Bold 36sp]
                        Text(
                          'Konfirmasi PIN',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.rasa(
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),

                        const SizedBox(height: 4),

                        // Subtitle: Masukkan 6-digit PIN Trasaksi kamu [Font: Roboto Slab 16sp]
                        Text(
                          'Masukkan 6-digit PIN Trasaksi kamu',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.robotoSlab(
                            fontSize: 16,
                            color: Colors.black,
                            fontWeight: FontWeight.w400,
                          ),
                        ),

                        const SizedBox(height: 44),

                        // Indikator 6 Digit PIN (Muncul Angka Font Poppins saat diisi, Titik Abu saat kosong)
                        // Ketuk titik untuk fokus keyboard HP jika diinginkan
                        GestureDetector(
                          onTap: () => _pinMobileFocusNode.requestFocus(),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(6, (idx) {
                              final isFilled = idx < _pin.length;
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
                        ),

                        const SizedBox(height: 52),

                        // Lupa PIN - Sambungan Navigasi ke ForgetPasswordScreen [Font: Roboto Slab 22sp Bold]
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const ForgetPasswordScreen(),
                              ),
                            );
                          },
                          child: Text(
                            'Lupa PIN?',
                            style: GoogleFonts.robotoSlab(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF772096),
                            ),
                          ),
                        ),

                        const Spacer(),

                        // Keypad PIN 3-Kolom Font Poppins untuk Angka Sesuai Figma Frame #180:1255
                        // Baris 1: 1, 2, 3
                        // Baris 2: 4, 5, 6
                        // Baris 3: 7, 8, 9
                        // Baris 4: kosong, 0, tombol aksi dinamis (hapus -> centang saat 6 digit)
                        _buildPinKeypad(),

                        const SizedBox(height: 28),

                        // Input tersembunyi untuk mendukung input keyboard HP
                        SizedBox(
                          width: 1,
                          height: 1,
                          child: Opacity(
                            opacity: 0,
                            child: TextField(
                              focusNode: _pinMobileFocusNode,
                              keyboardType: TextInputType.number,
                              onChanged: (val) {
                                if (val.isNotEmpty) {
                                  for (int i = 0; i < val.length; i++) {
                                    if (RegExp(r'^[0-9]$').hasMatch(val[i])) {
                                      _onPinDigit(val[i]);
                                    }
                                  }
                                }
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
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
            _buildPinNumberKey('1'),
            _buildPinNumberKey('2'),
            _buildPinNumberKey('3'),
          ],
        ),
        const SizedBox(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildPinNumberKey('4'),
            _buildPinNumberKey('5'),
            _buildPinNumberKey('6'),
          ],
        ),
        const SizedBox(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildPinNumberKey('7'),
            _buildPinNumberKey('8'),
            _buildPinNumberKey('9'),
          ],
        ),
        const SizedBox(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const SizedBox(width: 80, height: 60),
            _buildPinNumberKey('0'),
            _buildPinActionKey(),
          ],
        ),
      ],
    );
  }

  Widget _buildPinNumberKey(String num) {
    return InkResponse(
      onTap: () => _onPinDigit(num),
      radius: 36,
      child: SizedBox(
        width: 80,
        height: 60,
        child: Center(
          child: Text(
            num,
            style: GoogleFonts.poppins(
              fontSize: 30,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPinActionKey() {
    final isComplete = _pin.length == 6;
    return InkResponse(
      onTap: isComplete ? _submitPin : _onPinDelete,
      radius: 36,
      child: SizedBox(
        width: 80,
        height: 60,
        child: Center(
          child: isComplete
              ? AppIcons.buildImageOrIcon(
                  AppIcons.icKeypadCheck,
                  width: 36,
                  height: 32,
                  fallbackIcon: Icons.check,
                  fallbackColor: Colors.black,
                )
              : AppIcons.buildImageOrIcon(
                  AppIcons.icKeypadDelete,
                  width: 36,
                  height: 30,
                  fallbackIcon: Icons.backspace_outlined,
                  fallbackColor: Colors.black,
                ),
        ),
      ),
    );
  }
  
    // =========================================================================
  // FRAME 5: RESI BUKTI TRANSAKSI (FIGMA FRAME #403:1048)
  // - Background layar putih bersih & Header ungu #D373FC dengan popper art & share icon
  // - Kartu Struk Resi dengan pewarnaan bg rectangle otentik Figma #F6E1FF & shadow ungu lembut
  // - Header 'Bukti Transaksi' [Font: Rasa, Bold 26sp]
  // - Badge Ceklis Sukses Lingkaran Magenta #CA31FF
  // - Data Transaksi Lengkap (Nomor Referensi, Tanggal, Sumber Dana XEMA)
  // - Bagian 'SUKSES!' [Font: Roboto Slab 28sp Magenta dengan glow shadow]
  // - Data Penerima (Zavella Meica, No Rekening, Bank BSI)
  // - Rincian Transfer: Nominal & Biaya Admin 'Gratis' (#FE4D55 Coral Red)
  // - TOTAL: Huruf Roboto Slab Bold 22sp & Angka Poppins Bold 24sp
  // - Tombol OK di bagian bawah: Stadium Pill Magenta #CA31FF dengan border outline hitam solid 2px
  // =========================================================================
  Widget _buildResiBuktiView() {
    final displayAccount =
        _inputAccountNumber.isEmpty ? _selectedBankCode : _inputAccountNumber;

    return Container(
      color: Colors.white,
      width: double.infinity,
      height: double.infinity,
      child: SafeArea(
        top: false, // Memungkinkan header ungu mencapai status bar atas secara elegan
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Column(
                    children: [
                      // Header Ungu dengan Art Party Popper & Tombol Share (Figma #403:1048)
                      Stack(
                        alignment: Alignment.topCenter,
                        children: [
                          Container(
                            width: double.infinity,
                            height: 220,
                            color: const Color(0xFFD373FC),
                          ),
                          // Tombol Share di pojok kanan atas
                          Positioned(
                            top: 36,
                            right: 24,
                            child: GestureDetector(
                              onTap: () {},
                              child: AppIcons.buildImageOrIcon(
                                AppIcons.icShareBukti,
                                width: 30,
                                height: 32,
                                fallbackIcon: Icons.share_outlined,
                                fallbackColor: Colors.white,
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
                            ),
                          ),
                        ],
                      ),

                      // Kartu Struk Resi / Group 26 Otentik Figma (#403:1055, x=25, w=351, y=178)
                      Transform.translate(
                        offset: const Offset(0, -10), // Posisi pas diturunkan sedikit dari header sesuai Figma
                        child: Padding(
                          padding: const EdgeInsets.only(left: 25, right: 17), // x=25 dan lebar 351 persis Figma
                          child: Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: const Color(0xFFF6E1FF), // Pewarnaan bg rectangle otentik Figma
                              borderRadius: BorderRadius.circular(28),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFFD373FC).withValues(alpha: 0.35),
                                  blurRadius: 18,
                                  spreadRadius: 1,
                                  offset: const Offset(0, 6),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const SizedBox(height: 20),
                                // Badge Ceklis Sukses Lingkaran Otentik Figma
                                AppIcons.buildImageOrIcon(
                                  AppIcons.icReceiptCheck,
                                  width: 67,
                                  height: 67,
                                  fallbackIcon: Icons.check_circle,
                                  fallbackColor: const Color(0xFFCA31FF),
                                ),
                                const SizedBox(height: 12),

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

                                const SizedBox(height: 22),

                                // Bagian 1: Data Transaksi
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 20),
                                  child: Column(
                                    children: [
                                      _buildReceiptRow('Nomor  Referensi', '45499730898', isNumber: true),
                                      const SizedBox(height: 10),
                                      _buildReceiptRow('Tanggal Transaksi', '1 Okt 2026  09:18:67 WIB', isNumber: true),
                                      const SizedBox(height: 10),
                                      _buildReceiptRow(
                                        'Sumber Dana (XEMA):',
                                        '$_userSenderName\n$_userSenderPhone',
                                        isSender: true,
                                      ),
                                    ],
                                  ),
                                ),

                                const SizedBox(height: 18),
                                const Divider(color: Color(0xFFD8C7E2), height: 1, thickness: 1),
                                const SizedBox(height: 16),

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

                                const SizedBox(height: 14),

                                // Nama Penerima & Detail Akun
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 20),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Nama Penerima',
                                        style: GoogleFonts.robotoSlab(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Flexible(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.end,
                                          children: [
                                            Text.rich(
                                              TextSpan(
                                                children: [
                                                  TextSpan(
                                                    text: '$_recipientName (',
                                                    style: GoogleFonts.robotoSlab(
                                                      fontSize: 14,
                                                      fontWeight: FontWeight.bold,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                  TextSpan(
                                                    text: displayAccount,
                                                    style: GoogleFonts.poppins(
                                                      fontSize: 14,
                                                      fontWeight: FontWeight.bold,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                  TextSpan(
                                                    text: ')',
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
                                            const SizedBox(height: 2),
                                            Text(
                                              _selectedBankFullName,
                                              textAlign: TextAlign.right,
                                              style: GoogleFonts.robotoSlab(
                                                fontSize: 13,
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

                                const SizedBox(height: 18),
                                const Divider(color: Color(0xFFD8C7E2), height: 1, thickness: 1),
                                const SizedBox(height: 16),

                                // Bagian 3: Nominal Transfer & Biaya Admin
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 20),
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'Nominal  Transfer',
                                            style: GoogleFonts.robotoSlab(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black,
                                            ),
                                          ),
                                          Text.rich(
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
                                                  text: _formatCurrency(_amount),
                                                  style: GoogleFonts.poppins(
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 10),
                                      Row(
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
                                          Text(
                                            'Gratis',
                                            style: GoogleFonts.robotoSlab(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                              color: const Color(0xFFFE4D55), // Coral Red otentik Figma
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),

                                const SizedBox(height: 18),
                                const Divider(color: Color(0xFFB8A9BF), height: 1.5, thickness: 1.5),
                                const SizedBox(height: 18),

                                // Bagian 4: TOTAL
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 20),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'TOTAL',
                                        style: GoogleFonts.robotoSlab(
                                          fontSize: 22,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                      ),
                                      Text.rich(
                                        TextSpan(
                                          children: [
                                            TextSpan(
                                              text: 'Rp ',
                                              style: GoogleFonts.robotoSlab(
                                                fontSize: 22,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black,
                                              ),
                                            ),
                                            TextSpan(
                                              text: _formatCurrency(_amount),
                                              style: GoogleFonts.poppins(
                                                fontSize: 24,
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

                                const SizedBox(height: 48), // Bottom padding kartu yang pas sesuai Figma (#403:1048)
                              ],
                            ),
                          ),
                        ),
                      ),

                      // Jarak presisi antara kartu struk dan tombol OK (Figma: 17.5 pt ~ 18 pt)
                      // Karena kartu memiliki visual offset -10 pt, SizedBox(8) menghasilkan visual gap pas 18 pt (agak mepet tapi tidak menempel)
                      const SizedBox(height: 8),

                      // TOMBOL OK DI PALING BAWAH SESUAI FIGMA #403:1048
                      // Stadium Pill Magenta #CA31FF dengan Outline Border Hitam Solid 2px
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 14),
                        child: Container(
                          width: double.infinity,
                          height: 48,
                          decoration: BoxDecoration(
                            color: const Color(0xFFCA31FF),
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(color: Colors.black, width: 2.0),
                          ),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(24),
                              onTap: () {
                                setState(() => _currentStep = 1);
                              },
                              child: Center(
                                child: Text(
                                  'OK',
                                  style: GoogleFonts.robotoSlab(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            );
          },
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
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const SizedBox(width: 12),
        Flexible(
          child: isSender
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      value.split('\n')[0],
                      textAlign: TextAlign.right,
                      style: GoogleFonts.robotoSlab(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      value.split('\n').length > 1 ? value.split('\n')[1] : '',
                      textAlign: TextAlign.right,
                      style: GoogleFonts.poppins(
                        fontSize: 14,
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
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        )
                      : GoogleFonts.robotoSlab(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                ),
        ),
      ],
    );
  }
}
