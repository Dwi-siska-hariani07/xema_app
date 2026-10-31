import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'top_up_game_user_screen.dart';

class TopUpGameDiamondsScreen extends StatefulWidget {
  final String gameName;
  final String gameSubtitle;
  final String gameIcon;

  const TopUpGameDiamondsScreen({
    super.key,
    this.gameName = 'Mobile Legends:',
    this.gameSubtitle = 'Bang Bang',
    this.gameIcon = 'assets/images/game_mlbb.png',
  });

  @override
  State<TopUpGameDiamondsScreen> createState() => _TopUpGameDiamondsScreenState();
}

class _TopUpGameDiamondsScreenState extends State<TopUpGameDiamondsScreen> {
  int? _selectedIndex;

  // Daftar 10 Paket Diamonds persis sesuai Figma
  final List<Map<String, String>> _diamondPackages = const [
    {'diamonds': '5 Diamonds', 'price': 'Rp 1.000'},
    {'diamonds': '11 Diamonds', 'price': 'Rp 2.580'},
    {'diamonds': '20 Diamonds', 'price': 'Rp 5.500'},
    {'diamonds': '35 Diamonds', 'price': 'Rp 10.800'},
    {'diamonds': '40 Diamonds', 'price': 'Rp 16.400'},
    {'diamonds': '45 Diamonds', 'price': 'Rp 19.200'},
    {'diamonds': '53 Diamonds', 'price': 'Rp 22.900'},
    {'diamonds': '58 Diamonds', 'price': 'Rp 25.300'},
    {'diamonds': '62 Diamonds', 'price': 'Rp 28.900'},
    {'diamonds': '70 Diamonds', 'price': 'Rp 33.000'},
  ];

  void _onPackageSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });

    final package = _diamondPackages[index];

    // Navigasi ke halaman Masukkan User ID persis instruksi pengguna
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TopUpGameUserScreen(
          gameName: widget.gameName,
          gameSubtitle: widget.gameSubtitle,
          gameIcon: widget.gameIcon,
          selectedPackage: package['diamonds']!,
          selectedPrice: package['price']!,
        ),
      ),
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
                    // Gambar Top Bar Asli (Panah, TOP UP GAME, Logo Stik)
                    Image.asset(
                      'assets/images/top_bar_header.png',
                      width: double.infinity,
                      fit: BoxFit.fitWidth,
                    ),

                    // Area Sentuh Tombol Kembali
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
            // 2. KONTEN UTAMA (SCROLLABLE & PROPORSIONAL)
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
                          // Logo Mobile Legends
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

                          // Kotak Gelap Judul Game
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
                    // 2B. CONTAINER UNGU MUDA "Pilih Item" & GRID DIAMONDS
                    // ========================================================
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 18),
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
                          // Judul "Pilih Item"
                          Padding(
                            padding: const EdgeInsets.fromLTRB(20, 20, 20, 14),
                            child: Text(
                              'Pilih Item',
                              style: GoogleFonts.robotoSlab(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFF1C0823),
                              ),
                            ),
                          ),

                          // Grid 10 Paket Diamonds (2 Kolom x 5 Baris)
                          GridView.builder(
                            padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: _diamondPackages.length,
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 14,
                              mainAxisSpacing: 14,
                              childAspectRatio: 1.28,
                            ),
                            itemBuilder: (context, index) {
                              final item = _diamondPackages[index];
                              final isSelected = _selectedIndex == index;

                              return GestureDetector(
                                onTap: () => _onPackageSelected(index),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: isSelected
                                          ? const Color(0xFFCA31FF)
                                          : Colors.transparent,
                                      width: 1.5,
                                    ),
                                    boxShadow: const [
                                      BoxShadow(
                                        color: Color(0x14000000),
                                        blurRadius: 6,
                                        offset: Offset(0, 3),
                                      ),
                                    ],
                                  ),
                                  child: Stack(
                                    children: [
                                      // Ikon Berlian Biru di Sudut Kiri Atas (Diperbesar)
                                      Positioned(
                                        top: 10,
                                        left: 10,
                                        child: Image.asset(
                                          'assets/images/diamond_icon.png',
                                          width: 25,
                                          height: 23,
                                          fit: BoxFit.contain,
                                        ),
                                      ),

                                      // Teks Diamonds & Harga di Tengah Kartu (Font Diperbesar)
                                      Center(
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            const SizedBox(height: 8),
                                            Text(
                                              item['diamonds']!,
                                              textAlign: TextAlign.center,
                                              style: GoogleFonts.robotoSlab(
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              item['price']!,
                                              textAlign: TextAlign.center,
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
                              );
                            },
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
