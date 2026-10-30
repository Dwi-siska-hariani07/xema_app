import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'core/app_icons.dart';

enum TopUpStep {
  pilihMetode,
  detailVa,
  detailRetail,
  indomaretNominal,
  indomaretBarcode,
}

class TopUpScreen extends StatefulWidget {
  const TopUpScreen({super.key});

  @override
  State<TopUpScreen> createState() => _TopUpScreenState();
}

class _TopUpScreenState extends State<TopUpScreen> {
  TopUpStep _currentStep = TopUpStep.pilihMetode;

  // State pilihan metode
  String? _selectedMethodName;
  String _selectedVaNumber = '1120 8227 3013 438';
  String _selectedMethodLogo = AppIcons.logoBri;
  bool _isRetail = false;

  // State dropdown Transfer Bank
  bool _isTransferBankExpanded = true;

  // State input nominal Indomaret
  int _indomaretAmount = 0;
  bool _showKeypad = false;
  final FocusNode _laptopFocusNode = FocusNode();

  // Countdown timer Indomaret Barcode (24 jam)
  int _remainingSeconds = 23 * 3600 + 59 * 60 + 58;
  Timer? _countdownTimer;

  final List<Map<String, String>> _bankMethods = [
    {'name': 'SeaBank', 'va': '7820 8227 3013 438', 'logo': AppIcons.logoSeaBank},
    {'name': 'Bank BCA', 'va': '8801 0851 2343 5656', 'logo': AppIcons.logoBca},
    {'name': 'Bank Mandiri', 'va': '8950 8227 3013 438', 'logo': AppIcons.logoMandiri},
    {'name': 'Bank BNI', 'va': '9881 0851 2343 5656', 'logo': AppIcons.logoBni},
    {'name': 'Bank BRI', 'va': '1120 8227 3013 438', 'logo': AppIcons.logoBri},
    {'name': 'Bank Syariah Indonesia (BSI)', 'va': '7243 0851 2343 565', 'logo': AppIcons.logoBsi},
    {'name': 'Bank Permata', 'va': '8450 8227 3013 438', 'logo': AppIcons.logoPermata},
    {'name': 'Bank CIMB Niaga', 'va': '2329 0851 2343 5656', 'logo': AppIcons.logoCimb},
    {'name': 'Bank lainnya', 'va': '8450 8227 3013 438', 'logo': AppIcons.icBankLainnya},
  ];

  final List<Map<String, String>> _retailMethods = [
    {
      'name': 'Indomaret',
      'logo': AppIcons.logoIndomaret,
    },
    {
      'name': 'Alfamart / Alfamidi',
      'phone': '0851 2343 5656',
      'logo': AppIcons.logoAlfamart,
      'instruction':
          'Kunjungi gerai Alfamart atau Alfamidi terdekat. Berikan nomor handphone di atas kepada kasir untuk memproses pembayaran. Saldo Anda akan otomatis bertambah',
    },
    {
      'name': 'Kantor Pos Indonesia',
      'phone': '0851 2343 5656',
      'logo': AppIcons.logoPos,
      'instruction':
          'Lakukan pembayaran melalui aplikasi Pospay, atau kunjungi loket Kantor Pos terdekat dengan menunjukkan nomor handphone di atas. Saldo otomatis bertambah',
    },
  ];

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _countdownTimer?.cancel();
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 0) {
        if (mounted) {
          setState(() {
            _remainingSeconds--;
          });
        }
      } else {
        timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    _laptopFocusNode.dispose();
    super.dispose();
  }

  String _formatTimer(int totalSeconds) {
    int hours = totalSeconds ~/ 3600;
    int minutes = (totalSeconds % 3600) ~/ 60;
    int seconds = totalSeconds % 60;
    return '$hours jam $minutes menit $seconds detik';
  }

  String _formatCurrency(int amount) {
    if (amount == 0) return '0';
    return amount.toString().replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]}.',
        );
  }

  void _handleBackNavigation() {
    setState(() {
      if (_currentStep == TopUpStep.indomaretBarcode) {
        _currentStep = TopUpStep.indomaretNominal;
      } else if (_currentStep == TopUpStep.indomaretNominal) {
        if (_showKeypad) {
          _showKeypad = false;
        } else {
          _currentStep = TopUpStep.pilihMetode;
        }
      } else if (_currentStep == TopUpStep.detailRetail ||
          _currentStep == TopUpStep.detailVa) {
        _currentStep = TopUpStep.pilihMetode;
      } else {
        if (Navigator.canPop(context)) {
          Navigator.pop(context);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
      child: PopScope(
        canPop: _currentStep == TopUpStep.pilihMetode,
        onPopInvokedWithResult: (didPop, result) {
          if (didPop) return;
          _handleBackNavigation();
        },
        child: Scaffold(
          backgroundColor: Colors.white,
          body: Column(
            children: [
              // Navbar Ungu Menembus ke Atas (y = 0)
              _buildCustomNavbar(),

              // Konten Layar Berdasarkan Step
              Expanded(
                child: _buildCurrentBody(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCurrentBody() {
    switch (_currentStep) {
      case TopUpStep.pilihMetode:
        return _buildPilihMetodeView();
      case TopUpStep.detailVa:
        return _buildDetailVirtualAccountView();
      case TopUpStep.detailRetail:
        return _buildDetailRetailView();
      case TopUpStep.indomaretNominal:
        return _buildIndomaretNominalView();
      case TopUpStep.indomaretBarcode:
        return _buildIndomaretBarcodeView();
    }
  }

  // ==================== NAVBAR OTENTIK FIGMA (Y = 0) ====================
  Widget _buildCustomNavbar() {
    final topPadding = MediaQuery.of(context).padding.top;
    return Container(
      width: double.infinity,
      color: const Color(0xFFD373FC),
      padding: EdgeInsets.only(top: topPadding),
      child: SizedBox(
        height: 60,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: _handleBackNavigation,
                child: const Padding(
                  padding: EdgeInsets.all(4.0),
                  child: Icon(
                    Icons.arrow_back,
                    color: Color(0xFF300742),
                    size: 28,
                  ),
                ),
              ),
              const SizedBox(width: 8),

              // Judul Navbar: ISI SALDO [Font: Rasa Bold 28sp]
              Expanded(
                child: Text(
                  'ISI SALDO',
                  style: GoogleFonts.rasa(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF300742),
                    letterSpacing: 0.5,
                  ),
                ),
              ),

              // Ikon Kanan: Plus dalam Kotak Otentik Figma
              GestureDetector(
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Pusat bantuan & instruksi isi saldo XEMA'),
                      backgroundColor: Color(0xFF300742),
                    ),
                  );
                },
                child: Image.asset(
                  AppIcons.icTopupNavbar,
                  width: 32,
                  height: 32,
                  fit: BoxFit.contain,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // =========================================================================
  // 1. LAYAR PILIHAN METODE (FRAME #144:1077 & #144:1490 & PAGE 2 CADANGAN)
  // =========================================================================
  Widget _buildPilihMetodeView() {
    return Stack(
      children: [
        SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.only(
            top: 0,
            bottom: _selectedMethodName != null ? 100 : 30,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Accordion: Transfer Bank
              InkWell(
                onTap: () {
                  setState(() {
                    _isTransferBankExpanded = !_isTransferBankExpanded;
                  });
                },
                child: Container(
                  height: 65,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    border: Border(
                      bottom: BorderSide(color: Colors.black, width: 1.0),
                    ),
                  ),
                  child: Row(
                    children: [
                      Image.asset(
                        AppIcons.icTransferArrows,
                        width: 40,
                        height: 40,
                        fit: BoxFit.contain,
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Text(
                          'Transfer Bank',
                          style: GoogleFonts.robotoSlab(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      Icon(
                        _isTransferBankExpanded
                            ? Icons.keyboard_arrow_down
                            : Icons.keyboard_arrow_up,
                        color: Colors.black,
                        size: 26,
                      ),
                    ],
                  ),
                ),
              ),

              // Daftar Bank (Saat di-expand)
              if (_isTransferBankExpanded)
                ListView.builder(
                  shrinkWrap: true,
                  padding: EdgeInsets.zero,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _bankMethods.length,
                  itemBuilder: (context, index) {
                    final bank = _bankMethods[index];
                    final isSelected = _selectedMethodName == bank['name'];
                    return _buildBankRow(bank, isSelected, isRetail: false);
                  },
                ),

              // Daftar Gerai Ritel & Kantor Pos
              ListView.builder(
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _retailMethods.length,
                itemBuilder: (context, index) {
                  final retail = _retailMethods[index];
                  final isSelected = _selectedMethodName == retail['name'];
                  return _buildBankRow(retail, isSelected, isRetail: true);
                },
              ),
            ],
          ),
        ),

        // Tombol Konfirmasi Melayang di Bagian Bawah
        if (_selectedMethodName != null)
          Positioned(
            left: 22.5,
            right: 22.5,
            bottom: 24,
            child: SafeArea(
              top: false,
              child: Container(
                width: double.infinity,
                height: 58,
                decoration: BoxDecoration(
                  color: const Color(0xFFCA31FF),
                  borderRadius: BorderRadius.circular(29),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFCA31FF).withValues(alpha: 0.35),
                      blurRadius: 16,
                      spreadRadius: 1,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(29),
                    onTap: () {
                      setState(() {
                        if (_selectedMethodName == 'Indomaret') {
                          _currentStep = TopUpStep.indomaretNominal;
                          _showKeypad = false;
                          _indomaretAmount = 0;
                        } else if (_isRetail) {
                          _currentStep = TopUpStep.detailRetail;
                        } else {
                          _currentStep = TopUpStep.detailVa;
                        }
                      });
                    },
                    child: Center(
                      child: Text(
                        'Konfirmasi',
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
          ),
      ],
    );
  }

  // Baris Bank / Ritel Otentik Figma
  Widget _buildBankRow(Map<String, String> item, bool isSelected, {required bool isRetail}) {
    return InkWell(
      onTap: () {
        setState(() {
          _selectedMethodName = item['name']!;
          _selectedMethodLogo = item['logo']!;
          _isRetail = isRetail;
          if (!isRetail) {
            _selectedVaNumber = item['va']!;
          }
        });
      },
      child: Container(
        height: 61,
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFEBEBEB) : Colors.white,
          border: const Border(
            bottom: BorderSide(color: Colors.black, width: 1.0),
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          children: [
            // Logo Bank / Ritel di dalam Squircle
            // Untuk retail (Indomaret, Alfamart, Pos) logo mengisi rectangle secara proporsional sesuai Figma
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 4,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              clipBehavior: Clip.antiAlias,
              child: Center(
                child: isRetail
                    ? Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: Image.asset(
                          item['logo']!,
                          width: 40,
                          height: 40,
                          fit: BoxFit.contain,
                        ),
                      )
                    : AppIcons.buildImageOrIcon(
                        item['logo']!,
                        width: 32,
                        height: 32,
                        fallbackIcon: Icons.account_balance,
                      ),
              ),
            ),
            const SizedBox(width: 16),

            // Nama Bank / Ritel [Font: Roboto Slab 16sp]
            Expanded(
              child: Text(
                item['name']!,
                style: GoogleFonts.robotoSlab(
                  fontSize: 16,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                  color: isSelected ? const Color(0xFF333333) : Colors.black,
                ),
              ),
            ),

            // Ikon Centang Otentik Figma saat Terpilih
            if (isSelected)
              Image.asset(
                AppIcons.icBankSelectedCheck,
                width: 26,
                height: 26,
                fit: BoxFit.contain,
              ),
          ],
        ),
      ),
    );
  }

  // =========================================================================
  // 2. DETAIL VIRTUAL ACCOUNT BANK (FRAME #167:31)
  // =========================================================================
  Widget _buildDetailVirtualAccountView() {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. Baris Bank Terpilih
                Container(
                  height: 75,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    border: Border(
                      bottom: BorderSide(color: Colors.black, width: 1.0),
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.06),
                              blurRadius: 4,
                              offset: const Offset(0, 1),
                            ),
                          ],
                        ),
                        child: Center(
                          child: AppIcons.buildImageOrIcon(
                            _selectedMethodLogo,
                            width: 34,
                            height: 34,
                            fallbackIcon: Icons.account_balance,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Text(
                        _selectedMethodName ?? 'Bank BRI',
                        style: GoogleFonts.robotoSlab(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),

                // 1b. Khusus Bank Lainnya: Informasi Kode Bank yang Bisa Disalin
                if (_selectedMethodName == 'Bank lainnya')
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.only(
                      left: 64,
                      right: 24,
                      top: 18,
                      bottom: 20,
                    ),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      border: Border(
                        bottom: BorderSide(color: Colors.black, width: 1.0),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Kode Bank',
                          style: GoogleFonts.robotoSlab(
                            fontSize: 15.5,
                            fontWeight: FontWeight.w400,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                '013',
                                style: GoogleFonts.poppins(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xFFCA31FF),
                                  letterSpacing: 1.0,
                                ),
                              ),
                            ),
                            GestureDetector(
                              behavior: HitTestBehavior.opaque,
                              onTap: () {
                                Clipboard.setData(
                                  const ClipboardData(text: '013'),
                                );
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Kode bank 013 berhasil disalin!'),
                                    backgroundColor: Color(0xFF300742),
                                    duration: Duration(seconds: 2),
                                  ),
                                );
                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                                child: Text(
                                  'Salin',
                                  style: GoogleFonts.robotoSlab(
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                // 2. Bagian No. Rek/Virtual Account
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.only(
                    left: 64,
                    right: 24,
                    top: 18,
                    bottom: 20,
                  ),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    border: Border(
                      bottom: BorderSide(color: Colors.black, width: 1.0),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'No. Rek/Virtual Account',
                        style: GoogleFonts.robotoSlab(
                          fontSize: 15.5,
                          fontWeight: FontWeight.w400,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              _selectedVaNumber,
                              style: GoogleFonts.poppins(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFFCA31FF),
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                          GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onTap: () {
                              Clipboard.setData(
                                ClipboardData(text: _selectedVaNumber.replaceAll(' ', '')),
                              );
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Nomor VA $_selectedMethodName berhasil disalin!'),
                                  backgroundColor: const Color(0xFF300742),
                                  duration: const Duration(seconds: 2),
                                ),
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                              child: Text(
                                'Salin',
                                style: GoogleFonts.robotoSlab(
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // 3. Penjelasan Transfer & Minimal Transfer
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.only(
                    left: 64,
                    right: 58,
                    top: 22,
                    bottom: 24,
                  ),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    border: Border(
                      bottom: BorderSide(color: Colors.black, width: 1.0),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _selectedMethodName == 'Bank lainnya'
                            ? 'Transfer dari bank mana pun melalui ATM atau m-Banking dengan memasukkan kode bank 013 dan nomor Virtual Account di atas. Saldo XEMA akan langsung masuk secara instan tanpa konfirmasi manual.'
                            : 'Transfer ke nomor Virtual Account di atas menggunakan ${_selectedMethodName ?? "Bank BRI"}. Saldo akan langsung masuk tanpa konfirmasi manual.',
                        style: GoogleFonts.robotoSlab(
                          fontSize: 15,
                          height: 1.45,
                          fontWeight: FontWeight.w400,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 18),
                      Text(
                        '* Minimal 10.000',
                        style: GoogleFonts.robotoSlab(
                          fontSize: 14.5,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFFFF2F68),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),

        // 4. Tombol OK
        _buildBottomOkButton(onTap: () {
          setState(() {
            _currentStep = TopUpStep.pilihMetode;
            _selectedMethodName = null;
          });
        }),
      ],
    );
  }

  // =========================================================================
  // 3. DETAIL ALFAMART & KANTOR POS (FRAME #860:6111 & #860:6137)
  // =========================================================================
  Widget _buildDetailRetailView() {
    final methodData = _retailMethods.firstWhere(
      (m) => m['name'] == _selectedMethodName,
      orElse: () => _retailMethods[1],
    );
    final phone = methodData['phone'] ?? '0851 2343 5656';
    final instruction = methodData['instruction'] ??
        'Kunjungi gerai Alfamart atau Alfamidi terdekat. Berikan nomor handphone di atas kepada kasir untuk memproses pembayaran. Saldo Anda akan otomatis bertambah';

    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. Baris Ritel Terpilih
                Container(
                  height: 75,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    border: Border(
                      bottom: BorderSide(color: Colors.black, width: 1.0),
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.06),
                              blurRadius: 4,
                              offset: const Offset(0, 1),
                            ),
                          ],
                        ),
                        clipBehavior: Clip.antiAlias,
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: Image.asset(
                              methodData['logo']!,
                              width: 40,
                              height: 40,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Text(
                        _selectedMethodName ?? 'Alfamart / Alfamidi',
                        style: GoogleFonts.robotoSlab(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),

                // 2. Bagian No. Handphone (Otentik Figma Frame #860:6111 / #860:6137)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.only(
                    left: 64,
                    right: 24,
                    top: 18,
                    bottom: 20,
                  ),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    border: Border(
                      bottom: BorderSide(color: Colors.black, width: 1.0),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'No. Handphone',
                        style: GoogleFonts.robotoSlab(
                          fontSize: 15.5,
                          fontWeight: FontWeight.w400,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              phone,
                              style: GoogleFonts.poppins(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFFCA31FF),
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Clipboard.setData(
                                ClipboardData(text: phone.replaceAll(' ', '')),
                              );
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Nomor Handphone $phone berhasil disalin!'),
                                  backgroundColor: const Color(0xFF300742),
                                  duration: const Duration(seconds: 2),
                                ),
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                              child: Text(
                                'Salin',
                                style: GoogleFonts.robotoSlab(
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // 3. Penjelasan Kasir & Minimal Transfer
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.only(
                    left: 64,
                    right: 48,
                    top: 22,
                    bottom: 24,
                  ),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    border: Border(
                      bottom: BorderSide(color: Colors.black, width: 1.0),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        instruction,
                        style: GoogleFonts.robotoSlab(
                          fontSize: 14.5,
                          height: 1.45,
                          fontWeight: FontWeight.w400,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 18),
                      Text(
                        '* Minimal 10.000',
                        style: GoogleFonts.robotoSlab(
                          fontSize: 14.5,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFFFF2F68),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),

        // 4. Tombol OK
        _buildBottomOkButton(onTap: () {
          setState(() {
            _currentStep = TopUpStep.pilihMetode;
            _selectedMethodName = null;
          });
        }),
      ],
    );
  }

  // =========================================================================
  // 4. INDOMARET: INPUT NOMINAL + KEYPAD (FRAME #860:5846 / #860:5885)
  // =========================================================================
  void _onKeyTapped(String key) {
    setState(() {
      if (key == '⌫') {
        String str = _indomaretAmount.toString();
        if (str.length > 1) {
          _indomaretAmount = int.tryParse(str.substring(0, str.length - 1)) ?? 0;
        } else {
          _indomaretAmount = 0;
        }
      } else if (key == '✓') {
        _showKeypad = false;
      } else if (key == '-' || key == '␣' || key == ',' || key == '.') {
        // Simbol tambahan pada keypad otentik
      } else {
        String str = _indomaretAmount == 0 ? key : '$_indomaretAmount$key';
        if (str.length <= 8) {
          _indomaretAmount = int.tryParse(str) ?? _indomaretAmount;
        }
      }
    });
  }

  KeyEventResult _handleLaptopKeyEvent(FocusNode node, KeyEvent event) {
    if (event is KeyDownEvent) {
      final key = event.logicalKey;
      if (key == LogicalKeyboardKey.digit0 || key == LogicalKeyboardKey.numpad0) {
        _onKeyTapped('0');
        return KeyEventResult.handled;
      }
      if (key == LogicalKeyboardKey.digit1 || key == LogicalKeyboardKey.numpad1) {
        _onKeyTapped('1');
        return KeyEventResult.handled;
      }
      if (key == LogicalKeyboardKey.digit2 || key == LogicalKeyboardKey.numpad2) {
        _onKeyTapped('2');
        return KeyEventResult.handled;
      }
      if (key == LogicalKeyboardKey.digit3 || key == LogicalKeyboardKey.numpad3) {
        _onKeyTapped('3');
        return KeyEventResult.handled;
      }
      if (key == LogicalKeyboardKey.digit4 || key == LogicalKeyboardKey.numpad4) {
        _onKeyTapped('4');
        return KeyEventResult.handled;
      }
      if (key == LogicalKeyboardKey.digit5 || key == LogicalKeyboardKey.numpad5) {
        _onKeyTapped('5');
        return KeyEventResult.handled;
      }
      if (key == LogicalKeyboardKey.digit6 || key == LogicalKeyboardKey.numpad6) {
        _onKeyTapped('6');
        return KeyEventResult.handled;
      }
      if (key == LogicalKeyboardKey.digit7 || key == LogicalKeyboardKey.numpad7) {
        _onKeyTapped('7');
        return KeyEventResult.handled;
      }
      if (key == LogicalKeyboardKey.digit8 || key == LogicalKeyboardKey.numpad8) {
        _onKeyTapped('8');
        return KeyEventResult.handled;
      }
      if (key == LogicalKeyboardKey.digit9 || key == LogicalKeyboardKey.numpad9) {
        _onKeyTapped('9');
        return KeyEventResult.handled;
      }
      if (key == LogicalKeyboardKey.backspace) {
        _onKeyTapped('⌫');
        return KeyEventResult.handled;
      }
      if (key == LogicalKeyboardKey.enter || key == LogicalKeyboardKey.numpadEnter) {
        _onKeyTapped('✓');
        return KeyEventResult.handled;
      }
      if (key == LogicalKeyboardKey.minus || key == LogicalKeyboardKey.numpadSubtract) {
        _onKeyTapped('-');
        return KeyEventResult.handled;
      }
      if (key == LogicalKeyboardKey.space) {
        _onKeyTapped('␣');
        return KeyEventResult.handled;
      }
      if (key == LogicalKeyboardKey.comma) {
        _onKeyTapped(',');
        return KeyEventResult.handled;
      }
      if (key == LogicalKeyboardKey.period || key == LogicalKeyboardKey.numpadDecimal) {
        _onKeyTapped('.');
        return KeyEventResult.handled;
      }
      if (key == LogicalKeyboardKey.escape) {
        setState(() {
          _showKeypad = false;
        });
        return KeyEventResult.handled;
      }
    }
    return KeyEventResult.ignored;
  }

  Widget _buildIndomaretNominalView() {
    final bool isAmountValid = _indomaretAmount >= 10000;

    return Focus(
      focusNode: _laptopFocusNode,
      autofocus: true,
      onKeyEvent: _handleLaptopKeyEvent,
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 1. Box Metode Pembayaran
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.fromLTRB(20, 14, 20, 14),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      border: Border(
                        bottom: BorderSide(color: Colors.black, width: 1.0),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Metode Pembayaran',
                          style: GoogleFonts.robotoSlab(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Container(
                              width: 44,
                              height: 44,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.06),
                                    blurRadius: 4,
                                    offset: const Offset(0, 1),
                                  ),
                                ],
                              ),
                              clipBehavior: Clip.antiAlias,
                              child: Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(2.0),
                                  child: Image.asset(
                                    AppIcons.logoIndomaret,
                                    width: 40,
                                    height: 40,
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 14),
                            Text(
                              'Indomaret',
                              style: GoogleFonts.robotoSlab(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // 2. Box Masukkan Jumlah (Rp) & Quick Chips
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 18),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      border: Border(
                        bottom: BorderSide(color: Colors.black, width: 1.0),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Masukkan Jumlah (Rp)',
                          style: GoogleFonts.robotoSlab(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 10),

                        // Input Box Abu-abu Otentik Figma (Murni Rp dan nominal, tanpa icon tambahan)
                        GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: () {
                            setState(() {
                              _showKeypad = true;
                            });
                            _laptopFocusNode.requestFocus();
                          },
                          child: Container(
                            width: double.infinity,
                            height: 52,
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            decoration: BoxDecoration(
                              color: const Color(0xFFC4C4C4),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                Text(
                                  'Rp ',
                                  style: GoogleFonts.robotoSlab(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                ),
                                if (_indomaretAmount > 0)
                                  Text(
                                    _formatCurrency(_indomaretAmount),
                                    style: GoogleFonts.poppins(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                if (_showKeypad)
                                  Container(
                                    width: 2,
                                    height: 22,
                                    color: Colors.black54,
                                  ),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: 12),
                        Text(
                          '* Minimal 10.000',
                          style: GoogleFonts.robotoSlab(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFFFF2F68),
                          ),
                        ),

                        const SizedBox(height: 14),

                        // Quick Chips: 100.000, 300.000, 500.000 (Ungu Tua #6E1692)
                        Row(
                          children: [
                            _buildQuickChip(100000),
                            const SizedBox(width: 12),
                            _buildQuickChip(300000),
                            const SizedBox(width: 12),
                            _buildQuickChip(500000),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // 3. Ringkasan Pembayaran (Hanya muncul jika nominal sudah dipilih/diisi > 0)
                  // Otentik Figma: Jumlah Isi Saldo, Biaya Admin (Rp 1.000 Gratis), Total Pembayaran
                  if (_indomaretAmount > 0)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        border: Border(
                          bottom: BorderSide(color: Colors.black, width: 1.0),
                        ),
                      ),
                      child: Column(
                        children: [
                          // Baris 1: Jumlah Isi Saldo
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Jumlah Isi Saldo',
                                style: GoogleFonts.robotoSlab(
                                  fontSize: 14.5,
                                  color: Colors.black87,
                                ),
                              ),
                              Text(
                                'Rp ${_formatCurrency(_indomaretAmount)}',
                                style: GoogleFonts.poppins(
                                  fontSize: 14.5,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),

                          // Baris 2: Biaya Admin (Gratis warna merah)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Biaya Admin',
                                style: GoogleFonts.robotoSlab(
                                  fontSize: 14.5,
                                  color: Colors.black87,
                                ),
                              ),
                              Text(
                                'Gratis',
                                style: GoogleFonts.robotoSlab(
                                  fontSize: 14.5,
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xFFFF2F68),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),

                          // Baris 3: Total Pembayaran
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Total Pembayaran',
                                style: GoogleFonts.robotoSlab(
                                  fontSize: 15.5,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              Text(
                                'Rp ${_formatCurrency(_indomaretAmount)}',
                                style: GoogleFonts.poppins(
                                  fontSize: 16,
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

          // 4. Custom Keypad Otentik Figma (Frame #860:5885)
          // Jika keypad aktif, tampilkan keypad di bagian bawah.
          // Jika keypad tidak aktif, tampilkan tombol Konfirmasi di bagian bawah (Frame #860:5846).
          if (_showKeypad)
            _buildNumericKeypad()
          else
            Padding(
              padding: const EdgeInsets.fromLTRB(22.5, 12, 22.5, 24),
              child: SafeArea(
                top: false,
                child: Container(
                  width: double.infinity,
                  height: 56,
                  decoration: BoxDecoration(
                    color: isAmountValid ? const Color(0xFFCA31FF) : const Color(0xFF6E7179),
                    borderRadius: BorderRadius.circular(28),
                    boxShadow: isAmountValid
                        ? [
                            BoxShadow(
                              color: const Color(0xFFCA31FF).withValues(alpha: 0.35),
                              blurRadius: 16,
                              spreadRadius: 1,
                              offset: const Offset(0, 4),
                            ),
                          ]
                        : [],
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(28),
                      onTap: isAmountValid
                          ? () {
                              setState(() {
                                _currentStep = TopUpStep.indomaretBarcode;
                              });
                            }
                          : null,
                      child: Center(
                        child: Text(
                          'Konfirmasi',
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
            ),
        ],
      ),
    );
  }

  // Quick Chips (100.000, 300.000, 500.000)
  // Aturan User: Jika di klik chip, tidak memunculkan keyboard
  Widget _buildQuickChip(int amount) {
    final isSelected = _indomaretAmount == amount;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _indomaretAmount = amount;
            _showKeypad = false;
          });
        },
        child: Container(
          height: 42,
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF4A0D66) : const Color(0xFF6E1692),
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Center(
            child: Text(
              _formatCurrency(amount),
              style: GoogleFonts.poppins(
                fontSize: 14.5,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Keypad Otentik Figma (Frame #860:5885)
  // Kolom 4 Otentik:
  // Row 1: - (Dash)
  // Row 2: ␣ (Space tray |_|)
  // Row 3: ⌫ (Backspace outline)
  // Row 4: ✓ (Checkmark konfirmasi)
  Widget _buildNumericKeypad() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                _buildKey('1'),
                const SizedBox(width: 8),
                _buildKey('2'),
                const SizedBox(width: 8),
                _buildKey('3'),
                const SizedBox(width: 8),
                _buildKey('-'),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                _buildKey('4'),
                const SizedBox(width: 8),
                _buildKey('5'),
                const SizedBox(width: 8),
                _buildKey('6'),
                const SizedBox(width: 8),
                _buildKey(
                  '␣',
                  customChild: Container(
                    width: 20,
                    height: 9,
                    decoration: const BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: Color(0xFF212121), width: 2.2),
                        left: BorderSide(color: Color(0xFF212121), width: 2.2),
                        right: BorderSide(color: Color(0xFF212121), width: 2.2),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                _buildKey('7'),
                const SizedBox(width: 8),
                _buildKey('8'),
                const SizedBox(width: 8),
                _buildKey('9'),
                const SizedBox(width: 8),
                _buildKey('⌫', isIcon: true, icon: Icons.backspace_outlined),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                _buildKey(','),
                const SizedBox(width: 8),
                _buildKey('0'),
                const SizedBox(width: 8),
                _buildKey('.'),
                const SizedBox(width: 8),
                _buildKey('✓', isIcon: true, icon: Icons.check),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildKey(String label, {bool isIcon = false, IconData? icon, Widget? customChild}) {
    return Expanded(
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          color: const Color(0xFFEBEBEB),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(10),
            onTap: () => _onKeyTapped(label),
            child: Center(
              child: customChild ??
                  (isIcon
                      ? Icon(
                          icon,
                          size: 22,
                          color: const Color(0xFF212121),
                        )
                      : Text(
                          label,
                          style: GoogleFonts.poppins(
                            fontSize: label == '-' ? 24 : 18,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF212121),
                          ),
                        )),
            ),
          ),
        ),
      ),
    );
  }

  // =========================================================================
  // 5. INDOMARET: BARCODE / PAYMENT CODE (FRAME #860:6034 / DETAIL FRAME 6)
  // =========================================================================
  Widget _buildIndomaretBarcodeView() {
    const String indomaretCode = 'XXMMRFD45GYHUJI';

    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. Box Metode Pembayaran
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.fromLTRB(20, 14, 20, 14),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    border: Border(
                      bottom: BorderSide(color: Colors.black, width: 1.0),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Metode Pembayaran',
                        style: GoogleFonts.robotoSlab(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.06),
                                  blurRadius: 4,
                                  offset: const Offset(0, 1),
                                ),
                              ],
                            ),
                            clipBehavior: Clip.antiAlias,
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.all(2.0),
                                child: Image.asset(
                                  AppIcons.logoIndomaret,
                                  width: 40,
                                  height: 40,
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 14),
                          Text(
                            'Indomaret',
                            style: GoogleFonts.robotoSlab(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // 2. Box Timer Hitung Mundur
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    border: Border(
                      bottom: BorderSide(color: Colors.black, width: 1.0),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'Bayar dalam',
                        style: GoogleFonts.robotoSlab(
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _formatTimer(_remainingSeconds),
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFFCA31FF),
                        ),
                      ),
                    ],
                  ),
                ),

                // 3. Box Barcode & Tunjukkan Kode ke Kasir
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 28),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    border: Border(
                      bottom: BorderSide(color: Colors.black, width: 1.0),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Tunjukkan kode ini ke kasir',
                        style: GoogleFonts.robotoSlab(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 18),

                      // Barcode Graphic Otentik Figma
                      _buildBarcodeWidget(),

                      const SizedBox(height: 16),

                      // Kode Alfamumerik Pink/Ungu (#CA31FF)
                      Text(
                        indomaretCode,
                        style: GoogleFonts.poppins(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFFCA31FF),
                          letterSpacing: 1.0,
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Tombol "Salin Kode" (Ungu Tua #6E1692 Stadium Pill)
                      GestureDetector(
                        onTap: () {
                          Clipboard.setData(const ClipboardData(text: indomaretCode));
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Kode pembayaran Indomaret berhasil disalin!'),
                              backgroundColor: Color(0xFF300742),
                              duration: Duration(seconds: 2),
                            ),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 8),
                          decoration: BoxDecoration(
                            color: const Color(0xFF6E1692),
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF6E1692).withValues(alpha: 0.3),
                                blurRadius: 6,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Text(
                            'Salin Kode',
                            style: GoogleFonts.robotoSlab(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),

        // 4. Tombol OK di Bawah
        _buildBottomOkButton(onTap: () {
          setState(() {
            _currentStep = TopUpStep.pilihMetode;
            _selectedMethodName = null;
            _indomaretAmount = 0;
          });
        }),
      ],
    );
  }

  // Barcode Graphic Generator
  Widget _buildBarcodeWidget() {
    // Pola garis barcode otentik
    final List<double> barWidths = [
      4, 2, 3, 1, 2, 4, 1, 3, 2, 1, 4, 2, 1, 3, 2, 4, 1, 2, 3, 1, 4, 2, 1, 3, 2, 1, 4, 1, 3, 2
    ];

    return Container(
      width: 170,
      height: 70,
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: List.generate(barWidths.length, (index) {
          final isBlack = index % 2 == 0;
          return Container(
            width: barWidths[index],
            color: isBlack ? Colors.black : Colors.transparent,
          );
        }),
      ),
    );
  }

  // Tombol OK Stadium Pill di Bagian Bawah
  Widget _buildBottomOkButton({required VoidCallback onTap}) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(22.5, 0, 22.5, 26),
      child: SafeArea(
        top: false,
        child: Container(
          width: double.infinity,
          height: 58,
          decoration: BoxDecoration(
            color: const Color(0xFFCA31FF),
            borderRadius: BorderRadius.circular(29),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFCA31FF).withValues(alpha: 0.35),
                blurRadius: 16,
                spreadRadius: 1,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(29),
              onTap: onTap,
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
    );
  }
}
