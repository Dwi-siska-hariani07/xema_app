import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'top_up_game_diamonds_screen.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  void _onGameSelected(String gameName) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Top Up $gameName',
                style: GoogleFonts.robotoSlab(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF490B60),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Layanan top up resmi dan instan dengan Saldo Xema.',
                style: GoogleFonts.robotoSlab(fontSize: 13, color: Colors.grey[700]),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFCA31FF),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                  ),
                  child: Text(
                    'PILIH NOMINAL',
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
        );
      },
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
            // 1. TOP BAR / APPBAR FIGMA (GAMBAR ASLI PERSIS GAMBAR 1)
            // ========================================================
            Container(
              width: double.infinity,
              color: const Color(0xFFD373FC),
              child: SafeArea(
                bottom: false,
                child: Stack(
                  children: [
                    // Gambar Top Bar Asli dari Figma
                    Image.asset(
                      'assets/images/top_bar_header.png',
                      width: double.infinity,
                      fit: BoxFit.fitWidth,
                    ),

                    // Area Sentuh Tombol Kembali (Di atas tanda panah kiri)
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

            // Konten Utama (Proporsional & Mengisi Layar Penuh Tanpa Ruang Kosong Bawah)
            Expanded(
              child: SingleChildScrollView(
                physics: const NeverScrollableScrollPhysics(), // Layar terkunci dan pas, tidak bisa di-scroll ke bawah
                child: Column(
                  children: [
                    const SizedBox(height: 20),

                    // ========================================================
                    // 2. BANNER PROMO BISA DIGESER KE KANAN & KIRI (CAROUSEL)
                    // Ukuran Eksak Figma: W 309, H 100, Corner Radius 10
                    // ========================================================
                    SizedBox(
                      height: 112,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                        physics: const BouncingScrollPhysics(),
                        children: [
                          _buildBannerItem('assets/images/game_banner1.png'),
                          const SizedBox(width: 14),
                          _buildBannerItem('assets/images/game_banner2.png'),
                          const SizedBox(width: 14),
                          _buildBannerItem('assets/images/game_banner3.png'),
                        ],
                      ),
                    ),

                    const SizedBox(height: 28),

                    // ========================================================
                    // 3. JUDUL: Mobile Games (Roboto Slab, Ukuran 32 & Lebih Turun)
                    // ========================================================
                    Text(
                      'Mobile Games',
                      style: GoogleFonts.robotoSlab(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF490B60),
                      ),
                    ),

                    const SizedBox(height: 10),

                    // ========================================================
                    // 4. GRID 4 GAME ASLI 100% PERSIS FIGMA (BINTANG, UKURAN & POSISI)
                    // ========================================================
                    LayoutBuilder(
                      builder: (context, constraints) {
                        final gridWidth = constraints.maxWidth;
                        // Aspect ratio gambar grid asli dari Figma: 638 x 837
                        final gridHeight = gridWidth * (837 / 638);
                        return SizedBox(
                          width: gridWidth,
                          height: gridHeight,
                          child: Stack(
                            children: [
                              // Gambar 100% Asli Figma (Bintang, Tata Letak, Ukuran, Font, & Kartu)
                              Image.asset(
                                'assets/images/figma_games_grid.png',
                                width: gridWidth,
                                height: gridHeight,
                                fit: BoxFit.fill,
                              ),

                              // Area Sentuh 1: Mobile Legends: Bang Bang
                              Positioned(
                                left: gridWidth * 0.083,
                                top: gridHeight * 0.056,
                                width: gridWidth * 0.332,
                                height: gridHeight * 0.376,
                                child: GestureDetector(
                                  behavior: HitTestBehavior.opaque,
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => const TopUpGameDiamondsScreen(),
                                      ),
                                    );
                                  },
                                ),
                              ),

                              // Area Sentuh 2: Free Fire
                              Positioned(
                                left: gridWidth * 0.547,
                                top: gridHeight * 0.056,
                                width: gridWidth * 0.332,
                                height: gridHeight * 0.329,
                                child: GestureDetector(
                                  behavior: HitTestBehavior.opaque,
                                  onTap: () => _onGameSelected('Free Fire'),
                                ),
                              ),

                              // Area Sentuh 3: Roblox
                              Positioned(
                                left: gridWidth * 0.083,
                                top: gridHeight * 0.577,
                                width: gridWidth * 0.332,
                                height: gridHeight * 0.339,
                                child: GestureDetector(
                                  behavior: HitTestBehavior.opaque,
                                  onTap: () => _onGameSelected('Roblox'),
                                ),
                              ),

                              // Area Sentuh 4: PUBG Mobile
                              Positioned(
                                left: gridWidth * 0.564,
                                top: gridHeight * 0.579,
                                width: gridWidth * 0.334,
                                height: gridHeight * 0.337,
                                child: GestureDetector(
                                  behavior: HitTestBehavior.opaque,
                                  onTap: () => _onGameSelected('PUBG Mobile'),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget Item Banner Promo (Ukuran Eksak Figma: W 309, H 100, Radius 10)
  Widget _buildBannerItem(String assetPath) {
    return Container(
      width: 309,
      height: 100,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        boxShadow: const [
          BoxShadow(
            color: Color(0x1F000000), // Shadow hitam halus alami persis Figma
            blurRadius: 8,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Image.asset(
          assetPath,
          width: 309,
          height: 100,
          fit: BoxFit.fill,
        ),
      ),
    );
  }
}


