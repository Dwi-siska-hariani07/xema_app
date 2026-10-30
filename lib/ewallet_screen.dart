import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'ewallet_dana_input_screen.dart';

class EwalletItem {
  final String name;
  final String iconPath;

  const EwalletItem({required this.name, required this.iconPath});
}

class EwalletScreen extends StatefulWidget {
  const EwalletScreen({super.key});

  @override
  State<EwalletScreen> createState() => _EwalletScreenState();
}

class _EwalletScreenState extends State<EwalletScreen> {
  // Controller pencarian
  final TextEditingController _searchController = TextEditingController();

  // Status keyboard virtual in-app untuk pencarian
  bool _isSearchKeyboardOpen = false;

  // Dompet yang sedang dipilih / diklik (misal 'DANA')
  String? _selectedWallet;

  // Daftar lengkap E-Wallet resmi Figma
  final List<EwalletItem> _allWallets = const [
    EwalletItem(name: 'DANA', iconPath: 'assets/images/ewallet_dana_icon.png'),
    EwalletItem(name: 'GoPay', iconPath: 'assets/images/ewallet_gopay_icon.png'),
    EwalletItem(name: 'ShopeePay', iconPath: 'assets/images/ewallet_shopee_icon.png'),
    EwalletItem(name: 'Xema', iconPath: 'assets/images/ewallet_xema_icon.png'),
  ];

  // Hasil pencarian
  List<EwalletItem> get _filteredWallets {
    final query = _searchController.text.trim().toLowerCase();
    if (query.isEmpty) {
      return _allWallets;
    }
    return _allWallets
        .where((item) => item.name.toLowerCase().contains(query))
        .toList();
  }

  void _onKeyPress(String char) {
    setState(() {
      _searchController.text += char;
    });
  }

  void _onDelete() {
    if (_searchController.text.isNotEmpty) {
      setState(() {
        _searchController.text =
            _searchController.text.substring(0, _searchController.text.length - 1);
      });
    }
  }

  void _onClear() {
    setState(() {
      _searchController.clear();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final filtered = _filteredWallets;

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
            child: Column(
              children: [
                // =============================================================
                // 1. HEADER UNGU FIGMA (Warna #CA31FF / #C63BF3)
                // Berisi: Tombol Back, Judul "E-Wallet", dan Icon Dompet
                // =============================================================
                Container(
                  width: 393,
                  height: 110,
                  color: const Color(0xFFC736FE),
                  padding: const EdgeInsets.only(top: 45, left: 16, right: 18),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: const Icon(
                              Icons.arrow_back,
                              size: 26,
                              color: Color(0xFF52086B), // Warna ungu tua sesuai permintaan
                            ),
                          ),
                          const SizedBox(width: 14),
                          Text(
                            'E-Wallet',
                            style: GoogleFonts.poppins(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF52086B), // Warna ungu tua sesuai permintaan
                            ),
                          ),
                        ],
                      ),
                      // Icon dompet kanan atas
                      Image.asset(
                        'assets/images/ewallet_header_wallet.png',
                        width: 30,
                        height: 30,
                        fit: BoxFit.contain,
                      ),
                    ],
                  ),
                ),

                // =============================================================
                // 2. SEARCH BAR FIGMA ("Cari E-Wallet")
                // =============================================================
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _isSearchKeyboardOpen = true;
                      });
                    },
                    child: Container(
                      height: 44,
                      decoration: BoxDecoration(
                        color: const Color(0xFFD4D4D4), // Warna abu-abu search bar Figma
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.search_rounded,
                            size: 22,
                            color: Color(0xFF333333),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              _searchController.text.isEmpty
                                  ? 'Cari E-Wallet'
                                  : _searchController.text,
                              style: GoogleFonts.pochaevsk(
                                fontSize: 13.5,
                                color: _searchController.text.isEmpty
                                    ? const Color(0xFF555555)
                                    : const Color(0xFF1E1E1E),
                              ),
                            ),
                          ),
                          if (_searchController.text.isNotEmpty)
                            GestureDetector(
                              onTap: _onClear,
                              child: const Icon(
                                Icons.close_rounded,
                                size: 18,
                                color: Color(0xFF555555),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),

                // =============================================================
                // 3. DAFTAR E-WALLET & STATUS TIDAK DITEMUKAN
                // =============================================================
                Expanded(
                  child: filtered.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.search_off_rounded,
                                size: 64,
                                color: Color(0xFF9E9E9E),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                'E-Wallet tidak ditemukan',
                                style: GoogleFonts.poppins(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xFF333333),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Coba kata kunci lain atau periksa ejaan',
                                style: GoogleFonts.pochaevsk(
                                  fontSize: 12.5,
                                  color: const Color(0xFF777777),
                                ),
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          padding: EdgeInsets.zero,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: filtered.length,
                          itemBuilder: (context, index) {
                            final wallet = filtered[index];
                            final isSelected = _selectedWallet == wallet.name;

                            return InkWell(
                              onTap: () async {
                                setState(() {
                                  _selectedWallet = wallet.name;
                                  _isSearchKeyboardOpen = false;
                                });
                                // Jika yang dipilih DANA, lanjutkan ke halaman DANA (Input Nomor)
                                if (wallet.name == 'DANA') {
                                  await Future.delayed(const Duration(milliseconds: 250));
                                  if (!context.mounted) return;
                                  await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const EwalletDanaInputScreen(),
                                    ),
                                  );
                                  // Saat kembali ke layar ini, reset seleksi agar tidak ada warna abu-abu
                                  if (mounted) {
                                    setState(() {
                                      _selectedWallet = null;
                                    });
                                  }
                                }
                              },
                              child: Container(
                                height: 60,
                                width: 393,
                                // Warna abu-abu #E8E8E8 jika sedang diklik/dipilih
                                color: isSelected
                                    ? const Color(0xFFE8E8E8)
                                    : Colors.transparent,
                                padding: const EdgeInsets.symmetric(horizontal: 22),
                                child: Row(
                                  children: [
                                    Image.asset(
                                      wallet.iconPath,
                                      width: 36,
                                      height: 36,
                                      fit: BoxFit.contain,
                                    ),
                                    const SizedBox(width: 16),
                                    Text(
                                      wallet.name,
                                      style: GoogleFonts.poppins(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,
                                        color: const Color(0xFF1E1E1E),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                ),

                // =============================================================
                // 4. KEYBOARD VIRTUAL PENCARIAN (In-App QWERTY)
                // =============================================================
                if (_isSearchKeyboardOpen)
                  Container(
                    width: 393,
                    color: const Color(0xFFD6D7DC),
                    padding: const EdgeInsets.only(top: 8, bottom: 20),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Tombol Selesai di bar atas keyboard
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Ketik nama E-Wallet...',
                                style: GoogleFonts.pochaevsk(
                                  fontSize: 12,
                                  color: const Color(0xFF555555),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _isSearchKeyboardOpen = false;
                                  });
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFC736FE),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    'Selesai',
                                    style: GoogleFonts.poppins(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 6),
                        // Baris 1 QWERTY
                        _buildKeyboardRow(['Q', 'W', 'E', 'R', 'T', 'Y', 'U', 'I', 'O', 'P']),
                        const SizedBox(height: 6),
                        // Baris 2 ASDFGHJKL
                        _buildKeyboardRow(['A', 'S', 'D', 'F', 'G', 'H', 'J', 'K', 'L']),
                        const SizedBox(height: 6),
                        // Baris 3 ZXCVBNM + Backspace
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ...['Z', 'X', 'C', 'V', 'B', 'N', 'M'].map((ch) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 2.5),
                                child: _buildKeyBtn(ch, () => _onKeyPress(ch)),
                              );
                            }),
                            const SizedBox(width: 4),
                            _buildKeyBtn('⌫', _onDelete, isSpecial: true, width: 44),
                          ],
                        ),
                        const SizedBox(height: 6),
                        // Baris Spasi
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _buildKeyBtn('Spasi', () => _onKeyPress(' '), isSpecial: true, width: 140),
                          ],
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildKeyboardRow(List<String> keys) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: keys.map((k) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 2.5),
          child: _buildKeyBtn(k, () => _onKeyPress(k)),
        );
      }).toList(),
    );
  }

  Widget _buildKeyBtn(String label, VoidCallback onTap, {bool isSpecial = false, double width = 32}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        height: 42,
        decoration: BoxDecoration(
          color: isSpecial ? const Color(0xFFADB3BC) : Colors.white,
          borderRadius: BorderRadius.circular(5),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 1,
              offset: Offset(0, 1),
            ),
          ],
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: isSpecial ? 13 : 15,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF1E1E1E),
          ),
        ),
      ),
    );
  }
}
