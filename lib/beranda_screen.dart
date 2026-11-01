import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'ewallet_screen.dart';
import 'transfer_screen.dart';
import 'topup_screen.dart';
import 'ppob_screen.dart';
import 'gold_screen.dart';
import 'game_screen.dart';
import 'koin_screen.dart';
import 'history_screen.dart';
import 'user_profile_tab_screen.dart';
import 'notification_screen.dart';
import 'daftar_menu_screen.dart';

class BerandaScreen extends StatefulWidget {
  const BerandaScreen({super.key});

  @override
  State<BerandaScreen> createState() => _BerandaScreenState();
}

class _BerandaScreenState extends State<BerandaScreen> {
  int _currentTabIndex = 0;
  bool _isBalanceVisible = true;

  final List<String> _bannerAssets = [
    'assets/images/banner_promo_yellow.png',
    'assets/images/banner_qris_blue.png',
    'assets/images/banner_warning_red.png',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: _buildCurrentTab(),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildCurrentTab() {
    switch (_currentTabIndex) {
      case 0:
        return _buildHomeTab();
      case 1:
        return const HistoryScreen();
      case 2:
        return const NotificationScreen();
      case 3:
        return const UserProfileTabScreen();
      default:
        return _buildHomeTab();
    }
  }

  Widget _buildHomeTab() {
    final screenWidth = MediaQuery.of(context).size.width;
    final scale = screenWidth / 373.0;

    // Padding horizontal kartu menu tengah (24 * scale)
    final cardPadding = 24.0 * scale;

    // Posisi User Pill: digeser ke kanan agar sejajar lurus dengan tombol Transfer (36 * scale)
    final pillLeftMargin = 36.0 * scale;

    // Posisi Total Saldo & Rp: rata kanan sedikit lebih masuk dibanding ikon kontak (44 * scale)
    final saldoLeftMargin = 44.0 * scale;

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: [
          // ==================== 1. HEADER UNGU FIGMA ====================
          Container(
            width: double.infinity,
            padding: EdgeInsets.fromLTRB(0, 42, cardPadding, 22 * scale),
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/beranda_header_bubble_hd.png'),
                fit: BoxFit.cover,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Baris 1: Logo Xema di Pojok Kanan Atas
                Align(
                  alignment: Alignment.topRight,
                  child: Image.asset(
                    'assets/images/xema_header_logo_flawless.png',
                    height: 38 * scale,
                    fit: BoxFit.contain,
                  ),
                ),

                SizedBox(height: 8 * scale),

                // Baris 2: Pill Pengguna (Digeser ke kanan, sejajar dengan elemen Transfer)
                Padding(
                  padding: EdgeInsets.only(left: pillLeftMargin),
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 10 * scale,
                      vertical: 6 * scale,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.22),
                      borderRadius: BorderRadius.circular(30 * scale),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 38 * scale,
                          height: 38 * scale,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                          ),
                          child: Icon(
                            Icons.person,
                            color: const Color(0xFFCA31FF),
                            size: 26 * scale,
                          ),
                        ),
                        SizedBox(width: 8 * scale),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'LISA ARUNIA',
                              style: GoogleFonts.poppins(
                                fontSize: 13.5 * scale,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                                letterSpacing: 0.3,
                              ),
                            ),
                            Text(
                              '0851 2343 5656',
                              style: GoogleFonts.robotoSlab(
                                fontSize: 11.5 * scale,
                                fontWeight: FontWeight.w500,
                                color: Colors.white.withValues(alpha: 0.95),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(width: 8 * scale),
                      ],
                    ),
                  ),
                ),

                SizedBox(height: 16 * scale),

                // Baris 3: Total Saldo & Ikon Mata (Rata ke kanan sedikit lebih dibanding profil)
                Padding(
                  padding: EdgeInsets.only(left: saldoLeftMargin),
                  child: Row(
                    children: [
                      Text(
                        'Total Saldo',
                        style: GoogleFonts.poppins(
                          fontSize: 12.5 * scale,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(width: 8 * scale),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _isBalanceVisible = !_isBalanceVisible;
                          });
                        },
                        child: Icon(
                          _isBalanceVisible ? Icons.visibility : Icons.visibility_off,
                          color: Colors.white,
                          size: 19 * scale,
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 6 * scale),

                // Baris 4: Nominal Saldo (Rata ke kanan sedikit lebih dibanding profil)
                Padding(
                  padding: EdgeInsets.only(left: saldoLeftMargin),
                  child: Row(
                    children: [
                      Text(
                        'Rp  ',
                        style: GoogleFonts.poppins(
                          fontSize: 15.5 * scale,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 14 * scale,
                          vertical: 5 * scale,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.25),
                          borderRadius: BorderRadius.circular(16 * scale),
                        ),
                        child: Text(
                          _isBalanceVisible ? '76.565.000,00' : '••••••••',
                          style: GoogleFonts.poppins(
                            fontSize: 19 * scale,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                            letterSpacing: _isBalanceVisible ? 0.5 : 2.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Jarak presisi dari Header ke Menu Card
          SizedBox(height: 20 * scale),

          // ==================== 2. KARTU GRID MENU ASLI 1:1 FIGMA ====================
          Padding(
            padding: EdgeInsets.symmetric(horizontal: cardPadding),
            child: SizedBox(
              width: double.infinity,
              child: AspectRatio(
                aspectRatio: 324 / 200,
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: Image.asset(
                        'assets/images/figma_artboard_menu.png',
                        fit: BoxFit.fill,
                      ),
                    ),
                    // Tap targets transparan untuk 8 tombol menu
                    Column(
                      children: [
                        // Baris 1: TRANSFER, ISI SALDO, PULSA & KUOTA, PLN
                        Expanded(
                          child: Row(
                            children: [
                              Expanded(
                                child: GestureDetector(
                                  behavior: HitTestBehavior.opaque,
                                  onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (_) => const TransferScreen()),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: GestureDetector(
                                  behavior: HitTestBehavior.opaque,
                                  onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (_) => const TopUpScreen()),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: GestureDetector(
                                  behavior: HitTestBehavior.opaque,
                                  onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (_) => const PpobScreen(initialTab: 0)),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: GestureDetector(
                                  behavior: HitTestBehavior.opaque,
                                  onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (_) => const PpobScreen(initialTab: 1)),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Baris 2: E-WALLET, INVESTASI EMAS, TOP UP GAME, MENU
                        Expanded(
                          child: Row(
                            children: [
                              Expanded(
                                child: GestureDetector(
                                  behavior: HitTestBehavior.opaque,
                                  onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (_) => const EwalletScreen()),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: GestureDetector(
                                  behavior: HitTestBehavior.opaque,
                                  onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (_) => const GoldScreen()),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: GestureDetector(
                                  behavior: HitTestBehavior.opaque,
                                  onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (_) => const GameScreen()),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: GestureDetector(
                                  behavior: HitTestBehavior.opaque,
                                  onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (_) => const DaftarMenuScreen()),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Jarak presisi dari Menu Card ke Promo Banner
          SizedBox(height: 22 * scale),

          // ==================== 3. BANNER PROMO (SEJAJAR & BESAR SESUAI FIGMA) ====================
          SizedBox(
            height: 105 * scale,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: cardPadding),
              itemCount: _bannerAssets.length,
              separatorBuilder: (context, index) => SizedBox(width: 10 * scale),
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    if (index == 0) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const PpobScreen(initialTab: 0)),
                      );
                    }
                  },
                  child: SizedBox(
                    width: 270 * scale,
                    height: 105 * scale,
                    child: Image.asset(
                      _bannerAssets[index],
                      fit: BoxFit.fill,
                    ),
                  ),
                );
              },
            ),
          ),

          // Jarak presisi dari Promo Banner ke Poin Card
          SizedBox(height: 26 * scale),

          // ==================== 4. KARTU XEMA POIN ASLI FIGMA ====================
          Padding(
            padding: EdgeInsets.symmetric(horizontal: cardPadding),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const KoinScreen()),
                );
              },
              child: SizedBox(
                width: double.infinity,
                child: AspectRatio(
                  aspectRatio: 340 / 135,
                  child: Image.asset(
                    'assets/images/figma_poin_card_exact.png',
                    fit: BoxFit.fill,
                  ),
                ),
              ),
            ),
          ),

          // Jarak presisi ke bawah sebelum Bottom Navigation
          SizedBox(height: 32 * scale),
        ],
      ),
    );
  }

  // ==================== 5. BOTTOM NAVIGATION BAR ASLI FIGMA ====================
  Widget _buildBottomNav() {
    final screenWidth = MediaQuery.of(context).size.width;
    final scale = screenWidth / 373.0;

    return Container(
      color: const Color(0xFFF3D8FF),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 64 * scale,
          child: Row(
            children: [
              _buildFigmaTabItem(
                index: 0,
                assetPath: 'assets/images/nav_btn_home_pure.png',
              ),
              _buildFigmaTabItem(
                index: 1,
                assetPath: 'assets/images/nav_btn_history_pure.png',
              ),
              _buildFigmaTabItem(
                index: 2,
                assetPath: 'assets/images/nav_btn_inbox_pure.png',
              ),
              _buildFigmaTabItem(
                index: 3,
                assetPath: 'assets/images/nav_btn_user_pure.png',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFigmaTabItem({
    required int index,
    required String assetPath,
  }) {
    final isSelected = _currentTabIndex == index;

    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          setState(() {
            _currentTabIndex = index;
          });
        },
        child: Opacity(
          opacity: isSelected ? 1.0 : 0.65,
          child: Center(
            child: Image.asset(
              assetPath,
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
    );
  }
}
