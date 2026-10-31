import 'package:flutter/material.dart';
import 'transfer_screen.dart';
import 'topup_screen.dart';
import 'ppob_screen.dart';
import 'game_screen.dart';
import 'gold_screen.dart';
import 'ewallet_screen.dart';
import 'beranda_screen.dart';

class DaftarMenuScreen extends StatelessWidget {
  const DaftarMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final scale = screenWidth / 373.0;
    
    // Tinggi Header Ungu Presisi Figma (rasio 120 / 577)
    final headerHeight = screenWidth * (120.0 / 577.0);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            // ==================== 1. HEADER UNGU ASLI FIGMA ====================
            SizedBox(
              width: screenWidth,
              height: headerHeight,
              child: Stack(
                children: [
                  // Latar Belakang Header Asli Figma (Motif Bubble + Logo XEMA)
                  Positioned.fill(
                    child: Image.asset(
                      'assets/images/figma_daftar_menu_header_clean_bg.png',
                      fit: BoxFit.fill,
                    ),
                  ),

                  // ==================== TOMBOL KEMBALI (BACK ARROW) ====================
                  // Area sentuh luas & presisi di pojok kiri atas
                  Positioned(
                    left: 2 * scale,
                    top: (headerHeight / 2) - (32 * scale),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(32 * scale),
                        splashColor: Colors.white.withValues(alpha: 0.3),
                        highlightColor: Colors.white.withValues(alpha: 0.15),
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
                        child: Container(
                          width: 68 * scale,
                          height: 64 * scale,
                          alignment: Alignment.center,
                          child: Image.asset(
                            'assets/images/figma_daftar_menu_arrow_icon.png',
                            width: 26 * scale,
                            height: 24 * scale,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // ==================== JARAK PUTIH PRESISI FIGMA ====================
            // Gap latar putih asli Figma antara bawah header ungu dan atas kartu menu
            SizedBox(height: 18 * scale),

            // ==================== 2. KARTU MENU LAVENDER 1:1 FIGMA ====================
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20 * scale),
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
                      final cardHeight = cardWidth * (634.0 / 304.0);

                      return SizedBox(
                        width: cardWidth,
                        height: cardHeight,
                        child: Stack(
                          children: [
                            // Visual Kartu Asli Figma
                            Positioned.fill(
                              child: Image.asset(
                                'assets/images/figma_daftar_menu_card_rounded.png',
                                fit: BoxFit.fill,
                              ),
                            ),

                            // ==================== TAP TARGETS FITUR ====================
                            // 1. TRANSFER BANK (Ikon Bank ungu)
                            _buildTapBox(
                              left: cardWidth * (10 / 304),
                              top: cardHeight * (35 / 634),
                              width: cardWidth * (75 / 304),
                              height: cardHeight * (75 / 634),
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(builder: (_) => const TransferScreen()),
                              ),
                            ),

                            // SeaBank
                            _buildTapBox(
                              left: cardWidth * (95 / 304),
                              top: cardHeight * (32 / 634),
                              width: cardWidth * (95 / 304),
                              height: cardHeight * (42 / 634),
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(builder: (_) => const TransferScreen()),
                              ),
                            ),

                            // Bank BRI
                            _buildTapBox(
                              left: cardWidth * (195 / 304),
                              top: cardHeight * (32 / 634),
                              width: cardWidth * (95 / 304),
                              height: cardHeight * (42 / 634),
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(builder: (_) => const TransferScreen()),
                              ),
                            ),

                            // BCA
                            _buildTapBox(
                              left: cardWidth * (95 / 304),
                              top: cardHeight * (76 / 634),
                              width: cardWidth * (95 / 304),
                              height: cardHeight * (42 / 634),
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(builder: (_) => const TransferScreen()),
                              ),
                            ),

                            // BSI
                            _buildTapBox(
                              left: cardWidth * (195 / 304),
                              top: cardHeight * (76 / 634),
                              width: cardWidth * (95 / 304),
                              height: cardHeight * (42 / 634),
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(builder: (_) => const TransferScreen()),
                              ),
                            ),

                            // 2. TRANSFER E-WALLET (Ikon Wallet ungu)
                            _buildTapBox(
                              left: cardWidth * (10 / 304),
                              top: cardHeight * (120 / 634),
                              width: cardWidth * (75 / 304),
                              height: cardHeight * (80 / 634),
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(builder: (_) => const EwalletScreen()),
                              ),
                            ),

                            // DANA
                            _buildTapBox(
                              left: cardWidth * (95 / 304),
                              top: cardHeight * (122 / 634),
                              width: cardWidth * (95 / 304),
                              height: cardHeight * (40 / 634),
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(builder: (_) => const EwalletScreen()),
                              ),
                            ),

                            // xema
                            _buildTapBox(
                              left: cardWidth * (195 / 304),
                              top: cardHeight * (122 / 634),
                              width: cardWidth * (95 / 304),
                              height: cardHeight * (40 / 634),
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(builder: (_) => const TransferScreen()),
                              ),
                            ),

                            // GoPay
                            _buildTapBox(
                              left: cardWidth * (95 / 304),
                              top: cardHeight * (164 / 634),
                              width: cardWidth * (95 / 304),
                              height: cardHeight * (40 / 634),
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(builder: (_) => const EwalletScreen()),
                              ),
                            ),

                            // ShopeePay
                            _buildTapBox(
                              left: cardWidth * (195 / 304),
                              top: cardHeight * (164 / 634),
                              width: cardWidth * (95 / 304),
                              height: cardHeight * (40 / 634),
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(builder: (_) => const EwalletScreen()),
                              ),
                            ),

                            // 3. ISI SALDO (Indomaret & Alfamart)
                            _buildTapBox(
                              left: cardWidth * (15 / 304),
                              top: cardHeight * (235 / 634),
                              width: cardWidth * (135 / 304),
                              height: cardHeight * (48 / 634),
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(builder: (_) => const TopUpScreen()),
                              ),
                            ),

                            _buildTapBox(
                              left: cardWidth * (155 / 304),
                              top: cardHeight * (235 / 634),
                              width: cardWidth * (135 / 304),
                              height: cardHeight * (48 / 634),
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(builder: (_) => const TopUpScreen()),
                              ),
                            ),

                            // 4. PULSA & KUOTA (Telkomsel)
                            _buildTapBox(
                              left: cardWidth * (15 / 304),
                              top: cardHeight * (310 / 634),
                              width: cardWidth * (135 / 304),
                              height: cardHeight * (45 / 634),
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(builder: (_) => const PpobScreen(initialTab: 0)),
                              ),
                            ),

                            // 5. TOP UP GAME
                            // Mobile Legends Bang Bang
                            _buildTapBox(
                              left: cardWidth * (15 / 304),
                              top: cardHeight * (395 / 634),
                              width: cardWidth * (135 / 304),
                              height: cardHeight * (50 / 634),
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(builder: (_) => const GameScreen()),
                              ),
                            ),

                            // Free Fire
                            _buildTapBox(
                              left: cardWidth * (155 / 304),
                              top: cardHeight * (395 / 634),
                              width: cardWidth * (135 / 304),
                              height: cardHeight * (50 / 634),
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(builder: (_) => const GameScreen()),
                              ),
                            ),

                            // PUBG Mobile
                            _buildTapBox(
                              left: cardWidth * (15 / 304),
                              top: cardHeight * (448 / 634),
                              width: cardWidth * (135 / 304),
                              height: cardHeight * (50 / 634),
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(builder: (_) => const GameScreen()),
                              ),
                            ),

                            // Roblox
                            _buildTapBox(
                              left: cardWidth * (155 / 304),
                              top: cardHeight * (448 / 634),
                              width: cardWidth * (135 / 304),
                              height: cardHeight * (50 / 634),
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(builder: (_) => const GameScreen()),
                              ),
                            ),

                            // 6. BELI EMAS & LISTRIK
                            // EMAS
                            _buildTapBox(
                              left: cardWidth * (35 / 304),
                              top: cardHeight * (535 / 634),
                              width: cardWidth * (110 / 304),
                              height: cardHeight * (55 / 634),
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(builder: (_) => const GoldScreen()),
                              ),
                            ),

                            // LISTRIK
                            _buildTapBox(
                              left: cardWidth * (155 / 304),
                              top: cardHeight * (535 / 634),
                              width: cardWidth * (110 / 304),
                              height: cardHeight * (55 / 634),
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

            // Jarak putih presisi di bagian bawah sesuai Figma
            SizedBox(height: 42 * scale),
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
