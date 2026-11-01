import 'package:flutter/material.dart';
import 'transfer_screen.dart';
import 'topup_screen.dart';
import 'ppob_screen.dart';
import 'gold_screen.dart';
import 'ewallet_screen.dart';
import 'top_up_game_diamonds_screen.dart';
import 'beranda_screen.dart';

class DaftarMenuScreen extends StatelessWidget {
  const DaftarMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final scale = screenWidth / 360.0;
    
    // Tinggi header Figma asli = 74dp (skala 360)
    final figmaHeaderHeight = 74.0 * scale;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            // ==================== 1. HEADER UNGU ASLI FIGMA ====================
            // Latar belakang gelembung memanjang ke status bar tanpa meregangkan motif Figma
            Stack(
              children: [
                // Background yang menyatu ke atas status bar
                Container(
                  width: double.infinity,
                  height: MediaQuery.of(context).padding.top + figmaHeaderHeight,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/figma_menu_header_seamless_extended_bg.png'),
                      fit: BoxFit.cover,
                      alignment: Alignment.bottomCenter,
                    ),
                  ),
                ),

                // Area Header Figma 1:1 Presisi di bawah Status Bar
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  height: figmaHeaderHeight,
                  child: Stack(
                    children: [
                      // Gambar header asli Figma (rasio 360x74 = 1080x222)
                      Positioned.fill(
                        child: Image.asset(
                          'assets/images/figma_menu_header_pure_1080.png',
                          fit: BoxFit.fill,
                        ),
                      ),

                      // Area Klik Tombol Kembali (Back Arrow)
                      Positioned(
                        left: 0,
                        top: 0,
                        bottom: 0,
                        width: 70 * scale,
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            splashColor: Colors.white.withValues(alpha: 0.35),
                            highlightColor: Colors.white.withValues(alpha: 0.2),
                            onTap: () {
                              if (Navigator.canPop(context)) {
                                Navigator.pop(context);
                              } else {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(builder: (_) => const BerandaScreen()),
                                );
                              }
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            // ==================== JARAK PUTIH BERSIH FIGMA ====================
            SizedBox(height: 14 * scale),

            // ==================== 2. KARTU MENU LAVENDER 1:1 FIGMA ====================
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 27 * scale),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24 * scale),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.08),
                      blurRadius: 18 * scale,
                      offset: Offset(0, 8 * scale),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(24 * scale),
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final cardWidth = constraints.maxWidth;
                      final cardHeight = cardWidth * (1998.0 / 918.0);

                      return SizedBox(
                        width: cardWidth,
                        height: cardHeight,
                        child: Stack(
                          children: [
                            // Visual Kartu Asli Figma (Bersih tanpa garis ungu)
                            Positioned.fill(
                              child: Image.asset(
                                'assets/images/figma_daftar_menu_card_clean.png',
                                fit: BoxFit.fill,
                              ),
                            ),

                            // ==================== DAFTAR INTERAKTIF ====================
                            // 1. TRANSFER BANK (Ikon Bank Ungu)
                            _buildTapBox(
                              left: cardWidth * (10 / 304),
                              top: cardHeight * (18 / 617),
                              width: cardWidth * (75 / 304),
                              height: cardHeight * (75 / 617),
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(builder: (_) => const TransferScreen()),
                              ),
                            ),

                            // SeaBank
                            _buildTapBox(
                              left: cardWidth * (95 / 304),
                              top: cardHeight * (15 / 617),
                              width: cardWidth * (95 / 304),
                              height: cardHeight * (42 / 617),
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(builder: (_) => const TransferScreen()),
                              ),
                            ),

                            // Bank BRI
                            _buildTapBox(
                              left: cardWidth * (195 / 304),
                              top: cardHeight * (15 / 617),
                              width: cardWidth * (95 / 304),
                              height: cardHeight * (42 / 617),
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(builder: (_) => const TransferScreen()),
                              ),
                            ),

                            // BCA
                            _buildTapBox(
                              left: cardWidth * (95 / 304),
                              top: cardHeight * (59 / 617),
                              width: cardWidth * (95 / 304),
                              height: cardHeight * (42 / 617),
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(builder: (_) => const TransferScreen()),
                              ),
                            ),

                            // BSI
                            _buildTapBox(
                              left: cardWidth * (195 / 304),
                              top: cardHeight * (59 / 617),
                              width: cardWidth * (95 / 304),
                              height: cardHeight * (42 / 617),
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(builder: (_) => const TransferScreen()),
                              ),
                            ),

                            // 2. TRANSFER E-WALLET (Ikon Wallet Ungu)
                            _buildTapBox(
                              left: cardWidth * (10 / 304),
                              top: cardHeight * (103 / 617),
                              width: cardWidth * (75 / 304),
                              height: cardHeight * (80 / 617),
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(builder: (_) => const EwalletScreen()),
                              ),
                            ),

                            // DANA
                            _buildTapBox(
                              left: cardWidth * (95 / 304),
                              top: cardHeight * (105 / 617),
                              width: cardWidth * (95 / 304),
                              height: cardHeight * (40 / 617),
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(builder: (_) => const EwalletScreen()),
                              ),
                            ),

                            // xema
                            _buildTapBox(
                              left: cardWidth * (195 / 304),
                              top: cardHeight * (105 / 617),
                              width: cardWidth * (95 / 304),
                              height: cardHeight * (40 / 617),
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(builder: (_) => const TransferScreen()),
                              ),
                            ),

                            // GoPay
                            _buildTapBox(
                              left: cardWidth * (95 / 304),
                              top: cardHeight * (147 / 617),
                              width: cardWidth * (95 / 304),
                              height: cardHeight * (40 / 617),
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(builder: (_) => const EwalletScreen()),
                              ),
                            ),

                            // ShopeePay
                            _buildTapBox(
                              left: cardWidth * (195 / 304),
                              top: cardHeight * (147 / 617),
                              width: cardWidth * (95 / 304),
                              height: cardHeight * (40 / 617),
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(builder: (_) => const EwalletScreen()),
                              ),
                            ),

                            // 3. ISI SALDO (Indomaret & Alfamart)
                            _buildTapBox(
                              left: cardWidth * (15 / 304),
                              top: cardHeight * (218 / 617),
                              width: cardWidth * (135 / 304),
                              height: cardHeight * (48 / 617),
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(builder: (_) => const TopUpScreen()),
                              ),
                            ),

                            _buildTapBox(
                              left: cardWidth * (155 / 304),
                              top: cardHeight * (218 / 617),
                              width: cardWidth * (135 / 304),
                              height: cardHeight * (48 / 617),
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(builder: (_) => const TopUpScreen()),
                              ),
                            ),

                            // 4. PULSA & KUOTA (Telkomsel)
                            _buildTapBox(
                              left: cardWidth * (15 / 304),
                              top: cardHeight * (293 / 617),
                              width: cardWidth * (135 / 304),
                              height: cardHeight * (45 / 617),
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(builder: (_) => const PpobScreen(initialTab: 0)),
                              ),
                            ),

                            // 5. TOP UP GAME
                            // Mobile Legends Bang Bang (Langsung ke Pilih Diamonds MLBB)
                            _buildTapBox(
                              left: cardWidth * (15 / 304),
                              top: cardHeight * (378 / 617),
                              width: cardWidth * (135 / 304),
                              height: cardHeight * (50 / 617),
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const TopUpGameDiamondsScreen(
                                    gameName: 'Mobile Legends:',
                                    gameSubtitle: 'Bang Bang',
                                    gameIcon: 'assets/images/game_mlbb.png',
                                  ),
                                ),
                              ),
                            ),

                            // Free Fire (Langsung ke Pilih Diamonds FF)
                            _buildTapBox(
                              left: cardWidth * (155 / 304),
                              top: cardHeight * (378 / 617),
                              width: cardWidth * (135 / 304),
                              height: cardHeight * (50 / 617),
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const TopUpGameDiamondsScreen(
                                    gameName: 'Free Fire',
                                    gameSubtitle: 'Garena',
                                    gameIcon: 'assets/images/game_ff.png',
                                  ),
                                ),
                              ),
                            ),

                            // PUBG Mobile (Langsung ke Pilih UC PUBG)
                            _buildTapBox(
                              left: cardWidth * (15 / 304),
                              top: cardHeight * (431 / 617),
                              width: cardWidth * (135 / 304),
                              height: cardHeight * (50 / 617),
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const TopUpGameDiamondsScreen(
                                    gameName: 'PUBG Mobile',
                                    gameSubtitle: 'Level Infinite',
                                    gameIcon: 'assets/images/game_pubg.png',
                                  ),
                                ),
                              ),
                            ),

                            // Roblox (Langsung ke Pilih Robux Roblox)
                            _buildTapBox(
                              left: cardWidth * (155 / 304),
                              top: cardHeight * (431 / 617),
                              width: cardWidth * (135 / 304),
                              height: cardHeight * (50 / 617),
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const TopUpGameDiamondsScreen(
                                    gameName: 'Roblox',
                                    gameSubtitle: 'Roblox Corporation',
                                    gameIcon: 'assets/images/game_roblox.png',
                                  ),
                                ),
                              ),
                            ),

                            // 6. BELI EMAS & LISTRIK
                            // EMAS (Langsung ke Investasi Emas)
                            _buildTapBox(
                              left: cardWidth * (35 / 304),
                              top: cardHeight * (518 / 617),
                              width: cardWidth * (110 / 304),
                              height: cardHeight * (55 / 617),
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(builder: (_) => const GoldScreen()),
                              ),
                            ),

                            // LISTRIK (Langsung ke Layanan Listrik PLN)
                            _buildTapBox(
                              left: cardWidth * (155 / 304),
                              top: cardHeight * (518 / 617),
                              width: cardWidth * (110 / 304),
                              height: cardHeight * (55 / 617),
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(builder: (_) => const PpobScreen(initialTab: 1)),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),

            // Jarak putih bawah
            SizedBox(height: 40 * scale),
          ],
        ),
      ),
    );
  }

  Widget _buildTapBox({
    required double left,
    required double top,
    required double width,
    required double height,
    required VoidCallback onTap,
  }) {
    return Positioned(
      left: left,
      top: top,
      width: width,
      height: height,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
      ),
    );
  }
}
