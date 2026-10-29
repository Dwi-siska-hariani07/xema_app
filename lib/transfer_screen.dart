import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class TransferScreen extends StatefulWidget {
  final bool isEwallet;
  const TransferScreen({super.key, this.isEwallet = false});

  @override
  State<TransferScreen> createState() => _TransferScreenState();
}

class _TransferScreenState extends State<TransferScreen> {
  // Step navigation:
  // 1: Pilih Bank / Tujuan Transfer (Figma 103:296 & 152:856)
  // 2: Input Nominal & Rekening Sumber (Figma 558:975)
  // 3: Resi Bukti Transaksi Sukses (Figma 403:1048)
  int _currentStep = 1;

  // Form State
  String _selectedBankName = 'BSI';
  final String _selectedBankCode = '7243567687';
  final String _recipientName = 'Zavella Meica';
  String _amount = '100000';
  final String _userSenderName = 'LISA ARUNIA';
  final String _userSenderPhone = '0851 2343 5656';
  final String _userBalance = '300.000,00';

  // Bank List for Grid & List
  final List<Map<String, dynamic>> _popularBanks = [
    {'name': 'MANDIRI', 'fullName': 'Bank Mandiri', 'color': Color(0xFF003D79)},
    {'name': 'BSI', 'fullName': 'Bank Syariah Indonesia (BSI)', 'color': Color(0xFF00A39D)},
    {'name': 'BTN', 'fullName': 'Bank BTN', 'color': Color(0xFF002D62)},
    {'name': 'BNI', 'fullName': 'Bank Negara Indonesia (BNI)', 'color': Color(0xFFF37021)},
    {'name': 'BCA', 'fullName': 'Bank Central Asia (BCA)', 'color': Color(0xFF005EAA)},
    {'name': 'BRI', 'fullName': 'Bank Rakyat Indonesia (BRI)', 'color': Color(0xFF00529C)},
    {'name': 'BAS', 'fullName': 'Bank Aceh Syariah', 'color': Color(0xFF006F3C)},
    {'name': 'SeaBank', 'fullName': 'SeaBank Indonesia', 'color': Color(0xFFF05A28)},
  ];

  final List<String> _regionalBanks = [
    'Bank Aceh Syariah',
    'Bank Banten',
    'Bank Bengkulu',
    'Bank Jabar & Banten (BJB)',
    'Bank Jambi',
    'Bank Jateng',
    'Bank Jatim',
    'Bank Kalbar',
    'Bank Kalsel',
    'Bank Lampung',
    'Bank Maluku Malut',
    'Bank NTT',
    'Bank Papua',
    'Bank Pembangunan Daerah Bali',
    'Bank Sulteng',
    'Bank Sumut',
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildFigmaHeader(),
      body: SafeArea(
        child: _buildCurrentStepView(),
      ),
    );
  }

  // ==================== HEADER UNGU FIGMA (#D373FC) ====================
  PreferredSizeWidget _buildFigmaHeader() {
    String titleText = 'Transfer';
    if (_currentStep == 2) titleText = 'Tujuan Transfer';
    if (_currentStep == 3) titleText = 'Bukti Transaksi';

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
                      Navigator.pop(context);
                    } else {
                      Navigator.pop(context);
                    }
                  },
                ),
                Expanded(
                  child: Text(
                    titleText,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.robotoSlab(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF52086B),
                    ),
                  ),
                ),
                const SizedBox(width: 48), // Balance spacing with back button
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCurrentStepView() {
    switch (_currentStep) {
      case 1:
        return _buildSelectBankStep();
      case 2:
        return _buildInputNominalStep();
      case 3:
        return _buildReceiptStep();
      default:
        return _buildSelectBankStep();
    }
  }

  // =========================================================================
  // STEP 1: PILIH BANK / TUJUAN TRANSFER (FIGMA FRAME #103:296)
  // =========================================================================
  Widget _buildSelectBankStep() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section: Semua Bank Header
          Text(
            'Semua Bank',
            style: GoogleFonts.robotoSlab(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF52086B),
            ),
          ),
          const SizedBox(height: 14),

          // Grid 8 Bank Populer (Mandiri, BSI, BTN, BNI, BCA, BRI, BAS, SeaBank)
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _popularBanks.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.85,
            ),
            itemBuilder: (context, index) {
              final bank = _popularBanks[index];
              return InkWell(
                onTap: () {
                  setState(() {
                    _selectedBankName = bank['name'];
                    _currentStep = 2;
                  });
                },
                borderRadius: BorderRadius.circular(14),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: const Color(0xFFE0E0E0)),
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
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: (bank['color'] as Color).withValues(alpha: 0.12),
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Icon(
                            Icons.account_balance,
                            color: bank['color'] as Color,
                            size: 22,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        bank['name'],
                        textAlign: TextAlign.center,
                        style: GoogleFonts.robotoSlab(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
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

          // Daftar Bank Daerah / Bank Lainnya
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
              final bankTitle = _regionalBanks[index];
              return ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                leading: Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF3D8FF),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Center(
                    child: Icon(Icons.account_balance_outlined, color: Color(0xFF772096), size: 20),
                  ),
                ),
                title: Text(
                  bankTitle,
                  style: GoogleFonts.robotoSlab(
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                    color: Colors.black87,
                  ),
                ),
                trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: Color(0xFF939393)),
                onTap: () {
                  setState(() {
                    _selectedBankName = bankTitle;
                    _currentStep = 2;
                  });
                },
              );
            },
          ),
        ],
      ),
    );
  }

  // =========================================================================
  // STEP 2: INPUT NOMINAL & REKENING SUMBER (FIGMA FRAME #558:975)
  // =========================================================================
  Widget _buildInputNominalStep() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Kartu Penerima (Zavella Meica - BSI 7243567687)
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
                Container(
                  width: 52,
                  height: 52,
                  decoration: const BoxDecoration(
                    color: Color(0xFFF3D8FF),
                    shape: BoxShape.circle,
                  ),
                  child: const Center(
                    child: Icon(Icons.person, color: Color(0xFF52086B), size: 30),
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
                        '$_selectedBankName  $_selectedBankCode',
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
                  onPressed: () => setState(() => _currentStep = 1),
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
                        fontSize: 26,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF52086B),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        _formatCurrency(_amount),
                        style: GoogleFonts.poppins(
                          fontSize: 28,
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
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ActionChip(
                    backgroundColor: _amount == val ? const Color(0xFFCA31FF) : const Color(0xFFF3D8FF),
                    side: const BorderSide(color: Color(0xFFCA31FF), width: 0.8),
                    label: Text(
                      'Rp ${_formatCurrency(val)}',
                      style: GoogleFonts.robotoSlab(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: _amount == val ? Colors.white : const Color(0xFF570374),
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
                          fontSize: 12,
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

          // Custom Keypad Figma (1-9, 0, Backspace)
          _buildFigmaNumericKeypad(),

          const SizedBox(height: 24),

          // Tombol Lanjutkan (Figma Rectangle 87)
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

  // Keypad Numerik Sesuai Figma
  Widget _buildFigmaNumericKeypad() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildKeypadKey('1'),
              _buildKeypadKey('2'),
              _buildKeypadKey('3'),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildKeypadKey('4'),
              _buildKeypadKey('5'),
              _buildKeypadKey('6'),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildKeypadKey('7'),
              _buildKeypadKey('8'),
              _buildKeypadKey('9'),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildKeypadKey('000', isAction: true, onTap: () {
                if (_amount.isNotEmpty && _amount.length <= 8) {
                  setState(() => _amount += '000');
                }
              }),
              _buildKeypadKey('0'),
              _buildKeypadKey('del', isAction: true, icon: Icons.backspace_outlined, onTap: () {
                if (_amount.isNotEmpty) {
                  setState(() => _amount = _amount.substring(0, _amount.length - 1));
                }
              }),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildKeypadKey(
    String label, {
    bool isAction = false,
    IconData? icon,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap ?? () {
        if (_amount.length < 9) {
          setState(() => _amount += label);
        }
      },
      borderRadius: BorderRadius.circular(30),
      child: Container(
        width: 70,
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
                    fontSize: label == '000' ? 16 : 22,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF52086B),
                  ),
                ),
        ),
      ),
    );
  }

  // =========================================================================
  // STEP 3: MODAL KONFIRMASI TRANSFER (FIGMA FRAME #578:1675)
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
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF52086B),
                ),
              ),
              const SizedBox(height: 16),

              // Detail Penerima
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFFF3D8FF),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    const CircleAvatar(
                      backgroundColor: Colors.white,
                      child: Icon(Icons.person, color: Color(0xFF772096)),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _recipientName,
                          style: GoogleFonts.robotoSlab(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          '$_selectedBankName  $_selectedBankCode',
                          style: GoogleFonts.poppins(fontSize: 13, color: const Color(0xFF570374)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Rincian Transfer
              _buildDetailRow('Nominal', 'Rp ${_formatCurrency(_amount)}'),
              const Divider(color: Color(0xFFEBD4FA), height: 24),
              _buildDetailRow('Biaya Admin', 'Gratis (Rp 0)'),
              const Divider(color: Color(0xFFEBD4FA), height: 24),
              _buildDetailRow(
                'Total',
                'Rp ${_formatCurrency(_amount)}',
                isBold: true,
                color: const Color(0xFF52086B),
              ),

              const SizedBox(height: 30),

              // Tombol Konfirmasi
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context); // Tutup sheet konfirmasi
                    _showPinBottomSheet(); // Buka sheet PIN
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
  // STEP 4: BOTTOM SHEET KONFIRMASI PIN (FIGMA FRAME #180:1255)
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

                  // Icon Kunci Figma
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
                      fontSize: 24,
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

                  // 6 Titik PIN Indicator (Figma Ellipse 23-28)
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
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFFCA31FF),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Numeric Keypad PIN
                  Wrap(
                    spacing: 24,
                    runSpacing: 14,
                    alignment: WrapAlignment.center,
                    children: [
                      for (var i = 1; i <= 9; i++)
                        _buildPinKey(i.toString(), () {
                          if (pin.length < 6) {
                            setModalState(() => pin += i.toString());
                            if (pin.length == 6) {
                              Navigator.pop(context);
                              setState(() => _currentStep = 3); // Ke Resi Bukti
                            }
                          }
                        }),
                      const SizedBox(width: 65, height: 60), // Spacer kosong
                      _buildPinKey('0', () {
                        if (pin.length < 6) {
                          setModalState(() => pin += '0');
                          if (pin.length == 6) {
                            Navigator.pop(context);
                            setState(() => _currentStep = 3);
                          }
                        }
                      }),
                      IconButton(
                        iconSize: 28,
                        icon: const Icon(Icons.backspace_outlined, color: Color(0xFF52086B)),
                        onPressed: () {
                          if (pin.isNotEmpty) {
                            setModalState(() => pin = pin.substring(0, pin.length - 1));
                          }
                        },
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
  // STEP 5: RESI BUKTI TRANSAKSI TRANSFER SUKSES (FIGMA FRAME #403:1048)
  // =========================================================================
  Widget _buildReceiptStep() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        children: [
          // Icon Sukses Figma dengan aksen lingkaran ganda
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: const Color(0xFFE8F5E9),
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0xFF2E7D32), width: 3),
            ),
            child: const Center(
              child: Icon(Icons.check_rounded, color: Color(0xFF2E7D32), size: 48),
            ),
          ),
          const SizedBox(height: 14),

          Text(
            'SUKSES!',
            style: GoogleFonts.robotoSlab(
              fontSize: 28,
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
              const Icon(Icons.share_outlined, color: Color(0xFF52086B), size: 20),
            ],
          ),

          const SizedBox(height: 18),

          // Total Transfer Box
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            decoration: BoxDecoration(
              color: const Color(0xFFF3D8FF),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                Text(
                  'TOTAL',
                  style: GoogleFonts.robotoSlab(
                    fontSize: 13,
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
                _buildReceiptRow('Nama Penerima', '$_recipientName ($_selectedBankCode)\n$_selectedBankName'),
                const Divider(color: Color(0xFFF3D8FF), height: 20),
                _buildReceiptRow('Nomor Referensi', '45499730898'),
                const Divider(color: Color(0xFFF3D8FF), height: 20),
                _buildReceiptRow('Tanggal Transaksi', '1 Okt 2026  09:18 WIB'),
                const Divider(color: Color(0xFFF3D8FF), height: 20),
                _buildReceiptRow('Sumber Dana (XEMA)', '$_userSenderName (085******656)'),
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
                  fontSize: 18,
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
            fontSize: 15,
            color: const Color(0xFF570374),
          ),
        ),
        Text(
          value,
          style: GoogleFonts.poppins(
            fontSize: 15,
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
