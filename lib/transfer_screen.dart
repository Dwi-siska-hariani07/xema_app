import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'core/app_icons.dart';

class TransferScreen extends StatefulWidget {
  final bool isEwallet;
  const TransferScreen({super.key, this.isEwallet = false});

  @override
  State<TransferScreen> createState() => _TransferScreenState();
}

class _TransferScreenState extends State<TransferScreen> {
  // Navigation Flow State:
  // 1: Pilih Bank (Figma #103:296)
  // 2: Input No Rekening per Bank (Figma #246:49 & #553:251)
  // 3: Tujuan Transfer & Input Nominal (Figma #152:856 & #558:975)
  // 4: Resi Bukti Transaksi Sukses (Figma #403:1048)
  int _currentStep = 1;

  // Selected Bank Details (Dynamically reflects whichever bank was tapped)
  String _selectedBankName = 'BSI';
  String _selectedBankCode = '7243567687';
  String _selectedBankLogo = AppIcons.logoBsi;
  String _inputAccountNumber = '';
  final String _recipientName = 'Zavella Meica';
  String _amount = '100000';

  final String _userSenderName = 'LISA ARUNIA';
  final String _userSenderPhone = '0851 2343 5656';
  final String _userBalance = '300.000,00';

  // Bank Data Definition with distinct logo and default account numbers
  final List<Map<String, String>> _popularBanks = [
    {'name': 'MANDIRI', 'fullName': 'BANK MANDIRI', 'acc': '1370019283748', 'logo': AppIcons.logoMandiri},
    {'name': 'BSI', 'fullName': 'BANK BSI', 'acc': '7243567687', 'logo': AppIcons.logoBsi},
    {'name': 'BTN', 'fullName': 'BANK BTN', 'acc': '0001827364501', 'logo': AppIcons.logoBtn},
    {'name': 'BNI', 'fullName': 'BANK BNI', 'acc': '0981726354', 'logo': AppIcons.logoBni},
    {'name': 'BCA', 'fullName': 'BANK BCA', 'acc': '8801928374', 'logo': AppIcons.logoBca},
    {'name': 'BRI', 'fullName': 'BANK BRI', 'acc': '0019018273645', 'logo': AppIcons.logoBri},
    {'name': 'BAS', 'fullName': 'BANK ACEH SYARIAH', 'acc': '5018273645', 'logo': AppIcons.logoBas},
    {'name': 'SeaBank', 'fullName': 'BANK SEABANK', 'acc': '9018273645', 'logo': AppIcons.logoSeaBank},
  ];

  final List<Map<String, String>> _regionalBanks = [
    {'name': 'Bank Aceh Syariah', 'fullName': 'BANK ACEH SYARIAH', 'acc': '5018273645', 'logo': AppIcons.logoBas},
    {'name': 'Bank Banten', 'fullName': 'BANK BANTEN', 'acc': '1382910283', 'logo': AppIcons.logoBtn},
    {'name': 'Bank Bengkulu', 'fullName': 'BANK BENGKULU', 'acc': '1482910284', 'logo': AppIcons.logoBri},
    {'name': 'Bank Jabar & Banten (BJB)', 'fullName': 'BANK BJB', 'acc': '1102910285', 'logo': AppIcons.logoBni},
    {'name': 'Bank Jambi', 'fullName': 'BANK JAMBI', 'acc': '1582910286', 'logo': AppIcons.logoMandiri},
    {'name': 'Bank Jateng', 'fullName': 'BANK JATENG', 'acc': '1682910287', 'logo': AppIcons.logoBri},
    {'name': 'Bank Jatim', 'fullName': 'BANK JATIM', 'acc': '1782910288', 'logo': AppIcons.logoBca},
    {'name': 'Bank Kalbar', 'fullName': 'BANK KALBAR', 'acc': '1882910289', 'logo': AppIcons.logoMandiri},
    {'name': 'Bank Kalsel', 'fullName': 'BANK KALSEL', 'acc': '1982910290', 'logo': AppIcons.logoBni},
    {'name': 'Bank Lampung', 'fullName': 'BANK LAMPUNG', 'acc': '2082910291', 'logo': AppIcons.logoBri},
    {'name': 'Bank Maluku Malut', 'fullName': 'BANK MALUKU MALUT', 'acc': '2182910292', 'logo': AppIcons.logoBtn},
    {'name': 'Bank NTT', 'fullName': 'BANK NTT', 'acc': '2282910293', 'logo': AppIcons.logoBri},
    {'name': 'Bank Papua', 'fullName': 'BANK PAPUA', 'acc': '2382910294', 'logo': AppIcons.logoMandiri},
    {'name': 'Bank Pembangunan Daerah Bali', 'fullName': 'BANK BPD BALI', 'acc': '2482910295', 'logo': AppIcons.logoBca},
    {'name': 'Bank Sulteng', 'fullName': 'BANK SULTENG', 'acc': '2582910296', 'logo': AppIcons.logoBni},
    {'name': 'Bank Sumut', 'fullName': 'BANK SUMUT', 'acc': '2682910297', 'logo': AppIcons.logoBri},
  ];

  String _formatCurrency(String rawNumber) {
    if (rawNumber.isEmpty) return '0';
    try {
      final num = int.parse(rawNumber);
      return NumberFormat.currency(locale: 'id_ID', symbol: '', decimalDigits: 0).format(num).trim();
    } catch (_) {
      return rawNumber;
    }
  }

  void _selectBank(Map<String, String> bank) {
    setState(() {
      _selectedBankName = bank['name']!;
      _selectedBankCode = bank['acc']!;
      _selectedBankLogo = bank['logo']!;
      _inputAccountNumber = '';
      _currentStep = 2; // Pindah ke Frame Input No Rekening Bank Terpilih
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildCustomNavbar(),
      body: SafeArea(
        child: _buildBody(),
      ),
    );
  }

  // ==================== NAVBAR FIGMA DENGAN ATURAN FONT ====================
  PreferredSizeWidget _buildCustomNavbar() {
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
                Expanded(
                  child: Center(
                    child: _currentStep == 3
                        // Aturan User: "tujuan transfer" WAJIB FONT RASA
                        ? Text(
                            'Tujuan Transfer',
                            style: GoogleFonts.rasa(
                              fontSize: 26,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF52086B),
                            ),
                          )
                        : Text(
                            _currentStep == 1
                                ? 'Transfer'
                                : _currentStep == 2
                                    ? 'BANK $_selectedBankName'
                                    : 'Bukti Transaksi',
                            style: GoogleFonts.robotoSlab(
                              fontSize: 22,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF52086B),
                            ),
                          ),
                  ),
                ),
                const SizedBox(width: 48), // Spacer penyeimbang tombol back
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
  // FRAME 1: PILIH SEMUA BANK (FIGMA FRAME #103:296)
  // =========================================================================
  Widget _buildPilihBankView() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Semua Bank',
            style: GoogleFonts.robotoSlab(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF52086B),
            ),
          ),
          const SizedBox(height: 14),

          // Grid Bank Populer dengan Logo Asli dari Folder assets/images/
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _popularBanks.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              crossAxisSpacing: 10,
              mainAxisSpacing: 12,
              childAspectRatio: 0.85,
            ),
            itemBuilder: (context, index) {
              final bank = _popularBanks[index];
              return InkWell(
                onTap: () => _selectBank(bank),
                borderRadius: BorderRadius.circular(14),
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: const Color(0xFFE8E8E8)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.04),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 38,
                        height: 38,
                        child: Center(
                          child: AppIcons.buildImageOrIcon(bank['logo']!),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        bank['name']!,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.robotoSlab(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),

          const SizedBox(height: 24),
          const Divider(color: Color(0xFFE5E5E5), thickness: 1),
          const SizedBox(height: 12),

          // Daftar Bank Daerah
          Text(
            'Daftar Bank Daerah & Lainnya',
            style: GoogleFonts.robotoSlab(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF52086B),
            ),
          ),
          const SizedBox(height: 8),

          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _regionalBanks.length,
            separatorBuilder: (_, __) => const Divider(color: Color(0xFFF0F0F0), height: 1),
            itemBuilder: (context, index) {
              final bank = _regionalBanks[index];
              return ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                leading: Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF3D8FF),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: AppIcons.buildImageOrIcon(bank['logo']!, width: 26, height: 26),
                  ),
                ),
                title: Text(
                  bank['name']!,
                  style: GoogleFonts.robotoSlab(
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                    color: Colors.black87,
                  ),
                ),
                trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: Color(0xFF939393)),
                onTap: () => _selectBank(bank),
              );
            },
          ),
        ],
      ),
    );
  }

  // =========================================================================
  // FRAME 2: INPUT NOMOR REKENING SESUAI BANK TERPILIH (FIGMA #246:49)
  // =========================================================================
  Widget _buildInputNoRekeningView() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Bank Terpilih + Logo Asli
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFFF3D8FF),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: AppIcons.buildImageOrIcon(_selectedBankLogo, width: 34, height: 34),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'BANK $_selectedBankName',
                    style: GoogleFonts.robotoSlab(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF52086B),
                    ),
                  ),
                  Text(
                    'Transfer ke rekening bank ini',
                    style: GoogleFonts.robotoSlab(
                      fontSize: 12,
                      color: const Color(0xFF939393),
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Box Input Nomor Rekening Figma (#553:251)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
            decoration: BoxDecoration(
              color: const Color(0xFFFBF8FD),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: const Color(0xFFD373FC), width: 1.2),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Masukkan no. rekening/nama',
                  style: GoogleFonts.robotoSlab(
                    fontSize: 13,
                    color: const Color(0xFF570374),
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        _inputAccountNumber.isEmpty ? 'Ketik nomor rekening...' : _inputAccountNumber,
                        style: GoogleFonts.poppins(
                          fontSize: _inputAccountNumber.isEmpty ? 15 : 22,
                          fontWeight: FontWeight.w600,
                          color: _inputAccountNumber.isEmpty ? const Color(0xFF939393) : Colors.black,
                          letterSpacing: 1.0,
                        ),
                      ),
                    ),
                    if (_inputAccountNumber.isNotEmpty)
                      GestureDetector(
                        onTap: () => setState(() => _inputAccountNumber = ''),
                        child: const Icon(Icons.close, color: Color(0xFF939393), size: 20),
                      ),
                  ],
                ),
                const Divider(color: Color(0xFFCA31FF), thickness: 1.2, height: 16),
              ],
            ),
          ),

          const SizedBox(height: 12),

          // Tombol Quick-Fill Rekening Resmi Figma untuk Bank Ini
          InkWell(
            onTap: () {
              setState(() => _inputAccountNumber = _selectedBankCode);
            },
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFFF3D8FF),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFCA31FF), width: 0.8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.account_circle_outlined, size: 16, color: Color(0xFF52086B)),
                  const SizedBox(width: 6),
                  Text(
                    'Isi Otomatis: $_recipientName ($_selectedBankCode)',
                    style: GoogleFonts.robotoSlab(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF52086B),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Keypad Numerik Figma
          _buildNumericKeypad(
            onDigit: (digit) {
              if (_inputAccountNumber.length < 16) {
                setState(() => _inputAccountNumber += digit);
              }
            },
            onDelete: () {
              if (_inputAccountNumber.isNotEmpty) {
                setState(() => _inputAccountNumber = _inputAccountNumber.substring(0, _inputAccountNumber.length - 1));
              }
            },
          ),

          const SizedBox(height: 24),

          // Tombol Lanjutkan Figma (Rectangle 87)
          SizedBox(
            width: double.infinity,
            height: 54,
            child: ElevatedButton(
              onPressed: () {
                if (_inputAccountNumber.isEmpty) {
                  // Fallback ke default bank jika kosong
                  _inputAccountNumber = _selectedBankCode;
                }
                setState(() => _currentStep = 3); // Lanjut ke frame Tujuan Transfer
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFCA31FF),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(27)),
                elevation: 3,
              ),
              child: Text(
                'Lanjutkan',
                style: GoogleFonts.robotoSlab(
                  fontSize: 20,
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
  // FRAME 3: TUJUAN TRANSFER & NOMINAL (FIGMA #152:856 & #558:975)
  // Aturan User: "tujuan transfer" font Rasa, strings lain Roboto Slab, angka Poppins
  // =========================================================================
  Widget _buildTujuanTransferNominalView() {
    return SingleChildScrollView(
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
              borderRadius: BorderRadius.circular(18),
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
                // Avatar Ikon Figma
                Container(
                  width: 52,
                  height: 52,
                  decoration: const BoxDecoration(
                    color: Color(0xFFF3D8FF),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: AppIcons.buildImageOrIcon(
                      AppIcons.avatarRecipient,
                      width: 38,
                      height: 38,
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
                      Text(
                        '$_selectedBankName  ${_inputAccountNumber.isEmpty ? _selectedBankCode : _inputAccountNumber}',
                        style: GoogleFonts.poppins(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF570374),
                        ),
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
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
            decoration: BoxDecoration(
              color: const Color(0xFFFBF8FD),
              borderRadius: BorderRadius.circular(18),
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
                      'Rp',
                      style: GoogleFonts.robotoSlab(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF52086B),
                      ),
                    ),
                    const SizedBox(width: 10),
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

          const SizedBox(height: 12),

          // Chip Pilihan Nominal Cepat
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: ['50000', '100000', '200000', '500000'].map((val) {
                final isSelected = _amount == val;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ActionChip(
                    backgroundColor: isSelected ? const Color(0xFFCA31FF) : const Color(0xFFF3D8FF),
                    side: const BorderSide(color: Color(0xFFCA31FF), width: 0.8),
                    label: Text(
                      'Rp ${_formatCurrency(val)}',
                      style: GoogleFonts.robotoSlab(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: isSelected ? Colors.white : const Color(0xFF570374),
                      ),
                    ),
                    onPressed: () => setState(() => _amount = val),
                  ),
                );
              }).toList(),
            ),
          ),

          const SizedBox(height: 20),

          // Kartu Rekening Sumber (Figma Rectangle 114)
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
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
                    child: Icon(Icons.account_balance_wallet_outlined, color: Color(0xFF772096), size: 24),
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
                      Text(
                        '$_userSenderName ($_userSenderPhone)',
                        style: GoogleFonts.poppins(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        'Saldo: Rp $_userBalance',
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: const Color(0xFF570374),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Keypad Nominal
          _buildNumericKeypad(
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
          ),

          const SizedBox(height: 24),

          // Tombol Lanjutkan Figma (Rectangle 87)
          SizedBox(
            width: double.infinity,
            height: 54,
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
                backgroundColor: const Color(0xFFCA31FF),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(27)),
                elevation: 3,
              ),
              child: Text(
                'Lanjutkan',
                style: GoogleFonts.robotoSlab(
                  fontSize: 20,
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

  // Keypad Reusable
  Widget _buildNumericKeypad({
    required Function(String) onDigit,
    required VoidCallback onDelete,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildKey('1', () => onDigit('1')),
              _buildKey('2', () => onDigit('2')),
              _buildKey('3', () => onDigit('3')),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildKey('4', () => onDigit('4')),
              _buildKey('5', () => onDigit('5')),
              _buildKey('6', () => onDigit('6')),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildKey('7', () => onDigit('7')),
              _buildKey('8', () => onDigit('8')),
              _buildKey('9', () => onDigit('9')),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildKey('000', () => onDigit('000'), isSmall: true),
              _buildKey('0', () => onDigit('0')),
              _buildKey('del', onDelete, icon: Icons.backspace_outlined),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildKey(String label, VoidCallback onTap, {bool isSmall = false, IconData? icon}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        width: 72,
        height: 52,
        decoration: BoxDecoration(
          color: const Color(0xFFFBF8FD),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFFEBD4FA)),
        ),
        child: Center(
          child: icon != null
              ? Icon(icon, color: const Color(0xFF52086B), size: 22)
              : Text(
                  label,
                  style: GoogleFonts.poppins(
                    fontSize: isSmall ? 16 : 22,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF52086B),
                  ),
                ),
        ),
      ),
    );
  }

  // =========================================================================
  // FRAME 4: MODAL KONFIRMASI TRANSFER (FIGMA #578:1675)
  // =========================================================================
  void _showKonfirmasiTransferSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(24),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 48,
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
              const SizedBox(height: 16),

              // Detail Penerima Spesifik Bank Terpilih
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFFF3D8FF),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    AppIcons.buildImageOrIcon(
                      _selectedBankLogo,
                      width: 42,
                      height: 42,
                      fallbackIcon: Icons.account_balance,
                    ),
                    const SizedBox(width: 14),
                    Column(
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
                        Text(
                          '$_selectedBankName  ${_inputAccountNumber.isEmpty ? _selectedBankCode : _inputAccountNumber}',
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            color: const Color(0xFF570374),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              _buildDetailRow('Nominal', 'Rp ${_formatCurrency(_amount)}'),
              const Divider(color: Color(0xFFEBD4FA), height: 24),
              _buildDetailRow('Biaya Admin', 'Rp 0'),
              const Divider(color: Color(0xFFEBD4FA), height: 24),
              _buildDetailRow(
                'Total',
                'Rp ${_formatCurrency(_amount)}',
                isBold: true,
                color: const Color(0xFF52086B),
              ),

              const SizedBox(height: 30),

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
                  ),
                  child: Text(
                    'Konfirmasi',
                    style: GoogleFonts.robotoSlab(
                      fontSize: 16,
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

  // =========================================================================
  // FRAME 5: BOTTOM SHEET PIN (FIGMA FRAME #180:1255)
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

                  // Keypad PIN 3-Kolom Sesuai Desain Figma Asli
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

                        Container(
                          width: 50,
                          height: 50,
                          decoration: const BoxDecoration(
                            color: Color(0xFFF3D8FF),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.lock_outline_rounded, color: Color(0xFF52086B), size: 26),
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
                                color: isFilled ? const Color(0xFFCA31FF) : const Color(0xFFF3D8FF),
                                border: Border.all(
                                  color: isFilled ? const Color(0xFF52086B) : const Color(0xFFCA31FF),
                                  width: 1.5,
                                ),
                              ),
                            );
                          }),
                        ),

                        const SizedBox(height: 16),
                        Text(
                          'Lupa PIN?',
                          style: GoogleFonts.robotoSlab(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFFCA31FF),
                          ),
                        ),

                        const SizedBox(height: 24),

                        // Keypad PIN 3-Kolom Sesuai Desain Figma Asli
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
                                const SizedBox(width: 70, height: 60), // Spacer kosong kiri
                                _buildPinKey('0', () => onDigit('0')),
                                SizedBox(
                                  width: 70,
                                  height: 60,
                                  child: IconButton(
                                    iconSize: 28,
                                    icon: const Icon(Icons.backspace_outlined, color: Color(0xFF52086B)),
                                    onPressed: () {
                                      if (pin.isNotEmpty) {
                                        setModalState(() => pin = pin.substring(0, pin.length - 1));
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
            style: GoogleFonts.rasa(
              fontSize: 32,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF52086B),
            ),
          ),
        ),
      ),
    );
  }

  // =========================================================================
  // FRAME 6: RESI BUKTI TRANSAKSI (FIGMA FRAME #403:1048)
  // =========================================================================
  Widget _buildResiBuktiView() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        children: [
          // Icon Sukses Figma dari assets/icons/ic_success_tick.png
          SizedBox(
            width: 76,
            height: 76,
            child: AppIcons.buildImageOrIcon(
              AppIcons.icSuccessTick,
              width: 76,
              height: 76,
              fallbackIcon: Icons.check_circle_rounded,
              fallbackColor: const Color(0xFF2E7D32),
            ),
          ),
          const SizedBox(height: 12),

          Text(
            'SUKSES!',
            style: GoogleFonts.robotoSlab(
              fontSize: 30,
              fontWeight: FontWeight.w800,
              color: const Color(0xFF52086B),
            ),
          ),
          const SizedBox(height: 4),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Bukti Transaksi',
                style: GoogleFonts.robotoSlab(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF52086B),
                ),
              ),
              const SizedBox(width: 8),
              AppIcons.buildImageOrIcon(
                AppIcons.icShare,
                width: 20,
                height: 20,
                fallbackIcon: Icons.share_outlined,
              ),
            ],
          ),

          const SizedBox(height: 18),

          // Total Transfer Box
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            decoration: BoxDecoration(
              color: const Color(0xFFF3D8FF),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                Text(
                  'TOTAL ',
                  style: GoogleFonts.robotoSlab(
                    fontSize: 14,
                    color: const Color(0xFF570374),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  'Rp ${_formatCurrency(_amount)}',
                  style: GoogleFonts.poppins(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF52086B),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Detail Struk Figma
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFFD373FC), width: 1.2),
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
                _buildReceiptRow(
                  'Nama Penerima ',
                  '$_recipientName (${_inputAccountNumber.isEmpty ? _selectedBankCode : _inputAccountNumber})\nBank $_selectedBankName',
                ),
                const Divider(color: Color(0xFFF3D8FF), height: 20),
                _buildReceiptRow('Nomor Referensi', '45499730898'),
                const Divider(color: Color(0xFFF3D8FF), height: 20),
                _buildReceiptRow('Tanggal Transaksi', '1 Okt 2026  09:18 WIB'),
                const Divider(color: Color(0xFFF3D8FF), height: 20),
                _buildReceiptRow('Sumber Dana (XEMA):', '$_userSenderName (085******656)'),
                const Divider(color: Color(0xFFF3D8FF), height: 20),
                _buildReceiptRow('Nominal Transfer', 'Rp ${_formatCurrency(_amount)}'),
                const Divider(color: Color(0xFFF3D8FF), height: 20),
                _buildReceiptRow('Biaya Admin', 'Gratis'),
              ],
            ),
          ),

          const SizedBox(height: 28),

          // Tombol OK Selesai
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

  Widget _buildDetailRow(String label, String value, {bool isBold = false, Color? color}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.robotoSlab(
            fontSize: 16,
            color: const Color(0xFF570374),
          ),
        ),
        Text(
          value,
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
            color: color ?? Colors.black,
          ),
        ),
      ],
    );
  }

  Widget _buildReceiptRow(String label, String value) {
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
            style: GoogleFonts.poppins(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
        ),
      ],
    );
  }
}
