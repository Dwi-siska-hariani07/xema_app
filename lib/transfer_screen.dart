import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TransferScreen extends StatefulWidget {
  final bool isEwallet;
  const TransferScreen({super.key, this.isEwallet = false});

  @override
  State<TransferScreen> createState() => _TransferScreenState();
}

class _TransferScreenState extends State<TransferScreen> {
  final TextEditingController _accountController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  String _selectedBank = 'BCA';
  int _currentStep = 1; // 1: Input, 2: Konfirmasi, 3: Resi Sukses

  final List<Map<String, String>> _banks = [
    {'name': 'Sesama Xema', 'code': 'XEMA'},
    {'name': 'Bank Central Asia', 'code': 'BCA'},
    {'name': 'Bank Mandiri', 'code': 'MANDIRI'},
    {'name': 'Bank Rakyat Indonesia', 'code': 'BRI'},
    {'name': 'Bank Negara Indonesia', 'code': 'BNI'},
    {'name': 'DANA E-Wallet', 'code': 'DANA'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          widget.isEwallet ? 'Transfer E-Wallet' : 'Transfer Saldo',
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF570374),
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Color(0xFF570374)),
          onPressed: () {
            if (_currentStep > 1 && _currentStep < 3) {
              setState(() => _currentStep = 1);
            } else {
              Navigator.pop(context);
            }
          },
        ),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_currentStep == 1) {
      return _buildInputStep();
    } else if (_currentStep == 2) {
      return _buildConfirmStep();
    } else {
      return _buildReceiptStep();
    }
  }

  // STEP 1: INPUT TUJUAN & NOMINAL
  Widget _buildInputStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Pilih Tujuan Transfer',
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF570374),
            ),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            decoration: BoxDecoration(
              color: const Color(0xFFF3D8FF),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFCA31FF), width: 1),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _selectedBank,
                isExpanded: true,
                items: _banks.map((b) {
                  return DropdownMenuItem<String>(
                    value: b['code'],
                    child: Text(
                      '${b['name']} (${b['code']})',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: const Color(0xFF1C0823),
                      ),
                    ),
                  );
                }).toList(),
                onChanged: (val) {
                  if (val != null) setState(() => _selectedBank = val);
                },
              ),
            ),
          ),

          const SizedBox(height: 20),

          Text(
            'Nomor Rekening / Handphone',
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF570374),
            ),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: _accountController,
            keyboardType: TextInputType.number,
            style: GoogleFonts.robotoSlab(fontSize: 16),
            decoration: InputDecoration(
              hintText: 'Contoh: 085123456789 atau 1234567890',
              hintStyle: GoogleFonts.poppins(fontSize: 13, color: const Color(0xFF939393)),
              filled: true,
              fillColor: const Color(0xFFF3D8FF),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(color: Color(0xFFCA31FF)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(color: Color(0xFFCA31FF)),
              ),
            ),
          ),

          const SizedBox(height: 20),

          Text(
            'Nominal Transfer (Rp)',
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF570374),
            ),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: _amountController,
            keyboardType: TextInputType.number,
            style: GoogleFonts.robotoSlab(fontSize: 20, fontWeight: FontWeight.bold),
            decoration: InputDecoration(
              prefixText: 'Rp ',
              hintText: '0',
              filled: true,
              fillColor: const Color(0xFFF3D8FF),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(color: Color(0xFFCA31FF)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(color: Color(0xFFCA31FF)),
              ),
            ),
          ),

          const SizedBox(height: 12),

          // Pilihan Cepat Nominal
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: ['50.000', '100.000', '200.000', '500.000', '1.000.000'].map((amt) {
              return ActionChip(
                backgroundColor: const Color(0xFFF3D8FF),
                side: const BorderSide(color: Color(0xFFCA31FF), width: 0.8),
                label: Text(
                  'Rp $amt',
                  style: GoogleFonts.robotoSlab(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF570374),
                  ),
                ),
                onPressed: () {
                  setState(() => _amountController.text = amt.replaceAll('.', ''));
                },
              );
            }).toList(),
          ),

          const SizedBox(height: 35),

          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: () {
                if (_accountController.text.isNotEmpty && _amountController.text.isNotEmpty) {
                  setState(() => _currentStep = 2);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Silakan masukkan nomor rekening dan nominal transfer')),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFCA31FF),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(26)),
              ),
              child: Text(
                'Lanjutkan',
                style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // STEP 2: KONFIRMASI TRANSFER & INPUT PIN
  Widget _buildConfirmStep() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFFF3D8FF),
              borderRadius: BorderRadius.circular(22),
              border: Border.all(color: const Color(0xFFCA31FF)),
            ),
            child: Column(
              children: [
                _buildConfirmRow('Tujuan', '$_selectedBank - ${_accountController.text}'),
                const Divider(color: Color(0xFFCA31FF), height: 24),
                _buildConfirmRow('Nama Penerima', 'DNI DXX SIS'),
                const Divider(color: Color(0xFFCA31FF), height: 24),
                _buildConfirmRow('Nominal Transfer', 'Rp ${_amountController.text}'),
                const Divider(color: Color(0xFFCA31FF), height: 24),
                _buildConfirmRow('Biaya Admin', 'Gratis (Rp 0)'),
                const Divider(color: Color(0xFFCA31FF), height: 24),
                _buildConfirmRow('Total Bayar', 'Rp ${_amountController.text}', isBold: true),
              ],
            ),
          ),
          const Spacer(),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: () => _showPinDialog(),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF52086B),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(26)),
              ),
              child: Text(
                'Konfirmasi & Bayar',
                style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConfirmRow(String title, String value, {bool isBold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: GoogleFonts.poppins(
            fontSize: 13,
            color: const Color(0xFF570374),
          ),
        ),
        Text(
          value,
          style: GoogleFonts.robotoSlab(
            fontSize: 14,
            fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
            color: const Color(0xFF1C0823),
          ),
        ),
      ],
    );
  }

  void _showPinDialog() {
    String pin = '';
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
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
                children: [
                  Text(
                    'Masukkan PIN Keamanan',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF570374),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Indikator 6 Digit PIN
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(6, (index) {
                      bool isFilled = index < pin.length;
                      return Container(
                        margin: const EdgeInsets.symmetric(horizontal: 6),
                        width: 16,
                        height: 16,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isFilled ? const Color(0xFFCA31FF) : const Color(0xFFF3D8FF),
                          border: Border.all(color: const Color(0xFFCA31FF)),
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 24),
                  // Keypad Numerik 1-9
                  Wrap(
                    spacing: 20,
                    runSpacing: 15,
                    alignment: WrapAlignment.center,
                    children: [
                      for (var i = 1; i <= 9; i++)
                        _buildKeypadBtn(i.toString(), () {
                          if (pin.length < 6) {
                            setModalState(() => pin += i.toString());
                            if (pin.length == 6) {
                              Navigator.pop(context);
                              setState(() => _currentStep = 3);
                            }
                          }
                        }),
                      const SizedBox(width: 60, height: 60),
                      _buildKeypadBtn('0', () {
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
                        icon: const Icon(Icons.backspace_outlined, color: Color(0xFF570374)),
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

  Widget _buildKeypadBtn(String digit, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(30),
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: const Color(0xFFF3D8FF),
        ),
        child: Center(
          child: Text(
            digit,
            style: GoogleFonts.robotoSlab(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF570374),
            ),
          ),
        ),
      ),
    );
  }

  // STEP 3: RESI BUKTI TRANSAKSI FIGMA (#403:1048)
  Widget _buildReceiptStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          const Icon(Icons.check_circle_rounded, color: Color(0xFF2E7D32), size: 70),
          const SizedBox(height: 12),
          Text(
            'Transaksi Berhasil!',
            style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold, color: const Color(0xFF570374)),
          ),
          const SizedBox(height: 4),
          Text(
            'Rp ${_amountController.text}',
            style: GoogleFonts.robotoSlab(fontSize: 28, fontWeight: FontWeight.bold, color: const Color(0xFF1C0823)),
          ),
          const SizedBox(height: 25),

          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFFF3D8FF),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFFCA31FF)),
            ),
            child: Column(
              children: [
                _buildConfirmRow('No. Referensi', '45499730898'),
                const Divider(color: Color(0xFFCA31FF), height: 20),
                _buildConfirmRow('ID Transaksi', 'A220261002143010V'),
                const Divider(color: Color(0xFFCA31FF), height: 20),
                _buildConfirmRow('Waktu Transaksi', '1 Okt 2026, 09:18 WIB'),
                const Divider(color: Color(0xFFCA31FF), height: 20),
                _buildConfirmRow('Sumber Dana', 'XEMA (LISA ARUNIA)'),
                const Divider(color: Color(0xFFCA31FF), height: 20),
                _buildConfirmRow('Tujuan', '$_selectedBank - ${_accountController.text}'),
                const Divider(color: Color(0xFFCA31FF), height: 20),
                _buildConfirmRow('Penerima', 'DNI DXX SIS'),
              ],
            ),
          ),

          const SizedBox(height: 30),

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
                'Selesai',
                style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
