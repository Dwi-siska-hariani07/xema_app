import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'bukti_transaksi_game_screen.dart';

class TopUpGameUserScreen extends StatefulWidget {
  final String gameName;
  final String gameSubtitle;
  final String gameIcon;
  final String selectedPackage;
  final String selectedPrice;

  const TopUpGameUserScreen({
    super.key,
    this.gameName = 'Mobile Legends:',
    this.gameSubtitle = 'Bang Bang',
    this.gameIcon = 'assets/images/game_mlbb.png',
    this.selectedPackage = '70 Diamonds',
    this.selectedPrice = 'Rp 33.000',
  });

  @override
  State<TopUpGameUserScreen> createState() => _TopUpGameUserScreenState();
}

class _TopUpGameUserScreenState extends State<TopUpGameUserScreen> {
  String _userId = '';
  String _zoneId = '';
  int _activeField = 0; // 0: User ID, 1: Zone ID

  void _onKeyPress(String val) {
    setState(() {
      if (_activeField == 0) {
        if (_userId.length < 12) {
          _userId += val;
        }
      } else {
        if (_zoneId.length < 6) {
          _zoneId += val;
        }
      }
    });
  }

  void _onBackspace() {
    setState(() {
      if (_activeField == 0) {
        if (_userId.isNotEmpty) {
          _userId = _userId.substring(0, _userId.length - 1);
        }
      } else {
        if (_zoneId.isNotEmpty) {
          _zoneId = _zoneId.substring(0, _zoneId.length - 1);
        }
      }
    });
  }

  void _onLanjutkan() {
    final displayUserId = _userId.trim().isNotEmpty ? _userId : '490061864';
    final displayZoneId = _zoneId.trim().isNotEmpty ? _zoneId : '2489';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: const Color(0x8C000000),
      builder: (context) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 22, 20, 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Judul: Transaksi
                  Text(
                    'Transaksi',
                    style: GoogleFonts.robotoSlab(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Pastikan rincian pembelianmu sudah benar!',
                    style: GoogleFonts.robotoSlab(
                      fontSize: 12,
                      color: Colors.black87,
                    ),
                  ),

                  const SizedBox(height: 14),
                  const Divider(height: 1, thickness: 1, color: Color(0xFFE0E0E0)),
                  const SizedBox(height: 16),

                  // Detail Paket Diamonds
                  Row(
                    children: [
                      Image.asset(
                        'assets/images/diamond_icon.png',
                        width: 26,
                        height: 24,
                        fit: BoxFit.contain,
                      ),
                      const SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.selectedPackage,
                            style: GoogleFonts.robotoSlab(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            widget.selectedPrice,
                            style: GoogleFonts.robotoSlab(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),
                  const Divider(height: 1, thickness: 1, color: Color(0xFFE0E0E0)),
                  const SizedBox(height: 16),

                  // Data Akun (Username, User ID, Zone ID, Metode)
                  _buildDetailRow('Username', 'L’ravuelle'),
                  const SizedBox(height: 12),
                  _buildDetailRow('User ID', displayUserId),
                  const SizedBox(height: 12),
                  _buildDetailRow('Zone ID', displayZoneId),
                  const SizedBox(height: 12),
                  _buildDetailRow('Metode\nPembayaran', 'Xema'),

                  const SizedBox(height: 16),
                  const Divider(height: 1, thickness: 1, color: Color(0xFFE0E0E0)),
                  const SizedBox(height: 16),

                  // Baris Total
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Total',
                        style: GoogleFonts.robotoSlab(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        widget.selectedPrice,
                        style: GoogleFonts.robotoSlab(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),
                  Text(
                    'Pastikan data akun sudah benar\nsebelum melakukan konfirmasi pembayaran',
                    style: GoogleFonts.robotoSlab(
                      fontSize: 11,
                      color: Colors.grey[700],
                      height: 1.35,
                    ),
                  ),

                  const SizedBox(height: 26),

                  // Tombol Konfirmasi Magenta
                  Center(
                    child: SizedBox(
                      width: 160,
                      height: 40,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context); // Tutup modal sheet
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => BuktiTransaksiGameScreen(
                                totalAmount: widget.selectedPrice,
                              ),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFCA31FF),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          elevation: 0,
                        ),
                        child: Text(
                          'Konfirmasi',
                          style: GoogleFonts.robotoSlab(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.robotoSlab(
            fontSize: 13,
            color: Colors.grey[700],
          ),
        ),
        Text(
          value,
          style: GoogleFonts.robotoSlab(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ],
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            // ========================================================
            // 1. TOP BAR / APPBAR ASLI PERSIS FIGMA (TIDAK BERUBAH)
            // ========================================================
            Container(
              width: double.infinity,
              color: const Color(0xFFD373FC),
              child: SafeArea(
                bottom: false,
                child: Stack(
                  children: [
                    Image.asset(
                      'assets/images/top_bar_header.png',
                      width: double.infinity,
                      fit: BoxFit.fitWidth,
                    ),
                    Positioned(
                      left: 0,
                      top: 0,
                      bottom: 12,
                      width: 72,
                      child: GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () {
                          if (Navigator.canPop(context)) {
                            Navigator.pop(context);
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // ========================================================
            // 2. KONTEN UTAMA (SCROLLABLE)
            // ========================================================
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    const SizedBox(height: 18),

                    // ========================================================
                    // 2A. ROW INFO GAME (LOGO MLBB + KOTAK GELAP JUDUL)
                    // ========================================================
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 18),
                      child: Row(
                        children: [
                          Container(
                            width: 64,
                            height: 64,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: const [
                                BoxShadow(
                                  color: Color(0x1F000000),
                                  blurRadius: 6,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.asset(
                                widget.gameIcon,
                                width: 64,
                                height: 64,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Container(
                              height: 64,
                              decoration: BoxDecoration(
                                color: const Color(0xFF1C0823),
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Color(0x1F000000),
                                    blurRadius: 6,
                                    offset: Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    widget.gameName,
                                    style: GoogleFonts.robotoSlab(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    widget.gameSubtitle,
                                    style: GoogleFonts.robotoSlab(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // ========================================================
                    // 2B. CONTAINER UNGU MUDA "Masukkan User ID"
                    // ========================================================
                    Container(
                      width: double.infinity,
                      margin: const EdgeInsets.symmetric(horizontal: 18),
                      padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFAF0FE),
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x0A000000),
                            blurRadius: 8,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Judul: Masukkan User ID
                          Text(
                            'Masukkan User ID',
                            style: GoogleFonts.robotoSlab(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),

                          const SizedBox(height: 18),

                          // Box Input User ID
                          GestureDetector(
                            onTap: () => setState(() => _activeField = 0),
                            child: Container(
                              width: 210,
                              height: 48,
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: _activeField == 0
                                      ? const Color(0xFFCA31FF)
                                      : Colors.transparent,
                                  width: 1.5,
                                ),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Color(0x1F000000),
                                    blurRadius: 6,
                                    offset: Offset(0, 2),
                                  ),
                                ],
                              ),
                              alignment: Alignment.centerLeft,
                              child: Text(
                                _userId.isEmpty ? 'User ID' : _userId,
                                style: GoogleFonts.robotoSlab(
                                  fontSize: 14,
                                  fontWeight: _userId.isEmpty
                                      ? FontWeight.normal
                                      : FontWeight.bold,
                                  color: _userId.isEmpty
                                      ? Colors.black87
                                      : Colors.black,
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 14),

                          // Box Input Zone ID
                          GestureDetector(
                            onTap: () => setState(() => _activeField = 1),
                            child: Container(
                              width: 130,
                              height: 48,
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: _activeField == 1
                                      ? const Color(0xFFCA31FF)
                                      : Colors.transparent,
                                  width: 1.5,
                                ),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Color(0x1F000000),
                                    blurRadius: 6,
                                    offset: Offset(0, 2),
                                  ),
                                ],
                              ),
                              alignment: Alignment.centerLeft,
                              child: Text(
                                _zoneId.isEmpty ? 'Zone ID' : _zoneId,
                                style: GoogleFonts.robotoSlab(
                                  fontSize: 14,
                                  fontWeight: _zoneId.isEmpty
                                      ? FontWeight.normal
                                      : FontWeight.bold,
                                  color: _zoneId.isEmpty
                                      ? Colors.black87
                                      : Colors.black,
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 18),

                          // Teks Bantuan / Penjelasan Persis Figma
                          Text(
                            'Silakan masukkan User ID dan Zone ID Anda.\nContoh: 12345678 (2001).\nKesalahan penulisan ID bukan tanggung jawab\nkami',
                            style: GoogleFonts.robotoSlab(
                              fontSize: 12,
                              color: Colors.black87,
                              height: 1.4,
                            ),
                          ),

                          const SizedBox(height: 22),

                          // Tombol Lanjutkan (Berada di Tengah)
                          Center(
                            child: SizedBox(
                              width: 110,
                              height: 36,
                              child: ElevatedButton(
                                onPressed: _onLanjutkan,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFFCA31FF),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18),
                                  ),
                                  elevation: 0,
                                  padding: EdgeInsets.zero,
                                ),
                                child: Text(
                                  'Lanjutkan',
                                  style: GoogleFonts.robotoSlab(
                                    fontSize: 13,
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

                    const SizedBox(height: 24),

                    // ========================================================
                    // 2C. KEYPAD NUMERIK EKSKLUSIF PERSIS GAMBAR FIGMA
                    // 4 Kolom x 4 Baris
                    // ========================================================
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 18),
                      child: Column(
                        children: [
                          _buildKeypadRow(['1', '2', '3', '-']),
                          const SizedBox(height: 10),
                          _buildKeypadRow(['4', '5', '6', '_']),
                          const SizedBox(height: 10),
                          _buildKeypadRow(['7', '8', '9', 'backspace']),
                          const SizedBox(height: 10),
                          _buildKeypadRow([',', '0', '.', 'check']),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget Baris Tombol Keypad
  Widget _buildKeypadRow(List<String> keys) {
    return Row(
      children: keys.map((key) {
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: _buildKeyBtn(key),
          ),
        );
      }).toList(),
    );
  }

  // Widget Tiap Tombol Keypad Sesuai Figma
  Widget _buildKeyBtn(String key) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          if (key == 'backspace') {
            _onBackspace();
          } else if (key == 'check') {
            _onLanjutkan();
          } else {
            _onKeyPress(key);
          }
        },
        borderRadius: BorderRadius.circular(8),
        child: Container(
          height: 40,
          decoration: BoxDecoration(
            color: const Color(0xFFD9D9D9),
            borderRadius: BorderRadius.circular(8),
          ),
          alignment: Alignment.center,
          child: _buildKeyContent(key),
        ),
      ),
    );
  }

  Widget _buildKeyContent(String key) {
    if (key == 'backspace') {
      return const Icon(
        Icons.backspace_outlined,
        size: 18,
        color: Colors.black,
      );
    } else if (key == 'check') {
      return const Icon(
        Icons.check,
        size: 20,
        color: Colors.black,
      );
    } else {
      return Text(
        key,
        style: GoogleFonts.robotoSlab(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      );
    }
  }
}
