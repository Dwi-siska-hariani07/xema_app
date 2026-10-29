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
  // Navigation Flow State:
  // 1: Pilih Bank (Figma #103:296)
  // 2: Input No Rekening per Bank (Figma #246:49)
  // 3: Tujuan Transfer & Input Nominal (Figma #152:856 & #558:975)
  // 4: Resi Bukti Transaksi Sukses (Figma #403:1048)
  int _currentStep = 1;

  // Selected Bank Details (Dynamically reflects whichever bank was tapped)
  String _selectedBankName = 'BSI';
  String _selectedBankFullName = 'Bank Syariah Indonesia (BSI)';
  String _selectedBankCode = '7243567687';
  String _selectedBankLogo = AppIcons.logoBsi;
  String _inputAccountNumber = '';
  final String _recipientName = 'Zavella Meica';
  String _amount = '100000';

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
      _currentStep = 2; // Pindah ke Frame Input No Rekening Bank Terpilih (#246:49)
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _currentStep == 4 ? const Color(0xFFF8EAFF) : Colors.white,
      appBar: _buildCustomNavbar(),
      body: SafeArea(
        child: _buildBody(),
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
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new, color: Color(0xFF52086B), size: 22),
                  onPressed: () {
                    if (_currentStep == 2) {
                      setState(() => _currentStep = 1);
                    } else if (_currentStep == 3) {
                      setState(() => _currentStep = 2);
                    } else if (_currentStep == 4) {
                      Navigator.pop(context);
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
                            fontSize: 26,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF52086B),
                          ),
                        )
                      : Text(
                          _currentStep == 1 || _currentStep == 2
                              ? 'Transfer'
                              : 'Bukti Transaksi',
                          style: GoogleFonts.robotoSlab(
                            fontSize: 24,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF52086B),
                          ),
                        ),
                ),
                if (_currentStep == 4)
                  AppIcons.buildImageOrIcon(
                    AppIcons.icShare,
                    width: 22,
                    height: 22,
                    fallbackIcon: Icons.share_outlined,
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
        return _buildResiBuktiView();
      default:
        return _buildPilihBankView();
    }
  }

  // =========================================================================
  // FRAME 1: TRANSFER (FIGMA FRAME #103:296)
  // Tombol logo bank rounded rectangle (Rectangle 37) terpisah dari teks namanya
  // =========================================================================
  Widget _buildPilihBankView() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Grid 8 Bank Populer: Logo berada di dalam rectangle button tersendiri,
          // nama bank berada di bawah button persis desain Figma #103:296
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _popularBanks.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                crossAxisSpacing: 10,
                mainAxisSpacing: 14,
                childAspectRatio: 0.82,
              ),
              itemBuilder: (context, index) {
                final bank = _popularBanks[index];
                return InkWell(
                  onTap: () => _selectBank(bank),
                  borderRadius: BorderRadius.circular(10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Button Logo Bank (Rectangle 37 di Figma)
                      Container(
                        width: 48,
                        height: 44,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: const Color(0xFFE2E2E2)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.05),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Center(
                          child: AppIcons.buildImageOrIcon(bank['logo']!, width: 34, height: 30),
                        ),
                      ),
                      const SizedBox(height: 6),
                      // Teks Nama Bank di luar button
                      Text(
                        bank['name']!,
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.robotoSlab(
                          fontSize: 11,
                          fontWeight: FontWeight.w400,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),

          // 2. Full-Width Purple Banner "Semua Bank" (Rectangle 49)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            color: const Color(0xFFD373FC),
            child: Text(
              'Semua Bank',
              style: GoogleFonts.robotoSlab(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF52086B),
              ),
            ),
          ),

          // 3. Daftar Bank Daerah dengan Logo Asli & Garis Divider Halus (Figma Line 1 - Line 15)
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _regionalBanks.length,
            separatorBuilder: (_, __) => const Divider(
              color: Color(0xFFE5E5E5),
              height: 1,
              thickness: 1,
            ),
            itemBuilder: (context, index) {
              final bank = _regionalBanks[index];
              return InkWell(
                onTap: () => _selectBank(bank),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 38,
                        height: 32,
                        child: Center(
                          child: AppIcons.buildImageOrIcon(
                            bank['logo']!,
                            width: 34,
                            height: 28,
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
                    ],
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  // =========================================================================
  // FRAME 2: INPUT NOMOR REKENING SESUAI FIGMA (#246:49)
  // - Icon & Nama Bank Terpilih
  // - Button/Box "Masukkan no. rekening/nama" (tanpa nama penerima)
  // - Tombol "Lanjutkan" ungu (#D373FC)
  // - Keyboard 4-Kolom tombol abu-abu (#D9D9D9) persis Figma
  // =========================================================================
  Widget _buildInputNoRekeningView() {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Icon & Nama Bank Terpilih
                Row(
                  children: [
                    SizedBox(
                      width: 44,
                      height: 40,
                      child: Center(
                        child: AppIcons.buildImageOrIcon(_selectedBankLogo, width: 40, height: 36),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Text(
                      'BANK $_selectedBankName',
                      style: GoogleFonts.robotoSlab(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF52086B),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // Button/Box Masukkan no. rekening/nama (Figma #246:49)
                Text(
                  'Masukkan no. rekening/nama',
                  style: GoogleFonts.robotoSlab(
                    fontSize: 14,
                    color: const Color(0xFF52086B),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),

                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFD9D9D9),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          _inputAccountNumber.isEmpty
                              ? 'Ketik nomor rekening...'
                              : _inputAccountNumber,
                          style: GoogleFonts.poppins(
                            fontSize: _inputAccountNumber.isEmpty ? 15 : 20,
                            fontWeight: FontWeight.w600,
                            color: _inputAccountNumber.isEmpty
                                ? const Color(0xFF757575)
                                : Colors.black,
                            letterSpacing: 1.0,
                          ),
                        ),
                      ),
                      if (_inputAccountNumber.isNotEmpty)
                        GestureDetector(
                          onTap: () => setState(() => _inputAccountNumber = ''),
                          child: const Icon(Icons.close, color: Color(0xFF52086B), size: 20),
                        ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Tombol Lanjutkan Figma (Warna #D373FC, teks #52086B)
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_inputAccountNumber.isEmpty) {
                        _inputAccountNumber = _selectedBankCode;
                      }
                      setState(() => _currentStep = 3);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFD373FC),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(26)),
                      elevation: 0,
                    ),
                    child: Text(
                      'Lanjutkan',
                      style: GoogleFonts.robotoSlab(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF52086B),
                      ),
                    ),
                  ),
                ),
              ],
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
            setState(() => _currentStep = 3);
          },
        ),
      ],
    );
  }

  // =========================================================================
  // FRAME 3: TUJUAN TRANSFER & NOMINAL (FIGMA #152:856 & #558:975)
  // - "Tujuan Transfer" -> FONT RASA (Header)
  // - Tanpa pilihan cepat nominal (100, 200, dst)
  // - Keyboard 4-kolom persis Figma
  // =========================================================================
  Widget _buildTujuanTransferNominalView() {
    final displayAccount =
        _inputAccountNumber.isEmpty ? _selectedBankCode : _inputAccountNumber;

    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Kartu Penerima (Zavella Meica + Bank Terpilih)
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFFCA31FF), width: 1.2),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF772096).withValues(alpha: 0.08),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: const BoxDecoration(
                          color: Color(0xFFF3D8FF),
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: AppIcons.buildImageOrIcon(
                            AppIcons.avatarRecipient,
                            width: 36,
                            height: 36,
                            fallbackIcon: Icons.person,
                          ),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _recipientName,
                              style: GoogleFonts.robotoSlab(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Row(
                              children: [
                                Text(
                                  '$_selectedBankName ',
                                  style: GoogleFonts.robotoSlab(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: const Color(0xFF570374),
                                  ),
                                ),
                                Text(
                                  displayAccount,
                                  style: GoogleFonts.poppins(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: const Color(0xFF570374),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.edit_outlined, color: Color(0xFF772096), size: 20),
                        onPressed: () => setState(() => _currentStep = 2),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // Box Masukkan Nominal (Figma Rectangle 86)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFBF8FD),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFFD373FC), width: 1),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Masukkan Nominal',
                        style: GoogleFonts.robotoSlab(
                          fontSize: 13,
                          color: const Color(0xFF570374),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'Rp ',
                            style: GoogleFonts.robotoSlab(
                              fontSize: 24,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF52086B),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              _formatCurrency(_amount),
                              style: GoogleFonts.poppins(
                                fontSize: 26,
                                fontWeight: FontWeight.w700,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          if (_amount.isNotEmpty)
                            GestureDetector(
                              onTap: () => setState(() => _amount = ''),
                              child: const Icon(Icons.close, color: Color(0xFF939393), size: 20),
                            ),
                        ],
                      ),
                      const Divider(color: Color(0xFFCA31FF), thickness: 1.2, height: 16),
                    ],
                  ),
                ),

                const SizedBox(height: 18),

                // Kartu Rekening Sumber (Figma Rectangle 114)
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFFE0E0E0)),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF3D8FF),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Center(
                          child: Icon(Icons.account_balance_wallet_outlined,
                              color: Color(0xFF772096), size: 24),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Rekening Sumber',
                              style: GoogleFonts.robotoSlab(
                                fontSize: 13,
                                color: const Color(0xFF939393),
                              ),
                            ),
                            Row(
                              children: [
                                Text(
                                  '$_userSenderName ',
                                  style: GoogleFonts.robotoSlab(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black,
                                  ),
                                ),
                                Text(
                                  '($_userSenderPhone)',
                                  style: GoogleFonts.poppins(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Text(
                                  'Saldo: Rp ',
                                  style: GoogleFonts.robotoSlab(
                                    fontSize: 12,
                                    color: const Color(0xFF570374),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Text(
                                  _userBalance,
                                  style: GoogleFonts.poppins(
                                    fontSize: 12,
                                    color: const Color(0xFF570374),
                                    fontWeight: FontWeight.w600,
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

                const SizedBox(height: 20),

                // Tombol Lanjutkan Figma
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_amount.isEmpty || int.tryParse(_amount) == 0) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Masukkan nominal transfer terlebih dahulu')),
                        );
                        return;
                      }
                      _showKonfirmasiTransferSheet();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFD373FC),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(26)),
                      elevation: 0,
                    ),
                    child: Text(
                      'Lanjutkan',
                      style: GoogleFonts.robotoSlab(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF52086B),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        // Keypad 4-Kolom Persis Figma #558:975
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
          onSubmit: () {
            if (_amount.isEmpty || int.tryParse(_amount) == 0) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Masukkan nominal transfer terlebih dahulu')),
              );
              return;
            }
            _showKonfirmasiTransferSheet();
          },
        ),
      ],
    );
  }

  // =========================================================================
  // KEYBOARD 4-KOLOM DENGAN TOMBOL ABU-ABU (#D9D9D9) SESUAI DESAIN FIGMA ASLI
  // Baris 1: 1, 2, 3, -
  // Baris 2: 4, 5, 6, +
  // Baris 3: 7, 8, 9, ⌫
  // Baris 4: , , 0, . , ✓
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
              _buildFigmaKey('-', () {}),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildFigmaKey('4', () => onDigit('4')),
              _buildFigmaKey('5', () => onDigit('5')),
              _buildFigmaKey('6', () => onDigit('6')),
              _buildFigmaKey('+', () {}),
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
              _buildFigmaKey(',', () {}),
              _buildFigmaKey('0', () => onDigit('0')),
              _buildFigmaKey('.', () {}),
              _buildFigmaKey('ok', onSubmit, icon: Icons.check),
            ],
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _buildFigmaKey(String label, VoidCallback onTap, {IconData? icon}) {
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
          child: icon != null
              ? Icon(icon, color: Colors.black, size: 22)
              : Text(
                  label,
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
        ),
      ),
    );
  }

  // =========================================================================
  // FRAME 4: MODAL KONFIRMASI TRANSFER (FIGMA #578:1675)
  // - Logo User (BUKAN Bank)
  // - Tanpa garis divider terlihat
  // =========================================================================
  void _showKonfirmasiTransferSheet() {
    final displayAccount =
        _inputAccountNumber.isEmpty ? _selectedBankCode : _inputAccountNumber;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(28),
              topRight: Radius.circular(28),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 44,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 18),
              Text(
                'Konfirmasi Transfer',
                style: GoogleFonts.robotoSlab(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF52086B),
                ),
              ),
              const SizedBox(height: 18),

              // Detail Penerima: LOGO USER (Bukan Bank) Sesuai Desain Figma #578:1675
              Row(
                children: [
                  SizedBox(
                    width: 50,
                    height: 50,
                    child: Center(
                      child: AppIcons.buildImageOrIcon(
                        AppIcons.icKonfUser,
                        width: 46,
                        height: 46,
                        fallbackIcon: Icons.account_circle,
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _recipientName,
                          style: GoogleFonts.robotoSlab(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        Row(
                          children: [
                            Text(
                              '$_selectedBankName ',
                              style: GoogleFonts.robotoSlab(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: const Color(0xFF570374),
                              ),
                            ),
                            Text(
                              displayAccount,
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF570374),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Baris Nominal, Biaya Admin, Total TANPA GARIS DIVIDER (Persis Figma)
              _buildKonfirmasiRow('Nominal', 'Rp ${_formatCurrency(_amount)}'),
              const SizedBox(height: 14),
              _buildKonfirmasiRow('Biaya Admin', 'Gratis'),
              const SizedBox(height: 14),
              _buildKonfirmasiRow(
                'Total',
                'Rp ${_formatCurrency(_amount)}',
                isBold: true,
                color: const Color(0xFF52086B),
              ),

              const SizedBox(height: 32),

              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context); // Tutup konfirmasi
                    _showPinBottomSheet(); // Buka PIN
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFCA31FF),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(26)),
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
              const SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }

  Widget _buildKonfirmasiRow(String label, String value, {bool isBold = false, Color? color}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.robotoSlab(
            fontSize: 16,
            color: const Color(0xFF570374),
            fontWeight: isBold ? FontWeight.bold : FontWeight.w500,
          ),
        ),
        Text(
          value,
          style: isBold
              ? GoogleFonts.poppins(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: color ?? const Color(0xFF52086B),
                )
              : GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: color ?? Colors.black,
                ),
        ),
      ],
    );
  }

  // =========================================================================
  // FRAME 5: BOTTOM SHEET PIN (FIGMA FRAME #180:1255)
  // - Logo Kunci (BUKAN Gembok) -> Menggunakan PNG asli Figma
  // - Lupa PIN ada sambungannya (navigasi ke ForgetPasswordScreen)
  // =========================================================================
  void _showPinBottomSheet() {
    String pin = '';
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            void onDigit(String d) {
              if (pin.length < 6) {
                setModalState(() => pin += d);
                if (pin.length == 6) {
                  Navigator.pop(context);
                  setState(() => _currentStep = 4);
                }
              }
            }

            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(32),
                  topRight: Radius.circular(32),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 44,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Logo Kunci Asli dari Figma (BUKAN Gembok)
                  SizedBox(
                    width: 72,
                    height: 60,
                    child: Center(
                      child: AppIcons.buildImageOrIcon(
                        AppIcons.icPinKey,
                        width: 70,
                        height: 58,
                        fallbackIcon: Icons.key_rounded,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  Text(
                    'Konfirmasi PIN',
                    style: GoogleFonts.robotoSlab(
                      fontSize: 26,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF52086B),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Masukkan 6-digit PIN Transaksi kamu',
                    style: GoogleFonts.robotoSlab(
                      fontSize: 14,
                      color: const Color(0xFF570374),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // 6 Titik PIN Indicator
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(6, (idx) {
                      final isFilled = idx < pin.length;
                      return Container(
                        margin: const EdgeInsets.symmetric(horizontal: 8),
                        width: 18,
                        height: 18,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isFilled
                              ? const Color(0xFFCA31FF)
                              : const Color(0xFFF3D8FF),
                          border: Border.all(
                            color: isFilled
                                ? const Color(0xFF52086B)
                                : const Color(0xFFCA31FF),
                            width: 1.5,
                          ),
                        ),
                      );
                    }),
                  ),

                  const SizedBox(height: 16),

                  // Lupa PIN - Memiliki Sambungan / Navigasi ke ForgetPasswordScreen
                  InkWell(
                    onTap: () {
                      Navigator.pop(context); // Tutup bottom sheet PIN
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const ForgetPasswordScreen()),
                      );
                    },
                    borderRadius: BorderRadius.circular(8),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      child: Text(
                        'Lupa PIN?',
                        style: GoogleFonts.robotoSlab(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFFCA31FF),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Keypad PIN 3-Kolom Font Poppins untuk Angka
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildPinKey('1', () => onDigit('1')),
                          _buildPinKey('2', () => onDigit('2')),
                          _buildPinKey('3', () => onDigit('3')),
                        ],
                      ),
                      const SizedBox(height: 14),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildPinKey('4', () => onDigit('4')),
                          _buildPinKey('5', () => onDigit('5')),
                          _buildPinKey('6', () => onDigit('6')),
                        ],
                      ),
                      const SizedBox(height: 14),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildPinKey('7', () => onDigit('7')),
                          _buildPinKey('8', () => onDigit('8')),
                          _buildPinKey('9', () => onDigit('9')),
                        ],
                      ),
                      const SizedBox(height: 14),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          const SizedBox(width: 65, height: 60),
                          _buildPinKey('0', () => onDigit('0')),
                          SizedBox(
                            width: 65,
                            height: 60,
                            child: IconButton(
                              iconSize: 28,
                              icon: const Icon(Icons.backspace_outlined,
                                  color: Color(0xFF52086B)),
                              onPressed: () {
                                if (pin.isNotEmpty) {
                                  setModalState(
                                      () => pin = pin.substring(0, pin.length - 1));
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildPinKey(String num, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(30),
      child: Container(
        width: 65,
        height: 60,
        decoration: BoxDecoration(
          color: const Color(0xFFFBF8FD),
          shape: BoxShape.circle,
          border: Border.all(color: const Color(0xFFEBD4FA)),
        ),
        child: Center(
          child: Text(
            num,
            style: GoogleFonts.poppins(
              fontSize: 26,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF52086B),
            ),
          ),
        ),
      ),
    );
  }

  // =========================================================================
  // FRAME 6: RESI BUKTI TRANSAKSI (FIGMA FRAME #403:1048)
  // Background lavender lembut (#F8EAFF) dan struktur struk persis Figma
  // =========================================================================
  Widget _buildResiBuktiView() {
    final displayAccount =
        _inputAccountNumber.isEmpty ? _selectedBankCode : _inputAccountNumber;

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(
        children: [
          // Badge Ceklis Sukses Asli Figma
          SizedBox(
            width: 76,
            height: 76,
            child: AppIcons.buildImageOrIcon(
              AppIcons.icReceiptCheck,
              width: 76,
              height: 76,
              fallbackIcon: Icons.check_circle_rounded,
              fallbackColor: const Color(0xFF2E7D32),
            ),
          ),
          const SizedBox(height: 10),

          Text(
            'SUKSES!',
            style: GoogleFonts.robotoSlab(
              fontSize: 28,
              fontWeight: FontWeight.w800,
              color: const Color(0xFF52086B),
            ),
          ),
          const SizedBox(height: 4),

          Text(
            'Bukti Transaksi',
            style: GoogleFonts.robotoSlab(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF52086B),
            ),
          ),

          const SizedBox(height: 18),

          // Detail Struk Figma (Kartu Putih)
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFFEBD4FA), width: 1.2),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Nama Penerima',
                      style: GoogleFonts.robotoSlab(
                        fontSize: 13,
                        color: const Color(0xFF570374),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                '$_recipientName (',
                                style: GoogleFonts.robotoSlab(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                ),
                              ),
                              Text(
                                displayAccount,
                                style: GoogleFonts.poppins(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                ),
                              ),
                              Text(
                                ')',
                                style: GoogleFonts.robotoSlab(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                          Text(
                            _selectedBankFullName,
                            style: GoogleFonts.robotoSlab(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: const Color(0xFF570374),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const Divider(color: Color(0xFFF3D8FF), height: 20),
                _buildReceiptRow('Nomor Referensi', '45499730898', isNumber: true),
                const Divider(color: Color(0xFFF3D8FF), height: 20),
                _buildReceiptRow('Tanggal Transaksi', '1 Okt 2026 09:18 WIB', isNumber: true),
                const Divider(color: Color(0xFFF3D8FF), height: 20),
                _buildReceiptRow(
                    'Sumber Dana (XEMA):', '$_userSenderName (085******656)',
                    isNumber: true),
                const Divider(color: Color(0xFFF3D8FF), height: 20),
                _buildReceiptRowWithRp('Nominal Transfer', _formatCurrency(_amount)),
                const Divider(color: Color(0xFFF3D8FF), height: 20),
                _buildReceiptRow('Biaya Admin', 'Gratis', isNumber: false),
                const Divider(color: Color(0xFFF3D8FF), height: 20),
                // Baris TOTAL di dalam struk sesuai Figma #403:1048
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'TOTAL',
                      style: GoogleFonts.robotoSlab(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF52086B),
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                          'Rp ',
                          style: GoogleFonts.robotoSlab(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF52086B),
                          ),
                        ),
                        Text(
                          _formatCurrency(_amount),
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF52086B),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Tombol OK Selesai (Warna #CA31FF / #D373FC)
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
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildReceiptRow(String label, String value, {bool isNumber = false}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.robotoSlab(
            fontSize: 13,
            color: const Color(0xFF570374),
          ),
        ),
        const SizedBox(width: 12),
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: isNumber
                ? GoogleFonts.poppins(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  )
                : GoogleFonts.robotoSlab(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
          ),
        ),
      ],
    );
  }

  Widget _buildReceiptRowWithRp(String label, String numberVal) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.robotoSlab(
            fontSize: 13,
            color: const Color(0xFF570374),
          ),
        ),
        const SizedBox(width: 12),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Rp ',
              style: GoogleFonts.robotoSlab(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
            Text(
              numberVal,
              style: GoogleFonts.poppins(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
